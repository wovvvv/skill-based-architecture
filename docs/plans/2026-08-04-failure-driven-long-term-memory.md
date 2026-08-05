---
date: 2026-08-04
status: done
distilled_to:
  - templates/skill/workflows/task-execution.md
  - templates/skill/workflows/update-rules.md
  - templates/skill/workflows/fix-bug.md
  - templates/skill/workflows/task-closure.md
  - references/protocols.md
  - docs/sba-bible.md
---

# Plan: Failure-Driven Long-Term Memory

> Current conclusion: every verified failure must close with a repair and learning outcome, while durable project knowledge codifies repeated root-cause patterns and activates prevention before the next relevant action instead of accumulating raw error history.

## Problem And Scope

SBA currently has strong completion-time AAR and knowledge-recording gates, but reusable engineering lessons normally wait until Task Closure. A failed command or test causes Task Execution to reconsider the current step, yet no mandatory bridge carries the proven root cause into knowledge reconciliation immediately after red-to-green repair.

This gap has produced repeated failures even when a similar lesson already exists. Legacy Mockito/ByteBuddy incompatibility with newer JDKs, stale strict stubs after an implementation branch changes, full Controller dependency injection for a narrow unit path, duplicate Mockito/non-Mockito regression coverage, and stale Surefire evidence all show the same product failure: stored knowledge does not help unless the next relevant task reaches it early enough to change construction or verification behavior.

This Plan defines failure-driven learning for code, tests, scripts, workflows, generated surfaces, and Agent execution mistakes. It does not create an error database, chronological failure log, telemetry service, automatic global-memory promotion, or a guarantee that changing environments can never produce a similar symptom again. It guarantees the repair and learning process that must complete before the task can close.

This Plan is independent from `docs/plans/2026-08-04-default-downstream-simplification/prd.md`. Either Plan can complete, freeze, and be consumed without the other, so neither is `subplan_of` the other. Their implementation may later share existing Task Execution, Rule Update, and Closure owners without creating a composite Plan unless integrated delivery develops separate persistence pressure.

## Pre-Implementation Evidence Baseline

- `templates/skill/workflows/fix-bug.md` currently sends reusable engineering lessons to normal final Closure/AAR even after root-cause and red-to-green proof exist.
- `templates/skill/workflows/task-execution.md` reruns its Anchor Checkpoint after a failed check or surprising premise change but owns no durable knowledge reconciliation.
- `templates/skill/workflows/task-closure.md` asks the AAR questions only at completion time.
- `templates/skill/workflows/update-rules.md` already owns threshold, fidelity, reconciliation, activation, durability, and recurrence-to-machine-gate graduation; the missing behavior is a mandatory failure-time trigger and Closure accounting.
- `aii-flow` already separates iteration, personal, and team promotion, with higher-scope promotion explicitly initiated and team promotion reviewed through an MR. This is a destination boundary, not authority to auto-globalize project failures.
- Prior task evidence contains repeated variants of the same Mockito/JDK and stale-test root causes despite those lessons being stored, proving that additional storage without earlier activation is insufficient.

## Current Decisions

### D1 - Every verified failure receives a repair and learning outcome

When a command, test, runtime check, delivery action, or implementation premise fails, the Agent keeps a session-only failure candidate. It must prove the root cause, repair the current task, and obtain fitted verification before treating the diagnosis as durable knowledge. Once proof exists, it immediately reconciles the prevention into the correct existing owner and activates it for the next applicable task. Before Closure, every verified failure receives one explicit learning outcome; an unclassified verified failure blocks task completion.

- Trigger: the user requested that every error automatically lead to repair so the next task does not continue making the same mistake.
- Faithful answer: `可以做`.
- Authority: user-confirmed.
- Normative meaning: automatic repair guarantees a mandatory process, not an impossible promise that all future environment/code changes can never produce a similar symptom. Evidence and ownership facts are resolved by the Agent; ask the user only for remaining normative meaning, scope, promotion authority, or a materially costly prevention gate.
- Agent-derived consequences: do not persist the first error hypothesis; durable reconciliation begins immediately after root-cause proof and red-to-green evidence. Closure must account for every verified failure using a bounded outcome such as covered/no-write, extend, correct, add-and-activate, transient/no-write, user-authority-required, or machine-gate escalation.
- Evidence / Source: current conversation; current Task Execution, Fix Bug, Rule Update, and Task Closure owners.

