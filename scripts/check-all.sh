#!/usr/bin/env bash
# Run the upstream repo's full maintenance check suite.

set -euo pipefail

MODE="worktree"
BASE="${UPSTREAM_CHANGES_BASE:-HEAD}"
RUN_LIVE_AGENT=0

usage() {
  cat <<'EOF'
Usage: scripts/check-all.sh [--base <git-ref>] [--staged] [--live-agent]

Runs the self-hosting upstream maintenance checks used before commit/push:
  - upstream change-note guard
  - upstream supersedes refs check
  - template routing manifest check
  - template SessionStart hook runtime contract
  - responsibility-aware downstream validation contracts
  - empty-target Single-file materializer journey
  - one-procedure Folder-light materializer journey
  - declared Full downstream scaffold structural contract
  - existing-project first-migration journey
  - self-hosting shells + activation check
  - whitespace diff check
  - single-root + two-root integrity contracts
  - self-hosting manifest route proofs
  - self-hosting shell/bootstrap/link smoke subset
  - self-hosting orphan audit
  - Full template content conformance
  - self-hosting content conformance (upstream-canon)

Default mode checks the working tree. Use --staged from a pre-commit hook to
check the pending commit for UPSTREAM-CHANGES.md coverage and whitespace.
Use --live-agent to add the real Codex Single-file task and ordinary SBA
migration journeys in fresh temporary projects; without it, green means
deterministic structure and contract checks only.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --base)
      [[ $# -ge 2 ]] || { echo "Missing value for --base" >&2; exit 2; }
      BASE="$2"
      shift 2
      ;;
    --staged)
      MODE="staged"
      shift
      ;;
    --live-agent)
      RUN_LIVE_AGENT=1
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

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

run() {
  local label="$1"
  shift
  printf '\n==> %s\n' "$label"
  "$@"
}

LIVE_AGENT_NO_VERDICT_MODES=""

run_live_agent_mode() {
  local label="$1" live_mode="$2" live_exit_code
  printf '\n==> %s\n' "$label"
  set +e
  bash scripts/check-live-agent-journey.sh --mode "$live_mode"
  live_exit_code=$?
  set -e
  case "$live_exit_code" in
    0) return 0 ;;
    3)
      if [[ -n "$LIVE_AGENT_NO_VERDICT_MODES" ]]; then
        LIVE_AGENT_NO_VERDICT_MODES="$LIVE_AGENT_NO_VERDICT_MODES, $live_mode"
      else
        LIVE_AGENT_NO_VERDICT_MODES="$live_mode"
      fi
      return 0
      ;;
    *) return "$live_exit_code" ;;
  esac
}

fill_sample_scaffold() {
  local target="$1" name="$2" summary="$3"
  (
    cd "$target"
    find "skills/$name" AGENTS.md CLAUDE.md CODEX.md GEMINI.md .cursor \
      -type f \( -name '*.md' -o -name '*.mdc' -o -name '*.yaml' \) \
      -exec sed -i.bak \
        -e "s/{{NAME}}/$name/g" \
        -e "s/{{SUMMARY}}/$summary/g" \
        -e "s/<trigger phrase 1>/fix sample bug/g" \
        -e "s/<trigger phrase 2>/plan sample feature/g" \
        -e "s/<trigger phrase 3 \\/ 中文触发短语>/更新示例技能/g" \
        -e "s/<condition 1>/working on the sample project/g" \
        -e "s/<condition 2>/maintaining sample project rules/g" \
        {} +
    find . -name '*.bak' -type f -delete

    find "skills/$name" .cursor \
      -type f \( -name '*.md' -o -name '*.mdc' -o -name '*.yaml' \) \
      -exec perl -0pi -e 's/<!-- FILL:.*?-->//sg' {} +
    perl -0pi -e 's/^# FILL:.*?(?=^tasks:)/# This fixture intentionally exercises the complete routed scaffold.\n/ms' \
      "skills/$name/routing.yaml"
    perl -0pi -e 's/- <!-- Boundary 1 -->/- Owns the sample application and its repository-local validation rules./; s/- <!-- Boundary 2 -->/- Does not own deployment credentials or external release approval./' \
      "skills/$name/SKILL.md"

    cat > "skills/$name/rules/project-rules.md" <<'MARKDOWN'
# Project Rules

- Changes to the sample application must preserve its command-line contract.
- Release-affecting work requires the repository validation workflow before delivery.
- External credentials, deployment, and publication remain outside this project Skill.
- Project-rule changes require explicit user intent and the routed update-rules workflow.
MARKDOWN

    cat > "skills/$name/rules/coding-standards.md" <<'MARKDOWN'
# Coding Standards

- Use kebab-case file names and descriptive shell function names.
- Comment only non-obvious ownership, failure, or recovery boundaries.
- Keep shell scripts compatible with Bash 3.2 unless a checked runtime contract says otherwise.
- Run the repository-owned formatter or syntax check before reporting implementation complete.
- Keep imports and helper ownership local to the smallest responsible module.
MARKDOWN
  )
}

assert_full_scaffold_surfaces() {
  local target="$1" name="$2" path
  local required=(
    "skills/$name/routing.yaml"
    "skills/$name/workflows/task-execution.md"
    "skills/$name/workflows/task-closure.md"
    "skills/$name/scripts/smoke-test.sh"
    "skills/$name/scripts/sync-routing.sh"
    ".cursor/skills/$name/SKILL.md"
    ".cursor/rules/workflow.mdc"
    "AGENTS.md"
    "CLAUDE.md"
    "CODEX.md"
    "GEMINI.md"
  )

  for path in "${required[@]}"; do
    [[ -e "$target/$path" ]] || {
      echo "Full scaffold fixture missing declared surface: $path" >&2
      return 1
    }
  done
}

