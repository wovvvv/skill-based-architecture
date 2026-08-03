---
date: 2026-08-03
status: done
distilled_to:
  - templates/skill/protocol-blocks/source-localization.md
  - templates/skill/protocol-blocks/change-contract.md
  - templates/skill/protocol-blocks/ambiguous-request-gate.md
  - templates/skill/workflows/plan-feature.md
  - templates/skill/workflows/fix-bug.md
  - templates/skill/workflows/change-managed.md
  - templates/skill/workflows/task-execution.md
  - templates/skill/workflows/task-closure.md
  - templates/skill/conformance.yaml
  - references/self-hosting-conformance.yaml
  - scripts/check-self-scenarios.sh
  - docs/sba-bible.md
  - UPSTREAM-CHANGES.md
---

# Plan: Requirement-Semantics Change Contract

> Current conclusion: add one conditional `change-contract` protocol that owns desired meaning and implementation binding, compose it with the independently owned `source-localization` protocol, and let both operate on one Session-only runtime Change Contract. Keep the user experience as one continuous flow, preserve fast paths, and implement/validate upstream SBA before any project-specific downstream adaptation.

## Problem And Scope

SBA already routes tasks, delays domain knowledge until evidence requires it, separates desired business truth from current implementation fact, narrows evidence progressively, and prevents a successful command from being treated as outcome proof. It still lacks one complete contract between product-language input and safe source mutation.

Today the responsibilities are fragmented:

- `plan-feature.md` can close a design question and preserve user-confirmed decisions, but it does not own a reusable product-language-to-implementation readiness contract;
- `fix-bug.md` requires observed/expected behavior and root cause, but assumes the expected result is already concrete enough to locate and repair;
- `change-managed.md` requires scope, ownership, provenance, fan-out, and acceptance, but does not define how a vague product outcome becomes a bounded implementation intent;
- `ambiguous-request-gate.md` prevents asking users for implementation facts, but it owns question discipline rather than the complete desired meaning;
- `task-execution.md` owns Goal, Done When, Boundaries, evidence progression, and return behavior, but must not become a product-semantics or source-search workflow;
- `task-closure.md` reconciles the final result, but it is too late to define the contract for the first time;
- the approved [Evidence-Funnel Code Localization Plan](2026-07-31-evidence-funnel-code-localization.md) defines how to prove current code ownership without broad reading, but deliberately does not own desired product meaning.

The missing capability is a conditional translation and binding owner:

```text
product-language input
    -> Semantic Intent
    -> current implementation localization
    -> Implementation-Bound Change Contract
    -> Task Anchor / implementation / verification / Closure
```

This Plan covers the generic upstream SBA contract, its protocol boundaries, consumer hooks, behavior validation, implementation ordering, and downstream handoff boundary. It does not implement product-specific business meaning, a search runtime, or Chaos/chaos-web adaptation in the first delivery.

## Evidence Baseline

The discussion and current repository behavior exposed five concrete failure classes:

1. **Scope omission:** a requirement-bearing sentence or interaction surface is ignored because it is outside the dominant topic.
2. **Requirement/reference misclassification:** a design candidate or product rule is silently downgraded to background material and disappears from implementation scope.
3. **Associative over-expansion:** an explicit rule for one actor, surface, state, or object is generalized to another without authority.
4. **Search-vocabulary mismatch:** product wording does not match repository symbols, while broad synonyms produce noisy candidates rather than an owner.
5. **Wrong implementation owner:** a plausible phrase is bound to the wrong module, generated target, state owner, or consumer path.

The first three failures occur before source localization can be trusted. The last two require the approved localization funnel and selected-source proof. Treating them as one direct product-text-to-code prompt would manufacture unsupported semantic and technical authority.

The mechanism passes the template admission test:

- the failures recur across feature planning, bug fixing, managed change, and implementation handoff rather than one project-specific workflow;
- the protocol replaces repeated incomplete readiness checks with one complete owner plus thin local hooks;
- two real projects can disagree on activated fields, business authority, preserved behavior, and proof, so the mechanism carries more information than generic advice;
- the design states explicit fast paths, non-goals, return conditions, Session lifetime, and downstream boundaries.

## Decision Context

### D1 - Effective automation owns semantic translation

