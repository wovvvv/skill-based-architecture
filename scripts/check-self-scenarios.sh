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
assert_contains "$(<templates/skill/workflows/plan-feature.md)" 'self-hosting `product-direction`' "SBA product direction workflow checkpoint"
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
assert_contains "$task_execution" "canonical owner of the gate's trigger" "task execution canonical drift owner"
assert_contains "$task_execution" "Pause the affected implementation path immediately" "task execution drift pauses affected path"
assert_contains "$task_execution" "Independent work may continue only when it cannot prejudge the decision" "task execution affected-path concurrency boundary"
assert_contains "$task_execution" 'Mark every alternative `proposed`' "task execution proposed-alternative transition"
assert_contains "$task_execution" 'mark the prior decision `superseded`' "task execution superseded-mainline transition"
assert_contains "$task_execution" "never treat a late disclosure in review/Closure" "task execution rejects deferred drift disclosure"
assert_contains "$task_execution" "do not narrate it before every tool call" "task execution no per-tool narration"
assert_contains "$task_execution" "does not create durable planning files or recover task state across Sessions" "task execution session-only boundary"
assert_contains "$task_execution" "a new independent outcome re-matches the route and replaces them" "task execution new-task reset"
assert_contains "$task_execution" "cannot omit or semantically reorder a mandatory gate" "task execution Workflow authority"
assert_not_contains "$task_execution" "task_plan.md" "task execution no fixed task-plan file"
assert_not_contains "$task_execution" "cross-tool state sync" "task execution no cross-tool state system"
assert_not_contains "$task_execution" "Plan: <concise task-specific steps" "task execution no fixed chat block"
assert_contains "$task_execution" "Clear tasks keep the direct fast path" "task execution Change Contract fast path"
assert_contains "$task_execution" "source-localization.md" "task execution technical-owner hook"
assert_contains "$task_execution" "## Verified Failure Handoff" "task execution verified-failure owner hook"
assert_contains "$task_execution" "Session-only failure candidate" "failed check stays Session-only before proof"
assert_contains "$task_execution" "Retries inside the same unresolved task remain one occurrence" "unresolved retries are not recurrence"
assert_contains "$task_execution" "update-rules.md#verified-failure-input" "proven repair hands off to Rule Update"
assert_contains "$task_execution" "Rule Update owns durable reconciliation" "task execution does not duplicate durable semantics"
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
assert_contains "$task_execution" "present only useful alignment" "task execution proportional Anchor presentation"
assert_contains "$task_execution" "do not repeat its steps in chat" "task execution native Plan deduplication"
assert_contains "$task_execution" "Before each main Plan step" "task execution Anchor checkpoint activation"

