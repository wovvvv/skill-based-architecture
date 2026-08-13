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
  "需求已经确认,制定实现 plan" \
  "plan-feature" \
  "templates/skill/workflows/plan-feature.md"

check_scenario \
  "self-hosting Requirement-only PRD delivery" \
  "references/self-hosting-routing.yaml" \
  "先形成或更新 PRD Requirement,不要写实现 Plan 或代码" \
  "define-requirement" \
  "templates/skill/workflows/define-requirement.md"

check_scenario \
  "downstream Requirement-only PRD delivery" \
  "templates/skill/routing.yaml" \
  "先形成或更新 PRD Requirement,不要写实现 Plan 或代码" \
  "define-requirement" \
  "workflows/define-requirement.md"

assert_not_contains \
  "$(task_block references/self-hosting-routing.yaml plan-feature)$(task_block templates/skill/routing.yaml plan-feature)" \
  "先形成或更新 PRD Requirement,不要写实现 Plan 或代码" \
  "Requirement-only PRD does not route through Plan Feature"

assert_not_contains \
  "$(task_block references/self-hosting-routing.yaml plan-feature)" \
  "templates/skill/workflows/update-rules.md" \
  "draft plan initial reads"

check_scenario \
  "SBA product direction" \
  "references/self-hosting-routing.yaml" \
  "SBA 应该往什么方向发展" \
  "define-requirement" \
  "templates/skill/workflows/define-requirement.md"

