# Business Truth Reconciliation

Use this owner for user-confirmed desired business meaning from Plan handoff, standalone business modeling, an admitted confirmed implementation gap, or an explicit user business statement during Fix Bug. Before a persistent change or no-write decision, consume [`workflows/update-rules.md` § Shared Durable-Write Contract](../update-rules.md#shared-durable-write-contract) once for classification, fidelity, reconciliation, activation, placement, synchronization, verification, and authority.

## Business Leaf and Gotcha Ownership

A business leaf is the complete owner of cross-implementation normative truth: business objects, macro flows, states, boundaries, invariants, and failure semantics. A Gotcha is the complete owner of an observed or reproducible, costly, non-obvious implementation failure: symptom, current implementation root cause, tempting wrong shortcut, and repair/verification guidance. A Gotcha is not a general implementation reference or a second business-model owner.

Use these tests before writing:

- If the statement remains true after classes, APIs, storage, and frameworks are replaced, it belongs in the business leaf.
- If it only maps the current implementation and contains no failure pattern, it belongs in a technical reference.
- If it explains how the current implementation can repeatedly violate intended behavior, it belongs in a Gotcha.

One topic may activate both files, but the records have different shapes. Keep complete business truth in the leaf. Keep only a minimal business anchor and owner link in the Gotcha, followed by the implementation-specific symptom, cause, wrong shortcut, and prevention. Lift stable truth stranded in a Gotcha into the routed leaf; move classes, fields, endpoints, storage keys, and repair recipes out of a leaf without losing its normative meaning or provenance.

## Requirement Decision Source

[`workflows/define-requirement.md` § Decision Authority And Source Fidelity](../define-requirement.md#decision-authority-and-source-fidelity) owns Decision Delta capture; [`protocol-blocks/change-contract.md` § Requirement Contract](../../protocol-blocks/change-contract.md#requirement-contract) owns runtime requirement authority and readiness. Consume the relevant Requirement source without recreating its schema: preserve the confirmed answer, authority, scope, load-bearing meaning, evidence, and supersession state. An implementation Plan carries only one-way Requirement Provenance. Unselected brainstorm candidates remain `proposed`.

Before technical planning/implementation handoff, transfer stable confirmed normative meaning into the unique routed owner as `desired business truth` with Requirement Provenance. Keep separately evidenced `current implementation fact` and every known implementation gap explicit. A confirmed Requirement bypasses only ordinary recording admission for its stable load-bearing business meaning; it still consumes the shared fidelity, reconciliation, activation, durability, synchronization, verification, and authority contract. A purely technical Plan creates no business record.

## Standalone Business-Model Input

Explicit standalone modeling routes through `profile-business-model.md` when adopted. Write stable, clear, user-confirmed, cross-implementation meaning directly into the unique routed leaf with conditions, reasons, boundaries/counterexamples, and compact Modeling Provenance when useful. Do not require a feature Plan, re-apply an ordinary AAR threshold, or create a PRD for interview history.

When the project adopts business modeling, its local `business-global-model.md` confirmed-gap intake owns the narrow exception. Only a user-confirmed truth with implementation evidence of noncompliance, an explicit difference/impact, and real implementation-handoff value may write truth and gap immediately, create or reuse one draft gap dossier, continue the agreed modeling scope, and hand the complete gap set to Plan Feature. Unconfirmed candidates, reading history, and evidence-poor differences never trigger it.

## Active Bug-Fix Input

During Fix Bug, the only possible business source is the user's explicit correction, answer, expected rule, rationale, boundary, or rejected direction. The Agent may judge whether that statement is clear, cross-implementation stable, durable, and future-relevant, then reconcile it immediately rather than waiting for Closure.

Do not derive `desired business truth` from Bug symptoms, root cause, repaired behavior, code, tests, runtime evidence, or Agent summaries. A user implementation suggestion is not business meaning merely because the user said it. Proven reusable engineering prevention goes to [`workflows/rule-update/verified-failure.md`](verified-failure.md), never into business as user intent.

## Business-Specific Completion

- [ ] Only user-confirmed normative meaning became `desired business truth`; implementation evidence remains `current implementation fact`.
- [ ] The unique routed leaf owns complete macro truth and any Gotcha keeps only its distinct implementation failure plus a minimal owner link.
- [ ] Requirement or Modeling provenance preserves the confirmed source, authority, scope, and applicable supersession state.
- [ ] Standalone modeling created no unnecessary PRD; confirmed gaps use one admitted dossier and remain explicit until implementation proof closes them.
- [ ] Business-owner routing and affected consumers were synchronized, and implementation alignment was not claimed without code/test/runtime evidence.