### D2 - Long-term knowledge codifies repetition, not raw error history

The purpose of long-term memory is to turn repeated failure patterns into active project behavior. Do not append every raw error message, command failure, retry, or incidental environment interruption. Reconcile by proven root cause and prevention boundary, then prescribe the smallest action that must change next time.

- Trigger: after confirming the capability, the user clarified its responsibility.
- Faithful answer: `我们就是为了把重复的东西规定下来`.
- Authority: user-confirmed.
- Normative meaning: repeated knowledge becomes a rule, Gotcha, workflow check, testing convention, activation hook, or fitted executable gate. Different symptoms sharing one root cause remain one concept; identical text with different causes remains separate.
- Scope: repository/project engineering knowledge by default. Iteration-only, personal, and team promotion retain their existing authority boundaries; team-wide rules are not silently created from a project failure.
- Agent-derived consequences: search and reconcile before writing; repair a missing activation path before adding another record; do not create a second memory store or chronology. A repeated miss after an already active record increases prevention strength and may graduate to a scoped machine gate.
- Evidence / Source: current conversation; `update-rules.md` reconciliation and activation gates; `aii-flow` promotion boundary.

### D3 - Recurrence identity is root-cause and prevention based

Two failures are the same repeated pattern when they share the same proven root cause, applicability boundary, and prevention action. Raw error text is candidate-search evidence only. Different messages may belong to one pattern, while identical text with different causes remains separate.

- Trigger: the Agent proposed a precise recurrence identity and counting boundary after the user required repeated things to become rules.
- Faithful answer: `ke` (confirmation in context).
- Authority: user-confirmed.
- Normative meaning: retries and failed approaches inside one unresolved task count as one occurrence. An independent recurrence is a separately verified occurrence in another closed task, Session, branch, version, Agent/developer path, or a current occurrence whose root cause is already covered by applicable historical knowledge. Existing proven history can satisfy the prior-occurrence requirement immediately.
- Mandatory graduation: the first proven actionable occurrence already becomes active prevention under D7. An independent recurrence must first prove whether that prevention was reached early enough to change the action. Repair missing/weak activation before adding prose; if the task reached the prevention and still repeated the mistake, strengthen it toward a scoped executable gate.
- Boundary: three retries in one failing Maven run are not three recurrences. A broad label such as `NullPointerException`, `Mockito failure`, or `test failed` is not a root cause and cannot own prevention.
- Evidence / Source: current conversation; prior independent Mockito/JDK and strict-stub failures; `update-rules.md` same-root-cause reconciliation and machine-gate graduation behavior.

### D4 - Automatic machine gates stay local, reversible, and within authority

After applicable written prevention still fails, the Agent may automatically strengthen it only inside the already authorized task and repository scope when the gate is local, low-cost, reversible, uses existing project tooling/dependencies, has fitted regression proof, and retains a scoped escape path. Recurrence does not expand delivery or external-operation authority.

- Trigger: the Agent proposed the operation-by-target authorization boundary for executable prevention.
- Faithful answer: `可以`.
- Authority: user-confirmed.
- Automatic scope: targeted regression tests, reuse or tightening of existing test helpers, a scoped preflight in the triggering workflow, route/activation repair, or a non-shared local validation command when all conditions above hold.
- Approval-required scope: adding/changing CI, pre-commit, hooks, server-side enforcement, default shared build/test commands, hard-failure policy, dependencies/plugins/services, cross-repository or team rules, public/external contracts, non-local/shared state, difficult rollback, or materially increased routine cost.
- Approval checkpoint: state the proposed gate and target, routine cost, blast radius, reversal, scoped escape path, and lighter alternative. Do not ask the user to rediscover the technical root cause.
- Boundary: failure recurrence never grants commit, push, MR, deploy, publish, database, production, or external-system authority. Existing task and delivery authorization remains controlling.
- Evidence / Source: current conversation; `references/permission-model.md`; Change Discipline; Task Closure delivery authority; Anti-Templates mechanism admission.

