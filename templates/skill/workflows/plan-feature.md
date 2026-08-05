# Plan Feature Workflow

> **Inline by default.** This workflow resolves what should be done; it is not the runtime Native Plan. Use it for feature/design planning and admitted implementation-gap intake. Standalone business modeling stays in `profile-business-model.md` when installed.

When this repository selects self-hosting `product-direction`, read `docs/sba-bible.md` and `docs/plans/README.md`. Ordinary downstream planning never loads the SBA Bible. Read a local Plan archive contract only when the Artifact Pressure Gate admits a durable Plan.

## Deliverable Gate

First distinguish producing/updating a concrete Plan from explaining a planning method, reviewing an existing Plan, or brainstorming direction. Method/review/brainstorm requests are read-only advisory work: inspect only representative evidence needed to support the evaluation, report the strongest current finding and next decision, and do not execute every Design Slice, materialize artifacts, or build Task Breakdown. Continue through the full workflow only when the user asks to draft, update, complete, or decide the concrete feature/design Plan.

## Complexity Gate

Complexity changes analysis depth, never file creation.

| Size | Signal | Analysis |
|---|---|---|
| Trivial | obvious local correction | skip this workflow |
| Simple | clear goal, local behavior, little ambiguity | plan inline; ask only if a real decision remains |
| Complex | multiple owners, unclear behavior, dependency, architecture choice | trace evidence and close Design Slices |
| Large | multi-subsystem, irreversible/expensive, high uncertainty | also read [`plan-large.md`](plan-large.md) |

Reclassify when evidence expands or narrows owners, reversibility, uncertainty, or risk. Do not use token, line, file, section, question, or elapsed-time counts as correctness gates.

## Question Gate

**Evidence Baseline - Implementation facts closed?** When the current Design Slice cannot state implementation-ready desired meaning, use [`change-contract.md`](../protocol-blocks/change-contract.md) to form Semantic Intent; clear slices reuse their existing contract. When the entry/owner/change point remains technical, consume [`source-localization.md`](../protocol-blocks/source-localization.md) before asking the user, then execute the implementation-fact gate in [`ambiguous-request-gate.md`](../protocol-blocks/ambiguous-request-gate.md) and trace the smallest concrete business flow that can decide the current question: actor/trigger -> caller and actual owner/write target/state -> ordering, guards, and failure -> reader/UI/API/exit; trace distinct flows independently and do not combine two incomplete flows into a binary choice. Name the file/method, contract/schema, test, configuration, or runtime observation and the decision it changes, then form an evidence-backed working conclusion. Stop reading when evidence resolves or falsifies the current question or identifies the next semantic owner; suspected consumers, risks, and adjacent flows remain candidates until a later Design Slice needs them. Do not inventory every possible consumer before the first decision.

Do not ask the user to do Agent-available discovery, and never ask the user to restate an implementation fact. If the user says the answer is in code, finish the trace. Ask only a normative decision that can change future meaning, invariants, failure/compatibility/migration semantics, scope, acceptance, or ownership. Treat questions as a decision-relevant uncertainty budget, not an exhaustive questionnaire: cross-check implementation evidence against existing user-confirmed answers, ask the user to correct, complete, or choose against it, and accept the point and stop asking when no material ambiguity remains. Do not open with abstract prompts. If evidence and the answer conflict, ask only which normative meaning governs. The working conclusion remains `proposed` / `current implementation fact` until the user confirms normative meaning.

When resuming an active Plan that already has Open Questions, select the highest-impact unresolved decision first. Inspect only the evidence needed to frame or resolve that one question, then run the progressive Brainstorm Handoff; keep every other Open Question and suspected evidence path unopened until its turn.

## User-Confirmed Decision Mainline

This section is the canonical owner of Decision Delta capture and Plan Mainline Handoff. Preserve a compact Decision Trace only when the user selects, rejects, corrects, or defines a load-bearing normative decision: trigger/question -> faithful answer -> `Authority: user-confirmed` -> normative meaning/scope -> Agent-derived consequences -> affected requirement/design/proof. When a durable Plan exists, keep this in its `Decision Context` with `Evidence / Source: current conversation`. Do not put Agent-derived fields, tables, APIs, classes, or storage choices under user authority unless explicitly selected. Replacements create a `superseded` Delta; they do not silently rewrite the mainline.

## Business-Semantics Gate

Do not bind a business domain from keywords alone. An explicit business-rule request or source Plan that declares its domain owner may evaluate `domain-routing.yaml` after workflow selection. Ambiguous feature work first inspects minimal evidence and binds a domain only when the unresolved decision depends on business semantics. Compare desired business truth -> architecture/rules/contracts -> current implementation fact, and record `business-model impact: unchanged / proposed change / unknown`. If new evidence overturns a load-bearing conclusion, replay the mainline, approach, acceptance, boundaries, and Task Anchor before continuing.

## Modeling Gap Intake Handoff

Admit confirmed implementation gaps only after `profile-business-model.md` finishes the user's agreed modeling scope. Reuse one dossier; never create one PRD per gap. Each item needs user-confirmed desired truth, current implementation evidence, explicit gap/impact, unique owner, and Knowledge Impact. Show the full deduplicated gap set, then plan shared dependencies and repair boundaries without reconfirming the business rule.

## Design Slice

Close one load-bearing question at a time: `question -> current evidence -> decision -> impact/risk -> proof`. This is an internal completeness check, not a visible template. Select only dimensions the evidence activates: requirements, Current -> Target owner/flow/state, domain model, data/storage, contracts/integration, change/impact, material risk, verification/rollout. Keep ownership, cardinality/uniqueness, transaction/consistency, failure/recovery, compatibility/migration, performance, concurrency, and semantic consumers explicit when they change the design.

