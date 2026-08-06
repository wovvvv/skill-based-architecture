---
date: 2026-08-05
status: done
distilled_to:
  - templates/skill/workflows/update-rules.md
  - templates/skill/workflows/rule-update/business-truth.md
  - templates/skill/workflows/rule-update/verified-failure.md
  - templates/skill/workflows/rule-update/knowledge-reconciliation.md
  - templates/skill/workflows/rule-update/workflow-distillation.md
  - templates/skill/workflows/plan-feature.md
  - templates/skill/workflows/profile-business-model.md.example
  - templates/skill/workflows/task-execution.md
  - templates/skill/workflows/fix-bug.md
  - templates/skill/workflows/task-closure.md
  - templates/skill/workflows/maintain-docs.md
  - templates/skill/workflows/edit-templates.md
  - templates/skill/references/gotchas.md
  - references/protocols.md
---

# Plan: Rule Update Progressive Disclosure

> Current conclusion: preserve the existing business-truth, verified-failure, ordinary-knowledge, and workflow-distillation semantics, but replace the monolithic Rule Update workflow with one compact shared durable-write contract plus four independently loaded execution owners; known callers enter their owner directly, while only ambiguous explicit recording requests use the dispatcher.

## Problem And Scope

`templates/skill/workflows/update-rules.md` is the canonical generic Rule Update owner and currently occupies about 23.4 KB. The assembled Chaos backend adaptation is about 23.5 KB and the frontend adaptation about 22.6 KB. Each file combines:

- destination classification;
- Business Leaf / Gotcha ownership;
- Plan decision and business-leaf reconciliation;
- standalone business modeling and confirmed-gap intake;
- active Bug Fix user-business input;
- verified-failure admission, lifecycle outcomes, recurrence, activation repair, and enforcement escalation;
- accepted workflow-distillation `extend / compose / create` handling;
- ordinary AAR admission, fidelity, reconciliation, placement, activation, synchronization, correction, retirement, and completion checks.

These meanings are individually load-bearing and already have distinct callers. The runtime problem is that a caller normally knows its input type before invoking Rule Update, yet still loads every unrelated branch. A JDK / Mockito failure therefore pays for business modeling, Plan handoff, ordinary AAR, and workflow distillation; a business Plan handoff pays for failure recurrence and enforcement escalation; a normal Closure lesson pays for both.

The target is a semantics-preserving responsibility and loading refactor. It does not weaken or reopen the completed product decisions in:

- `docs/plans/2026-08-04-failure-driven-long-term-memory.md`;
- `docs/plans/2026-08-04-proactive-workflow-distillation.md`;
- `docs/plans/2026-07-27-rule-ownership-and-change-fanout/prd.md`;
- `docs/plans/2026-07-16-business-global-model-and-load-reason/prd.md`.

It also does not create a Memory subsystem, knowledge database, candidate ledger, new route manifest, user-visible mode, package choice, or automatic higher-scope promotion. No database-structure change is involved.

## Current Decisions

### D1 - Split by independent runtime input, not by file size

Rule Update will materialize four execution owners because the current callers activate them at different lifecycle moments, carry different evidence, write to different semantic destinations, and enforce different authority boundaries. File size is diagnostic evidence only; it is not the acceptance criterion.

Decision Context:

- Trigger/question: whether the current monolithic `update-rules.md` should become a compact owner plus independently loaded paths for user-confirmed business meaning, verified engineering failure, ordinary Closure learning, and accepted workflow distillation.
- Faithful answer: `按你说的`.
- Authority: user-confirmed.
- Normative meaning: accept the recommended shared-contract plus four-owner structure, including the refinement that ordinary knowledge reconciliation also owns explicit non-business recording, correction, and retirement so existing behavior is not lost.
- Scope: canonical SBA template, self-hosting consumers and validation, Chaos backend/frontend meta adaptations, and generated downstream copies. The decision does not authorize implementation, downstream assembly, commit, push, MR, deployment, database, platform, or other external actions.
- Agent-derived consequences: preserve every previously confirmed semantic and authority boundary; change physical ownership, direct links, loading order, and validation only where needed to make irrelevant reads conditional.
- Evidence / Source: current conversation; current upstream and Chaos Rule Update headings, sizes, and consumer links; SBA Bible principles 1-3, 7-10, 13-14.