### D5 - First-occurrence value uses the existing threshold, not a ledger (superseded by D7)

SBA does not create a first-occurrence candidate ledger, occurrence counter, timestamp log, or error database. A first proven failure is codified and activated immediately when at least two of `likely repeatable`, `costly`, and `not obvious` pass. A failure that does not pass receives an explicit no-write outcome. Any independent evidence of a prior same-root-cause occurrence makes codification mandatory.

- Trigger: technical owner review showed that a Session-only first occurrence cannot later prove recurrence without another durable store.
- Faithful answer: `可以`.
- Authority: user-confirmed.
- Normative meaning: value-bearing prevention may begin on the first occurrence; actual recurrence is a mandatory floor, not the only admission path. Independent evidence may come from an applicable existing record, another closed task/Plan, repository history, user-provided history, or another verified source. No numeric counter is required.
- Agent-derived consequences: reuse `update-rules.md` Recording Threshold; do not add lifecycle, retirement, deduplication, or user-facing concepts for unpromoted candidates. Rejected hypotheses and low-value incidents remain Session-only and disappear after their classified no-write outcome.
- Evidence / Source: current conversation; `update-rules.md` Recording Threshold and no-chronological-log boundary; the confirmed no-Memory-subsystem scope.

- Status: superseded by D7 after the user clarified that the first proven actionable lesson must be written directly to its correct owner rather than waiting for a value threshold or later recurrence.

### D6 - Existing lifecycle owners compose failure learning

No new Memory route, subsystem, database, workflow file, or default Always Read surface is created. Existing owners compose the capability with one complete semantic owner and thin lifecycle hooks.

- Status: architecture-derived from current owner contracts.
- Task Execution owns Session-only failure candidates, failed-premise reclassification, and the handoff after root-cause plus red-to-green proof. A formerly Simple task that now requires diagnosis or repeated repair becomes Managed rather than continuing invisible retries.
- Rule Update owns the complete durable contract: verified-failure admission, direct first-occurrence reconciliation, root-cause recurrence identity, lifecycle and storage outcomes, destination, fidelity, activation, recurrence graduation, machine-gate authority, and retirement/correction.
- Fix Bug keeps the immediate local hook after its red-to-green step and no longer defers reusable engineering lessons only to final AAR. Other modifying workflows rely on Task Execution for generic failure candidates and keep their existing Task Closure hook; they do not copy the complete learning procedure.
- Task Closure owns final accounting: every verified failure encountered by the integrated task has one completed outcome; any durable write has an action-changing activation path and fresh verification. Closure returns incomplete execution/learning to the owning workflow and does not resolve root cause itself.
- The SBA Bible and operating protocol summary preserve the product boundary; conformance manifests and self-scenarios protect unique ownership and thin hooks. `aii capture/promote` remains an optional higher-scope destination when available, never a default downstream runtime dependency.
- Evidence / Source: current `task-execution.md`, `update-rules.md`, `fix-bug.md`, `task-closure.md`, `references/protocols.md`, conformance manifests, and self-scenario harness.

### D7 - The first proven actionable failure writes directly to its canonical owner

The first time a failure has a proven root cause, a completed repair, fitted red-to-green evidence, and a prevention action that can change a future task, the Agent immediately writes or reconciles that prevention in the place where it already belongs. It does not wait for a second occurrence, a later AAR, or a separate promotion queue, and it does not create an intermediate failure record.

