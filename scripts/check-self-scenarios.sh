#!/usr/bin/env bash
# Minimal self-hosting scenario checks for high-risk routes.
#
# These are transcript-shaped route proofs, not a general scenario harness:
# user phrase -> routing manifest row -> first workflow -> evidence-gated knowledge.

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

assert_contains() {
  local block="$1" needle="$2" label="$3"
  if grep -qF -- "$needle" <<<"$block"; then
    pass "$label contains $needle"
  else
    fail "$label missing $needle"
  fi
}

assert_not_contains() {
  local block="$1" needle="$2" label="$3"
  if grep -qF -- "$needle" <<<"$block"; then
    fail "$label unexpectedly contains $needle"
  else
    pass "$label excludes $needle"
  fi
}

unsafe_backtick_assertions="$(
  awk '
    /assert_(not_)?contains/ {
      in_double = 0
      escaped = 0
      for (i = 1; i <= length($0); i++) {
        char = substr($0, i, 1)
        if (escaped) {
          escaped = 0
          continue
        }
        if (char == "\\") {
          escaped = 1
          continue
        }
        if (char == "\"") {
          in_double = !in_double
          continue
        }
        if (char == "`" && in_double) {
          print NR ":" $0
          break
        }
      }
    }
  ' "$0"
)"
if [[ -n "$unsafe_backtick_assertions" ]]; then
  echo "Unsafe assertion quoting: literal backticks inside double quotes execute command substitution." >&2
  echo "$unsafe_backtick_assertions" >&2
  exit 1
fi

check_scenario() {
  local name="$1" manifest="$2" prompt="$3" route="$4" workflow="$5"
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
  assert_not_contains "$block" "required_reads:" "$name task route eager reads"
  assert_not_contains "$block" "route:" "$name executable route instructions"
}

echo "Self-hosting Scenario Checks"
echo "============================"

check_scenario \
  "ordinary downstream migration" \
  "references/self-hosting-routing.yaml" \
  "用 SBA 整理这个项目的规则" \
  "migrate-downstream" \
  "WORKFLOW.md#quick-start"

migration_workflow="$(<WORKFLOW.md)"
profile_project="$(<templates/skill/workflows/profile-project.md)"
assert_contains "$migration_workflow" "Begin with a read-only code/config/rule scan" "ordinary migration code-first entry"
assert_contains "$migration_workflow" "Ask only when evidence cannot resolve a normative product/business decision" "ordinary migration question boundary"
assert_contains "$migration_workflow" "continue directly to preview and apply" "ordinary migration no-question fast path"
assert_not_contains "$migration_workflow" "Start with the workflow's user brainstorm gate" "ordinary migration removes pre-scan brainstorm gate"
assert_not_contains "$migration_workflow" "do not read code yet" "ordinary migration does not block evidence reads"
assert_contains "$profile_project" "Do not begin by asking whether the user wants to brainstorm" "project profile code-first entry"
assert_contains "$profile_project" "User-confirmed desired truth" "project profile preserves normative authority"

check_scenario \
  "edit templates" \
  "references/self-hosting-routing.yaml" \
  "修改 templates" \
  "edit-templates" \
  "templates/skill/workflows/edit-templates.md"

check_scenario \
  "improve activation routing" \
  "references/self-hosting-routing.yaml" \
  "优化 routing.yaml" \
  "improve-activation-routing" \
  "templates/skill/workflows/edit-templates.md"

assert_contains \
  "$(task_block references/self-hosting-routing.yaml improve-activation-routing)" \
  "load references/multi-skill-routing.md only when evidence shows multiple skills" \
  "improve activation routing conditional multi-skill read"
assert_not_contains \
  "$(task_block references/self-hosting-routing.yaml improve-activation-routing)" \
  "required_reads:" \
  "improve activation routing initial reads"

check_scenario \
  "add example" \
  "references/self-hosting-routing.yaml" \
  "补一个行为失败例子" \
  "add-example" \
  "templates/skill/workflows/change-managed.md"

assert_contains \
  "$(task_block references/self-hosting-routing.yaml add-example)" \
  "Read EXAMPLES.md after workflow selection" \
  "add example delayed reference read"

check_scenario \
  "draft plan without distillation preload" \
  "references/self-hosting-routing.yaml" \
  "制定一个 plan" \
  "plan-feature" \
  "templates/skill/workflows/plan-feature.md"

assert_not_contains \
  "$(task_block references/self-hosting-routing.yaml plan-feature)" \
  "templates/skill/workflows/update-rules.md" \
  "draft plan initial reads"

check_scenario \
  "SBA product direction" \
  "references/self-hosting-routing.yaml" \
  "SBA 应该往什么方向发展" \
  "product-direction" \
  "templates/skill/workflows/plan-feature.md"

product_direction="$(task_block references/self-hosting-routing.yaml product-direction)"
assert_contains "$product_direction" "吸收一个外部项目" "SBA product direction external-project trigger"
assert_contains "$product_direction" "增加一个重大机制" "SBA product direction major-mechanism trigger"
assert_not_contains "$product_direction" "docs/sba-bible.md" "SBA product direction route does not preload Bible"
assert_contains "$(<templates/skill/workflows/plan-feature.md)" 'Self-hosting `product-direction` support is optional downstream' "SBA product direction optional downstream boundary"
assert_contains "$(<templates/skill/workflows/plan-feature.md)" "When it is admitted" "SBA product direction admitted-owner checkpoint"
assert_contains "$(<templates/skill/workflows/plan-feature.md)" "Ordinary downstream planning never loads the SBA Bible" "SBA product direction scope boundary"

check_scenario \
  "distill plan conclusions" \
  "references/self-hosting-routing.yaml" \
  "把 plan 的结论沉淀下来" \
  "distill-plan-conclusions" \
  "templates/skill/workflows/update-rules.md"

# This proves the high-risk part: the trigger phrase reaches the first workflow
# without preloading project or mutation rules.
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
  "$(<templates/skill/workflows/update-rules.md)" \
  'never preload both `references/gotchas.md` and `references/behavior-failures.md`' \
  "update-rules conditional evidence selection"
assert_not_contains \
  "$(task_block templates/skill/routing.yaml update-rules)" \
  "references/gotchas.md" \
  "update-rules initial gotcha read"
assert_not_contains \
  "$(task_block templates/skill/routing.yaml update-rules)" \
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

change_contract="$(<templates/skill/protocol-blocks/change-contract.md)"
source_localization="$(<templates/skill/protocol-blocks/source-localization.md)"
assert_not_contains "$(<templates/skill/routing.yaml)$(<references/self-hosting-routing.yaml)" "id: change-contract" "Change Contract is not a first-workflow route"
assert_not_contains "$(<templates/skill/routing.yaml)$(<references/self-hosting-routing.yaml)" "id: source-localization" "source localization is not a first-workflow route"
assert_not_contains "$(<templates/skill/routing.yaml)" "protocol-blocks/change-contract.md" "Change Contract is not an eager routing read"
assert_not_contains "$(<templates/skill/routing.yaml)" "protocol-blocks/source-localization.md" "source localization is not an eager routing read"
assert_contains "$change_contract" "clear request, confirmed Plan, observed/expected contract, or already proven owner" "Change Contract readiness fast path"
assert_contains "$change_contract" "Every material requirement-bearing input receives an evidenced disposition" "Change Contract input coverage"
assert_contains "$change_contract" "Agent-discoverable files, symbols, callers" "Change Contract keeps technical discovery with the Agent"
assert_contains "$change_contract" "Treat ordinary Current/Target difference as the change to bind" "Change Contract binds normal Current/Target difference"
assert_contains "$change_contract" "A final file list, line-level design, exhaustive call graph" "Change Contract avoids broad pre-mutation inventory"
assert_contains "$change_contract" "Evidence inside the bound contract updates it" "Change Contract evidence-driven expansion"
assert_contains "$change_contract" "ordinary tasks create no contract file" "Change Contract Session-only default"
assert_contains "$source_localization" "skip directly to a selected-source check when the target is already proven concrete" "source localization known-target fast path"
assert_contains "$source_localization" "Stages 1-2 expose no source bodies" "source localization progressive source exposure"
assert_contains "$source_localization" "Empty/noisy/truncated results refine or return" "source localization failed-search return"
assert_contains "$source_localization" "a path, lexical match, file read, or successful command is not owner proof" "source localization owner-proof boundary"
assert_contains "$source_localization" "Source evidence may falsify Semantic Intent but cannot rewrite desired meaning" "source localization authority boundary"
assert_contains "$source_localization" "ordinary localization creates no repository artifact" "source localization no-map default"