validate_downstream_scaffold() {
  local target="$1" name="$2"
  (
    cd "$target"
    bash "skills/$name/scripts/sync-routing.sh" "$name" --check
    bash "skills/$name/scripts/smoke-test.sh" "$name" --phase 8
    (
      cd "skills/$name"
      bash scripts/audit-orphans.sh
      bash scripts/route-reachability.sh
    )
  )
}

# Exercise the actual no-evidence Quick Start path.  The assertions are about
# the fitted boundary (the two owners and the absence of independently owned
# surfaces), not a copied Full scaffold inventory.
check_single_file_materializer_journey() (
  set -euo pipefail
  local tmp before name summary preview apply file_count
  tmp="$(mktemp -d)"
  before="$(mktemp -d)"
  trap 'rm -rf "$tmp" "$before"' EXIT
  name="single-project"
  summary="Small project with one direct procedure"

  preview="$(bash "$ROOT/scripts/scaffold-downstream.sh" \
    --target "$tmp" --name "$name" --summary "$summary")"
  [[ "$preview" == *"DRY-RUN: target unchanged; the evidence plan is session-scoped and was not written to the target"* ]]
  diff -r "$before" "$tmp"

  apply="$(bash "$ROOT/scripts/scaffold-downstream.sh" \
    --target "$tmp" --name "$name" --summary "$summary" --apply)"
  [[ "$apply" == *"APPLIED: evidence-selected Skill created; generated owners passed marker/path staging checks"* ]]
  [[ "$apply" == *"APPLIED RESPONSIBILITIES: materialization=direct routed=0"* ]]

  [[ -f "$tmp/AGENTS.md" ]]
  [[ -f "$tmp/skills/$name/SKILL.md" ]]
  file_count="$(find "$tmp" -type f -print | wc -l | tr -d '[:space:]')"
  [[ "$file_count" -eq 2 ]]
  for path in \
    "skills/$name/routing.yaml" \
    "skills/$name/workflows" \
    "skills/$name/scripts" \
    "CLAUDE.md" "CODEX.md" "GEMINI.md" \
    ".cursor" ".claude" ".codex" ".gemini"; do
    [[ ! -e "$tmp/$path" ]] || {
      echo "Single-file journey materialized an unadmitted surface: $path" >&2
      return 1
    }
  done
  grep -qF "skills/$name/SKILL.md" "$tmp/AGENTS.md"
  ! grep -qE 'routing\.yaml|workflows/|scripts/' "$tmp/skills/$name/SKILL.md"

  (
    cd "$tmp"
    bash "$ROOT/templates/skill/scripts/smoke-test.sh" "$name" --phase 8 >/dev/null
  )
  printf 'PASS: empty target materializes only the fitted Single-file owners\n'
)

# Exercise a single recurring workflow signal.  This must produce the
# Folder-light direct shape: rule owners plus one project procedure, while
# routing, Full execution/Closure owners, maintenance scripts, and extra
# harness registrations remain absent.
check_folder_direct_materializer_journey() (
  set -euo pipefail
  local tmp before name summary preview apply file_count
  tmp="$(mktemp -d)"
  before="$(mktemp -d)"
  trap 'rm -rf "$tmp" "$before"' EXIT
  name="folder-project"
  summary="Project with one recurring release procedure"
  cat > "$tmp/README.md" <<'MARKDOWN'
# Release Helper

## Release Workflow

Follow this workflow to change release metadata and verify a release.

1. Read VERSION.
2. Run the repository release check.
MARKDOWN
  cp -R "$tmp/." "$before/"

  preview="$(bash "$ROOT/scripts/scaffold-downstream.sh" \
    --target "$tmp" --name "$name" --summary "$summary")"
  [[ "$preview" == *"recurring_signals=1"* ]]
  [[ "$preview" == *"workflow_pressure=1"* ]]
  [[ "$preview" == *"CREATE: skills/$name/rules/project-rules.md"* ]]
  [[ "$preview" == *"CREATE: skills/$name/rules/coding-standards.md"* ]]
  [[ "$preview" == *"CREATE: skills/$name/workflows/project-task.md"* ]]
  [[ "$preview" != *"CREATE: skills/$name/routing.yaml"* ]]
  [[ "$preview" != *"CREATE: skills/$name/scripts/"* ]]
  [[ "$preview" != *"CREATE: skills/$name/workflows/task-execution.md"* ]]
  [[ "$preview" != *"CREATE: skills/$name/workflows/task-closure.md"* ]]
  [[ "$preview" == *"DRY-RUN: target unchanged; the evidence plan is session-scoped and was not written to the target"* ]]
  diff -r "$before" "$tmp"

  apply="$(bash "$ROOT/scripts/scaffold-downstream.sh" \
    --target "$tmp" --name "$name" --summary "$summary" --apply)"
  [[ "$apply" == *"APPLIED: evidence-selected Skill created; generated owners passed marker/path staging checks"* ]]
  [[ "$apply" == *"APPLIED RESPONSIBILITIES: materialization=folder routed=0"* ]]
  cmp "$before/README.md" "$tmp/README.md"

  for path in \
    "skills/$name/SKILL.md" \
    "skills/$name/rules/project-rules.md" \
    "skills/$name/rules/coding-standards.md" \
    "skills/$name/workflows/project-task.md"; do
    [[ -f "$tmp/$path" ]] || {
      echo "Folder-light direct journey is missing fitted owner: $path" >&2
      return 1
    }
  done
  file_count="$(find "$tmp" -type f -print | wc -l | tr -d '[:space:]')"
  [[ "$file_count" -eq 6 ]]
  for path in \
    "skills/$name/routing.yaml" \
    "skills/$name/scripts" \
    "skills/$name/workflows/task-execution.md" \
    "skills/$name/workflows/task-closure.md" \
    "skills/$name/conformance.yaml" \
    "skills/$name/sync-manifest.yaml" \
    "skills/$name/.upstream-sync" \
    "skills/$name/references" \
    "CLAUDE.md" "CODEX.md" "GEMINI.md" \
    ".cursor" ".claude" ".codex" ".gemini"; do
    [[ ! -e "$tmp/$path" ]] || {
      echo "Folder-light direct journey materialized an unadmitted surface: $path" >&2
      return 1
    }
  done
  grep -qF "rules/project-rules.md" "$tmp/skills/$name/SKILL.md"
  grep -qF "workflows/project-task.md" "$tmp/skills/$name/SKILL.md"
  grep -qF "repository-owned fitted" \
    "$tmp/skills/$name/workflows/project-task.md"
  grep -qF "validation command." \
    "$tmp/skills/$name/workflows/project-task.md"

  (
    cd "$tmp"
    bash "$ROOT/templates/skill/scripts/smoke-test.sh" "$name" --phase 8 >/dev/null
  )
  printf 'PASS: one recurring procedure materializes fitted Folder-light direct owners\n'
)

