#!/usr/bin/env bash
# Minimal self-hosting scenario checks for high-risk routes.
#
# These are transcript-shaped route proofs, not a general scenario harness:
# user phrase -> routing manifest row -> required reads + workflow.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

PASS=0
FAIL=0

pass() { PASS=$((PASS+1)); echo "PASS: $1"; }
fail() { FAIL=$((FAIL+1)); echo "FAIL: $1"; }

task_block() {
  local manifest="$1" id="$2"
  awk -v id="$id" '
    /^[[:space:]]*-[[:space:]]id:/ {
      current=$0
      sub(/^[[:space:]]*-[[:space:]]id:[[:space:]]*/, "", current)
      in_task=(current==id)
    }
    in_task { print }
  ' "$manifest"
}

required_reads_block() {
  local manifest="$1" id="$2"
  task_block "$manifest" "$id" | awk '
    /^[[:space:]]*required_reads:/ { in_reads=1; next }
    in_reads && /^    [a-z_]+:/ { exit }
    in_reads { print }
  '
}

assert_contains() {
  local block="$1" needle="$2" label="$3"
  if printf '%s\n' "$block" | grep -qF "$needle"; then
    pass "$label contains $needle"
  else
    fail "$label missing $needle"
  fi
}

assert_not_contains() {
  local block="$1" needle="$2" label="$3"
  if printf '%s\n' "$block" | grep -qF "$needle"; then
    fail "$label unexpectedly contains $needle"
  else
    pass "$label excludes $needle"
  fi
}

check_scenario() {
  local name="$1" manifest="$2" prompt="$3" route="$4" workflow="$5"
  shift 5
  local block
  block="$(task_block "$manifest" "$route")"

  echo ""
  echo "==> $name"
  if [[ -z "$block" ]]; then
    fail "$name route $route missing"
    return
  fi

  assert_contains "$block" "$prompt" "$name trigger_examples"
  assert_contains "$block" "workflow: $workflow" "$name workflow"

  local read_path
  for read_path in "$@"; do
    assert_contains "$block" "$read_path" "$name required_reads"
  done
}

echo "Self-hosting Scenario Checks"
echo "============================"

check_scenario \
  "edit templates" \
  "references/self-hosting-routing.yaml" \
  "修改 templates" \
  "edit-templates" \
  "templates/skill/workflows/edit-templates.md" \
  "SKILL.md" \
  "templates/README.md" \
  "templates/ANTI-TEMPLATES.md"

check_scenario \
  "improve activation routing" \
  "references/self-hosting-routing.yaml" \
  "优化 routing.yaml" \
  "improve-activation-routing" \
  "references/layout.md#description-as-trigger-condition" \
  "SKILL.md" \
  "references/layout.md"

assert_contains \
  "$(task_block references/self-hosting-routing.yaml improve-activation-routing)" \
  "Load references/multi-skill-routing.md only when evidence shows multiple skills" \
  "improve activation routing conditional multi-skill read"
assert_not_contains \
  "$(required_reads_block references/self-hosting-routing.yaml improve-activation-routing)" \
  "references/multi-skill-routing.md" \
  "improve activation routing initial reads"

check_scenario \
  "draft plan without distillation preload" \
  "references/self-hosting-routing.yaml" \
  "制定一个 plan" \
  "plan-feature" \
  "templates/skill/workflows/plan-feature.md" \
  "SKILL.md" \
  "docs/plans/README.md"

assert_not_contains \
  "$(required_reads_block references/self-hosting-routing.yaml plan-feature)" \
  "templates/skill/workflows/update-rules.md" \
  "draft plan initial reads"

check_scenario \
  "SBA product direction" \
  "references/self-hosting-routing.yaml" \
  "SBA 应该往什么方向发展" \
  "product-direction" \
  "templates/skill/workflows/plan-feature.md" \
  "SKILL.md" \
  "docs/sba-bible.md" \
  "docs/plans/README.md"

product_direction="$(task_block references/self-hosting-routing.yaml product-direction)"
assert_contains "$product_direction" "吸收一个外部项目" "SBA product direction external-project trigger"
assert_contains "$product_direction" "增加一个重大机制" "SBA product direction major-mechanism trigger"
assert_contains "$product_direction" "ordinary coding and downstream tasks do not load it" "SBA product direction scope boundary"