- Trigger: after approving implementation, the user clarified the expected first-occurrence behavior with the example that a test proven to require JDK 8 should record that constraint automatically so the next applicable test selects JDK 8 before execution.
- Faithful answer: `第一次发现是单测必须用jdk8导致报错,那么就会自己记录下来(类似aar),然后下一次就会自动用jdk8了,同理别的地方也是一样的`.
- Authority: user-confirmed.
- Normative meaning: the destination is the nearest canonical rule, Gotcha, workflow check, convention, technical reference, or existing executable gate that owns the prevention. The same change must activate that owner before the next mistake-prone action; a write that future tasks do not reach is incomplete.
- No-write boundary: rejected hypotheses, unresolved causes, ordinary retries, one-off command typos, and transient external/environment failures with no stable future action remain Session-only and receive `transient/no-write` or `covered/no-write`. This boundary is evidence-based, not a two-of-three value threshold.
- Scope and authority: project-local prevention may be written automatically within the authorized repository task. Personal/team promotion and materially costly or shared machine gates retain D4 and `aii-flow` approval boundaries.
- Evidence / Source: current conversation; D1 red-to-green proof; D2 pattern-not-history boundary; `update-rules.md` canonical-owner reconciliation and activation gates.

## Requirements And Acceptance

- A failed check creates only session state until the root cause is proven; rejected hypotheses and ordinary retries never become durable memory.
- Red-to-green verification must establish that the proposed cause and repair explain the failure before durable reconciliation runs.
- A first proven failure with a stable prevention action is reconciled directly into its canonical owner and activated immediately; it does not wait for a threshold, second occurrence, later AAR, or intermediate candidate artifact.
- A failure receives no durable write only when the cause is unproven or no stable future action exists, such as a transient external interruption or one-off command typo.
- Independent evidence of a prior same-root-cause occurrence triggers an activation audit and prevention-strength review without a counter or ledger.
- Reconciliation searches the nearest existing rule, Gotcha, workflow, technical reference, and activation hook before adding content.
- Every verified failure ends as exactly one of: existing coverage/no write, extend existing, correct existing, add and activate, transient/no durable write, requires user authority, or escalate prevention.
- Repeated symptoms sharing a root cause and prevention action update one semantic owner rather than creating parallel entries.
- A durable record must name its applicability boundary, root cause, tempting wrong action, required next action, and fitted verification strongly enough for a fresh Agent to make the same judgment.
- Project knowledge must be activated on the normal task path before the mistake-prone action, not merely linked from an inert reference.
- A repeated failure caused by missing or weak activation repairs the activation path before creating more prose.
- A failure that recurs after an applicable active record triggers consideration of a scoped executable preflight, test helper, lint, validation script, or CI gate; structural cost and escape behavior remain explicit.
- User consultation is limited to intended behavior, normative applicability, promotion to personal/team policy, or authorization for a materially costly/wide machine gate. The Agent does not ask the user to identify current root cause, code owner, duplicate coverage, or framework compatibility facts available from evidence.
- Iteration and personal promotion may use `aii capture/promote`; team promotion remains explicit and MR-reviewed. Project-local knowledge defaults to the project's active Skill owners.
- Task Closure cannot complete while an encountered verified failure lacks a learning outcome or while a durable write lacks an action-changing activation path.
- No database-structure change is involved.

## Current To Target Design

| Surface | Current | Target |
|---|---|---|
| Failed execution | Task Execution rechecks the Anchor/premise; Simple tasks may retry without durable-learning state | Keep one Session-only failure candidate; unresolved diagnosis reclassifies Simple -> Managed; proven red-to-green repair hands the candidate to Rule Update |
| Bug-fix engineering lesson | Reusable engineering lessons wait for final Closure/AAR | Fix Bug invokes the verified-failure input immediately after repair proof while preserving the user-content-only business boundary |
| Durable knowledge | Rule Update records lessons selected by Closure/user/Plan, with threshold/reconciliation/activation gates | Rule Update additionally owns verified-failure outcomes, direct first-occurrence reconciliation, recurrence identity, activation repair, and machine-gate authority |
| Completion | Closure runs AAR and conditional recording but does not account for every failure seen during execution | Closure rejects any verified failure without a completed outcome and re-verifies deliverables changed by learning |
| Activation | A record must declare an action-changing path, but recurrence is not explicitly tied to activation repair | A recurrence first tests whether the prevention was reached; missing/weak activation is repaired before prose or machine-gate growth |
| Enforcement | A repeated active landmine may graduate to a machine gate | Graduation follows D4's local/reversible automatic boundary and approval checkpoint for shared/costly/external gates |
| Persistence | No failure-specific store exists | Still no failure-specific store; active project owners hold durable prevention, while unproven or transient failures disappear after their Session outcome |