- **Status:** confirmed product direction.
- **Authority:** user-confirmed.
- **Decision:** SBA should let the Agent translate `product semantics -> executable change contract -> current code owner`; the user decides only normative meaning, authority boundaries, permissions, and high-cost trade-offs that repository evidence cannot decide.
- **Consequence:** users are never required to pre-translate a request, PRD, Figma surface, CGI/API description, or business rule into files, classes, methods, fields, configuration keys, or search terms.
- **Durable principle:** `docs/sba-bible.md` principle 12.

### D2 - Reuse the existing lifecycle

- **Status:** confirmed.
- **Authority:** user-confirmed.
- **Decision:** semantic translation belongs to the existing `拆解` responsibility; vocabulary expansion and owner proof belong to `定位`. The runtime Change Contract connects them without adding a new top-level lifecycle stage.
- **Consequence:** routing still selects the first business/task workflow. `change-contract` and `source-localization` are conditional protocol blocks, not sibling task routes or a universal workflow platform.

### D3 - Conditional activation and fast paths

- **Status:** confirmed.
- **Authority:** user-confirmed.
- **Decision:** activate `change-contract` only after workflow selection when missing semantic evidence could change scope, authority, preserved behavior, or acceptance. PRD/Figma presence, keywords, task size, file count, or complexity alone do not activate it.
- **Fast path:** reuse an explicit implementation-ready request, confirmed Plan, clear observed/expected contract, or already routed/proven owner when it satisfies the readiness checks.
- **Visibility:** runtime state is internal by default. Surface only a compact reviewable conclusion, a user-owned hard-gate decision, an otherwise unreviewable result, or an explicit audit request.

### D4 - Two physical owners, one runtime contract, one user flow

- **Status:** confirmed.
- **Authority:** user-confirmed.
- **Decision:** `change-contract.md` owns desired meaning and implementation binding; `source-localization.md` independently owns current implementation facts, actual owner, change point, and source-oriented narrowing. Both update one evolving Session-only runtime Change Contract.
- **Reason:** either protocol has real independent use. A read-only “where is this implemented?” request may need localization without semantic translation; an already-proven owner may allow binding without replaying the localization funnel.
- **Boundary:** physical separation must not create two user workflows or two persistent artifacts. Consumers call the needed owner internally and present one continuous task mainline.

### D5 - Semantic Intent readiness permits technical unknowns

- **Status:** confirmed.
- **Authority:** user-confirmed.
- **Decision:** `semantic-ready` means the intent is sufficient to constrain localization and reject a false owner, not that every semantic or technical detail has been exhausted.
- **Required evidence:** distinguishable observable outcome; traceable normative authority; enough scope, preserved behavior, and non-goal evidence to prevent omission or unauthorized expansion; an observable proof direction; and no remaining user-owned decision capable of redirecting localization.
- **Admissible unknowns:** file, symbol, caller, state owner, configuration key, repository path, current implementation shape, and other Agent-discoverable technical facts remain explicit inputs to source localization.
- **Return rule:** Agent-discoverable gaps return to evidence gathering; user-owned meaning/permission/scope/preservation/acceptance gaps use the minimum-question gate; contradictions keep the state open; non-material unknowns may be carried forward.

### D6 - Implementation binding proves the owner, not the final file list

- **Status:** confirmed.
- **Authority:** user-confirmed.
- **Decision:** `implementation-ready` requires a still-valid Semantic Intent, proven canonical owner/source relationship, bound Current -> Target behavior, decision-bearing semantic path, closed high-cost boundaries, preserved behavior, and a proof direction.
- **Not required before mutation:** a complete final file list, line-by-line design, exhaustive call graph, final helper names, or already-written tests.
- **Expansion rule:** files and consumers may enter only through a proven producer/consumer/state/contract/generation edge. Evidence inside the bound contract updates it and continues; evidence that changes owner, scope, public contract, permission, data/transaction, compatibility/migration/failure behavior, or acceptance returns to localization or semantic translation.
- **Drift rule:** conflict with user-confirmed desired meaning invokes the existing user-decision drift gate immediately rather than waiting for Closure.

### D7 - One complete owner plus thin consumer hooks

