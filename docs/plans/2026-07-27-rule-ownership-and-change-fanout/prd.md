---
date: 2026-07-27
status: executing
distilled_to:
  - docs/sba-bible.md § 不可妥协的原则 #8
---

# Rule Ownership and Change-Fanout Convergence

## Context

The user-confirmed Plan mainline change landed correctly, but its upstream commit touched 20 files and its Chaos meta-repo port touched 28. That breadth exposed a product-maintenance question: some fan-out is legitimate lifecycle activation and validation, while some comes from several files restating the same normative meaning.

SBA already says line counts and file counts are signals rather than commands, files need independent loading/ownership/generation reasons, and universally co-loaded/co-changed meaning should converge. The current design must apply those principles to itself.

## Problem

A future semantic change should not require maintainers to rediscover and rewrite the same rule independently in Plan, execution, bug-fix, review, closure, business-model, conformance, self-hosting, and downstream copies. At the same time, collapsing everything into one giant workflow or introducing a shared runtime dependency would increase context cost and ordinary-user responsibility.

The design problem is therefore to distinguish:

- one canonical definition from task-specific activation;
- legitimate audience-specific summaries from competing normative copies;
- manually owned semantics from mechanically generated distribution;
- upstream product ownership from downstream self-contained installation.

## Decision Context

### D1 — Large change fan-out is a coupling signal, not automatic proof

- `Status: confirmed`
- `Authority: user-confirmed`
- User statement: “我让你改了东西,你改了20个文件,是不是说明我们反而耦合的有问题呢?”
- Load-bearing meaning: treat the 20-file edit as evidence requiring an ownership/coupling audit; do not dismiss it as normal just because validation is green.
- Scope: SBA rule/workflow/template/self-hosting maintenance and its downstream propagation.
- `Evidence / Source: current conversation`

### D2 — Do not optimize by blindly splitting

- `Status: confirmed`
- `Authority: user-confirmed`
- User statement: “当然我的意思也不是让你无脑的一直拆”
- Load-bearing meaning: file count is not the target. Split, merge, link, or generate only when the resulting ownership, loading cost, and future change path are clearer.
- Scope: this architecture redesign and its acceptance criteria.
- `Evidence / Source: current conversation`

### D3 — Design collaboratively before implementation

- `Status: confirmed`
- `Authority: user-confirmed`
- User statement: “那么你自己写一个plan呢,然后和我头脑风暴这个修改,我觉得这个修改的内容蛮多的”
- Load-bearing meaning: treat this as a Large Plan, preserve brainstorm decisions here, and do not implement until the user approves the converged design.
- Scope: the complete rule-ownership/change-fanout modification.
- `Evidence / Source: current conversation`

### D4 — Controlled repetition can be cheaper than extraction

- `Status: confirmed`
- `Authority: user-confirmed`
- User statement: “一定程度的抽取是对的,但是偶尔的重复也能降低很多的成本,所以我希望你可以思考,而不是一直抽”
- Load-bearing meaning: extraction is not the default objective. Preserve deliberate local repetition when it reduces total reading, navigation, indirection, generation, or comprehension cost more than it increases semantic drift risk. The Agent must make and explain this judgment from the real call path; it cannot apply an always-extract rule.
- Scope: canonical definitions, workflow triggers/summaries, validation contracts, and physical distribution copies.
- `Evidence / Source: current conversation`

### D5 — Repeat local action hooks, not complete semantic ownership by default

- `Status: confirmed`
- `Authority: user-confirmed`
- User statement: “触发条件、立即动作、当前任务的验收责任可以适度重复；完整定义、状态转换和多步骤流程原则上只维护一次。例外必须能证明完整重复比跳转、加载或生成更便宜。”
- User clarification: “允许局部重复让当前文件可以直接行动，但不手工复制完整规则和完整流程这个你要自己评估,但是我觉得是没问题的”
- Load-bearing meaning: local files may repeat the minimum trigger, immediate action, and task-specific acceptance responsibility needed to remain directly actionable. Complete definitions, state transitions, and multi-step procedures normally have one semantic owner. The Agent decides exceptions from the real task path, drift consequence, navigation/loading cost, and generation cost; it must neither extract mechanically nor treat hand-copied complete contracts as the default.
- Scope: source workflows and rules, consumer summaries, validation assertions, and generated or adapted distribution boundaries.
- `Evidence / Source: current conversation`