check_scenario \
  "distill plan conclusions" \
  "references/self-hosting-routing.yaml" \
  "把 plan 的结论沉淀下来" \
  "distill-plan-conclusions" \
  "templates/skill/workflows/update-rules.md" \
  "SKILL.md" \
  "docs/plans/README.md"

# update-upstream relies on always_read for rules (project-rules etc.); its
# required_reads is intentionally route-specific-only, so this proves the
# high-risk part: the trigger phrase reaches the update-upstream workflow.
check_scenario \
  "downstream upstream refresh" \
  "templates/skill/routing.yaml" \
  "上游项目更新了,帮我更新一下" \
  "update-upstream" \
  "workflows/update-upstream.md"

check_scenario \
  "classify record before evidence load" \
  "templates/skill/routing.yaml" \
  "把这次踩坑记下来" \
  "update-rules" \
  "workflows/update-rules.md"

assert_contains \
  "$(task_block templates/skill/routing.yaml update-rules)" \
  "never preload both evidence stores" \
  "update-rules conditional evidence selection"
assert_not_contains \
  "$(required_reads_block templates/skill/routing.yaml update-rules)" \
  "references/gotchas.md" \
  "update-rules initial gotcha read"
assert_not_contains \
  "$(required_reads_block templates/skill/routing.yaml update-rules)" \
  "references/behavior-failures.md" \
  "update-rules initial behavior-failure read"

echo ""
echo "==> task execution contracts"

clarity_gate="$(<templates/skill/protocol-blocks/ambiguous-request-gate.md)"
assert_contains "$clarity_gate" "Vague wording is a signal, not an automatic blocker" "request clarity uncertainty signal"
assert_contains "$clarity_gate" "smallest read-only evidence set" "request clarity evidence-first discovery"
assert_contains "$clarity_gate" "normative product or business preference" "request clarity owner-question boundary"
assert_contains "$clarity_gate" "Do not mutate until the requested outcome is concrete enough to verify" "request clarity mutation stop"
assert_not_contains "$clarity_gate" "Let me scan the project first, then ask" "request clarity old lexical stop"

for shell in \
  templates/shells/AGENTS.md \
  templates/shells/CLAUDE.md \
  templates/shells/CODEX.md \
  templates/shells/GEMINI.md \
  templates/shells/.cursor/rules/workflow.mdc; do
  shell_content="$(<"$shell")"
  assert_contains "$shell_content" "Request-clarity judgment" "$shell clarity activation"
  assert_contains "$shell_content" "vague wording is a signal, not an automatic blocker" "$shell evidence-first summary"
  assert_not_contains "$shell_content" "stop and ask for scope" "$shell old lexical stop"
done