### D2 - `update-rules.md` remains the compact shared contract and ambiguous-request dispatcher

The existing path remains stable. It owns only the durable-write rules shared by every branch and the dispatch decision for explicit requests whose input type is not yet known.

The compact owner retains:

- input and destination classification;
- source / authority / semantic-fidelity preservation;
- targeted search of the nearest likely existing owners;
- exactly one `no-write / extend / correct / retire / add` reconciliation result;
- action-changing activation rather than storage-only completion;
- the lightest sufficient placement and shape;
- affected routing/generated/consumer synchronization and fitted re-verification;
- unchanged local and external authority boundaries.

It does not retain the complete Business, Verified Failure, ordinary-learning, or Workflow Distillation procedures or one global checklist containing every branch.

### D3 - Four execution owners materialize under one workflow namespace

The target physical shape is:

```text
templates/skill/workflows/
├── update-rules.md
└── rule-update/
    ├── business-truth.md
    ├── verified-failure.md
    ├── knowledge-reconciliation.md
    └── workflow-distillation.md
```

No `rule-update/index.md` or second routing manifest is created. `update-rules.md` is already the selecting owner. The nested directory exists because the four procedures are direct consumers of one Rule Update lifecycle and would otherwise add unrelated top-level workflow clutter.

### D4 - Known callers enter the execution owner directly

Callers that already possess typed evidence do not reload the dispatcher merely to rediscover the type:

| Caller / evidence | Direct execution owner |
|---|---|
| `plan-feature` business-bearing implementation handoff | `rule-update/business-truth.md` |
| `profile-business-model` standalone confirmed meaning / gap | `rule-update/business-truth.md` |
| `fix-bug` explicit durable user business statement | `rule-update/business-truth.md` |
| `maintain-docs` Business Leaf / Gotcha owner reconciliation | `rule-update/business-truth.md` |
| `task-execution` proven root cause + repair + red-to-green evidence | `rule-update/verified-failure.md` |
| `fix-bug` proven engineering failure | `rule-update/verified-failure.md` |
| `task-closure` verified-failure accounting | check the returned outcome; do not rerun the procedure |
| `task-closure` ordinary recordable lesson | `rule-update/knowledge-reconciliation.md` |
| explicit non-business record / correction / retirement | `rule-update/knowledge-reconciliation.md` |
| user-accepted post-Closure workflow proposal | `rule-update/workflow-distillation.md` |
| ambiguous explicit `记录一下 / 更新规则 / 这个以后要注意` | `update-rules.md` dispatcher, then exactly one owner |

Each execution owner consumes the compact durable-write contract when a persistent change or no-write reconciliation is evaluated. Within one unchanged Session the shared contract may be reused rather than reread.

### D5 - Business Truth owns all desired-business-truth inputs

`rule-update/business-truth.md` owns:

- Business Leaf and Gotcha ownership;
- Plan Decision Source and Plan Leaf Reconciliation;
- standalone modeling and confirmed-gap upgrade intake;
- active Bug Fix user-business input;
- Requirement / Modeling provenance;
- business-specific fidelity and cross-implementation stability;
- desired business truth versus current implementation fact separation;
- business-owner routing and synchronization responsibilities.

It preserves the hard boundary that Bug symptoms, root cause, repaired behavior, code, tests, runtime evidence, and Agent summaries cannot create `desired business truth`. Only user-confirmed normative meaning enters the business owner.

### D6 - Verified Failure owns proven engineering prevention

`rule-update/verified-failure.md` owns:

- proof prerequisites: failure boundary, root cause, completed repair, fitted red-to-green evidence, and a stable future action;
- the seven existing lifecycle outcomes;
- same-root-cause recurrence identity;
- missed/inert activation repair;
- reached-but-insufficient prevention escalation;
- machine-gate admission and escape-path requirements;
- project / iteration / personal / team promotion boundaries;
- unchanged commit, delivery, shared-system, and external authority limits;
- failure-specific completion evidence returned to Task Execution and Closure.

Raw messages, rejected hypotheses, unresolved causes, same-task retries, transient interruptions, and one-off command mistakes remain Session-only under the already confirmed failure-learning contract.

### D7 - Knowledge Reconciliation owns ordinary learning, correction, and retirement

`rule-update/knowledge-reconciliation.md` is intentionally broader than `AAR` and owns:

- ordinary Closure lessons;
- explicit user-requested non-business records;
- Agent-observed reusable knowledge not admitted through the other three inputs;
- the ordinary Recording Threshold;
- ordinary `When NOT to Record` boundaries;
- correction of inaccurate or over-broad knowledge;
- retirement or legacy scoping when the premise no longer exists;
- rule-existed-but-was-missed activation repair when no Verified Failure escalation is active;
- generic placement and cross-project generalization decisions.

Full-file reorganization, split/merge, index admission, orphan/reachability audits, and independent-load-reason maintenance remain owned by `maintain-docs.md`.

### D8 - Workflow Distillation owns only accepted durable workflow mutation

`rule-update/workflow-distillation.md` owns:

- at least two independently completed semantic instances;
- reusable workflow identity and stable contract reconstruction;
- exactly one `extend / compose / create` result;
- pure-composition no-persistence behavior;
- canonical source and generated/downstream provenance;
- one complete cross-repository orchestration owner plus thin local hooks;
- assembly/install and downstream-consumer verification;
- the existing boundary that workflow acceptance grants no commit, push, MR, deploy, database, work-item, version-revision, reviewer, publish, merge, team-promotion, or shared-system authority.

It is loaded only after Task Closure reports the completed result, presents an evidence-backed proposal, and the user accepts it.

### D9 - This Plan is independent from downstream materialization simplification

This Plan and `docs/plans/2026-08-04-default-downstream-simplification/prd.md` can each complete, freeze, and be consumed without the other. Neither is `subplan_of` the other, and this Plan does not edit that draft.

The default-downstream materializer may later use the resulting owner set as evidence-driven optional responsibilities. A project that does not admit business modeling, verified-failure learning, ordinary durable records, or workflow distillation must not receive the corresponding leaf merely because SBA's Full source contains it.

### D10 - Canonical source changes before Chaos adaptation and downstream assembly

The implementation order is:

1. change canonical SBA template owners and consumers;
2. update self-hosting conformance/scenarios and validate the source behavior;
3. adapt the Chaos backend meta owner under `~/.ai-infra/chaos/apps/chaos/skills/chaos/`;
4. adapt the Chaos frontend meta owner under `~/.ai-infra/chaos/apps/chaos_web/skills/chaos-web/`;
5. run the repository-owned aii assembly path;
6. verify generated `.codex` / `.claude` downstream copies and real load journeys.

Installed/generated files are never edited as independent semantic owners. Backend/frontend adaptations preserve their existing project-specific Plan Leaf, business owner, cross-app, and code-root semantics instead of blindly replacing them with the generic English template.

## Current To Target Design

| Journey | Current Rule Update read | Target Rule Update read |
|---|---|---|
| Business Plan handoff | full monolith | compact contract + Business Truth |
| Fix Bug user business correction | full monolith | compact contract + Business Truth |
| JDK / Mockito verified failure | full monolith | compact contract + Verified Failure |
| Ordinary Closure lesson | full monolith | compact contract + Knowledge Reconciliation |
| Explicit incorrect-rule correction | full monolith | compact contract + Knowledge Reconciliation |
| Accepted repeated workflow proposal | full monolith | compact contract + Workflow Distillation |
| Ambiguous explicit recording request | full monolith | compact dispatcher + exactly one selected owner |