product_direction="$(task_block references/self-hosting-routing.yaml define-requirement)"
assert_contains "$product_direction" "吸收一个外部项目" "SBA product direction external-project trigger"
assert_contains "$product_direction" "增加一个重大机制" "SBA product direction major-mechanism trigger"
assert_contains "$product_direction" "Read docs/sba-bible.md after workflow selection when the request concerns SBA product direction" "SBA product direction conditional Bible read"
assert_not_contains "$product_direction" "required_reads:" "SBA product direction does not preload Bible"
assert_contains "$(<templates/skill/workflows/define-requirement.md)" "Requirement brainstorming explores outcomes, actors, models, flows" "SBA product direction requirement brainstorm owner"
assert_not_contains "$(<templates/skill/workflows/plan-feature.md)" "docs/sba-bible.md" "ordinary implementation planning excludes SBA product doctrine"

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
requirement_definition="$(<templates/skill/workflows/define-requirement.md)"
assert_not_contains "$(<templates/skill/routing.yaml)$(<references/self-hosting-routing.yaml)" "id: change-contract" "Change Contract is not a first-workflow route"
assert_not_contains "$(<templates/skill/routing.yaml)$(<references/self-hosting-routing.yaml)" "id: source-localization" "source localization is not a first-workflow route"
assert_not_contains "$(<templates/skill/routing.yaml)" "protocol-blocks/change-contract.md" "Change Contract is not an eager routing read"
assert_not_contains "$(<templates/skill/routing.yaml)" "protocol-blocks/source-localization.md" "source localization is not an eager routing read"
assert_contains "$change_contract" "A clear request, confirmed Requirement/issue/PRD, or accepted decision may" "Change Contract readiness fast path"
assert_contains "$change_contract" "when work adds or changes user-visible" "Change Contract requirement-bearing trigger"
assert_contains "$change_contract" "satisfy it immediately without expanded state or another confirmation" "Change Contract clear-request no-question path"
assert_contains "$change_contract" "locality, estimate, elapsed time, file count, keywords, or complexity never" "Change Contract apparent-size no-bypass boundary"
assert_contains "$change_contract" "Every material requirement-bearing input receives an evidenced disposition" "Change Contract input coverage"
assert_contains "$change_contract" '`requirement-ready` means no remaining user-owned choice can redirect' "Change Contract requirement-ready definition"
assert_contains "$change_contract" "These dimensions are conditional, never a fixed questionnaire" "Change Contract adaptive readiness dimensions"
assert_contains "$change_contract" "Agent-discoverable files, symbols, callers" "Change Contract keeps technical discovery with the Agent"
assert_contains "$change_contract" "Bind Current -> Target without changing the Requirement" "Change Contract binds normal Current/Target difference"
assert_contains "$change_contract" "A final file list, line-level design, exhaustive call graph" "Change Contract avoids broad pre-mutation inventory"
assert_contains "$change_contract" "Evidence changing desired meaning or acceptance returns to Requirement" "Change Contract evidence-driven return"
assert_contains "$change_contract" 'creates the Task Anchor after `requirement-ready`, but creates the Native Plan' "Change Contract Anchor readiness ordering"
assert_contains "$change_contract" 'only after `implementation-ready`; the Plan consumes rather than defines the' "Change Contract implementation readiness precedes Native Plan"
assert_contains "$change_contract" "ordinary tasks create no contract file" "Change Contract Session-only default"
assert_contains "$requirement_definition" "present the current understanding in concrete outcome terms" "Requirement Definition incomplete understanding"
assert_contains "$requirement_definition" "name only evidence-backed risk, conflict" "Requirement Definition real-risk boundary"
assert_contains "$requirement_definition" "ask the minimum normative question needed" "Requirement Definition minimum-question boundary"
assert_contains "$requirement_definition" "stop before implementation planning, Task Breakdown, or mutation" "Requirement Definition mutation stop"
assert_contains "$requirement_definition" "Requirement brainstorming explores outcomes, actors, models, flows" "Requirement Definition brainstorm scope"
assert_contains "$requirement_definition" "Discuss one load-bearing normative topic at a time" "Requirement Definition one-topic brainstorm"
assert_contains "$requirement_definition" "material risk or trade-off, the Agent's recommendation" "Requirement Definition decision-ready brainstorm"
assert_contains "$requirement_definition" "When the Requirement is already clear, ask no question" "Requirement Definition clear no-question path"
assert_contains "$requirement_definition" "## Requirement Artifact Pressure Gate" "Requirement Definition owns durable Requirement pressure"
assert_contains "$requirement_definition" "Keep the Requirement Contract in the current Session by default" "Requirement Definition Session-only default"
assert_contains "$requirement_definition" "update the smallest Governing Requirement only when the user explicitly asks" "Requirement Definition explicit PRD pressure"
assert_contains "$requirement_definition" "independent reader, review" "Requirement Definition independent consumer pressure"
assert_contains "$requirement_definition" "Complexity, activity, implementation size, or a clear Requirement alone is not" "Requirement Definition rejects size-only persistence"
assert_contains "$requirement_definition" "real project code root and follow its local Requirement archive contract" "Requirement Definition code-root guard"
assert_contains "$requirement_definition" "Exclude Current -> Target implementation design" "Requirement artifact excludes implementation design"
assert_contains "$requirement_definition" "Requirement does not enter Plan Feature or authorize mutation" "Requirement artifact does not borrow Plan or mutation"
assert_contains "$requirement_definition" "A later durable implementation Plan links to and consumes this owner one way" "Plan consumes durable Requirement one way"
assert_contains "$requirement_definition" "Plan Feature cannot copy, narrow, resolve, or update the Governing" "Plan cannot edit Governing Requirement"
assert_not_contains "$requirement_definition" "Do not create a Requirement file, Task Anchor, or Plan here" "Requirement Definition rejects old absolute no-file rule"
assert_not_contains "$requirement_definition" "Requirement-only PRD uses Plan Feature's Artifact Pressure Gate" "Requirement Definition rejects Plan-borrowed persistence"
assert_not_contains "$requirement_definition" "## Technical Design Slices" "Requirement Definition excludes implementation design"
assert_contains "$source_localization" "skip directly to a selected-source check when the target is already proven concrete" "source localization known-target fast path"
assert_contains "$source_localization" "Stages 1-2 expose no source bodies" "source localization progressive source exposure"
assert_contains "$source_localization" "Empty/noisy/truncated results refine or return" "source localization failed-search return"
assert_contains "$source_localization" "a path, lexical match, file read, or successful command is not owner proof" "source localization owner-proof boundary"
assert_contains "$source_localization" "Source evidence may falsify a Current premise or expose a Requirement conflict" "source localization authority boundary"
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
assert_contains "$task_execution" "Classify by whether an explicit goal or requirement changes execution" "task execution classifier decision basis"
assert_contains "$task_execution" "one clear read-only or fixed-contract maintenance action" "task execution fixed-contract Simple boundary"
assert_contains "$task_execution" "no new desired behavior/contract" "task execution excludes new behavior from Simple"
assert_contains "$task_execution" 'a `requirement-ready` addition/change to user-visible behavior, business flow/state, or external contract' "task execution requirement-bearing Managed trigger"
assert_contains "$task_execution" "Apparent code locality never makes requirement-bearing work Simple" "task execution locality no-Simple boundary"
assert_contains "$task_execution" "reclassify before more mutation" "task execution in-place reclassification"
assert_contains "$task_execution" "build only the remaining Native Plan rather than asking the user to restate the task" "task execution preserves evidence during reclassification"
assert_contains "$task_execution" "a technical architecture choice between implementations that preserve a ready Requirement" "task execution Design classification boundary"
assert_contains "$task_execution" 'after `implementation-ready`, convert its result into a Managed task' "task execution Design-to-Managed transition"
assert_contains "$task_execution" "Proceed unless a real decision, authority boundary" "task execution auto-start default"
assert_contains "$task_execution" "project the observable Goal" "task execution projects Requirement goal"
assert_contains "$task_execution" "Done When acceptance, and only material Boundaries" "task execution projects Requirement acceptance and boundaries"
assert_contains "$task_execution" "The Native Plan owns only implementation/proof steps and live status" "task execution Plan implementation-only boundary"
assert_contains "$task_execution" "material acceptance/risk to fitted evidence" "task execution maps acceptance to proof"
assert_contains "$task_execution" "Technical evidence that changes only Current facts" "task execution technical evidence branch"
assert_contains "$task_execution" "without editing the Anchor" "task execution technical evidence preserves Anchor"
assert_contains "$task_execution" "would change Goal, Done When, scope, preservation, permission, or acceptance" "task execution normative evidence branch"
assert_contains "$task_execution" 'updated and reaches `requirement-ready` again' "task execution Requirement re-readiness"
assert_contains "$task_execution" "may Task Execution re-project the" "task execution reprojects only after Requirement"
assert_not_contains "$task_execution" "Re-anchor only when the user or evidence changes the Requirement frame" "task execution rejects evidence-owned Requirement frame"
assert_not_contains "$task_execution" "If evidence changes the premise, scope, ordering, or Done When, update the Anchor" "task execution rejects direct Anchor rewrite"
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
assert_contains "$task_execution" "every governing Requirement and Plan path" "task execution design-source handoff"
assert_contains "$task_execution" "Only business-bearing decisions require a routed business rule" "task execution technical-plan business-leaf boundary"
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
assert_contains "$user_decision_drift" "in the governing Requirement mainline" "decision drift records source-faithful answer in Requirement"
assert_contains "$user_decision_drift" "retain the source wording or ask the user" "decision drift ambiguity preserves source authority"
assert_contains "$user_decision_drift" 'mark the prior decision `superseded`' "decision drift superseded-mainline transition"
assert_contains "$user_decision_drift" "re-project the Task Anchor, rebind implementation facts, and replace the remaining Native Plan before more mutation" "decision drift updates runtime mainline"
assert_contains "$user_decision_drift" "Never silently compromise a confirmed mainline" "decision drift rejects implementation-led meaning loss"
assert_contains "$user_decision_drift" "A late disclosure in review or Closure never substitutes" "decision drift rejects deferred disclosure"
assert_contains "$task_execution" "do not narrate it before every tool call" "task execution no per-tool narration"
assert_contains "$task_execution" "does not create durable planning files or recover task state across Sessions" "task execution session-only boundary"
assert_contains "$task_execution" "a new independent outcome re-matches the route and replaces them" "task execution new-task reset"
assert_contains "$task_execution" "first updates the Requirement through" "task execution updates Requirement before runtime state"
assert_contains "$task_execution" "Already-clear wording stays verbatim" "task execution leaves clear user wording unchanged"
assert_contains "$task_execution" "an Agent-derived summary cannot be the only normative record" "task execution rejects summary-only authority"
assert_contains "$task_execution" "cannot omit or semantically reorder a mandatory gate" "task execution Workflow authority"
assert_not_contains "$task_execution" "task_plan.md" "task execution no fixed task-plan file"
assert_not_contains "$task_execution" "cross-tool state sync" "task execution no cross-tool state system"
assert_not_contains "$task_execution" "Plan: <concise task-specific steps" "task execution no fixed chat block"
assert_contains "$task_execution" 'Requirement-bearing changes always evaluate [`change-contract.md`](../protocol-blocks/change-contract.md)' "task execution requirement contract activation"
assert_contains "$task_execution" 'clear input may satisfy `requirement-ready` immediately without questions' "task execution clear-request no-question path"
assert_contains "$task_execution" "Fixed-contract Simple tasks keep the direct fast path" "task execution fixed-contract fast path"
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

