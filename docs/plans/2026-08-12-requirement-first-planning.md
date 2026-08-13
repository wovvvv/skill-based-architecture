---
date: 2026-08-12
status: done
distilled_to:
  - docs/sba-bible.md
  - templates/skill/protocol-blocks/change-contract.md
  - templates/skill/workflows/plan-feature.md
  - templates/skill/workflows/task-execution.md
  - templates/skill/workflows/change-managed.md
  - templates/skill/SKILL.md.template
  - templates/skill/SKILL.routed.md.template
  - templates/skill/SKILL.single.md.template
  - templates/skill/scripts/sync-routing.sh
  - references/self-hosting-shell-base.md
  - references/protocols.md
  - docs/plans/_TEMPLATE.md
  - docs/plans/README.md
  - docs/task-anchor-native-plan.md
  - templates/skill/conformance.yaml
  - references/self-hosting-conformance.yaml
  - scripts/check-self-scenarios.sh
  - scripts/check-validation-contract.sh
  - UPSTREAM-CHANGES.md
---

# Plan: Requirement-First Planning And Feature Intake

> Current conclusion: complete the requirement as the governing target before
> deriving implementation steps, require every request that adds or changes
> user-visible behavior, business flow/state, or an external contract to receive
> at least a Session Native Plan, and keep durable Plan files conditional on
> real persistence pressure rather than apparent size.

## Problem And Scope

SBA already has a runtime Change Contract, Task Anchor, Native Plan, Plan
Feature workflow, and Artifact Pressure Gate. The owners are individually
sound, but their entry conditions leave a gap:

- the thin-shell fast path says that one clear action/check may execute
  directly before Task Execution is read;
- Task Execution defines Simple mainly by execution shape and drift room;
- Plan Feature emphasizes unresolved design choices;
- Change Managed lets an explicit request take the Change Contract fast path.

Together, those clauses can classify a syntactically concrete product request
as implementation-ready merely because it sounds local. The request may still
carry scope, ordering, interaction, count, preservation, and acceptance
semantics that must govern implementation.

The reported incident is:

> “如果我发在迭代/版本/hotfix的缺陷tab，新增按状态分组筛选的功能，状态需要按推进顺序排。例如：待解决(5) 重新打开(2) 待验证(7) 已修复(3) .. 这个,你直接花了一个小时时间帮我写代码了,但是这个理论上是一个需求,那么为什么没有建plan呢,因为你觉得太小了吗?”

The original task transcript was not located by exact or bounded variant search,
so this Plan does not claim that no hidden Native Plan existed. The user report
is authoritative evidence that planning was not visible or sufficient. The
closest repository evidence also proves the behavior family is not inherently
local: `chaos_web` commit
`1bdafc61144bbad53711b95a5f8503faa33ca9ac` changed 17 files and bound
`statusGroup`, pagination, filters, list state, and defect interactions across
product-build surfaces. That evidence supports reclassification pressure; it is
not presented as the missing transcript.

This Plan changes generic upstream SBA semantics and activation. It does not
modify the historical Chaos implementation, create a requirement database,
force a repository Plan file for every change, or authorize commit, push, MR,
assembly, deploy, publish, database, or downstream writes.

## Current Decisions

### D1 - Requirement is the target; Plan is the means

The requirement owns the desired observable outcome, normative scope,
preserved behavior, boundaries, and acceptance. The Plan is a revisable path
for producing that outcome. A Plan may change when implementation evidence
changes owner, order, risk, or proof; it cannot silently redefine the
requirement to fit the current code or an earlier step list.

For requirement-bearing work, Task Anchor `Goal` and `Done When` derive from the
requirement. Native Plan steps derive from the matched Workflow and are only
the current means. If evidence changes desired meaning, return to requirement
formation and the applicable user-decision gate before replanning.

**User source:**

> “我们写plan的时候,是先要完成需求,然后再指定计划,这个是重点,需求是目标,计划是手段,这个跟我们的task archar 是有异曲同工之妙的,我也希望能让我们的plan更准确”

- Authority: user-confirmed.
- Scope: SBA planning, Task Anchor/Native Plan derivation, and feature intake.

