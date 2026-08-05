---
date: 2026-08-04
status: done
distilled_to:
  - docs/sba-bible.md
  - templates/skill/workflows/task-closure.md
  - templates/skill/workflows/update-rules.md
  - references/protocols.md
  - templates/skill/conformance.yaml
  - references/self-hosting-conformance.yaml
  - scripts/check-self-scenarios.sh
  - UPSTREAM-CHANGES.md
---

# Plan: Proactive Workflow Distillation

> Current conclusion: after a requested task and its real delivery artifacts are verified, the Agent should recognize evidence-backed repetition of an independently reusable procedure, distill its stable contract and ownership, and ask once whether to persist the recommended workflow change without auto-creating a candidate store or inheriting external-operation authority.

## Problem And Scope

SBA records proven failures and completion-time lessons, but it does not currently require the Agent to notice when a complete multi-step procedure has been independently executed more than once. The user must recognize the repetition, reconstruct the relations among steps, decide whether an existing workflow should be extended or a new orchestration owner created, and explicitly request the durable change.

Task `019fc597-a624-7050-b4a1-95d6207cc80f` provides organic pressure. The repeated delivery shape included selective staging, backend/frontend commits, push, Codeup requirement or defect creation, version-revision association, reviewer selection, merge-request creation, and authoritative MR readback. The useful candidate is not a list of repeated Git commands. It is the stable relation among code artifacts, external work items, version scope, reviewer authority, merge artifacts, and integrated delivery acceptance.

This Plan defines proactive workflow-distillation detection, evidence, classification, proposal, consent, source ownership, downstream consumption, suppression, and validation. It does not automatically create a workflow, scan all task history at every Closure, create a workflow-signature database, persist rejected candidates, or create new commit/push/MR/deploy/database/platform authority.

This Plan is independent from `docs/plans/2026-08-04-failure-driven-long-term-memory.md` and `docs/plans/2026-08-04-default-downstream-simplification/prd.md`. Failure-driven learning writes the first proven actionable prevention directly to its canonical owner; proactive workflow distillation requires repeated independently completed procedure evidence plus user consent. The downstream-simplification Plan can independently complete and freeze without this capability.

No database-structure change is involved.

## Pre-Implementation Evidence Baseline

- `templates/skill/workflows/task-closure.md` already owns verified completion, AAR, external-artifact readback, and the distinction between `Ready for Delivery` and `Closure Complete`. It has no proactive repeated-procedure proposal contract.
- `templates/skill/workflows/update-rules.md` already classifies ordered task procedures into `workflows/` and owns reconciliation, activation, durability, and authority. It has no accepted workflow-candidate input or canonical-source-to-downstream activation contract.
- `references/skill-composition.md` already distinguishes embedded invocation, serial route handoff, and subagent delegation. A stable combination does not automatically require a wrapper workflow.
- `templates/skill/workflows/maintain-docs.md` already owns split/merge and repeated-body health after a durable change is admitted. It is not a runtime usage monitor.
- `references/progressive-rigor.md` admits recurring step-by-step procedure pressure while `templates/ANTI-TEMPLATES.md` rejects project-specific prefilled template workflows.
- The current Chaos release workspace resolves `devops-version 0.1.36` as `origin: market` into both `.codex` and `.claude`. That installed Skill already owns version revision, work-item association, reviewer-aware code MR creation, and authoritative readback subflows. The example pressure is missing end-to-end orchestration, not missing sub-procedures or a reason to copy a complete workflow into both Chaos app Skills.

## Current Decisions

### D1 - Repetition requires two independently completed semantic instances

Eligibility begins only when the Agent can recover at least two independently completed instances of the same workflow contract. The instances may occur inside one task, across tasks, or across Sessions; task/thread identity is not part of workflow identity. Retries, repeated commands, and repeated substeps inside one unfinished delivery count as one instance.

- Trigger: the Agent proposed two independently completed instances as the minimum non-arbitrary evidence of repetition.
- Faithful answer: the user confirmed and explained that repeated executions may contain meaningful associations that the Agent must extract.
- Authority: user-confirmed.
- Agent-derived consequence: backend/frontend branches inside one integrated delivery are not automatically two instances; separately completed batches with their own inputs, outputs, and acceptance may be.
- Evidence / Source: current conversation and the user-linked historical task.

### D2 - Distill contract relations, not command similarity

