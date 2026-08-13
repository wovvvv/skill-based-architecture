---
date: 2026-08-13
status: done
supersedes:
  - 2026-08-12-requirement-first-planning.md
distilled_to:
  - docs/sba-bible.md
  - templates/skill/workflows/define-requirement.md
  - templates/skill/protocol-blocks/change-contract.md
  - templates/skill/workflows/plan-feature.md
  - templates/skill/workflows/task-execution.md
  - templates/skill/workflows/change-managed.md
  - templates/skill/routing.yaml
  - references/self-hosting-routing.yaml
  - references/protocols.md
  - docs/task-anchor-native-plan.md
  - docs/plans/README.md
  - docs/plans/_TEMPLATE.md
  - scripts/scaffold-downstream.sh
  - templates/skill/conformance.yaml
  - references/self-hosting-conformance.yaml
  - scripts/check-self-scenarios.sh
  - scripts/check-validation-contract.sh
  - UPSTREAM-CHANGES.md
---

# Plan: Separate Requirement Definition From Implementation Planning

> Current conclusion: make Requirement Definition the sole interactive owner of
> desired meaning, use Task Anchor as its current-Session projection, require
> implementation facts before deriving an implementation Plan, and keep that
> Plan limited to technical means, order, risk treatment, and proof execution.

## Governing Requirement

### User source

> 你刚刚是对的,其实先明确需求再写计划(plan)其实跟我们之前说的,先读代码再写有异曲同工的感觉,本质上的目的是,先明确讨论需求这个是我们的根,然后再写plan作为实现细节,头脑风暴也是分开的,我觉得这样更好一点,原因在于我们的计划是从需求上长出来的,所以在我们明确了需求的目标(这个跟task archar可能有关),范围,模型,规则,技术选项(可选),验收标准(这个可能跟红测有关)***目标 + 范围 + 具体流程 + 规则/约束 + 可验证的验收标准。***如果需求仍不完整，最好的做法不是让 AI 猜，而是明确要求它：**“先列出你的理解、风险点和需要澄清的问题，确认后再开始写代码。”*这些都是我们的需求需要注意的地方,然后计划则是实现细节,这个我们要分开掉,***

- Authority: user-confirmed.
- Goal: requirement discussion is the root; implementation planning grows from
  a confirmed requirement rather than defining or completing it afterward.
- Scope: feature and behavior/contract work in SBA's reusable task flow,
  including explicit requirement discussion, ordinary direct implementation
  requests, Task Anchor projection, Plan Feature, downstream materialization,
  and fitted validation.
- Requirement content: desired goal; authoritative scope, exclusions, and
  preserved behavior; decision-bearing actors/models/relations and concrete
  flow/state/order/interaction; rules and constraints; and observable,
  falsifiable acceptance. A technical option belongs here only when the user is
  choosing a product/architecture constraint that changes desired behavior,
  scope, or acceptance.
- Incomplete path: inspect only decision-relevant evidence, then present the
  Agent's current understanding, real risks/conflicts, and the minimum remaining
  normative question. Do not produce an implementation Plan or mutate code
  until no user-owned decision can redirect the requirement.
- Clear path: explicit user wording may be sufficient authority and may reach
  `requirement-ready` without another confirmation turn. Separation must not
  become a universal approval ceremony.
- Acceptance boundary: the requirement defines what observable result is
  correct. A red test, automated test, runtime/browser readback, or human review
  is a Plan-selected proof implementation; it cannot invent or redefine the
  acceptance it later proves.
- Code boundary: source inspection establishes Current behavior, canonical
  ownership, technical feasibility, constraints, cost, and risk. It may falsify
  an assumption and return a normative conflict, but it cannot choose desired
  product meaning.
- Artifact boundary: logical separation is mandatory; persistent files remain
  conditional. Ordinary requests create no requirement document, Plan file,
  Task Anchor file, question ledger, or brainstorm log.

### Requirement readiness

The requirement above is `requirement-ready`. No user-owned choice remains for
the responsibility split, fast path, source-authority boundary, acceptance/test
relationship, or artifact cost. This Plan therefore begins with implementation
design and must return to Requirement Definition if evidence would change any
of those meanings.

## Current Implementation Facts