for shell in \
  templates/shells/AGENTS.md \
  templates/shells/CLAUDE.md \
  templates/shells/CODEX.md \
  templates/shells/GEMINI.md \
  templates/shells/.cursor/rules/workflow.mdc; do
  shell_content="$(<"$shell")"
  assert_contains "$shell_content" "Request-clarity judgment" "$shell clarity activation"
  assert_contains "$shell_content" "vague wording is a signal, not an automatic blocker" "$shell evidence-first summary"
  assert_contains "$shell_content" "Before any requested commit/push/MR/deploy/publish delivery" "$shell pre-delivery Closure activation"
  assert_contains "$shell_content" "Ready for Delivery" "$shell readiness is not completion"
  assert_not_contains "$shell_content" "stop and ask for scope" "$shell old lexical stop"
done

task_execution="$(<templates/skill/workflows/task-execution.md)"
composite_execution="$(<templates/skill/protocol-blocks/composite-plan-execution.md)"
user_decision_drift="$(<templates/skill/protocol-blocks/user-decision-drift.md)"
template_routing="$(<templates/skill/routing.yaml)"
self_routing="$(<references/self-hosting-routing.yaml)"
templates_shells="$(<templates/shells/AGENTS.md)$(<templates/shells/CLAUDE.md)$(<templates/shells/CODEX.md)$(<templates/shells/GEMINI.md)"
assert_not_contains "$template_routing" "id: subagent-driven" "template routing excludes task-size sibling route"
assert_not_contains "$self_routing" "id: long-run" "self-hosting routing excludes task-size sibling route"
assert_not_contains "$(task_block templates/skill/routing.yaml plan-feature)" "long-running change" "plan route excludes duration-based matching"
assert_not_contains "$(task_block templates/skill/routing.yaml plan-feature)" "长任务" "plan route excludes Chinese duration-based matching"
assert_not_contains "$templates_shells" "explicit business request" "generated shells exclude broad business-request activation"
assert_contains "$templates_shells" "explicit business-rule request" "generated shells keep business-rule activation boundary"
assert_not_contains "$templates_shells" "Skip closure only" "generated shells defer skip policy to Closure owner"
assert_contains "$task_execution" "## Task Classifier" "task execution explicit classifier owner"
assert_contains "$task_execution" "Classify by whether an explicit goal changes execution" "task execution classifier decision basis"
assert_contains "$task_execution" "unresolved product/architecture choice, materially different interpretations, or irreversible decision" "task execution Design classification boundary"
assert_contains "$task_execution" "after approval, convert its result into a Managed task" "task execution Design-to-Managed transition"
assert_contains "$task_execution" "Proceed unless a real decision, authority boundary" "task execution auto-start default"
assert_contains "$task_execution" "freeze one risk-sized Done Contract" "task execution freezes Done Contract before Managed work"
assert_contains "$task_execution" "the cheapest fitted validation set, and concrete escalation signals" "task execution freezes validation and escalation"
assert_contains "$task_execution" "The frozen contract owns read breadth, validation depth, and the stop point" "task execution Done Contract ownership"
assert_contains "$task_execution" "the result that would select the next read" "task execution next-read decision hook"
assert_contains "$task_execution" "Ranked, sampled, truncated, or Top-N output is candidate evidence, not an exhaustive inventory" "task execution bounded-output completeness boundary"
assert_contains "$task_execution" "harness's native Plan/Task surface" "task execution native plan preference"
assert_contains "$task_execution" "natural-language alignment" "task execution default natural presentation"
assert_contains "$task_execution" "do not repeat its steps in chat" "task execution no native-plan duplication"
assert_contains "$task_execution" "## Presentation Gate" "task execution presentation selection gate"
assert_contains "$task_execution" "Evaluate **Structured Brief first**" "task execution Structured Brief precedence"
assert_contains "$task_execution" "Compact Alignment is allowed only when all Structured conditions are false" "task execution Compact Alignment exclusion boundary"
assert_contains "$task_execution" "first user-facing task-start message MUST begin" "task execution Structured Brief first-message requirement"
assert_contains "$task_execution" "Steps must be numbered" "task execution Structured Brief numbered steps"
assert_contains "$task_execution" "do not collapse the brief into prose or render empty headings" "task execution Structured Brief semantic shape"
assert_contains "$task_execution" "does not create durable planning files or recover task state across Sessions" "task execution state-presentation boundary"
assert_contains "$task_execution" "## Recitation Loop" "task execution recitation section"
assert_contains "$task_execution" "Before each main Plan step" "task execution per-step Anchor checkpoint"
assert_contains "$task_execution" "cross-cutting modifier, never a first-workflow route" "task execution modifier-only long-run activation"
assert_contains "$task_execution" "task size or duration alone does not activate it" "task execution rejects size-only routing"
assert_contains "$task_execution" "every governing Plan path" "task execution design-source handoff"
assert_contains "$task_execution" "only business-bearing decisions require a routed business rule" "task execution technical-plan business-leaf boundary"
assert_contains "$task_execution" "owner of domain gates/evidence" "task execution domain-specific evidence owner"
assert_contains "$task_execution" "the evidence that could resolve or falsify it" "task execution step evidence question"
assert_contains "$task_execution" "receiving a successful exit code" "task execution rejects command success as stage completion"
assert_contains "$task_execution" "If it contradicts the premise" "task execution evidence return path"
assert_contains "$task_execution" "if it is inconclusive" "task execution inconclusive evidence stays open"
assert_contains "$task_execution" "## User Decision Drift Gate" "task execution immediate user-drift gate"
assert_contains "$task_execution" "user-decision-drift.md" "task execution conditional drift owner link"
assert_contains "$task_execution" "product meaning, business rule, scope, flow, state, boundary, invariant, acceptance condition, or user-visible behavior" "task execution full user-drift trigger scope"
assert_contains "$task_execution" "Ordinary implementation choices that preserve those decisions do not trigger this gate" "task execution user-drift no-trigger boundary"
assert_contains "$task_execution" "pause the affected path immediately" "task execution drift pauses affected path"
assert_contains "$task_execution" "including updating the Task Anchor and remaining Native Plan before more mutation" "task execution drift synchronization responsibility"
assert_contains "$user_decision_drift" "Keep the affected path paused" "decision drift affected-path concurrency boundary"
assert_contains "$user_decision_drift" "Ordinary implementation choices that preserve those decisions do not trigger it" "decision drift ordinary-choice no-trigger boundary"
assert_contains "$user_decision_drift" 'Mark every alternative `proposed`' "decision drift proposed-alternative transition"
assert_contains "$user_decision_drift" "Source-Preserving User Input" "decision drift loads source-preserving capture owner"
assert_contains "$user_decision_drift" "keep clear wording verbatim" "decision drift defaults to user source wording"
assert_contains "$user_decision_drift" "label any Agent-derived summary as subordinate" "decision drift keeps Agent synthesis subordinate"
assert_contains "$user_decision_drift" "bind every short answer to its original question/options" "decision drift preserves short-answer context"
assert_contains "$user_decision_drift" "speech act/force, actor/ownership, timing/commitment, uncertainty/emphasis" "decision drift preserves pragmatic force and responsibility"
assert_contains "$user_decision_drift" "definition/identity, applicability/preconditions, boundary/counterexample, negation/rejected direction, rationale/consequence, authority, scope" "decision drift preserves load-bearing semantics"
assert_contains "$user_decision_drift" '`proposed | confirmed | superseded` status' "decision drift preserves decision status"
assert_contains "$user_decision_drift" "Record that source-faithful answer in the governing Plan Decision Context" "decision drift records source-faithful answer"
assert_contains "$user_decision_drift" "retain the source wording or ask the user" "decision drift ambiguity preserves source authority"
assert_contains "$user_decision_drift" 'mark the prior decision `superseded`' "decision drift superseded-mainline transition"
assert_contains "$user_decision_drift" "update the Task Anchor and remaining Native Plan before more mutation" "decision drift updates runtime mainline"
assert_contains "$user_decision_drift" "Never silently compromise a confirmed mainline" "decision drift rejects implementation-led meaning loss"
assert_contains "$user_decision_drift" "A late disclosure in review or Closure never substitutes" "decision drift rejects deferred disclosure"
assert_contains "$task_execution" "do not narrate it before every tool call" "task execution no per-tool narration"
assert_contains "$task_execution" "does not create durable planning files or recover task state across Sessions" "task execution session-only boundary"
assert_contains "$task_execution" "a new independent outcome re-matches the route and replaces them" "task execution new-task reset"
assert_contains "$task_execution" "preserve the source before changing runtime state" "task execution preserves later user input before synthesis"
assert_contains "$task_execution" "already-clear wording stays verbatim" "task execution leaves clear user wording unchanged"
assert_contains "$task_execution" "an Agent-derived summary cannot be the only normative record" "task execution rejects summary-only authority"
assert_contains "$task_execution" "cannot omit or semantically reorder a mandatory gate" "task execution Workflow authority"
assert_not_contains "$task_execution" "task_plan.md" "task execution no fixed task-plan file"
assert_not_contains "$task_execution" "cross-tool state sync" "task execution no cross-tool state system"
assert_not_contains "$task_execution" "Plan: <concise task-specific steps" "task execution no fixed chat block"
assert_contains "$task_execution" "Clear tasks keep the direct fast path" "task execution Change Contract fast path"
assert_contains "$task_execution" "source-localization.md" "task execution technical-owner hook"
assert_contains "$task_execution" "## Verified Failure Handoff" "task execution verified-failure owner hook"
assert_contains "$task_execution" "Session-only failure candidate" "failed check stays Session-only before proof"
assert_contains "$task_execution" "Retries inside the same unresolved task remain one occurrence" "unresolved retries are not recurrence"
assert_contains "$task_execution" "rule-update/verified-failure.md#verified-failure-input" "proven repair hands off directly to Verified Failure"
assert_contains "$task_execution" "Verified Failure owns durable reconciliation" "task execution does not duplicate durable semantics"
assert_contains "$task_execution" "every verified failure has a Rule Update learning outcome" "execution blocks unclassified failure at Closure handoff"

