> Conclusion: keep the planning interface small, but make evidence-driven Design Slices close the current/target structure, semantic impact, activated risks, authority, and proof before implementation handoff.

# Design

## Current State

The canonical owner is `templates/skill/workflows/plan-feature.md`, with conditional Large behavior in `plan-large.md` and archive/output contracts in `docs/plans/README.md` plus `_TEMPLATE.md`.

Current behavior has several conflicting incentives:

- Complex Steps create `prd.md` before source inspection, making the durable artifact the early scratchpad.
- User-Confirmed Decision Mainline asks Complex/Large Plans to retain question/correction, answer, authority, meaning, scope, and source for each decision.
- Complex Plan prescribes a canonical section sequence even though it says sections are warranted-only.
- Brainstorm requires multiple solution shapes for Complex/Large work, which can generate artificial alternatives after constraints leave only one viable path.
- Task Breakdown has a strong interface contract, but the sample kept a placeholder before design freeze.
- Large Plan currently maps each selected lens directly to a sibling file, which can over-split tightly related design questions.
- Plan archive guidance values full context, dead ends, assumptions, and who-said-what, while implementation and review need a short current mainline.
- Conformance mostly checks that required phrases occur in workflow text; it does not evaluate generated artifact quality.

## Target Workflow

### 1. Deliverable and Tentative Complexity

Identify whether the user wants a concrete Plan produced/updated or only an explanation, review, or brainstorm. Advisory requests use representative evidence and stop after a supported finding plus next decision; they do not execute the entire feature-planning process. For concrete Plan work, identify the requested outcome and whether planning is actually needed. Simple work stays inline unless the user asks for a durable artifact. Complex/Large classification is tentative and must be re-evaluated when evidence expands scope.

Output: one current planning question and the evidence needed to resolve it, not a pre-filled document skeleton.

### 2. Evidence Baseline

Trace the smallest decision-bearing current flow. Establish enough Current Fact to state:

- the concrete problem and affected behavior;
- the current semantic owner, write/read/state path, or the absence of one;
- the gap between current fact and desired truth;
- the next unresolved normative or architecture decision.

Evidence must identify the file/method, contract/schema, test, configuration, or runtime observation and explain which decision it changes. A class name without a path, method, flow, or consumer is insufficient when those details carry the design.

Stop the read when the current question is resolved or falsified, or when evidence identifies the next semantic owner. Record adjacent consumers, risks, and flows as candidates; do not expand them all before the first Design Slice produces a decision. Wide inventories and parallel scans require a bounded decision question and stop condition.

### 3. Design Coverage Selection

Select dimensions from the observed change rather than a universal checklist:

| Dimension | Activate when it changes a decision |
|---|---|
| Requirements and business behavior | actor, scenario, invariant, boundary, or acceptance changes |
| Current/target system design | owner, component boundary, flow, state, or dependency changes |
| Domain model | entity, aggregate, lifecycle, state machine, command/event, or business invariant changes |
| Data/storage | schema, cardinality, identity, uniqueness, index, transaction, migration, or retention changes |
| Contracts/integration | API, event, DTO, error, compatibility, or consumer behavior changes |
| Change/impact | shared semantics fan out to multiple callers, readers, writers, copies, merges, or deletions |
| Risk/quality | consistency, concurrency, performance, availability, permission, dependency, or recovery affects the chosen design |
| Verification/rollout | proof, migration, staged activation, rollback, or operational readiness is nontrivial |

The workflow scans these dimensions internally. It persists only the activated conclusions and evidence.

### 4. One Design Slice at a Time

A Design Slice closes one independent load-bearing question:

```text
question
  -> current evidence
  -> decision
  -> change and impact / activated risk
  -> proof and remaining uncertainty
```

The output remains natural prose. The five-part shape is an internal completeness check, not mandatory visible headings.