### D2 - Product behavior changes cannot be Simple by apparent locality

Any request that adds or changes user-visible behavior, a business flow/state,
or an external contract must first pass the existing Change Contract's semantic
readiness check and is at least Managed execution. This includes a very clear
one-sentence request. Clear wording can close readiness immediately without a
question; it cannot remove the Native Plan.

The trigger is requirement-bearing semantics, not elapsed time, file count,
tool count, estimated effort, code locality, or whether the Agent initially
believes the implementation is easy.

The Simple fast path remains for one clear read-only or maintenance action that
does not create new desired behavior: for example, an obvious typo, a bounded
style correction whose expected behavior is already fixed, or a known-owner
repair that restores an existing contract with one direct check.

### D3 - Reuse `semantic-ready` as `requirement-ready`

No second requirement state machine is introduced. For requirement-bearing
changes, the existing Change Contract's `semantic-ready` state is also called
`requirement-ready`: activated meaning is concrete enough to reject a wrong
result and no unresolved user-owned choice about authority, scope, preservation,
permission, or acceptance can redirect the work.

Actor, trigger, scope, observable behavior, ordering, counts, interaction,
defaults, preservation, failure behavior, and acceptance are examples of
activated dimensions, not a universal questionnaire. The Agent inspects only
dimensions the request and evidence make decision-bearing.

For the reported defect filter, the explicit scope and display ordering are
already authoritative. Status membership, count source, selection semantics,
default/empty behavior, pagination interaction, and shared ownership are
investigated from product/code evidence and asked only when a remaining
normative choice could redirect the result.

### D4 - Every requirement gets logical planning; only pressured work gets a file

After `requirement-ready`, every requirement-bearing change derives a concise
Native Plan before mutation. A small clear feature may have only a few steps,
but those steps remain visible in the harness Plan surface and are checked
against the requirement.

A durable repository Plan is still created only when the user explicitly asks
for one or Artifact Pressure exists: recovery/handoff, independent review or
validation, a load-bearing decision at risk of context loss, cross-owner
reconciliation, lifecycle pressure, or an integrated contract that needs one
owner. Duration and implementation size are evidence that may reveal pressure,
not independent file-creation rules.

The reported status-grouped filter should have received at least a Native Plan
before coding. If investigation exposed the demonstrated multi-surface/API and
recovery pressure, the task should then have been promoted to a durable Plan.
This conclusion does not depend on calling it “large”; it follows from its
requirement and ownership surface.

### D5 - Reclassify as soon as the premise expands

An initially legitimate Simple maintenance action becomes Managed immediately
when diagnosis, repeated repair, new behavior, multiple dependent owners,
contract fan-out, or material drift risk appears. Freeze the requirement/Done
Contract, create the remaining Native Plan, and continue from the current
evidence rather than restarting or hiding the earlier classification error.

Likewise, a Managed request returns to Plan Feature only when unresolved
normative product/architecture choices or materially different viable outcomes
remain. Planning depth grows from evidence; it is not fixed at intake.

### D6 - Protect semantics without claiming live behavior from strings

Verification is separated into:

1. fitted conformance and mutation checks for owner wording and activation;
2. repository regression and generated-shell equality;
3. fresh Agent pressure cases for actual classification decisions.

Structural green proves that the contract is stored, linked, and protected. It
does not prove a future Agent will follow it. If a fresh Agent surface is
unavailable, behavior remains `no verdict`.

## Requirements And Acceptance

### Requirement formation

- A requirement-bearing request reaches the Change Contract readiness check
  even when its wording is specific and the selected workflow is obvious.
- `semantic-ready`/`requirement-ready` is based on decision-bearing meaning,
  not a fixed checklist or document.
- The Agent investigates implementation facts and asks only for a remaining
  user-owned normative choice.
- No Task Breakdown, Native Plan implementation step, or mutation is derived
  while a redirecting requirement choice remains unresolved.

### Plan derivation

- Requirement/Goal/Done When visibly govern the Plan; Plan steps cannot define
  or narrow the requirement after the fact.
- Every new or changed user-visible behavior, business flow/state, or external
  contract receives a Native Plan before mutation.