- **Status:** confirmed.
- **Authority:** user-confirmed.
- **Decision:** each consumer may repeat only its local trigger, provided input, consumed output, immediate action, and current-task acceptance. Complete Semantic Intent fields, authority rules, two-pass state transitions, return behavior, and completion gates stay in `change-contract`; complete search stages and tool/context boundaries stay in `source-localization`.
- **Consequence:** conformance must positively assert owner/consumer interfaces and negatively reject copied complete procedures.

### D8 - The localization Plan remains authoritative

- **Status:** confirmed.
- **Decision:** the existing source-localization Plan continues to own adaptive stages, runtime localization map, progressive model exposure, deterministic search contract, map persistence boundary, localization acceptance, and localization-specific risks/scenarios.
- **Consequence:** this Plan references that owner and defines the integration interface. It does not duplicate the full funnel, search tool contract, or fourteen localization scenarios.

### D9 - Upstream SBA first, downstream adaptation later

- **Status:** confirmed.
- **Authority:** user-confirmed.
- **Decision:** first implement and validate the generic upstream SBA protocol, hooks, conformance, scenarios, and upstream adaptation note. Do not modify Chaos/chaos-web canonical skills or assembled workspaces in the same first delivery.
- **Reason:** upstream behavior must be falsifiable independently before project semantics and assembly are introduced. Downstream adaptation consumes one verified upstream version and performs explicit source-to-destination mapping rather than blind copying.
- **Follow-up:** the upstream Plan and change note must leave a decision-ready adaptation contract, but actual downstream edits, assembly, commit/push/MR, and workspace verification require a separate authorized execution.

### D10 - No fixed schema or resource correctness budget

- **Status:** confirmed product boundary.
- **Decision:** the runtime contract has stable logical dimensions and states, not a mandatory visible form, evidence ledger, fixed field table, keyword dictionary, Token/file/step threshold, or persistent project artifact.
- **Consequence:** simple tasks may satisfy the contract internally in one sentence. Dimensions expand only when evidence shows they can change meaning, owner, implementation, risk, or proof.

### D11 - Durable Plan and implementation authorization remain separate

- **Status:** confirmed and satisfied for upstream implementation.
- **Authority:** user-confirmed.
- **Decision:** this single file preserves the reconciled design and becomes the later implementation/review contract. Creating it does not authorize modifications to active protocols, workflows, conformance, scenarios, downstream repositories, commits, pushes, MRs, or delivery systems.
- **Implementation gate:** the user explicitly approved execution on 2026-08-03; both governing Plans completed T1-T6 and are `done` with truthful `distilled_to`. Downstream adaptation and source delivery remained separate authorization boundaries and were handled by later tasks.

## Chosen Runtime Contract

### Logical Shape

The runtime Change Contract is Session state, not a required document or visible form:

```text
Semantic Intent
- desired-meaning authority
- desired observable outcome
- actor/trigger when behavior depends on them
- materially activated scope
- preserved behavior and non-goals
- acceptance evidence direction
- unresolved normative and technical questions

Source Binding
- candidate then proven canonical owner/source of truth
- current behavior and controlling path
- Current -> Target change points
- producer/consumer/state/contract/generated relationships
- affected semantic paths and high-cost boundaries
- contradictions and residual technical uncertainty

Execution Binding
- implementation-ready state
- Task Anchor inputs: Goal, Done When, Boundaries
- proof mapping and return conditions
- contract expansions and superseded hypotheses
```

Fields are activated by evidence. An actor is unnecessary when it cannot change behavior; migration is unnecessary when no persisted/public contract changes; a non-goal need not be invented when the scope is already unambiguous.

### State Model

```text
unexamined
    -> semantic-incomplete
        -> Agent evidence gathering
        -> user-decision-required
        -> semantic-ready

semantic-ready
    -> localization-required
        -> owner-unresolved
        -> source contradiction -> semantic-incomplete
        -> owner-proven
    -> owner already proven -> owner-proven

owner-proven
    -> binding-incomplete
        -> targeted impact/contract trace
        -> semantic contradiction -> semantic-incomplete or user-decision-required
        -> implementation-ready

implementation-ready
    -> implementation/verification
        -> evidence-preserving expansion -> update contract and continue
        -> contract-changing evidence -> return to localization/translation
        -> desired-meaning drift -> user-decision-required
    -> Closure reconciliation
```

Current code differing from desired behavior is normally the reason for the change, not a semantic contradiction. Return to semantic interpretation only when source evidence invalidates the assumed meaning, authority, scope, object relationship, preservation boundary, or acceptance model.