Only evidence-backed relations enter the normalized candidate: one stage produces an input consumed by another, establishes a necessary prerequisite/order, participates in one integrated acceptance result, or owns an explicit authority checkpoint. Temporal adjacency, similar commands, the same tool, or frequent co-occurrence is insufficient.

- Variable values such as version, branch, repository, reviewer, product, work-item ID, and tenant Session remain runtime parameters.
- A non-universal step becomes a conditional branch only when its applicability condition is known. Otherwise it remains unresolved evidence.
- Authority: user-confirmed.
- Evidence / Source: current conversation; pushed branch -> MR input, work-item/version association, reviewer confirmation, and MR readback in the named task.

### D3 - The Agent recommends extend, compose, or create

The Agent inspects the routed workflow graph and presents one evidence-backed recommendation instead of asking the user to choose an abstract storage shape.

- `extend`: an existing workflow already owns the same reusable result and acceptance but lacks stages, parameters, branches, authority checks, or proof.
- `compose`: complete existing owners can express the sequence without a new cross-step state, decision, authorization, route/hook gap, or integrated-acceptance owner.
- `create`: the repeated combination has an independently reusable goal, inputs/outputs, cross-step dependencies or decisions, authority checkpoints, and integrated acceptance that no existing workflow owns.
- Pure `compose` with no durable gap produces no persistence proposal. A needed route or local trigger is an `extend` gap rather than pure composition.
- Authority: user-confirmed.
- Evidence / Source: current conversation; existing Skill Composition and workflow-maintenance owners.

### D4 - Ask only after verified completion, with the result first

Candidate detection and normalization may use execution evidence, but the optional proposal is shown only after the current requested result and every requested external artifact are verified. The completion report comes first. The proposal is not a Task Closure gate and cannot interrupt implementation, commit, push, work-item creation, version association, reviewer selection, MR creation, artifact readback, or blocker recovery.

- Blocked, paused, stopped, or unverified tasks do not trigger the question by default.
- An explicit user switch to retrospective or workflow design may discuss the candidate immediately.
- Authority: user-confirmed.
- Evidence / Source: current conversation; Task Closure delivery/completion contract.

### D5 - Decline and defer create no durable candidate state

`No` or `not now` creates no candidate file, rejection record, counter, timestamp, route, or workflow artifact. The same normalized proposal is suppressed for the remainder of the current Session. Another completion boundary or rewording is not new evidence.

A later proactive question requires materially stronger evidence: another independently completed instance, a newly proven relation/branch/authority checkpoint/integrated acceptance/user cost, a changed owner recommendation, or explicit user reopening. A lasting personal preference such as `never proactively ask about workflows` uses the existing personal-preference memory path only when the user explicitly requests that durability.

- Authority: user-confirmed.
- Evidence / Source: current conversation.

### D6 - Downstream consumption is mandatory; canonical source follows provenance

Every accepted workflow must be directly consumable in the affected downstream repository. The canonical mutation may belong in that downstream, a product meta-repository, or another package/market source depending on the repository's real generation and maintenance graph.

- Directly owned downstream workflow: edit and verify downstream.
- Meta-generated workflow: edit canonical meta source, assemble through the repository-owned path, and verify downstream.
- Market/package-installed workflow: edit its canonical maintenance source, reinstall, and verify every downstream harness surface.
- A canonical-source-only change without downstream consumption is incomplete. Independently editing canonical and generated/installed copies creates multiple owners and is forbidden.
- The proposal names `canonical owner -> downstream consumer` when the surfaces differ.
- Authority: user-confirmed correction: the workflow must be written to downstream, while some repositories may require writing the meta source.
- Evidence / Source: current conversation; Chaos `.ai-infra.yaml`, `skills.yaml`, and release `.ai-infra.lock`.

### D7 - Cross-repository behavior has one complete orchestration owner

One coordinating Skill owns the complete cross-repository workflow, selected from the real execution entry, cross-step state, authority checkpoints, and integrated acceptance. Other repository-local Skills keep only evidence-required trigger, participation, or acceptance hooks and do not copy the complete body.

The canonical owner must be installed or assembled and verified in every actual downstream consumer. For the named example, current evidence points to `devops-version` as the candidate owner because it already owns the version revision, work-item association, reviewer-aware MR, and authoritative readback subflows. Locating and modifying its market maintenance source would belong to a separately accepted concrete workflow task, not automatic execution of this Plan.