change_discipline="$(<templates/skill/rules/change-discipline.md)"
assert_contains "$change_discipline" "## Semantic Boundary" "mutation-time semantic owner"
assert_contains "$change_discipline" "Default to Product Development" "mutation-time development default"
assert_contains "$change_discipline" "ownership/provenance" "mutation-time ownership trace"
assert_contains "$change_discipline" "full/incremental/read/write paths" "mutation-time all-path trace"
assert_contains "$change_discipline" "Dependency count is risk evidence" "mutation-time dependency-count boundary"
assert_contains "$change_discipline" "Use Operational Stabilization only" "mutation-time operational exception"
assert_contains "$change_discipline" "project-rules.md" "mutation-time project-rule activation"
assert_contains "$change_discipline" "coding-standards.md" "mutation-time coding-rule activation"

assert_contains "$task_execution" "one clear action with one direct check" "task execution Simple direct path"
assert_contains "$task_execution" "Present only useful alignment" "task execution proportional Anchor presentation"
assert_contains "$task_execution" "do not repeat its steps in chat" "task execution native Plan deduplication"
assert_contains "$task_execution" "Before each main Plan step" "task execution Anchor checkpoint activation"

task_closure="$(<templates/skill/workflows/task-closure.md)"
plan_knowledge_closure="$(<templates/skill/protocol-blocks/plan-knowledge-closure.md)"
external_delivery="$(<templates/skill/protocol-blocks/external-delivery-verification.md)"
workflow_proposal="$(<templates/skill/protocol-blocks/workflow-distillation-proposal.md)"
assert_contains "$task_closure" "### Entry Gate" "closure execution entry gate"
assert_contains "$task_closure" 'return to [`task-execution.md`](task-execution.md)' "closure cannot finish execution"
assert_contains "$task_closure" "final Anchor Checkpoint" "closure final Anchor checkpoint"
assert_contains "$task_closure" "restate the frozen Done Contract and Task Anchor" "closure reads back frozen Done Contract"
assert_contains "$task_closure" "frozen validation set, escalation signals, stop point" "closure reads back validation and escalation"
assert_contains "$task_closure" "does not redefine Semantic Intent, source-localization stages, read breadth, or validation depth after green" "closure cannot expand a green contract"
assert_contains "$task_closure" "plan-knowledge-closure.md" "closure conditional Plan/Knowledge owner link"
assert_contains "$plan_knowledge_closure" "Replay each relevant user-confirmed Decision Context" "Plan/Knowledge decision-mainline replay"
assert_contains "$plan_knowledge_closure" 'enumerate every one-way `consumes` edge' "Plan/Knowledge explicit Component dependency graph"
assert_contains "$plan_knowledge_closure" "read each Component from its canonical owner" "Plan/Knowledge reconciliation owner"
assert_contains "$plan_knowledge_closure" 'A `done` Component is frozen' "Plan/Knowledge frozen Component lifecycle"
assert_contains "$plan_knowledge_closure" 'no required Component may remain `draft` or `executing`' "Plan/Knowledge unfinished Component lifecycle gate"
assert_contains "$plan_knowledge_closure" 'a true `subplan_of` shares its parent'"'"'s lifecycle' "Plan/Knowledge true subplan lifecycle"
assert_contains "$plan_knowledge_closure" "an independent Component retains its own lifecycle" "Plan/Knowledge independent Component lifecycle"
assert_contains "$plan_knowledge_closure" "Decision Delta, local acceptance, fresh proof, delivery responsibility, and durable distillation" "Plan/Knowledge complete Component reconciliation payload"
assert_contains "$plan_knowledge_closure" "Material drift returns to [" "Plan/Knowledge rejects first drift disclosure"
assert_contains "$plan_knowledge_closure" "read the routed business rule" "Plan/Knowledge optional business-leaf boundary"
assert_contains "$plan_knowledge_closure" "pre-implementation Plan Mainline Handoff and Plan Leaf Reconciliation" "Plan/Knowledge verifies implementation handoff"
assert_contains "$plan_knowledge_closure" "Before implementation handoff" "Plan/Knowledge handoff timing"
assert_contains "$plan_knowledge_closure" "preserved Requirement Provenance to the source Plan" "Plan/Knowledge requirement provenance"
assert_contains "$plan_knowledge_closure" "it is not the first place to compress or write the user-confirmed mainline" "Plan/Knowledge Closure is not first-write owner"
assert_contains "$plan_knowledge_closure" "integrated acceptance, and delivery responsibility" "Plan/Knowledge integrated proof responsibility"
assert_contains "$task_closure" "Ready for Delivery" "closure distinguishes readiness from completion"
assert_contains "$task_closure" "Closure never grants commit, push, MR, deploy, publish" "closure preserves delivery authority boundary"
assert_contains "$task_closure" "external-delivery-verification.md" "closure conditional external-delivery owner link"
assert_contains "$external_delivery" 'Return `blocked`' "external delivery stays open on failure"
assert_contains "$external_delivery" 'Return `stale` when source content, branch/config inputs, or relevant verification changed' "external delivery stale result boundary"
assert_contains "$external_delivery" 'Return `premise-changed` when the requested artifact, target, authority, or delivery scope/premise changed' "external delivery premise-changed boundary"
assert_contains "$external_delivery" "Retry only the external boundary" "external delivery scopes unchanged retries"
assert_contains "$task_closure" "Closure Complete" "closure verifies delivery before completion"
assert_contains "$task_closure" "The command exited 0, so the stage is complete" "closure build-success false-completion scenario"
assert_contains "$task_closure" "proves only the command's own contract" "closure exit-code evidence boundary"
assert_contains "$task_closure" "treating that exit code as sufficient completion evidence by itself" "closure red-flags exit-code sufficiency"
assert_contains "$task_closure" 'final expanded [`Change Contract`](../protocol-blocks/change-contract.md)' "closure bound-contract reconciliation"
assert_contains "$task_closure" "does not redefine Semantic Intent, source-localization stages" "closure stays a consumer"
assert_contains "$plan_knowledge_closure" "read each Component from its canonical owner" "closure reads Component truth at its owner"
assert_contains "$plan_knowledge_closure" "unfinished required inputs" "closure blocks unfinished Components"
assert_contains "$plan_knowledge_closure" 'missing, `abandoned`, unresolved-Delta, superseded-but-consumed' "closure blocks stale Component inputs"
assert_contains "$plan_knowledge_closure" "Abandoning an Integrating Plan never changes independent Component state" "integration abandonment preserves Component lifecycle"
assert_contains "$task_closure" "SQL-file existence alone is neither schema readiness nor DB delivery" "closure separates SQL review from DB delivery"
assert_contains "$external_delivery" "authoritative schema/data readback" "closure requires authoritative DB delivery proof"
assert_contains "$task_closure" "Account for verified failures" "closure accounts for repair-time learning"
assert_contains "$task_closure" 'rule-update/verified-failure.md` § Verified Failure Input' "closure requires one outcome per verified failure"
assert_contains "$task_closure" 'rule-update/knowledge-reconciliation.md' "ordinary AAR enters Knowledge Reconciliation directly"
assert_contains "$task_closure" 'workflow-distillation-proposal.md' "closure activates post-completion proposal owner"
assert_contains "$task_closure" "Closure does not diagnose root cause or postpone the first write" "closure stays accounting-only"
assert_contains "$task_closure" "Do not re-record an already-reconciled verified failure" "closure does not duplicate repair-time learning"
assert_contains "$task_closure" "verified failure that lacks a completed learning outcome" "closure rejects missing learning outcome"
assert_contains "$task_closure" "recorded red reproduction → same-case green proof" "closure tests-as-spec same-case proof"
assert_contains "$task_closure" "remaining regression uncertainty" "closure tests-as-spec residual uncertainty"
assert_contains "$task_closure" "historical red evidence remains valid" "closure tests-as-spec does not rewind proven red"
assert_contains "$task_closure" "durable instruction or user-meaning compression" "closure semantic-fidelity trigger"
assert_contains "$task_closure" "Semantic Before/After Reconciliation" "closure consumes semantic before-after owner"
assert_contains "$task_closure" "decision-changing clause" "closure clause-level semantic proof"