assert_contains "$task_execution" "one direct check, no new desired behavior/contract" "task execution Simple direct path"
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
assert_contains "$task_closure" "restate the governing Requirement projection and Task Anchor" "closure reads back governing Requirement"
assert_contains "$task_closure" "Plan-selected proof set, escalation signals, stop point" "closure reads back proof and escalation"
assert_contains "$task_closure" "does not redefine Requirement meaning, source-localization stages, read breadth, or proof depth after green" "closure cannot expand a green contract"
assert_contains "$task_closure" "plan-knowledge-closure.md" "closure conditional Plan/Knowledge owner link"
assert_contains "$plan_knowledge_closure" "Replay each relevant user-confirmed Requirement Decision Context" "Plan/Knowledge decision-mainline replay"
assert_contains "$plan_knowledge_closure" 'enumerate every one-way `consumes` edge' "Plan/Knowledge explicit Component dependency graph"
assert_contains "$plan_knowledge_closure" "read each Component from its canonical owner" "Plan/Knowledge reconciliation owner"
assert_contains "$plan_knowledge_closure" 'A `done` Component is frozen' "Plan/Knowledge frozen Component lifecycle"
assert_contains "$plan_knowledge_closure" 'no required Component may remain `draft` or `executing`' "Plan/Knowledge unfinished Component lifecycle gate"
assert_contains "$plan_knowledge_closure" 'a true `subplan_of` shares its parent'"'"'s lifecycle' "Plan/Knowledge true subplan lifecycle"
assert_contains "$plan_knowledge_closure" "an independent Component retains its own lifecycle" "Plan/Knowledge independent Component lifecycle"
assert_contains "$plan_knowledge_closure" "Decision Delta, local acceptance, fresh proof, delivery responsibility, and durable distillation" "Plan/Knowledge complete Component reconciliation payload"
assert_contains "$plan_knowledge_closure" "Material drift returns to [" "Plan/Knowledge rejects first drift disclosure"
assert_contains "$plan_knowledge_closure" "read the routed business rule" "Plan/Knowledge optional business-leaf boundary"
assert_contains "$plan_knowledge_closure" "Plan Leaf Reconciliation before implementation handoff" "Plan/Knowledge verifies implementation handoff"
assert_contains "$plan_knowledge_closure" "before implementation handoff" "Plan/Knowledge handoff timing"
assert_contains "$plan_knowledge_closure" "preserve one-way Requirement Provenance" "Plan/Knowledge requirement provenance"
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
assert_contains "$task_closure" "does not redefine Requirement meaning, source-localization stages" "closure stays a consumer"
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
assert_contains "$plan_feature" "Advisory requests inspect" "plan keeps advisory requests bounded"
assert_contains "$plan_feature" "only representative evidence and return findings/next decisions" "plan advisory review uses representative evidence"
assert_contains "$plan_feature" "they do not" "plan advisory review prohibition lead-in"
assert_contains "$plan_feature" "materialize artifacts, build Task Breakdown, or mutate code" "plan advisory review does not run implementation"
assert_contains "$plan_feature" "## Intake Sequence" "plan consumes ready Requirement before design"
assert_contains "$plan_feature" "Consume the Requirement" "plan Requirement intake"
assert_contains "$plan_feature" "Project the Task Anchor" "plan Anchor projection handoff"
assert_contains "$plan_feature" "Prove implementation facts" "plan current-code binding"
assert_contains "$plan_feature" 'Reach `implementation-ready`' "plan implementation readiness gate"
assert_contains "$plan_feature" "Task Breakdown and mutation are forbidden before this state" "plan readiness ordering"
assert_contains "$plan_feature" "If later evidence changes desired meaning, return to Requirement Definition" "plan normative return"
assert_contains "$plan_feature" "The proof implementation is subordinate to acceptance" "plan proof subordinate to Requirement"
assert_not_contains "$plan_feature" "## Question Gate" "plan excludes normative question ownership"
assert_not_contains "$plan_feature" "## User-Confirmed Decision Mainline" "plan excludes Requirement decision ownership"
assert_not_contains "$plan_feature" "## Progressive Brainstorm Handoff" "plan excludes Requirement brainstorm ownership"
assert_not_contains "$plan_feature" "canonical owner of Decision Delta" "plan excludes Decision Delta ownership"
assert_contains "$plan_feature" "Complexity changes analysis depth, never file creation" "plan complexity changes analysis, not storage"
assert_contains "$plan_feature" "## Technical Design Slices" "plan closes one load-bearing technical question"
assert_contains "$plan_feature" "question -> Current evidence -> technical decision -> impact/risk -> proof" "plan design slice evidence chain"
assert_contains "$plan_feature" "A choice that changes desired behavior" "plan returns normative alternatives"
assert_contains "$plan_feature" "## Artifact Pressure Gate" "plan artifact creation has a pressure gate"
assert_contains "$plan_feature" "Complexity or activity alone is not pressure" "plan rejects size-only materialization"
assert_contains "$plan_feature" "A durable Plan names and consumes its governing Requirement" "plan preserves Requirement provenance"
assert_contains "$plan_feature" "An explicit request to create or update only the Requirement/PRD stays in" "plan rejects Requirement-only artifact intake"
assert_contains "$plan_feature" "Requirement Definition and never borrows this Gate" "plan cannot lend its artifact gate"
assert_contains "$plan_feature" "return to Requirement Definition to materialize that owner first" "plan returns missing durable Requirement owner"
assert_contains "$plan_feature" "use separate dossier carriers" "plan separates durable dossier carriers"
assert_contains "$plan_feature" '`prd.md` owns the Requirement and `design.md` owns the Implementation Plan' "plan assigns separate durable owners"
assert_contains "$plan_feature" '`design.md` declares `requirement: prd.md`' "plan links Requirement one way"
assert_contains "$plan_feature" 'A Requirement-only dossier may stop at `prd.md`' "requirement-only dossier remains complete"
assert_contains "$plan_feature" 'A new implementation Plan never uses `prd.md` as its technical or lifecycle owner' "plan rejects prd technical ownership"
assert_contains "$plan_feature" "Requirement-only artifact delivery never enters this workflow" "plan completion excludes Requirement-only delivery"
assert_contains "$plan_feature" "without copying or modifying it" "plan durable consumer is read-only"
assert_not_contains "$plan_feature" "Requirement-only PRD uses Plan Feature's Artifact Pressure Gate" "plan rejects borrowed Requirement persistence"
assert_not_contains "$plan_feature" 'Record at least two real options' "plan no longer forces two options"
assert_not_contains "$plan_feature" 'Create only `prd.md` initially' "plan no longer auto-creates prd"
assert_not_contains "$plan_feature" 'or a dossier `prd.md` only when it already needs independently readable' "plan no longer assigns dossier prd to technical Plan"
assert_contains "$plan_feature" "change-contract.md" "plan semantic-contract hook"
assert_contains "$plan_feature" "source-localization.md" "plan technical-owner hook"
assert_contains "$plan_feature" "A durable implementation Plan is a revisable technical contract" "plan technical contract boundary"
assert_contains "$plan_feature" 'one-way `consumes` edges' "integrating plan records one-way Component edges"
assert_contains "$plan_feature" "without" "composition mirror-state prohibition lead-in"
assert_contains "$plan_feature" "mirroring Component content or live status" "composition rejects durable mirror state"
assert_contains "$plan_feature" "## Database-Change Artifact Gate" "schema changes have a canonical artifact gate"
assert_contains "$plan_feature" "dossier and naturally" "schema change requires a Plan-local SQL artifact"
assert_contains "$plan_feature" '`prd.md` Requirement,' "schema dossier retains Requirement owner"
assert_contains "$plan_feature" '`design.md` Plan, and SQL surface remain separate owners' "schema dossier retains separate Plan owner"
assert_contains "$plan_feature" "include forward change, read-only verification" "SQL artifact contains migration and proof"
assert_contains "$plan_feature" "safe rollback" "SQL artifact contains honest recovery"
assert_contains "$plan_feature" "never grants database-write authority" "SQL artifact preserves DB authority"
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
assert_contains "$(<AGENTS.md)" "do not repeat visible steps in chat" "self-hosting shell Plan deduplication"
assert_contains "$(<templates/shells/AGENTS.md)" "do not repeat visible steps in chat" "downstream shell Plan deduplication"

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
assert_contains "$business_profile" "define-requirement.md" "business model Requirement question-owner link"
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
assert_contains "$fix_bug" "user-confirmed Requirement Decision Context" "fix-bug Requirement-mainline activation"
assert_contains "$fix_bug" "Purely technical Design-derived work may consume the Plan without requiring a business model" "fix-bug technical-plan business-leaf boundary"
assert_contains "$fix_bug" 'enter [`define-requirement.md`](define-requirement.md)' "fix-bug question-owner link"
assert_contains "$fix_bug" "Implementation-Fact Question Gate" "fix-bug implementation-fact owner hook"
assert_contains "$fix_bug" "trace distinct flows independently" "fix-bug separates incomplete implementation flows"
assert_contains "$fix_bug" "present the current understanding and real conflict" "fix-bug conclusion-before-question"
assert_contains "$fix_bug" "cross-check it against any existing user-confirmed answer" "fix-bug cross-checks evidence and prior answers"
assert_contains "$fix_bug" "continue without another question" "fix-bug skips aligned questions"
assert_contains "$fix_bug" "ask only a remaining normative ambiguity that could change repair classification or expected behavior" "fix-bug asks only decision-changing normative ambiguity"
assert_contains "$fix_bug" "Never ask the user to choose a Current implementation fact, request exhaustive detail, or define an abstract concept from scratch" "fix-bug rejects implementation-fact and blank business questions"
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
echo ""
echo "==> clear status-grouped defect-filter requirement"
# Representative input: 在迭代/版本/hotfix的缺陷tab，新增按状态分组筛选的功能，
# 状态按推进顺序排列并显示数量。Clear wording can close requirement readiness
# without questions, but the new user-visible behavior must still enter Managed
# execution and a Native Plan before mutation.
assert_contains "$(task_block templates/skill/routing.yaml change-managed)" "新增 / 重构 / 优化非 bug 行为" "defect filter requirement route intent"
assert_contains "$(task_block templates/skill/routing.yaml change-managed)" "workflow: workflows/change-managed.md" "defect filter requirement first workflow"
assert_contains "$change_managed" "A feature or any request that adds or changes user-visible behavior, a business flow/state, or an external contract is Managed even when it sounds local" "defect filter requirement Managed classification"
assert_contains "$change_managed" "complete Requirement Definition" "defect filter requirement readiness"
assert_contains "$change_managed" "before mutation" "defect filter requirement pre-mutation planning"
assert_contains "$change_managed" 'A clear source Requirement or explicit request may satisfy `requirement-ready` with zero questions' "defect filter clear request no-question path"
assert_contains "$change_managed" 'Only then mark `implementation-ready`, derive the Native Plan' "defect filter clear request keeps Native Plan"
assert_contains "$change_managed" "Map semantic fan-out" "change-managed invariant fan-out"
assert_contains "$change_managed" "full/incremental/read/write path" "change-managed all-path map"
assert_contains "$change_managed" "smallest semantically complete change" "change-managed minimality tie-breaker"
assert_contains "$change_managed" "user-confirmed Requirement mainline" "change-managed Requirement-mainline activation"
assert_contains "$change_managed" "Plan's technical decisions" "change-managed technical-plan boundary"
assert_contains "$change_managed" "User Decision Drift Gate" "change-managed immediate drift escalation"
assert_contains "$change_managed" "task-execution.md#user-decision-drift-gate" "change-managed drift-owner link"
assert_contains "$change_managed" "source-localization.md" "change-managed technical-owner hook"
assert_contains "$change_managed" "Steps 1-3 must bind the returned owner, Current -> Target, affected path" "change-managed contract-consumption acceptance"

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
  assert_not_contains "$consumer_content" "Every material requirement-bearing input receives an evidenced disposition" "$consumer_file does not copy the Requirement Contract definition"
  assert_not_contains "$consumer_content" "## Adaptive Evidence Funnel" "$consumer_file does not copy the localization procedure"