check_downstream_scaffold() (
  set -euo pipefail
  local tmp name summary
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  name="sample-skill"
  summary="Sample downstream scaffold for upstream regression checks"

  # This is an explicitly evidenced broad project, not the default path. The
  # blank-target/default journey is covered separately by the responsibility
  # contract fixture; keeping this evidence here preserves a real Full-like
  # regression without teaching Quick Start to copy it unconditionally.
  mkdir -p "$tmp/.cursor" "$tmp/.claude" "$tmp/.codex" "$tmp/.gemini" \
    "$tmp/.github/workflows" "$tmp/scripts"
  printf '# Sample project instructions\n\n## Fix bug\nReproduce the bug and run the check.\n\n## Add feature\nPreserve the public contract.\n\n## Refactor\nUpdate all callers and review the result.\n' > "$tmp/AGENTS.md"
  printf '# Upstream tracking evidence\nRefresh upstream vendor files only with the repository check.\n' > "$tmp/UPSTREAM-CHANGES.md"

  bash "$ROOT/scripts/scaffold-downstream.sh" \
    --target "$tmp" --name "$name" --summary "$summary" --apply
  # Simulate the Agent's semantic merge of the preserved source entry before
  # running fitted structural checks; the scaffold itself must not overwrite it.
  for shell in AGENTS.md CLAUDE.md CODEX.md GEMINI.md; do
    cp "$ROOT/templates/shells/$shell" "$tmp/$shell"
  done
  cp "$ROOT/templates/shells/.cursor/rules/workflow.mdc" "$tmp/.cursor/rules/workflow.mdc"
  fill_sample_scaffold "$tmp" "$name" "$summary"
  # Semantic merge changes canonical route inputs and generated shell bodies.
  # Model the real Agent path: regenerate from routing.yaml, then let the
  # validator below prove check mode is clean rather than accepting drift.
  (
    cd "$tmp"
    bash "skills/$name/scripts/sync-routing.sh" "$name" >/dev/null
  )
  assert_full_scaffold_surfaces "$tmp" "$name"
  validate_downstream_scaffold "$tmp" "$name"
)

