#!/usr/bin/env bash
# check-version-conformance — verify a skill matches its conformance manifest.
#
# Usage:
#   bash check-version-conformance.sh <skill-root> [--conformance <path>]
#
# The selected conformance.yaml lists required sections / phrases / files for
# the owners materialized by that result. Each rule applies to a path resolved
# relative to <skill-root>; the checker never infers a universal file inventory.
#
# Default conformance.yaml path: <skill-root>/conformance.yaml
#
# Useful as part of update-upstream workflows when the selected manifest fits
# the downstream's actual owners. Complementary to
# check-upstream-changes.sh (changelog enforcement) and smoke-test.sh
# (structural budgets / routing) — none of those validates content presence.
#
# Exit codes: 0 pass, 1 fail, 2 usage error.

set -euo pipefail

SKILL_ROOT="${1:-}"
CONFORMANCE_PATH=""

if [[ -z "$SKILL_ROOT" || "$SKILL_ROOT" == "-h" || "$SKILL_ROOT" == "--help" ]]; then
  sed -n '2,18p' "$0" | sed 's/^# \{0,1\}//'
  [[ -z "$SKILL_ROOT" ]] && exit 2 || exit 0
fi
shift

while [[ $# -gt 0 ]]; do
  case "$1" in
    --conformance)
      [[ $# -ge 2 ]] || { echo "Missing value for --conformance" >&2; exit 2; }
      CONFORMANCE_PATH="$2"
      shift 2
      ;;
    *)
      echo "Unknown arg: $1" >&2
      exit 2
      ;;
  esac
done

[[ -d "$SKILL_ROOT" ]] || { echo "Skill root not found: $SKILL_ROOT" >&2; exit 2; }

if [[ -z "$CONFORMANCE_PATH" ]]; then
  CONFORMANCE_PATH="$SKILL_ROOT/conformance.yaml"
fi
[[ -f "$CONFORMANCE_PATH" ]] || { echo "conformance.yaml not found: $CONFORMANCE_PATH" >&2; exit 2; }

PARSED_FILE="$(mktemp)"
trap 'rm -f "$PARSED_FILE"' EXIT

if ! python3 - "$CONFORMANCE_PATH" "$SKILL_ROOT" > "$PARSED_FILE" <<'PY'
from __future__ import annotations

import sys
import json
from pathlib import Path


def decode_scalar(raw: str, context: str, *, allow_empty: bool = False) -> str:
    """Decode the YAML scalar subset used by fitted conformance manifests."""
    value = raw.strip()
    if value.startswith("'"):
        decoded: list[str] = []
        index = 1
        while index < len(value):
            if value[index] != "'":
                decoded.append(value[index])
                index += 1
                continue
            if index + 1 < len(value) and value[index + 1] == "'":
                decoded.append("'")
                index += 2
                continue
            tail = value[index + 1 :].strip()
            if tail and not tail.startswith("#"):
                raise ValueError(f"{context} has trailing content after a quoted scalar")
            value = "".join(decoded)
            break
        else:
            raise ValueError(f"{context} has an unterminated single-quoted scalar")
    elif value.startswith('"'):
        escaped = False
        closing = None
        for index in range(1, len(value)):
            char = value[index]
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == '"':
                closing = index
                break
        if closing is None:
            raise ValueError(f"{context} has an unterminated double-quoted scalar")
        tail = value[closing + 1 :].strip()
        if tail and not tail.startswith("#"):
            raise ValueError(f"{context} has trailing content after a quoted scalar")
        try:
            value = json.loads(value[: closing + 1])
        except json.JSONDecodeError as exc:
            raise ValueError(
                f"{context} uses an unsupported or invalid double-quoted escape"
            ) from exc
    else:
        for index, char in enumerate(value):
            if char == "#" and (index == 0 or value[index - 1].isspace()):
                value = value[:index].rstrip()
                break
    if not allow_empty and not value:
        raise ValueError(f"{context} must not be empty")
    if any(char in value for char in ("\t", "\r", "\n")):
        raise ValueError(f"{context} contains an unsupported control character")
    return value


def parse(path: Path) -> list[tuple[str, str, str]]:
    lines: list[tuple[int, str, int]] = []
    for line_number, raw in enumerate(
        path.read_text(encoding="utf-8").splitlines(), start=1
    ):
        if not raw.strip() or raw.lstrip().startswith("#"):
            continue
        lines.append((len(raw) - len(raw.lstrip()), raw.strip(), line_number))

    records: list[tuple[str, str, str]] = []
    section: str | None = None
    item_indent: int | None = None
    current: dict[str, object] | None = None
    active_group: dict[str, object] | None = None

    phrase_kinds = {
        "must_contain": "CONTAINS",
        "must_contain_in_order": "ORDERED",
        "must_not_contain": "NOT_CONTAINS",
    }

    def flush_group() -> None:
        nonlocal active_group
        if active_group is None:
            return
        phrases = active_group["phrases"]
        if not isinstance(phrases, list) or not phrases:
            raise ValueError(
                f"{active_group['key']} must be a non-empty block sequence "
                f"(line {active_group['line']})"
            )
        active_group = None

    def flush_item() -> None:
        nonlocal current, item_indent
        flush_group()
        if current is None:
            return
        owner = current["owner"]
        if not isinstance(owner, str) or not owner:
            if section == "required_files":
                raise ValueError(
                    "required_files items must be mappings such as '- path: SKILL.md'; "
                    f"invalid item at line {current['line']}"
                )
            raise ValueError(
                f"required_sections item at line {current['line']} requires file or path"
            )
        if section == "required_files":
            records.append(("EXISTS", owner, ""))
        else:
            groups = current["groups"]
            if not isinstance(groups, list) or not groups:
                raise ValueError(
                    f"required_sections item for {owner} must declare a content assertion"
                )
            for group in groups:
                if not isinstance(group, dict):
                    raise ValueError(f"invalid content assertion for {owner}")
                kind = group["kind"]
                phrases = group["phrases"]
                if kind == "ORDERED":
                    records.append(("ORDER_START", owner, ""))
                for phrase in phrases:
                    records.append((str(kind), owner, str(phrase)))
        current = None
        item_indent = None

    def process_key(key: str, raw_value: str, indent: int, line_number: int) -> None:
        nonlocal active_group
        if current is None:
            raise ValueError(f"mapping key outside a list item at line {line_number}")
        if key in ("file", "path"):
            if current["owner"] is not None:
                raise ValueError(
                    f"duplicate file/path owner in item at line {current['line']}"
                )
            current["owner"] = decode_scalar(
                raw_value, f"{key} at line {line_number}"
            )
            return
        if key == "reason":
            decode_scalar(raw_value, f"reason at line {line_number}")
            return
        if key in phrase_kinds:
            if key in current["keys"]:
                raise ValueError(
                    f"duplicate {key} in item at line {current['line']}"
                )
            inline_value = decode_scalar(
                raw_value, f"{key} at line {line_number}", allow_empty=True
            )
            if inline_value:
                raise ValueError(
                    f"{key} must be a non-empty block sequence; "
                    "flow-style sequences are unsupported"
                )
            group: dict[str, object] = {
                "key": key,
                "kind": phrase_kinds[key],
                "phrases": [],
                "indent": indent,
                "line": line_number,
            }
            current["keys"].add(key)
            current["groups"].append(group)
            active_group = group
            return
        raise ValueError(f"unsupported key '{key}' at line {line_number}")

    for indent, body, line_number in lines:
        if indent == 0:
            flush_item()
            if ":" not in body:
                section = None
                continue
            key, _, raw_value = body.partition(":")
            top_value = decode_scalar(
                raw_value, f"top-level key at line {line_number}", allow_empty=True
            )
            section = key.strip() if not top_value else None
            continue
        if section not in ("required_sections", "required_files"):
            continue
        if body.startswith("- ") and (item_indent is None or indent <= item_indent):
            flush_item()
            item_indent = indent
            current = {
                "owner": None,
                "groups": [],
                "keys": set(),
                "line": line_number,
            }
            payload = body[2:].strip()
            if ":" not in payload:
                if section == "required_files":
                    raise ValueError(
                        "required_files items must be mappings such as "
                        "'- path: SKILL.md'"
                    )
                raise ValueError(
                    f"required_sections item at line {line_number} must be a mapping"
                )
            key, _, raw_value = payload.partition(":")
            process_key(key.strip(), raw_value, indent, line_number)
            continue
        if body == "-" and (item_indent is None or indent <= item_indent):
            raise ValueError(f"empty list item at line {line_number} is invalid")
        if current is None or item_indent is None:
            raise ValueError(f"content outside a mapping item at line {line_number}")
        if (
            active_group is not None
            and indent > int(active_group["indent"])
            and body.startswith("- ")
        ):
            phrase = decode_scalar(
                body[2:],
                f"{active_group['key']} phrase at line {line_number}",
            )
            active_group["phrases"].append(phrase)
            continue
        flush_group()
        if ":" not in body:
            raise ValueError(f"invalid mapping content at line {line_number}")
        key, _, raw_value = body.partition(":")
        process_key(key.strip(), raw_value, indent, line_number)
    flush_item()
    return records
def main() -> int:
    path = Path(sys.argv[1])
    skill_root = Path(sys.argv[2]).resolve()
    try:
        records = parse(path)
        for _, file, _ in records:
            relative = Path(file)
            if relative.is_absolute():
                raise ValueError(f"owner path must be relative to the skill root: {file}")
            target = (skill_root / relative).resolve()
            try:
                target.relative_to(skill_root)
            except ValueError as exc:
                raise ValueError(f"owner path escapes the skill root: {file}") from exc
    except (OSError, UnicodeError, ValueError) as exc:
        print(f"conformance schema error: {exc}", file=sys.stderr)
        return 2
    for kind, file, phrase in records:
        print(f"{kind}\t{file}\t{phrase}")
    return 0
raise SystemExit(main())
PY
then
  echo "Failed to parse conformance.yaml" >&2
  exit 2
fi

if [[ ! -s "$PARSED_FILE" ]]; then
  echo "conformance.yaml produced no rules" >&2
  exit 2
fi

PASS=0
FAIL=0
ORDERED_TARGET=""
ORDERED_OFFSET=0

red()   { printf '\033[31m%s\033[0m' "$*"; }
green() { printf '\033[32m%s\033[0m' "$*"; }

pass_msg() { PASS=$((PASS+1)); printf "  %s %s\n" "$(green OK)"   "$*"; }
fail_msg() { FAIL=$((FAIL+1)); printf "  %s %s\n" "$(red FAIL)" "$*"; }

echo "Skill root:  $SKILL_ROOT"
echo "Manifest:    $CONFORMANCE_PATH"
echo ""
echo "Required content"
echo "----------------"

while IFS=$'\t' read -r kind file phrase; do
  target="$SKILL_ROOT/$file"
  case "$kind" in
    ORDER_START)
      ORDERED_TARGET="$target"
      ORDERED_OFFSET=0
      ;;
    ORDERED)
      if [[ ! -f "$target" ]]; then
        fail_msg "$file -- file missing (cannot scan ordered phrase: $phrase)"
        continue
      fi
      if [[ "$ORDERED_TARGET" != "$target" ]]; then
        fail_msg "$file <- ordered phrase has no must_contain_in_order group: $phrase"
        continue
      fi
      set +e
      order_result="$(python3 - "$target" "$phrase" "$ORDERED_OFFSET" <<'PY'