done

assert_contains "$plan_feature" "business-model impact: unchanged / proposed change / unknown" "plan business-model impact"
assert_contains "$plan_feature" "Before handoff, reconcile Requirement authority" "plan reconciles Requirement before coding"
assert_contains "$plan_feature" "For business-bearing work, send confirmed business meaning" "plan handoff optional business-distillation boundary"
assert_contains "$plan_feature" "Current implementation fact" "plan preserves implementation-fact boundary"

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
assert_contains "$business_truth" "## Requirement Decision Source" "business truth owns Requirement handoff"
assert_contains "$business_truth" "## Standalone Business-Model Input" "business truth owns standalone modeling"
assert_contains "$business_truth" "## Active Bug-Fix Input" "business truth owns active bug business input"
assert_contains "$business_truth" 'Do not derive `desired business truth` from Bug symptoms' "business truth rejects bug-derived intent"
assert_not_contains "$business_truth" "## Verified Failure Input" "business path does not load failure procedure"
assert_not_contains "$business_truth" "## Accepted Workflow-Distillation Input" "business path does not load workflow distillation"

assert_contains "$verified_failure" "## Verified Failure Input" "verified failure has complete owner"
assert_contains "$verified_failure" "first proven actionable failure bypasses only the ordinary Recording Threshold" "first proven prevention writes without waiting for recurrence"
assert_contains "$verified_failure" "**Activation failure** - applicable prevention already exists" "existing prevention can fail at activation independently of storage"
assert_contains "$verified_failure" "**Learning-closure failure** - the first occurrence has already proved a stable prevention" "first proven prevention can fail at durable learning closure"
assert_contains "$verified_failure" "Their evidence is not interchangeable" "activation and learning evidence cannot substitute for each other"
assert_contains "$verified_failure" "Evaluate and close both classes separately whenever both are present" "both failure classes receive independent completion judgments"
assert_contains "$verified_failure" "Stable execution preconditions need an earlier placement than their failure explanation" "verified failure recognizes execution preconditions"
assert_contains "$verified_failure" "before its first protected command" "execution precondition activates before the mistake-prone command"
assert_contains "$verified_failure" "select the environment and verify what the command will actually use" "execution precondition selects and reads back effective runtime"
assert_contains "$verified_failure" "count tool initialization as the intended red test" "tool initialization is not accepted as business red evidence"
assert_contains "$verified_failure" "project-specific versions and commands stay downstream" "generic failure owner excludes project-specific tool values"
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
assert_contains "$business_truth" "define-requirement.md#decision-authority-and-source-fidelity" "persistence Requirement-owner link"
assert_contains "$business_truth" "A confirmed Requirement bypasses only ordinary recording admission" "persistence Requirement-handoff admission"
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
assert_contains "$receiving_review" "governing Requirement Decision Context" "review Requirement-mainline activation"
assert_contains "$receiving_review" "Purely technical Design-derived work consumes the Plan without requiring a business model" "review technical-plan business-leaf boundary"
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
assert_contains "$plan_large" 'or `design.md` when a durable Requirement dossier exists' "large-plan uses design carrier"
assert_contains "$plan_large" '`prd.md` remains the Governing Requirement and never becomes the Large Plan synthesis' "large-plan rejects prd synthesis ownership"
assert_contains "$plan_large" "Do not dispatch broad “scan the subsystem” work before that boundary" "large-plan bounds parallel evidence scans"
assert_not_contains "$plan_large" "Each selected lens gets a naturally named sibling file" "large-plan removes automatic lens files"
assert_not_contains "$plan_large" 'otherwise `prd.md` or the existing one-file Plan' "large-plan removes prd Plan carrier"