- `templates/skill/protocol-blocks/change-contract.md` already owns the complete
  runtime translation and implementation-binding state, but its Requirement
  Contract dimensions and the boundary between semantic and technical phases
  are implicit.
- `templates/skill/workflows/plan-feature.md` currently owns requirement
  readiness, question gating, user-confirmed decisions, brainstorm handoff,
  technical evidence, design slices, artifact pressure, and Task Breakdown.
  Users can independently request “先讨论需求，不要写 Plan” and “基于确认需求写
  实现 Plan”, so those responsibilities now have independent selection pressure.
- The current Plan flow derives a Native Plan immediately after
  `requirement-ready`, even when canonical owner, Current -> Target, and the
  affected technical path are not yet proven. That violates the already adopted
  source-localization boundary.
- `templates/skill/routing.yaml` routes “先帮我把这个需求问清楚” to
  `plan-feature`; self-hosting product-direction and Plan work also share one
  workflow. The entry itself therefore conflates the deliverables.
- `scripts/scaffold-downstream.sh` renders project-specific light workflows
  rather than copying every upstream workflow. A new upstream owner does not
  change downstream behavior unless the light route and fitted evidence path
  carry the same phase separation.
- `docs/plans/README.md` and `_TEMPLATE.md` currently describe a Plan as a
  combined requirement/design/implementation contract. Task Anchor documentation
  already says Requirement owns desired meaning, but its flow still presents
  Task Anchor and Native Plan as one immediate pair.
- The completed 2026-08-12 Plan correctly established requirement-before-Plan
  ordering and the no-question/no-artifact fast paths. This successor preserves
  those results but replaces its future-facing owner allocation: Plan Feature
  no longer owns Requirement Definition.

## Target Responsibility Model

```text
User request / route
  -> Requirement Definition
       -> clear: requirement-ready without another confirmation
       -> incomplete: understanding + real risks + minimum normative question
  -> Task Anchor projection (Goal / Done When / Boundaries)
  -> Source Localization + Implementation Binding
  -> implementation-ready
  -> Implementation Plan / Native Plan
  -> Mutation + fitted proof
  -> Closure against the Requirement projection
```

| Owner | Owns | Must not own |
|---|---|---|
| `define-requirement.md` | interaction order for understanding, evidence, brainstorm, minimum normative clarification, and readiness handoff | implementation tasks, file design, mutation, or proof commands |
| `change-contract.md` | sole runtime Requirement Contract semantics, readiness state, technical-binding handoff, and return states | routing, fixed question form, persistent artifact, or Native Plan state |
| `source-localization.md` | Current behavior, canonical owner/change point, affected technical path, contradictions, and residual technical uncertainty | desired product meaning |
| Task Anchor | current-Session projection of confirmed Goal, Done When, and material Boundaries | complete Requirement storage or implementation steps |
| `plan-feature.md` | technical options, Current -> Target implementation design, impact/risk/recovery, proof implementation, task interfaces, dependency order, and optional durable Plan lifecycle | inventing, narrowing, or silently changing goal/scope/flow/rules/acceptance |
| Native Plan | current implementation steps and verified step status | requirement authority or durable design truth |
| Closure | compare implementation and requested delivery to the frozen Requirement projection | redefining acceptance after green |

## Design Decisions

### D1 - Add one independently selectable Requirement Definition workflow

Create `templates/skill/workflows/define-requirement.md`. It is a workflow, not
another protocol or state store. It consumes and updates the existing Change
Contract, uses Source Localization for technical facts, and invokes the existing
minimum-question gate only for a remaining normative blocker.

The workflow activates evidence-selected dimensions rather than a fixed form:

- goal and observable user/business outcome;
- scope, exclusions, preserved behavior, and permission boundary;
- actor/trigger, model/relationship, concrete flow/state/order/interaction when
  any of them changes the result;
- rules, defaults, constraints, failure behavior, and compatibility when
  decision-bearing;
- observable acceptance that can reject a wrong result;
- confirmed facts, assumptions, real risks/conflicts, and remaining normative
  choices;
- optional user-owned technical/product constraints only when they change the
  desired contract.

When incomplete, its user-facing handoff is meaning, not a mandatory heading
template: current understanding, evidence-backed risk/conflict, and one minimum
question. It does not start Task Breakdown or code mutation. When complete, it
returns the Requirement Contract and `requirement-ready`; it does not create an
implementation Plan.