task_closure="$(<templates/skill/workflows/task-closure.md)"
assert_contains "$task_closure" "### Entry Gate" "closure execution entry gate"
assert_contains "$task_closure" 'return to [`task-execution.md`](task-execution.md)' "closure cannot finish execution"
assert_contains "$task_closure" "final Anchor Checkpoint" "closure final Anchor checkpoint"
assert_contains "$task_closure" "Replay the user-confirmed mainline" "closure decision-mainline replay"
assert_contains "$task_closure" "Reconcile Component owners first" "closure reconciliation owner"
assert_contains "$task_closure" "If Closure first surfaces material drift" "closure rejects first drift disclosure"
assert_contains "$task_closure" "for business-bearing decisions, also read the routed business rule" "closure optional business-leaf boundary"
assert_contains "$task_closure" "task-execution.md#user-decision-drift-gate" "closure drift-owner link"
assert_contains "$task_closure" "Ready for Delivery" "closure distinguishes readiness from completion"
assert_contains "$task_closure" "Closure never grants commit, push, MR, deploy, publish" "closure preserves delivery authority boundary"
assert_contains "$task_closure" "leaves Closure open" "closure stays open on delivery failure"
assert_contains "$task_closure" "without rerunning unrelated local checks" "closure scopes unchanged external retries"
assert_contains "$task_closure" "Closure Complete" "closure verifies delivery before completion"
assert_contains "$task_closure" "The command exited 0, so the stage is complete" "closure build-success false-completion scenario"
assert_contains "$task_closure" "proves only the command's own contract" "closure exit-code evidence boundary"
assert_contains "$task_closure" "treating that exit code as sufficient completion evidence by itself" "closure red-flags exit-code sufficiency"
assert_contains "$task_closure" 'final expanded [`Change Contract`](../protocol-blocks/change-contract.md)' "closure bound-contract reconciliation"
assert_contains "$task_closure" "does not define Semantic Intent or source-localization stages" "closure stays a consumer"
assert_contains "$task_closure" "Reconcile Component owners first" "closure reconciles Component owners before integration"
assert_contains "$task_closure" 'enumerate `consumes` and read current truth from each Component owner rather than a mirror' "closure reads Component truth at its owner"
assert_contains "$task_closure" 'no required Component may remain `draft` or `executing`' "closure blocks unfinished Components"
assert_contains "$task_closure" 'Reject missing, `abandoned`, unresolved-Delta, or superseded-but-still-consumed inputs' "closure blocks stale Component inputs"
assert_contains "$task_closure" "Abandoning the Integrating Plan leaves independent Component states unchanged" "integration abandonment preserves Component lifecycle"
assert_contains "$task_closure" "SQL-file existence alone is neither schema readiness nor DB delivery" "closure separates SQL review from DB delivery"
assert_contains "$task_closure" "authoritative schema/data readback" "closure requires authoritative DB delivery proof"
assert_contains "$task_closure" "Account for verified failures" "closure accounts for repair-time learning"
assert_contains "$task_closure" 'completed [`update-rules.md` § Verified Failure Input]' "closure requires one outcome per verified failure"
assert_contains "$task_closure" "Closure does not diagnose root cause or postpone the first write" "closure stays accounting-only"
assert_contains "$task_closure" "Do not re-record an already-reconciled verified failure" "closure does not duplicate repair-time learning"
assert_contains "$task_closure" "verified failure that lacks a completed learning outcome" "closure rejects missing learning outcome"