plan_feature="$(<templates/skill/workflows/plan-feature.md)"
assert_contains "$plan_feature" "## Deliverable Gate" "plan classifies the requested deliverable before expansion"
assert_contains "$plan_feature" "Method/review/brainstorm requests are read-only advisory work" "plan keeps advisory requests bounded"
assert_contains "$plan_feature" "inspect only representative evidence needed to support the evaluation" "plan advisory review uses representative evidence"
assert_contains "$plan_feature" "do not execute every Design Slice, materialize artifacts, or build Task Breakdown" "plan advisory review does not run the full plan"
assert_contains "$plan_feature" "it is not the runtime Native Plan" "design plan runtime boundary"
assert_contains "$plan_feature" "pass its chosen outcome, acceptance criteria, boundaries, and task breakdown" "design to execution transition"
assert_contains "$plan_feature" "## User-Confirmed Decision Mainline" "plan user-confirmed decision source"
assert_contains "$plan_feature" "canonical owner of Decision Delta capture and Plan Mainline Handoff" "plan decision owner"
assert_contains "$plan_feature" "Capture source before synthesis" "plan captures user source before Agent synthesis"
assert_contains "$plan_feature" 'keep it verbatim as `User source`' "plan leaves clear user wording unchanged"
assert_contains "$plan_feature" '`Agent-derived interpretation` is optional' "plan marks Agent interpretation as derived"
assert_contains "$plan_feature" "cannot replace the source as the only normative record" "plan rejects interpretation-only authority"
assert_contains "$plan_feature" "## Semantic Fidelity Before Plan Compression" "plan semantic-fidelity gate"
assert_contains "$plan_feature" "short answer bound to its original question/options" "plan preserves short-answer context"
assert_contains "$plan_feature" "Each source clause must have one disposition" "plan clause-level disposition"
assert_contains "$plan_feature" "meaning, applicability/authority, and normal activation timing" "plan equivalence proof"
assert_contains "$plan_feature" "fresh Agent could make a different decision" "plan semantic reconstruction check"
assert_contains "$plan_feature" "Authority: user-confirmed" "plan user-answer authority"
assert_contains "$plan_feature" "Plan Mainline Handoff" "plan business-rule handoff"
assert_contains "$plan_feature" "trace the smallest concrete business flow" "plan grounds business questions in a real flow"
assert_contains "$plan_feature" "form an evidence-backed working conclusion" "plan requires an Agent conclusion before asking"
assert_contains "$plan_feature" "Stop reading when evidence resolves or falsifies the current question or identifies the next semantic owner" "plan stops evidence expansion at the current decision"
assert_contains "$plan_feature" "suspected consumers, risks, and adjacent flows remain candidates" "plan defers adjacent evidence until needed"
assert_contains "$plan_feature" "Do not inventory every possible consumer before the first decision" "plan rejects eager whole-system inventory"
assert_contains "$plan_feature" "ask the user to correct, complete, or choose against it" "plan asks for comparison instead of blank definition"
assert_contains "$plan_feature" "decision-relevant uncertainty budget, not an exhaustive questionnaire" "plan limits questions to decision-relevant uncertainty"
assert_contains "$plan_feature" "cross-check implementation evidence against existing user-confirmed answers" "plan cross-checks code and user answers"
assert_contains "$plan_feature" "accept the point and stop asking" "plan stops asking when evidence and answers align"
assert_contains "$plan_feature" "select the highest-impact unresolved decision first" "plan resumes active plans from one open decision"
assert_contains "$plan_feature" "keep every other Open Question and suspected evidence path unopened until its turn" "plan does not fan out active-plan open questions"
assert_contains "$plan_feature" "never ask the user to restate an implementation fact" "plan does not ask for already-proven facts"
assert_contains "$plan_feature" "Do not open with abstract prompts" "plan rejects empty business abstractions"
assert_contains "$plan_feature" "trace distinct flows independently" "plan closes distinct implementation flows separately"
assert_contains "$plan_feature" "do not combine two incomplete flows into a binary choice" "plan rejects binary questions built from incomplete traces"
assert_contains "$plan_feature" "## Modeling Gap Intake Handoff" "plan accepts confirmed gaps only after modeling scope"
assert_contains "$plan_feature" "Show the full deduplicated gap set" "plan presents the complete gap intake before solution discussion"
assert_contains "$plan_feature" "## Progressive Brainstorm Handoff" "plan analysis activates detailed user discussion"
assert_contains "$plan_feature" "This handoff is progressive, not only a final ceremony" "plan brainstorm runs during analysis"
assert_contains "$plan_feature" "before opening an unrelated Slice" "plan brainstorm creates an inter-slice user boundary"
assert_contains "$plan_feature" "only when the user explicitly requests an artifact-only or end-to-end Plan without checkpoints" "plan autonomous expansion requires explicit request"
assert_contains "$plan_feature" "automatically enter a detailed user-facing brainstorm" "plan completion does not end the conversation"
assert_contains "$plan_feature" "exactly one topic" "plan brainstorm discusses one topic at a time"
assert_contains "$plan_feature" "three-line summary" "plan brainstorm rejects shallow summaries"
assert_contains "$plan_feature" "Complexity changes analysis depth, never file creation" "plan complexity changes analysis, not storage"
assert_contains "$plan_feature" "## Design Slice" "plan closes one load-bearing design question"
assert_contains "$plan_feature" "question -> current evidence -> decision -> impact/risk -> proof" "plan design slice evidence chain"
assert_contains "$plan_feature" "Do not open the next independent Design Slice while the current one still contains a user-owned normative choice" "plan blocks unrelated expansion before user decision"
assert_contains "$plan_feature" "## Artifact Pressure Gate" "plan artifact creation has a pressure gate"
assert_contains "$plan_feature" "Complexity, activity, or reaching a universal evidence-ready checkpoint is not pressure" "plan rejects size and fixed-stage materialization"
assert_contains "$plan_feature" 'Never pre-create a Plan, directory, `design.md`, or a taxonomy of empty files from complexity alone' "plan rejects eager artifact sets"
assert_contains "$plan_feature" "Alternatives appear only when genuinely different viable shapes" "plan rejects fake alternatives"
assert_contains "$plan_feature" "Resolved questions leave Open Questions" "plan removes stale open questions"
assert_contains "$plan_feature" "Task Breakdown stays absent until stable executable interfaces exist" "plan rejects placeholder decomposition"
assert_not_contains "$plan_feature" 'Record at least two real options' "plan no longer forces two options"
assert_not_contains "$plan_feature" 'Create only `prd.md` initially' "plan no longer auto-creates prd"
assert_contains "$plan_feature" "change-contract.md" "plan semantic-contract hook"
assert_contains "$plan_feature" "source-localization.md" "plan technical-owner hook"
assert_contains "$plan_feature" "Any activated Change Contract is consumed" "plan contract-consumption acceptance"
assert_contains "$plan_feature" 'A Plan is `subplan_of` and physically nested only when it cannot independently complete, freeze, and be directly consumed without its parent' "plan nests only true lifecycle-owned subplans"
assert_contains "$plan_feature" "otherwise it remains an external Component" "plan preserves independently consumable Components"
assert_contains "$plan_feature" 'one-way `consumes` paths' "integrating plan records one-way Component edges"
assert_contains "$plan_feature" "promote an existing truthful common-outcome owner before creating a third Plan" "composition promotes a real owner before materializing another Plan"
assert_contains "$plan_feature" "without mirroring Component status or content" "composition rejects durable mirror state"
assert_contains "$plan_feature" "## Database-Change Artifact Gate" "schema changes have a canonical artifact gate"
assert_contains "$plan_feature" 'dossier plus a naturally named `.sql` sibling before implementation approval' "schema change requires a Plan-local SQL artifact"
assert_contains "$plan_feature" "complete target DDL, forward schema/data update, read-only verification" "SQL artifact contains target migration and proof"
assert_contains "$plan_feature" "safe rollback or an explicit recovery plan" "SQL artifact contains honest recovery"
assert_contains "$plan_feature" "never permission to bypass the project-owned database workflow" "SQL artifact preserves project DB ownership"
for rejected_field in plan_role consumed_by component_status integration_status; do
  assert_not_contains "$plan_feature" "$rejected_field" "plan composition rejects $rejected_field"