- Clear requirement wording creates a short planning path, not a planning
  bypass.
- Durable Plan materialization remains controlled only by Artifact Pressure.

### Classification and recovery

- One clear read-only/maintenance action with one direct check can remain
  Simple when it does not create desired behavior or contract semantics.
- The status-grouped defect-filter request is classified at least Managed even
  if an Agent predicts one file or a short implementation.
- New evidence that expands semantics, owners, dependent steps, or drift risk
  reclassifies the task before more mutation.
- A false initial Simple classification is recovered in place through a Task
  Anchor and remaining Native Plan; the user does not have to restate the task.

### Product cost and authority

- No requirement database, mandatory PRD, per-task file, fixed interview, new
  route, Always Read item, or persistent state service is introduced.
- Ordinary Q&A, read-only explanation, and fixed-contract maintenance retain
  proportional cost.
- Planning semantics grant no new delivery or external-system authority.

## Behavior Pressure Matrix

| Case | Expected decision |
|---|---|
| Explain an existing function without changing files | direct read-only answer; no Anchor or Plan |
| Correct a known typo and verify the exact text | Simple direct maintenance path |
| Restore one known-owner bug to an already authoritative expected contract | Simple only while one action/check and no diagnosis or contract expansion remain |
| Add one user-visible toggle with fully specified behavior | requirement-ready fast path, then Managed Native Plan; no user question merely for ceremony |
| Add status-grouped defect filtering across iteration/version/hotfix with ordered labels and counts | requirement readiness plus Native Plan before mutation; inspect grouping/count/interaction ownership and promote to durable Plan if persistence pressure appears |
| A “small” UI request exposes API, pagination, shared-state, or multiple-surface fan-out | immediately reclassify/update the Native Plan before further mutation |
| User explicitly asks for a repository Plan | create the smallest durable Plan after requirement formation |
| Existing implementation evidence contradicts a confirmed requirement | pause affected path, return to requirement/user-decision owner, then replan |

## Current To Target Owner Map

| Owner | Target responsibility |
|---|---|
| `docs/sba-bible.md` | constitutional requirement-over-Plan relationship and semantic feature-intake boundary |
| `change-contract.md` | complete `requirement-ready` meaning without a second state machine |
| `plan-feature.md` | requirement-before-Plan ordering, no Task Breakdown before readiness, Native/durable split |
| `task-execution.md` | classifier and Task Anchor/Native Plan derivation from the requirement |
| `change-managed.md` | first mutation hook for all feature/user-visible contract changes |
| SKILL/shell sources and generators | pre-Task-Execution activation so the Simple shortcut cannot bypass the owner |
| Plan docs/template | durable artifact wording consistent with the same target/means relationship |
| conformance/scenarios | fitted semantic and activation protection, not behavior claims |
| `UPSTREAM-CHANGES.md` | downstream porting and preservation guidance |

## Task Interfaces

### Task 1 - Establish constitutional and runtime readiness semantics

- **Files:** `docs/sba-bible.md`,
  `templates/skill/protocol-blocks/change-contract.md`,
  `templates/skill/workflows/plan-feature.md`.
- **Consumes:** D1-D4 and the existing Change Contract/Artifact Pressure owners.
- **Produces:** requirement-over-Plan principle, `requirement-ready` alias, and
  no-breakdown-before-readiness rule.
- **Acceptance:** the complete target/means/readiness meaning is reconstructable
  without a new lifecycle, checklist, or artifact mandate.

### Task 2 - Repair classification and first-action activation

- **Files:** `templates/skill/workflows/task-execution.md`,
  `templates/skill/workflows/change-managed.md`, SKILL carriers,
  `templates/skill/scripts/sync-routing.sh`, `references/protocols.md`, shell
  sources/generated shells, and self-hosting entry surfaces.
- **Consumes:** Task 1 readiness semantics and D2/D5.
- **Produces:** requirement-bearing changes cannot use the Simple direct path;
  bounded maintenance still can; reclassification remains in-place.
- **Acceptance:** generated downstream and self-hosting entries activate the
  same boundary before the first mutation, with no copied complete protocol.

### Task 3 - Align durable Plan documentation