For interactive Complex/Large work, stop after the first Slice that exposes a user-owned normative choice or high-impact assumption. Present that one decision in the Brainstorm Handoff and wait for the answer before opening unrelated Slices. Only an explicit artifact-only or end-to-end request authorizes uninterrupted expansion across independent questions.

When an active Plan already lists multiple Open Questions, recovery starts from the highest-impact unresolved decision rather than replaying the document as an investigation checklist. Load only the implementation evidence needed to make that question decision-ready; leave every unrelated question and evidence candidate unopened.

When a user owns the unresolved normative meaning, preserve a compact Decision Trace:

```text
trigger/problem -> user question/correction -> faithful answer
-> normative decision -> Agent-derived consequences -> affected requirements/design/tests
```

Do not place Agent-derived storage, API, class, or field choices under user authority unless the user explicitly selected that implementation design.

### 5. Pressure-Triggered Materialization and Progressive Extraction

Complexity controls analysis depth, not file creation. Start in the conversation and harness-native Plan. Create a durable artifact only when the user explicitly asks for one or when analysis discovers a pressure that needs an independent carrier, such as a cross-module conflict, a database migration requiring separate review and proof, or a consistency risk with its own lifecycle.

Physical shapes after pressure appears:

```text
focused one-file record: docs/plans/YYYY-MM-DD-<slug>.md
named/multi-topic dossier: docs/plans/YYYY-MM-DD-<slug>/prd.md
independent extra carrier: add only the needed sibling(s)
```

The first file follows the same admission rule as every sibling. Choose one dated Plan file for a focused record or a `prd.md` dossier when the durable object has a real aggregation/archive identity. A correct dossier may contain only `prd.md`. Add a sibling only when it has a separate job. Never pre-create a file or sibling set from the size label.

When a directory is justified, `prd.md` owns:

- problem, desired behavior, scope, and acceptance;
- compact current/superseded user-confirmed decisions;
- chosen synthesis and real unresolved questions;
- links to independently justified design artifacts;
- final implementation handoff status.

When independently justified, `design.md` can own:

- current evidence and Current -> Target structure;
- solution/system, domain, data, contract, integration, and verification sections that are actually activated;
- Change Map, Impact Map, Risk Scenarios, and technical decisions;
- implementation decomposition after design freeze.

Extract `design.md`, `domain-model.md`, `database.md`, `contracts.md`, `risks.md`, `test-plan.md`, or `rollout.md` only when the content:

1. answers an independent decision question;
2. has an independent consumer, reviewer, lifecycle, or loading reason;
3. can be read alone and change the mainline, task boundary, risk treatment, or proof;
4. would materially obscure the integrated design if left in place.

Content always read and changed together remains one section/file. No line or file-count threshold decides correctness.

### 6. Conditional Change, Impact, Risk, and Decision Detail

#### Change Map

For each semantic owner/model change, record Current, Target, change type (`reuse`, `extend`, `new`, `replace`, `remove`), preserved behavior, and migration/compatibility consequence.

#### Impact Map

Activate when a shared module, state, schema, interface, or lifecycle rule changes. Trace semantic upstream/downstream callers, readers/writers, state/data, copy/merge/delete flows, UI/API, operations, tests, and live rules. A raw file-reference inventory is not a substitute for causal impact.

#### Risk Scenario

Activate only on evidence. Each material risk states scenario, invariant, failure mode, chosen mechanism, mechanism boundary/cost, recovery, proof, and residual risk.

- Eventual consistency additionally identifies truth owner, propagation path, convergence window, intermediate visibility, duplicate/out-of-order/loss handling, retry/dead-letter/reconciliation, and non-convergence detection.
- Concurrency additionally identifies writers, aggregate key, transaction/lock/version order, idempotency/retry/timeout/deadlock behavior, and final database constraint.
- Performance additionally identifies hot path, cardinality/fan-out/query count, index/cache/batch/pagination choice, consistency cost, target observation, and degradation behavior.

#### Decision Trace