business_global_model="$(<references/business-global-model.md)"
profile_business_model="$(<templates/skill/workflows/profile-business-model.md.example)"
assert_contains "$business_global_model" "Reuse an authoritative Governing Requirement for the same scope" "gap intake reuses Requirement owner"
assert_contains "$business_global_model" 'separate `design.md` consumer' "gap intake separates Plan carrier"
assert_contains "$business_global_model" "It is not an Implementation Plan" "gap prd excludes implementation Plan"
assert_contains "$profile_business_model" 'separate `design.md` consumer instead of putting technical Plan content in `prd.md`' "business-model workflow separates carriers"
assert_contains "$profile_business_model" "Plan Feature may write implementation design only to the separate Plan carrier" "business-model handoff protects Plan destination"
assert_contains "$profile_business_model" "keep the Requirement draft and stop" "paused gap intake remains Requirement-only"

plan_archive="$(<docs/plans/README.md)"
assert_contains "$plan_archive" "Complexity changes analysis depth, not materialization timing" "plan archive separates complexity and materialization"
assert_contains "$plan_archive" "Use one dated file for a focused one-file record" "plan archive supports focused one-file carrier"
assert_contains "$plan_archive" "Use a directory when the durable object is a named dossier" "plan archive supports pressure-triggered dossier carrier"
assert_contains "$plan_archive" 'A correct dossier may contain only `prd.md`' "plan archive does not require eager siblings"
assert_contains "$plan_archive" '`design.md` is admitted, it declares `requirement: prd.md`' "plan archive links separate design owner"
assert_contains "$plan_archive" 'resulting dossier as `design.md` with Git history preserved' "plan archive migrates active one-file Plan to design"
assert_contains "$plan_archive" 'Historical frozen dossiers may already use `prd.md` as their Plan entry' "plan archive preserves frozen legacy"
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
assert_contains "$plan_template" "## Requirement Input And Proof Mapping" "plan template acceptance mapping"
assert_contains "$plan_template" "Proof code and commands are subordinate to acceptance" "plan template keeps proof subordinate"
assert_contains "$plan_template" "A true subplan is not an independent Plan" "plan template documents true subplan ownership"
assert_contains "$plan_template" "Durable Integrating Plan" "plan template documents Integrating synthesis"
assert_contains "$plan_template" "Database-structure change" "plan template documents conditional SQL sibling"
assert_contains "$plan_template" "The SQL artifact never grants DB-write authority" "plan template preserves DB authorization"
assert_not_contains "$plan_template" "CREATE TABLE" "plan template does not invent generic DDL"
assert_not_contains "$plan_template" "plan_role:" "plan template does not add a Plan-role mirror field"

echo ""
echo "Summary: $PASS passed, $FAIL failed"
[[ "$FAIL" -eq 0 ]]