- Authority: user-confirmed.
- Evidence / Source: current conversation; current Chaos meta and release installed-skill evidence.

### D8 - Cross-task discovery is progressive and evidence-backed

Same-Session detection uses execution history already in context. Cross-task detection may use relevant harness memory/task history already retrieved for the current task, a user-provided task/thread link, routed Plan/Closure provenance, existing workflow/rule evidence, or a targeted lookup prompted by a plausible semantic match.

The Agent normalizes the current completed flow, identifies a plausible prior-match signal, and retrieves only the smallest history needed to prove or falsify a second completed instance. It does not scan every historical task at every Closure and does not create a signature database, candidate ledger, usage counter, timeline, or new Always Read archive. If the second instance cannot be recovered and verified, the Agent does not claim repetition.

- Authority: user-confirmed.
- Evidence / Source: current conversation and targeted recovery of the user-linked historical task.

### D9 - The proposal is compact, concrete, and directly actionable

The optional follow-up contains only the smallest information needed for informed consent:

- concrete independently completed repeat evidence;
- one compact normalized goal and ordered skeleton;
- the Agent's single `extend` or `create` recommendation, or no proposal for pure composition;
- canonical source and affected downstream consumers;
- important runtime parameters, conditional branches, and authority boundaries;
- one direct consent question.

It does not dump a full draft workflow, exhaustive history, internal matching/retrieval details, scoring, layout alternatives, or an implementation checklist. An affirmative response such as `yes`, `可以`, or `做` authorizes the described workflow mutation as a newly routed task. The Agent does not ask for a redundant second start confirmation; a newly discovered normative ambiguity or separately scoped external delivery action retains its own authority checkpoint.

- Authority: user-confirmed.
- Evidence / Source: current conversation.

### D10 - Existing lifecycle owners compose the capability

No new route, candidate-management workflow, store, database, counter, timeline, or default Always Read surface is created.

- SBA Bible owns the stable product principle.
- Task Closure owns post-completion detection, evidence normalization, timing, Session suppression, and proposal presentation.
- Rule Update owns accepted `extend`/`create` reconciliation, canonical source, single semantic ownership, activation, downstream consumption, and durability.
- Skill Composition and Documentation Maintenance retain their complete existing ownership for composition and split/merge health.
- Protocols, conformance, and self-scenarios preserve discoverability, unique ownership, and behavior.
- Authority: user-confirmed.
- Evidence / Source: current conversation; current owner contracts.

## Requirements And Acceptance

- At least two independently completed semantic instances are required before a proactive proposal.
- A candidate is identified by shared goal, ordered stages, input/output contract, authority checkpoints, and integrated acceptance rather than command text or task identity.
- Retries and repeated substeps inside one unfinished instance count once.
- Variable values remain runtime inputs; conditional branches require a proven applicability condition.
- The Agent searches existing owners and produces one `extend`, `compose`, or `create` conclusion without delegating technical ownership discovery to the user.
- Pure composition with no missing owner, route, hook, state, or acceptance produces no persistence proposal.
- A proactive question is presented only after the completion report and verified requested artifacts; active, blocked, paused, stopped, or unverified tasks do not trigger it by default.
- Decline/defer creates no durable candidate state and suppresses the same Session proposal.
- Re-prompt requires materially stronger evidence or explicit user reopening.
- Cross-task evidence uses current/relevant history and targeted retrieval; it never requires exhaustive history scanning or a new tracking subsystem.
- The proposal contains repeat evidence, compact contract, one recommendation, source-to-downstream path, parameter/authority boundaries, and one consent question.
- Acceptance starts a newly routed workflow-maintenance task without a redundant second start question.
- Acceptance authorizes only the described workflow mutation and required local verification. Commit, push, MR, deploy, publish, database, work-item, version-revision, reviewer-selection, merge, and other external actions require explicit inclusion or separate authorization.
- One complete orchestration owner exists across repositories. Local consumers keep only necessary hooks.
- Generated or installed downstream copies are never independent semantic owners.
- A canonical mutation is incomplete until every affected downstream consumer is installed/assembled and verified.
- No database-structure change is involved.

## Current To Target Design