Persist a user answer only when it selects/rejects/corrects a solution, defines business meaning, sets failure/compatibility/migration semantics, changes scope/owner/acceptance, resolves a contradiction, or supersedes a prior decision. Routine acknowledgement and implementation facts remain outside the durable trace.

### 7. Plan Ready Reconciliation

Before handoff, verify:

- every active decision has supporting authority and evidence;
- Current, Target, Change, Impact, Risks, Acceptance, and Task interfaces agree;
- resolved questions are absent from Open Questions;
- title, slug, complexity, artifact set, and owner still match the discovered scope;
- alternatives are real and current rather than ceremonial;
- every activated material risk is treated, explicitly deferred, or left as a blocker;
- every task consumes an existing interface, produces a downstream interface, and has observable acceptance;
- the implementer and reviewer can use the Plan without replaying the conversation.

Contradictory evidence returns to the owning Design Slice; it does not preserve document completeness by force.

## Materialization Decision

Artifact creation is purely pressure-triggered. There is no universal evidence-ready checkpoint and no size-based default artifact set. Evidence can reveal the pressure, but a concrete problem or confirmed decision alone does not force persistence when the conversation and harness-native Plan still serve the task.

Valid triggers include an explicit user request; context-loss or handoff risk for a load-bearing decision; independent implementation or review consumption; a cross-module conflict that needs one reconciled owner; a migration, risk, proof, or rollout surface with an independent lifecycle; or an integrated document becoming semantically harder to use than an extracted owner. Create only the smallest current artifact and reassess later siblings independently.

## Repository Change Map

| Owner | Intended change | Boundary |
|---|---|---|
| `templates/skill/workflows/plan-feature.md` | Reorder the workflow around evidence baseline, Design Slices, artifact materialization, reconciliation, and handoff; compress verbose repeated rules | Remain the canonical planning/decision-mainline owner and fit the existing workflow budget by delegating conditional Large detail |
| `templates/skill/workflows/plan-large.md` | Replace lens-equals-file behavior with integrated design coverage plus progressive extraction and risk/impact contracts | Stay conditional; do not load for ordinary Complex work |
| `docs/plans/README.md` | Reframe active Plans as current contracts with compact provenance; retain frozen audit history without requiring full transcript in the mainline | Preserve lifecycle, distillation, and discoverability semantics |
| `docs/plans/_TEMPLATE.md` | Mirror the minimal one-file current contract and describe conditional design/risk/task sections | Do not add a family of mandatory templates |
| `docs/sba-bible.md` | Record the stable product principle: logical design coverage is evidence-driven; physical artifacts split only for independent consumption; Plan value is downstream decision/implementation/review use | Bible remains product cognition, not downstream ordinary-task input |
| `templates/skill/conformance.yaml`, `references/self-hosting-conformance.yaml`, `scripts/check-self-scenarios.sh` | Protect evidence-before-materialization, authority separation, progressive extraction, stale-question reconciliation, and no-placeholder/no-artificial-option behavior | Do not treat phrase checks as behavioral proof |
| `UPSTREAM-CHANGES.md` | Document the downstream-visible workflow/artifact change and compatibility boundary | No downstream business workspace mutation in this task |

Existing consumers of `Decision Context` (`task-execution`, change/fix/review, update-rules, Closure, business modeling) remain read-only unless the redesign changes their anchor or required handoff semantics. Prefer preserving the canonical Decision Mainline owner/anchor and changing its compact record contract to avoid unnecessary fan-out.

## Implementation Breakdown

### Task 1 - Rewrite the canonical Plan workflow

- **Files:** own `templates/skill/workflows/plan-feature.md`; read the approved Plan and existing consumer anchors; do not edit consumers yet.
- **Consumes:** confirmed mainline, Materialization Timing decision, current Question/Business-Semantics/Mainline handoff contracts.
- **Produces:** evidence-first staged workflow, internal Design Slice contract, progressive artifact logic, reconciliation gate, and late executable decomposition.
- **Acceptance:** the workflow stays concise, preserves decision authority and handoff semantics, and contains no immediate file-generation, forced-option, placeholder-task, or section-count completion shortcut.

