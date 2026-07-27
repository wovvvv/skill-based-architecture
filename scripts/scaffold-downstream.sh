#!/usr/bin/env bash
# Safe first-use scaffold for a downstream repository.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET="$(pwd)"
NAME=""
SUMMARY=""
MODE="dry-run"

usage() {
  cat <<'EOF'
Usage: bash scripts/scaffold-downstream.sh --name <skill-name> --summary <text> [--target <dir>] [--apply]

Defaults to a read-only preview. Existing project entry files are preserved and
reported for Agent-led semantic merge. Existing skill or Cursor registration
directories are hard conflicts because rerunning over them is unsafe.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --name)
      [[ $# -ge 2 ]] || { echo "Missing value for --name" >&2; exit 2; }
      NAME="$2"
      shift 2
      ;;
    --summary)
      [[ $# -ge 2 ]] || { echo "Missing value for --summary" >&2; exit 2; }
      SUMMARY="$2"
      shift 2
      ;;
    --target)
      [[ $# -ge 2 ]] || { echo "Missing value for --target" >&2; exit 2; }
      TARGET="$2"
      shift 2
      ;;
    --apply)
      MODE="apply"
      shift
      ;;
    --dry-run)
      MODE="dry-run"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown arg: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

[[ -n "$NAME" ]] || { echo "Missing required --name" >&2; exit 2; }
[[ -n "$SUMMARY" ]] || { echo "Missing required --summary" >&2; exit 2; }
[[ "$NAME" =~ ^[a-z0-9][a-z0-9-]*$ ]] || {
  echo "Skill name must be kebab-case: $NAME" >&2
  exit 2
}
[[ "$SUMMARY" != *$'\n'* ]] || { echo "Summary must be one line" >&2; exit 2; }
[[ -d "$TARGET" ]] || { echo "Target directory does not exist: $TARGET" >&2; exit 2; }
TARGET="$(cd "$TARGET" && pwd)"

hard_conflict=0
for path in "skills/$NAME" ".cursor/skills/$NAME"; do
  if [[ -e "$TARGET/$path" || -L "$TARGET/$path" ]]; then
    echo "CONFLICT: $path already exists; inspect the current migration instead of rerunning"
    hard_conflict=1
  else
    echo "CREATE: $path"
  fi
done

entry_paths=(
  "AGENTS.md"
  "CLAUDE.md"
  "CODEX.md"
  "GEMINI.md"
  ".cursor/rules/workflow.mdc"
)
preserved_count=0
for path in "${entry_paths[@]}"; do
  if [[ -e "$TARGET/$path" || -L "$TARGET/$path" ]]; then
    echo "PRESERVE: $path (Agent must migrate its meaning and merge the thin-shell bootstrap)"
    preserved_count=$((preserved_count+1))
  else
    echo "CREATE: $path"
  fi
done

[[ $hard_conflict -eq 0 ]] || exit 2
if [[ "$MODE" == "dry-run" ]]; then
  echo "DRY-RUN: target unchanged; rerun with --apply after reviewing this inventory"
  exit 0
fi

stage="$(mktemp -d)"
created_paths=()
cleanup() {
  rm -rf "$stage"
}
rollback() {
  local status=$?
  if [[ $status -ne 0 ]]; then
    local path
    for path in "${created_paths[@]}"; do
      rm -rf "$TARGET/$path"
    done
    echo "FAIL: scaffold apply rolled back newly created paths" >&2
  fi
  cleanup
  exit "$status"
}
trap rollback EXIT

mkdir -p "$stage/skills/$NAME" "$stage/.cursor/skills/$NAME" "$stage/.cursor/rules"
cp -R "$ROOT/templates/skill/." "$stage/skills/$NAME/"
mv "$stage/skills/$NAME/SKILL.md.template" "$stage/skills/$NAME/SKILL.md"
cp "$ROOT/templates/shells/.cursor/skills/{{NAME}}/SKILL.md.template" \
  "$stage/.cursor/skills/$NAME/SKILL.md"
for path in AGENTS.md CLAUDE.md CODEX.md GEMINI.md; do
  cp "$ROOT/templates/shells/$path" "$stage/$path"
done
cp "$ROOT/templates/shells/.cursor/rules/workflow.mdc" "$stage/.cursor/rules/workflow.mdc"

escaped_name="$(printf '%s' "$NAME" | sed 's/[\\&|]/\\&/g')"
escaped_summary="$(printf '%s' "$SUMMARY" | sed 's/[\\&|]/\\&/g')"
find "$stage" -type f \( -name '*.md' -o -name '*.mdc' -o -name '*.yaml' \) \
  -exec sed -i.bak \
    -e "s|{{NAME}}|$escaped_name|g" \
    -e "s|{{SUMMARY}}|$escaped_summary|g" \
    {} +
find "$stage" -name '*.bak' -type f -delete

upstream_ref="$(git -C "$ROOT" config --get remote.origin.url 2>/dev/null || printf '%s' "$ROOT")"
upstream_sha="$(git -C "$ROOT" rev-parse HEAD 2>/dev/null || true)"
if [[ -n "$upstream_sha" ]]; then
  printf 'upstream: %s\nsynced_sha: %s\nsynced_date: %s\n' \
    "$upstream_ref" "$upstream_sha" "$(date +%F)" > "$stage/skills/$NAME/.upstream-sync"
fi

mkdir -p "$TARGET/skills" "$TARGET/.cursor/skills" "$TARGET/.cursor/rules"
cp -R "$stage/skills/$NAME" "$TARGET/skills/"
created_paths+=("skills/$NAME")
cp -R "$stage/.cursor/skills/$NAME" "$TARGET/.cursor/skills/"
created_paths+=(".cursor/skills/$NAME")

for path in "${entry_paths[@]}"; do
  if [[ ! -e "$TARGET/$path" && ! -L "$TARGET/$path" ]]; then
    mkdir -p "$(dirname "$TARGET/$path")"
    cp "$stage/$path" "$TARGET/$path"
    created_paths+=("$path")
  fi
done

trap - EXIT
cleanup
if [[ $preserved_count -gt 0 ]]; then
  echo "APPLIED: scaffold created; preserved entries still require Agent-led semantic merge"
else
  echo "APPLIED: scaffold created; no existing entry files required merge"
fi