Do not open the next independent Design Slice while the current one still contains a user-owned normative choice or high-impact assumption that could redirect later analysis. Alternatives appear only when genuinely different viable shapes or a load-bearing rejected path exist. Never manufacture a second option for ceremony. Resolved questions leave Open Questions; Task Breakdown stays absent until stable executable interfaces exist.

## Artifact Pressure Gate

Start in conversation plus the harness-native Plan. Create a durable artifact only when the user explicitly requests it or analysis exposes a concrete pressure: a load-bearing decision risks context loss or needs handoff; an independent consumer/reviewer/validator/lifecycle exists; a cross-module conflict needs one reconciled owner; or keeping the content integrated would obscure decisions or proof. Complexity, activity, or reaching a universal evidence-ready checkpoint is not pressure.

Create the smallest current owner. Use one `docs/plans/YYYY-MM-DD-<slug>.md` for a focused one-file record, or `docs/plans/YYYY-MM-DD-<slug>/prd.md` when the durable object is a named dossier, must collect multiple admitted topics, follows an existing local archive contract, or already needs an independent sibling. `prd.md` owns the requirement/decision synthesis and links siblings. Add `design.md` or another natural sibling only when it can be read alone and changes a decision, task boundary, risk treatment, or proof. Never pre-create a Plan, directory, `design.md`, or a taxonomy of empty files from complexity alone.

When multiple independently authoritative Plans jointly govern one outcome, distinguish an ordinary dependency from composition before materializing anything. A Plan is `subplan_of` and physically nested only when it cannot independently complete, freeze, and be directly consumed without its parent; otherwise it remains an external Component. Materialize a durable Integrating dossier only when the composition itself has persistence, handoff, review, recovery, conflict, authorization, integrated-proof, or Closure pressure; promote an existing truthful common-outcome owner before creating a third Plan. Its `prd.md` records one-way `consumes` paths and the common outcome/order/conflict/integrated acceptance without mirroring Component status or content.

## Database-Change Artifact Gate

Any database-structure change independently requires a dossier plus a naturally named `.sql` sibling before implementation approval. Show the user a separate checkpoint naming the affected database/table, target change, compatibility/backfill, SQL path, execution owner, and authorization boundary. Derive the file from the real current schema and dialect; include complete target DDL, forward schema/data update, read-only verification, and safe rollback or an explicit recovery plan. The SQL artifact is a review/handoff contract, never permission to bypass the project-owned database workflow.

## Progressive Brainstorm Handoff

This handoff is progressive, not only a final ceremony. In interactive Complex/Large planning, run it as soon as the first Design Slice exposes a user-owned normative choice or high-impact assumption, before opening an unrelated Slice. Continue autonomously across independent slices only when the user explicitly requests an artifact-only or end-to-end Plan without checkpoints.

A written and internally checked Plan does not end the planning conversation. Unless the user asked for artifact-only work, paused, or stopped, automatically enter a detailed user-facing brainstorm when a remaining normative choice or high-impact assumption can change design or acceptance. Cover exactly one topic: **Current conclusion**, **Evidence and constraints**, **Remaining question**, **Impact and trade-offs**, **Agent recommendation**, and the user decision point. Do not replace this with a three-line summary or batch checklist. Write each answer back before moving to another independent topic; stop when no substantial ambiguity remains.

## Plan Contract And Handoff

A durable Plan is the current requirement/design and implementation-review contract, not a full transcript. Keep only warranted sections in a natural order: Problem/Scope, current decisions, requirements/observable acceptance, chosen design and Current -> Target evidence, impacts/risks/proof, executable tasks, and genuine Open Questions. Provenance stays compact; frozen Plans retain history without remaining default task knowledge.

For two or more dependent tasks, declare `Files`, `Consumes`, `Produces`, and observable `Acceptance`; omit placeholder decomposition. Before implementation handoff, reconcile authority, Current/Target, impact, risks, proof, Open Questions, artifact links, and task interfaces. Run Plan Mainline Handoff: replay confirmed/superseded decisions; for business-bearing work, distilled confirmed business meaning goes through [`update-rules.md`](update-rules.md); initialize truthful `distilled_to:` targets; retain the source Plan path; and pass its chosen outcome, acceptance criteria, boundaries, and task breakdown to [`task-execution.md`](task-execution.md). For an Integrating Plan, every consumed interface must be stable and it becomes the only source for the Native Plan; Component reconciliation precedes integrated `done`. The dossier owns decisions, not live step status.

## Completion Check

- Every mainline claim has fitted evidence/authority and changes implementation, review, risk treatment, or proof.
- Any activated Change Contract is consumed into reconstructable Current -> Target, impact, risk, proof, and executable interfaces without copying its complete protocol into the Plan.
- Current -> Target and semantic consumers are reconstructable; activated risks state scenario, invariant, failure, mechanism/boundary, recovery, proof, and residual risk.
- No stale question, fake alternative, authority mixing, placeholder task, duplicated conclusion, or unjustified artifact remains.
- Business-bearing desired truth remains distinct from current implementation fact; technical Plans create no business leaf.
- Every activated Plan graph edge resolves to one semantic owner; schema-changing Plans have a complete SQL sibling and explicit user confirmation rather than prose-only DB impact.
- At final `done`, reconcile later deltas and implementation evidence, verify activated destinations, and freeze the Plan.

[workflow-state:planning]
Close the next Design Slice from evidence, create no artifact without real pressure, and hand off only a reconciled current contract.
[/workflow-state:planning]