### Task 2 - Refactor Large and archive/artifact contracts

- **Files:** own `templates/skill/workflows/plan-large.md`, `docs/plans/README.md`, and `docs/plans/_TEMPLATE.md`.
- **Consumes:** Task 1 anchors and the approved logical-versus-physical split.
- **Produces:** inline-first planning, pressure-triggered one-file/directory selection, conditional extraction rules, activated risk/impact detail, and a current-contract/archive boundary.
- **Acceptance:** a Complex Plan can remain one file, a nontrivial design can use two coherent files, and a Large Plan splits only independently consumable surfaces without duplicated synthesis.

### Task 3 - Activate product semantics and conformance

- **Files:** own `docs/sba-bible.md`, `UPSTREAM-CHANGES.md`, `templates/skill/conformance.yaml`, `references/self-hosting-conformance.yaml`, and `scripts/check-self-scenarios.sh`; edit a consumer only if an exact anchor/contract changed.
- **Consumes:** Tasks 1-2 final wording and current dirty-worktree changes in the same files.
- **Produces:** stable product principle, downstream refresh note, positive/negative structural scenarios, and preserved existing user work.
- **Acceptance:** targeted checks reject early empty artifacts, fake alternatives, stale Open Questions, authority mixing, and unjustified split guidance at the contract level; `git diff --check` passes.

### Task 4 - Validate behavior and review semantic fan-out

- **Files:** read the full diff and test fixtures; do not create permanent eval machinery unless the forward tests expose a reusable enforcement gap.
- **Consumes:** implemented workflow and raw representative prompts/artifacts without the intended answer.
- **Produces:** full repository validation, independent forward-test outputs, semantic review findings, and any fitted corrections.
- **Acceptance:** `bash scripts/check-all.sh --base HEAD` passes; fresh agents handle a Simple clear request without ceremony, the reference-version class of Complex/Large request with exact evidence/impact/risk/decision separation, and a large cross-subsystem request without mandatory file explosion. Structural green alone is not accepted as completion.

## Design Risks

| Risk | Treatment |
|---|---|
| The redesign becomes a new large visible template | Keep Design Slice internal, external headings natural, and conditional detail in `plan-large.md` |
| Agents omit important design because files are optional | Require coverage selection and Plan Ready reconciliation by semantic decision/risk, not file existence |
| Agents generate many tiny files | Keep one current carrier; require independent consumer/loading/review/validation/lifecycle evidence before extraction |
| Compact provenance loses a decisive user correction | Preserve faithful answer plus normative decision and consequences only when the answer is load-bearing |
| Risk sections become generic checklists | Activate only from evidence and require scenario/invariant/failure/mechanism/boundary/recovery/proof |
| Structural checks remain green while outputs stay weak | Add raw-artifact forward tests and main-thread semantic review before closure |
| Renaming Decision Context causes broad downstream fan-out | Preserve the canonical owner/anchor unless a real semantic conflict requires migration |

## Validation Strategy

1. Run targeted conformance/self-scenario checks while editing.
2. Run the full Bucket A suite because workflow/template/conformance files are high-blast-radius.
3. Forward-test with fresh agents and raw inputs:
   - a Simple, clear, localized design request;
   - the downstream reference-version requirement without this diagnosis;
   - a Large cross-subsystem change with schema, lifecycle, integration, concurrency, and rollout pressure.
4. Evaluate behavior by evidence traceability, authority separation, Current -> Target completeness, semantic fan-out, activated-risk quality, stale-question absence, observable acceptance, and justified artifact extraction. Do not score by length or file count.
5. Review all `Decision Context` consumers and archive/template links for semantic drift.

## Open Decisions

None. Pressure-triggered materialization is confirmed; implementation may proceed.