task_execution="$(<templates/skill/workflows/task-execution.md)"
assert_contains "$task_execution" "Simple tasks skip this protocol" "task execution Simple no-ceremony boundary"
assert_contains "$task_execution" "After any needed alignment, proceed without waiting unless" "task execution auto-start default"
assert_contains "$task_execution" "harness's native Plan/Task surface" "task execution native plan preference"
assert_contains "$task_execution" "runtime state, not a fixed chat template" "task execution state-presentation boundary"
assert_contains "$task_execution" "natural-language alignment" "task execution default natural presentation"
assert_contains "$task_execution" "do not repeat its steps in chat" "task execution no native-plan duplication"
assert_contains "$task_execution" "## Presentation Gate" "task execution presentation selection gate"
assert_contains "$task_execution" "Evaluate **Structured Brief first**" "task execution structured-first precedence"
assert_contains "$task_execution" "Compact Alignment is allowed only when all Structured conditions are false" "task execution compact fallback boundary"
assert_contains "$task_execution" "first user-facing task-start message MUST begin with separate Goal" "task execution full brief escalation"
assert_contains "$task_execution" "Steps must be numbered" "task execution full brief numbered plan"
assert_contains "$task_execution" "do not collapse the brief into prose" "task execution full brief remains scannable"
assert_contains "$task_execution" "## Recitation Loop" "task execution recitation section"
assert_contains "$task_execution" "Before each main Plan step" "task execution per-step Anchor checkpoint"
assert_contains "$task_execution" "source Plan path" "task execution design-source handoff"
assert_contains "$task_execution" "only business-bearing decisions require a routed business rule" "task execution technical-plan business-leaf boundary"
assert_contains "$task_execution" "## User Decision Drift Gate" "task execution immediate user-drift gate"
assert_contains "$task_execution" "canonical owner of the gate's trigger" "task execution canonical drift owner"
assert_contains "$task_execution" "Pause the affected implementation path immediately" "task execution drift pauses affected path"
assert_contains "$task_execution" "Independent work may continue only when it cannot prejudge the decision" "task execution affected-path concurrency boundary"
assert_contains "$task_execution" 'Mark every alternative `proposed`' "task execution proposed-alternative transition"
assert_contains "$task_execution" 'mark the prior decision `superseded`' "task execution superseded-mainline transition"
assert_contains "$task_execution" "never treat a late disclosure in review/Closure" "task execution rejects deferred drift disclosure"
assert_contains "$task_execution" "do not narrate it before every tool call" "task execution no per-tool narration"
assert_contains "$task_execution" "does not create durable planning files or recover task state across Sessions" "task execution session-only boundary"
assert_contains "$task_execution" "new independent outcome -> re-match the route and replace the old Anchor/Plan" "task execution new-task reset"
assert_contains "$task_execution" "cannot omit or reorder a mandatory gate" "task execution Workflow authority"
assert_not_contains "$task_execution" "task_plan.md" "task execution no fixed task-plan file"
assert_not_contains "$task_execution" "cross-tool state sync" "task execution no cross-tool state system"
assert_not_contains "$task_execution" "Plan: <concise task-specific steps" "task execution no fixed chat block"

agent_behavior="$(<templates/skill/rules/agent-behavior.md)"
assert_contains "$agent_behavior" "## 2. Semantic Completeness Before Minimality" "always-read semantic completeness precedence"
assert_contains "$agent_behavior" "Default to **Product Development**" "always-read development default"
assert_contains "$agent_behavior" "state ownership/provenance" "always-read ownership trace"
assert_contains "$agent_behavior" "full/incremental/read/write path" "always-read all-path trace"
assert_contains "$agent_behavior" "Dependency count is risk evidence, not a veto" "always-read dependency-count boundary"
assert_contains "$agent_behavior" "Enter **Operational Stabilization** only when" "always-read operational exception"
assert_contains "$agent_behavior" "One clear action with one direct check proceeds without planning ceremony" "always-read Simple direct path"
assert_contains "$agent_behavior" "task-execution.md" "always-read Task Execution activation"
assert_contains "$agent_behavior" "present only useful alignment" "always-read proportional Anchor presentation"
assert_contains "$agent_behavior" "without duplicating visible steps in chat" "always-read native Plan deduplication"
assert_contains "$agent_behavior" "Before every main Plan step" "always-read Anchor checkpoint activation"

task_closure="$(<templates/skill/workflows/task-closure.md)"
assert_contains "$task_closure" "### Entry Gate" "closure execution entry gate"
assert_contains "$task_closure" 'return to [`task-execution.md`](task-execution.md)' "closure cannot finish execution"
assert_contains "$task_closure" "final Anchor Checkpoint" "closure final Anchor checkpoint"
assert_contains "$task_closure" "Replay the user-confirmed mainline" "closure decision-mainline replay"
assert_contains "$task_closure" "Closure owns final reconciliation" "closure reconciliation owner"
assert_contains "$task_closure" "first time a material drift is surfaced" "closure rejects first drift disclosure"
assert_contains "$task_closure" "for business-bearing decisions, also read the routed business rule" "closure optional business-leaf boundary"
assert_contains "$task_closure" "task-execution.md#user-decision-drift-gate" "closure drift-owner link"

