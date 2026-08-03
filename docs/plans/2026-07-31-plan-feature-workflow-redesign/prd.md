---
date: 2026-07-31
status: done
distilled_to:
  - templates/skill/workflows/plan-feature.md
  - templates/skill/workflows/plan-large.md
  - docs/plans/README.md
  - docs/plans/_TEMPLATE.md
  - docs/sba-bible.md
  - templates/skill/conformance.yaml
  - references/self-hosting-conformance.yaml
  - scripts/check-self-scenarios.sh
  - UPSTREAM-CHANGES.md
---

# Plan Feature Workflow Redesign

> Current conclusion: make a durable Plan a precise requirement/design and implementation-review contract. Keep the visible artifact shape simple, but require each load-bearing design question to close evidence, decision, impact/risk, and proof before handoff.

## Context

The current `plan-feature` workflow can produce formally complete but weak Plans. The representative downstream PRD `2026-07-29-rdbms-sql-reference-version/prd.md` contains real user-confirmed business meaning, yet implementation evidence, owner boundaries, consumer paths, risk treatment, and acceptance proof remain incomplete. Repeated Decision Context blocks and canonical sections occupy more space than the design facts needed by implementers and reviewers.

The failure is not solved by a fixed token, line, file, section, or question budget. It is also not solved by pre-creating requirement, architecture, domain, database, risk, test, and rollout files. The redesigned workflow must cover the dimensions that evidence activates while keeping physically inseparable content together.

## Problem

- A durable `prd.md` is created before enough implementation evidence exists, so it becomes the scratchpad for an evolving conversation.
- The Plan is asked to preserve full provenance and simultaneously act as the current implementation contract; history obscures the mainline.
- Visible format requirements are more concrete than evidence outputs, so an Agent can fill sections without closing the real code/data/state flow.
- User-confirmed business meaning and Agent-derived field/table/class choices can be recorded under the same authority.
- Complex work can retain stale Open Questions, placeholder Task Breakdown, non-observable acceptance, and artificial alternatives.
- Scope expansion does not force complexity, title, artifact, owner, and risk re-evaluation.
- Current structural conformance can prove that workflow phrases exist but cannot prove that generated Plans are useful.

## Confirmed Mainline

### D-001 - Plan is a current contract, not a transcript

- **User signal:** the desired result is neither “特别全的流水账” nor “特别简单的目录”.
- **Decision:** keep the current requirement/design mainline primary. Preserve provenance only when it changes or explains a load-bearing decision.
- **Consequence:** repeated question/answer metadata no longer dominates `prd.md`; superseded or disputed history remains compact and secondary.

### D-002 - Logical dimensions do not imply one file per dimension

- **User signal:** requirements, solution, models, database, domain, deltas, consistency, performance, and concurrency must be addressed when relevant, but ten tiny files are not useful.
- **Decision:** select design dimensions by evidence; extract a physical file only for an independent decision, consumer, review, lifecycle, or loading reason.
- **Consequence:** related dimensions stay in the current inline or durable carrier until real pressure justifies extraction.

### D-003 - Default runtime stays inline

- **Decision:** no artifact is the default. When pressure creates a durable carrier, use either one dated Plan file or a named dossier with `prd.md` according to its real aggregation/archive job. `design.md` is one possible sibling, not a default consequence of technical complexity.
- **Consequence:** domain, database, contracts, risks, tests, rollout, and even `prd.md` / `design.md` are pressure-triggered owners rather than a mandatory dossier schema.

### D-004 - One load-bearing question is closed at a time

- **User signal:** the specification should “精准的切入多个不同维度”, and each matter should have a clear goal.
- **Decision:** use an internal Design Slice check: `question -> current evidence -> decision -> impact/risk -> proof`.
- **Consequence:** Design Slice is a reasoning/readiness unit, not a visible fixed form and not automatically a file.

### D-005 - Change, impact, risk, and user authority become conditionally visible

- **Decision:** show a Change Map when current owners/models change, an Impact Map when semantics fan out, Risk Scenarios when evidence activates material failure modes, and a compact Decision Trace when a user answer defines or changes normative meaning.
- **Consequence:** transient tool failures, routine acknowledgements, and facts already proved by code do not enter durable Decision Trace.

### D-006 - Load-bearing structure cannot be compressed away

- **Decision:** when applicable, preserve ownership, state transitions, read/write and lifecycle paths, transaction/consistency boundaries, cardinality/uniqueness, failure/recovery, concurrency, performance, migration, compatibility, and semantic consumers.
- **Consequence:** brevity is valid only after a downstream reader can reconstruct the behavior and its failure boundary.

### D-007 - External simplicity, internal rigor

- **User signal:** “我也不希望太复杂”.
- **Decision:** keep workflow-visible artifacts and headings minimal. Put conditional detail in the existing Large extension rather than expanding every Plan.
- **Consequence:** no universal software-design standard, mandatory risk ledger, or fixed multi-file template is added.

### D-008 - Durable artifacts are created only under real pressure

- **User signal:** files should be created only when analysis discovers a module conflict or another issue that needs an independent carrier, not at the start of planning.
- **Decision:** complexity changes analysis depth, never materialization timing. Start in the conversation and harness-native Plan; create the first durable artifact only when the user explicitly requests it or evidence reveals a persistence, independent-consumer, review, validation, lifecycle, or handoff pressure that cannot be served well inline.
- **Consequence:** no complexity class pre-creates `prd.md`, `design.md`, or sibling files. When pressure appears, create the smallest artifact that owns the current need; add siblings later only under their own independently demonstrated pressure.

