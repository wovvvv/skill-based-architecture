# Task Closure Protocol

This is the completion-time gate between finished local execution and verified delivery for behavior, rule, routing, script, and structure changes. It owns readiness and completion states; recording mechanics live in [`update-rules.md`](update-rules.md), file-boundary and path-integrity mechanics live in [`maintain-docs.md`](maintain-docs.md), and task-specific delivery mechanics remain with the matched workflow and user authorization.

## Task Closure Protocol

### Entry Gate

Closure starts only after local execution is complete. For a Simple task, the direct check and all non-delivery goal evidence must exist. For a Managed or Design-derived task, first run the final Anchor Checkpoint; every non-delivery Native Plan step must have passed its check, material Boundaries must remain intact, and no stale Plan branch may remain. Any outstanding Done When evidence must be explicitly delivery-dependent, with the expected artifact and proof named before Closure advances.

If implementation work or non-delivery evidence is missing, return to [`task-execution.md`](task-execution.md); do not use Closure to finish execution work. A Plan status or worker claim is not evidence by itself.

### Trigger Policy

| Task | Required closure |
|---|---|
| Pure Q&A/read-only advice with no file change | none |
| Formatting/comment/behavior-preserving rename with no reusable lesson | relevant text check only |
| Production behavior, API/schema, validation, state, transaction, async, or call-chain change | fresh verification + lightweight AAR |
| Rule/reference/workflow meaning change | AAR + triggered reconciliation/activation checks |
| Routing, SKILL/shell, script, generated block, file path, or skill structure change | full structure/path closure |
| User explicitly requests full validation | run the requested suite |

`smoke-test.sh` is for skill structure/routing/links, not ordinary code changes.

### Closure Steps

1. **Read back the contract** — restate the Task Anchor (or Simple-task outcome), matched route, Goal-level acceptance evidence, material Boundaries, forbidden shortcuts, for Design-derived work the source Plan path, and when activated the final expanded [`Change Contract`](../protocol-blocks/change-contract.md). Closure consumes that contract; it does not define Semantic Intent or source-localization stages. After a long/interrupted task, use `protocol-blocks/reboot-check.md`.
2. **Replay the user-confirmed mainline** — read the relevant Decision Context; for business-bearing decisions, also read the routed business rule. Closure owns final reconciliation: verify the confirmed record remains intact, compare `desired business truth` with code/tests/runtime `current implementation fact`, and account for every later Delta in the Plan, Task Anchor, implementation evidence, and any business rule. If Closure is the first time a material drift is surfaced, Closure fails: return to [`task-execution.md` § User Decision Drift Gate](task-execution.md#user-decision-drift-gate) and consult the user immediately; that gate owns the resolution procedure.
3. **Verify with fresh, fitted evidence**:
   - bind each material risk to the cheapest evidence that can falsify it and state the stop/escalation condition before running checks;
   - targeted command/test/typecheck first;
   - runtime/service/browser evidence only for wiring, config, permissions, serialization, data state, or UI behavior;
   - packaged/release/deploy evidence only when that chain changed or the user requires it.
   Stop when the bound evidence proves the contract; escalate only when a check fails, the risk crosses another boundary, or a stated uncertainty remains. Test count is not evidence quality. A fresh command against a stale artifact is not fresh evidence.
4. **Run the AAR below.** Any yes enters `update-rules.md`; all no stops recording. If recording changes any deliverable, return to the affected verification and integrity checks before declaring readiness.
5. **Run conditional integrity work**:
   - routing/shell/generated-block or structure/path changes → follow `maintain-docs.md` Step 6 and the repository's sync/smoke commands;
   - rule/reference meaning changes → search workflows for repeated invariants and reconcile them in the same change;
   - durable knowledge migrated/deleted/superseded → prove destination, owner, normal activation path, fitted validation, and intentionally unretained content before removing the legacy source; use the existing Plan/migration record rather than creating a mandatory ledger;
   - high-risk route, non-idempotent workflow, executable script contract, or external handoff → add/adjust a behavior contract only when structural checks cannot prove it.
6. **Declare readiness** — only after Steps 1–5 pass, name the already-authorized delivery action, expected artifact, and exact verification. `Ready for Delivery` is a checkpoint, not task completion.

### Delivery and Completion Gate

Closure never grants commit, push, MR, deploy, publish, or other side-effect authority. The matched workflow or harness performs only the delivery already authorized by the user, while Closure remains open.

- Verify the requested artifact rather than inferring it from a local precursor: inspect the commit/ref, remote branch, MR/PR URL and state, deployed runtime, published file, or other promised result.
- A failed, blocked, or unverified delivery leaves Closure open. Retry an external-only failure without rerunning unrelated local checks only when source content, relevant evidence, branch/config inputs, and the delivery premise are unchanged; otherwise return to fitted verification or Task Execution.
- When no external delivery was requested, the verified result and final response are the delivery artifact.
- Mark `Closure Complete` and report honestly only after every requested delivery artifact is verified; name any remaining risk without self-certifying beyond the checks run.

### Rationalizations to Reject

| Rationalization | Reality |
|---|---|
| “The change is small.” | Behavior/structure is the trigger; read-only work is already exempt. |
| “Tests passed earlier.” | A completion claim requires fresh evidence after the final edit. |
| “I will reconcile links/rules later.” | The decision context will be gone; do it in the same change. |
| “I can mention the mainline drift in the final report.” | First disclosure at Closure is too late. Pause the affected path and consult the user when drift is discovered. |
| “The file exists and smoke is green.” | Reachable structure can still be inert; state the next action it changes. |
| “The command exited 0, so the stage is complete.” | A successful exit code proves only the command's own contract. If it does not resolve the step's question, validate target behavior, or produce evidence consumed by the next step, return to Task Execution. |
| “I should add a safeguard just in case.” | No concrete recurring failure means no new mechanism. |
| “The branch was pushed, so the requested MR probably exists.” | A local or remote precursor is not delivery evidence; verify the actual requested artifact. |
| “A login/network retry means I must rerun every local test.” | If inputs and verified content are unchanged, retry and verify only the blocked delivery boundary. |

### Red Flags

- claiming “done/should pass” without reading a fresh exit code, or treating that exit code as sufficient completion evidence by itself;
- claiming completion from `Ready for Delivery` or from an unverified precursor such as a pushed branch;
- recording by appending instead of reconciling the existing concept;
- creating a file/index with no independently selected task path;
- treating optional delegation or future infrastructure as a completion requirement.

## After-Action Review

Ask only after Trigger Policy admits the task:

1. Did this reveal a repeatable costly pattern not obvious from code?
2. Did a missing rule or activation path cause a wrong turn?
3. Did an existing rule become inaccurate, obsolete, duplicated, or inert?
4. Did an external fact materially affect the decision and need scoped re-verification guidance?

Any yes → apply `update-rules.md` threshold, fidelity, reconciliation, activation, and durability gates. Otherwise do not create a record.