### Semantic-Ready Gate

Enter source localization when all applicable checks pass:

| Check | Ready evidence | Blocking condition |
|---|---|---|
| Outcome | Correct and incorrect observable results are distinguishable | The request can lead to materially different future behavior |
| Authority | Every normative claim is confirmed, proposed, or explicitly unresolved | Inference/reference material is silently treated as a requirement |
| Scope | Material requirement-bearing inputs are accounted for | A known surface/actor/state/relationship may be omitted or expanded without authority |
| Preservation | Applicable unchanged behavior/non-goals are known | The implementation could change adjacent behavior without a decision |
| Proof direction | A later observable check can distinguish success | Success is only “code was changed” or “command exited zero” |
| Unknowns | Remaining blockers are Agent-discoverable technical facts | A user-owned meaning, permission, scope, preservation, or acceptance decision could redirect localization |

### Change Contract -> Source Localization Interface

`change-contract` provides only the evidence needed to guide technical localization:

- desired observable outcome and materially distinct interpretations;
- actor/trigger and product surface when they affect owner selection;
- preserved behavior, exclusions, and forbidden associative expansion;
- desired-meaning authority and unresolved technical questions;
- candidate owner region and bounded search-vocabulary hypotheses when available;
- the evidence that would falsify a candidate owner.

`source-localization` returns:

- proven or still-unresolved canonical owner/source of truth;
- current behavior, controlling entry/change point, and source evidence;
- producer/consumer/state/contract/generated relationships activated by the decision;
- affected path boundary and residual technical uncertainty;
- contradictions that invalidate the Semantic Intent premise;
- a compact localization conclusion consumed by implementation binding.

Localization never changes desired meaning. Product inference may generate candidates; desired-meaning authority governs normative scope; source evidence binds current implementation facts.

### Implementation-Ready Gate

Mutation may begin only when all applicable checks pass:

| Check | Required before first mutation | May remain progressive |
|---|---|---|
| Semantic validity | Desired meaning and authority still hold after source inspection | Non-material wording refinement |
| Canonical owner | Source/generated/provenance relationship and actual controlling boundary are proven | Local helper/file choices inside that owner |
| Current -> Target | Observable current behavior and target delta are bound to the owner | Line-by-line implementation design |
| Semantic path | Every hop capable of changing the chosen design is closed | Additional consumers discovered along an already proven edge |
| High-cost boundaries | Public contract, permission, data/transaction, compatibility/migration, failure/recovery, generation, and acceptance unknowns are closed when activated | Ordinary reversible implementation detail |
| Proof | Each major outcome/risk has fitted falsification evidence | Exact test file/helper arrangement |

Each discovered expansion must name the relationship that admitted it and update impact/proof responsibility before mutation continues. A file count increase is valid when decision uncertainty decreases along a proven semantic path.

### Visibility And Lifetime

- Keep the runtime contract in current Session state, harness-native Plan/current step, or compact Task Anchor checkpoints.
- Recover only current desired meaning, owner/binding evidence, material exclusions, unresolved blocker, and next action after compaction.
- Do not create a repository Change Contract file, ledger, generated manifest, Wiki, or database for ordinary tasks.
- Present a compact checkpoint only for a user-owned normative decision, material authority/scope conflict, high-cost authorization, unreviewable conclusion, or explicit audit.
- A durable feature Plan may preserve the confirmed contract under the existing Artifact Pressure Gate; implementation tasks do not create another persistent copy.

## Semantic Ownership And Consumer Hooks

### Complete Owners

| Owner | Complete responsibility | Explicit non-responsibility |
|---|---|---|
| `protocol-blocks/change-contract.md` | activation/skip, Semantic Intent, authority, readiness, source handoff, binding, return states, visibility | task routing, business truth storage, question wording, search procedure, Task Anchor, implementation steps, tests, Closure procedure |
| `protocol-blocks/source-localization.md` | adaptive technical narrowing, runtime localization map, search contract, source-owner proof, localization return states | desired meaning, product authority, task routing, persistent map creation, mutation, validation rigor |
| `protocol-blocks/ambiguous-request-gate.md` | minimum user question after Agent-available facts are closed | Semantic Intent definition or authority state machine |
| `workflows/task-execution.md` | Task Anchor, Native Plan state, generic evidence advance/return, decision-drift gate | product-language translation or complete code-search funnel |
| `workflows/task-closure.md` | final reconciliation and fitted outcome proof | first-time contract definition or late silent resolution of drift |

