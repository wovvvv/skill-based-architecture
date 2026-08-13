---
date: 2026-08-12
status: done
distilled_to:
  - docs/sba-bible.md
  - references/executable-skill-architecture.md
  - templates/skill/workflows/profile-project.md
  - templates/skill/conformance.yaml
  - references/self-hosting-conformance.yaml
  - scripts/check-validation-contract.sh
  - UPSTREAM-CHANGES.md
---

# Plan: Bounded Deterministic Execution And Re-Readable Evidence

> Current conclusion: preserve Agent judgment and creativity as the owner of
> goals, meaning, choices, interpretation, and escalation; move only admitted
> low-freedom execution into a structured API, existing CLI, or script, and
> prove long-running or asynchronous outcomes through authoritative re-readable
> evidence rather than either stdout or file existence alone.

## Problem And Scope

SBA already distinguishes high-, medium-, and low-freedom work in
`references/executable-skill-architecture.md`, requires two pressures before a
whole Skill adopts executable shape, and rejects a generated file or successful
exit code as completion evidence by itself. The external Skill summary exposes
two useful pressures that are not yet stated as one complete boundary:

1. deterministic execution should absorb repeated precision and fragility;
2. long-running, background, noisy, or truncated execution needs evidence that
   survives the terminal and can be read again.

Taken literally, both ideas are dangerous. "Precise work belongs in a script"
can freeze exploratory choices and gradually reduce the Agent to a script
dispatcher. "A file exists, therefore the command succeeded" can accept stale,
partial, unrelated, or non-terminal output. The implementation must absorb the
motivation while rejecting both universal rules.

This Plan changes the SBA product principle and the optional executable-Skill
reference, then adds the smallest conditional action hook to the existing
`profile-project.md` workflow so stored guidance changes an execution-mode
decision when project evidence activates it. It also changes only the fitted
protection and upstream-change surfaces needed to keep those meanings
reviewable. It adds no default surface, does not change ordinary task routing or
Task Execution/Closure ownership, and does not touch any existing downstream
project.

### Pre-Implementation Evidence

- `docs/sba-bible.md` already requires smaller defaults, action-changing
  activation, fitted evidence, conditional artifacts, and an execution
  lifecycle that is not a fixed ceremony. It does not yet state the complete
  Agent-judgment versus deterministic-execution responsibility boundary.
- `references/executable-skill-architecture.md` already treats low freedom as a
  pressure signal, requires at least two pressures before promoting a whole
  Skill, and declares tool idempotency and stable output contracts. It does not
  yet distinguish a single operation's downshift from whole-Skill promotion or
  say when *not* to author a script.
- `templates/skill/workflows/profile-project.md` already detects execution-mode
  pressure and classifies Rule-only, Assisted-executable, or Executable, but it
  does not make the low-freedom plus real-pressure conjunction change that
  decision and does not bind long-running validation to authoritative
  re-readable evidence. Without a compact conditional hook here, the expanded
  reference can remain correct but inert during normal project profiling.
- `templates/skill/workflows/task-execution.md` and
  `templates/skill/workflows/task-closure.md` already say that a command, file,
  or exit code is not sufficient completion evidence and that evidence must be
  fresh and fitted. They remain the execution and completion owners and should
  not receive a second copy of this architecture guidance.
- `references/permission-model.md` already classifies side effects by
  `operation x target/environment`; deterministic execution must not inherit or
  expand authority.
- `templates/ANTI-TEMPLATES.md` already rejects executable directories in every
  default scaffold. No new default script surface is warranted.

## Current Decisions

### D1 - Put the responsibility boundary in the SBA Bible

Add one new item to `docs/sba-bible.md` under `不可妥协的原则`. Preserve the
user's first sentence verbatim, then state the creativity and proportionality
boundary in the same item so the positive rule cannot be separated from its
limit.

**User source:**

