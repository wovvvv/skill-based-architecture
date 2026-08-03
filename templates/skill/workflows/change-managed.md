# Change-Managed Workflow

Use this for non-bug changes whose partial edits can drift: features, refactors, generated/copied files, shared configuration, or changes with derived targets. For a non-Simple task, [`task-execution.md`](task-execution.md) turns these domain steps into the current Task Anchor and Native Plan; this workflow remains authoritative for their meaning and order. Use [`subagent-auxiliary.md`](subagent-auxiliary.md) only for one admitted auxiliary workstream and [`refactor-fanout.md`](refactor-fanout.md) only for several independent usage batches.

Start without domain knowledge. An explicit business-rule request or a source Plan that already declares the applicable business-domain owner may activate `domain-routing.yaml` immediately after this workflow is selected; otherwise inspect the smallest source slice first and activate one domain only when an unresolved business decision appears. Read a source Plan directly when this workflow owns it; the Plan's existence alone does not activate a domain. Keywords alone do not activate a domain. Before the first mutation, read [`change-discipline.md`](../rules/change-discipline.md).

Use [`change-contract.md`](../protocol-blocks/change-contract.md) only when the observable target, authority, preserved behavior, scope, or acceptance is not implementation-ready; clear source Plans and explicit requests take its fast path. When Semantic Intent is ready but canonical ownership remains technical, consume [`source-localization.md`](../protocol-blocks/source-localization.md). Steps 1-3 must bind the returned owner/Current -> Target/affected path before mutation.

## Steps

1. **Define scope and replay the decision source** — name owned files/modules and the observable outcome. For Design-derived work, read the source Plan's relevant user-confirmed Decision Context before reasoning about or editing code; for business-bearing work, also read the routed business model. Carry the applicable rules, boundaries, rationale, and acceptance into the Task Anchor. Purely technical Design-derived work replays the source Plan without requiring a business model. Record `business-model impact: unchanged / proposed change / unknown`; a proposed type/flow/state/boundary/invariant change requires an approved Plan.
2. **Find the source of truth and owner** — distinguish canonical content/state from generated, copied, or downstream consumers; trace provenance and the producer-to-consumer call chain.
3. **Map semantic fan-out** — name the invariant and list every affected full/incremental/read/write path, derived target, registration, test, and doc/index that must stay synchronized.
4. **Choose the owning boundary** — default to Product Development and make every coordinated change needed for semantic completeness. Operational Stabilization requires an explicit production/availability/frozen-scope constraint and must expose unresolved structural work.
5. **Make the smallest semantically complete change** — use minimality only to choose among complete solutions; preserve unrelated edits and avoid adjacent cleanup.
6. **Sync derived files** with the owning generator/copy process.
7. **Check drift** across all mapped targets, semantic paths, and the user-confirmed Plan mainline. If current or in-progress implementation diverges, invoke [`task-execution.md` § User Decision Drift Gate](task-execution.md#user-decision-drift-gate) immediately: pause the affected path, expose the gap/constraints/cost/risk, and obtain a user decision before continuing. Do not silently fit the requirement to existing code or wait until review/Closure.
8. **Validate behavior** with the cheapest sufficient fresh evidence; escalate only when concrete runtime/release risk requires it.
9. **Run [Task Closure](task-closure.md)** once after the integrated change.

If templates, scaffolds, entry shells, or reusable project structure change, also follow [`edit-templates.md`](edit-templates.md). If this project has already activated an operation-permission model, apply its pre-operation classifier and closure check; the default scaffold assumes none.

## Completion Check

Scope, applicable source Plan/mainline, any activated Change Contract, invariant, ownership/provenance, call chain, all semantic paths, fan-out targets, sync, user-resolved drift, targeted validation, and Task Closure are all accounted for without copying the complete shared protocols here.