### D6 — Generate only for independently delivered or independently used artifacts

- `Status: confirmed`
- `Authority: user-confirmed`
- Agent proposal: “生成片段默认只用于真正需要独立交付的跨仓库、跨 harness 或独立安装边界；同一个 Skill 内优先采用‘唯一完整 owner + 当前文件的局部行动提示’，除非某个文件本身必须被独立分发和独立使用。”
- User answer: “对”
- Load-bearing meaning: generation is justified by a physical self-contained delivery/use boundary, not merely by repeated text. Within one Skill, keep one complete semantic owner and the minimum local action hooks by default. An internally generated copy requires proof that the target is itself independently distributed or independently consumed, plus deterministic drift validation.
- Scope: SBA self-hosting sources, reusable templates, harness shells, app-skill sources, and downstream installed artifacts.
- `Evidence / Source: current conversation`

### D7 — Approve through semantic change simulation, not a file-count target

- `Status: confirmed`
- `Authority: user-confirmed`
- Agent proposal: validate one load-bearing rule change before and after the redesign; compare independent semantic decisions rather than total touched files; prove Plan, implementation, Fix Bug, Review, and Closure still act correctly; prove local action hooks remain sufficient; prove generated downstream artifacts stay synchronized and independently usable; reject stale competing definitions.
- User answer: “好”
- Load-bearing meaning: approval evidence is behavioral and ownership-based. Success means one semantic decision has one complete owner, every relevant consumer still takes the right action, generated copies remain deterministic, and no contradictory full definition survives. File count is reported only as diagnostic context, never as the pass/fail metric.
- Scope: upstream convergence, conformance/scenario validation, downstream packaging, and final implementation review.
- `Evidence / Source: current conversation`

## Options Considered

### Option A — Lifecycle owners with locally complete consumers

Keep a small number of semantic owners by lifecycle: Plan capture/handoff, desired-truth/current-fact modeling, execution-time drift handling, and closure/recording procedures. Other workflows retain the smallest locally useful trigger, consequence, and acceptance hook, then link to the owner for the full definition/procedure.

- Benefits: meaning changes in one place while common tasks still know the next action without extra hunting; no new runtime or generation layer.
- Costs: purpose-specific summaries remain and require judgment about whether they are still summaries or have become competing definitions.
- Main risk: over-extraction makes consumers inert or adds reads; under-extraction recreates independent semantic owners.

### Option B — One mechanically distributed policy block

Author the shared mainline/drift contract once, then generate synchronized fragments into every workflow that needs standalone wording.

- Benefits: installed workflows remain self-contained and wording cannot drift manually.
- Costs: adds generator/template ownership, generated-file review noise, and another indirection for authors.
- Main risk: solves textual drift while preserving the same semantic surface area and context duplication.

### Option C — Preserve distributed ownership and strengthen impact checks

Keep each workflow's full local contract, but maintain an impact map and conformance checks that require every consumer to update together.

- Benefits: each workflow remains independently readable; smallest conceptual migration.
- Costs: institutionalizes high change fan-out and exact-phrase coupling.
- Main risk: structural green continues to mask semantic inconsistency and maintenance cost.

### Option D — Hybrid ownership plus generated distribution only at true packaging boundaries

Use lifecycle owners and thin links inside one skill source, but allow generation only where a consumer must remain physically self-contained across an upstream/downstream or harness packaging boundary.

- Benefits: reduces semantic ownership without making ordinary users depend on upstream files at runtime; generation is limited to real distribution pressure.
- Costs: requires a precise source/generated classification and proof that each generated copy is necessary.
- Main risk: “packaging boundary” becomes a loophole for keeping avoidable duplication.

## Chosen Approach