## Chosen Direction

Redesign planning as a staged, reversible flow:

1. Establish the request, current decision pressure, and tentative complexity without creating ceremony.
2. Inspect the smallest evidence that can state the real problem, current owner/flow, and gap.
3. Select only the design dimensions activated by that evidence.
4. Close one load-bearing Design Slice at a time; ask one normative question only after current facts are closed.
5. When analysis exposes real persistence or consumption pressure, materialize the smallest useful artifact and progressively enrich it; create `design.md` or later siblings only when each has an independent reason.
6. Reconcile scope, authority, decisions, artifacts, Open Questions, acceptance, risks, and task interfaces before declaring Plan Ready.
7. Handoff only the current mainline, exact evidence, boundaries, proof, and executable tasks to Task Execution.

Detailed mechanics, repository change surfaces, risks, validation, and the implementation breakdown live in [design.md](design.md). That sibling remains justified because implementation and review consume its cross-owner workflow, archive, conformance, and proof contract independently; it is not a default Plan shape.

## Requirements & Acceptance Criteria

- **R1 - Evidence before formal completeness:** the workflow cannot treat a created Plan file or filled section list as planning progress without decision-relevant evidence.
- **R2 - Precise current/target delta:** every changed owner, model, state, contract, or lifecycle path states Current -> Target and classifies reuse, extension, new owner, replacement, or removal.
- **R3 - Conditional impact:** shared/module-wide changes identify semantic upstream/downstream consumers and lifecycle effects rather than listing files alone.
- **R4 - Conditional risk:** activated consistency, concurrency, performance, migration, dependency, permission, or recovery risks state scenario, invariant, failure, mechanism, boundary, recovery, and proof.
- **R5 - Authority separation:** a user answer is distinguishable from Agent-derived consequences and implementation design.
- **R6 - No stale mainline:** resolved questions leave Open Questions; superseded decisions cannot remain active in Chosen Approach, acceptance, or tasks.
- **R7 - Real alternatives only:** alternatives appear only when a genuine unresolved choice or load-bearing rejection exists.
- **R8 - Late executable decomposition:** Task Breakdown is omitted until the design is stable enough to declare Files, Consumes, Produces, and observable Acceptance.
- **R9 - Pressure-triggered artifacts:** no complexity class creates a file by itself. The first durable artifact and every later sibling require an explicit request or independent persistence, consumer, review, validation, lifecycle, or handoff pressure; related content stays together and conclusions are not duplicated.
- **R10 - Scope reclassification:** evidence that expands the change to new subsystems, irreversible migration, or additional owners re-runs complexity and artifact selection.
- **R11 - Behavioral validation:** validation includes raw-prompt forward tests and semantic review, not only phrase-presence conformance.
- **R12 - Downstream usability:** an implementer can locate the intended owners and behavior without replaying the conversation; a reviewer can identify major failure modes and their proof.
- **R13 - Bounded evidence expansion:** each Design Slice stops reading once its current question is resolved/falsified or the next semantic owner is identified; suspected consumers and risks remain candidates until a later decision actually needs them.
- **R14 - Progressive user checkpoint:** interactive Complex/Large planning discusses the first user-owned normative choice or high-impact assumption before opening unrelated Design Slices; autonomous end-to-end expansion requires an explicit artifact-only or no-checkpoint request.
- **R15 - Active-Plan recovery:** when a Plan already has multiple Open Questions, resume from the highest-impact unresolved decision, load only its fitted evidence, and leave other questions/evidence paths unopened until their turn.
- **R16 - Deliverable classification:** requests to explain planning, review an existing Plan, or brainstorm direction remain read-only advisory work with representative evidence; only an explicit request to draft/update/complete the concrete Plan activates full Design-Slice closure and materialization decisions.

## Out of Scope

- A fixed enterprise software-design-document standard.
- Mandatory `domain-model.md`, `database.md`, `risks.md`, `test-plan.md`, or `rollout.md` files.
- Fixed word, token, file, section, question, or risk-count correctness thresholds.
- Recording every command, investigation branch, rejected thought, or user acknowledgement.
- A new planning runtime, database, scoring engine, or cross-session state machine.
- Modifying the Chaos business implementation or the weak downstream reference-version PRD in this upstream workflow task.

## Open Questions

None. The materialization boundary is confirmed by D-008.

## Implementation Status

Implemented and reconciled across the canonical workflows, Plan archive/template, Bible, conformance manifests, self-scenarios, and downstream refresh guidance.

- The Artifact Pressure Gate is evaluated as analysis progresses. No project Plan file exists while pressure is unproved; when evidence exposes a real persistence, reconciliation, consumption, review, validation, lifecycle, or handoff need, only the smallest current owner is created.
- Raw Simple and Large advisory scenarios stayed inline. The final reference-version advisory rerun stopped after representative evidence, surfaced one load-bearing user decision, and created no downstream artifact.
- `bash scripts/check-all.sh --base HEAD` completed with exit code 0 after the implementation and semantic corrections. Post-status checks passed: self-scenarios `332/332`, template conformance `366/366`, self-hosting conformance `228/228`, and `git diff --check`.
- The AAR found no additional owner to create: the repeatable planning failures and their activation path are already reconciled in the workflow, Bible, archive contract, conformance, scenarios, and `UPSTREAM-CHANGES.md`.

No commit, push, MR, or downstream business-workspace mutation is part of this task.
