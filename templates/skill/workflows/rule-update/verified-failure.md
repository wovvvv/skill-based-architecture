# Verified Failure Learning

Use this owner only after Task Execution or Fix Bug proves the failure boundary, root cause, completed repair, fitted red-to-green evidence, and a stable prevention action that can change a future task. Before a persistent change or no-write decision, consume [`workflows/update-rules.md` § Shared Durable-Write Contract](../update-rules.md#shared-durable-write-contract) once.

## Verified Failure Input

Rejected hypotheses, unresolved causes, raw messages, transient interruptions, and retries inside one unresolved task remain Session-only. A first proven actionable failure bypasses only the ordinary Recording Threshold: when the write is within current authority, reconcile prevention directly into its canonical owner and activate it before the next mistake-prone action instead of waiting for another occurrence or the final AAR.

Keep two failure classes independent:

1. **Activation failure** - applicable prevention already exists, but the normal task path does not reach it before the protected action, or reaching it does not change the action. Repair the route, checkpoint, or scoped enforcement that should make the stored prevention act before the mistake.
2. **Learning-closure failure** - the first occurrence has already proved a stable prevention, but that prevention is not reconciled into its canonical owner and activated during the current task before the next mistake-prone action. Complete the durable write and its activation edge immediately.

Their evidence is not interchangeable. A record's existence, or a write completed after failure, does not prove that an earlier protected action used it; one correctly configured run does not prove that a newly learned prevention was durably reconciled for the next task. Evaluate and close both classes separately whenever both are present.

Stable execution preconditions need an earlier placement than their failure explanation. When the proven cause is a wrong project tool, runtime, or configuration, keep the exact project value, selector, and effective-runtime readback in the nearest project testing/build owner, then make every applicable workflow reach that preflight. The active owner must select the environment and verify what the command will actually use before its first protected command; compatibility prose, a buried Gotcha, or a check performed only after failure is inert. If the required environment cannot be selected or read back, stop and report an unmet precondition rather than run under a known-incompatible default or count tool initialization as the intended red test. Generic templates keep only this placement contract; project-specific versions and commands stay downstream.

Return exactly one lifecycle outcome:

1. **`covered/no-write`** - an active owner already changes the required next action.
2. **`extend-existing`** - the same root cause and prevention needs another applicability condition or symptom.
3. **`correct-existing`** - current knowledge is inaccurate, over-broad, obsolete, or must be retired.
4. **`add-and-activate`** - a distinct prevention is added to the nearest canonical owner with its action-changing path.
5. **`transient/no-write`** - no stable future action exists, such as a one-off command mistake or transient external interruption.
6. **`requires-user-authority`** - intended meaning, higher-scope promotion, or a shared/costly enforcement boundary needs a user decision.
7. **`escalate-prevention`** - applicable written prevention was reached yet the same mistake recurred, so a stronger scoped mechanism is justified.

## Recurrence and Prevention Escalation

Match recurrence by `same proven root cause + same applicability boundary + same prevention action`; raw text only finds candidates. On an independent recurrence, first verify whether active prevention was reached before the mistake-prone action. If it was missed or inert, repair activation instead of adding prose. If it was reached and still failed, strengthen the earliest triggering tool only when the gate is local to the authorized repository/task scope, low-cost, reversible, based on existing tooling/dependencies, supported by fitted proof, and retains a scoped escape path.

Ask before changing CI, hooks, server-side enforcement, default shared build/test commands, hard-failure policy, dependencies/plugins/services, team or cross-repository rules, public/external contracts, shared/non-local state, difficult rollback, or materially increased routine cost. Project-local prevention writes to project owners by default; iteration, personal, and team promotion remain explicit higher-scope actions.

Failure learning never grants commit, push, MR, deploy, publish, database, production, or other external authority.

## Failure-Specific Completion

- [ ] Proof includes boundary, root cause, completed repair, fitted red-to-green evidence, and a stable future action, or the outcome is `transient/no-write`.
- [ ] Exactly one lifecycle outcome was returned to Task Execution and later Closure accounting.
- [ ] Activation failure and learning-closure failure were evaluated independently; stored/written knowledge was not used as proof of pre-action activation, and one correct run was not used as proof of durable learning.
- [ ] Recurrence identity used root cause, applicability, and prevention rather than message text or same-task retry count.
- [ ] Missed/inert prevention repaired activation; reached-but-insufficient prevention escalated only within the local/reversible/authorized gate.
- [ ] Stable tool/runtime/configuration prevention is selected and read back before the first protected command; unavailable preconditions stop honestly instead of producing a false red/green result.
- [ ] Every durable prevention has an action-changing path and affected verification was rerun.
- [ ] No delivery, shared-system, enforcement, or promotion authority expanded.
