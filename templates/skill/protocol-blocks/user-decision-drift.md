# User Decision Drift

Load this protocol only after code, tests, runtime evidence, review, or a proposed implementation conflicts with a user-confirmed product/business mainline. Code may expose constraints, cost, and risk; it cannot change that authority.

## Resolution

1. Keep the affected path paused; independent work continues only when it cannot prejudge the decision.
2. Preserve the existing `Authority: user-confirmed` Decision Delta. State the confirmed mainline, `current implementation fact`, exact gap, constraint/cost/risk, and only materially different options.
3. Mark every alternative `proposed`. Ask one decision-bearing question; do not mutate the affected path until the answer is clear.
4. Record the answer in the governing Plan Decision Context. If meaning changes, mark the prior decision `superseded`; never silently rewrite it.
5. Reconcile any routed business rule, affected Plan/Component interface, Task Anchor, acceptance criteria, and implementation evidence before resuming.

## Return

Return `resume` only when authority and every affected owner agree. Return `blocked` when the user decision or required owner update is still missing. A late disclosure in review or Closure never substitutes for this gate.