### D2 - Make Plan Feature a strict consumer

Remove complete Requirement Definition, normative brainstorm ownership, and
user-decision capture from `plan-feature.md`. Replace them with one intake gate:

1. consume a `requirement-ready` Change Contract from the user, a confirmed
   source, or `define-requirement.md`;
2. project its outcome/acceptance/boundaries into Task Anchor state;
3. use `source-localization.md` to prove Current behavior, canonical owner,
   Current -> Target, affected path, and fitted proof boundary;
4. reach `implementation-ready`;
5. only then derive technical design, Task Interfaces, and Native Plan steps.

If technical evidence exposes a normative gap or conflicts with the confirmed
requirement, return to `define-requirement.md` or User Decision Drift. Plan
Feature must not fill the gap through an “implementation assumption”.

Plan brainstorming remains allowed only for genuinely technical alternatives
that preserve the confirmed requirement. Product/requirement alternatives and
normative questions return to Requirement Definition.

### D3 - Preserve one runtime contract and one step owner

Refactor `change-contract.md` into visible Requirement Contract and
Implementation Binding phases without creating another ledger. Its runtime
transition becomes:

```text
requirement-incomplete -> requirement-ready
  -> localization-required / owner-proven
  -> binding-incomplete -> implementation-ready
```

Task Execution establishes Task Anchor after `requirement-ready`, but delays the
Native Plan until `implementation-ready`. A small discovery step may run under
the Anchor to obtain technical facts; it is not yet an implementation Plan.

The original user request remains valid authority until contradicted. Clear
requests skip clarification, not readiness or technical binding. Users do not
have to know or explicitly invoke the phases.

### D4 - Separate acceptance truth from proof implementation

Requirement Definition records observable acceptance without selecting a test
framework or command. Plan Feature maps each material acceptance/risk to the
cheapest fitted evidence. Where a stable seam exists, it may choose a red test
or acceptance case before mutation; subjective UI/UX may require browser or
human evidence. A generated test is subordinate to the Requirement Contract.

If a proposed test reveals an unstated expected result, that is a Requirement
question, not permission for the Agent to choose the answer. A red test that
does not trace to confirmed acceptance cannot certify the product requirement.

### D5 - Activate the split without exporting author complexity

- Add a self-hosting `define-requirement` route for explicit requirement
  discussion and move those triggers out of `plan-feature`/product-direction.
- Add the route to the full template routing catalog, while keeping ordinary
  direct and folder-light projects evidence-selected.
- `change-managed` remains the first route for “implement this feature”. It
  invokes Requirement Definition internally when needed; the user does not
  re-route or restate the request.
- The materializer accepts `define-requirement` as an evidence task. Its light
  requirement route performs no implementation; its feature/change light routes
  inline the minimum phase boundary when no independent shared owner is admitted.
- Broad projects with independent requirement discussion pressure may carry the
  new workflow. Single-file projects keep the same complete behavior inline and
  receive no new file merely for uniformity.
- No Always Read entry, required `requirements.md`, universal PRD, new manifest,
  question log, brainstorm store, or second Native Plan is added.

### D6 - Keep durable Requirement and Plan ownership logically separate

The Artifact Pressure Gate remains unchanged. A durable implementation Plan
names its governing Requirement source and treats it as consumed input. If the
Requirement itself has independent review, handoff, or lifecycle pressure, a
natural sibling may own it and the Plan links it one way. Otherwise, a compact
source-faithful Requirement input may be physically co-located in a dossier;
physical co-location never grants Plan Feature authority to edit its meaning.

Existing frozen Plans remain history. This Plan supersedes only the earlier
Plan's future-facing owner allocation, not its evidence or completed delivery.

## Behavior Cases