The target does not impose byte or file-count correctness budgets. Diagnostic success means each normal journey stops loading unrelated input contracts while preserving the same decision, destination, authority, activation, and verification behavior.

## Requirements And Acceptance

- `update-rules.md` remains the only explicit ambiguous-request entry and the only complete owner of the shared durable-write contract.
- Each of the four execution files has at least one real direct caller and changes the caller's next action without requiring other execution leaves.
- No execution leaf imports or requires another execution leaf as a normal prerequisite.
- Known typed callers link directly to their owner; they do not enter the dispatcher first.
- A persistent outcome consumes the shared contract exactly once per unchanged Session and returns a branch-specific completion result.
- Business Truth preserves user authority, Plan / Modeling provenance, unique routed owner, cross-implementation stability, and desired-truth/current-fact separation.
- Verified Failure preserves all seven outcomes, recurrence identity, activation repair, enforcement escalation, promotion boundaries, and unchanged external authority.
- Knowledge Reconciliation preserves ordinary threshold, explicit non-business recording, no-record boundaries, correction, retirement, activation repair, placement, and generalization.
- Workflow Distillation preserves two-instance evidence, result-first proposal timing, acceptance, `extend / compose / create`, pure composition, canonical provenance, downstream verification, and unchanged authority.
- `maintain-docs.md` remains the complete owner of full-document split/merge/index/load-reason maintenance.
- Generic completion criteria move to the shared contract; branch-specific criteria move to their execution owner. No global checklist requires an unrelated branch to be read.
- Existing route names and ordinary user requests remain valid. No new user-visible profile, package, mode, install choice, routing manifest, Memory store, candidate ledger, counter, or timeline is introduced.
- All current inbound anchors are updated atomically. Conformance validates complete semantics at the canonical owner and activation/link behavior at callers.
- Nested workflow paths pass routing, orphan, reachability, Markdown-link, content-conformance, and self-hosting checks.
- Chaos backend and frontend meta adaptations preserve local semantics and produce verified generated copies through aii rather than direct installed-copy edits.
- The implementation reports before/after load journeys as diagnostic evidence without turning sizes into hard gates.

## Validation Journeys

1. **Plan handoff:** a business-bearing confirmed Plan reaches Business Truth, reconciles every relevant Decision into one active owner, and does not load failure, ordinary-learning, or workflow-distillation leaves.
2. **Bug business input:** explicit user business meaning reaches Business Truth; Bug/code/test evidence cannot create desired truth.
3. **Verified failure:** a proven JDK / Mockito incompatibility returns one lifecycle outcome and activates prevention without loading Business Truth, Knowledge Reconciliation, or Workflow Distillation.
4. **Transient failure:** a one-off command mistake returns `transient/no-write` and creates no durable record.
5. **Ordinary Closure lesson:** an admitted non-failure lesson reaches Knowledge Reconciliation and does not load Business Truth or Workflow Distillation.
6. **Correction and retirement:** inaccurate content is corrected directly; an obsolete premise is retired or scoped legacy with consumer/link verification, without pretending the task is an AAR.
7. **Accepted workflow proposal:** two independently completed semantic instances plus user acceptance reach Workflow Distillation and return `extend`, pure `compose`, or `create` without loading the other execution owners.
8. **Ambiguous user request:** `记录一下` first uses the dispatcher and reaches exactly one execution owner after the smallest evidence-based classification.
9. **Missing activation:** a durable write with no action-changing future path fails regardless of structural green checks.
10. **Authority boundary:** no recording or workflow acceptance grants unlisted repository delivery, platform, database, promotion, or shared-system actions.
11. **Negative ownership:** removing a required direct caller link or a canonical branch definition fails validation; callers are not required to repeat the full procedure.
12. **Downstream assembly:** SBA source, Chaos meta adaptations, and installed `.codex` / `.claude` consumers are distinguishable; generated copies are current and not independent owners.

