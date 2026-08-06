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
2. **Run conditional Plan/Knowledge reconciliation** — for Design-derived, business-bearing, knowledge-changing, or Composite Plan work, read [`plan-knowledge-closure.md`](../protocol-blocks/plan-knowledge-closure.md) and consume its `pass / return / blocked` evidence. It owns Component-first reconciliation, mainline/Decision Delta replay, business-leaf fidelity, Plan Leaf and Requirement Provenance checks, Knowledge Reciprocity, and `distilled_to:` calibration; it cannot declare readiness or completion.
3. **Verify with fresh, fitted evidence**:
   - bind each material risk to the cheapest evidence that can falsify it and state the stop/escalation condition before running checks;
   - targeted command/test/typecheck first;
   - runtime/service/browser evidence only for wiring, config, permissions, serialization, data state, or UI behavior;
   - packaged/release/deploy evidence only when that chain changed or the user requires it.
   Stop when the bound evidence proves the contract; escalate only when a check fails, the risk crosses another boundary, or a stated uncertainty remains. Test count is not evidence quality. A fresh command against a stale artifact is not fresh evidence.
4. **Account for verified failures** — enumerate every command, test, runtime, delivery, or premise failure whose root cause was proven during the task. Each must already have one completed [`workflows/rule-update/verified-failure.md` § Verified Failure Input](rule-update/verified-failure.md#verified-failure-input) learning outcome and, for a durable write, an action-changing activation path. If diagnosis, repair proof, outcome, or activation is missing, return to Task Execution or Verified Failure; Closure does not diagnose root cause or postpone the first write. Re-run affected verification when learning changed a deliverable.
5. **Run the AAR below.** Any yes enters [`workflows/rule-update/knowledge-reconciliation.md`](rule-update/knowledge-reconciliation.md); all no stops additional recording. Do not re-record an already-reconciled verified failure. If recording changes any deliverable, return to the affected verification and integrity checks before declaring readiness.
6. **Run conditional integrity work**:
   - routing/shell/generated-block or structure/path changes → follow `maintain-docs.md` Step 6 and the repository's sync/smoke commands;
   - rule/reference meaning changes → search workflows for repeated invariants and reconcile them in the same change;
   - durable knowledge migrated/deleted/superseded → prove destination, owner, normal activation path, fitted validation, and intentionally unretained content before removing the legacy source; use the existing Plan/migration record rather than creating a mandatory ledger;
   - high-risk route, non-idempotent workflow, executable script contract, or external handoff → add/adjust a behavior contract only when structural checks cannot prove it.
   - database-structure change → verify the confirmed schema-impact checkpoint and dedicated SQL sibling against the Plan Feature gate: authoritative baseline/dialect, complete target and forward update agreement, data treatment, read-only proof, honest rollback/recovery, and the project-owned execution/authorization boundary; SQL-file existence alone is neither schema readiness nor DB delivery.
7. **Declare readiness** — only after Steps 1–6 pass, name any already-authorized delivery action, expected artifact, and exact verification. `Ready for Delivery` is a checkpoint, not task completion.

### Delivery and Completion Gate

Closure never grants commit, push, MR, deploy, publish, or other side-effect authority. The matched workflow or harness performs only the delivery already authorized by the user, while Closure remains open.

- When the user requested an external/shared-system artifact, read [`external-delivery-verification.md`](../protocol-blocks/external-delivery-verification.md) and consume its `verified / blocked / stale / premise-changed` result. The protocol verifies the artifact but cannot grant authority or declare completion.
- When no external delivery was requested, the verified local result and final response are the delivery artifact.
- Task Closure alone marks `Closure Complete`, and only after every required local and conditional proof has passed and every requested artifact is verified. Name residual risk without self-certifying beyond the checks run.

### Post-Completion Workflow Distillation

Only after `Closure Complete`, and only when a plausible repeated-procedure signal already exists, read [`workflow-distillation-proposal.md`](../protocol-blocks/workflow-distillation-proposal.md). This optional follow-up owns evidence normalization and the `extend / compose / create` recommendation; it is not a Closure gate, completion state, mutation authority, or delivery authority.

### Rationalizations to Reject

| Rationalization | Reality |
|---|---|
| “The change is small.” | Behavior/structure is the trigger; read-only work is already exempt. |
| “Tests passed earlier.” | A completion claim requires fresh evidence after the final edit. |
| “I will reconcile links/rules later.” | The decision context will be gone; do it in the same change. |
| “The file exists and smoke is green.” | Reachable structure can still be inert; state the next action it changes. |
| “The command exited 0, so the stage is complete.” | A successful exit code proves only the command's own contract. If it does not resolve the step's question, validate target behavior, or produce evidence consumed by the next step, return to Task Execution. |
| “I should add a safeguard just in case.” | No concrete recurring failure means no new mechanism. |

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