done

task_execution="$(<templates/skill/workflows/task-execution.md)"
assert_contains "$task_execution" "## Composite Plan Handoff" "execution activates composite handoff"
assert_contains "$task_execution" "composite-plan-execution.md" "execution conditional composite owner link"
assert_contains "$composite_execution" "one Integrating Task Anchor and one Native Plan" "composite execution has one Native Plan mainline"
assert_contains "$composite_execution" "Components never create competing runtime anchors" "Components do not become parallel runtime plans"
assert_contains "$composite_execution" 'missing, `abandoned`, replaced, or unauthorized inputs block' "invalid Component blocks execution"
assert_contains "$composite_execution" "Component meaning, invariant, boundary, accepted interface" "Component conflict returns to its owner"
assert_contains "$composite_execution" "a frozen Component changes only through a successor" "frozen Component conflict creates a successor"
assert_contains "$task_execution" "## Database-Structure Mutation Gate" "execution gates schema mutation"
assert_contains "$task_execution" "dedicated Plan-local SQL sibling" "execution requires implementation-ready SQL"
assert_contains "$task_execution" "never permission to bypass the project migration workflow or write a database" "execution preserves DB authorization"
for rejected_state in locally_done ready_for_parent waiting_for_component component_status integration_status plan_role; do
  assert_not_contains "$task_execution" "$rejected_state" "composite execution rejects $rejected_state"
done

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
assert_contains "$business_profile" "Persist by task type" "business model chooses standalone leaf, existing Plan, or gap intake"
assert_contains "$business_profile" "task-execution.md#user-decision-drift-gate" "business model drift-owner link"
assert_contains "$business_profile" "plan-feature.md#question-gate" "business model question-owner link"
assert_contains "$business_profile" "Implementation-Fact Question Gate" "business model implementation-fact owner hook"
assert_contains "$business_profile" "Close every decision-relevant trigger/entry" "business model closes every decision-bearing implementation hop"
assert_contains "$business_profile" "trace distinct flows independently" "business model separates incomplete flows"
assert_contains "$business_profile" "Cross-check that evidence with existing user-confirmed answers" "business model cross-check hook"
assert_contains "$business_profile" "accept the point and do not ask again" "business model aligned-answer stop hook"
assert_contains "$business_profile" "Ask only an unresolved normative ambiguity that could change the current decision" "business model minimal normative-question hook"
assert_contains "$business_profile" "does not create a PRD merely because the scope is long or complex" "business model standalone no-PRD boundary"
assert_contains "$business_profile" "## Confirmed Implementation Gap Collection and Handoff" "business model confirmed-gap upgrade path"
assert_contains "$business_profile" "Continue the user's agreed modeling scope" "business model gap discovery does not interrupt leaf completion"
assert_contains "$business_profile" "The default unit is one business domain, not one code module" "business model default domain-file boundary"
assert_contains "$business_profile" "about 120 nonblank lines" "business model split-review size signal"
assert_contains "$business_profile" "more than 10 substantive H2 sections" "business model split-review section signal"
assert_contains "$business_profile" "Size only triggers review; it never decides the split" "business model no mechanical split"
assert_contains "$business_profile" "independently understandable business submodules" "business model submodule split unit"
assert_contains "$business_profile" "Do not split by document aspect" "business model rejects aspect slicing"
assert_contains "$business_profile" "The index must select a leaf from task signals and carry no business body" "business model selecting index boundary"

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
assert_contains "$fix_bug" "Implementation-Fact Question Gate" "fix-bug implementation-fact owner hook"
assert_contains "$fix_bug" "trace distinct flows independently" "fix-bug separates incomplete implementation flows"
assert_contains "$fix_bug" "form an evidence-backed working conclusion" "fix-bug conclusion-before-question"
assert_contains "$fix_bug" "cross-check it against any existing user-confirmed answer" "fix-bug cross-checks evidence and prior answers"
assert_contains "$fix_bug" "continue without another question" "fix-bug skips aligned questions"
assert_contains "$fix_bug" "ask only a remaining normative ambiguity that could change repair classification or expected behavior" "fix-bug asks only decision-changing normative ambiguity"
assert_contains "$fix_bug" "Never ask the user to choose a current implementation fact, request exhaustive detail, or define an abstract concept from scratch" "fix-bug rejects implementation-fact and blank business questions"
assert_contains "$fix_bug" "rule-update/business-truth.md#active-bug-fix-input" "fix-bug immediate business-recording owner link"
assert_contains "$fix_bug" "instead of waiting for Task Closure" "fix-bug does not defer durable user input"
assert_contains "$fix_bug" 'the only source eligible for a `references/business/<module>.md` record is the user' "fix-bug user-content-only source"
assert_contains "$fix_bug" "Do not derive a business rule from the Bug" "fix-bug rejects bug-derived business rules"
assert_contains "$fix_bug" "Bug symptoms, root cause, repaired behavior, code, tests, runtime evidence, and Agent summaries are not" "fix-bug excludes repair evidence from desired truth"
assert_contains "$fix_bug" "rule-update/verified-failure.md#verified-failure-input" "fix-bug immediate engineering-learning owner link"
assert_contains "$fix_bug" "After Step 8 proves an engineering failure and repair" "fix-bug waits for red-to-green proof"
assert_contains "$fix_bug" "For each verified engineering failure, run Verified Failure Input now" "fix-bug writes proven prevention before Closure"
assert_contains "$fix_bug" "does not defer the verified-failure write" "fix-bug rejects Closure-only learning"
assert_contains "$fix_bug" "No Bug-derived or Agent-derived content entered the business model" "fix-bug completion protects user-intent fidelity"
assert_contains "$fix_bug" "User Decision Drift Gate" "fix-bug immediate drift escalation"
assert_contains "$fix_bug" "task-execution.md#user-decision-drift-gate" "fix-bug drift-owner link"
assert_contains "$fix_bug" "Reuse a clear observed/expected contract as the fast path" "fix-bug semantic fast path"
assert_contains "$fix_bug" "source-localization.md" "fix-bug technical-owner hook"
assert_contains "$fix_bug" "must identify the repair target and root-cause path before mutation" "fix-bug contract-consumption acceptance"

