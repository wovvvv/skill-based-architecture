---
date: YYYY-MM-DD
status: draft                          # draft | executing | done | abandoned
# requirement: prd.md                  # required when a durable sibling Requirement exists
# distilled_to:                        # initialize only at implementation handoff
#   - rules/<topic>.md
#   - references/business/<domain>.md
#   - references/gotchas.md
# consumes:                            # durable Integrating design.md only; paths to independent Components
#   - ../YYYY-MM-DD-<component>.md
# supersedes:                          # successor only; the frozen predecessor stays unchanged
#   - ../YYYY-MM-DD-<frozen-plan>.md
---

# Plan: {{Title}}

> Current conclusion: {{one sentence that implementers and reviewers can act on}}

> Use this template only after `plan-feature.md` § Artifact Pressure Gate admits a durable Plan. It is an Implementation Plan, normally `design.md`. Delete instructions and unused optional sections. Do not pre-create sibling files. A Requirement-only `prd.md` is independently complete and never uses this template.

> Consume a `requirement-ready` source and proven Implementation Binding before deriving tasks. The Requirement owns desired outcome, authoritative scope, model/flow, rules, preserved behavior, boundaries, and acceptance; this Plan records revisable technical means and must not redefine the target to fit its steps. Requirement and Plan have independent Artifact Pressure Gates: this template cannot create a Requirement artifact on the Plan's behalf.

<!-- A true subplan is not an independent Plan: place it inside the parent dossier, use only `subplan_of: design.md` frontmatter, omit independent date/status/distilled_to, and let the parent own lifecycle and Closure. `subplan_of: prd.md` is legacy-only for a frozen dossier whose Plan entry already uses that name. -->

## Governing Requirement

Link the Governing Requirement whenever a durable owner exists and identify its
authority, readiness, and version/supersession state. For an authoritative
Session or external source, identify that source precisely enough to reopen it.
Do not copy its Goal, scope, model/flow, rules, preservation, or acceptance into
this Plan. Do not add or resolve normative meaning here; return any such gap to
Requirement Definition, then update only this link/readiness reference after
the Requirement becomes ready again.

## Current Implementation Facts

Record only evidence-backed current owners, flows/states/contracts, Current ->
Target binding, affected producer/consumer paths, and technical boundaries that
change the design. Keep desired meaning in the governing Requirement.

<!-- Durable Integrating Plan: use `design.md` as the Plan entry, list independent Component paths in `consumes`, and synthesize only Component roles, dependency order, implementation composition conflicts, integrated proof, authorization/delivery boundary, and final Closure. Do not mirror Component content, status, Requirement meaning, or acceptance. -->

<!-- Database-structure change: before implementation, separately disclose the affected database object, change, compatibility/backfill, SQL artifact, execution owner, and authorization. Add one natural `.sql` sibling containing authoritative complete target DDL, forward schema/data update SQL, verification SQL, and safe rollback or explicit backup/stop/forward-repair recovery. The SQL artifact never grants DB-write authority. Delete this comment when no database structure changes. -->

## Implementation Decisions

State the chosen technical design and why. Include only alternatives that are
genuinely viable implementations of the same Requirement, plus impact, risk,
compatibility/recovery, and the evidence that selected one. A choice that would
change desired behavior, scope, flow meaning, rules, or acceptance is not a Plan decision and must return to Requirement Definition.

## Requirement Input And Proof Mapping

Reference each governing Requirement acceptance criterion without rewriting it,
then map it to the cheapest truthful proof: red/green automated check, API or
runtime readback, browser evidence, or human review. Proof code and commands are subordinate to acceptance; if they need an unstated expected result, return that
question to Requirement Definition.

## Technical Open Questions

Keep only unresolved implementation questions that preserve the governing
Requirement but can change design, risk, migration, recovery, ownership, or
proof implementation. Write `None` when the Plan is ready and remove resolved
questions. Any question that can change Requirement meaning returns upstream.
Technical evidence cannot directly edit Task Anchor Goal, Done When, or
Boundaries; a normative change first returns to Requirement Definition and
reaches `requirement-ready` again.

<!-- Add only when evidence warrants it; use natural headings, not this comment text. -->
<!-- Current -> Target Design: owners, models, state/data/contract/lifecycle paths, preserved behavior. -->
<!-- Change / Impact: semantic readers, writers, callers, copies, merges, deletes, UI/API/ops/tests. -->
<!-- Risk Scenarios: scenario, invariant, failure, mechanism/boundary, recovery, proof, residual risk. -->
<!-- Options: genuinely different viable shapes or a load-bearing rejected path only. -->
<!-- Task Interfaces: derive only after implementation-ready; for stable dependent tasks, Files / Consumes / Produces / observable Acceptance. -->
<!-- Synthesis: when independent siblings exist, link them and reconcile conflicts in the entry Plan. -->

<!-- For abandoned Plans, replace the active body with: -->
<!-- ## Why Abandoned -->
<!-- One concise explanation. Do not distill an unchosen direction. -->