plan_feature="$(<templates/skill/workflows/plan-feature.md)"
assert_contains "$plan_feature" "it is not the runtime Native Plan" "design plan runtime boundary"
assert_contains "$plan_feature" "pass its chosen outcome, acceptance criteria, boundaries, and task breakdown" "design to execution transition"
assert_contains "$plan_feature" "## User-Confirmed Decision Mainline" "plan user-confirmed decision source"
assert_contains "$plan_feature" "canonical owner of Decision Delta capture and Plan Mainline Handoff" "plan decision owner"
assert_contains "$plan_feature" "Authority: user-confirmed" "plan user-answer authority"
assert_contains "$plan_feature" "Plan Mainline Handoff" "plan business-rule handoff"
assert_contains "$plan_feature" "trace the smallest concrete business flow" "plan grounds business questions in a real flow"
assert_contains "$plan_feature" "form an evidence-backed working conclusion" "plan requires an Agent conclusion before asking"
assert_contains "$plan_feature" "ask the user to correct, complete, or choose against it" "plan asks for comparison instead of blank definition"
assert_contains "$plan_feature" "decision-relevant uncertainty budget, not an exhaustive questionnaire" "plan limits questions to decision-relevant uncertainty"
assert_contains "$plan_feature" "cross-check implementation evidence against existing user-confirmed answers" "plan cross-checks code and user answers"
assert_contains "$plan_feature" "accept the point and stop asking" "plan stops asking when evidence and answers align"
assert_contains "$plan_feature" "never ask the user to restate an implementation fact" "plan does not ask for already-proven facts"
assert_contains "$plan_feature" "Do not open with abstract prompts" "plan rejects empty business abstractions"

subagent_driven="$(<templates/skill/workflows/subagent-driven.md)"
assert_contains "$subagent_driven" "Worker-local status never advances the Native Plan" "worker status main-plan boundary"

assert_contains "$(<AGENTS.md)" "Task Anchor" "self-hosting shell Task Anchor activation"
assert_contains "$(<templates/shells/AGENTS.md)" "Task Anchor" "downstream shell Task Anchor activation"
assert_contains "$(<AGENTS.md)" "Anchor Checkpoint" "self-hosting shell Recitation activation"
assert_contains "$(<templates/shells/AGENTS.md)" "Anchor Checkpoint" "downstream shell Recitation activation"
assert_contains "$(<AGENTS.md)" "without repeating visible steps in chat" "self-hosting shell Plan deduplication"
assert_contains "$(<templates/shells/AGENTS.md)" "without repeating visible steps in chat" "downstream shell Plan deduplication"

echo ""
echo "==> business-model and persistence contracts"

business_profile="$(<templates/skill/workflows/profile-business-model.md.example)"
assert_contains "$business_profile" "No model, the gap affects the task" "business model missing state"
assert_contains "$business_profile" "Existing model is locally unclear" "business model local calibration state"
assert_contains "$business_profile" "Existing model conflicts with code/tests/runtime" "business model conflict state"
assert_contains "$business_profile" "Do not ask code and the confirmed model to compete for authority" "business model confirmed-authority conflict boundary"
assert_contains "$business_profile" '"Later" is session-only' "business model no-placeholder deferral"
assert_contains "$business_profile" "desired business truth" "business model desired-truth source"
assert_contains "$business_profile" "current implementation fact" "business model implementation-fact boundary"
assert_contains "$business_profile" "Distill at Plan handoff" "business model Plan-handoff distillation"
assert_contains "$business_profile" "task-execution.md#user-decision-drift-gate" "business model drift-owner link"
assert_contains "$business_profile" "plan-feature.md#question-gate" "business model question-owner link"
assert_contains "$business_profile" "trace one concrete business flow" "business model concrete-flow hook"
assert_contains "$business_profile" "carry an evidence-backed working conclusion into the question" "business model conclusion-before-question hook"
assert_contains "$business_profile" "cross-check the evidence with existing user-confirmed answers" "business model cross-check hook"
assert_contains "$business_profile" "accept the point and do not ask again" "business model aligned-answer stop hook"
assert_contains "$business_profile" "Ask only an unresolved ambiguity that could change the current decision" "business model minimal-question hook"