> Agent 负责目标、语义、参数选择、异常解释和升级判断；当结果依赖精确计数、结构化解析、重复变换、批量操作、幂等重放或脆弱命令组装，并且已有重复或高错误压力时，将执行下沉到结构化 API、现有 CLI 或脚本。

> 但是我们要记住,要把握好度,不然就会导致被各种脚本固化,而失去了agent本身的创造性.

- Authority: user-confirmed.
- Normative meaning: Agent judgment owns the open-ended and normative parts of
  work. Deterministic machinery may own a bounded execution contract only when
  its result has low freedom and repeated or high-error pressure justifies the
  maintenance cost.
- Mandatory boundary: scripts must not decide the goal, desired meaning,
  product trade-off, target/parameter semantics, interpretation of unexpected
  evidence, or escalation. Exploration, alternative generation, diagnosis,
  and open implementation design remain with the Agent.
- Fast-path boundary: a one-off, low-risk action that the Agent can execute and
  verify directly does not justify a new script merely because a script could
  express it.
- Product consequence: deterministic execution increases the Agent's leverage;
  it must not replace the Agent's creativity or make every project inherit an
  executable architecture.

The implementation may make punctuation and terminology consistent with the
Bible, but it must retain every responsibility, trigger, boundary, reason, and
the warning about lost creativity. An Agent-derived shorter slogan cannot
replace the user source as the only normative record in this Plan.

### D2 - Use a two-gate operation-level downshift

Extend `references/executable-skill-architecture.md` with an operation-level
decision that is separate from its existing whole-Skill shape gate.

An operation is a candidate for deterministic downshift only when **both** are
true:

1. **Low-freedom contract:** correctness depends on exact counting, structured
   parsing, repeated transformation, batch operation, idempotent replay,
   fragile command assembly, or another stable input/output/error contract.
2. **Real pressure:** the direct Agent path has repeated maintenance or failure
   evidence, or the cost/probability of an execution error is already high
   enough to justify a deterministic carrier.

Candidate categories alone do not admit scripting. "This can be automated" is
not evidence that it should be automated. Conversely, high-risk deterministic
work does not have to fail twice before receiving a reliable carrier.

Once admitted, prefer the lightest existing carrier in this order:

1. a structured domain/API operation;
2. an existing project CLI;
3. an existing script or the smallest extension to it;
4. a new focused script only when no existing carrier owns the contract.

The Agent still chooses the goal, semantic parameters, target, authorization
path, and response to unexpected output. The deterministic carrier owns only
declared inputs, execution, stable outputs/errors, and idempotency behavior. A
new fact that invalidates the contract returns control to Agent judgment; the
script must not hide it behind blind retry or hard-coded product choices.

One downshifted operation does not promote the whole Skill to executable shape.
The current independent "at least two pressures" promotion gate remains in
force.

The existing `profile-project.md` workflow receives only the smallest local
action hook: after project evidence exposes an execution-mode candidate, apply
the conjunction above, prefer an existing carrier, preserve Agent judgment,
and reject a new script for a one-off direct action. It must not copy the full
architecture rationale or make ordinary Rule-only profiles load another file.

### D3 - Absorb the motivation of disk-backed evidence, reject file existence

Extend the executable reference with a re-readable execution-evidence contract.

For an ordinary synchronous command, stdout and exit status may be sufficient
when that command's own contract directly proves the requested result. When an
operation is long-running, asynchronous, backgrounded, noisy, terminal-
truncated, or merely submits work for later completion, the workflow must name
an authoritative evidence source that can be read again. The source may be a
job/status API, test report, manifest, generated artifact, deployed runtime,
schema/data readback, or another domain-owned state. It is not required to be a
file.

Before treating that evidence as success, verify all applicable dimensions:

1. **Execution identity:** it belongs to this run, job, commit, input set, or
   requested target rather than a neighboring or historical execution.
2. **Authority and provenance:** it comes from the system or artifact that owns
   the claimed result, not a precursor or copied summary.
3. **Freshness:** it was produced or read after the final relevant input and is
   not a stale artifact observed by a fresh command.