## Task Interfaces

### T1 - Materialize the shared contract and execution owners

- Files: `templates/skill/workflows/update-rules.md`, four new `templates/skill/workflows/rule-update/*.md` files.
- Consumes: D1-D9 and the four completed semantic source Plans named in Problem And Scope.
- Produces: one compact shared contract/dispatcher and four complete execution owners with no semantic loss.
- Acceptance: a before/after responsibility map accounts for every current heading and completion criterion; no branch meaning disappears or gains authority.

### T2 - Migrate canonical callers and operating contracts

- Files: task workflows that currently reference `update-rules.md`, `templates/skill/routing.yaml`, `templates/skill/SKILL.md.template`, `references/protocols.md`, and only the conformance/shell targets actually affected by changed links or route projections.
- Consumes: T1 final owner paths and direct-caller table.
- Produces: direct typed invocation, stable ambiguous entry, updated anchors, and local trigger/immediate-action/current-task-acceptance hooks.
- Acceptance: known callers do not redispatch; no caller copies a complete execution procedure; route summaries and generated surfaces remain synchronized.

### T3 - Prove semantic preservation and progressive loading

- Files: `templates/skill/conformance.yaml`, `references/self-hosting-conformance.yaml`, `scripts/check-self-scenarios.sh`, and temporary downstream fixtures only as required by existing test conventions.
- Consumes: T1-T2 source owners and the twelve Validation Journeys.
- Produces: positive owner tests, negative unrelated-load tests, broken-link/anchor detection, and before/after load evidence.
- Acceptance: targeted checks and full Bucket A closure pass; validation fails for missing owner semantics or activation and does not require unrelated leaves.

### T4 - Adapt the Chaos meta application Skills

- Files: canonical backend/frontend app-skill workflows, routing/entry/conformance consumers, and meta-owned assembly inputs under `~/.ai-infra/chaos/apps/`.
- Consumes: verified T1-T3 upstream contract plus current backend/frontend local adaptations.
- Produces: project-specific shared contracts and four owners for each admitted app capability, preserving cross-app/business/code-root semantics.
- Acceptance: each meta skill passes fitted conformance and load journeys; no installed/generated workspace copy is hand-edited as source.

### T5 - Assemble and verify authorized downstream consumers

- Files: generated aii workspace assets only; no business-source edit is implied.
- Consumes: verified Chaos meta commits and the repository-owned aii assembly path.
- Produces: current `.codex` / `.claude` copies and journey evidence from the named target workspace(s).
- Acceptance: generated copies match their meta owners, real journeys load only the shared contract plus the applicable owner, and unrelated dirty business edits remain intact.

T4-T5 require separate authorization for meta/downstream mutation and any commit, push, MR, or external delivery. The later `开始` and `下一步和我头脑风暴,如果没有了就去执行` instructions grant local meta adaptation and aii downstream assembly/verification for this Plan; they do not grant repository delivery or external actions.

## Risks And Controls

- **Semantic loss during extraction:** a current monolith section or checklist item is dropped. Control: heading-to-owner inventory plus branch-specific completion mapping before deletion.
- **Four new competing owners:** shared reconciliation/activation semantics are copied into every leaf. Control: one compact durable-write contract; leaves retain only input-specific admission, procedure, and outcome.
- **Extra read indirection:** every task reads dispatcher, shared contract, and leaf. Control: known callers enter the leaf directly; `update-rules.md` combines dispatcher and shared contract; no second index exists; Session reuse avoids rereading unchanged common content.
- **Anchor and conformance drift:** consumers still point at removed headings. Control: exact inbound-link inventory, atomic caller updates, negative conformance, and Markdown-link checks.
- **Nested path tooling gap:** routing/orphan/reachability scripts assume flat workflow paths. Control: prove current support before finalizing the physical move; repair generic path handling rather than flattening semantic ownership when the tooling is the defect.
- **Chaos adaptation overwritten by generic template:** project-specific Plan Leaf or business-owner semantics disappear. Control: adapt from current meta owners, not installed copies or blind whole-file replacement; compare branch-specific semantics before assembly.
- **Default downstream grows by four files:** every project receives all leaves. Control: this Plan defines Full-source owners; `default-downstream-simplification` independently admits only responsibilities supported by target evidence.

