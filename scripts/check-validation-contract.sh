#!/usr/bin/env bash
# Upstream regression checks for responsibility-aware downstream validation.

set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PASS=0
FAIL=0

pass() {
  PASS=$((PASS + 1))
  printf 'PASS: %s\n' "$1"
}

fail() {
  FAIL=$((FAIL + 1))
  printf 'FAIL: %s\n' "$1" >&2
}

materialize_complete_fixture() {
  local target="$1" name="$2"

  mkdir -p "$target/skills/$name" \
    "$target/.cursor/skills/$name" \
    "$target/.cursor/rules"
  cp -R "$ROOT/templates/skill/." "$target/skills/$name/"
  # Conditional materializer sources are upstream author inputs, not emitted
  # Full downstream owners. Keep only the canonical complete Skill template.
  find "$target/skills/$name" -maxdepth 1 -type f \
    -name 'SKILL.*.md.template' ! -name 'SKILL.md.template' -delete
  mv "$target/skills/$name/SKILL.md.template" "$target/skills/$name/SKILL.md"
  # The same rule applies to conditional workflow/reference template sources
  # nested under the author tree: a complete downstream contains concrete
  # owners, never an unfilled *.md.template/*.yaml.template source.
  find "$target/skills/$name" -type f \( -name '*.md.template' -o -name '*.yaml.template' \) -delete
  cp "$ROOT/templates/shells/.cursor/skills/{{NAME}}/SKILL.md.template" \
    "$target/.cursor/skills/$name/SKILL.md"
  cp "$ROOT/templates/shells/.cursor/rules/workflow.mdc" \
    "$target/.cursor/rules/workflow.mdc"
  for shell in AGENTS.md CLAUDE.md CODEX.md GEMINI.md; do
    cp "$ROOT/templates/shells/$shell" "$target/$shell"
  done
}

replace_complete_fixture_identity() {
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
  )
}