4. **Completeness and semantic validity:** required content is present,
   parseable, and satisfies the operation's stable output contract.
5. **Requested terminal state:** it proves the user's requested outcome, not
   only accepted, queued, started, pushed, uploaded, or another intermediate
   state.

File existence, stdout text, and a zero exit code remain useful signals, but no
one of them is a universal success oracle. A stale, malformed, unrelated,
partial, or non-terminal artifact keeps the step open. If no authoritative
readback can prove the outcome, report that evidence boundary explicitly
instead of manufacturing success.

**User source:**

> “落盘判定”要吸收动机，拒绝结论,这个也是对的

- Authority: user-confirmed.
- Normative meaning: retain terminal-surviving evidence, reject `file exists =
  success` as the replacement rule.

The same existing profile workflow receives one validation hook: when an
admitted operation is long-running, asynchronous, noisy, backgrounded, or
terminal-truncated, its drafted executable contract names an authoritative
re-readable source and requested terminal state. The complete five-dimension
definition remains in the executable reference.

### D4 - Do not add fixed process or artifact machinery

This change creates none of the following:

- a mandatory script for every precise action;
- new `scripts/`, `tools/`, `capability/`, or `conf/` directories in the default
  scaffold;
- a fixed eight-stage pipeline;
- a universal red-line YAML;
- a required per-task `TECH_SPEC.md`;
- a mandatory output/status file or task ledger;
- a new Always Read surface, route, workflow, runtime service, or state machine.

Knowledge persistence continues through SBA's existing canonical-owner,
activation, verified-failure, and Artifact Pressure contracts. This Plan itself
exists because the user explicitly requested a durable Plan and the exact
responsibility boundary must survive implementation review.

### D5 - Protect meaning without confusing structure with behavior

Verification has three separately reported layers:

1. **Semantic/structural protection:** add fitted template/self-hosting
   conformance anchors for the Bible boundary, executable reference, and the
   conditional profile hook. In a temporary copy, deleting the low-freedom +
   real-pressure conjunction, the creativity boundary, its action-changing
   activation, or the re-readable evidence dimensions must make conformance
   fail for the intended reason.
2. **Regression:** run the repository's fitted self-hosting/full checks and
   `git diff --check`. Green results prove consistency and reachability, not
   Agent behavior.
3. **Behavior pressure cases:** use fresh, isolated Agent reviews of the updated
   Bible/reference and assert decisions as a loose subset. Do not add a default
   scenario harness or another repository script unless an actual repeated
   behavioral failure later proves that permanent machinery is worth its cost.

If the live/fresh Agent surface is unavailable, report `no verdict` for behavior
rather than inferring compliance from conformance. The semantic change may be
locally ready while that separate evidence layer remains explicitly unproven.

## Current To Target Owner Map

| Owner | Current | Target | Intentionally unchanged |
|---|---|---|---|
| `docs/sba-bible.md` | general proportionality, activation, evidence, and conditional-artifact principles | one constitutional judgment/execution boundary preserving Agent creativity | ordinary downstream Skills do not load the Bible |
| `references/executable-skill-architecture.md` | degrees of freedom, whole-Skill pressure gate, executable layer contracts | operation-level two-gate downshift, lightest-carrier preference, re-readable evidence contract | existing full-shape gate and project-specific implementation freedom |
| `templates/skill/workflows/profile-project.md` | detects execution mode from broad pressure categories | conditionally changes the profiling decision through the conjunction/carrier rule and drafts authoritative readback for admitted long-running operations | no full reference copy, no new route, no effect on ordinary task execution |
| `templates/skill/conformance.yaml` and `references/self-hosting-conformance.yaml` | protect current reusable/self-hosted contracts | protect the new inseparable positive rule, thin activation, and anti-overreach/evidence boundaries | do not claim live behavior proof |
| `UPSTREAM-CHANGES.md` | no entry for this change | one scoped note explaining optional downstream impact | no automatic downstream assembly or copy |