| Surface | Current | Target |
|---|---|---|
| Completion AAR | Finds recordable rules and failures but not repeated complete procedures | Detects a possible repeated procedure, proves semantic instances, and defers the optional proposal until after verified completion |
| Repeat identity | No reusable procedure identity contract | Same goal + ordered relations + inputs/outputs + authority + integrated acceptance; retries remain one instance |
| Cross-task evidence | Ad hoc user recall or broad search | Current/relevant history first, then targeted retrieval from a plausible signal; no exhaustive scan/store |
| Classification | User may ask for a new workflow before owner analysis | Agent recommends extend/compose/create after inspecting current owners |
| User interaction | User must notice and author the request | Agent presents one compact evidence-backed proposal after completion |
| Refusal | No defined suppression/re-prompt behavior | No durable rejection; Session suppression; materially stronger evidence required to revisit |
| Persistence | Workflow edits may target a visible generated copy | Canonical source follows provenance and must be consumed/verified downstream |
| Cross-repository flow | Risk of complete copies in each app/repository | One orchestration owner plus thin local hooks |
| Authority | Workflow discovery may blur with delivery actions | Proposal and acceptance never inherit unlisted external-operation authority |

## Risks And Controls

- **False repetition:** similar commands are merged despite different goals. Control: D1-D2 semantic identity and completed-instance proof.
- **User interruption:** optional improvement blocks the requested delivery. Control: D4 result-first post-completion timing.
- **History cost/privacy:** every Closure scans all tasks. Control: D8 progressive targeted retrieval and no store.
- **Prompt fatigue:** the same rejected candidate is repeatedly proposed. Control: D5 Session suppression and materially stronger re-prompt evidence.
- **Workflow proliferation:** every stable combination creates a wrapper. Control: D3 pure-composition no-proposal boundary and existing composition owner.
- **Duplicate ownership:** backend, frontend, meta, and installed Skill each copy the complete flow. Control: D6-D7 canonical provenance, one orchestration owner, and downstream equality/activation proof.
- **Generated-copy drift:** installed copies are hand-edited. Control: canonical-source resolution before mutation and source-to-consumer verification.
- **Authority leakage:** user acceptance triggers commit, MR, version writes, or deployment. Control: D9 scoped proposal plus unchanged Closure/permission boundaries.
- **Inert workflow:** the file exists but future tasks do not reach it. Control: Rule Update activation proof, fitted routes/hooks, and downstream behavior scenarios.
- **New subsystem creep:** a candidate ledger or signature database appears for convenience. Control: D5, D8, D10 and conformance prohibitions.

## Task Interfaces

### T1 - Add the product principle and post-completion proposal owner

- Files: `docs/sba-bible.md`, `templates/skill/workflows/task-closure.md`.
- Consumes: D1-D5, D8-D9; current Task Closure delivery and AAR contract.
- Produces: stable product principle; repeated-procedure evidence/normalization boundary; result-first post-completion proposal; Session suppression and re-prompt rules.
- Acceptance: proposal cannot block Closure or appear before artifact verification; retries/similarity do not qualify; no candidate persistence exists.

### T2 - Add the accepted-candidate reconciliation path

- Files: `templates/skill/workflows/update-rules.md`; existing `references/skill-composition.md` and `templates/skill/workflows/maintain-docs.md` are consumed and edited only if a proven missing hook exists.
- Consumes: D3, D6-D7, D9-D10 and an accepted scoped proposal.
- Produces: extend/create admission; pure-composition no-proposal outcome; canonical owner and source-to-downstream activation; single complete orchestration ownership.
- Acceptance: the user is not asked to choose technical storage; generated copies are not owners; accepted scope does not expand external authority.

### T3 - Preserve operating discoverability and unique ownership

- Files: `references/protocols.md`, `templates/skill/conformance.yaml`, `references/self-hosting-conformance.yaml`.
- Consumes: T1-T2 final owner wording.
- Produces: compact operating summary, required owner assertions, anti-duplication and no-subsystem constraints.
- Acceptance: checks fail if Closure loses proposal timing ownership, Rule Update loses persistence ownership, consumers copy the complete procedure, or a new route/store is introduced.

### T4 - Add behavior scenarios and full verification

- Files: `scripts/check-self-scenarios.sh`, `UPSTREAM-CHANGES.md`, this Plan at final reconciliation.
- Consumes: T1-T3.
- Produces: transcript-shaped positive/negative scenarios, downstream adaptation guidance, fresh Bucket A evidence, and truthful lifecycle reconciliation.
- Acceptance: targeted scenarios and `bash scripts/check-all.sh --base HEAD` pass; no unrelated dirty files are staged, reverted, or overwritten; no downstream repository, market package, commit, push, MR, deploy, database, or external operation is inferred without separate authorization.