check_existing_project_scaffold_journey() (
  set -euo pipefail
  local tmp before after_apply name summary preview conflict_output conflict_status evidence
  tmp="$(mktemp -d)"
  before="$(mktemp -d)"
  after_apply="$(mktemp -d)"
  trap 'rm -rf "$tmp" "$before" "$after_apply"' EXIT
  name="existing-project"
  summary="Existing project migration journey"

  mkdir -p "$tmp/.cursor/rules" "$tmp/.codex" "$tmp/.gemini"
  printf '# Existing Agent Rules\n\nKeep the release approval rule.\n' > "$tmp/AGENTS.md"
  printf '# Existing Claude Rules\n\n## Fix bug\nReproduce the failing case.\n\n## Change feature\nPreserve the public behavior.\n' > "$tmp/CLAUDE.md"
  printf '# Existing Cursor Rule\n\nRun the repository formatter before review.\n' > "$tmp/.cursor/rules/workflow.mdc"
  cp -R "$tmp/." "$before/"

  preview="$(bash "$ROOT/scripts/scaffold-downstream.sh" \
    --target "$tmp" --name "$name" --summary "$summary")"
  [[ "$preview" == *"PRESERVE: AGENTS.md"* ]]
  [[ "$preview" == *"PRESERVE: .cursor/rules/workflow.mdc"* ]]
  diff -r "$before" "$tmp"

  bash "$ROOT/scripts/scaffold-downstream.sh" \
    --target "$tmp" --name "$name" --summary "$summary" --apply
  cmp "$before/AGENTS.md" "$tmp/AGENTS.md"
  cmp "$before/.cursor/rules/workflow.mdc" "$tmp/.cursor/rules/workflow.mdc"

  cp -R "$tmp/." "$after_apply/"
  set +e
  conflict_output="$(bash "$ROOT/scripts/scaffold-downstream.sh" \
    --target "$tmp" --name "$name" --summary "$summary" 2>&1)"
  conflict_status=$?
  set -e
  [[ $conflict_status -eq 2 ]]
  [[ "$conflict_output" == *"CONFLICT: skills/$name already exists"* ]]
  diff -r "$after_apply" "$tmp"

  cp "$before/AGENTS.md" "$tmp/skills/$name/rules/project-rules.md"
  cp "$before/.cursor/rules/workflow.mdc" "$tmp/skills/$name/rules/coding-standards.md"
  cp "$ROOT/templates/shells/AGENTS.md" "$tmp/AGENTS.md"
  # The existing Claude entry is also a preserved source.  The original remains
  # available under `before`/`.migration-source` for semantic evidence; the
  # target root entry is switched to the canonical thin shell so the generated
  # marker contract can be checked after the merge below.
  cp "$ROOT/templates/shells/CLAUDE.md" "$tmp/CLAUDE.md"
  cp "$ROOT/templates/shells/.cursor/rules/workflow.mdc" "$tmp/.cursor/rules/workflow.mdc"
  fill_sample_scaffold "$tmp" "$name" "$summary"
  cp "$before/AGENTS.md" "$tmp/skills/$name/rules/project-rules.md"
  cp "$before/.cursor/rules/workflow.mdc" "$tmp/skills/$name/rules/coding-standards.md"
  cat >> "$tmp/skills/$name/rules/project-rules.md" <<'MARKDOWN'

## Migrated Claude rules

- Reproduce the failing case.
- Preserve the public behavior.
MARKDOWN

  grep -qF 'Keep the release approval rule.' "$tmp/skills/$name/rules/project-rules.md"
  grep -qF 'Run the repository formatter before review.' "$tmp/skills/$name/rules/coding-standards.md"
  mkdir -p "$tmp/.migration-source/.cursor/rules"
  cp "$before/AGENTS.md" "$tmp/.migration-source/AGENTS.md"
  cp "$before/CLAUDE.md" "$tmp/.migration-source/CLAUDE.md"
  cp "$before/.cursor/rules/workflow.mdc" "$tmp/.migration-source/.cursor/rules/workflow.mdc"
  evidence="$tmp/migration-evidence.json"
  cat > "$evidence" <<JSON
{
  "version": 1,
  "inventory": [
    {
      "id": "release-approval",
      "source": ".migration-source/AGENTS.md",
      "text": "Keep the release approval rule."
    },
    {
      "id": "formatter-before-review",
      "source": ".migration-source/.cursor/rules/workflow.mdc",
      "text": "Run the repository formatter before review."
    },
    {
      "id": "claude-reproduce-failing-case",
      "source": ".migration-source/CLAUDE.md",
      "text": "Reproduce the failing case."
    },
    {
      "id": "claude-preserve-public-behavior",
      "source": ".migration-source/CLAUDE.md",
      "text": "Preserve the public behavior."
    }
  ],
  "mappings": [
    {
      "inventory_id": "release-approval",
      "destination": "skills/$name/rules/project-rules.md",
      "mode": "verbatim",
      "activation_chain": [
        "skills/$name/SKILL.md",
        "skills/$name/routing.yaml",
        "skills/$name/workflows/change-managed.md",
        "skills/$name/rules/change-discipline.md",
        "skills/$name/rules/project-rules.md"
      ]
    },
    {
      "inventory_id": "formatter-before-review",
      "destination": "skills/$name/rules/coding-standards.md",
      "mode": "verbatim",
      "activation_chain": [
        "skills/$name/SKILL.md",
        "skills/$name/routing.yaml",
        "skills/$name/workflows/change-managed.md",
        "skills/$name/rules/change-discipline.md",
        "skills/$name/rules/coding-standards.md"
      ]
    },
    {
      "inventory_id": "claude-reproduce-failing-case",
      "destination": "skills/$name/rules/project-rules.md",
      "mode": "verbatim",
      "activation_chain": [
        "skills/$name/SKILL.md",
        "skills/$name/routing.yaml",
        "skills/$name/workflows/fix-bug.md",
        "skills/$name/rules/change-discipline.md",
        "skills/$name/rules/project-rules.md"
      ]
    },
    {
      "inventory_id": "claude-preserve-public-behavior",
      "destination": "skills/$name/rules/project-rules.md",
      "mode": "verbatim",
      "activation_chain": [
        "skills/$name/SKILL.md",
        "skills/$name/routing.yaml",
        "skills/$name/workflows/change-managed.md",
        "skills/$name/rules/change-discipline.md",
        "skills/$name/rules/project-rules.md"
      ]
    }
  ],
  "exclusions": []
}
JSON
  bash "$ROOT/scripts/check-migration-evidence.sh" --root "$tmp" --manifest "$evidence"
  # The migrated rules and preserved shell replacements above are the Agent's
  # semantic merge. Regenerate their derived routing blocks before strict
  # check mode, matching the same lifecycle as the declared-Full journey.
  (
    cd "$tmp"
    bash "skills/$name/scripts/sync-routing.sh" "$name" >/dev/null
  )
  assert_full_scaffold_surfaces "$tmp" "$name"
  validate_downstream_scaffold "$tmp" "$name"
)