No semantic edit is planned for `task-execution.md`, `task-closure.md`,
`permission-model.md`, `ANTI-TEMPLATES.md`, routing, shell templates, or default
downstream files/directories beyond the existing conditional profile workflow.
If implementation evidence shows that one of those other files must change,
return this Plan to `draft` and justify the new owner rather than expanding
scope silently.

## Requirements And Acceptance

### Responsibility and creativity

- A reader can distinguish what the Agent owns from what a deterministic
  carrier owns.
- Exactness alone does not trigger a new script; the low-freedom contract and
  real-pressure gate are both visible.
- The reference explicitly preserves exploration, diagnosis, alternative
  generation, product trade-offs, semantic parameter choice, exception
  interpretation, and escalation as Agent responsibilities.
- A one-off, low-risk, directly verifiable action remains on the direct Agent
  path.
- A script/API/CLI cannot expand operation or delivery authority.

### Re-readable evidence

- The contract permits stdout/exit status when they directly prove a simple
  synchronous result; it does not mandate disk output.
- Long-running or asynchronous work names an authoritative readback and checks
  identity, provenance, freshness, completeness/validity, and requested
  terminal state.
- `file exists`, `exit 0`, `request accepted`, and `job started` cannot satisfy
  a later terminal-state request by themselves.
- Missing authoritative readback produces an honest evidence boundary, not a
  success claim.

### Product cost

- No new default template file, directory, route, Always Read item, YAML
  registry, task artifact, or script is introduced.
- The existing profile workflow adds only an evidence-triggered local action
  hook; Rule-only profiles and ordinary implementation tasks do not acquire a
  new read or executable requirement.
- The two complete meanings have one canonical operational owner and one
  constitutional product owner; workflow consumers are not filled with copied
  definitions.
- Existing dirty JDK/conformance work is preserved and is not reclassified as
  part of this implementation.

### Behavior pressure matrix

| Case | Expected decision |
|---|---|
| Open-ended architecture or product design with several viable approaches | Agent explores and judges; no script is required to freeze the path |
| One-time local inspection with a direct, cheap check | Agent executes directly; no new wrapper script |
| Repeated fragile JSON parsing or batch transformation with a stable schema | use a structured API/existing CLI/script; return structured facts/errors to the Agent |
| Non-idempotent external operation | deterministic carrier declares idempotency/error contract, while Agent retains target, parameter, permission, and escalation judgment |
| Long-running job where an old success file already exists | old file is rejected; read the current run's authoritative status/artifact and requested terminal state |
| Synchronous CLI whose exact output contract directly answers the request | stdout/exit evidence may be accepted; no forced file creation |
| File exists but is stale, malformed, partial, from another run, or still `RUNNING` | step remains incomplete or stale |
| Terminal was truncated and no authoritative readback exists | report `no verdict`/unproven outcome; do not claim success |

Behavior evaluation uses subset assertions on the decisions above, not exact
transcript wording or a fixed sequence of internal thoughts.

## Risk Scenarios

### Scriptification creep

- Invariant: deterministic carriers absorb low-freedom execution but never own
  open-ended judgment.
- Failure: every recurring task receives a wrapper, choices become hard-coded,
  and the Agent loses the ability to adapt to new evidence.
- Prevention: conjunction gate, lightest-existing-carrier order, one-off fast
  path, explicit return to Agent on premise change, and whole-Skill promotion
  kept separate.
- Proof: negative conformance mutation plus the exploratory and one-off behavior
  pressure cases.
- Residual risk: teams may still over-claim "high error pressure"; future
  recurrence should correct the existing gate rather than add more scripts.

### Artifact false green

- Invariant: evidence proves the current requested terminal state.
- Failure: a stale or merely existing artifact is treated as semantic success.
- Prevention: identity, authority, freshness, completeness, and terminal-state
  readback.
- Proof: stale-file, wrong-run, malformed, and non-terminal pressure cases.
- Residual risk: some external systems expose weak status contracts; those
  cases remain explicitly unproven rather than guessed.