## Implementation Authorization

Granted for local implementation, Chaos backend/frontend meta adaptation, aii assembly into `/Users/shiqi/ai-infra-workspace/chaos-release-0.77_shiqi_bugfix`, and fitted local verification. The authorization is established by the later `开始` and `下一步和我头脑风暴,如果没有了就去执行` instructions after the Plan had no open normative question.

Not authorized: commit, push, MR, merge, deploy, publish, database mutation, work-item/version-revision mutation, or any other external/shared-system action.

## Implementation Evidence And Closure

### Canonical SBA source

- `templates/skill/workflows/update-rules.md` is now the compact shared durable-write contract plus ambiguous-request dispatcher. The complete Business Truth, Verified Failure, Knowledge Reconciliation, and Workflow Distillation procedures live in the four `templates/skill/workflows/rule-update/*.md` owners; no index, second routing manifest, Memory route/store, ledger, counter, timeline, mode, or user configuration was added.
- Known typed callers now link directly to their owner. Plan handoff, standalone modeling, Fix Bug business input, and business-leaf/Gotcha maintenance enter Business Truth; Task Execution and Fix Bug proven engineering failures enter Verified Failure; Closure ordinary lessons enter Knowledge Reconciliation; accepted post-Closure workflow proposals enter Workflow Distillation. Only ambiguous explicit recording requests use `update-rules.md` to select exactly one owner.
- Shared fidelity, authority, reconciliation, activation, placement, synchronization, and completion rules remain centralized. `maintain-docs.md` still exclusively owns full-file split/merge/index/load-reason and path-integrity work. Business Truth may point a proven engineering prevention to Verified Failure, but no execution leaf imports another leaf as a normal prerequisite.
- Canonical validation passed after the final semantic source edits: self scenarios `503 passed, 0 failed`; template conformance `541 passed, 0 failed`; self-hosting conformance `391 passed, 0 failed`; routing/shell synchronization, orphan, reachability, Markdown-link, and `git diff --check` gates passed. `bash scripts/check-all.sh --base HEAD` exited `0` with `All upstream maintenance checks passed.`

### Chaos canonical meta adaptations

- Backend and frontend app skills preserve their two-root `skill:` / `code:` semantics, Plan Leaf Reconciliation, unique business owner, legacy PK migration, Knowledge Impact / Requirement Provenance, frontend cross-app and database-owner boundaries, canonical provenance, assembly, promotion, and unchanged delivery/platform authority.
- Backend canonical checks passed: conformance `798/0`, smoke `54/0`, orphan `0/36`, reachability `0/37`, routing sync/check, clean route health for `11` task routes plus `11` domain overlays, and `git diff --check`.
- Frontend canonical checks passed: conformance `758/0`, smoke `52/0`, orphan `0/38`, reachability `0/38`, routing sync/check, clean route health for `10` task routes plus `11` domain overlays, and `git diff --check`.

### aii assembly and downstream proof