| Request | Required behavior |
|---|---|
| “先讨论这个需求，不要写代码或 Plan” | route to Requirement Definition; return a confirmed Requirement Contract or one minimum question; no Task Breakdown/mutation |
| Clear status-grouped defect filter request | `change-managed`; reach `requirement-ready` with zero questions when wording is sufficient; establish Anchor, prove code owner/Current path, reach `implementation-ready`, then create Native Plan before mutation |
| “优化这里” with several plausible user outcomes | inspect minimum evidence; show current understanding and real risks; ask one normative question; no implementation Plan or mutation |
| User asks which file/class to change | Source Localization discovers it; do not transfer repository indexing to the user |
| Code contradicts confirmed desired flow | report conflict and return to Requirement Definition/User Decision Drift; never fit the requirement to current code silently |
| User provides a complete PRD/issue | consume it as requirement authority; do not demand a duplicate confirmation or requirement file |
| Proposed red test needs an unstated expected value | return that expected value to Requirement Definition; do not let the test author choose it |
| Subjective visual acceptance | Requirement states observable/user judgment; Plan selects browser evidence and user sign-off rather than a fake unit test |
| One fixed-contract maintenance correction | retain Simple path; no requirement ceremony or Plan artifact |

## Task Interfaces

### Task 1 - Establish the Requirement Definition owner

- **Files:** `templates/skill/workflows/define-requirement.md`,
  `templates/skill/protocol-blocks/change-contract.md`, `docs/sba-bible.md`.
- **Consumes:** Governing Requirement and D1/D3/D4.
- **Produces:** one Requirement interaction workflow, one canonical runtime
  Requirement Contract, explicit completeness dimensions, incomplete/clear
  paths, code-authority boundary, and acceptance/proof separation.
- **Acceptance:** a reader can complete a requirement without producing
  implementation steps; every dimension is conditional rather than a fixed
  questionnaire; missing normative meaning cannot be guessed.

### Task 2 - Narrow planning and runtime execution

- **Files:** `templates/skill/workflows/plan-feature.md`,
  `templates/skill/workflows/task-execution.md`,
  `templates/skill/workflows/change-managed.md`, and any task workflow whose
  current link points to a moved Plan Feature requirement section.
- **Consumes:** Task 1 Requirement Contract, Source Localization output, D2-D4.
- **Produces:** `requirement-ready -> Task Anchor -> implementation-ready ->
  Native Plan -> mutation`; Plan-only technical design and proof; precise return
  to Requirement Definition for normative gaps.
- **Acceptance:** no implementation Plan is derived from an incomplete
  requirement or unproven technical owner; Plan Feature cannot own or rewrite
  desired meaning; bug/feature consumers resolve moved anchors.

### Task 3 - Activate self-hosting and downstream behavior

- **Files:** `references/self-hosting-routing.yaml`, `templates/skill/routing.yaml`,
  SKILL carriers, `templates/skill/scripts/sync-routing.sh`,
  `references/self-hosting-shell-base.md`, generated shell surfaces, and
  `scripts/scaffold-downstream.sh`.
- **Consumes:** D1, D3, D5 and current materializer evidence contract.
- **Produces:** independent requirement-discussion route, Plan-only route,
  feature/change internal handoff, conditionally materialized light behavior,
  and synchronized entry activation.
- **Acceptance:** explicit requirement discussion cannot reach implementation;
  direct feature requests need no user re-routing; a fresh evidence-selected
  downstream has no broken link and no unjustified new file.

### Task 4 - Align durable documentation

- **Files:** `references/protocols.md`, `docs/task-anchor-native-plan.md`,
  `docs/plans/README.md`, `docs/plans/_TEMPLATE.md`, and directly affected
  reference/index links.
- **Consumes:** target responsibility table and D3/D4/D6.
- **Produces:** one-way Requirement -> Anchor -> binding -> Plan explanation,
  logical/physical artifact boundary, and Plan template limited to consumed
  requirement input plus implementation details.
- **Acceptance:** documentation cannot imply Task Anchor stores the Requirement,
  Plan owns acceptance, or a red test defines product truth; old anchor links do
  not point at moved sections.

### Task 5 - Mutation-protect and close

- **Files:** `templates/skill/conformance.yaml`,
  `references/self-hosting-conformance.yaml`, `scripts/check-self-scenarios.sh`,
  `scripts/check-validation-contract.sh`, `UPSTREAM-CHANGES.md`, and this Plan's
  final lifecycle fields.
- **Consumes:** Tasks 1-4 and Behavior Cases.
- **Produces:** fitted content/ordering checks, independent deletions, fresh
  scenario evidence, repository regression, upstream guidance, final
  Plan/Knowledge reconciliation, and `status: done`.