## Risks And Controls

- **Wrong-root-cause persistence:** the first hypothesis becomes a permanent rule. Control: no durable reconciliation before root-cause evidence and red-to-green proof; rejected hypotheses remain Session-only.
- **Memory pollution:** every command error creates a record. Control: D7 requires proven root cause plus a stable future action, preserves explicit transient/covered no-write outcomes, reconciles before add, and creates no candidate ledger.
- **Duplicate rules:** different symptoms create parallel entries. Control: D3 identity plus mandatory same-root-cause reconciliation in Rule Update.
- **Stored but inert knowledge:** the record exists but the next test task never reads it. Control: activation before the mistake-prone action, recurrence-first activation audit, and Closure proof of the changed next action.
- **Gate creep:** each recurrence adds scripts, hooks, or CI. Control: D4 authority/cost boundary, mechanism admission evidence, earliest triggering tool, and scoped escape path.
- **User interruption cost:** ordinary technical facts are repeatedly escalated. Control: ask only for normative meaning, scope/promotion authority, or approval-required gates; current root cause and owner remain Agent-discoverable.
- **Cross-scope leakage:** project-specific Mockito behavior becomes universal/team policy. Control: project Skill default destination and explicit iteration/personal/team promotion boundaries.
- **Semantic duplication:** task workflows copy the complete learning algorithm. Control: Rule Update owns the full procedure; Task Execution, Fix Bug, and Closure retain only trigger/input/output/acceptance hooks protected by conformance.

## Task Interfaces

### T1 - Capture verified failure state during execution

- Files: `templates/skill/workflows/task-execution.md`.
- Consumes: D1, D3, D7; current Task Anchor and failed-check evidence.
- Produces: Session-only failure candidate, Simple -> Managed reclassification boundary, root-cause/red-to-green handoff to Rule Update.
- Acceptance: retries do not become recurrence; rejected hypotheses are not persisted; a proven failure cannot disappear before receiving a learning outcome.

### T2 - Make Rule Update the complete durable owner

- Files: `templates/skill/workflows/update-rules.md`, `references/protocols.md`.
- Consumes: T1 candidate plus D1-D4 and D7.
- Produces: verified-failure input, bounded outcomes, D7 direct first-occurrence reconciliation, D3 recurrence matching, activation repair, D4 machine-gate graduation, and operating summary.
- Acceptance: no chronology/counter/database; same-root-cause entries reconcile in place; only failures without a proven stable future action stop at no-write; user questions remain authority-scoped.

### T3 - Add thin lifecycle hooks and product boundary

- Files: `templates/skill/workflows/fix-bug.md`, `templates/skill/workflows/task-closure.md`, `docs/sba-bible.md`, and only other consumers whose current wording contradicts the new owner.
- Consumes: T1-T2 contracts.
- Produces: immediate post-red-to-green engineering-learning hook, Closure outcome accounting, stable activation-over-storage product rule, and no duplicated complete procedure.
- Acceptance: business meaning is still never derived from a Bug; Closure does not finish root-cause work; ordinary workflows do not preload or restate the full learning contract.

### T4 - Lock ownership and behavior with conformance/scenarios

- Files: `templates/skill/conformance.yaml`, `references/self-hosting-conformance.yaml`, `scripts/check-self-scenarios.sh`.
- Consumes: T1-T3 final wording.
- Produces: owner/hook assertions and transcript-shaped failure-learning scenarios.
- Acceptance: checks fail if Rule Update loses complete ownership, consumers copy its procedure, first failures create a ledger, retries count as recurrence, activation repair is skipped, or shared gates bypass approval.