- The repository-owned command `aii update release-0.77_shiqi_bugfix --no-pull --no-self-upgrade` consumed the local dirty canonical meta clone, force-rendered the named iteration, refreshed `chaos` and `chaos-web` app skills in `.codex` and `.claude`, and avoided both product-asset pull and unrelated CLI upgrade.
- Recursive comparison proves each installed backend/frontend tree is byte-equal to its canonical meta owner and each `.codex` tree is byte-equal to its `.claude` peer. `aii status` reports `chaos@app`, `chaos-web@app`, and all six other installed skills current for `chaos-release-0.77_shiqi_bugfix`, with `一致，无告警`.
- From all four installed skill roots, workspace-aware routing, smoke, conformance, orphan, reachability, and route-health checks passed. This closes code-root and cross-owner target verification rather than relying only on source-tree structural checks.
- Downstream business repositories were preserved exactly. Backend remained on `release-0.77_shiqi_bugfix` at `b4defb450032a169206c2604fcdc068ae91bea1b`, with unchanged status hash `17041f4d0aec42088065ea867d42014cd4c635bee1ba31819bb16134523e377b`, whole binary diff hash `9de8bac9b4c824ef79e1aaa424f159a0c5679fad9ae62d254dfe1d3b4fcac114`, and empty staged/unmerged streams. Frontend remained on the same branch at `d80229569c7d234ed490e1a9972e89aff99c454a`, with unchanged status hash `e280b8e6788132c7941715b37fcb416dca78009ac9a5f64e1f85a3c2f356798f`, whole binary diff hash `7d88d291fda1bdb47ebb2abaf45e3bfa53294a5df06e678ce5f2ad563ff33131`, and empty staged/unmerged streams.

### Progressive-load evidence

Sizes remain diagnostic evidence, not correctness gates:

| Installed journey | Before monolith | After shared + typed owner |
|---|---:|---:|
| backend Business Truth | 23,521 bytes | 11,286 bytes |
| backend Verified Failure | 23,521 bytes | 9,171 bytes |
| backend Knowledge Reconciliation | 23,521 bytes | 8,970 bytes |
| backend Workflow Distillation | 23,521 bytes | 8,977 bytes |
| frontend Business Truth | 22,608 bytes | 11,729 bytes |
| frontend Verified Failure | 22,608 bytes | 9,354 bytes |
| frontend Knowledge Reconciliation | 22,608 bytes | 9,153 bytes |
| frontend Workflow Distillation | 22,608 bytes | 9,160 bytes |

The reduction is accepted because the caller traces and negative conformance prove that each normal journey stops loading unrelated branch procedures while retaining the same owner, evidence, authority, activation, synchronization, and completion decisions.

### Verified failures and AAR

- A guessed self-hosting rule path and an incorrect `required_files` patch anchor both failed without writes; discovered paths/sections were used for the next action. They are `transient/no-write` outcomes and introduced no durable mechanism.
- The first conformance invocation omitted the documented skill-root argument. The existing app `update-upstream.md` already contains the exact command and installed-root rule; rereading that owner corrected the invocation and all fitted checks passed. This is `covered/no-write`, not a reason to duplicate the command contract.
- A stale-anchor search repeated the known shell-backtick execution failure. The root cause and repair are proven: executable backticks inside a double-quoted shell command were replaced with a single-quoted regex containing no executable substitution, and the repaired search returned no stale anchors. Stronger automatic enforcement belongs to the personal/global command-execution layer outside this Plan's authorized SBA/meta/downstream surfaces, so the lifecycle outcome is `requires-user-authority`; no out-of-scope hook, linter, Memory subsystem, or shared gate was added.
- Final AAR found no additional unowned project lesson. The plan's core repeatable problem is already absorbed by the shared contract, four typed owners, direct caller activation, conformance, and installed consumer verification.
- Final fresh Bucket A rerun after Plan evidence reconciliation passed: `bash scripts/check-all.sh --base HEAD` exited `0` and ended with `All upstream maintenance checks passed.` The suite again reported self scenarios `503/0`, template conformance `541/0`, self-hosting conformance `391/0`, synchronized shells/routing, and zero scaffold orphan/reachability failures.

## Open Questions

None. Local implementation, canonical meta adaptation, authorized aii assembly, fitted downstream verification, evidence reconciliation, and Bucket A Closure are complete. The Plan is frozen as `done`. Commit, push, MR, merge, deploy, publish, database, platform, and other external/shared-system actions remain unauthorized.