### Thin Hooks

| Consumer | Trigger/input | Consumed output | Current-task acceptance |
|---|---|---|---|
| `plan-feature.md` | Current Design Slice lacks implementation-ready semantics or current owner evidence | Semantic Intent and, when needed, bound Current -> Target | requirement/design, impact, risk, and proof can be reconstructed without invented symbols |
| `fix-bug.md` | observed/expected, preservation, authority, or actual root-cause owner remains materially unclear | expected semantic contract plus proven owner/path | defect classification and repair target are bound; no design change is smuggled through Bug Fix |
| `change-managed.md` | observable target, canonical owner, source/derived boundary, or affected semantic path is insufficient | implementation-bound contract | mutation remains inside the bound outcome and all admitted fan-out/provenance is handled |
| `ambiguous-request-gate.md` | Change Contract exposes a user-owned normative blocker | one resolved/superseded decision | no Agent-discoverable implementation fact is asked back to the user |
| `task-execution.md` | task is non-Simple after the selected workflow has enough binding evidence | Goal, Done When, Boundaries, proof and return conditions | Anchor derives from rather than reinterprets the contract |
| `task-closure.md` | local execution is complete | final expanded contract and evidence | final behavior, preserved boundaries, proof, and decision mainline reconcile; drift returns to its owner |

Review workflows receive no hook in the first implementation unless an actual validation scenario proves changed-diff/source-Plan evidence cannot localize or bind a finding through existing behavior.

## Requirements And Acceptance

- **R1 - No user translation tax:** ordinary users provide product meaning, not repository vocabulary or implementation locations.
- **R2 - Route-first composition:** task routing still selects exactly one first workflow; Change Contract and localization compose afterward from evidence.
- **R3 - Conditional activation:** clear requests and proven owners use fast paths; no PRD/Figma/keyword/task-size trigger creates ceremony.
- **R4 - Authority separation:** inference generates candidates, desired-meaning authority governs normative scope, and source evidence binds implementation facts.
- **R5 - Complete input disposition:** every material requirement-bearing input is confirmed as requirement, constraint, context/reference, proposed/unresolved, or excluded with evidence; nothing silently disappears or becomes normative.
- **R6 - No associative expansion:** behavior for another actor/surface/state/object enters scope only through authority or an explicit user decision.
- **R7 - Semantic-ready without circularity:** technical owner/symbol/path unknowns may enter localization; user-owned blockers cannot.
- **R8 - Source owner proof:** lexical/path matches are candidates, not ownership proof; generated/derived targets lead to canonical sources.
- **R9 - Implementation-ready without exhaustive inventory:** the owner, delta, decision-bearing path, high-cost boundaries, preservation, and proof are closed; files may grow only along proven semantic edges.
- **R10 - Reversible progression:** inconclusive evidence keeps the current state open; contradictory evidence returns to the owning earlier state; contract-changing discoveries pause mutation.
- **R11 - One complete owner:** consumers remain locally actionable without copying complete fields, state transitions, search stages, or return procedures.
- **R12 - Internal by default:** users see decisions and reviewable conclusions, not mandatory protocol narration or runtime ledgers.
- **R13 - Session-only default:** ordinary tasks create no Change Contract, technical map, Wiki, manifest, index, or database artifact.
- **R14 - Evidence-bearing completion:** creating text, finding a symbol, editing a file, or receiving exit code zero does not prove readiness or task completion.
- **R15 - Closure fidelity:** final expanded implementation and proof reconcile against the same user-confirmed desired meaning and source-bound contract.
- **R16 - Upstream isolation:** the first delivery changes and validates upstream SBA only; downstream project semantics and generated workspaces remain untouched.
- **R17 - Ordinary-user completeness:** a downstream project that adopts the later verified mechanism remains usable after clone/pull without author-only setup, search services, or manual protocol selection.

## Executable Task Breakdown

### T1 - Implement The Approved Source-Localization Owner