fill_complete_fixture() {
  local target="$1" name="$2"
  (
    cd "$target"
    find "skills/$name" .cursor \
      -type f \( -name '*.md' -o -name '*.mdc' -o -name '*.yaml' \) \
      -exec perl -0pi -e 's/<!-- FILL:.*?-->//sg' {} +
    perl -0pi -e 's/^# FILL:.*?(?=^tasks:)/# This fixture intentionally exercises the complete routed scaffold.\n/ms' \
      "skills/$name/routing.yaml"
    perl -0pi -e 's/- <!-- Boundary 1 -->/- Owns the sample application and its repository-local validation rules./; s/- <!-- Boundary 2 -->/- Does not own deployment credentials or external release approval./' \
      "skills/$name/SKILL.md"
    perl -0pi -e 's#`\./\.maintenance-log\.yaml`#`../.maintenance-log.yaml`#g' \
      "skills/$name/workflows/maintain-docs.md"

    mkdir -p "skills/$name/references/business"
    cat > "skills/$name/domain-routing.yaml" <<'YAML'
domain_overlays:
  - id: order-policy
    labels: { en: Order policy domain, zh: 订单策略领域 }
    required_reads:
      - references/business/order-policy.md
    trigger_examples:
      - order policy rule
      - 订单策略规则
YAML
    cat > "skills/$name/references/business/order-policy.md" <<'MARKDOWN'
# Order Policy

The complete fixture owns one explicit business domain so its optional domain
routing references resolve to a real, activated owner.
MARKDOWN
    cat > "skills/$name/.maintenance-log.yaml" <<'YAML'
files:
  - path: references/gotchas.md
    last_tier2: 2026-08-11
YAML
    cat >> "skills/$name/references/gotchas.md" <<'MARKDOWN'

## X Registration

Register the fixture dependency before the controller uses it.
MARKDOWN

    cat > "skills/$name/rules/project-rules.md" <<'MARKDOWN'
# Project Rules

- Changes to the sample application must preserve its command-line contract.
- Release-affecting work requires the repository validation workflow before delivery.
- External credentials, deployment, and publication remain outside this project Skill.
- Project-rule changes require explicit user intent and the routed update-rules workflow.
- Task scope does not automatically grant external write authority for databases, deployments, configuration, or shared systems; obtain explicit authorization before performing such writes.
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

declared_complete_surfaces() {
  local name="$1"
  printf '%s\n' \
    "skills/$name/SKILL.md" \
    "skills/$name/routing.yaml" \
    "skills/$name/domain-routing.yaml" \
    "skills/$name/.maintenance-log.yaml" \
    "skills/$name/conformance.yaml" \
    "skills/$name/references/business/order-policy.md" \
    "skills/$name/workflows/task-execution.md" \
    "skills/$name/workflows/task-closure.md" \
    "skills/$name/workflows/update-upstream.md" \
    "skills/$name/protocol-blocks/external-delivery-verification.md" \
    "skills/$name/scripts/smoke-test.sh" \
    "skills/$name/scripts/sync-routing.sh" \
    "skills/$name/scripts/check-version-conformance.sh" \
    "skills/$name/scripts/audit-orphans.sh" \
    "skills/$name/scripts/route-reachability.sh" \
    "skills/$name/scripts/route-health.sh" \
    "skills/$name/scripts/sync-vendor.sh" \
    "skills/$name/scripts/upstream-status.sh" \
    "skills/$name/sync-manifest.yaml" \
    ".cursor/skills/$name/SKILL.md" \
    ".cursor/rules/workflow.mdc" \
    "AGENTS.md" \
    "CLAUDE.md" \
    "CODEX.md" \
    "GEMINI.md"
}

write_declared_complete_manifest() {
  local target="$1" name="$2" manifest="$3" path prefix
  prefix="skills/$name/"
  printf 'required_files:\n' > "$manifest"
  while IFS= read -r path; do
    # Conformance owns the Skill root; root-level harness/registration entries
    # are checked separately by assert_declared_complete_surfaces.
    [[ "$path" == "$prefix"* ]] || continue
    printf '  - path: %s\n' "${path#"$prefix"}" >> "$manifest"
  done < <(declared_complete_surfaces "$name")
}

assert_declared_complete_surfaces() {
  local target="$1" name="$2" path
  while IFS= read -r path; do
    [[ -e "$target/$path" ]] || {
      printf 'declared complete fixture surface is missing: %s\n' "$path" >&2
      return 1
    }
  done < <(declared_complete_surfaces "$name")
}

# Evidence input: one SKILL.md with one direct Common Tasks procedure and no
# independently owned routing, workflow, maintenance, or harness surfaces.
# Expected: smoke-test accepts the result and does not infer Full obligations.
check_single_file_skill() (
  set -euo pipefail
  local tmp skill output
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  skill="$tmp/skills/release-helper"
  output="$tmp/smoke.out"
  mkdir -p "$skill"

  cat > "$skill/SKILL.md" <<'MARKDOWN'
---
name: release-helper
description: >
  This skill should be used when the user asks to "update the project version",
  "prepare a release", or "更新版本号". Activate for release metadata changes
  in this small repository where one direct workflow covers every admitted task.
---

# Release Helper

Keep release metadata consistent without introducing additional project machinery.

## Always Read

1. Read `VERSION` before changing release metadata.

## Common Tasks

- Version update: edit `VERSION`, then run `bash scripts/check-version.sh`.
- Other release request: inspect `VERSION`, make the smallest relevant change, and run the same check.
MARKDOWN

  [[ ! -e "$skill/routing.yaml" ]]
  [[ ! -e "$skill/workflows" ]]
  [[ ! -e "$skill/scripts" ]]
  if ! (
    cd "$tmp"
    bash "$ROOT/templates/skill/scripts/smoke-test.sh" release-helper
  ) >"$output" 2>&1; then
    cat "$output" >&2
    return 1
  fi
)

# Evidence input: two Folder-light projects. The first keeps one recurring
# procedure in rules/ + workflows/ while SKILL.md owns routing directly. The
# second has two independently selectable procedures, so routing.yaml and its
# sync owner are admitted, but Full author/harness machinery remains absent.
# Expected: both fitted shapes pass; deleting a routed workflow fails exactly at
# the declared route target.
check_folder_light_fitted_shapes() (
  set -euo pipefail
  local tmp direct_root direct_skill routed_root routed_skill output
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT

  direct_root="$tmp/direct"
  direct_skill="$direct_root/skills/release-helper"
  mkdir -p "$direct_skill/rules" "$direct_skill/workflows"
  cat > "$direct_skill/SKILL.md" <<'MARKDOWN'
---
name: release-helper
description: >
  This skill should be used when the user asks to "update the project version",
  "prepare a release", or "更新版本号". Activate for release metadata changes
  whose one admitted procedure reads one repository-specific rules file.
---

# Release Helper

## Always Read

1. Read [`release-rules.md`](rules/release-rules.md) before changing version metadata.

## Common Tasks

- Release change: follow [`change-release.md`](workflows/change-release.md), including its direct verification and completion check.

## Known Gotchas

- Never infer a release approval from a successful local build.
MARKDOWN
  cat > "$direct_skill/rules/release-rules.md" <<'MARKDOWN'
# Release Rules

Keep the release approval rule.
MARKDOWN
  cat > "$direct_skill/workflows/change-release.md" <<'MARKDOWN'
# Change Release

Read [`release-rules.md`](../rules/release-rules.md), update the version, run the repository check, and report only that requested result as complete.
MARKDOWN
  cat > "$direct_skill/conformance.yaml" <<'YAML'
required_sections:
  - file: rules/release-rules.md
    must_contain:
      - "Keep the release approval rule."
  - file: workflows/change-release.md
    must_contain:
      - "report only that requested result as complete"
required_files:
  - path: SKILL.md
  - path: rules/release-rules.md
  - path: workflows/change-release.md
YAML

  [[ ! -e "$direct_skill/routing.yaml" ]]
  [[ ! -e "$direct_skill/scripts/sync-routing.sh" ]]
  output="$direct_root/smoke.out"
  if ! (
    cd "$direct_root"
    bash "$ROOT/templates/skill/scripts/smoke-test.sh" release-helper
  ) >"$output" 2>&1; then
    cat "$output" >&2
    return 1
  fi

  routed_root="$tmp/routed"
  routed_skill="$routed_root/skills/release-helper"
  mkdir -p "$routed_skill/rules" "$routed_skill/workflows" "$routed_skill/scripts"
  cat > "$routed_skill/SKILL.md" <<'MARKDOWN'
---
name: release-helper
description: >
  This skill should be used when the user asks to "update the project version",
  "inspect release readiness", or "检查发布准备情况". Activate for release work
  where two independently selectable procedures now require conditional routing.
---

# Release Helper

## Always Read

<!-- ALWAYS_READ_START -->
<!-- ALWAYS_READ_END -->

## Common Tasks

<!-- ROUTING_SUMMARY_START -->
<!-- ROUTING_SUMMARY_END -->

## Known Gotchas

- Never infer a release approval from a successful local build.
MARKDOWN
  cat > "$routed_skill/routing.yaml" <<'YAML'
always_read:
  - rules/release-rules.md
tasks:
  - id: change-release
    labels: { en: Change release, zh: 修改发布 }
    workflow: workflows/change-release.md
    trigger_examples: [update the project version, 更新版本号]
  - id: other
    labels: { en: Other release task, zh: 其他发布任务 }
    workflow: workflows/inspect-release.md
    trigger_examples: [inspect release readiness, 检查发布准备情况]
YAML
  cat > "$routed_skill/rules/release-rules.md" <<'MARKDOWN'
# Release Rules

Keep the release approval rule.
MARKDOWN
  cat > "$routed_skill/workflows/change-release.md" <<'MARKDOWN'
# Change Release

Read [`release-rules.md`](../rules/release-rules.md), update the version, and run the repository check.
MARKDOWN
  cat > "$routed_skill/workflows/inspect-release.md" <<'MARKDOWN'
# Inspect Release

Read [`release-rules.md`](../rules/release-rules.md) and report release readiness without changing repository state.
MARKDOWN
  cp "$ROOT/templates/skill/scripts/sync-routing.sh" "$routed_skill/scripts/sync-routing.sh"
  cat > "$routed_skill/conformance.yaml" <<'YAML'
required_sections:
  - file: routing.yaml
    must_contain:
      - "id: change-release"
      - "id: other"
  - file: workflows/change-release.md
    must_contain:
      - "run the repository check"
  - file: workflows/inspect-release.md
    must_contain:
      - "without changing repository state"
required_files:
  - path: SKILL.md
  - path: routing.yaml
  - path: scripts/sync-routing.sh
YAML

  [[ ! -e "$routed_root/AGENTS.md" ]]
  [[ ! -e "$routed_root/.cursor/skills/release-helper/SKILL.md" ]]
  (
    cd "$routed_root"
    bash "skills/release-helper/scripts/sync-routing.sh" release-helper >/dev/null
  )
  output="$routed_root/smoke.out"
  if ! (
    cd "$routed_root"
    bash "$ROOT/templates/skill/scripts/smoke-test.sh" release-helper
  ) >"$output" 2>&1; then
    cat "$output" >&2
    return 1
  fi

  mv "$routed_skill/workflows/change-release.md" \
    "$routed_skill/workflows/change-release.md.validation-missing"
  if (
    cd "$routed_root"
    bash "$ROOT/templates/skill/scripts/smoke-test.sh" release-helper
  ) >"$output" 2>&1; then
    echo "conditional routing accepted a missing declared workflow" >&2
    return 1
  fi
  grep -q 'workflows/change-release.md missing' "$output" || {
    cat "$output" >&2
    echo "conditional routing failed for an unrelated reason" >&2
    return 1
  }
)

# Evidence input: a deliberately complete copy of the canonical emitted
# templates/skill owners (conditional *.template author sources are excluded)
# plus every emitted shell/registration surface. The fixture itself declares
# these paths in a fitted required_files manifest.
# Expected: the complete result passes, and removing any representative routing,
# execution, Closure, maintenance, Cursor, or harness owner is a hard failure.
check_complete_declared_surfaces() (
  set -euo pipefail
  local tmp name summary skill manifest output path backup status
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  name="complete-skill"
  summary="Complete routed fixture for declared downstream responsibilities"
  skill="$tmp/skills/$name"
  manifest="$tmp/declared-complete-surfaces.yaml"
  output="$tmp/check.out"

  materialize_complete_fixture "$tmp" "$name"
  replace_complete_fixture_identity "$tmp" "$name" "$summary"
  fill_complete_fixture "$tmp" "$name"
  assert_declared_complete_surfaces "$tmp" "$name"
  write_declared_complete_manifest "$tmp" "$name" "$manifest"

  (
    cd "$tmp"
    bash "skills/$name/scripts/sync-routing.sh" "$name" --check >/dev/null
    bash "skills/$name/scripts/smoke-test.sh" "$name" --phase 8
  ) >"$output" 2>&1 || {
    cat "$output" >&2
    return 1
  }
  bash "$ROOT/templates/skill/scripts/check-version-conformance.sh" \
    "$skill" --conformance "$manifest" >"$output" 2>&1 || {
    cat "$output" >&2
    return 1
  }

  for path in \
    "routing.yaml" \
    "workflows/task-execution.md" \
    "workflows/task-closure.md" \
    "scripts/upstream-status.sh"; do
    backup="$skill/$path.validation-missing"
    mv "$skill/$path" "$backup"
    set +e
    bash "$ROOT/templates/skill/scripts/check-version-conformance.sh" \
      "$skill" --conformance "$manifest" >"$output" 2>&1
    status=$?
    set -e
    mv "$backup" "$skill/$path"
    if [[ "$status" -ne 1 ]] || ! grep -qF "$path <- MISSING" "$output"; then
      cat "$output" >&2
      echo "declared complete surface was not enforced: $path" >&2
      return 1
    fi
  done

  for path in ".cursor/skills/$name/SKILL.md" "AGENTS.md"; do
    backup="$tmp/$path.validation-missing"
    mv "$tmp/$path" "$backup"
    if assert_declared_complete_surfaces "$tmp" "$name" >"$output" 2>&1; then
      mv "$backup" "$tmp/$path"
      echo "declared external surface was not enforced: $path" >&2
      return 1
    fi
    mv "$backup" "$tmp/$path"
  done

  mv "$skill/workflows/task-closure.md" \
    "$skill/workflows/task-closure.md.validation-missing"
  if (
    cd "$tmp"
    bash "skills/$name/scripts/smoke-test.sh" "$name" --phase 8
  ) >"$output" 2>&1; then
    echo "complete smoke validation accepted a missing Task Closure owner" >&2
    return 1
  fi
  grep -q 'task-closure.md' "$output" || {
    cat "$output" >&2
    echo "complete smoke validation failed for an unrelated reason" >&2
    return 1
  }
)

# Evidence input: the same complete fixture first retains upstream FILL markers,
# then mechanically renames them to FILLED:. Expected: each fails for the marker
# contract itself, not merely because an unrelated route or link happens to drift.
check_unresolved_and_laundered_fill_are_rejected() (
  set -euo pipefail
  local tmp name summary output
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  name="laundered-skill"
  summary="Fixture that must not pass by renaming unresolved migration work"
  output="$tmp/smoke.out"

  materialize_complete_fixture "$tmp" "$name"
  replace_complete_fixture_identity "$tmp" "$name" "$summary"

  if (
    cd "$tmp"
    bash "skills/$name/scripts/smoke-test.sh" "$name" --phase 8
  ) >"$output" 2>&1; then
    echo "unresolved FILL markers passed validation" >&2
    return 1
  fi
  grep -q 'Unresolved FILL markers found' "$output" || {
    cat "$output" >&2
    echo "unresolved FILL fixture failed for an unrelated reason" >&2
    return 1
  }

  (
    cd "$tmp"
    find "skills/$name" AGENTS.md CLAUDE.md CODEX.md GEMINI.md .cursor \
      -type f \( -name '*.md' -o -name '*.mdc' -o -name '*.yaml' \) \
      -exec sed -i.bak -e 's/FILL:/FILLED:/g' {} +
    find . -name '*.bak' -type f -delete
    bash "skills/$name/scripts/sync-routing.sh" "$name" >/dev/null
  )

  if (
    cd "$tmp"
    bash "skills/$name/scripts/smoke-test.sh" "$name" --phase 8
  ) >"$output" 2>&1; then
    echo "renamed FILLED markers passed validation" >&2
    return 1
  fi
  grep -q 'Renamed FILLED: markers found' "$output" || {
    cat "$output" >&2
    echo "renamed FILLED fixture failed for an unrelated reason" >&2
    return 1
  }
)

# Evidence input: an inventory with a verbatim clause, a reviewed rewrite, and an
# explicit exclusion, plus deliberately malformed variants. Expected: every
# decision-changing source clause has exactly one disposition and activation
# proof; rewrites pass only with explicit review evidence.
check_migration_evidence_contract() (
  set -euo pipefail
  local tmp root manifest checker output status
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  root="$tmp/project"
  manifest="$tmp/evidence.json"
  checker="$ROOT/scripts/check-migration-evidence.sh"
  mkdir -p "$root/source" "$root/skills/release-helper/workflows" "$root/skills/release-helper/rules"

  cat > "$root/source/AGENTS.md" <<'MARKDOWN'
# Existing Rules

Keep the release approval rule.
Run the repository formatter before review.
Remove the obsolete local-only note during migration.
MARKDOWN
  cat > "$root/skills/release-helper/SKILL.md" <<'MARKDOWN'
# Release Helper

Read [`routing.yaml`](routing.yaml) for every task.
MARKDOWN
  cat > "$root/skills/release-helper/routing.yaml" <<'YAML'
tasks:
  - id: change-release
    workflow: workflows/change-release.md
YAML
  cat > "$root/skills/release-helper/workflows/change-release.md" <<'MARKDOWN'
# Change Release

Before changing release state, read [`project-rules.md`](../rules/project-rules.md).
MARKDOWN
  cat > "$root/skills/release-helper/rules/project-rules.md" <<'MARKDOWN'
# Project Rules

Keep the release approval rule.
Use the repository formatter before requesting review.
MARKDOWN

  expect_manifest_failure() {
    local expected="$1" label="$2"
    set +e
    output="$(bash "$checker" --root "$root" --manifest "$manifest" 2>&1)"
    status=$?
    set -e
    if [[ "$status" -ne 1 || "$output" != *"$expected"* ]]; then
      printf '%s\n' "$output" >&2
      printf 'migration evidence fixture did not reject %s with the expected contract failure\n' "$label" >&2
      return 1
    fi
  }

  cat > "$manifest" <<'JSON'
{
  "version": 1,
  "inventory": [
    {"id": "release-approval", "source": "source/AGENTS.md", "text": "Keep the release approval rule."},
    {"id": "formatter-before-review", "source": "source/AGENTS.md", "text": "Run the repository formatter before review."},
    {"id": "obsolete-note", "source": "source/AGENTS.md", "text": "Remove the obsolete local-only note during migration."}
  ],
  "mappings": [
    {
      "inventory_id": "release-approval",
      "destination": "skills/release-helper/rules/project-rules.md",
      "mode": "verbatim",
      "activation_chain": [
        "skills/release-helper/SKILL.md",
        "skills/release-helper/routing.yaml",
        "skills/release-helper/workflows/change-release.md",
        "skills/release-helper/rules/project-rules.md"
      ]
    }
  ],
  "exclusions": [
    {"inventory_id": "obsolete-note", "reason": "The instruction explicitly says this local-only note is obsolete."}
  ]
}
JSON
  expect_manifest_failure \
    "inventory formatter-before-review has no mapped or excluded disposition" \
    "a missing disposition"

  cat > "$manifest" <<'JSON'
{
  "version": 1,
  "inventory": [
    {"id": "release-approval", "source": "source/AGENTS.md", "text": "Keep the release approval rule."},
    {"id": "formatter-before-review", "source": "source/AGENTS.md", "text": "Run the repository formatter before review."},
    {"id": "obsolete-note", "source": "source/AGENTS.md", "text": "Remove the obsolete local-only note during migration."}
  ],
  "mappings": [
    {
      "inventory_id": "release-approval",
      "destination": "skills/release-helper/rules/project-rules.md",
      "mode": "verbatim",
      "activation_chain": [
        "skills/release-helper/SKILL.md",
        "skills/release-helper/workflows/change-release.md",
        "skills/release-helper/rules/project-rules.md"
      ]
    }
  ],
  "exclusions": [
    {"inventory_id": "formatter-before-review", "reason": "Temporary fixture disposition."},
    {"inventory_id": "obsolete-note", "reason": "The instruction explicitly says this local-only note is obsolete."}
  ]
}
JSON
  expect_manifest_failure \
    "activation chain for release-approval has no reference" \
    "a broken activation chain"

  cat > "$manifest" <<'JSON'
{
  "version": 1,
  "inventory": [
    {"id": "release-approval", "source": "source/AGENTS.md", "text": "Keep the release approval rule."},
    {"id": "formatter-before-review", "source": "source/AGENTS.md", "text": "Run the repository formatter before review."},
    {"id": "obsolete-note", "source": "source/AGENTS.md", "text": "Remove the obsolete local-only note during migration."}
  ],
  "mappings": [
    {
      "inventory_id": "release-approval",
      "destination": "skills/release-helper/rules/project-rules.md",
      "mode": "verbatim",
      "activation_chain": [
        "skills/release-helper/SKILL.md",
        "skills/release-helper/routing.yaml",
        "skills/release-helper/workflows/change-release.md",
        "skills/release-helper/rules/project-rules.md"
      ]
    }
  ],
  "exclusions": [
    {"inventory_id": "release-approval", "reason": "Duplicate disposition fixture."},
    {"inventory_id": "formatter-before-review", "reason": "Temporary fixture disposition."},
    {"inventory_id": "obsolete-note", "reason": "The instruction explicitly says this local-only note is obsolete."}
  ]
}
JSON
  expect_manifest_failure \
    "inventory release-approval has 2 dispositions; exactly one is required" \
    "duplicate dispositions"

  cat > "$manifest" <<'JSON'
{
  "version": 1,
  "inventory": [
    {"id": "release-approval", "source": "source/AGENTS.md", "text": "Keep the release approval rule."},
    {"id": "formatter-before-review", "source": "source/AGENTS.md", "text": "Run the repository formatter before review."},
    {"id": "obsolete-note", "source": "source/AGENTS.md", "text": "Remove the obsolete local-only note during migration."}
  ],
  "mappings": [
    {
      "inventory_id": "formatter-before-review",
      "destination": "skills/release-helper/rules/project-rules.md",
      "destination_text": "Use the repository formatter before requesting review.",
      "mode": "rewrite",
      "activation_chain": [
        "skills/release-helper/SKILL.md",
        "skills/release-helper/routing.yaml",
        "skills/release-helper/workflows/change-release.md",
        "skills/release-helper/rules/project-rules.md"
      ]
    }
  ],
  "exclusions": [
    {"inventory_id": "release-approval", "reason": "Temporary fixture disposition."},
    {"inventory_id": "obsolete-note", "reason": "The instruction explicitly says this local-only note is obsolete."}
  ]
}
JSON
  expect_manifest_failure \
    "mapping formatter-before-review review must be non-empty text" \
    "an unreviewed faithful rewrite"

  cat > "$manifest" <<'JSON'
{
  "version": 1,
  "inventory": [
    {"id": "release-approval", "source": "source/AGENTS.md", "text": "Keep the release approval rule."},
    {"id": "formatter-before-review", "source": "source/AGENTS.md", "text": "Run the repository formatter before review."},
    {"id": "obsolete-note", "source": "source/AGENTS.md", "text": "Remove the obsolete local-only note during migration."}
  ],
  "mappings": [
    {
      "inventory_id": "release-approval",
      "destination": "skills/release-helper/rules/project-rules.md",
      "mode": "verbatim",
      "activation_chain": [
        "skills/release-helper/SKILL.md",
        "skills/release-helper/routing.yaml",
        "skills/release-helper/workflows/change-release.md",
        "skills/release-helper/rules/project-rules.md"
      ]
    },
    {
      "inventory_id": "formatter-before-review",
      "destination": "skills/release-helper/rules/project-rules.md",
      "destination_text": "Use the repository formatter before requesting review.",
      "mode": "rewrite",
      "review": "Reviewed by the migration owner against the original formatter-before-review requirement.",
      "activation_chain": [
        "skills/release-helper/SKILL.md",
        "skills/release-helper/routing.yaml",
        "skills/release-helper/workflows/change-release.md",
        "skills/release-helper/rules/project-rules.md"
      ]
    }
  ],
  "exclusions": [
    {"inventory_id": "obsolete-note", "reason": "The instruction explicitly says this local-only note is obsolete."}
  ]
}
JSON
  output="$(bash "$checker" --root "$root" --manifest "$manifest")"
  [[ "$output" == *"REVIEW: mapping formatter-before-review records rewrite review"* ]]
  [[ "$output" == *"semantic equivalence is review evidence, not a script claim"* ]]
  [[ "$output" == *"0 failed"* ]]
)

# Evidence input: a malformed fitted manifest uses scalar required_files items.
# Expected: the conformance parser rejects the schema with exit 2 instead of
# silently producing zero file-existence rules.
check_scalar_required_files_are_rejected() (
  set -euo pipefail
  local tmp skill manifest checker output status
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  skill="$tmp/skills/scalar-contract"
  manifest="$skill/conformance.yaml"
  checker="$ROOT/templates/skill/scripts/check-version-conformance.sh"
  mkdir -p "$skill"
  printf '# Scalar contract\n' > "$skill/SKILL.md"
  cat > "$manifest" <<'YAML'
required_files:
  - SKILL.md
YAML

  set +e
  output="$(bash "$checker" "$skill" --conformance "$manifest" 2>&1)"
  status=$?
  set -e
  [[ "$status" -eq 2 ]] || {
    printf '%s\n' "$output" >&2
    echo "scalar required_files returned status $status instead of schema status 2" >&2
    return 1
  }
  [[ "$output" == *"conformance schema error"* ]]
  [[ "$output" == *"required_files items must be mappings"* ]]
)

# Evidence input: valid local Markdown references include one path-like inline
# code span, one heading fragment, fenced example paths, and placeholder/glob
# examples. Expected: the valid fixture passes; deleting the inline target and
# renaming the heading each fail for the exact affected reference.
check_inline_paths_and_heading_fragments() (
  set -euo pipefail
  local tmp skill smoke output status
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  skill="$tmp/skills/path-contract"
  smoke="$ROOT/templates/skill/scripts/smoke-test.sh"
  mkdir -p "$skill/references"

  cat > "$skill/SKILL.md" <<'MARKDOWN'
---
name: path-contract
description: >
  This skill should be used when the user asks to "inspect reference integrity",
  "validate local skill documentation", or "检查技能引用". Activate for project
  documentation whose local paths and section anchors must stay executable.
---

# Path Contract

## Common Tasks

- Reference check: read [inline paths](references/code-owner.md) and
  [heading anchors](references/anchor-owner.md), then run the fitted smoke check.
- Other: inspect the same two owners and report unresolved local references.

## Known Gotchas

- Fenced examples and placeholder/glob notation are examples, not dependencies.
MARKDOWN
  cat > "$skill/references/code-owner.md" <<'MARKDOWN'
# Inline Path Owner

Read `references/details.md` before applying the local procedure.

Do not treat `path with spaces.md`, `references/<name>/missing.md`, or
`references/*.md` as concrete dependencies.

```text
`missing-fenced-example.md`
```
MARKDOWN
  cat > "$skill/references/anchor-owner.md" <<'MARKDOWN'
# Anchor Owner

Follow the [Completion Gate](sections.md#completion-gate).
MARKDOWN
  cat > "$skill/references/details.md" <<'MARKDOWN'
# Details

The concrete inline-code target exists.
MARKDOWN
  cat > "$skill/references/sections.md" <<'MARKDOWN'
# Sections

## Completion Gate

The referenced completion section exists.
MARKDOWN

  output="$(cd "$tmp" && bash "$smoke" path-contract --phase 7 --workspace-root "$tmp")"
  [[ "$output" == *"inline_paths="* ]]
  [[ "$output" == *"fragments="* ]]

  mv "$skill/references/details.md" "$skill/references/details.md.validation-missing"
  set +e
  output="$(cd "$tmp" && bash "$smoke" path-contract --phase 7 --workspace-root "$tmp" 2>&1)"
  status=$?
  set -e
  mv "$skill/references/details.md.validation-missing" "$skill/references/details.md"
  [[ "$status" -eq 1 && "$output" == *"inline path:"* && "$output" == *"details.md"* ]] || {
    printf '%s\n' "$output" >&2
    echo "missing inline-code target did not fail for details.md" >&2
    return 1
  }

  cp "$skill/references/sections.md" "$tmp/sections.base.md"
  perl -0pi -e 's/## Completion Gate/## Completion Boundary/' "$skill/references/sections.md"
  set +e
  output="$(cd "$tmp" && bash "$smoke" path-contract --phase 7 --workspace-root "$tmp" 2>&1)"
  status=$?
  set -e
  cp "$tmp/sections.base.md" "$skill/references/sections.md"
  [[ "$status" -eq 1 && "$output" == *"heading fragment:"* && "$output" == *"sections.md#completion-gate"* ]] || {
    printf '%s\n' "$output" >&2
    echo "renamed heading did not fail for the completion-gate fragment" >&2
    return 1
  }
)

# Evidence input: a real broad materializer result with validation and
# database/deploy/config/shared-system pressure. Expected: the emitted manifest
# uses mapping-shaped required_files, deleting an emitted owner fails, and the
# no-implied-authority rule is both emitted and mutation-protected.
check_materialized_required_files_and_permission_anchor() (
  set -euo pipefail
  local tmp target name summary skill manifest checker output status permission_anchor
  local control_target control_name control_summary control_skill control_manifest control_apply
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  target="$tmp/project"
  name="permission-project"
  summary="Project with validation and external write authority pressure"
  skill="$target/skills/$name"
  manifest="$skill/conformance.yaml"
  checker="$ROOT/templates/skill/scripts/check-version-conformance.sh"
  permission_anchor='Task scope does not automatically grant external write authority for databases, deployments, configuration, or shared systems; obtain explicit authorization before performing such writes.'
  mkdir -p "$target/.github/workflows" "$target/scripts"
  cat > "$target/AGENTS.md" <<'MARKDOWN'
# Project Instructions

## Fix Bug Workflow

Reproduce database failures and run the repository validation script.

## Add Feature Workflow

Implement configuration changes without deploying them to a shared system.

## Review Release Workflow

Review the change and keep deployment approval explicit.

## Known Gotcha

Never infer database, deployment, configuration, or shared-system write authority from local task scope.
MARKDOWN
  printf 'name: verify\n' > "$target/.github/workflows/verify.yml"
  printf '#!/usr/bin/env bash\nset -euo pipefail\n' > "$target/scripts/check-project.sh"
  chmod +x "$target/scripts/check-project.sh"

  bash "$ROOT/scripts/scaffold-downstream.sh" \
    --target "$target" --name "$name" --summary "$summary" --apply >/dev/null

  [[ -f "$manifest" ]]
  grep -qF -- '- path: workflows/task-closure.md' "$manifest"
  grep -qF -- "$permission_anchor" "$skill/rules/project-rules.md"
  grep -qF -- 'file: rules/project-rules.md' "$manifest"
  grep -qF -- "$permission_anchor" "$manifest"
  [[ ! -e "$skill/references/permission-model.md" ]]
  bash "$checker" "$skill" --conformance "$manifest" >/dev/null

  mv "$skill/workflows/task-closure.md" \
    "$skill/workflows/task-closure.md.validation-missing"
  set +e
  output="$(bash "$checker" "$skill" --conformance "$manifest" 2>&1)"
  status=$?
  set -e
  mv "$skill/workflows/task-closure.md.validation-missing" \
    "$skill/workflows/task-closure.md"
  [[ "$status" -eq 1 && "$output" == *"workflows/task-closure.md <- MISSING"* ]] || {
    printf '%s\n' "$output" >&2
    echo "deleting an actually emitted required file did not fail conformance" >&2
    return 1
  }

  cp "$skill/rules/project-rules.md" "$tmp/project-rules.base.md"
  perl -0pi -e 's/Task scope does not automatically grant external write authority for databases, deployments, configuration, or shared systems; obtain explicit authorization before performing such writes\.//g' \
    "$skill/rules/project-rules.md"
  set +e
  output="$(bash "$checker" "$skill" --conformance "$manifest" 2>&1)"
  status=$?
  set -e
  cp "$tmp/project-rules.base.md" "$skill/rules/project-rules.md"
  [[ "$status" -eq 1 && "$output" == *"rules/project-rules.md <- MISSING: $permission_anchor"* ]] || {
    printf '%s\n' "$output" >&2
    echo "removing the permission anchor did not fail for its fitted rule" >&2
    return 1
  }

  # Control: one recurring local procedure justifies Folder-light owners but
  # carries no evidence of an external side effect. Permission responsibility
  # must therefore stay absent rather than becoming a universal doctrine.
  control_target="$tmp/local-procedure-project"
  control_name="local-procedure"
  control_summary="Project with one recurring formatter procedure"
  control_skill="$control_target/skills/$control_name"
  control_manifest="$control_skill/conformance.yaml"
  mkdir -p "$control_target"
  cat > "$control_target/AGENTS.md" <<'MARKDOWN'
# Project Instructions

## Formatter Procedure

Run the repository formatter before review and keep public output stable.
MARKDOWN

  control_apply="$(bash "$ROOT/scripts/scaffold-downstream.sh" \
    --target "$control_target" --name "$control_name" \
    --summary "$control_summary" --apply)"
  [[ "$control_apply" == *"APPLIED RESPONSIBILITIES: materialization=folder routed=0"* ]] || {
    printf '%s\n' "$control_apply" >&2
    echo "no-external-write control did not materialize as Folder-light" >&2
    return 1
  }
  [[ -f "$control_skill/rules/project-rules.md" ]]
  if grep -qF -- "$permission_anchor" "$control_skill/rules/project-rules.md"; then
    echo "Folder-light control received permission doctrine without external-write evidence" >&2
    return 1
  fi
  if [[ -f "$control_manifest" ]] && grep -qF -- "$permission_anchor" "$control_manifest"; then
    echo "Folder-light fitted manifest protected permission doctrine without external-write evidence" >&2
    return 1
  fi
)

# Evidence input: five existing harness Skill registries, with four matching
# formal owners and one orphaned Claude registration. Expected: every registry
# is inventoried/preserved, and the orphan produces explicit review work without
# being deleted or silently treated as a complete migration.
check_existing_skill_registries_are_preserved() (
  set -euo pipefail
  local tmp target before name summary preview apply path owner
  local registrations=(
    ".cursor/skills/cursor-helper/SKILL.md"
    ".claude/skills/orphan/SKILL.md"
    ".codex/skills/codex-helper/SKILL.md"
    ".agents/skills/agents-helper/SKILL.md"
    ".gemini/skills/gemini-helper/SKILL.md"
  )
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  target="$tmp/project"
  before="$tmp/before"
  name="registry-project"
  summary="Project with existing harness Skill registrations"
  mkdir -p "$target" "$before"

  for path in "${registrations[@]}"; do
    mkdir -p "$target/$(dirname "$path")"
    cat > "$target/$path" <<MARKDOWN
---
name: $(basename "$(dirname "$path")")
description: Existing harness registration fixture.
---

# Existing Registration

Preserve this harness-local registration during SBA migration.
MARKDOWN
  done
  for owner in cursor-helper codex-helper agents-helper gemini-helper; do
    mkdir -p "$target/skills/$owner"
    printf '# %s formal owner\n' "$owner" > "$target/skills/$owner/SKILL.md"
  done
  cp -R "$target/." "$before/"

  preview="$(bash "$ROOT/scripts/scaffold-downstream.sh" \
    --target "$target" --name "$name" --summary "$summary")"
  diff -r "$before" "$target"
  for path in "${registrations[@]}"; do
    [[ "$preview" == *"PRESERVE: $path (Agent must migrate its meaning and keep the local shell hook)"* ]] || {
      printf '%s\n' "$preview" >&2
      echo "registry was omitted from the evidence inventory: $path" >&2
      return 1
    }
  done
  [[ "$preview" == *"REVIEW: .claude/skills/orphan/SKILL.md (formal owner missing: skills/orphan/SKILL.md; preserve registration until ownership is resolved)"* ]] || {
    printf '%s\n' "$preview" >&2
    echo "missing formal owner did not create explicit registry review work" >&2
    return 1
  }

  apply="$(bash "$ROOT/scripts/scaffold-downstream.sh" \
    --target "$target" --name "$name" --summary "$summary" --apply)"
  [[ "$apply" == *"REVIEW: .claude/skills/orphan/SKILL.md"* ]]
  for path in "${registrations[@]}"; do
    cmp "$before/$path" "$target/$path"
  done
  for owner in cursor-helper codex-helper agents-helper gemini-helper; do
    cmp "$before/skills/$owner/SKILL.md" "$target/skills/$owner/SKILL.md"
  done
)

# Evidence input: a routed Skill and Cursor registration begin with identical
# descriptions, then only the formal SKILL.md activation text changes. Expected:
# --check reports drift, normal sync repairs Cursor frontmatter, and registration-
# specific body content remains intact.
check_cursor_description_sync_contract() (
  set -euo pipefail
  local tmp skill cursor sync output status
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  skill="$tmp/skills/description-skill"
  cursor="$tmp/.cursor/skills/description-skill/SKILL.md"
  sync="$ROOT/templates/skill/scripts/sync-routing.sh"
  mkdir -p "$skill/workflows" "$(dirname "$cursor")"
  cat > "$skill/SKILL.md" <<'MARKDOWN'
---
name: description-skill
description: >
  This skill should be used when the user asks to "inspect the old activation",
  "maintain description routing", or "检查旧触发描述". Activate for the routed
  description synchronization fixture.
---

# Description Skill

## Always Read

<!-- ALWAYS_READ_START -->
<!-- ALWAYS_READ_END -->

## Common Tasks

<!-- ROUTING_SUMMARY_START -->
<!-- ROUTING_SUMMARY_END -->

## Known Gotchas

- Keep the formal and Cursor descriptions identical.
MARKDOWN
  cat > "$skill/routing.yaml" <<'YAML'
always_read: []
tasks:
  - id: inspect
    labels: { en: Inspect, zh: 检查 }
    workflow: workflows/inspect.md
    trigger_examples: [inspect activation, 检查触发]
  - id: other
    labels: { en: Other, zh: 其他 }
    workflow: workflows/inspect.md
    trigger_examples: [other task, 其他任务]
YAML
  printf '# Inspect\n\nInspect the routed activation.\n' > "$skill/workflows/inspect.md"
  cat > "$cursor" <<'MARKDOWN'
---
name: description-skill
description: >
  This skill should be used when the user asks to "inspect the old activation",
  "maintain description routing", or "检查旧触发描述". Activate for the routed
  description synchronization fixture.
---

# Cursor Registration

CURSOR-SPECIFIC-SENTINEL: preserve this registration body.

<!-- ROUTING_BOOTSTRAP_START -->
<!-- ROUTING_BOOTSTRAP_END -->
MARKDOWN

  bash "$sync" "$skill" >/dev/null
  perl -0pi -e 's/inspect the old activation/inspect the new canonical activation/' \
    "$skill/SKILL.md"
  set +e
  output="$(bash "$sync" "$skill" --check 2>&1)"
  status=$?
  set -e
  [[ "$status" -eq 1 && "$output" == *"DRIFT:"* && "$output" == *".cursor/skills/description-skill/SKILL.md"* ]] || {
    printf '%s\n' "$output" >&2
    echo "Cursor description drift was not reported in check mode" >&2
    return 1
  }

  bash "$sync" "$skill" >/dev/null
  grep -qF 'inspect the new canonical activation' "$cursor"
  grep -qF 'CURSOR-SPECIFIC-SENTINEL: preserve this registration body.' "$cursor"
  bash "$sync" "$skill" --check >/dev/null
)

# App Skills are installed beneath a harness-owned `skills/` registry. A
# reference from one formal Skill to another is relative to that harness root,
# even when --workspace-root points at the surrounding iteration directory.
check_harness_relative_skill_paths_resolve() (
  set -euo pipefail
  local tmp harness primary secondary smoke output
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  harness="$tmp/.codex"
  primary="$harness/skills/primary"
  secondary="$harness/skills/secondary"
  smoke="$ROOT/templates/skill/scripts/smoke-test.sh"
  mkdir -p "$primary/workflows" "$secondary"
  cat > "$primary/SKILL.md" <<'MARKDOWN'
---
name: primary
description: >
  This skill should be used when the user asks to "inspect installed skills",
  "follow a sibling skill owner", or "检查已安装 Skill". Activate for harness
  registries whose formal owners live below the current skills directory.
---

# Primary

## Common Tasks

- Sibling owner: read `workflows/run.md`.
- Other: use the same harness-relative owner rule.

## Known Gotchas

- The workspace root and harness registry root are distinct boundaries.
MARKDOWN
  cat > "$primary/workflows/run.md" <<'MARKDOWN'
# Run

Read `skills/secondary/SKILL.md` before reporting the sibling owner.
MARKDOWN
  cat > "$secondary/SKILL.md" <<'MARKDOWN'
---
name: secondary
description: >
  This skill should be used when the user asks to "read the secondary owner",
  "inspect sibling registration", or "读取相邻 Skill". Activate for the
  secondary installed owner used by the harness-relative fixture.
---

# Secondary

## Common Tasks

- Owner check: report this file.
- Other: report this file.

## Known Gotchas

- This owner is intentionally outside the primary Skill directory.
MARKDOWN

  output="$(cd "$harness" && bash "$smoke" primary --phase 7 --workspace-root "$tmp")"
  [[ "$output" == *"Local links, inline paths, and heading fragments resolve"* ]]
)

# A self-hosting Skill may keep its formal owner at the project root. Invoking
# smoke by the Skill's frontmatter name must not fall through to skills/<name>.
check_self_hosting_skill_root_resolves_by_name() (
  set -euo pipefail
  local tmp smoke output
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  smoke="$ROOT/templates/skill/scripts/smoke-test.sh"
  mkdir -p "$tmp/references" "$tmp/workflows" "$tmp/scripts" "$tmp/.cursor/rules"
  cat > "$tmp/SKILL.md" <<'MARKDOWN'
---
name: self-hosting-contract
description: >
  This skill should be used when the user asks to "inspect a self-hosting Skill",
  "validate root-owned formal docs", or "检查自托管 Skill". Activate when the
  formal Skill owner intentionally lives at the repository root.
---

# Self-Hosting Contract

## Common Tasks

- Root owner check: read [the fitted workflow](workflows/full-migration.md).
- Other: use the same root-owned formal documentation.

## Known Gotchas

- The project root, not `skills/self-hosting-contract`, owns this Skill.
MARKDOWN
  cat > "$tmp/references/self-hosting-routing.yaml" <<'YAML'
tasks:
  - id: migrate
    workflow: workflows/full-migration.md
YAML
  cat > "$tmp/references/protocols.md" <<'MARKDOWN'
# Protocols

Use the fitted completion proof.
MARKDOWN
  cat > "$tmp/workflows/full-migration.md" <<'MARKDOWN'
# Full Migration

Read `references/protocols.md` before completion.
MARKDOWN
  cat > "$tmp/AGENTS.md" <<'MARKDOWN'
# Agent Instructions

Formal docs live at repo root. Read `SKILL.md` first, then read
`references/self-hosting-routing.yaml`; the migration route owns
`workflows/full-migration.md` and completion uses `references/protocols.md`.
MARKDOWN
  cat > "$tmp/.cursor/rules/workflow.mdc" <<'MARKDOWN'
# Cursor Workflow

Read `SKILL.md` and `references/self-hosting-routing.yaml` before routing.
MARKDOWN
  cat > "$tmp/scripts/check-self-shells.sh" <<'SHELL'
#!/usr/bin/env bash
set -euo pipefail
test -f references/self-hosting-routing.yaml
SHELL
  chmod +x "$tmp/scripts/check-self-shells.sh"

  output="$(cd "$tmp" && bash "$smoke" self-hosting-contract --phase 7 --workspace-root "$tmp")"
  [[ "$output" == *"Local links, inline paths, and heading fragments resolve"* ]]
  [[ "$output" != *"(missing $tmp/skills/self-hosting-contract"* ]]
)

# Optional-owner guidance and examples in HTML comments are authoring context,
# not live downstream dependencies. Missing paths inside those comments must not
# fail the fitted local-reference scan.
check_html_comments_are_not_live_references() (
  set -euo pipefail
  local tmp skill smoke output
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  skill="$tmp/skills/comment-contract"
  smoke="$ROOT/templates/skill/scripts/smoke-test.sh"
  mkdir -p "$skill"
  cat > "$skill/SKILL.md" <<'MARKDOWN'
---
name: comment-contract
description: >
  This skill should be used when the user asks to "validate optional examples",
  "inspect commented owners", or "检查注释示例". Activate for downstream
  documentation whose author-only HTML comments must not become live paths.
---

# Comment Contract

## Common Tasks

- Comment check: run the fitted reference scan and preserve author examples as comments.
- Other: inspect only materialized owners.

## Known Gotchas

<!-- OPTIONAL: Read `references/not-materialized.md` only after a real owner is admitted. -->
<!-- e.g. See [Example owner](references/example-owner.md#example-section). -->
MARKDOWN

  output="$(cd "$tmp" && bash "$smoke" comment-contract --phase 7 --workspace-root "$tmp")"
  [[ "$output" == *"Local links, inline paths, and heading fragments resolve"* ]]
)

# Namespaced references are rooted capabilities, not permission to traverse out
# of either owner. Existing files outside the roots must not launder ../ escapes.
check_namespaced_path_escapes_are_rejected() (
  set -euo pipefail
  local tmp workspace skill code_root smoke sync reach output smoke_status skill_status code_status
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  workspace="$tmp/workspace"
  skill="$workspace/skills/escape-contract"
  code_root="$workspace/code/skills/escape-contract"
  smoke="$ROOT/templates/skill/scripts/smoke-test.sh"
  sync="$ROOT/templates/skill/scripts/sync-routing.sh"
  reach="$ROOT/templates/skill/scripts/route-reachability.sh"
  mkdir -p "$skill/workflows" "$code_root" "$workspace/skills" "$workspace/code/skills"
  printf '# Outside skill root\n' > "$workspace/skills/outside.md"
  printf '# Outside code root\n' > "$workspace/code/skills/outside.md"
  cat > "$skill/SKILL.md" <<'MARKDOWN'
---
name: escape-contract
description: >
  This skill should be used when the user asks to "validate owner boundaries",
  "inspect namespaced paths", or "检查路径越界". Activate for two-root routing
  whose skill and code references must remain inside their declared owners.
---

# Escape Contract

## Always Read

<!-- ALWAYS_READ_START -->
<!-- ALWAYS_READ_END -->

## Common Tasks

<!-- ROUTING_SUMMARY_START -->
<!-- ROUTING_SUMMARY_END -->

## Known Gotchas

- Never accept an existing file outside a declared owner root.

## Escape Probe

Read `skill:../outside.md` and `code:../outside.md` before the probe.
MARKDOWN
  cat > "$skill/routing.yaml" <<'YAML'
path_resolution:
  skill_root: { owns: [SKILL.md, routing.yaml, workflows/**] }
  code_root:
    root: code/skills/escape-contract
    owns: [references/**]
always_read: []
tasks:
  - id: probe
    labels: { en: Probe paths, zh: 检查路径 }
    workflow: workflows/run.md
    trigger_examples: [probe paths, 检查路径]
  - id: other
    labels: { en: Other, zh: 其他 }
    workflow: workflows/run.md
    trigger_examples: [other task, 其他任务]
YAML
  printf '# Run\n\nRun the owner-boundary probe.\n' > "$skill/workflows/run.md"
  bash "$sync" "$skill" --workspace-root "$workspace" >/dev/null

  set +e
  output="$(cd "$workspace" && bash "$smoke" escape-contract --phase 7 --workspace-root "$workspace" 2>&1)"
  smoke_status=$?
  set -e
  [[ "$smoke_status" -eq 1 && "$output" == *"skill:../outside.md"* && "$output" == *"code:../outside.md"* ]] || {
    printf '%s\n' "$output" >&2
    echo "smoke accepted a namespaced path escape" >&2
    return 1
  }

  perl -0pi -e 's/always_read: \[\]/always_read:\n  - skill:workflows\/\.\.\/\.\.\/outside.md\n  - code:references\/\.\.\/\.\.\/outside.md/' \
    "$skill/routing.yaml"
  perl -0pi -e 's/workflow: workflows\/run\.md/workflow: skill:workflows\/run.md/g' \
    "$skill/routing.yaml"
  set +e
  output="$(cd "$skill" && bash "$reach" --namespace skill --routing "$skill/routing.yaml" 2>&1)"
  skill_status=$?
  set -e
  [[ "$skill_status" -eq 1 && "$output" == *"INVALID"* && "$output" == *"../outside.md"* ]] || {
    printf '%s\n' "$output" >&2
    echo "skill reachability accepted a ../ escape" >&2
    return 1
  }
  set +e
  output="$(cd "$code_root" && bash "$reach" --namespace code --routing "$skill/routing.yaml" 2>&1)"
  code_status=$?
  set -e
  [[ "$code_status" -eq 1 && "$output" == *"INVALID"* && "$output" == *"../outside.md"* ]] || {
    printf '%s\n' "$output" >&2
    echo "code reachability accepted a ../ escape" >&2
    return 1
  }
)

# A missing owner in one formal Skill cannot be satisfied by a same-relative
# path that happens to exist under another harness registration Skill.
check_registration_owners_do_not_cross_resolve() (
  set -euo pipefail
  local tmp skill smoke output status
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  skill="$tmp/skills/primary-skill"
  smoke="$ROOT/templates/skill/scripts/smoke-test.sh"
  mkdir -p "$skill" "$tmp/.cursor/skills/unrelated-skill/references"
  cat > "$skill/SKILL.md" <<'MARKDOWN'
---
name: primary-skill
description: >
  This skill should be used when the user asks to "validate owner isolation",
  "inspect registration references", or "检查注册隔离". Activate when local
  references must resolve only inside the selected formal Skill owner.
---

# Primary Skill

## Common Tasks

- Owner check: read [the primary owner](references/shared.md).
- Other: report the missing primary owner without searching another Skill.

## Known Gotchas

- Same-relative paths in another registration are not substitutes.
MARKDOWN
  printf '# Unrelated registration owner\n' \
    > "$tmp/.cursor/skills/unrelated-skill/references/shared.md"

  set +e
  output="$(cd "$tmp" && bash "$smoke" primary-skill --phase 7 --workspace-root "$tmp" 2>&1)"
  status=$?
  set -e
  [[ "$status" -eq 1 && "$output" == *"references/shared.md"* && "$output" == *"missing"* ]] || {
    printf '%s\n' "$output" >&2
    echo "smoke resolved a missing owner through another registration Skill" >&2
    return 1
  }
)

# required_files paths are owned by the selected Skill root. A reason cannot
# make parent traversal valid even when the escaped target exists.
check_required_files_path_escape_is_rejected() (
  set -euo pipefail
  local tmp skill manifest checker output status
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  skill="$tmp/skills/path-escape"
  manifest="$skill/conformance.yaml"
  checker="$ROOT/templates/skill/scripts/check-version-conformance.sh"
  mkdir -p "$skill"
  printf '# Path Escape\n' > "$skill/SKILL.md"
  printf '# Outside\n' > "$tmp/skills/outside.md"
  cat > "$manifest" <<'YAML'
required_files:
  - path: ../outside.md
    reason: Existing outside file must not satisfy a Skill-root contract.
YAML

  set +e
  output="$(bash "$checker" "$skill" --conformance "$manifest" 2>&1)"
  status=$?
  set -e
  [[ "$status" -eq 2 && "$output" == *"conformance schema error"* ]] || {
    printf '%s\n' "$output" >&2
    echo "required_files accepted a path escaping the Skill root" >&2
    return 1
  }
)

# Commented YAML examples are not routing edges. An otherwise-unreferenced file
# named only in a routing comment must remain unreachable.
check_routing_comments_do_not_seed_reachability() (
  set -euo pipefail
  local tmp skill reach output status
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  skill="$tmp/skill"
  reach="$ROOT/templates/skill/scripts/route-reachability.sh"
  mkdir -p "$skill/workflows" "$skill/references"
  printf '# Run\n' > "$skill/workflows/run.md"
  printf '# Hidden owner\n' > "$skill/references/hidden.md"
  cat > "$skill/routing.yaml" <<'YAML'
# Example only: references/hidden.md
tasks:
  - id: run
    workflow: workflows/run.md
YAML

  set +e
  output="$(cd "$skill" && bash "$reach" 2>&1)"
  status=$?
  set -e
  [[ "$status" -eq 1 && "$output" == *"UNREACHED  references/hidden.md"* ]] || {
    printf '%s\n' "$output" >&2
    echo "routing.yaml comment text became a reachability seed" >&2
    return 1
  }
)

# GitHub preserves every separator hyphen produced by spaces and punctuation;
# `A - B` therefore resolves to #a---b, not a collapsed #a-b slug.
check_github_slug_preserves_consecutive_hyphens() (
  set -euo pipefail
  local tmp skill smoke output
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  skill="$tmp/skills/slug-contract"
  smoke="$ROOT/templates/skill/scripts/smoke-test.sh"
  mkdir -p "$skill/references"
  cat > "$skill/SKILL.md" <<'MARKDOWN'
---
name: slug-contract
description: >
  This skill should be used when the user asks to "validate heading anchors",
  "inspect GitHub slugs", or "检查标题锚点". Activate for Markdown references
  whose punctuation must follow GitHub heading-fragment behavior exactly.
---

# Slug Contract

## Common Tasks

- Fragment check: read [A - B](references/sections.md#a---b).
- Other: run the same fitted reference scan.

## Known Gotchas

- Consecutive separator hyphens are significant.
MARKDOWN
  cat > "$skill/references/sections.md" <<'MARKDOWN'
# Sections

## A - B

The GitHub-compatible fragment contains three consecutive hyphens.
MARKDOWN

  output="$(cd "$tmp" && bash "$smoke" slug-contract --phase 7 --workspace-root "$tmp")"
  [[ "$output" == *"fragments=1"* ]]
)

# required_files is a mapping contract, not a key-order contract. A useful
# reason may appear before path without suppressing the existence assertion.
check_reason_first_required_files_mapping() (
  set -euo pipefail
  local tmp skill manifest checker output
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  skill="$tmp/skills/reason-first"
  manifest="$skill/conformance.yaml"
  checker="$ROOT/templates/skill/scripts/check-version-conformance.sh"
  mkdir -p "$skill"
  printf '# Reason First\n' > "$skill/SKILL.md"
  cat > "$manifest" <<'YAML'
required_files:
  - reason: Primary formal owner for this fitted result.
    path: SKILL.md
YAML

  output="$(bash "$checker" "$skill" --conformance "$manifest")"
  [[ "$output" == *"SKILL.md <- exists"* && "$output" == *"0 failed"* ]]
)

# The smoke scanner must stream or batch discovered files. Passing every path in
# argv makes a large but valid Markdown tree fail before Python can inspect it.
check_many_markdown_files_do_not_hit_arg_max() (
  set -euo pipefail
  local tmp skill smoke output arg_max approximate_path_bytes file_count index long_name
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  skill="$tmp/skills/arg-max-contract"
  smoke="$ROOT/templates/skill/scripts/smoke-test.sh"
  mkdir -p "$skill/references/bulk"
  cat > "$skill/SKILL.md" <<'MARKDOWN'
---
name: arg-max-contract
description: >
  This skill should be used when the user asks to "scan a large documentation tree",
  "validate many Markdown owners", or "检查大量文档". Activate when fitted
  reference integrity must remain independent of operating-system argv limits.
---

# Arg Max Contract

## Common Tasks

- Large scan: run fitted local-reference integrity across every Markdown owner.
- Other: use the same streamed file inventory.

## Known Gotchas

- File discovery volume must not become one process argument list.
MARKDOWN
  arg_max="$(getconf ARG_MAX 2>/dev/null || printf '1048576')"
  approximate_path_bytes=190
  file_count=$((arg_max / approximate_path_bytes + 512))
  [[ "$file_count" -le 14000 ]] || file_count=14000
  long_name="$(printf '%0120d' 0 | tr '0' 'x')"
  for ((index = 0; index < file_count; index++)); do
    printf '# Bulk owner %s\n' "$index" \
      > "$skill/references/bulk/$long_name-$index.md"
  done

  output="$(cd "$tmp" && bash "$smoke" arg-max-contract --phase 7 --workspace-root "$tmp")"
  [[ "$output" == *"Local links, inline paths, and heading fragments resolve"* ]]
)

if check_single_file_skill; then
  pass "valid Single-file Skill passes without Full-only files"
else
  fail "valid Single-file Skill was rejected by Full-shape assumptions"
fi

if check_folder_light_fitted_shapes; then
  pass "Folder-light direct and conditionally routed shapes use fitted validation"
else
  fail "Folder-light validation still assumes absent Full or routing surfaces"
fi

if check_complete_declared_surfaces; then
  pass "complete fixture keeps every declared Full responsibility strict"
else
  fail "adaptive validation weakened a declared Full responsibility"
fi

if check_unresolved_and_laundered_fill_are_rejected; then
  pass "FILL residue and renamed FILLED markers are rejected for their actual reason"
else
  fail "unresolved migration markers can still be laundered or fail only incidentally"
fi

if check_migration_evidence_contract; then
  pass "source clauses require one disposition, activation, and explicit rewrite review"
else
  fail "migration evidence did not distinguish stored text from activated or reviewed migration"
fi

if check_scalar_required_files_are_rejected; then
  pass "scalar required_files manifests are rejected as schema errors"
else
  fail "scalar required_files can still bypass file-existence checks"
fi

if check_inline_paths_and_heading_fragments; then
  pass "inline paths and heading fragments fail on the exact missing target"
else
  fail "local-reference validation still ignores code spans, anchors, or example boundaries"
fi

if check_materialized_required_files_and_permission_anchor; then
  pass "actual emitted required files and permission semantics are mutation-protected"
else
  fail "materialized conformance does not protect emitted owners and external-write authority"
fi

if check_existing_skill_registries_are_preserved; then
  pass "existing harness Skill registries are inventoried, preserved, and reviewed when orphaned"
else
  fail "existing harness Skill registrations can be omitted or silently lose ownership"
fi

if check_cursor_description_sync_contract; then
  pass "routing sync detects and repairs Cursor description drift without replacing registration content"
else
  fail "Cursor activation description remains a drifting hand-maintained copy"
fi

if check_harness_relative_skill_paths_resolve; then
  pass "installed skills/... references resolve from the active harness registry root"
else
  fail "installed sibling Skill references are incorrectly resolved from the workspace root"
fi

if check_self_hosting_skill_root_resolves_by_name; then
  pass "self-hosting Skills invoked by name resolve their root formal owner"
else
  fail "self-hosting root owners fall through to a nonexistent skills/<name> directory"
fi

if check_html_comments_are_not_live_references; then
  pass "optional-owner and HTML-comment examples do not become live references"
else
  fail "commented author examples are still treated as materialized owners"
fi

if check_namespaced_path_escapes_are_rejected; then
  pass "smoke and reachability reject skill:/code: paths that escape their owner roots"
else
  fail "namespaced ../ paths can escape a declared owner root"
fi

if check_registration_owners_do_not_cross_resolve; then
  pass "smoke does not satisfy a missing owner from another registration Skill"
else
  fail "registration globbing can cross-resolve an unrelated Skill owner"
fi

if check_required_files_path_escape_is_rejected; then
  pass "conformance rejects required_files paths that escape the Skill root"
else
  fail "required_files can validate an owner outside the fitted Skill root"
fi

if check_routing_comments_do_not_seed_reachability; then
  pass "routing.yaml comments do not create reachability seeds"
else
  fail "comment-only routing paths can make dead owners look reachable"
fi

if check_github_slug_preserves_consecutive_hyphens; then
  pass "heading fragments follow GitHub consecutive-hyphen slug behavior"
else
  fail "heading slug normalization collapses significant consecutive hyphens"
fi

if check_reason_first_required_files_mapping; then
  pass "reason-first required_files mappings retain their path assertion"
else
  fail "required_files mapping validity still depends on key order"
fi

if check_many_markdown_files_do_not_hit_arg_max; then
  pass "large Markdown inventories are scanned without an argv-sized file list"
else
  fail "large Markdown inventories can still fail at the operating-system ARG_MAX boundary"
fi

printf '\nValidation contract results: %s passed, %s failed\n' "$PASS" "$FAIL"
[[ "$FAIL" -eq 0 ]]