### Duplicate ownership and context cost

- Invariant: the Bible owns the stable product principle; the executable
  reference owns the complete operating contract; the profile workflow keeps
  only the smallest condition and next action needed at its decision boundary.
- Failure: Task Execution, Closure, permission guidance, and templates each copy
  a slightly different version.
- Prevention: no planned semantic edits to those consumers; targeted search
  after implementation checks for accidental full-definition duplication.
- Proof: owner map review plus final semantic before/after reconciliation.

### Green checks mistaken for Agent behavior

- Invariant: structure/conformance and live behavior are different evidence
  layers.
- Failure: string anchors pass and the implementation is called behaviorally
  proven without a fresh Agent decision.
- Prevention: report deterministic and behavior results separately; unavailable
  live evaluation is `no verdict`.
- Proof: final Closure report names each layer and its boundary.

## Task Interfaces

### Task 1 - Add the constitutional boundary

- **Files:** `docs/sba-bible.md`
- **Consumes:** D1 and the preserved user source in this Plan.
- **Produces:** one new inseparable principle covering Agent responsibility,
  deterministic downshift trigger, creativity boundary, and one-off fast path.
- **Acceptance:** semantic inventory shows that no user responsibility, trigger,
  warning, or reason was dropped or broadened; existing Bible scope remains
  upstream-only and not Always Read downstream.

### Task 2 - Extend executable operation and evidence contracts

- **Files:** `references/executable-skill-architecture.md`
- **Consumes:** D2-D4 and the existing degrees-of-freedom/full-shape contracts.
- **Produces:** an operation-level two-gate classifier, carrier preference,
  responsibility split, premise-change escape, and re-readable evidence model.
- **Acceptance:** all responsibility/evidence requirements and all eight
  pressure cases are decidable from this reference; the document does not
  require a new script, file, directory, or full executable shape by default.

### Task 3 - Activate and protect the two boundaries proportionately

- **Files:** `templates/skill/workflows/profile-project.md`,
  `templates/skill/conformance.yaml`, and
  `references/self-hosting-conformance.yaml`
- **Consumes:** final wording from Tasks 1-2.
- **Produces:** a compact evidence-triggered execution-mode/readback hook plus
  fitted anchors that protect the conjunction gate, Agent creativity/one-off
  boundary, action-changing activation, and current-run authoritative evidence
  dimensions without pretending to be a behavioral oracle.
- **Acceptance:** an execution-pressure profile reaches the hook before adding
  executable machinery; a Rule-only profile incurs no new read or executable
  requirement; baseline conformance passes; separate temporary mutations of
  each load-bearing boundary fail for the expected missing anchor; no route,
  checker, new workflow/file, or default scenario-harness code is added.

### Task 4 - Run fitted regression and fresh behavior review

- **Files:** no product file by default; temporary isolated workspaces/transcript
  evidence only.
- **Consumes:** Tasks 1-3 and the behavior pressure matrix.
- **Produces:** separate semantic/conformance, regression, and live-behavior
  results.
- **Acceptance:** `git diff --check`, fitted self-hosting conformance, and
  `bash scripts/check-all.sh --base HEAD` pass after the final edit; fresh Agent
  cases satisfy the loose decisions above or are honestly reported as
  `no verdict` when the harness is unavailable. A structural green result is
  never reported as live behavior proof.

### Task 5 - Record upstream impact and close locally

- **Files:** `UPSTREAM-CHANGES.md`; this Plan's lifecycle fields only at the
  implementation handoff/final reconciliation required by the archive contract.
- **Consumes:** final diff and all Task 4 evidence.
- **Produces:** a scoped upstream note stating that this is optional executable-
  architecture/product guidance and adds no default downstream artifact.
- **Acceptance:** Task Closure accounts for final semantic ownership, fitted
  evidence, absence of unwanted scaffold expansion, and preservation of all
  unrelated dirty work. Commit, push, MR, downstream assembly, deployment, and
  publication remain unauthorized unless the user separately requests them.

