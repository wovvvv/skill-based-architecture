#!/usr/bin/env bash
# Verify that active-tier and workflow files are reachable from a task route.
#
# Single-root compatibility:
#   bash scripts/route-reachability.sh
# Two-root usage (run once from each local root):
#   bash scripts/route-reachability.sh --namespace skill --routing /path/to/routing.yaml
#   bash /path/to/scripts/route-reachability.sh --namespace code --routing /path/to/routing.yaml

set -uo pipefail

ROOT="$PWD"
ROUTING="$ROOT/routing.yaml"
NAMESPACE=""

usage() {
  echo "Usage: bash route-reachability.sh [--namespace skill|code] [--routing <path>]" >&2
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --namespace)
      [[ $# -ge 2 ]] || { usage; exit 2; }
      NAMESPACE="$2"; shift 2 ;;
    --routing)
      [[ $# -ge 2 ]] || { usage; exit 2; }
      ROUTING="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) usage; exit 2 ;;
  esac
done
DOMAIN_ROUTING="$(dirname "$ROUTING")/domain-routing.yaml"

if [[ -z "$NAMESPACE" ]]; then
  if [[ -f "$ROUTING" ]] && grep -q '^path_resolution:' "$ROUTING"; then
    NAMESPACE="skill"
  else
    NAMESPACE="single"
  fi
fi
case "$NAMESPACE" in single|skill|code) ;; *) usage; exit 2 ;; esac

if [[ ! -f "$ROUTING" ]]; then
  if [[ "$NAMESPACE" == "single" ]]; then
    echo "route-reachability: no routing.yaml at $ROOT — nothing to check"
    exit 0
  fi
  echo "route-reachability: two-root audit requires --routing <path>" >&2
  exit 2
fi

# Workflows are active procedures, not lookup material: a workflow referenced
# only by another dead workflow is not route-reachable and must fail here.
ACTIVE_DIRS=(architecture conventions gotchas rules workflows references)

python3 - "$ROOT" "$ROUTING" "$NAMESPACE" "${ACTIVE_DIRS[@]}" <<'PY'
from __future__ import annotations

import re
import sys
from collections import deque
from pathlib import Path

root = Path(sys.argv[1]).resolve()
routing = Path(sys.argv[2]).resolve()
namespace = sys.argv[3]
active_dirs = sys.argv[4:]
domain_routing = routing.parent / "domain-routing.yaml"
token_re = re.compile(
    r"(?:(skill|code):)?"
    r"((?:architecture|conventions|gotchas|rules|references|workflows)/"
    r"[A-Za-z0-9._/-]+\.md)"
)
invalid_references: list[str] = []


def strip_nonlive(text: str) -> str:
    output: list[str] = []
    marker: str | None = None
    for line in text.splitlines():
        match = re.match(r"^[ \t]*(```+|~~~+)", line)
        if match:
            token = match.group(1)[0]
            if marker is None:
                marker = token
            elif marker == token:
                marker = None
            continue
        if marker is None:
            output.append(line)
    return re.sub(r"<!--.*?-->", "", "\n".join(output), flags=re.S)


def strip_yaml_comments(text: str) -> str:
    output: list[str] = []
    for line in text.splitlines():
        kept: list[str] = []
        quote: str | None = None
        for char in line:
            if char in ("'", '"'):
                if quote is None:
                    quote = char
                elif quote == char:
                    quote = None
                kept.append(char)
            elif char == "#" and quote is None:
                break
            else:
                kept.append(char)
        output.append("".join(kept))
    return "\n".join(output)


def normalize_relative(relative: str, base: Path, source: str) -> str | None:
    candidate = (base / relative).resolve()
    try:
        return candidate.relative_to(base.resolve()).as_posix()
    except ValueError:
        invalid_references.append(f"{source} -> {relative} (path escapes {base})")
        return None


def tokens(text: str, wanted: str, mode: str, base: Path, source: str) -> set[str]:
    found: set[str] = set()
    for match in token_re.finditer(text):
        prefix, relative = match.groups()
        selected = False
        if wanted == "single":
            if prefix is None:
                selected = True
        elif mode in ("routing", "cross"):
            if prefix == wanted:
                selected = True
        elif prefix is None or prefix == wanted:
            selected = True
        if selected:
            normalized = normalize_relative(relative, base, source)
            if normalized is not None:
                found.add(normalized)
    return found


def read(path: Path) -> str:
    return strip_nonlive(path.read_text(encoding="utf-8", errors="replace"))


def workflow_siblings(base: Path, source_relative: str, content: str) -> set[str]:
    if not source_relative.startswith("workflows/"):
        return set()
    found: set[str] = set()
    for name in re.findall(r"[A-Za-z0-9._-]+\.md", content):
        candidate_relative = normalize_relative(
            f"workflows/{name}", base, source_relative
        )
        if candidate_relative is None:
            continue
        candidate = base / candidate_relative
        if candidate.is_file():
            found.add(candidate_relative)
    return found


def traverse(
    base: Path,
    seeds: set[str],
    wanted: str,
    cross_code_base: Path | None = None,
) -> tuple[set[str], set[str]]:
    reachable = set(seeds)
    cross_code: set[str] = set()
    queue = deque(sorted(seeds))
    visited: set[str] = set()
    while queue:
        relative = queue.popleft()
        if relative in visited:
            continue
        visited.add(relative)
        path = base / relative
        if not path.is_file():
            continue
        content = read(path)
        local = tokens(content, wanted, "local", base, relative)
        local.update(workflow_siblings(base, relative, content))
        if wanted == "skill" and cross_code_base is not None:
            cross_code.update(tokens(content, "code", "cross", cross_code_base, relative))
        for item in sorted(local - reachable):
            reachable.add(item)
            queue.append(item)
    return reachable, cross_code


routing_text = strip_yaml_comments("\n".join(
    path.read_text(encoding="utf-8", errors="replace")
    for path in (routing, domain_routing)
    if path.is_file()
))

seeds = tokens(routing_text, namespace, "routing", root, routing.as_posix())
if namespace == "code":
    skill_root = routing.parent.resolve()
    skill_seeds = tokens(routing_text, "skill", "routing", skill_root, routing.as_posix())
    if (skill_root / "SKILL.md").is_file():
        skill_seeds.add("SKILL.md")
    _, code_from_skill = traverse(skill_root, skill_seeds, "skill", root)
    seeds.update(code_from_skill)
elif (root / "SKILL.md").is_file():
    seeds.add("SKILL.md")

reachable, _ = traverse(root, seeds, namespace)
active_files: list[Path] = []
for directory in active_dirs:
    owner = root / directory
    if owner.is_dir():
        active_files.extend(path for path in owner.rglob("*.md") if path.name != "README.md")

unreachable = [
    path.relative_to(root).as_posix()
    for path in sorted(set(active_files))
    if path.relative_to(root).as_posix() not in reachable
]

print(f"Route-reachability — namespace={namespace}, root={root}")
print("=" * 60)
for relative in unreachable:
    print(f"UNREACHED  {relative}")
for invalid in sorted(set(invalid_references)):
    print(f"INVALID    {invalid}")
print()
print(f"Summary: {len(unreachable)} unreachable / {len(set(active_files))} active file(s)")
raise SystemExit(1 if unreachable or invalid_references else 0)
PY