- **Files:** `docs/plans/_TEMPLATE.md`, `docs/plans/README.md`,
  `docs/task-anchor-native-plan.md`.
- **Consumes:** D1, D4, and existing archive/Task Anchor ownership.
- **Produces:** requirements precede task interfaces; Task Anchor/Native Plan
  reflect target versus means; Artifact Pressure remains unchanged.
- **Acceptance:** a fresh Plan author cannot infer either “steps define the
  requirement” or “every requirement creates a file.”

### Task 4 - Protect and pressure-test the repair

- **Files:** `templates/skill/conformance.yaml`,
  `references/self-hosting-conformance.yaml`,
  `scripts/check-self-scenarios.sh`; temporary mutation and fresh-Agent evidence.
- **Consumes:** Tasks 1-3 and the behavior pressure matrix.
- **Produces:** fitted baseline/mutation/regression results plus a separate live
  behavior verdict or `no verdict`.
- **Acceptance:** deleting requirement authority, the feature-intake trigger,
  Simple exclusion, Native/durable split, or reclassification boundary fails the
  intended check; full Bucket A validation passes after final edits.

### Task 5 - Record upstream impact and close

- **Files:** `UPSTREAM-CHANGES.md` and this Plan's lifecycle fields.
- **Consumes:** final diff and all Task 4 evidence.
- **Produces:** downstream refresh guidance, final reconciliation, `status: done`.
- **Acceptance:** unrelated JDK/validator work is preserved; structural,
  semantic, and live-behavior claims are separated; no unauthorized delivery is
  implied.

## Open Questions

None. The user confirmed that requirement is the goal, Plan is the means, and
the reported feature request should not have bypassed planning because it looked
small. Artifact materialization remains governed by existing pressure rather
than a new universal per-requirement file rule.

## Implementation Evidence And Closure

- Tasks 1-3 are implemented at the planned owners. The Bible owns the stable
  target/means rule; Change Contract owns `requirement-ready`; Plan Feature owns
  requirement-before-breakdown and Native-versus-durable Plan ordering; Task
  Execution and Change Managed own classification, activation, and in-place
  reclassification; entry carriers and generated shells activate that boundary
  before the first mutation.
- The reported failure family is protected as a representative clear request:
  adding ordered status-grouped filtering with counts to iteration/version/
  hotfix defect tabs routes to Change Managed, may satisfy
  `requirement-ready` without questions, remains Managed, and cannot bypass a
  Native Plan. The fresh self-scenario suite passes `636/0`.
- Independent mutations remove requirement authority, feature-not-Simple,
  readiness-before-Native-Plan, Native-versus-durable Plan separation, and
  in-place reclassification one at a time. Each mutation fails for the expected
  missing contract while the complete validation suite passes `23/0`.
- Fitted content evidence passes: template conformance `709/0`, self-hosting
  conformance `589/0`, synchronized template routing, and synchronized
  self-hosting shells. Workflow budgets remain within the existing limits:
  Task Execution `93`, Plan Feature `100`, Project Profile `82`, and Change
  Contract `24` lines.
- `bash scripts/check-all.sh --base HEAD --live-agent` completed every
  deterministic structure, materialization, path, scenario, mutation, and
  conformance check, then returned the runner's documented exit `3` because
  both fresh Codex journeys lost WebSocket and HTTP transport. Both modes are
  therefore `NO VERDICT`; deterministic green is not promoted into live Agent
  behavior proof.
- Plan/Knowledge reconciliation returns `pass`. There is no Composite graph,
  business leaf, later Decision Delta, parallel requirement owner, or
  downstream consumer in this task. The calibrated `distilled_to` list names
  the canonical semantic and proof owners; generated shells remain consumers,
  not independent truth.
- Final AAR admits no additional rule or workflow. The two diagnostic command
  mistakes were invocation errors with no repository write: a zsh reserved
  variable name, and a `tail` pipeline that masked an upstream exit status.
  Direct reruns exposed and resolved the stale assertions; the active fitted
  checks already prevent the product regressions.
- Local implementation is `Closure Complete` and this Plan is now frozen.
  No commit, push, MR, downstream assembly, deploy, publish, database, or other
  external delivery was requested or performed.