check_two_root_integrity() {
  local tmp skill_root code_root routing
  tmp="$(mktemp -d)"
  skill_root="$tmp/skill"
  code_root="$tmp/code"
  routing="$skill_root/routing.yaml"
  mkdir -p "$skill_root/rules" "$skill_root/workflows" "$skill_root/gotchas" "$code_root/gotchas"

  printf '# Base\n' > "$skill_root/rules/base.md"
  printf '# Run\n' > "$skill_root/workflows/run.md"
  printf '# Code shared\n' > "$code_root/gotchas/shared.md"
  printf '# Skill collision\n' > "$skill_root/gotchas/shared.md"
  cat > "$routing" <<'YAML'
path_resolution:
  skill_root: {owns: [rules/**, workflows/**, gotchas/**]}
  code_root: {owns: [gotchas/**]}
always_read:
  - skill:rules/base.md
  - code:gotchas/shared.md
tasks:
  - id: fixture
    workflow: skill:workflows/run.md
YAML

  if (cd "$skill_root" && bash "$ROOT/templates/skill/scripts/audit-orphans.sh" --namespace skill --routing "$routing") >/dev/null 2>&1; then
    echo "two-root audit failed to isolate a same-path skill:/code: collision" >&2
    rm -rf "$tmp"
    return 1
  fi
  if (cd "$skill_root" && bash "$ROOT/templates/skill/scripts/route-reachability.sh" --namespace skill --routing "$routing") >/dev/null 2>&1; then
    echo "two-root route check failed to isolate a same-path skill:/code: collision" >&2
    rm -rf "$tmp"
    return 1
  fi

  rm "$skill_root/gotchas/shared.md"
  (cd "$skill_root" && bash "$ROOT/templates/skill/scripts/audit-orphans.sh" --namespace skill --routing "$routing")
  (cd "$skill_root" && bash "$ROOT/templates/skill/scripts/route-reachability.sh" --namespace skill --routing "$routing")
  (cd "$code_root" && bash "$ROOT/templates/skill/scripts/audit-orphans.sh" --namespace code --routing "$routing")
  (cd "$code_root" && bash "$ROOT/templates/skill/scripts/route-reachability.sh" --namespace code --routing "$routing")
  rm -rf "$tmp"
}

check_conformance_option_like_phrases() {
  local tmp script
  tmp="$(mktemp -d)"
  script="$ROOT/templates/skill/scripts/check-version-conformance.sh"
  printf '%s\n' '# Fixture' '--present' > "$tmp/fixture.md"

  cat > "$tmp/pass.yaml" <<'YAML'
required_sections:
  - file: fixture.md
    must_contain:
      - "--present"
YAML
  bash "$script" "$tmp" --conformance "$tmp/pass.yaml" >/dev/null

  cat > "$tmp/fail.yaml" <<'YAML'
required_sections:
  - file: fixture.md
    must_not_contain:
      - "--present"
YAML
  if bash "$script" "$tmp" --conformance "$tmp/fail.yaml" >/dev/null 2>&1; then
    echo "conformance must_not_contain accepted an option-like phrase that exists" >&2
    rm -rf "$tmp"
    return 1
  fi
  rm -rf "$tmp"
}

check_vendor_sync_guards() (
  set -euo pipefail
  local tmp up skill outside script manifest sha output status
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  up="$tmp/upstream"; skill="$tmp/skill"; outside="$tmp/outside"
  script="$ROOT/templates/skill/scripts/sync-vendor.sh"
  manifest="$up/templates/skill/sync-manifest.yaml"

  mkdir -p "$up/templates/skill/scripts" "$up/templates/skill/rules" "$skill" "$outside"
  printf '# fixture\n' > "$up/templates/skill/scripts/payload.sh"
  printf '# project-owned\n' > "$up/templates/skill/rules/project.md"
  printf '# fixture skill\n' > "$skill/SKILL.md"
  printf 'vendor:\n  - scripts/payload.sh\nproject_owned:\n  - rules/project.md\n' > "$manifest"
  git -C "$up" init -q
  git -C "$up" config user.email fixture@example.invalid
  git -C "$up" config user.name Fixture
  git -C "$up" add .
  git -C "$up" commit -qm fixture
  sha="$(git -C "$up" rev-parse HEAD)"
  printf 'upstream: fixture\nsynced_sha: %s\nsynced_date: 2026-07-22\n' "$sha" > "$skill/.upstream-sync"

  bash "$script" "$skill" --upstream "$up" --apply >/dev/null
  [[ -f "$skill/scripts/payload.sh" ]] || { echo "vendor block entry was not copied" >&2; return 1; }
  [[ ! -e "$skill/rules/project.md" ]] || { echo "parser consumed a non-vendor owner block" >&2; return 1; }

  expect_vendor_reject() {
    local label="$1"
    if output="$(bash "$script" "$skill" --upstream "$up" --apply 2>&1)"; then
      echo "vendor guard accepted $label" >&2
      return 1
    else
      status=$?
    fi
    [[ $status -eq 2 && "$output" == *"FAIL:"* ]] || {
      echo "vendor guard returned unexpected result for $label: status=$status" >&2
      printf '%s\n' "$output" >&2
      return 1
    }
  }

  printf 'vendor:\n  - rules/project.md\n' > "$manifest"
  expect_vendor_reject "project-owned path"
  [[ ! -e "$skill/rules/project.md" ]] || { echo "project-owned path was written" >&2; return 1; }

  printf 'vendor:\n  - /tmp/vendor-sync-absolute-escape\n' > "$manifest"
  expect_vendor_reject "absolute path"

  printf 'vendor:\n  - scripts/../escape.sh\n' > "$manifest"
  expect_vendor_reject "traversal path"
  [[ ! -e "$skill/escape.sh" ]] || { echo "traversal path escaped the owner directory" >&2; return 1; }

  rm -rf "$skill/scripts"
  ln -s "$outside" "$skill/scripts"
  printf 'vendor:\n  - scripts/payload.sh\n' > "$manifest"
  expect_vendor_reject "symlink target"
  [[ ! -e "$outside/payload.sh" ]] || { echo "symlink target escaped the skill root" >&2; return 1; }
)

check_overlay_owner_contract() (
  set -euo pipefail
  local tmp root skill script output
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  root="$tmp/workspace"
  skill="$root/skills/sample"
  script="$ROOT/templates/skill/scripts/sync-routing.sh"
  mkdir -p "$skill/rules" "$skill/workflows" "$skill/references/business" \
    "$root/services/billing/skills/billing/references/business"
  printf '# Base\n' > "$skill/rules/base.md"
  printf '# Run\n' > "$skill/workflows/run.md"
  printf '# Local billing consumer\n' > "$skill/references/business/billing-consumer.md"
  printf '# Billing owner\n' > "$root/services/billing/skills/billing/references/business/billing.md"
  cat > "$skill/SKILL.md" <<'MARKDOWN'
---
name: sample
description: sample overlay fixture
---
# Sample
<!-- ALWAYS_READ_START -->
<!-- ALWAYS_READ_END -->
<!-- ROUTING_SUMMARY_START -->
<!-- ROUTING_SUMMARY_END -->
MARKDOWN
  cat > "$skill/routing.yaml" <<'YAML'
always_read:
  - rules/base.md
tasks:
  - id: run
    labels: { en: Run, zh: 执行 }
    workflow: workflows/run.md
    trigger_examples: [执行任务, run task]
  - id: other
    labels: { en: Other, zh: 其他 }
    workflow: workflows/run.md
    trigger_examples: [其他任务]
YAML

  if (cd "$root" && bash "$script" "$skill" --check --workspace-root "$root") >/dev/null 2>&1; then
    echo "domain validation accepted a business owner without domain-routing.yaml" >&2
    return 1
  fi

  printf 'domain_overlays: []\n' > "$skill/domain-routing.yaml"
  if (cd "$root" && bash "$script" "$skill" --check --workspace-root "$root") >/dev/null 2>&1; then
    echo "domain validation accepted an empty domain-routing.yaml" >&2
    return 1
  fi

  cat > "$skill/domain-routing.yaml" <<'YAML'
owner_roots:
  billing: services/billing
domain_overlays:
  - id: billing
    labels: { en: Billing, zh: 计费 }
    required_reads:
      - references/business/billing-consumer.md
      - owner:billing:skills/billing/references/business/billing.md
    trigger_examples: [账单, billing policy]
YAML

  (cd "$root" && bash "$script" "$skill" --workspace-root "$root") >/dev/null
  grep -qF 'For each new task, read `routing.yaml`, match exactly one route' "$skill/SKILL.md"
  if grep -qF 'Run / 执行 (`run`) -> workflow `workflows/run.md`' "$skill/SKILL.md"; then
    echo "generated SKILL.md duplicated canonical task-route rows" >&2
    return 1
  fi
  if grep -q 'billing-consumer\|domain_overlay_ids\|merged_required_reads' "$skill/SKILL.md"; then
    echo "generated task summary eagerly exposed domain-routing content" >&2
    return 1
  fi
  (cd "$root" && bash "$script" "$skill" --check --workspace-root "$root") >/dev/null
  output="$(cd "$root" && bash "$script" "$skill" --check)"
  [[ "$output" == *"cross-owner target verification remains open"* ]] || {
    echo "owner check without workspace root did not report unverified target existence" >&2
    return 1
  }
  output="$(bash "$ROOT/templates/skill/scripts/route-health.sh" "$skill")"
  [[ "$output" == *"1 task routes + 1 domain overlays"* ]] || {
    echo "route-health did not separate task routes from domain overlays" >&2
    return 1
  }

  cp "$skill/domain-routing.yaml" "$tmp/domain-routing.base"
  perl -0pi -e 's#      - references/business/billing-consumer.md\n      - owner:billing:skills/billing/references/business/billing.md#      - task-relevant requirement billing:docs/requirements/billing.md#' "$skill/domain-routing.yaml"
  if (cd "$root" && bash "$script" "$skill" --check --workspace-root "$root") >/dev/null 2>&1; then
    echo "domain validation accepted a Plan requirement without a business owner" >&2
    return 1
  fi
  cp "$tmp/domain-routing.base" "$skill/domain-routing.yaml"

  printf '# Unregistered domain\n' > "$skill/references/business/unregistered.md"
  if (cd "$root" && bash "$script" "$skill" --check --workspace-root "$root") >/dev/null 2>&1; then
    echo "domain validation accepted an unregistered business leaf" >&2
    return 1
  fi
  rm "$skill/references/business/unregistered.md"

  cp "$skill/routing.yaml" "$tmp/routing.base"
  perl -0pi -e 's/(    labels: \{ en: Run[^\n]*\n)/$1    required_reads: []\n/' "$skill/routing.yaml"
  if (cd "$root" && bash "$script" "$skill" --check --workspace-root "$root") >/dev/null 2>&1; then
    echo "task route validation accepted required_reads" >&2
    return 1
  fi
  cp "$tmp/routing.base" "$skill/routing.yaml"

  perl -0pi -e 's/(    labels: \{ en: Run[^\n]*\n)/$1    route: inspect everything\n/' "$skill/routing.yaml"
  if (cd "$root" && bash "$script" "$skill" --check --workspace-root "$root") >/dev/null 2>&1; then
    echo "task route validation accepted executable route instructions" >&2
    return 1
  fi
  cp "$tmp/routing.base" "$skill/routing.yaml"

  printf '# Navigation only\n' > "$skill/references/navigation.md"
  perl -0pi -e 's#workflow: workflows/run.md#workflow: references/navigation.md#' "$skill/routing.yaml"
  if (cd "$root" && bash "$script" "$skill" --check --workspace-root "$root") >/dev/null 2>&1; then
    echo "task route validation accepted a navigation-only workflow target" >&2
    return 1
  fi
  cp "$tmp/routing.base" "$skill/routing.yaml"
  rm "$skill/references/navigation.md"

  cat >> "$skill/routing.yaml" <<'YAML'
domain_overlays:
  - id: legacy
    labels: { en: Legacy, zh: 旧领域 }
    required_reads: [references/business/billing-consumer.md]
    trigger_examples: [legacy]
YAML
  if (cd "$root" && bash "$script" "$skill" --check --workspace-root "$root") >/dev/null 2>&1; then
    echo "task routing accepted legacy inline domain overlays" >&2
    return 1
  fi
  cp "$tmp/routing.base" "$skill/routing.yaml"

  rm "$root/services/billing/skills/billing/references/business/billing.md"
  if (cd "$root" && bash "$script" "$skill" --check --workspace-root "$root") >/dev/null 2>&1; then
    echo "owner target validation accepted a missing cross-owner file" >&2
    return 1
  fi
  printf '# Billing owner\n' > "$root/services/billing/skills/billing/references/business/billing.md"

  perl -0pi -e 's#billing: services/billing#billing: ../billing#' "$skill/domain-routing.yaml"
  if (cd "$root" && bash "$script" "$skill" --check --workspace-root "$root") >/dev/null 2>&1; then
    echo "owner root validation accepted parent traversal" >&2
    return 1
  fi
  perl -0pi -e 's#billing: ../billing#billing: services/billing#' "$skill/domain-routing.yaml"

  perl -0pi -e 's#owner:billing:#owner:undeclared:#' "$skill/domain-routing.yaml"
  if (cd "$root" && bash "$script" "$skill" --check --workspace-root "$root") >/dev/null 2>&1; then
    echo "owner reference validation accepted an undeclared owner" >&2
    return 1
  fi
  perl -0pi -e 's#owner:undeclared:#owner:billing:#' "$skill/domain-routing.yaml"

  perl -0pi -e 's/(    labels: \{ en: Billing[^\n]*\n)/$1    workflow: workflows\/run.md\n/' "$skill/domain-routing.yaml"
  if (cd "$root" && bash "$script" "$skill" --check --workspace-root "$root") >/dev/null 2>&1; then
    echo "domain overlay validation accepted a workflow override" >&2
    return 1
  fi
)

check_code_root_domain_contract() (
  set -euo pipefail
  local tmp root skill code_root script
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  root="$tmp/workspace"
  skill="$root/skills/sample"
  code_root="$root/code/skills/sample"
  script="$ROOT/templates/skill/scripts/sync-routing.sh"
  mkdir -p "$skill/workflows" "$code_root/references/business/orders"
  printf '# Run\n' > "$skill/workflows/run.md"
  printf '# Business catalog\n' > "$code_root/references/business/index.md"
  printf '# Orders selector\n\nSee [refunds](refunds.md).\n' > "$code_root/references/business/orders/index.md"
  printf '# Refund rules\n' > "$code_root/references/business/orders/refunds.md"
  cat > "$skill/SKILL.md" <<'MARKDOWN'
---
name: sample
description: sample code-root domain fixture
---
# Sample
<!-- ALWAYS_READ_START -->
<!-- ALWAYS_READ_END -->
<!-- ROUTING_SUMMARY_START -->
<!-- ROUTING_SUMMARY_END -->
MARKDOWN
  cat > "$skill/routing.yaml" <<'YAML'
path_resolution:
  skill_root:
    owns: [SKILL.md, routing.yaml, domain-routing.yaml, workflows/**]
  code_root:
    root: code/skills/sample
    owns: [references/**]
always_read: []
tasks:
  - id: run
    labels: { en: Run, zh: 执行 }
    workflow: workflows/run.md
    trigger_examples: [run]
  - id: other
    labels: { en: Other, zh: 其他 }
    workflow: workflows/run.md
    trigger_examples: [other]
YAML

  if (cd "$root" && bash "$script" "$skill" --check --workspace-root "$root") >/dev/null 2>&1; then
    echo "code-root domain validation accepted business content without domain-routing.yaml" >&2
    return 1
  fi

  cat > "$skill/domain-routing.yaml" <<'YAML'
domain_overlays:
  - id: orders
    labels: { en: Orders, zh: 订单 }
    required_reads: [code:references/business/orders/index.md]
    trigger_examples: [refund, 退款]
YAML
  (cd "$root" && bash "$script" "$skill" --workspace-root "$root") >/dev/null
  (cd "$root" && bash "$script" "$skill" --check --workspace-root "$root") >/dev/null
  output="$(cd "$root" && bash "$script" "$skill" --check)"
  [[ "$output" == *"code-root target verification remains open"* ]] || {
    echo "code-root check without workspace root did not report open target verification" >&2
    return 1
  }

  cp "$skill/domain-routing.yaml" "$tmp/code-domain-routing.base"
  perl -0pi -e 's#required_reads: \[code:references/business/orders/index.md\]#required_reads: [code:references/business/orders/index.md, code:references/business/missing.md]#' "$skill/domain-routing.yaml"
  if (cd "$root" && bash "$script" "$skill" --check --workspace-root "$root") >/dev/null 2>&1; then
    echo "code-root target validation accepted a missing code owner" >&2
    return 1
  fi
  cp "$tmp/code-domain-routing.base" "$skill/domain-routing.yaml"

  mv "$code_root/references/business/orders/index.md" "$tmp/orders-index.md"
  if (cd "$root" && bash "$script" "$skill" --check --workspace-root "$root") >/dev/null 2>&1; then
    echo "code-root domain validation accepted nested leaves without a selecting index" >&2
    return 1
  fi
  mv "$tmp/orders-index.md" "$code_root/references/business/orders/index.md"
  (cd "$root" && bash "$script" "$skill" --check --workspace-root "$root") >/dev/null
)

check_recursive_knowledge_integrity() (
  set -euo pipefail
  local tmp root routing domain_routing
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  root="$tmp/skill"
  routing="$root/routing.yaml"
  domain_routing="$root/domain-routing.yaml"
  mkdir -p "$root/rules" "$root/workflows" "$root/references/business/deep"
  printf '# Base\n' > "$root/rules/base.md"
  printf '# Run\n' > "$root/workflows/run.md"
  printf '# Known\n' > "$root/references/business/known.md"
  printf '# Nested orphan\n' > "$root/references/business/deep/orphan.md"
  cat > "$routing" <<'YAML'
always_read:
  - rules/base.md
tasks:
  - id: run
    workflow: workflows/run.md
  - id: other
    workflow: workflows/run.md
YAML
  cat > "$domain_routing" <<'YAML'
domain_overlays:
  - id: known
    labels: { en: Known, zh: 已知 }
    required_reads:
      - references/business/known.md
    trigger_examples: [known]
YAML

  if (cd "$root" && bash "$ROOT/templates/skill/scripts/audit-orphans.sh") >/dev/null 2>&1; then
    echo "recursive orphan audit missed a nested business reference" >&2
    return 1
  fi
  if (cd "$root" && bash "$ROOT/templates/skill/scripts/route-reachability.sh") >/dev/null 2>&1; then
    echo "recursive route reachability missed an unactivated nested business reference" >&2
    return 1
  fi

  printf '\nSee references/business/deep/orphan.md.\n' >> "$root/references/business/known.md"
  (cd "$root" && bash "$ROOT/templates/skill/scripts/audit-orphans.sh") >/dev/null
  (cd "$root" && bash "$ROOT/templates/skill/scripts/route-reachability.sh") >/dev/null
)

if [[ "$MODE" == "staged" ]]; then
  run "upstream change-note guard (staged)" bash scripts/check-upstream-changes.sh --base "$BASE" --staged
  run "whitespace diff check (staged)" git diff --cached --check
else
  run "upstream change-note guard" bash scripts/check-upstream-changes.sh --base "$BASE"
  run "whitespace diff check" git diff --check
fi

run "upstream supersedes refs check" bash scripts/check-upstream-supersedes.sh

run "template routing manifest check" bash templates/skill/scripts/sync-routing.sh templates/skill --check
run "template SessionStart hook runtime contract" bash scripts/check-template-hooks.sh
run "responsibility-aware downstream validation contracts" bash scripts/check-validation-contract.sh
run "empty-target Single-file materializer journey" check_single_file_materializer_journey
run "one-procedure Folder-light materializer journey" check_folder_direct_materializer_journey
run "declared Full downstream scaffold structural contract" check_downstream_scaffold
run "existing-project first-migration journey" check_existing_project_scaffold_journey
run "single-root + two-root integrity contracts" check_two_root_integrity
run "conformance option-like phrase contract" check_conformance_option_like_phrases
run "vendor owner + path guards" check_vendor_sync_guards
run "task route + domain overlay and cross-owner guards" check_overlay_owner_contract
run "code-root domain materialization + nested-owner guards" check_code_root_domain_contract
run "recursive business-reference integrity" check_recursive_knowledge_integrity
run "self-hosting shells + activation check" bash scripts/check-self-shells.sh
run "self-hosting manifest route proofs" bash scripts/check-self-scenarios.sh
# The self-hosting root intentionally stores unfilled template sources. This
# Phase 7 slice checks only its root shell/bootstrap/link surfaces; the valid
# Single-file and declared Full fixtures above own downstream Skill structure.
run "self-hosting shell/bootstrap/link smoke subset" bash templates/skill/scripts/smoke-test.sh skill-based-architecture --phase 7
run "self-hosting orphan audit" bash templates/skill/scripts/audit-orphans.sh
run "Full template content conformance" bash templates/skill/scripts/check-version-conformance.sh templates/skill
run "self-hosting content conformance" bash templates/skill/scripts/check-version-conformance.sh . --conformance references/self-hosting-conformance.yaml

printf '\nAll deterministic upstream structure and contract checks passed.\n'
if [[ "$RUN_LIVE_AGENT" -eq 1 ]]; then
  run_live_agent_mode "live Codex Single-file user journey" single-file
  run_live_agent_mode "live Codex ordinary SBA migration journey" migration
  if [[ -n "$LIVE_AGENT_NO_VERDICT_MODES" ]]; then
    printf '\nNO VERDICT: live Agent evidence was unavailable for mode(s): %s.\n' "$LIVE_AGENT_NO_VERDICT_MODES" >&2
    printf 'Deterministic checks passed, but this run proves no live behavior for those mode(s).\n' >&2
    exit 3
  fi
  printf '\nBoth requested live Codex journeys passed their named terminal checks.\n'
else
  printf 'Live Agent behavior was not run; this green result does not prove real Agent behavior.\n'
  printf 'Run `bash scripts/check-all.sh --base %q --live-agent` for the opt-in Single-file and migration journeys.\n' "$BASE"
fi