fix_bug="$(<templates/skill/workflows/fix-bug.md)"
assert_contains "$fix_bug" "IMPLEMENTATION_BUG" "fix-bug implementation classification"
assert_contains "$fix_bug" "DESIGN_CHANGE" "fix-bug design-change classification"
assert_contains "$fix_bug" "INSUFFICIENT_BUSINESS_CONTEXT" "fix-bug insufficient-context classification"
assert_contains "$fix_bug" "changes a business type, flow direction, state machine, or core invariant" "fix-bug plan escalation red line"
assert_contains "$fix_bug" "Repair-depth gate" "fix-bug repair-depth gate"
assert_contains "$fix_bug" "invariant-owning boundary" "fix-bug owning-boundary repair"
assert_contains "$fix_bug" "smallest semantically complete repair" "fix-bug minimality tie-breaker"
assert_contains "$fix_bug" "full/incremental/read/write path" "fix-bug all-path inspection"
assert_contains "$fix_bug" "user-confirmed Decision Context" "fix-bug Plan-mainline activation"
assert_contains "$fix_bug" "Purely technical Design-derived work replays the source Plan without requiring a business model" "fix-bug technical-plan business-leaf boundary"
assert_contains "$fix_bug" "plan-feature.md#question-gate" "fix-bug question-owner link"
assert_contains "$fix_bug" "trace the smallest concrete business flow" "fix-bug concrete-flow-before-question"
assert_contains "$fix_bug" "form an evidence-backed working conclusion" "fix-bug conclusion-before-question"
assert_contains "$fix_bug" "cross-check it against any existing user-confirmed answer" "fix-bug cross-checks evidence and prior answers"
assert_contains "$fix_bug" "continue without another question" "fix-bug skips aligned questions"
assert_contains "$fix_bug" "only an unresolved ambiguity that could change repair classification or expected behavior" "fix-bug asks only decision-changing ambiguity"
assert_contains "$fix_bug" "not request exhaustive detail or an abstract definition from scratch" "fix-bug rejects exhaustive or blank business questions"
assert_contains "$fix_bug" "update-rules.md#active-bug-fix-input" "fix-bug immediate business-recording owner link"
assert_contains "$fix_bug" "instead of waiting for Task Closure" "fix-bug does not defer durable user input"
assert_contains "$fix_bug" 'the only source eligible for a `references/business/<module>.md` record is the user' "fix-bug user-content-only source"
assert_contains "$fix_bug" "Do not derive a business rule from the Bug" "fix-bug rejects bug-derived business rules"
assert_contains "$fix_bug" "Bug symptoms, root cause, repaired behavior, code, tests, runtime evidence, and Agent summaries are not" "fix-bug excludes repair evidence from desired truth"
assert_contains "$fix_bug" "Reusable engineering lessons discovered while fixing the Bug follow normal Closure/AAR" "fix-bug routes engineering lessons through closure"
assert_contains "$fix_bug" "No Bug-derived or Agent-derived content entered the business model" "fix-bug completion protects user-intent fidelity"
assert_contains "$fix_bug" "User Decision Drift Gate" "fix-bug immediate drift escalation"
assert_contains "$fix_bug" "task-execution.md#user-decision-drift-gate" "fix-bug drift-owner link"

change_managed="$(<templates/skill/workflows/change-managed.md)"
assert_contains "$change_managed" "Map semantic fan-out" "change-managed invariant fan-out"
assert_contains "$change_managed" "full/incremental/read/write path" "change-managed all-path map"
assert_contains "$change_managed" "smallest semantically complete change" "change-managed minimality tie-breaker"
assert_contains "$change_managed" "source Plan's relevant user-confirmed Decision Context" "change-managed Plan-mainline activation"
assert_contains "$change_managed" "Purely technical Design-derived work replays the source Plan without requiring a business model" "change-managed technical-plan business-leaf boundary"
assert_contains "$change_managed" "User Decision Drift Gate" "change-managed immediate drift escalation"
assert_contains "$change_managed" "task-execution.md#user-decision-drift-gate" "change-managed drift-owner link"

assert_contains "$plan_feature" "business-model impact: unchanged / proposed change / unknown" "plan business-model impact"
assert_contains "$plan_feature" "Before implementation handoff" "plan distills desired truth before coding"
assert_contains "$plan_feature" "for business-bearing work, distilled confirmed business meaning" "plan handoff optional business-distillation boundary"
assert_contains "$plan_feature" "current implementation fact" "plan preserves implementation-fact boundary"