from pathlib import Path
import sys

try:
    content = Path(sys.argv[1]).read_text(encoding="utf-8")
except (OSError, UnicodeError) as exc:
    print(f"{type(exc).__name__}: {exc}")
    raise SystemExit(2)
phrase = sys.argv[2]
offset = int(sys.argv[3])
position = content.find(phrase, offset)
if position >= 0:
    print(f"FOUND\t{position + len(phrase)}")
elif content.find(phrase) >= 0:
    print("OUT_OF_ORDER")
else:
    print("MISSING")
PY
)"
      order_status=$?
      set -e
      if [[ "$order_status" -ne 0 ]]; then
        fail_msg "$file <- ordered check error: $phrase ($order_result)"
        continue
      fi
      case "$order_result" in
        FOUND$'\t'*)
          ORDERED_OFFSET="${order_result#*$'\t'}"
          pass_msg "$file <- ordered: $phrase"
          ;;
        OUT_OF_ORDER)
          fail_msg "$file <- OUT OF ORDER: $phrase"
          ;;
        MISSING)
          fail_msg "$file <- MISSING ordered phrase: $phrase"
          ;;
        *)
          fail_msg "$file <- ordered check error: $phrase"
          ;;
      esac
      ;;
    CONTAINS)
      if [[ ! -f "$target" ]]; then
        fail_msg "$file -- file missing (cannot scan for: $phrase)"
        continue
      fi
      if grep -qF -- "$phrase" "$target"; then
        pass_msg "$file <- contains: $phrase"
      else
        fail_msg "$file <- MISSING: $phrase"
      fi
      ;;
    NOT_CONTAINS)
      if [[ ! -f "$target" ]]; then
        fail_msg "$file -- file missing (cannot scan forbidden phrase: $phrase)"
        continue
      fi
      if grep -qF -- "$phrase" "$target"; then
        fail_msg "$file <- FORBIDDEN: $phrase"
      else
        pass_msg "$file <- does not contain: $phrase"
      fi
      ;;
    EXISTS)
      if [[ -e "$target" ]]; then
        pass_msg "$file <- exists"
      else
        fail_msg "$file <- MISSING (file not found)"
      fi
      ;;
  esac
done < "$PARSED_FILE"

echo ""
echo "==========================="
if [[ "$FAIL" -eq 0 ]]; then
  printf "Results: %s passed, 0 failed\n" "$(green "$PASS")"
  printf "%s\n" "$(green 'Conformance check passed.')"
  exit 0
else
  printf "Results: %s passed, %s failed\n" "$(green "$PASS")" "$(red "$FAIL")"
  printf "%s\n" "$(red 'Conformance check failed.')"
  echo ""
  echo "If running as part of update-upstream: re-apply the missing sections"
  echo "from the upstream template, then re-run."
  exit 1
fi