change_managed="$(<templates/skill/workflows/change-managed.md)"
assert_contains "$change_managed" "Map semantic fan-out" "change-managed invariant fan-out"
assert_contains "$change_managed" "full/incremental/read/write path" "change-managed all-path map"
assert_contains "$change_managed" "smallest semantically complete change" "change-managed minimality tie-breaker"
assert_contains "$change_managed" "source Plan's relevant user-confirmed Decision Context" "change-managed Plan-mainline activation"
assert_contains "$change_managed" "Purely technical Design-derived work replays the source Plan without requiring a business model" "change-managed technical-plan business-leaf boundary"
assert_contains "$change_managed" "User Decision Drift Gate" "change-managed immediate drift escalation"
assert_contains "$change_managed" "task-execution.md#user-decision-drift-gate" "change-managed drift-owner link"
assert_contains "$change_managed" "clear source Plans and explicit requests take its fast path" "change-managed semantic fast path"
assert_contains "$change_managed" "source-localization.md" "change-managed technical-owner hook"
assert_contains "$change_managed" "bind the returned owner/Current -> Target/affected path before mutation" "change-managed contract-consumption acceptance"

assert_contains "$clarity_gate" "identify whether the blocker is normative" "request clarity consumes Change Contract blocker"
assert_contains "$clarity_gate" "instead of asking the user" "request clarity sends technical unknowns to localization"

for consumer_file in \
  templates/skill/workflows/plan-feature.md \
  templates/skill/workflows/fix-bug.md \
  templates/skill/workflows/change-managed.md \
  templates/skill/protocol-blocks/ambiguous-request-gate.md \
  templates/skill/workflows/task-execution.md \
  templates/skill/workflows/task-closure.md; do
  consumer_content="$(<"$consumer_file")"
  assert_not_contains "$consumer_content" "Every material requirement-bearing input receives an evidenced disposition" "$consumer_file does not copy the Semantic Intent definition"
  assert_not_contains "$consumer_content" "## Adaptive Evidence Funnel" "$consumer_file does not copy the localization procedure"
done

assert_contains "$plan_feature" "business-model impact: unchanged / proposed change / unknown" "plan business-model impact"
assert_contains "$plan_feature" "Before implementation handoff" "plan distills desired truth before coding"
assert_contains "$plan_feature" "for business-bearing work, distilled confirmed business meaning" "plan handoff optional business-distillation boundary"
assert_contains "$plan_feature" "current implementation fact" "plan preserves implementation-fact boundary"

update_rules="$(<templates/skill/workflows/update-rules.md)"
business_truth="$(<templates/skill/workflows/rule-update/business-truth.md)"
verified_failure="$(<templates/skill/workflows/rule-update/verified-failure.md)"
knowledge_reconciliation="$(<templates/skill/workflows/rule-update/knowledge-reconciliation.md)"
workflow_distillation="$(<templates/skill/workflows/rule-update/workflow-distillation.md)"

assert_contains "$update_rules" "## Shared Durable-Write Contract" "update-rules owns shared durable-write contract"
assert_contains "$update_rules" "## Ambiguous Request Dispatcher" "update-rules remains ambiguous request entry"
assert_contains "$update_rules" "Select exactly one execution owner" "ambiguous recording selects one leaf"
assert_contains "$update_rules" "If the input type is already known, skip this dispatcher" "typed inputs bypass dispatcher"
assert_contains "$update_rules" "No durable write is complete until it has a normal path that is reached and changes action" "durable write requires action-changing activation"
assert_contains "$update_rules" "A durable update never grants commit, push, MR, deploy, publish, database" "shared contract preserves authority"
for branch_heading in "## Business Leaf and Gotcha Ownership" "## Verified Failure Input" "## Ordinary Recording Threshold" "## Accepted Workflow-Distillation Input"; do
  assert_not_contains "$update_rules" "$branch_heading" "compact dispatcher excludes branch procedure $branch_heading"
done

assert_contains "$business_truth" "## Business Leaf and Gotcha Ownership" "business truth owns leaf/Gotcha boundary"
assert_contains "$business_truth" "## Plan Decision Source" "business truth owns Plan handoff"
assert_contains "$business_truth" "## Standalone Business-Model Input" "business truth owns standalone modeling"
assert_contains "$business_truth" "## Active Bug-Fix Input" "business truth owns active bug business input"
assert_contains "$business_truth" 'Do not derive `desired business truth` from Bug symptoms' "business truth rejects bug-derived intent"
assert_not_contains "$business_truth" "## Verified Failure Input" "business path does not load failure procedure"
assert_not_contains "$business_truth" "## Accepted Workflow-Distillation Input" "business path does not load workflow distillation"

assert_contains "$verified_failure" "## Verified Failure Input" "verified failure has complete owner"
assert_contains "$verified_failure" "first proven actionable failure bypasses only the ordinary Recording Threshold" "first proven prevention writes without waiting for recurrence"
assert_contains "$verified_failure" "same proven root cause + same applicability boundary + same prevention action" "recurrence uses cause boundary and prevention"
assert_contains "$verified_failure" "repair activation instead of adding prose" "recurrence repairs missed activation first"
assert_contains "$verified_failure" "Failure learning never grants commit, push, MR, deploy, publish, database, production, or other external authority" "failure learning preserves authority boundary"
for failure_outcome in covered/no-write extend-existing correct-existing add-and-activate transient/no-write requires-user-authority escalate-prevention; do
  assert_contains "$verified_failure" "\`$failure_outcome\`" "verified-failure outcome $failure_outcome"
