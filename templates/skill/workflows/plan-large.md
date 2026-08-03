# Large Plan Extension

Read this file only after `plan-feature.md` classifies the task as **Large** because evidence shows multi-subsystem scope, irreversible/expensive change, high uncertainty, or many decision-bearing unknowns. Large changes analysis depth, not artifact count.

## Multi-Perspective Analysis

Select perspectives incrementally after the current Design Slice exposes a decision that needs them. Analyze them in the conversation, harness-native Plan, or the current integrated artifact; a perspective is not a file. A suspected risk or consumer list is a candidate queue, not permission to open every perspective at once.

| Possible perspective | What it decides |
|---|---|
| Architecture | boundaries, owners, components, data/state flow |
| Domain | entities, lifecycle, state machine, invariants, desired truth impact |
| Data and contracts | schema/API/event/cardinality/uniqueness, compatibility and migration |
| Integration and impact | semantic callers/readers/writers, copies/merges/deletes, cross-repo/service effects |
| Risk and quality | consistency, concurrency, performance, availability, permission, recovery |
| Rollout and proof | sequencing, staged activation, rollback, observability, acceptance |
| Decomposition | build order, shared interfaces, independent dispatch cut-points |

For business-bearing work, compare business-model intent, architecture/contracts, and current code/tests/runtime without turning current implementation into desired truth.

## Angle Contract

Each selected angle closes one or more Design Slices and states:

1. its decision question and current evidence;
2. Current -> Target ownership/flow/model change;
3. chosen decision plus semantic impact;
4. activated risk treatment and proof;
5. remaining uncertainty or blocker.

Keep tightly coupled angles together. Extract a naturally named sibling only after the Artifact Pressure Gate proves an independent consumer, reviewer, validator, lifecycle, or loading reason and the sibling can change the synthesis alone. If an angle would be read only with every sibling, keep it integrated. Never create one file per lens, and never create empty `architecture.md`, `risks.md`, `contracts.md`, or rollout/checklist files from the Large label.

## Risk Scenarios

Expand only risks activated by evidence, but do not compress them to labels. Every material scenario states invariant, failure mode, mechanism, mechanism boundary/cost, recovery, fitted proof, and residual risk.

- **Eventual consistency:** truth owner, propagation path, convergence window, intermediate visibility, duplicate/out-of-order/loss handling, retry/dead-letter/reconciliation, and non-convergence detection.
- **Concurrency:** writers, aggregate key, transaction/lock/version order, idempotency/retry/timeout/deadlock behavior, and final database constraint.
- **Performance:** hot path, cardinality/fan-out/query count, index/cache/batch/pagination choice, consistency cost, target observation, and degradation behavior.
- **Migration/compatibility:** old/new readers and writers, backfill/cutover order, reversibility, partial-failure state, rollback, and proof against production-shaped data.

## Synthesis

Maintain one current synthesis in the active carrier: conversation when no artifact is justified, otherwise `prd.md` or the existing one-file Plan. It states the chosen path, Current -> Target change, conflicts resolved across perspectives, material risks/proof, and genuine blockers. Link only independently justified siblings; a sibling absent from Synthesis is not part of the Plan, and a Synthesis claim without evidence is ungrounded.

Before approval or freeze, diff overlapping claims, verify each link supports its sentence, remove resolved Open Questions, and convert stable decomposition into `Files / Consumes / Produces / Acceptance`. Contradictory evidence reopens the owning Design Slice instead of preserving document completeness.

## Parallel Analysis

Independent perspectives may use Mode 2 analysis subagents only after the main thread states the current decision, bounded evidence region, expected result, and stop condition, and overlap plus Net Benefit are real. Do not dispatch broad “scan the subsystem” work before that boundary. Give each worker one decision question without leaking the intended answer; the main agent owns cross-perspective reconciliation and user discussion. Dependent perspectives stay inline.

## Large-Plan Checklist

- [ ] Perspectives were selected by decision/risk pressure, not taxonomy completeness
- [ ] Current -> Target, semantic fan-out, authority, and proof agree across the synthesis
- [ ] Activated consistency/concurrency/performance/migration risks have scenario-level treatment
- [ ] Every extracted artifact has an independent job and no conclusion is duplicated
- [ ] Business-model impact and desired-truth/current-fact separation are explicit where relevant
- [ ] Multi-file semantic drift and implementation interfaces were checked before handoff
