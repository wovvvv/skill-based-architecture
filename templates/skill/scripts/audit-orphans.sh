#!/usr/bin/env bash
# Surface content-tier + workflow files with zero inbound links.
# Single-root compatibility:
#   bash scripts/audit-orphans.sh
# Two-root usage (run once from each local root):
#   bash scripts/audit-orphans.sh --namespace skill --routing /path/to/routing.yaml
#   bash /path/to/scripts/audit-orphans.sh --namespace code --routing /path/to/routing.yaml
# `--namespace` prevents `code:gotchas/x.md` from making a same-path
# `skill:gotchas/x.md` look reachable (and vice versa). Local unprefixed links
# still count inside the root being audited.
set -euo pipefail
ROOT="$PWD"
ROUTING="$ROOT/routing.yaml"
NAMESPACE=""

usage() {
  echo "Usage: bash audit-orphans.sh [--namespace skill|code] [--routing <path>]" >&2
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
if [[ "$NAMESPACE" != "single" && ! -f "$ROUTING" ]]; then
  echo "audit-orphans: two-root audit requires --routing <path>" >&2
  exit 2
fi

TIER_DIRS=(rules references architecture gotchas conventions)
AUDIT_DIRS=("${TIER_DIRS[@]}" workflows)

python3 - "$ROOT" "$ROUTING" "$NAMESPACE" "${AUDIT_DIRS[@]}" <<'PY'
from __future__ import annotations

import re
import sys
from pathlib import Path

root = Path(sys.argv[1]).resolve()
routing = Path(sys.argv[2]).resolve()
namespace = sys.argv[3]
audit_dirs = sys.argv[4:]
domain_routing = routing.parent / "domain-routing.yaml"
path_token_re = re.compile(
    r"(?:(skill|code):)?"
    r"((?:architecture|conventions|gotchas|rules|references|workflows)/"
    r"[A-Za-z0-9._/-]+\.md)"
)


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


def read(path: Path) -> str:
    return strip_nonlive(path.read_text(encoding="utf-8", errors="replace"))


def local_normalized(path: Path) -> str:
    content = read(path)
    if namespace == "single":
        return path_token_re.sub(lambda match: "" if match.group(1) else match.group(0), content)
    opposite = "code" if namespace == "skill" else "skill"
    return path_token_re.sub(
        lambda match: "" if match.group(1) == opposite else match.group(0),
        content,
    )


def markdown_sources(base: Path) -> list[Path]:
    sources: list[Path] = []
    for directory in audit_dirs:
        owner = base / directory
        if owner.is_dir():
            sources.extend(owner.rglob("*.md"))
    sources.extend(path for path in base.glob("*.md") if path.is_file())
    return sorted(set(sources))


local_sources = markdown_sources(root)
repo_root = root.parent.parent
if (repo_root / "AGENTS.md").is_file() or (repo_root / "CLAUDE.md").is_file():
    for name in ("AGENTS.md", "CLAUDE.md", "CODEX.md", "GEMINI.md"):
        candidate = repo_root / name
        if candidate.is_file():
            local_sources.append(candidate)

normalized_sources = [(path.resolve(), local_normalized(path)) for path in local_sources]
cross_sources: list[str] = []
if namespace == "code":
    for path in markdown_sources(routing.parent):
        content = read(path)
        refs = [
            match.group(0)
            for match in path_token_re.finditer(content)
            if match.group(1) == "code"
        ]
        if refs:
            cross_sources.append("\n".join(refs))

routing_text = "\n".join(
    "\n".join(
        line for line in path.read_text(encoding="utf-8", errors="replace").splitlines()
        if not line.lstrip().startswith("#")
    )
    for path in (routing, domain_routing)
    if path.is_file()
)

targets: list[tuple[Path, str, str]] = []
for directory in audit_dirs:
    owner = root / directory
    if not owner.is_dir():
        continue
    for path in owner.rglob("*.md"):
        if path.name in {"README.md", "index.md"}:
            continue
        relative = path.relative_to(root).as_posix()
        match = path.name if directory == "workflows" else relative
        targets.append((path.resolve(), relative, match))

orphans: list[str] = []
for absolute, relative, match in sorted(targets, key=lambda item: item[1]):
    routing_token = relative if namespace == "single" else f"{namespace}:{relative}"
    inbound = routing_token in routing_text
    if not inbound:
        inbound = any(match in content for origin, content in normalized_sources if origin != absolute)
    if not inbound and namespace == "code":
        inbound = any(f"code:{relative}" in content for content in cross_sources)
    if not inbound:
        orphans.append(relative)

print(f"Orphan scan — namespace={namespace}, root={root}")
print("=" * 60)
for relative in orphans:
    print(f"ORPHAN  {relative}")
print()
print(f"Summary: {len(orphans)} orphan(s) / {len(targets)} file(s)")
raise SystemExit(1 if orphans else 0)
PY