### T5 - Reconcile delivery documentation and Closure

- Files: `UPSTREAM-CHANGES.md`, this Plan, and any directly affected generated/self-hosting documentation proven by T1-T4.
- Consumes: implementation and fresh validation evidence.
- Produces: downstream adaptation guidance, truthful `distilled_to`, final Plan status, and verified Task Closure.
- Acceptance: full Bucket A validation is green; no new route/store/default Always Read surface exists; no downstream adaptation, commit, push, MR, deploy, or external operation is inferred without separate authorization.

## Validation Scenarios

1. **Transient first failure:** a one-off local command typo is repaired, classified no-write, and creates no durable candidate.
2. **Actionable first failure:** a proven project test/JDK incompatibility is written directly to the canonical testing owner, activated before runtime selection, and causes the next applicable test task to choose the required JDK before execution.
3. **Retries inside one task:** three attempts against one unresolved Maven failure count as one occurrence and force diagnosis/reclassification, not three records.
4. **Different messages, same root cause:** ByteBuddy, Mockito initialization, and proxy-generation symptoms reconcile into one applicable prevention when cause/action match.
5. **Same text, different causes:** two `NullPointerException` failures with different owners and prevention remain separate.
6. **Independent recurrence:** prior task/history evidence plus a new same-root-cause occurrence audits whether the existing prevention was reached and strengthens activation or enforcement without a counter.
7. **Rule existed but was missed:** recurrence repairs routing/workflow activation and does not append a duplicate Gotcha.
8. **Rule was reached but ignored:** recurrence graduates to a local reversible gate when within D4, with fitted proof and escape path.
9. **Shared-gate escalation:** a proposed CI hard failure or new dependency stops at the D4 approval checkpoint.
10. **Business boundary:** a Bug-derived technical lesson enters a Gotcha/workflow, while desired business truth changes only from explicit authority.
11. **Subagent boundary:** a worker reports a candidate; the main Agent proves/integrates it and Rule Update/Closure decide persistence once.
12. **Closure accounting:** an integrated task with one unclassified verified failure cannot complete; after reconciliation and re-verification it can.
13. **No subsystem:** routing, required files, and generated surfaces contain no new Memory route, failure ledger, counter, database, or default Always Read item.

## Implementation Evidence And Closure

- `task-execution.md` now owns one Session-only failure candidate, retry-as-one-occurrence behavior, Simple -> Managed reclassification, and the proven root-cause/repair/red-to-green handoff.
- `update-rules.md` owns the complete Verified Failure Input: direct first proven actionable write, seven lifecycle outcomes, root-cause recurrence identity, activation repair, machine-gate admission, promotion scope, and unchanged delivery/external authority.
- `fix-bug.md` invokes engineering learning immediately after red-to-green proof without deriving business truth from Bug evidence. `task-closure.md` accounts for completed outcomes, rejects deferred first writes, and keeps final AAR for additional lessons only.
- `references/protocols.md`, Bible principle 13, `UPSTREAM-CHANGES.md`, both conformance manifests, and self-scenarios preserve the owner split, downstream adaptation boundary, and no-subsystem rule.
- Targeted verification passed: self-scenarios `463/463`, downstream template conformance `485/485`, self-hosting conformance `332/332`, and `git diff --check`.
- Full Bucket A verification passed twice after final semantic edits: `bash scripts/check-all.sh --base HEAD` ended with `All upstream maintenance checks passed` and exit code `0`.
- Execution-time exact-anchor drift was repaired by synchronizing existing conformance assertions and classified `covered/no-write`; the existing gate already provided the prevention. Unavailable desktop-terminal readback was classified `transient/no-write`; the suite was re-run with bounded `pipefail` output to obtain authoritative exit evidence.
- Final AAR found no additional unowned lesson. The recurring product failure is absorbed by the active lifecycle owners and their activation/conformance paths; no failure ledger, counter, chronology, Memory route/store, default Always Read item, downstream change, personal/team promotion, commit, push, MR, deploy, database write, or external operation was created or inferred.

## Open Questions

None.