done
assert_not_contains "$verified_failure" "## Business Leaf and Gotcha Ownership" "verified-failure path does not load business procedure"
assert_not_contains "$verified_failure" "## Accepted Workflow-Distillation Input" "verified-failure path does not load workflow distillation"
assert_not_contains "$fix_bug$verified_failure" "follow normal Closure/AAR" "verified engineering learning is not deferred"
assert_not_contains "$template_routing$self_routing" "id: memory" "failure learning adds no Memory route"
for outcome in 'no-write' 'extend' 'correct' 'retire' 'add'; do
  assert_contains "$update_rules" "**\`$outcome\`**" "shared reconciliation outcome $outcome"
done
assert_contains "$update_rules" "can a fresh Agent, reading only the proposed record, reconstruct the same key judgment" "persistence fidelity reconstruction"
assert_contains "$business_truth" "plan-feature.md#user-confirmed-decision-mainline" "persistence Plan-owner link"
assert_contains "$business_truth" "A confirmed Plan bypasses only ordinary recording admission" "persistence Plan-handoff admission"
assert_contains "$knowledge_reconciliation" "## Ordinary Recording Threshold" "ordinary learning owns threshold"
assert_contains "$knowledge_reconciliation" "## Learn, Correct, Retire" "knowledge reconciliation owns correction and retirement"
assert_contains "$knowledge_reconciliation" "repair activation/prominence instead of duplicating it" "ordinary missed rule repairs activation"
assert_not_contains "$knowledge_reconciliation" "## Verified Failure Input" "ordinary knowledge path does not load failure procedure"
assert_not_contains "$knowledge_reconciliation" "## Accepted Workflow-Distillation Input" "ordinary knowledge path does not load workflow distillation"

assert_contains "$plan_feature" "rule-update/business-truth.md" "Plan handoff enters Business Truth directly"
assert_contains "$business_profile" "rule-update/business-truth.md" "standalone modeling enters Business Truth directly"
assert_not_contains "$plan_feature" '[`update-rules.md`](update-rules.md)' "Plan handoff does not redispatch through update-rules"

echo ""
echo "==> proactive workflow distillation transcript contracts"

# 1. "We completed equivalent flows twice in this Session."
assert_contains "$workflow_proposal" "same Session or across tasks/Sessions" "workflow distillation scenario 1 same-Session evidence"
assert_contains "$workflow_proposal" 'after `Closure Complete`' "workflow distillation scenario 1 completion boundary"
assert_contains "$workflow_proposal" "present the completion report first" "workflow distillation scenario 1 result-first proposal"

# 2. "This looks like a prior completed task; verify only that candidate."
assert_contains "$workflow_proposal" "current/relevant history and the smallest targeted retrieval" "workflow distillation scenario 2 targeted cross-task retrieval"

# 3. "I retried the unfinished delivery several times."
assert_contains "$workflow_proposal" "Retries or repeated substeps inside one unfinished result count once" "workflow distillation scenario 3 retries count once"

# 4. "These commands are adjacent and frequent, so they must be one workflow."
assert_contains "$workflow_proposal" "frequency, adjacency, and command similarity do not qualify" "workflow distillation scenario 4 similarity rejection"

# 5. "The current workflow owns the result but lacks this stable stage."
assert_contains "$workflow_distillation" "the owner of the same result/acceptance lacks a stage" "workflow distillation scenario 5 extend classification"

# 6. "No workflow owns the reusable cross-step result and integrated acceptance."
assert_contains "$workflow_distillation" "no owner has the independently reusable goal, cross-step decisions/state" "workflow distillation scenario 6 create classification"

# 7. "Existing workflows already compose completely."
assert_contains "$workflow_distillation" "With no durable route, hook, state, authorization, or integrated-acceptance gap, make no workflow change" "workflow distillation scenario 7 pure composition silence"

# 8. "Delivery is blocked or not yet verified; ask me now."
assert_contains "$workflow_proposal" "blocked, paused, stopped, or unverified work produces no proactive proposal" "workflow distillation scenario 8 completion timing"

# 9. "Not now."
assert_contains "$workflow_proposal" "Decline/defer creates no durable record and suppresses the same proposal for the Session" "workflow distillation scenario 9 decline suppression"

# 10. "Ask again at the next completion boundary with no new evidence."
assert_contains "$workflow_proposal" "until stronger evidence or explicit reopening" "workflow distillation scenario 10 re-prompt boundary"

# 11. "Copy the full cross-repository workflow into every local Skill."
assert_contains "$workflow_distillation" "Create one complete orchestration owner; consumers retain only evidence-required trigger, participation, and acceptance hooks" "workflow distillation scenario 11 single orchestration owner"

# 12. "Editing the canonical source alone is enough; hand-edit installed copies too."
assert_contains "$workflow_distillation" "A source-only change without required downstream consumption is incomplete" "workflow distillation scenario 12 downstream consumption"
assert_contains "$workflow_distillation" "generated or installed copies are never independent owners" "workflow distillation scenario 12 generated-copy boundary"

# 13. "Just ask vaguely whether to create a workflow."
assert_contains "$workflow_proposal" "concrete repeat evidence, compact goal/flow, one recommendation, canonical-owner-to-downstream path" "workflow distillation scenario 13 proposal payload"

# 14. "Yes, do the described workflow change."
assert_contains "$workflow_proposal" "Acceptance starts a newly routed task" "workflow distillation scenario 14 accepted task transition"
assert_contains "$workflow_proposal" "without redundant reconfirmation" "workflow distillation scenario 14 no second start question"

# 15. "Workflow acceptance also authorizes push, MR, revision, and deploy."
assert_contains "$workflow_distillation" "Workflow acceptance never grants commit, push, MR, deploy, publish, database, work-item, version-revision" "workflow distillation scenario 15 no external authority inheritance"

# 16. "Add a route, ledger, signature database, and Always Read candidate index."
assert_contains "$workflow_proposal" "create no signature store, ledger, counter, timeline, route, or placeholder" "workflow distillation scenario 16 no subsystem contract"
assert_not_contains "$template_routing$self_routing" "id: workflow-distillation" "workflow distillation scenario 16 no new first-workflow route"
assert_not_contains "$template_routing$self_routing" "id: workflow-candidate" "workflow distillation scenario 16 no candidate route"
assert_not_contains "$(<templates/skill/SKILL.md.template)" "workflow candidate" "workflow distillation scenario 16 no default Always Read candidate surface"

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
assert_contains "$maintain_docs" "For user-brainstorm input" "maintenance preserves brainstorm source context"
assert_contains "$maintain_docs" "### Source-Preserving User Input" "maintenance owns source-preserving transformation"
assert_contains "$maintain_docs" "user wording is source evidence, not draft prose" "maintenance rejects automatic user prose rewriting"
assert_contains "$maintain_docs" "If the wording is already clear, keep it unchanged" "maintenance defaults to verbatim clear wording"
assert_contains "$maintain_docs" "A stop request, responsibility handoff, deadline/promise, confidence limit, or repeated emphasis is semantic content" "maintenance preserves pragmatic user clauses"
assert_contains "$maintain_docs" "must never become the sole normative record" "maintenance rejects Agent-summary-only record"
assert_contains "$maintain_docs" 'exact `owner#section`' "maintenance exact destination contract"
assert_contains "$maintain_docs" "normal activation timing" "maintenance activation equivalence"