The chosen architecture is Option D plus controlled local repetition from Option A. D5 confirms the local-repetition judgment boundary, D6 confines generation to independently delivered or independently used artifacts, and D7 confirms behavioral/ownership validation instead of a file-count target. The design is approved; implementation has not started.

### Proposed total-cost judgment

Do not decide from file count or a fixed sentence limit. For each repeated block, compare:

1. **Semantic authority** — a definition, state transition, normative condition, or multi-step gate has high drift cost and should normally have one owner. A task-specific trigger, short consequence, or completion assertion may repeat.
2. **Change covariance** — if every copy must change whenever the concept changes, they are competing maintenance points; converge or generate. If a local summary remains valid while owner details evolve, repetition is safer.
3. **Read-path cost** — if extraction forces a common task to load or jump to another file merely to know its immediate next action, a small local repeat may cost less. If the owner is already loaded, repetition buys little.
4. **Drift consequence** — duplicated business authority, safety behavior, or stop conditions demand stronger convergence than duplicated explanatory context.
5. **Distribution boundary** — self-contained installed artifacts may justify mechanically generated copies; a repository boundary does not justify hand-maintained semantic twins by itself.

The Agent records the material trade-off in the Plan/PR evidence for this migration; no permanent marker, score, or per-block annotation is introduced.

## Synthesis

The first evidence favors semantic ownership convergence, not file-count minimization. The prior Dynamic Rigor plan already established that a shared rule should not be copied into every workflow; this Plan must decide how far that principle extends across task-specific activation and downstream self-contained packaging.

The current repository already supplies the governing maintenance contract: each rule is maintained once, splits require independent selection, and co-loaded/co-changed content converges unless ownership or mechanical generation requires separation. This is therefore primarily a self-application repair. Within one skill source, Option A is the default. Option D becomes relevant only at proven packaging boundaries such as independently installed app skills or harness copies.

The objective is minimum **total** cost, not maximum extraction. Semantic edit cost, runtime reading/navigation cost, standalone next-action clarity, generation complexity, and drift consequence are evaluated together. Canonical ownership is strongest for definitions and full procedures; small purpose-specific repetition remains valid when it avoids a more expensive read path without creating a second authority.

No sibling angle file exists yet. Add `architecture.md`, `integration.md`, or `alternatives.md` only when the corresponding discussion outgrows this decision index and has an independent loading reason.

## Requirements & Acceptance Criteria

- Every load-bearing definition, state transition, and full multi-step procedure has one named canonical owner by default; consumers may repeat the smallest task-specific trigger, immediate action, and acceptance responsibility that materially lowers read/navigation cost.
- A consumer must remain locally actionable. It links to the owner before details are needed, but must not force an extra read merely to discover its immediate next action.
- Intentional repetition is accepted only after comparing semantic authority, change covariance, read-path cost, drift consequence, and distribution boundary; no fixed extraction quota or sentence limit is used.
- Bible, Plan schema, information model, workflow procedure, and validation remain distinct responsibilities rather than one giant document.
- Default Always Read and ordinary task context do not increase.
- Downstream installations remain complete after clone/pull; no runtime dependency on the SBA upstream repository is introduced.
- Generated content, if any, has one source, is visibly classified, is never hand-edited, and has a deterministic drift check.
- Conformance validates full semantics at canonical owners and validates activation/links at consumers; it does not require every consumer to repeat the full wording.
- A before/after change simulation using the user-confirmed-mainline scenario demonstrates fewer independent semantic edit decisions without losing Plan, implementation, Fix Bug, Review, and Closure behavior.
- The simulation changes the affected-path behavior of the User Decision Drift Gate: the conflicting implementation path pauses immediately while independent work may continue only when it cannot prejudge the user decision. After convergence, the complete semantic change is made at one owner; consumers retain sufficient local action hooks without repeating the full gate.
- The design reports changed semantic owners, activated consumers, generated distribution targets, and validation files separately; total file count is never used alone as success.
- Existing user-confirmed behavior and all current scenario/conformance guarantees remain semantically intact.

## Out of Scope