- **Files:** `templates/skill/protocol-blocks/source-localization.md`; source-localization registrations in `templates/skill/conformance.yaml` and `references/self-hosting-conformance.yaml`; focused self-hosting scenarios in `scripts/check-self-scenarios.sh`.
- **Consumes:** [Evidence-Funnel Code Localization Plan](2026-07-31-evidence-funnel-code-localization.md), especially D3-D8, the adaptive funnel, tool/context boundary, runtime map, acceptance, and scenarios.
- **Produces:** one complete conditional technical-localization owner with adaptive entry/skip/return, bounded deterministic-search interface, selected-source proof, and Session-only map behavior.
- **Acceptance:** known-target, ambiguous-target, empty/noisy-result, generated-source, no-map, read-only, compaction, and internal/audit visibility scenarios behave as the approved localization Plan requires; no search executable or persistent map is added.

### T2 - Implement The Change Contract Owner And Interface

- **Files:** `templates/skill/protocol-blocks/change-contract.md`; its conformance registrations.
- **Consumes:** D1-D10 and the Chosen Runtime Contract in this Plan; T1's source-localization input/output contract.
- **Produces:** conditional activation/fast path, Semantic Intent, authority handling, semantic-ready and implementation-ready gates, state transitions, source handoff, evidence-driven expansion, visibility, and Session-lifetime rules.
- **Acceptance:** the owner distinguishes normative from technical unknowns, allows localization without pre-known symbols, refuses mutation without proven owner/high-cost boundaries/proof, and returns to the correct owner when evidence changes the contract.

### T3 - Add Thin Consumer Hooks

- **Files:** `templates/skill/workflows/plan-feature.md`, `fix-bug.md`, `change-managed.md`, `task-execution.md`, `task-closure.md`, and `templates/skill/protocol-blocks/ambiguous-request-gate.md`.
- **Consumes:** T1/T2 owner links and the Semantic Ownership And Consumer Hooks table.
- **Produces:** local trigger/input/output/acceptance hooks with no copied complete protocol or competing state machine.
- **Acceptance:** each normal workflow remains independently actionable; Simple/known-target fast paths stay short; Plan, Bug Fix, and Managed Change consume the same bound contract according to their distinct acceptance; Task Execution and Closure retain their existing ownership.

### T4 - Prove Owner Boundaries And Activation

- **Files:** `templates/skill/conformance.yaml`, `references/self-hosting-conformance.yaml`, and only the smallest self-hosting/public navigation surface needed to activate the new owners.
- **Consumes:** R2-R13 and T1-T3 outputs.
- **Produces:** positive assertions for complete owners and consumer links; negative assertions against route creation, eager loading, full-procedure duplication, persistent runtime artifacts, and inference-as-authority.
- **Acceptance:** structural checks prove reachability and ownership without placing either protocol in Always Read or task routing; consumer checks cannot pass by copying the full fields/stages locally.

### T5 - Add Behavior And Forward Validation

- **Files:** `scripts/check-self-scenarios.sh` and existing repository-owned validation fixtures/surfaces only when a scenario needs them.
- **Consumes:** Requirements And Acceptance plus the source-localization scenarios by reference.
- **Produces:** regression scenarios that fail against current fragmented or over-eager behavior and pass only when the composed contract changes the next action correctly.
- **Acceptance:** targeted scenarios, template conformance, self-hosting conformance, shell/path integrity, smoke tests, `git diff --check`, and fresh-agent forward runs are green. Structural green alone is insufficient; at least one known-target and one ambiguous product-language task must demonstrate the intended fast path, bounded context exposure, owner proof, and return behavior.

### T6 - Reconcile Upstream Documentation And Complete Delivery Readiness

- **Files:** current `docs/sba-bible.md` principle 12 edit, this Plan, `UPSTREAM-CHANGES.md`, and only additional owner/navigation text proven necessary by implementation.
- **Consumes:** implementation evidence from T1-T5 and the existing Bible principles 8-16.
- **Produces:** one reconciled upstream semantic owner set, an actionable downstream adaptation note, truthful Plan status/distillation targets, and Bucket A Closure evidence.
- **Acceptance:** no duplicated Bible principle or stale Plan question remains; `bash scripts/check-all.sh --base HEAD` passes after final reconciliation; the intended upstream change set is isolated from unrelated untracked/dirty paths; no downstream repo/workspace is changed. Commit, push, MR, or release delivery remains separately authorized.