## Validation Scenarios

1. **Same-Session positive:** two independently completed equivalent flows produce one proposal after the second completion report.
2. **Cross-task positive:** a plausible signal triggers targeted retrieval of one prior completed task; the proposal cites both recovered instances.
3. **Retry negative:** repeated attempts inside one unfinished delivery count once and produce no proposal.
4. **Similarity negative:** adjacent/high-frequency steps with different goal, authority, or acceptance do not form one candidate.
5. **Extend classification:** an existing workflow with the same result/acceptance but missing a stable step yields one extend proposal.
6. **Create classification:** independently reusable cross-step orchestration with new integrated acceptance yields one create proposal.
7. **Pure composition:** complete existing subflows with no route/hook/state/acceptance gap produce no persistence question.
8. **Timing:** active, blocked, paused, stopped, or unverified delivery receives no proposal; completion is reported first.
9. **Decline:** refusal creates no artifact and suppresses the same Session proposal.
10. **Re-prompt:** only materially stronger evidence, changed ownership, or explicit reopening permits another question.
11. **Cross-repository ownership:** one complete orchestration owner plus thin hooks passes; duplicated complete bodies fail.
12. **Canonical/downstream:** canonical-only mutation without install/assembly/readback fails; direct generated-copy mutation fails.
13. **Proposal payload:** evidence, compact contract, one recommendation, source/consumer path, and authority boundary are present; a vague `create a workflow?` question fails.
14. **Acceptance transition:** affirmative consent starts the scoped maintenance task without a redundant start question.
15. **Authority:** workflow acceptance never grants unlisted commit, push, MR, deploy, database, work-item, revision, reviewer, publish, or merge actions.
16. **No subsystem:** routing and required files contain no candidate workflow, ledger, signature database, usage counter, timestamp log, or new Always Read item.

## Implementation Authorization

Granted. After reviewing the complete reconciled Plan, the user explicitly authorized implementation with `开始`. This authorization covers only the Plan's SBA source files and local verification. It does not authorize downstream/meta/market adaptation, commit, push, MR, deploy, database, work-item, version-revision, reviewer, publish, merge, or other external actions.

## Implementation Evidence And Closure

- Bible principle 14 now owns the stable product rule: two independently completed semantic instances, result-first post-Closure proposal timing, pure-composition silence, consent before persistence, canonical-to-downstream completion, one cross-repository orchestration owner, and unchanged external authority.
- `task-closure.md` owns execution-time normalization plus post-`Closure Complete` proposal timing, targeted history retrieval, evidence identity, suppression/re-prompt behavior, compact proposal payload, and the accepted-task handoff. It creates no candidate state and does not make the optional question a completion gate.
- `update-rules.md` owns the accepted input and returns `extend`, pure `compose`, or `create`; it treats the accepted proposal as the scoped upgrade plan, resolves downstream/meta/package provenance, mutates only the canonical owner, requires assembly/install plus downstream verification, and preserves every delivery/shared-system authority boundary.
- `references/protocols.md`, both conformance manifests, sixteen transcript-shaped self-scenarios, and `UPSTREAM-CHANGES.md` preserve operating discoverability, reciprocal owner boundaries, downstream adaptation, and the no-route/store/Always-Read contract.
- Targeted verification passed after final semantic edits: self-scenarios `486/486`, downstream template conformance `507/507`, self-hosting conformance `355/355`, and `git diff --check`.
- Full Bucket A verification passed: `bash scripts/check-all.sh --base HEAD` ended with `All upstream maintenance checks passed` and exit code `0` after the final owner, conformance, scenario, and upstream-refresh edits.
- Two continuation-time multi-ledger patches assumed that a progress-only bullet also existed in findings. Both `apply_patch` calls failed atomically and changed no file. The second occurrence disproved `covered/no-write`; current execution now reads and patches each ledger independently. A durable generic prevention belongs to the external personal planning/editing owner, so the lifecycle outcome is `requires-user-authority` rather than an out-of-scope SBA rule mutation.
- Final AAR found no additional unowned SBA lesson. No route, candidate workflow, ledger, signature database, counter, timeline, default Always Read item, downstream/meta/market mutation, personal planning-skill mutation, commit, push, MR, deploy, database write, work-item, version revision, reviewer action, publish, merge, personal/team promotion, or other external operation was created or inferred.

## Open Questions

None.