## Implementation Order And Return Conditions

1. Set this Plan to `executing`; read the user source and perform a before-edit
   semantic inventory.
2. Implement Task 1 and Task 2 together so the positive script boundary never
   lands without its creativity and evidence limits.
3. Search the affected owner family for contradictions or copied full
   definitions. Return to this Plan if a third semantic owner appears necessary.
4. Implement the Task 3 conditional profile hook, add its fitted anchors, and
   run baseline plus independent temporary mutations.
5. Run Task 4 regression and behavior layers. A failed pressure case returns to
   the owning wording; it does not justify a special-case script automatically.
6. Add the upstream note, run fitted Closure, reconcile final evidence, set the
   Plan to `done`, and freeze it only after the implementation is locally
   complete.

Return to planning before further mutation when:

- the implementation would require adding default surfaces, changing routing,
  changing a template beyond the scoped profile hook, changing Task
  Execution/Closure or permission semantics, or touching a downstream project;
- the deterministic carrier would need to decide a normative/product choice;
- evidence cannot distinguish the current run or requested terminal state;
- a new persistent script, status file, ledger, YAML registry, or scenario
  harness appears necessary;
- fresh evidence contradicts the user-confirmed creativity boundary.

## Open Questions

None. The user confirmed the constitutional statement, the anti-scriptification
boundary, the re-readable-evidence direction, and the request to proceed through
this Plan. Implementation facts remain discoverable by the Agent and do not
require another product decision before execution.

## Implementation Evidence And Closure

- The Bible and executable reference now preserve the complete responsibility
  split: Agent owns goal, desired meaning, semantic parameters, target,
  authorization, alternatives, exception interpretation, and escalation; a
  deterministic carrier owns only declared inputs, exact execution, stable
  outputs/errors, and idempotency behavior.
- Operation-level downshift requires both low freedom and repeated or
  demonstrated high-error pressure. The preferred carrier order is structured
  API, existing CLI, existing script, then a new minimal script. One-off,
  low-risk, directly verifiable actions remain on the Agent path, and premise
  changes return control to Agent judgment.
- Long-running, asynchronous, backgrounded, noisy, terminal-truncated, or
  submission-only work now verifies five distinct readback dimensions:
  execution identity, authority/provenance, freshness, completeness/semantic
  validity, and the requested terminal state. File existence, exit zero, or an
  accepted/queued/started precursor cannot satisfy the user's terminal outcome.
- Project Profile activates the admitted contract at its existing execution-
  mode decision without adding an Always Read item, route, executable folder,
  or downstream reference owner. Its initial upstream-only relative link was
  removed; the emitted workflow is self-contained and still carries both gates,
  carrier order, Agent boundary, one-off path, and readback hook.
- Independent mutations remove both downshift gates, Agent judgment, the
  one-off direct path, each of the five readback dimensions, and the
  intermediate-versus-terminal boundary separately. Each deletion fails for
  the expected missing contract while the complete validation suite passes
  `23/0`; fitted template and self-hosting conformance pass `709/0` and `589/0`.
- `bash scripts/check-all.sh --base HEAD --live-agent` completed all
  deterministic checks. Both fresh Codex journeys then lost WebSocket and HTTP
  transport and produced the runner's documented `NO VERDICT`, so the overall
  exit is `3`. This proves no live behavior and does not convert external
  transport failure into an SBA behavior failure.
- Plan/Knowledge reconciliation returns `pass`. The Bible is the product owner,
  executable architecture is the complete operating owner, Project Profile is
  the thin action hook, and fitted manifests/mutations are proof owners. No
  duplicate full definition, default executable machinery, downstream change,
  business leaf, Component graph, or later Decision Delta exists.
- Final AAR admits no additional durable mechanism. Local implementation is
  `Closure Complete` and this Plan is now frozen. No commit, push, MR,
  downstream assembly, deploy, publish, database, or other external delivery
  was requested or performed.