## Validation Scenarios

The implementation must preserve every localization-specific scenario in the referenced source-localization Plan and add the following composed scenarios:

1. **Explicit local change fast path:** a clear target and proven owner skip expanded Semantic Intent and irrelevant localization stages.
2. **PRD scope omission:** a material surface outside the dominant paragraph remains classified and cannot silently disappear.
3. **Reference downgrade:** a design/input unit receives an explicit semantic disposition instead of being silently treated as background.
4. **Associative expansion:** an Agent may propose a related behavior as a candidate but cannot place it in scope or acceptance without authority.
5. **Normative blocker:** unclear permission, preserved behavior, or product outcome produces one minimum user question after implementation facts are closed.
6. **Technical unknown:** unknown files/classes/callers flow into source localization without asking the user for repository facts.
7. **Wrong lexical owner:** a plausible string match remains a candidate until canonical owner and semantic path evidence prove it.
8. **Normal Current/Target difference:** current behavior differing from desired behavior binds a change; it does not falsely return as a semantic contradiction.
9. **Semantic premise contradiction:** source evidence that invalidates scope, object relationship, authority, preservation, or acceptance returns to semantic translation.
10. **Progressive file expansion:** an additional consumer enters only through a proven edge and adds impact/proof responsibility without broad inventory.
11. **High-cost boundary discovery:** a new public contract, generated source, data/transaction, compatibility, migration, or failure boundary pauses mutation until the contract is rebound.
12. **Implementation drift:** implementation that conflicts with user-confirmed desired meaning triggers the existing drift gate before Closure.
13. **Task Anchor derivation:** Goal, Done When, and Boundaries consume the bound contract without reinterpreting the PRD or duplicating its full state.
14. **Closure reconciliation:** final behavior and all expanded paths/proof are checked against the same desired meaning and source binding; command success alone cannot close the task.
15. **Internal visibility:** ordinary tasks expose only compact decisions/results, while explicit audit and user-decision checkpoints reveal bounded evidence.
16. **No durable runtime artifact:** ordinary execution leaves no contract file, map, Wiki, manifest, ledger, index, or generated state in the project.
17. **Downstream-free upstream delivery:** all upstream checks can pass without touching Chaos/chaos-web or relying on project-specific business content.

## Risks And Controls

- **Universal ceremony:** every task could be forced through a visible semantic checklist. **Control:** readiness-based activation, fast paths, evidence-activated dimensions, and internal-by-default state.
- **User technical tax:** incomplete semantics could cause the Agent to ask for files or symbols. **Control:** classify technical unknowns as localization inputs and ask only user-owned normative decisions.
- **Authority mixing:** source behavior or Agent inference could rewrite desired meaning. **Control:** separate owners, explicit authority state, contradiction returns, and drift gate.
- **Circular readiness:** localization could require the owner to be known before it starts. **Control:** `semantic-ready` requires enough evidence to constrain/reject candidates, not implementation location.
- **Premature mutation:** a plausible match could become a patch target. **Control:** canonical owner/source proof plus implementation-ready gate.
- **Broad pre-mutation inventory:** requiring the final file list could recreate context exhaustion. **Control:** prove the decision-bearing path first and expand only through semantic evidence.
- **Incomplete fan-out:** progressive expansion could miss a real consumer. **Control:** every admitted edge updates impact/proof, activated high-cost boundaries block, and Closure reconciles the final expanded set.
- **Competing definitions:** six consumers could restate the full protocol. **Control:** one complete owner, thin-hook conformance, and negative duplication assertions.
- **Protocol/platform creep:** the mechanism could become a new workflow engine, schema, search service, or persistence layer. **Control:** explicit non-ownership, no route, no runtime dependency, no persistent default, and native-tool reuse.
- **Plan duplication:** the new Plan could copy the full localization design. **Control:** interface and dependency references only; localization stages/maps/tool semantics stay canonical in the existing Plan.
- **Downstream coupling:** project adaptation could hide upstream defects. **Control:** upstream-only first delivery and a later source-to-destination adaptation task against a verified version.
- **Unmeasured benefit:** structural reachability could pass without improving behavior. **Control:** fresh-agent forward tests compare decisions, exposure order, questions, owner proof, and return behavior; Token/file counts remain diagnostics only.

## Out Of Scope