- **Acceptance:** independent deletion of goal, scope/preservation,
  model/flow, rules/constraints, acceptance, no-guess incomplete handoff,
  code/current-versus-desired authority, Anchor projection,
  `implementation-ready` ordering, Plan return behavior, or test-subordination
  causes the intended failure; clear requests remain zero-question and
  artifact-free; full Bucket A passes.

## Implementation Order And Return Conditions

1. Implement Task 1 without touching Plan mechanics; self-check Requirement
   completeness and no-fixed-question/no-artifact boundaries.
2. Implement Task 2 and repair every moved-anchor consumer before changing
   routing. Return here if Plan Feature still needs a normative decision owner.
3. Implement Task 3 as one activation unit, run sync generators, and inspect a
   fresh direct, folder-light, and broad materialization before claiming the
   owner is usable downstream.
4. Implement Task 4 and run a repository-wide link/heading search for the old
   Plan Feature requirement anchors.
5. Implement Task 5, run baseline and each independent mutation, then the fitted
   scenario and full Bucket A suite. Report live behavior separately if run.
6. Reconcile the final owner graph, add the upstream note, freeze this Plan at
   `done`, and leave all external delivery unperformed unless separately asked.

Return to Requirement Definition before more mutation when:

- implementation evidence would change the confirmed goal, scope, model/flow,
  rule, constraint, preservation, or acceptance;
- the implementation would require mandatory confirmation for clear requests,
  a universal Requirement file, another runtime ledger, or a fixed questionnaire;
- a test/proof mechanism would become the authority for an unstated outcome;
- ordinary downstream projects would receive an owner with no independent task
  or load reason;
- physical artifact separation would add files without review, handoff,
  recovery, conflict, or lifecycle pressure.

## Open Questions

None. Requirement semantics are user-confirmed; current source evidence closes
the owner, routing, materialization, compatibility, and proof decisions needed
for implementation.

## Implementation And Closure Evidence

- Canonical ownership is separated without a second runtime ledger:
  `define-requirement.md` performs requirement interaction,
  `change-contract.md` owns Requirement readiness and Implementation Binding,
  Task Anchor projects Goal/Done When/Boundaries, Source Localization proves
  Current ownership, and `plan-feature.md` derives only revisable technical
  means and acceptance-to-proof mapping after `implementation-ready`.
- Self-hosting routing, generated shells, direct/Folder-light/routed/broad
  carriers, existing-project migration, durable Plan docs, and affected bug,
  review, business-model, and Closure consumers all preserve
  `requirement-ready -> Task Anchor -> implementation-ready -> Native Plan ->
  mutation` without a mandatory Requirement file, PRD, question log, or Plan
  artifact.
- Fresh focused proof passes: Requirement/Plan and related validator mutations
  `24/0`, self-hosting scenarios `606/0`, template conformance `672/0`,
  self-hosting conformance `662/0`, routing generator check, self-shell equality,
  Bash syntax, and whitespace validation.
- Fresh `bash scripts/check-all.sh --base HEAD` exits `0` from the synchronized
  final implementation. It includes materialization/migration evidence,
  routing/shell checks, smoke, orphan/reachability, path-integrity guards, the
  mutation contract, scenarios, and both conformance layers. This proves the
  deterministic structure and contract, not all live Agent behavior.
- Independent read-only forward behavior is reported separately: an incomplete
  business-rule request is `PASS` because the Agent returned concrete
  understanding, real boundary risks, and one normative question without a Plan
  or mutation; the clear feature request is `NO VERDICT` because it produced no
  terminal response within the bounded evaluation window and was interrupted.
  The optional `skill-creator` validator is also `NO VERDICT` because its Python
  environment lacks `PyYAML`; repository-owned stronger validation is green.
- Plan/Knowledge and semantic Before/After reconciliation return `pass`: no
  active validation asserts Plan-owned desired meaning, no additional durable
  owner is admitted, and the dedicated `UPSTREAM-CHANGES.md` entry describes the
  one-way downstream upgrade.
- Local implementation and requested Closure are complete. No commit, push, MR,
  downstream assembly, deploy, publish, database write, or other external
  delivery was requested or performed.
