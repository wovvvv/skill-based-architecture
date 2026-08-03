---
date: YYYY-MM-DD
status: draft                          # draft | executing | done | abandoned
# distilled_to:                        # initialize only at implementation handoff
#   - rules/<topic>.md
#   - references/business/<domain>.md
#   - references/gotchas.md
---

# Plan: {{Title}}

> Current conclusion: {{one sentence that implementers and reviewers can act on}}

> Use this template only after `plan-feature.md` § Artifact Pressure Gate admits a durable Plan. Delete instructions and unused optional sections. Do not pre-create sibling files.

## Problem And Scope

State the concrete problem, desired outcome, current owner/flow/state, affected scope, and meaningful exclusions. Cite the smallest implementation evidence that changes the design.

## Current Decisions

State the chosen current mainline and why. When a user answer carries normative authority, add compact `Decision Context`: trigger/question, faithful answer, `Authority: user-confirmed`, meaning/scope, Agent-derived consequences, and evidence source. Mark replaced decisions `superseded`; do not preserve routine acknowledgements or the investigation transcript.

## Requirements And Acceptance

List observable behavior and the evidence that will prove it. Requirements identify actor/scenario/invariant/boundary; acceptance proves outcomes rather than command execution alone.

## Open Questions

Keep only unresolved decisions that can change design, acceptance, risk, migration, or ownership. Write `None` when the Plan is ready; remove resolved questions from this section.

<!-- Add only when evidence warrants it; use natural headings, not this comment text. -->
<!-- Current -> Target Design: owners, models, state/data/contract/lifecycle paths, preserved behavior. -->
<!-- Change / Impact: semantic readers, writers, callers, copies, merges, deletes, UI/API/ops/tests. -->
<!-- Risk Scenarios: scenario, invariant, failure, mechanism/boundary, recovery, proof, residual risk. -->
<!-- Options: genuinely different viable shapes or a load-bearing rejected path only. -->
<!-- Task Interfaces: for stable dependent tasks, Files / Consumes / Produces / observable Acceptance. -->
<!-- Synthesis: when independent siblings exist, link them and reconcile conflicts in the entry Plan. -->

<!-- For abandoned Plans, replace the active body with: -->
<!-- ## Why Abandoned -->
<!-- One concise explanation. Do not distill an unchosen direction. -->
