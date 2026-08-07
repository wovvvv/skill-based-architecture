# User Decision Drift

Load this protocol only after code, tests, runtime evidence, review, or a proposed implementation conflicts with a user-confirmed product meaning, business rule, scope, flow, state, boundary, invariant, acceptance condition, or user-visible behavior. Ordinary implementation choices that preserve those decisions do not trigger it. Code may expose constraints, cost, and risk; it cannot change that authority.

## Resolution

1. Keep the affected path paused; independent work continues only when it cannot prejudge the decision.
2. Preserve the existing `Authority: user-confirmed` Decision Delta. State the confirmed mainline, `current implementation fact`, exact gap, constraint/cost/risk, and only materially different options.
3. Mark every alternative `proposed`. Ask one decision-bearing question; do not mutate the affected path until the answer is clear.
4. Before recording the answer, apply [`maintain-docs.md` § Source-Preserving User Input](../workflows/maintain-docs.md#source-preserving-user-input): keep clear wording verbatim; limit optional normalization to punctuation, obvious typo, grammar, or word order; keep the original adjacent; and label any Agent-derived summary as subordinate rather than letting it become the only normative record.
5. For every answer, bind every short answer to its original question/options and preserve speech act/force, actor/ownership, timing/commitment, uncertainty/emphasis, definition/identity, applicability/preconditions, boundary/counterexample, negation/rejected direction, rationale/consequence, authority, scope, and `proposed | confirmed | superseded` status. Record that source-faithful answer in the governing Plan Decision Context. If meaning changes, mark the prior decision `superseded`; never silently rewrite it. When faithful normalization is uncertain, retain the source wording or ask the user rather than inventing a cleaner interpretation.
6. Reconcile any routed business rule, affected Plan/Component interface, Task Anchor, acceptance criteria, and implementation evidence before resuming. If the answer changes the mainline, update the Task Anchor and remaining Native Plan before more mutation.

Never silently compromise a confirmed mainline to fit current code. If the proposed implementation must change the meaning, return to the user-owned Decision Delta instead of resolving the conflict at implementation or Closure.

## Return

Return `resume` only when authority and every affected owner agree. Return `blocked` when the user decision or required owner update is still missing. A late disclosure in review or Closure never substitutes for this gate.
