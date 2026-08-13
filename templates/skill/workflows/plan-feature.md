# Implementation Plan Workflow

> **Inline by default.** This workflow derives how to implement an already
> confirmed Requirement. It is not the Requirement Definition owner and it is
> not the runtime Native Plan.

Use it to draft, update, or review an implementation design/Plan, or to compare
technical alternatives that preserve the same desired contract. A self-hosting
route may append its own product doctrine after selecting Requirement
Definition; this reusable workflow carries no repository-specific product
source. Read a local Plan archive contract only when the Artifact Pressure Gate
admits a durable Plan.

## Deliverable Gate

Distinguish a concrete implementation Plan from planning-method explanation,
Plan review, or read-only technical brainstorming. Advisory requests inspect
only representative evidence and return findings/next decisions; they do not
materialize artifacts, build Task Breakdown, or mutate code. A request to
understand desired behavior, product direction, scope, flow, rules, or
acceptance belongs to [`define-requirement.md`](define-requirement.md).

## Intake Sequence

1. **Consume the Requirement** - require a `requirement-ready` Change Contract
   from explicit user input, a governing Requirement source, or Requirement
   Definition. If any user-owned goal, scope, model/flow, rule/constraint,
   permission, preservation, or acceptance choice remains, return to
   Requirement Definition. Never close it with an implementation assumption.
2. **Project the Task Anchor** - let
   [`task-execution.md`](task-execution.md) project Goal, Done When, and material
   Boundaries from the Requirement. The projection is not a Requirement copy or
   an implementation step list.
3. **Prove implementation facts** - use
   [`source-localization.md`](../protocol-blocks/source-localization.md) and the
   matched Domain Workflow to prove Current behavior, canonical owner/change
   point, affected producer/consumer/state/contract path, Current -> Target, and
   activated high-cost boundaries. Code can falsify a premise but cannot rewrite
   desired meaning.
4. **Reach `implementation-ready`** - finish the Implementation Binding in
   [`change-contract.md`](../protocol-blocks/change-contract.md). Only then
   derive technical design, Task Interfaces, proof implementation, and the
   Native Plan. Task Breakdown and mutation are forbidden before this state.

If later evidence changes desired meaning, return to Requirement Definition and
re-project the Anchor before replanning. If only owner or Current facts change,
return to localization and rebind.

## Complexity Gate

Complexity changes analysis depth, never file creation.

| Size | Signal | Analysis |
|---|---|---|
| Trivial | obvious fixed-contract correction | skip this workflow |
| Simple | one proven owner, local Target, little technical uncertainty | plan inline after binding |
| Complex | multiple owners, dependency, architecture choice, material risk | close technical Design Slices |
| Large | multi-subsystem, irreversible/expensive, high uncertainty | also read [`plan-large.md`](plan-large.md) |

Reclassify when evidence changes owners, reversibility, uncertainty, or risk.
Do not use token, line, file, question, or elapsed-time counts as correctness
gates.

## Technical Design Slices

Close one load-bearing implementation question at a time:
`question -> Current evidence -> technical decision -> impact/risk -> proof`.
Activate only dimensions that change implementation: owner/flow/state, domain
model impact, data/storage, contracts/integration, compatibility/migration,
transaction/consistency, failure/recovery, concurrency/performance, rollout,
and semantic consumers.

Alternatives must be genuinely different viable technical shapes that all
preserve the governing Requirement. Do not manufacture options for ceremony.
A choice that changes desired behavior, scope, flow meaning, rules, or
acceptance is a Requirement alternative and returns to Requirement Definition.
Agent-discoverable technical uncertainty returns to Source Localization, not to
the user. Do not open the next independent Slice while the current one can
redirect later design.

For business-bearing work, compare confirmed desired business truth ->
architecture/rules/contracts -> Current implementation fact and record
`business-model impact: unchanged / proposed change / unknown`. A proposed
business change returns to Requirement Definition or the owning business-model
workflow; Plan Feature cannot create desired business truth.

## Proof Design

Map each observable acceptance criterion and material implementation risk to the
cheapest fitted evidence, its advance/return condition, and its stop/escalation
boundary. Prefer a red test when a stable automated seam exists; use API/runtime
readback, browser evidence, or human review when those are the truthful proof.
The proof implementation is subordinate to acceptance. If writing it requires
an unstated expected result, return that question to Requirement Definition.

## Artifact Pressure Gate

Start in conversation and, after `implementation-ready`, the harness-native
Plan. Create a durable artifact only when the user explicitly requests it or a
load-bearing decision needs recovery/handoff, an independent consumer/reviewer/
validator/lifecycle exists, or a cross-module conflict needs one reconciled
owner. Complexity or activity alone is not pressure.

Create the smallest owner: one `docs/plans/YYYY-MM-DD-<slug>.md` for a focused
record, or a dossier `prd.md` only when it already needs independently readable
siblings. A durable Plan names and consumes its governing Requirement; physical
co-location never transfers Requirement authority to the Plan. Add `design.md`
or another sibling only when it independently changes a technical decision,
task boundary, risk treatment, or proof.

When several authoritative Plans compose one outcome, distinguish dependency
from `subplan_of`. Materialize an Integrating Plan only for real composition
recovery/handoff/review/conflict/authorization/proof pressure. It records
one-way `consumes` edges and the integrated outcome/order/conflict/proof without
mirroring Component content or live status.

## Database-Change Artifact Gate

A database-structure change independently requires a dossier and naturally
named `.sql` sibling before implementation approval. Show a separate checkpoint
naming database/table, target change, compatibility/backfill, SQL path,
execution owner, and authorization boundary. Derive SQL from the real schema
and dialect; include forward change, read-only verification, and safe rollback
or explicit recovery. The artifact never grants database-write authority.

## Plan Contract And Handoff

A durable implementation Plan is a revisable technical contract. It names its
`Governing Requirement` source/authority and contains only warranted Current ->
Target evidence, chosen technical design, impact/risk/recovery, acceptance-to-
proof mapping, executable Task Interfaces, dependencies/order, and genuine
technical Open Questions. It must not redefine Goal, scope, model/flow, rules,
constraints, permissions, preservation, or acceptance.

For two or more dependent tasks, declare `Files`, `Consumes`, `Produces`, and
observable `Acceptance`. Before handoff, reconcile Requirement authority,
Implementation Binding, impact, risk, proof, artifact links, and interfaces.
Then let Task Execution derive the Native Plan; the durable dossier owns design
decisions, not live step status. For business-bearing work, send confirmed business meaning through [`rule-update/business-truth.md` § Requirement Decision Source](rule-update/business-truth.md#requirement-decision-source).

## Completion Check

- A named `requirement-ready` source governs the Plan, and every Task Interface
  appears only after `implementation-ready`.
- Current -> Target, owner, affected paths, technical choices, impact, risks,
  recovery, and proof mapping are reconstructable from evidence.
- No implementation assumption invents or narrows desired meaning; normative
  gaps return to Requirement Definition and technical gaps to localization.
- Every proof traces to Requirement acceptance; test code creates no expected
  product behavior.
- No fake alternative, stale question, authority mixing, placeholder task,
  duplicated conclusion, or unjustified artifact remains.

[workflow-state:planning]
Consume the governing Requirement, prove Implementation Binding, then derive
only the technical Plan. Return upstream whenever desired meaning changes.
[/workflow-state:planning]
