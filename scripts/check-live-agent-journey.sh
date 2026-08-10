#!/usr/bin/env bash
# Opt-in black-box journey using a real Codex CLI in a fresh temporary project.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CODEX_BIN="${SBA_CODEX_BIN:-codex}"
LIVE_TIMEOUT_SECONDS="${SBA_LIVE_AGENT_TIMEOUT_SECONDS:-180}"

command -v "$CODEX_BIN" >/dev/null 2>&1 || {
  echo "Codex CLI not found: $CODEX_BIN" >&2
  exit 2
}

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
project="$tmp/project"
mkdir -p "$project/skills/release-helper" "$project/scripts"

cat > "$project/AGENTS.md" <<'MARKDOWN'
# Project Instructions

For every task, read `skills/release-helper/SKILL.md` before acting.
MARKDOWN

cat > "$project/skills/release-helper/SKILL.md" <<'MARKDOWN'
---
name: release-helper
description: >
  This skill should be used when the user asks to "update the project version",
  "prepare a release", or "更新版本号". Activate for release metadata changes
  in this small repository where one direct workflow covers every admitted task.
---

# Release Helper

## Always Read

1. Read `VERSION` before changing release metadata.

## Common Tasks

- Version update: change only `VERSION`, then run `bash scripts/check-version.sh 1.2.4`.
- Other release request: inspect `VERSION`, make the smallest relevant change, and run the same check.

Do not create `routing.yaml`, workflow directories, extra harness entries, or maintenance files for this task.
MARKDOWN

cat > "$project/scripts/check-version.sh" <<'BASH'
#!/usr/bin/env bash
set -euo pipefail
expected="${1:?expected version required}"
actual="$(tr -d '\r\n' < VERSION)"
[[ "$actual" == "$expected" ]] || {
  echo "expected VERSION=$expected, got $actual" >&2
  exit 1
}
BASH
chmod +x "$project/scripts/check-version.sh"
printf '1.2.3\n' > "$project/VERSION"

agents_before="$(cksum "$project/AGENTS.md")"
skill_before="$(cksum "$project/skills/release-helper/SKILL.md")"
check_before="$(cksum "$project/scripts/check-version.sh")"

set +e
perl -e 'alarm shift; exec @ARGV' "$LIVE_TIMEOUT_SECONDS" \
  "$CODEX_BIN" exec \
    --cd "$project" \
    --sandbox workspace-write \
    --skip-git-repo-check \
    --ephemeral \
    --ignore-user-config \
    --disable plugins \
    --disable remote_plugin \
    --disable plugin_sharing \
    --disable apps \
    --disable browser_use \
    --disable browser_use_external \
    --disable computer_use \
    --disable in_app_browser \
    --disable image_generation \
    --disable memories \
    --disable multi_agent \
    --color never \
    '把版本号更新到 1.2.4' \
    </dev/null \
    >"$tmp/codex-output.log" 2>&1
codex_status=$?
set -e
if [[ "$codex_status" -ne 0 ]]; then
  echo "Live Codex journey failed with status $codex_status" >&2
  sed -n '1,160p' "$tmp/codex-output.log" >&2
  if [[ "$codex_status" -eq 142 ]] || grep -qiE 'stream disconnected|request timed out|authentication required|unauthorized|rate limit' "$tmp/codex-output.log"; then
    echo "BLOCKED: live Agent transport or authentication was unavailable; no behavior verdict was produced." >&2
    exit 3
  fi
  exit "$codex_status"
fi

bash "$project/scripts/check-version.sh" 1.2.4
[[ "$(cksum "$project/AGENTS.md")" == "$agents_before" ]] || {
  echo "Live Agent changed AGENTS.md outside the requested task" >&2
  exit 1
}
[[ "$(cksum "$project/skills/release-helper/SKILL.md")" == "$skill_before" ]] || {
  echo "Live Agent changed the Single-file Skill outside the requested task" >&2
  exit 1
}
[[ "$(cksum "$project/scripts/check-version.sh")" == "$check_before" ]] || {
  echo "Live Agent changed the validation script outside the requested task" >&2
  exit 1
}
[[ ! -e "$project/skills/release-helper/routing.yaml" ]] || {
  echo "Live Agent created an unneeded routing.yaml" >&2
  exit 1
}
[[ ! -d "$project/skills/release-helper/workflows" ]] || {
  echo "Live Agent created an unneeded workflows directory" >&2
  exit 1
}

printf 'PASS: fresh-project natural-language journey updated VERSION through a Single-file Skill\n'
printf 'NOTE: this proves one live Codex journey, not every harness, prompt, migration, or interruption path.\n'