plan_feature="$(<templates/skill/workflows/plan-feature.md)"
assert_contains "$plan_feature" "## Deliverable Gate" "plan classifies the requested deliverable before expansion"
assert_contains "$plan_feature" "Method/review/brainstorm requests are read-only advisory work" "plan keeps advisory requests bounded"
assert_contains "$plan_feature" "inspect only representative evidence needed to support the evaluation" "plan advisory review uses representative evidence"
assert_contains "$plan_feature" "do not execute every Design Slice, materialize artifacts, or build Task Breakdown" "plan advisory review does not run the full plan"
assert_contains "$plan_feature" "it is not the runtime Native Plan" "design plan runtime boundary"
assert_contains "$plan_feature" "pass its chosen outcome, acceptance criteria, boundaries, and task breakdown" "design to execution transition"
assert_contains "$plan_feature" "## User-Confirmed Decision Mainline" "plan user-confirmed decision source"
assert_contains "$plan_feature" "canonical owner of Decision Delta capture and Plan Mainline Handoff" "plan decision owner"
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
assert_contains "$task_execution" "exactly one Integrating Task Anchor and Native Plan" "composite execution has one Native Plan mainline"
assert_contains "$task_execution" 'they do not create competing anchors, live step stores, or semantic `Current Task` entries' "Components do not become parallel runtime plans"
assert_contains "$task_execution" 'A missing, `abandoned`, or replaced Component cannot drive mutation' "invalid Component blocks execution"
assert_contains "$task_execution" "active Components use an explicit Decision Delta" "active Component conflict returns to its owner"
assert_contains "$task_execution" "frozen Components require a successor" "frozen Component conflict creates a successor"
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
assert_contains "$fix_bug" "update-rules.md#active-bug-fix-input" "fix-bug immediate business-recording owner link"
assert_contains "$fix_bug" "instead of waiting for Task Closure" "fix-bug does not defer durable user input"
assert_contains "$fix_bug" 'the only source eligible for a `references/business/<module>.md` record is the user' "fix-bug user-content-only source"
assert_contains "$fix_bug" "Do not derive a business rule from the Bug" "fix-bug rejects bug-derived business rules"
assert_contains "$fix_bug" "Bug symptoms, root cause, repaired behavior, code, tests, runtime evidence, and Agent summaries are not" "fix-bug excludes repair evidence from desired truth"
assert_contains "$fix_bug" "update-rules.md#verified-failure-input" "fix-bug immediate engineering-learning owner link"
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
assert_contains "$update_rules" "## Active Bug-Fix Input" "update-rules active bug-fix admission owner"
assert_contains "$update_rules" "The only business-recording source during Fix Bug is the user's explicit business statement" "update-rules user-content-only source"
assert_contains "$update_rules" "Preserve the user's meaning faithfully" "update-rules user-meaning fidelity"
assert_contains "$update_rules" "Do not derive a business rule from the Bug" "update-rules rejects bug-derived intent"
assert_contains "$update_rules" "Reusable engineering lessons discovered while fixing the Bug enter Verified Failure Input immediately after fitted red-to-green proof" "update-rules repair-time engineering input"
assert_contains "$update_rules" "Fix Bug owns noticing and immediate invocation" "update-rules fix-bug local-action boundary"
assert_contains "$update_rules" "## Verified Failure Input" "update-rules complete verified-failure owner"
assert_contains "$update_rules" "first proven actionable failure bypasses only the Recording Threshold" "first proven prevention writes without waiting for recurrence"
assert_contains "$update_rules" "activate it in the same change rather than waiting for another occurrence or final AAR" "first write includes next-task activation"
assert_contains "$update_rules" "same proven root cause + same applicability boundary + same prevention action" "recurrence uses cause boundary and prevention"
assert_contains "$update_rules" "retries inside one unresolved task are one occurrence" "rule update rejects retry counting"
assert_contains "$update_rules" "repair activation instead of adding prose" "recurrence repairs missed activation first"
assert_contains "$update_rules" "Failure learning never grants commit, push, MR, deploy, publish, database, production, or other external authority" "failure learning preserves authority boundary"
for failure_outcome in covered/no-write extend-existing correct-existing add-and-activate transient/no-write requires-user-authority escalate-prevention; do
  assert_contains "$update_rules" "\`$failure_outcome\`" "verified-failure outcome $failure_outcome"
done
assert_not_contains "$fix_bug$update_rules" "follow normal Closure/AAR" "verified engineering learning is not deferred"
assert_not_contains "$template_routing$self_routing" "id: memory" "failure learning adds no Memory route"
for outcome in "No write" "Extend in place" "Correct in place" "Retire" "Add independently"; do
  assert_contains "$update_rules" "$outcome" "gotcha reconciliation outcome"
done
assert_contains "$update_rules" "can a fresh Agent, reading only the proposed record, reconstruct the same key judgment" "persistence fidelity reconstruction"
assert_contains "$update_rules" "## Plan Decision Source" "persistence Plan-decision source"
assert_contains "$update_rules" "plan-feature.md#user-confirmed-decision-mainline" "persistence Plan-owner link"
assert_contains "$update_rules" "owns distillation and reconciliation" "persistence distillation owner"
assert_contains "$update_rules" "Plan confirmed for implementation" "persistence Plan-handoff sync"
assert_contains "$update_rules" "bypasses only the Recording Threshold" "persistence Plan-handoff admission"

echo ""
echo "==> proactive workflow distillation transcript contracts"