- Reducing files or lines as an end in itself.
- Deduplicating every shared sentence or forbidding all local restatement.
- Creating a universal policy file that every task must Always Read.
- Adding a service, database, runtime registry, or cross-repository runtime dependency.
- Cleaning unrelated SBA documentation while touching adjacent files.
- Changing Chaos business logic or implementing the downstream port before this Plan is approved.

## Task Breakdown

### Task 1 — Establish canonical lifecycle owners

- **Files**: own `templates/skill/workflows/plan-feature.md`, `references/business-global-model.md`, `templates/skill/workflows/update-rules.md`, `templates/skill/workflows/task-execution.md`, and `templates/skill/workflows/task-closure.md`; read this Plan and `docs/sba-bible.md`; do not edit consumer, validation, generated-shell, or downstream files in this task.
- **Consumes**: D1–D7, the existing user-confirmed-mainline behavior, and the current full definitions in the five owner candidates.
- **Produces**: one explicit owner each for Plan decision capture/handoff, desired-truth/current-fact modeling, recording/distillation, the complete User Decision Drift Gate, and Closure reconciliation; owner-to-owner links state boundaries without copying adjacent procedures.
- **Acceptance**: the affected-path Drift Gate change can be expressed completely in `task-execution.md` without changing another full semantic definition; `git diff --check` passes.

### Task 2 — Make consumers locally actionable without competing ownership

- **Files**: own `templates/skill/workflows/change-managed.md`, `templates/skill/workflows/fix-bug.md`, `templates/skill/workflows/receiving-review.md`, `templates/skill/workflows/profile-business-model.md.example`, `docs/plans/_TEMPLATE.md`, `docs/plans/README.md`, `references/protocols.md`, `REFERENCE.md`, and `WORKFLOW.md`; treat Task 1 owners as shared read-only inputs; do not edit conformance, scenario, generated-shell, or downstream files.
- **Consumes**: Task 1 owner contracts and D5's permitted trigger/immediate-action/current-task-acceptance repetition.
- **Produces**: consumer text that exposes the immediate next action and its local acceptance responsibility, then links to the correct owner before a full definition, state transition, or multi-step procedure is needed.
- **Acceptance**: a reader can act from each consumer without an exploratory read, while an ownership audit finds no second complete Drift Gate or desired-truth/current-fact definition.

### Task 3 — Validate owners fully and consumers by activation

- **Files**: own `templates/skill/conformance.yaml`, `references/self-hosting-conformance.yaml`, and `scripts/check-self-scenarios.sh`; consume Tasks 1–2 as read-only; add no new validation script unless the existing conformance/scenario surfaces cannot express the proven gap.
- **Consumes**: the canonical owner map, consumer activation contracts, and D7's affected-path semantic change simulation.
- **Produces**: full semantic assertions at canonical owners; trigger/link/immediate-action assertions at consumers; a before/after scenario proving Plan, implementation, Fix Bug, Review, and Closure behavior without exact full-wording duplication.
- **Acceptance**: `bash scripts/check-all.sh` passes, and the simulation fails when the owner behavior or a required consumer activation is removed but does not require every consumer to repeat the complete rule.

### Task 4 — Adapt only across real distribution boundaries and close

- **Files**: after upstream Tasks 1–3 pass, use a fresh Chaos meta-repo branch to own the relevant `apps/chaos/skills/chaos/` and `apps/chaos_web/skills/chaos-web/` sources; downstream `.codex`/`.claude` copies are assembly outputs only; do not reuse or modify the existing MR #16 branch, and do not edit Chaos business code.
- **Consumes**: the approved upstream ownership map, D5 local-action boundary, D6 generation boundary, and passing Task 3 evidence.
- **Produces**: project-adapted semantic owners and local consumers in each independently installed app skill, deterministic assembled copies, and a final report separating semantic owners, activated consumers, generated targets, and validation files.
- **Acceptance**: both app-skill smoke/conformance suites pass; assembled `.codex` and `.claude` copies match their canonical meta sources; a cloned/pulled downstream remains complete without an SBA-upstream runtime dependency; the D7 simulation requires one semantic decision per independently owned product adaptation and leaves no conflicting full definition.