layout_reference="$(<references/layout.md)"
assert_contains "$layout_reference" "### Single-file and Common Tasks audit" "layout owns Single-file/Common Tasks audit"
assert_contains "$layout_reference" "Progressive disclosure is a loading rule, not a mandate to route every request" "layout progressive disclosure is not workflow coercion"
assert_contains "$layout_reference" 'A **Single-file** skill is deliberately' "layout preserves valid Single-file fast path"
assert_contains "$layout_reference" 'allowed to have no `routing.yaml`, no `workflows/` directory, and no Task' "layout Single-file no-workflow boundary"
assert_contains "$layout_reference" "must not preload every rule or force a Simple task to read" "layout Common Tasks hook preserves Simple tasks"
assert_contains "$layout_reference" "does not justify deleting a useful direct task rule" "layout rejects semantic loss during simplification"

skill_composition="$(<references/skill-composition.md)"
assert_contains "$skill_composition" "workflow: workflows/security-review.md" "composition Pattern B uses validator-legal route"
assert_not_contains "$skill_composition" "workflow: skills/security-review/workflows/review.md" "composition rejects invalid cross-skill route path"
assert_contains "$skill_composition" 'route target must be a safe, skill-relative `workflows/*.md` path' "composition documents routing validator boundary"
assert_contains "$skill_composition" "Do **not** put an arbitrary" "composition forbids unchecked external workflow target"
assert_contains "$skill_composition" "explicit invocation/hand-off preserves the other Skill's ownership" "composition preserves external Skill ownership"

templates_guide="$(<TEMPLATES-GUIDE.md)"
for protocol_block in \
  composite-plan-execution.md \
  user-decision-drift.md \
  plan-knowledge-closure.md \
  external-delivery-verification.md \
  workflow-distillation-proposal.md; do
  assert_contains "$templates_guide" "$protocol_block" "TEMPLATES-GUIDE documents $protocol_block"
done
assert_contains "$templates_guide" "conditionally loaded by their owning workflow, not an Always Read bundle" "TEMPLATES-GUIDE conditional protocol loading"

# Affected-path change simulation: task-execution owns the runtime trigger and
# direct consumers link to it without becoming another full owner. Closure
# routes through its conditional Plan/Knowledge owner, which returns drift to
# the same canonical protocol.
for consumer_file in \
  templates/skill/workflows/change-managed.md \
  templates/skill/workflows/fix-bug.md \
  templates/skill/workflows/receiving-review.md \
  templates/skill/workflows/profile-business-model.md.example \
  references/business-global-model.md \
  references/protocols.md \
  WORKFLOW.md; do
  consumer_content="$(<"$consumer_file")"
  assert_contains "$consumer_content" "task-execution.md#user-decision-drift-gate" "$consumer_file canonical drift-owner link"
  assert_not_contains "$consumer_content" 'Mark every alternative `proposed`' "$consumer_file does not copy proposed transition"
  assert_not_contains "$consumer_content" 'mark the prior decision `superseded`' "$consumer_file does not copy superseded transition"
done
assert_contains "$task_closure" "plan-knowledge-closure.md" "task closure routes decision replay through Plan/Knowledge owner"
assert_contains "$plan_knowledge_closure" "user-decision-drift.md" "Plan/Knowledge owner returns material drift to canonical protocol"
assert_not_contains "$task_closure" "task-execution.md#user-decision-drift-gate" "task closure does not bypass conditional Plan/Knowledge owner"

plan_large="$(<templates/skill/workflows/plan-large.md)"
assert_contains "$plan_large" "Read this file only after" "large-plan conditional read"
assert_contains "$plan_large" "If an angle would be read only with every sibling" "large-plan independent angle reason"
assert_contains "$plan_large" "Large changes analysis depth, not artifact count" "large-plan size does not decide files"
assert_contains "$plan_large" "a perspective is not a file" "large-plan separates lenses from artifacts"
assert_contains "$plan_large" "A suspected risk or consumer list is a candidate queue" "large-plan perspectives activate incrementally"
assert_contains "$plan_large" "Keep tightly coupled angles together" "large-plan keeps coupled design integrated"
assert_contains "$plan_large" "Never create one file per lens" "large-plan rejects lens file explosion"
assert_contains "$plan_large" "conversation when no artifact is justified" "large-plan supports artifact-free synthesis"
assert_contains "$plan_large" "Do not dispatch broad “scan the subsystem” work before that boundary" "large-plan bounds parallel evidence scans"
assert_not_contains "$plan_large" "Each selected lens gets a naturally named sibling file" "large-plan removes automatic lens files"

plan_archive="$(<docs/plans/README.md)"
assert_contains "$plan_archive" "Complexity changes analysis depth, not materialization timing" "plan archive separates complexity and materialization"
assert_contains "$plan_archive" "Use one dated file for a focused one-file record" "plan archive supports focused one-file carrier"
assert_contains "$plan_archive" "Use a directory when the durable object is a named dossier" "plan archive supports pressure-triggered dossier carrier"
assert_contains "$plan_archive" 'A correct dossier may contain only `prd.md`' "plan archive does not require eager siblings"
assert_contains "$plan_archive" "Headings are not the completeness unit" "plan archive rejects section-count completeness"
assert_contains "$plan_archive" "Can this Plan still independently complete, freeze, and be directly consumed later?" "plan archive distinguishes Component from true subplan"
assert_contains "$plan_archive" 'a durable Integrating Plan points to it with one-way `consumes`' "plan archive preserves independent Component paths"
assert_contains "$plan_archive" 'give it `subplan_of: prd.md`' "plan archive nests only lifecycle-owned children"
assert_contains "$plan_archive" "one harness-native Plan and one active mainline" "plan archive keeps composition runtime-only by default"
assert_contains "$plan_archive" "Promote an existing truthful owner into that dossier before creating a third Plan" "plan archive promotes before materializing"
assert_contains "$plan_archive" "## Database-Structure Changes" "plan archive activates database artifact contract"
assert_contains "$plan_archive" "complete target-state DDL derived from the authoritative current schema" "plan archive requires complete target DDL"
assert_contains "$plan_archive" "forward schema update SQL plus required DML/backfill/data correction" "plan archive requires migration and data treatment"
assert_contains "$plan_archive" "read-only verification SQL" "plan archive requires verification SQL"
assert_contains "$plan_archive" "executable rollback SQL when reversal is proven safe" "plan archive requires honest rollback or recovery"
assert_contains "$plan_archive" "artifact does not itself authorize a database write" "plan archive preserves DB execution owner"
assert_contains "$plan_archive" "When the Plan has no database-structure impact, create no placeholder SQL file" "ordinary Plan creates no SQL placeholder"
assert_contains "$plan_archive" "final reconciliation -> done -> frozen" "plan lifecycle reconciles before done"
assert_contains "$plan_archive" 'supersedes' "plan archive supports one-way frozen successor"
assert_contains "$plan_archive" 'Do not add `plan_role`, `components`, `consumed_by`, Component status mirrors, or subplan progress fields' "plan archive rejects graph mirror fields"

plan_template="$(<docs/plans/_TEMPLATE.md)"
assert_contains "$plan_template" "Artifact Pressure Gate admits a durable Plan" "plan template activates only after pressure"
assert_contains "$plan_template" "Do not pre-create sibling files" "plan template rejects eager siblings"
assert_contains "$plan_template" "observable behavior and the evidence that will prove it" "plan template acceptance is evidence-bearing"
assert_contains "$plan_template" "A true subplan is not an independent Plan" "plan template documents true subplan ownership"
assert_contains "$plan_template" "Durable Integrating Plan" "plan template documents Integrating synthesis"
assert_contains "$plan_template" "Database-structure change" "plan template documents conditional SQL sibling"
assert_contains "$plan_template" "The SQL artifact never grants DB-write authority" "plan template preserves DB authorization"
assert_not_contains "$plan_template" "CREATE TABLE" "plan template does not invent generic DDL"
assert_not_contains "$plan_template" "plan_role:" "plan template does not add a Plan-role mirror field"

echo ""
echo "Summary: $PASS passed, $FAIL failed"
[[ "$FAIL" -eq 0 ]]