update_rules="$(<templates/skill/workflows/update-rules.md)"
assert_contains "$update_rules" "## Active Bug-Fix Input" "update-rules active bug-fix admission owner"
assert_contains "$update_rules" "The only business-recording source during Fix Bug is the user's explicit business statement" "update-rules user-content-only source"
assert_contains "$update_rules" "Preserve the user's meaning faithfully" "update-rules user-meaning fidelity"
assert_contains "$update_rules" "Do not derive a business rule from the Bug" "update-rules rejects bug-derived intent"
assert_contains "$update_rules" "Reusable engineering lessons discovered while fixing the Bug follow normal Closure/AAR" "update-rules engineering-lesson destination boundary"
assert_contains "$update_rules" "Fix Bug owns noticing and immediate invocation" "update-rules fix-bug local-action boundary"
for outcome in "No write" "Extend in place" "Correct in place" "Retire" "Add independently"; do
  assert_contains "$update_rules" "$outcome" "gotcha reconciliation outcome"
done
assert_contains "$update_rules" "can a fresh Agent, reading only the proposed record, reconstruct the same key judgment" "persistence fidelity reconstruction"
assert_contains "$update_rules" "## Plan Decision Source" "persistence Plan-decision source"
assert_contains "$update_rules" "plan-feature.md#user-confirmed-decision-mainline" "persistence Plan-owner link"
assert_contains "$update_rules" "owns distillation and reconciliation" "persistence distillation owner"
assert_contains "$update_rules" "Plan confirmed for implementation" "persistence Plan-handoff sync"
assert_contains "$update_rules" "bypasses only the Recording Threshold" "persistence Plan-handoff admission"

receiving_review="$(<templates/skill/workflows/receiving-review.md)"
assert_contains "$receiving_review" "user-confirmed Decision Context" "review Plan-mainline activation"
assert_contains "$receiving_review" "Purely technical Design-derived work replays the source Plan without requiring a business model" "review technical-plan business-leaf boundary"
assert_contains "$receiving_review" "pause the affected path and ask the user immediately" "review immediate drift escalation"
assert_contains "$receiving_review" "task-execution.md#user-decision-drift-gate" "review drift-owner link"

maintain_docs="$(<templates/skill/workflows/maintain-docs.md)"
assert_contains "$maintain_docs" "## Semantic Ownership and Local Actionability" "semantic ownership judgment owner"
assert_contains "$maintain_docs" "smallest task-specific trigger, immediate action, and current-task acceptance responsibility" "local action repetition boundary"
assert_contains "$maintain_docs" "A complete repeated rule or workflow is exceptional" "complete-copy exception boundary"
assert_contains "$maintain_docs" "independently delivered or independently used" "generation distribution boundary"
assert_contains "$maintain_docs" "## Step 2: Independent Load-Reason Audit" "independent load-reason audit"
assert_contains "$maintain_docs" "## Step 5: Semantic Before/After Reconciliation" "semantic before-after audit"

# Affected-path change simulation: task-execution owns the complete transition;
# every runtime consumer links to it and must not become another full owner.
for consumer_file in \
  templates/skill/workflows/change-managed.md \
  templates/skill/workflows/fix-bug.md \
  templates/skill/workflows/receiving-review.md \
  templates/skill/workflows/task-closure.md \
  templates/skill/workflows/profile-business-model.md.example \
  references/business-global-model.md \
  references/protocols.md \
  WORKFLOW.md; do
  consumer_content="$(<"$consumer_file")"
  assert_contains "$consumer_content" "task-execution.md#user-decision-drift-gate" "$consumer_file canonical drift-owner link"
  assert_not_contains "$consumer_content" 'Mark every alternative `proposed`' "$consumer_file does not copy proposed transition"
  assert_not_contains "$consumer_content" 'mark the prior decision `superseded`' "$consumer_file does not copy superseded transition"
done

plan_large="$(<templates/skill/workflows/plan-large.md)"
assert_contains "$plan_large" "Read this file only after" "large-plan conditional read"
assert_contains "$plan_large" "If an angle would be read only with every sibling" "large-plan independent angle reason"

echo ""
echo "Summary: $PASS passed, $FAIL failed"
[[ "$FAIL" -eq 0 ]]
