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

declared_complete_surfaces() {
  local name="$1"
  printf '%s\n' \
    "skills/$name/SKILL.md" \
    "skills/$name/routing.yaml" \
    "skills/$name/conformance.yaml" \
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

printf '\nValidation contract results: %s passed, %s failed\n' "$PASS" "$FAIL"
[[ "$FAIL" -eq 0 ]]