- A new task route, top-level lifecycle phase, planning runtime, or universal context workflow.
- A fixed visible Change Contract form, mandatory evidence ledger, global ontology, or keyword dictionary.
- Fixed Token, line, file, question, stage, or elapsed-time correctness thresholds.
- A grep engine, search wrapper, code graph, embedding index, database, daemon, language-server dependency, or tool installer.
- Mandatory persistent technical maps, Change Contract files, project Wikis, indexes, manifests, or generated state.
- Replacing the business-model owner, source-localization owner, Task Anchor, Native Plan, question gate, Task Closure, or Task Closure AAR.
- Requiring all callers to load the SBA Bible or either protocol before workflow selection.
- Designing exact project fields, APIs, classes, schemas, storage, UI behavior, or business rules.
- Modifying Chaos/chaos-web canonical skills, generated `.codex`/`.claude` copies, release workspaces, or business repositories in the upstream first delivery.
- Commit, push, MR, deploy, publish, or release work without separate authorization.

## Rollout Boundary

### Phase 1 - Upstream SBA

Implement T1-T6 in this repository, validate the generic behavior, reconcile the Plan and active owners, and produce an upstream change note that describes downstream semantic adaptation points. Phase 1 is complete only when the full Bucket A contract and fresh behavior runs pass; a successful edit or command is not delivery.

### Phase 2 - Project Adaptation

After a verified upstream version exists and the user authorizes downstream work:

1. route each downstream repository through its own `update-upstream`/project workflow;
2. classify upstream protocol blocks as vendor/project-owned according to the downstream manifest;
3. map each generic consumer hook to the real Chaos/chaos-web semantic owner without blind copying;
4. adapt business/model/question/validation boundaries while keeping desired truth separate from current code facts;
5. run canonical meta validation before assembly;
6. assemble exact `.codex`/`.claude` copies only from the canonical source;
7. prove existing business repository HEADs and dirty/untracked work are preserved;
8. verify any requested commit, push, MR, or handoff artifact separately.

Phase 2 may use a separate execution Plan if project evidence activates additional owners, risks, or delivery requirements. This upstream Plan must not predict project-specific content.

Phase 2 was later authorized and completed through the canonical Chaos meta source: both app skills consumed the two complete owners through project-specific thin hooks, passed canonical and installed validation, and were assembled byte-identically into the 0.77 `.claude` / `.codex` surfaces while preserving business-repository work. Commit, push, and MR verification remain owned by the subsequent delivery task rather than this design Plan.

## Implementation Outcome

Upstream T1-T6 completed locally on 2026-08-03 without changing the confirmed desired meaning, rollout boundary, or delivery authority.

- T1/T2 added the 29-line source-localization owner and 24-line Change Contract owner. Both remain below the protocol-block budget and create no task route, eager routing read, search runtime, or persistent task artifact.
- T3/T4 connected Plan Feature, Fix Bug, Managed Change, Ambiguous Request Gate, Task Execution, and Task Closure through thin local hooks. Template/self-hosting conformance and self-scenarios positively protect the owner interfaces and reject copied complete Semantic Intent or localization procedures.
- T5 content review found no competing owner or authority inversion. A fresh known-target run used the direct fast path; a fresh ambiguous product-language run kept technical discovery with the Agent, proved both owners and their consumers, and requested no repository vocabulary from the user. The known-target run exposed one missing normal-Current/Target regression lock, which was added to the existing validation surfaces.
- T6 added the downstream adaptation entry in `UPSTREAM-CHANGES.md`. `bash scripts/check-all.sh --base HEAD` passed after the final active implementation edit, including temporary new/existing downstream instantiation, smoke, orphan/reachability, routing/shell integrity, self scenarios `376/376`, template conformance `422/422`, and self-hosting conformance `263/263`.
- Final upstream Closure found no new durable lesson or activation gap beyond the fitted regression assertion already reconciled above. Unrelated dirty/untracked paths were preserved. The later separately authorized Phase 2 completed Chaos/chaos-web adaptation and 0.77 assembly without changing the confirmed upstream contract; commit, push, and MR verification remain separate delivery evidence.

The `distilled_to` list names the complete active upstream owner/consumer/proof surfaces. This Plan is `done`; later downstream adaptation must consume a verified upstream version under separate authorization.
