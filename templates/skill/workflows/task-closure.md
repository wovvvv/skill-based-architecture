# Task Closure Protocol

This is the completion-time gate between finished local execution and verified delivery for behavior, rule, routing, script, and structure changes. It owns readiness and completion states; the shared durable-write contract lives in [`workflows/update-rules.md`](update-rules.md), typed recording procedures live under `workflows/rule-update/`, file-boundary and path-integrity mechanics live in [`maintain-docs.md`](maintain-docs.md), and task-specific delivery mechanics remain with the matched workflow and user authorization.

## Task Closure Protocol

### Entry Gate

Closure starts only after local execution is complete. For a Simple task, the direct check and all non-delivery goal evidence must exist. For a Managed or Design-derived task, first run the final Anchor Checkpoint; every non-delivery Native Plan step must have passed its check, material Boundaries must remain intact, and no stale Plan or Component branch may remain. Composite execution must still have exactly one Integrating Native Plan and one semantic `Current Task`. Any outstanding Done When evidence must be explicitly delivery-dependent, with the expected artifact and proof named before Closure advances.

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

1. **Read back the contract** — restate the Task Anchor (or Simple-task outcome), matched route, Goal-level acceptance evidence, material Boundaries, forbidden shortcuts, every governing Plan path, and when activated the final expanded [`Change Contract`](../protocol-blocks/change-contract.md). Closure consumes that contract; it does not define Semantic Intent or source-localization stages. After a long/interrupted task, use `protocol-blocks/reboot-check.md`.
2. **Reconcile Component owners first** — for an Integrating Plan, enumerate `consumes` and read current truth from each Component owner rather than a mirror. Reject missing, `abandoned`, unresolved-Delta, or superseded-but-still-consumed inputs. For each affected Component, reconcile its Decision Delta, local acceptance, fresh proof, delivery responsibility, and durable distillation, then verify it is `done`; no required Component may remain `draft` or `executing`, and true `subplan_of` content shares its parent's lifecycle. Only then replay the Integrating Decision Context and prove cross-Plan interfaces and acceptance. Abandoning the Integrating Plan leaves independent Component states unchanged.
3. **Replay the user-confirmed mainline** — read each relevant Decision Context; for business-bearing decisions, also read the routed business rule. Verify the confirmed record remains intact, compare `desired business truth` with code/tests/runtime `current implementation fact`, and account for every later Delta in its owning Plan, Task Anchor, implementation evidence, and any business rule. If Closure first surfaces material drift, return to [`task-execution.md` § User Decision Drift Gate](task-execution.md#user-decision-drift-gate); Closure does not resolve it.
4. **Verify with fresh, fitted evidence**:
   - bind each material risk to the cheapest evidence that can falsify it and state the stop/escalation condition before running checks;
   - targeted command/test/typecheck first;
   - runtime/service/browser evidence only for wiring, config, permissions, serialization, data state, or UI behavior;
   - packaged/release/deploy evidence only when that chain changed or the user requires it.
   Stop when the bound evidence proves the contract; escalate only when a check fails, the risk crosses another boundary, or a stated uncertainty remains. Test count is not evidence quality. A fresh command against a stale artifact is not fresh evidence.
5. **Account for verified failures** — enumerate every command, test, runtime, delivery, or premise failure whose root cause was proven during the task. Each must already have one completed [`workflows/rule-update/verified-failure.md` § Verified Failure Input](rule-update/verified-failure.md#verified-failure-input) learning outcome and, for a durable write, an action-changing activation path. If diagnosis, repair proof, outcome, or activation is missing, return to Task Execution or Verified Failure; Closure does not diagnose root cause or postpone the first write. Re-run affected verification when learning changed a deliverable.
6. **Run the AAR below.** Any yes enters [`workflows/rule-update/knowledge-reconciliation.md`](rule-update/knowledge-reconciliation.md); all no stops additional recording. Do not re-record an already-reconciled verified failure. If recording changes any deliverable, return to the affected verification and integrity checks before declaring readiness.
7. **Run conditional integrity work**:
   - routing/shell/generated-block or structure/path changes → follow `maintain-docs.md` Step 6 and the repository's sync/smoke commands;
   - rule/reference meaning changes → search workflows for repeated invariants and reconcile them in the same change;
   - durable knowledge migrated/deleted/superseded → prove destination, owner, normal activation path, fitted validation, and intentionally unretained content before removing the legacy source; use the existing Plan/migration record rather than creating a mandatory ledger;
   - high-risk route, non-idempotent workflow, executable script contract, or external handoff → add/adjust a behavior contract only when structural checks cannot prove it.
   - database-structure change → verify the confirmed schema-impact checkpoint and dedicated SQL sibling against the Plan Feature gate: authoritative baseline/dialect, complete target and forward update agreement, data treatment, read-only proof, honest rollback/recovery, and the project-owned execution/authorization boundary; SQL-file existence alone is neither schema readiness nor DB delivery.
8. **Declare readiness** — only after Steps 1–7 pass, name the already-authorized delivery action, expected artifact, and exact verification. `Ready for Delivery` is a checkpoint, not task completion.

### Delivery and Completion Gate

Closure never grants commit, push, MR, deploy, publish, or other side-effect authority. The matched workflow or harness performs only the delivery already authorized by the user, while Closure remains open.

- Verify the requested artifact rather than inferring it from a local precursor: inspect the commit/ref, remote branch, MR/PR URL and state, deployed runtime, published file, or other promised result.
- When DB delivery was requested, verify the project-owned migration/version artifact and authoritative schema/data readback; do not infer it from a reviewed SQL sibling or application build.
- A failed, blocked, or unverified delivery leaves Closure open. Retry an external-only failure without rerunning unrelated local checks only when source content, relevant evidence, branch/config inputs, and the delivery premise are unchanged; otherwise return to fitted verification or Task Execution.
- When no external delivery was requested, the verified result and final response are the delivery artifact.
- Mark `Closure Complete` and report honestly only after every requested delivery artifact is verified; name any remaining risk without self-certifying beyond the checks run.

### Post-Completion Workflow Distillation

Evidence normalization and owner classification may happen during execution, but proposal presentation may happen only after `Closure Complete`, with the completion report first. This optional follow-up is not a Closure gate. Blocked, paused, stopped, or unverified work produces no proactive question; an explicit user switch to retrospective or workflow design may discuss it earlier.

Require at least two independently completed instances with the same reusable goal, ordered stage relations, inputs/outputs, integrated acceptance, and authority checkpoints. They may occur in the same Session or across tasks/Sessions. Retries or repeated substeps inside one unfinished delivery count once; temporal adjacency, frequency, or command/tool similarity does not qualify. Variable values remain parameters; a non-universal stage becomes a branch only when its applicability is proven. Use current/relevant history and the smallest targeted retrieval needed to prove or falsify a plausible second instance; never scan all history or create a signature store, candidate ledger, counter, timeline, route, or placeholder.

Inspect existing owners and choose one conclusion: `extend` when an owner of the same result is incomplete; pure `compose` when complete owners need no durable route, hook, state, authorization, or integrated-acceptance owner; `create` only for an independently reusable cross-step contract with no owner. Pure composition produces no proposal. Otherwise present only the concrete repeat evidence, compact goal/flow, one recommendation, canonical-owner-to-downstream path, material parameters/branches/authority boundaries, and one consent question.

A decline or defer creates no durable candidate/rejection record and suppresses the same normalized proposal for the current Session. Re-prompt only after materially stronger evidence or explicit user reopening. Acceptance starts a newly routed task through [`workflows/rule-update/workflow-distillation.md` § Accepted Workflow-Distillation Input](rule-update/workflow-distillation.md#accepted-workflow-distillation-input) without redundant reconfirmation; it does not grant commit, push, MR, deploy, publish, database, work-item, version-revision, reviewer-selection, merge, or other external authority.

### Rationalizations to Reject

| Rationalization | Reality |
|---|---|
| “The change is small.” | Behavior/structure is the trigger; read-only work is already exempt. |
| “Tests passed earlier.” | A completion claim requires fresh evidence after the final edit. |
| “I will reconcile links/rules later.” | The decision context will be gone; do it in the same change. |
| “I can mention the mainline drift in the final report.” | First disclosure at Closure is too late. Pause the affected path and consult the user when drift is discovered. |
| “The file exists and smoke is green.” | Reachable structure can still be inert; state the next action it changes. |
| “I can record this proven failure in the final AAR.” | Repair-time evidence is freshest. Run Verified Failure Input after red-to-green proof; Closure only checks the outcome. |
| “The command exited 0, so the stage is complete.” | A successful exit code proves only the command's own contract. If it does not resolve the step's question, validate target behavior, or produce evidence consumed by the next step, return to Task Execution. |
| “I should add a safeguard just in case.” | No concrete recurring failure means no new mechanism. |
| “The branch was pushed, so the requested MR probably exists.” | A local or remote precursor is not delivery evidence; verify the actual requested artifact. |
| “A login/network retry means I must rerun every local test.” | If inputs and verified content are unchanged, retry and verify only the blocked delivery boundary. |

### Red Flags

- claiming “done/should pass” without reading a fresh exit code, or treating that exit code as sufficient completion evidence by itself;
- claiming completion from `Ready for Delivery` or from an unverified precursor such as a pushed branch;
- recording by appending instead of reconciling the existing concept;
- reaching Closure with a verified failure that lacks a completed learning outcome or action-changing activation;
- creating a file/index with no independently selected task path;
- treating optional delegation or future infrastructure as a completion requirement.

## After-Action Review

Ask only after Trigger Policy admits the task:

1. Did this reveal a repeatable costly pattern not obvious from code?
2. Did a missing rule or activation path cause a wrong turn?
3. Did an existing rule become inaccurate, obsolete, duplicated, or inert?
4. Did an external fact materially affect the decision and need scoped re-verification guidance?

Any yes -> apply [`workflows/rule-update/knowledge-reconciliation.md`](rule-update/knowledge-reconciliation.md), which consumes the shared fidelity, reconciliation, activation, and durability contract. Verified failures were already handled through their earlier input and are not counted again. Otherwise do not create a record.