# 1. "We completed equivalent flows twice in this Session."
assert_contains "$task_closure" "same Session or across tasks/Sessions" "workflow distillation scenario 1 same-Session evidence"
assert_contains "$task_closure" 'only after `Closure Complete`, with the completion report first' "workflow distillation scenario 1 result-first proposal"

# 2. "This looks like a prior completed task; verify only that candidate."
assert_contains "$task_closure" "current/relevant history and the smallest targeted retrieval" "workflow distillation scenario 2 targeted cross-task retrieval"

# 3. "I retried the unfinished delivery several times."
assert_contains "$task_closure" "Retries or repeated substeps inside one unfinished delivery count once" "workflow distillation scenario 3 retries count once"

# 4. "These commands are adjacent and frequent, so they must be one workflow."
assert_contains "$task_closure" "temporal adjacency, frequency, or command/tool similarity does not qualify" "workflow distillation scenario 4 similarity rejection"

# 5. "The current workflow owns the result but lacks this stable stage."
assert_contains "$update_rules" "the owner of the same result/acceptance is missing a stage" "workflow distillation scenario 5 extend classification"

# 6. "No workflow owns the reusable cross-step result and integrated acceptance."
assert_contains "$update_rules" "no owner has the independently reusable goal, cross-step decisions/state" "workflow distillation scenario 6 create classification"

# 7. "Existing workflows already compose completely."
assert_contains "$update_rules" "With no durable gap, make no workflow change" "workflow distillation scenario 7 pure composition silence"

# 8. "Delivery is blocked or not yet verified; ask me now."
assert_contains "$task_closure" "Blocked, paused, stopped, or unverified work produces no proactive question" "workflow distillation scenario 8 completion timing"

# 9. "Not now."
assert_contains "$task_closure" "creates no durable candidate/rejection record and suppresses the same normalized proposal for the current Session" "workflow distillation scenario 9 decline suppression"

# 10. "Ask again at the next completion boundary with no new evidence."
assert_contains "$task_closure" "Re-prompt only after materially stronger evidence or explicit user reopening" "workflow distillation scenario 10 re-prompt boundary"

# 11. "Copy the full cross-repository workflow into every local Skill."
assert_contains "$update_rules" "Create one complete orchestration owner; consumers keep only evidence-required trigger, participation, and acceptance hooks" "workflow distillation scenario 11 single orchestration owner"

# 12. "Editing the canonical source alone is enough; hand-edit installed copies too."
assert_contains "$update_rules" "A source-only change without downstream consumption is incomplete" "workflow distillation scenario 12 downstream consumption"
assert_contains "$update_rules" "generated or installed copies are never independent owners and must not be hand-edited in parallel" "workflow distillation scenario 12 generated-copy boundary"

# 13. "Just ask vaguely whether to create a workflow."
assert_contains "$task_closure" "concrete repeat evidence, compact goal/flow, one recommendation, canonical-owner-to-downstream path" "workflow distillation scenario 13 proposal payload"

# 14. "Yes, do the described workflow change."
assert_contains "$task_closure" "Acceptance starts a newly routed task" "workflow distillation scenario 14 accepted task transition"
assert_contains "$task_closure" "without redundant reconfirmation" "workflow distillation scenario 14 no second start question"

# 15. "Workflow acceptance also authorizes push, MR, revision, and deploy."
assert_contains "$update_rules" "Workflow acceptance authorizes only the described durable mutation and fitted local verification" "workflow distillation scenario 15 scoped authority"
assert_contains "$update_rules" "It never grants commit, push, MR, deploy, publish, database, work-item, version-revision, reviewer-selection, merge" "workflow distillation scenario 15 no external authority inheritance"

# 16. "Add a route, ledger, signature database, and Always Read candidate index."
assert_contains "$task_closure" "never scan all history or create a signature store, candidate ledger, counter, timeline, route, or placeholder" "workflow distillation scenario 16 no subsystem contract"
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
