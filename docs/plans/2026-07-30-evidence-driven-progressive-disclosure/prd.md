---
date: 2026-07-30
status: executing
distilled_to:
  - docs/sba-bible.md § 原则 9
  - docs/sba-bible.md § 原则 10
  - SKILL.md § Core Principles / runtime routing kernel
  - references/business-global-model.md § Orthogonal task and domain routing
  - references/protocols.md § Task Execution / Task Closure Protocol
  - templates/skill/SKILL.md.template
  - templates/skill/routing.yaml
  - templates/skill/workflows/task-execution.md
  - templates/skill/workflows/task-closure.md
  - templates/skill/workflows/update-rules.md
  - templates/skill/scripts/sync-routing.sh
---

# Plan: Evidence-Driven Progressive Disclosure

## Context

This Plan records the full progressive-disclosure discussion that began with first-use cost in `/Users/shiqi/ai-infra-workspace/chaos-release-0.75_shiqi`. The representative technical request was:

> 发布弹窗第一次打开一直加载，刷新后正常

The current startup path can eagerly load the root/app shells, `SKILL.md`, routing, Always Read material, a task workflow, a keyword-selected business overlay, managed-task execution, and closure material before source inspection. The observed representative path is roughly 90 KB before evidence establishes whether business semantics are relevant. This measurement is diagnostic evidence, not a correctness budget.

The intended technical path is:

```text
task route -> fix-bug workflow -> minimal UI/API/lifecycle evidence
           -> technical lifecycle cause -> no business overlay
```

The intended business-bearing path is:

```text
task route -> workflow -> evidence shows a version-state decision
           -> activate product-delivery domain -> continue the same workflow
```

This is an SBA runtime-loading design. `business-model impact: unchanged`: the work changes when domain truth is loaded, not the truth itself.

## Problem

The current design can answer two different questions at the same time:

1. What procedure should start this task?
2. What project/domain knowledge might eventually matter?

Task-level `required_reads`, non-empty Always Read defaults, and keyword-first overlay matching turn probable relevance into immediate context cost. This causes ordinary technical work to pay for business knowledge before source evidence proves that a business decision exists. It also encourages context policy to be duplicated across the router, workflows, aggregate rule files, and generated shells.

The goal is not a hard token target or fewer files by itself. The goal is to preserve complete behavior while making every additional read answer an unresolved decision that can change the next action.

## Decision Context

### D1 - Context cost is evidence, not a fixed gate

- `Status: confirmed`
- `Authority: user-confirmed`
- User correction: “普通技术任务在读取源码前，项目文档总预算不超过约 8–10k token 这个不应该写死,这不是一个好的设计。”
- Load-bearing meaning: do not encode token, byte, file-count, or elapsed-time ceilings as correctness rules. Measure startup cost to compare designs and expose regressions, but route and load from task evidence.
- `Evidence / Source: current conversation`

### D2 - Task routing selects only the first workflow

- `Status: confirmed`
- `Authority: user-confirmed`
- User statement: “路由只确定第一个工作流；工作流根据证据逐步拉取知识。”
- Load-bearing meaning: remove task-level eager knowledge bundles such as `required_reads`. The task route identifies the first procedure; it does not precompute the task's full knowledge set.
- `Evidence / Source: current conversation`

### D3 - Knowledge expands from unresolved decisions

- `Status: confirmed`
- `Authority: user-confirmed`
- Agent proposal accepted by the user: after the workflow begins, gather the smallest evidence needed for the current uncertainty, then load only a rule, reference, test contract, or domain model that can resolve that uncertainty and change the next action.
- Load-bearing meaning: progressive disclosure is decision-driven rather than a fixed startup bundle. Observability may report read cost, but it does not choose correctness.
- `Evidence / Source: current conversation`

### D4 - Task routing and domain selection are separate phases

- `Status: confirmed`
- `Authority: user-confirmed`
- User statement: “Task 路由和领域选择从同时执行，变成两个由证据隔开的阶段；物理拆文件只是大型业务项目用于落实这个时间边界的手段。”
- Load-bearing meaning: the selected workflow remains active while evidence decides whether a domain overlay is needed. Domain selection appends knowledge; it cannot replace or restart the task workflow.
- `Evidence / Source: current conversation`

### D5 - Domain activation is evidence-gated

- `Status: confirmed`
- `Authority: user-confirmed`
- Agent proposal accepted by the user:
  - activate immediately for an explicit business-rule question or when the source Plan already declares the applicable business-domain owner;
  - inspect minimal evidence first for ambiguous bugs/features;
  - never activate for clearly technical-only work;
  - keyword matches produce candidates only and cannot activate a business leaf alone;
  - default to one domain owner, adding another only when explicit cross-domain evidence appears.
- Load-bearing meaning: domain routing must trigger reliably, but at the first decision point that actually depends on domain semantics rather than at initial keyword recognition.
- `Evidence / Source: current conversation`

### D6 - Physical domain routing is optional

- `Status: superseded by D13`
- `Authority: user-confirmed sequence`
- Earlier proposal accepted by the user: keep task and domain entries in one manifest when they can still be evaluated at different times, and split only when a large business catalog has an independently selected loading phase.
- Supersession: D13 later replaced that default storage choice to preserve upstream/downstream consistency and prevent first-domain omission. Domain-bearing projects now use the upstream-owned `domain-routing.yaml`; zero-domain projects omit it.
- Retained meaning: the evidence boundary remains mandatory and domain routing still runs only after the task workflow and qualifying evidence. The separate file enforces that timing/ownership contract rather than directory symmetry.
- `Evidence / Source: current conversation`

### D7 - Always Read defaults to empty and lifecycle knowledge loads at use time

- `Status: confirmed`
- `Authority: user-confirmed`
- Agent proposal accepted by the user:
  - Always Read may be empty and should default to empty;
  - `task-execution.md` loads only when a task becomes Managed;
  - Tests-as-Spec loads when constructing test evidence;
  - `task-closure.md` loads only when completion begins.
- Load-bearing meaning: phase transitions, not session startup, activate execution, testing, and closure knowledge.
- `Evidence / Source: current conversation`

### D8 - Preserve one owner and repeat only activation hooks

- `Status: confirmed`
- `Authority: user-confirmed`
- User concern: “但是如果拆到了不同的工作流里面,如果需要修改,不就需要改好多地方吗”
- Agent proposal accepted by the user: full definitions and transition semantics remain with one canonical owner; workflows repeat only the trigger, immediate action, and local acceptance needed to stay actionable.
- Load-bearing meaning: progressive loading must not turn into semantic duplication across workflows.
- `Evidence / Source: current conversation`

### D9 - Resolve the two aggregate rule files asymmetrically

- `Status: confirmed`
- `Authority: user-confirmed`
- Agent proposal accepted by the user:
  - migrate unique `agent-behavior.md` semantics to their real owners, then delete the aggregation file;
  - keep `change-discipline.md` as the single mutation-safety owner, trim unrelated rule-maintenance/testing content, remove it from Always Read, and load it before the first mutation from modifying workflows.
- Load-bearing meaning: do not replace two universal files with a new universal context file. Delete only the aggregation owner that has no independent runtime responsibility; retain the mutation boundary that does.
- `Evidence / Source: current conversation`

### D10 - Keep the runtime kernel small and avoid a new loading DSL

- `Status: confirmed`
- `Authority: user-confirmed`
- Agent proposal accepted by the user: `SKILL.md` keeps only the first-workflow route, Simple-to-Managed transition, evidence-driven expansion rule, domain activation rule, and mutation/testing/closure phase transitions. Do not add a generic context-loading file, score, runtime database, or YAML condition DSL.
- Load-bearing meaning: the architecture should reduce mechanisms and user concepts while making timing explicit.
- `Evidence / Source: current conversation`

### D11 - Bible is product cognition, not runtime knowledge

- `Status: confirmed`
- `Authority: user-confirmed`
- User concern: “bible真的可以在里面使用吗,这个更多的应该只是我们对这个项目的认知而已”
- Agent proposal accepted by the user: the Bible records SBA product direction, is not copied downstream, and is never required by ordinary task workflows. Its confirmed principle is already recorded in `docs/sba-bible.md` principle 9.
- Load-bearing meaning: implementation must activate the principle through routing/workflow contracts; reading the Bible at runtime is not the mechanism.
- `Evidence / Source: current conversation`

### D12 - Root AGENTS.md remains one generated entry

- `Status: confirmed`
- `Authority: user-confirmed`
- User conclusion: “明白了,不应该拆他。”
- User clarification: “agent.md基本不需要改,只要对一些旧实现进行调整就行了”
- Load-bearing meaning: do not physically split or broadly rewrite the root `AGENTS.md`. It remains a single generated cross-tool/project entry. During implementation, change only obsolete implementation wording or generated behavior that conflicts with the new route/domain timing contract; if no such conflict exists, leave the file unchanged.
- `Evidence / Source: current conversation`

### D13 - Upstream must own the domain-routing split protocol

- `Status: confirmed`
- `Authority: user-confirmed`
- User challenge: “那为什么sba不拆分呢,上下游的一致性不就保证不了了吗”
- Agent correction accepted by the user: splitting only Chaos would create a downstream-owned architecture. SBA must define the canonical second-stage file contract, activation rule, synchronization behavior, and validation; domain-bearing downstreams instantiate that upstream contract.
- User selection: “按需生成”
- Load-bearing meaning: domain-free projects do not carry an empty `domain-routing.yaml`. The upstream protocol still owns the file and all validation; once a project admits its first real domain, the file becomes required rather than optional.
- `Evidence / Source: current conversation and current template/script inspection`

### D14 - First-domain materialization must be atomic

- `Status: confirmed`
- `Authority: user-confirmed`
- User concern: “但是我主要害怕后面有领域了又不生成了”
- User authorization: “做”
- Confirmed invariant: only two states are valid: zero domain owners with no `domain-routing.yaml`, or one-or-more domain owners with a non-empty, validated `domain-routing.yaml`. A domain owner without the manifest, an empty manifest, an inline legacy `domain_overlays` block, an unregistered business leaf, or a route pointing to a missing owner is invalid.
- Confirmed activation: the workflow that admits the first `references/business/<domain>.md` must create the owner and domain route in one change, then run the same idempotent sync/check command. Authors do not perform a separate optional follow-up.
- Confirmed enforcement: `sync-routing.sh --check`, orphan scanning, and route reachability fail the invalid states; migration extracts legacy inline overlays before removing them from `routing.yaml`.
- `Evidence / Source: current conversation and current workflow/script inspection`

### D15 - Domain activation checkpoints

- `Status: confirmed`
- `Authority: implementation decision under user-approved Plan`
- Explicit business-rule requests and source Plans that already declare the applicable business-domain owner evaluate `domain-routing.yaml` immediately after the task workflow is selected. A source Plan is always read directly by its owning workflow; its existence alone does not activate a domain.
- Ambiguous bugs/features first inspect the smallest source/runtime slice; the first unresolved decision that depends on business types, state, flow, boundary, or invariant triggers domain selection before dependent reasoning or mutation.
- Clearly technical work records `domain: not needed` for the current decision and never reads the domain manifest. Cross-domain expansion requires explicit evidence after the first owner is loaded.

### D16 - Existing eager fields use a one-time source migration

- `Status: confirmed`
- `Authority: implementation decision under user-approved Plan`
- Task-level `required_reads` move to the owning workflow as initial evidence or later decision-triggered reads. Inline `domain_overlays` move to `domain-routing.yaml`.
- No permanent compatibility runtime remains. Upgrade guidance performs the one-time migration; current validation rejects task `required_reads` and inline overlays so the old and new semantics cannot silently coexist.

### D17 - Roll out upstream first, then canonical downstream sources, then assembly

- `Status: confirmed`
- `Authority: implementation decision under user-approved Plan`
- Implement and close SBA upstream first. After its full checks pass, adapt canonical Chaos and chaos-web app-skill sources, validate them, then assemble exact source output into `release-0.75_shiqi` and verify source/generated equality. Business code and unrelated dirty work remain untouched.

### D18 - Closure spans authorized delivery

- `Status: confirmed`
- `Authority: user-confirmed`
- User approval: “这个按你说的做”。
- Load-bearing meaning: `task-closure.md` is the single late lifecycle gate. It begins only after local execution and non-delivery evidence are complete, may declare `Ready for Delivery`, and remains open across an already-authorized commit/push/MR/deploy/publish/report handoff until the requested artifact is verified. Readiness is not task completion, and Closure does not grant delivery authority.
- Failure boundary: an external-only retry may reuse unchanged local evidence; any changed source, branch/config input, premise, or deliverable returns to fitted verification or Task Execution. Distillation that changes a deliverable must also be reverified before readiness.
- `Evidence / Source: current conversation and the current pushed-branch-without-MR delivery state`

## Options Considered

### Option A - Fixed startup budget

Cap project-document reads before source inspection by token, byte, or file count.

- Benefit: easy to measure and test.
- Cost: confuses cost with correctness, fails across task sizes and harnesses, and encourages gaming the threshold.
- Decision: rejected by D1.

### Option B - Keep eager routing and optimize file sizes

Retain `required_reads` and keyword-selected overlays, but shorten or merge the loaded files.

- Benefit: minimal routing change.
- Cost: keeps the timing bug; unrelated knowledge still loads before evidence and grows again over time.
- Decision: rejected.

### Option C - One manifest, two evidence-separated selection stages

Task routing selects a workflow. The workflow gathers evidence, then evaluates domain candidates and loads one owner when needed. Task and domain entries may remain in one physical manifest.

- Benefit: smallest mechanism change; fixes timing without forcing directory churn.
- Cost: routing schema and workflow wording must make evaluation time unambiguous.
- Decision: superseded as a storage choice by D13. Its evidence-separated timing remains part of the chosen runtime contract.

### Option D - Separate task and domain manifests

Move domain candidates into `domain-routing.yaml` and read it only after the evidence gate.

- Benefit: physically enforces that domain candidates cannot participate in first-workflow selection and gives upstream validation one atomic first-domain contract.
- Cost: one additional manifest in domain-bearing projects; zero-domain projects avoid that cost by omitting the file.
- Decision: chosen materialization protocol by D13-D14. The first real domain creates the non-empty manifest atomically; no empty placeholder ships.

### Option E - Generic context loader or condition DSL

Introduce a common context policy file, scoring model, or YAML expression language that every workflow calls.

- Benefit: centralized mechanism.
- Cost: replaces eager content with universal machinery and makes ordinary maintainers think like framework authors.
- Decision: rejected by D10.

## Chosen Approach

Adopt Option D as the domain materialization protocol while retaining Option C's evidence-separated timing. Zero-domain projects have no `domain-routing.yaml`; admitting the first real domain atomically creates the non-empty manifest and its owner route.

The runtime sequence becomes:

```text
request
  -> task route selects first workflow
  -> workflow performs the smallest decision-relevant inspection
  -> domain gate: explicit / evidenced / technical-only
  -> append zero or one domain owner by default
  -> continue the original workflow
  -> load mutation, test, and closure contracts at their phase boundaries
```

The route owns procedure selection. The workflow owns evidence acquisition and phase transitions. Domain routing owns only domain-owner selection. Each knowledge file owns one complete semantic responsibility. The Bible records why the product follows this model but is absent from the ordinary runtime path.

Implementation uses an upstream-owned optional `domain-routing.yaml`: domain-free projects omit it, while the first admitted domain materializes it atomically. Task `routing.yaml` contains no task-level `required_reads` and no inline overlays. Existing projects migrate once at source level; no dual runtime protocol is retained.

For root `AGENTS.md`, the confirmed direction is intentionally conservative: keep its generated single-file structure and make no broad content change. During implementation, adjust only obsolete implementation wording or generated behavior that conflicts with the new route/domain timing contract; if no conflict exists, leave it unchanged.

At the late lifecycle boundary, Task Execution hands off only after every non-delivery step is verified. Task Closure performs final verification, AAR, conditional distillation and integrity checks, declares `Ready for Delivery`, remains open across the authorized task-specific handoff, and reaches `Closure Complete` only after the requested artifact is verified. No separate delivery workflow or new authorization mechanism is introduced.

## Requirements & Acceptance Criteria

- Task routes no longer pre-load task-level knowledge bundles; `required_reads` is removed from the new runtime contract.
- A workflow can start from its route without reading business overlays, Tests-as-Spec, managed execution, mutation safety, or closure material prematurely.
- A clearly technical bug path completes domain evaluation as `not needed` without loading a business leaf.
- An explicit business-rule request activates its known domain owner immediately after workflow selection.
- An ambiguous feature/bug loads a domain owner only after minimal evidence identifies a business-semantic decision.
- A keyword hit alone never activates a domain leaf.
- Domain activation appends context and preserves the selected workflow; it never substitutes a domain workflow for the task workflow.
- One domain owner is the default; cross-domain expansion requires explicit evidence.
- Always Read is allowed to be empty and defaults to empty in new scaffolds.
- Mutation safety, test semantics, managed execution, and closure each load at their first use boundary.
- `agent-behavior.md` is deleted only after every unique semantic has a discoverable active owner; `change-discipline.md` retains one complete mutation-safety definition and is not Always Read.
- No new generic context-loading file, hard budget, scoring model, runtime store, or condition DSL is introduced.
- The Bible remains upstream product cognition and is absent from generated ordinary runtime dependencies.
- Root `AGENTS.md` remains one generated file and is not physically decomposed.
- A route/load scenario matrix proves the technical, explicit-business, ambiguous-business, and cross-domain paths.
- Before/after read cost is reported as observational evidence; it is not a pass/fail correctness threshold.
- Downstream clone/pull use remains self-contained; no runtime dependency on this SBA repository or the Bible is introduced.
- Domain routing has exactly two valid materialization states: no admitted domain and no manifest, or at least one admitted domain and a non-empty validated manifest. The first-domain write is atomic with route activation.
- Existing routing, smoke, conformance, orphan, reachability, and generated-shell checks remain green after semantic assertions are updated.
- Closure distinguishes local readiness from completion, preserves user authority, and cannot close from a pushed branch when the requested MR or other delivery artifact is still missing.
- Unchanged external-only delivery retries do not trigger unrelated local reruns; changed deliverables or premises do.

## Out of Scope

- Optimizing toward a fixed token, byte, line, or file-count target.
- Splitting root `AGENTS.md` or creating per-workflow copies of full policies.
- Mandatory `domain-routing.yaml` for every project.
- Rewriting business domain truth or changing Chaos application behavior.
- Replacing routing with a general-purpose policy engine.
- Copying the SBA Bible into downstream workspaces.
- Adding a generic `task-delivery.md`, delivery runtime, or implicit commit/push/MR/deploy authority.

## Task Breakdown

### Task 1 - Freeze the route and activation contract

- **Files**: own this Plan, `templates/skill/SKILL.md.template`, `templates/skill/routing.yaml`, `SKILL.md`, and `references/self-hosting-routing.yaml`; read `docs/sba-bible.md`; forbidden: Chaos/downstream files.
- **Consumes**: D1-D14 and the final answers to the Open Questions.
- **Produces**: a task-route schema that selects the first workflow, the evidence/domain activation contract, and an explicit compatibility decision for existing `required_reads`.
- **Acceptance**: static assertions find no new task-level eager knowledge bundle and no runtime dependency on `docs/sba-bible.md`; `git diff --check` passes.

### Task 2 - Move knowledge loading to lifecycle owners

- **Files**: own `templates/skill/rules/agent-behavior.md`, modifying workflows, `templates/skill/workflows/task-execution.md`, `templates/skill/workflows/task-closure.md`, and the existing testing reference/activation surfaces; share Task 1 files read-only; forbidden: downstream assembled copies.
- **Consumes**: Task 1's route/activation interface and D7-D10 plus D18.
- **Produces**: empty-default Always Read behavior, pre-mutation loading of the canonical mutation-safety owner, Managed-only execution loading, evidence-time testing loading, cross-delivery Closure readiness/completion states, and removal of the obsolete aggregation owner after semantic migration.
- **Acceptance**: every migrated semantic has one discoverable owner and an activation hook; no workflow contains a competing full definition.

### Task 3 - Prove upstream behavior

- **Files**: own existing conformance/scenario fixtures and checks only; consume Tasks 1-2 read-only; do not add a new checker unless an existing surface cannot express a demonstrated failure.
- **Consumes**: the final route/load matrix and canonical owner map.
- **Produces**: executable scenarios for technical-only, explicit-business, ambiguous-business, cross-domain, mutation, testing, Closure readiness, delivery failure, and verified completion timing.
- **Acceptance**: `bash scripts/check-all.sh` passes; old eager behavior fails the new semantic assertions; no hard cost threshold is asserted.

### Task 4 - Adapt and assemble Chaos after upstream approval

- **Files**: own the canonical Chaos/chaos-web app-skill sources selected during scope confirmation; downstream `.codex`/`.claude` copies are generated outputs only; forbidden: Chaos business code and unrelated dirty files.
- **Consumes**: passing upstream contract, the chosen domain-catalog layout, and the compatibility strategy.
- **Produces**: delayed domain binding in both app skills, preserved workflow routing, exact assembled copies in `chaos-release-0.75_shiqi`, and a review handoff.
- **Acceptance**: both app-skill validation suites pass; representative source traces follow the intended paths; assembled copies match canonical sources; existing business work remains untouched.

## Implementation Evidence

- **Upstream**: the final Bucket A run `bash scripts/check-all.sh` passes after adding the workspace-aware missing-`code:` target regression, explicit unverified output for workspace-free code roots, D6/D13 reconciliation, and removal of the nonexistent empty-domain example from `distilled_to`.
- **Canonical source**: commits `d5f55e344a639d6ea1f1fb7e2c0b25497c51e5d4` and the review follow-up `062201f02adc52ff2518d5a6e5de113036a9c45d` on `codex/evidence-driven-progressive-disclosure-20260730` are pushed to Codeup. The follow-up fixes the one behavior-audit finding: both app skills had a valid `receiving-review.md` but no first-workflow route for a new review-feedback task. Backend now passes smoke `54/54`, conformance `584/584`, skill orphan `0/32`, skill reachability `0/33`, code-root orphan `0/46`, code-root reachability `0/35`, and route health `11 task + 11 domain`; frontend passes smoke `52/52`, conformance `532/532`, skill orphan `0/34`, skill reachability `0/34`, code-root reachability `0/15`, and route health `10 task + 11 domain`. The historical frontend code-root orphan `references/project-overview.md` remains unrelated.
- **Team review handoff**: the user explicitly deferred MR creation while the combined result receives broader routing/retrieval/loading review. Commit `062201f` is pushed and unmerged; this Plan stays `executing` until the user resumes MR delivery.
- **Assembly**: `aii update release-0.75_shiqi --no-pull --no-self-upgrade` assembled exact commit `062201f`. The earlier stale comparison was not an asset-ref bug: it ran while the original update process was still active and therefore read the previous copy. After waiting for completion, recursive comparisons are empty for canonical -> `.codex`, canonical -> `.claude`, and `.codex` -> `.claude` in both chaos and chaos-web. All four installed `.codex` / `.claude` workspace-aware routing checks pass, and the old prose workflow, broad domain-trigger wording, and shell Closure skip have no non-conformance residue.
- **Behavior review**: structured scenarios pass for the representative frontend first-open bug, backend 500, backend DO/BO modeling, backend/frontend review feedback, explicit business rules, source Plan handling, phase-specific mutation/testing/Closure reads, and DO/BO child-skill composition. Task manifests have empty Always Read, no task-level `required_reads`, and only real `workflows/*.md` procedures. Domain targets resolve only from the second-stage manifest; the representative query still produces a `product-delivery` keyword candidate, but `fix-bug` remains the first workflow and domain activation waits for evidence.
- **Business-work preservation**: `chaos_web` stayed at `9baa56c7e06321762171a5ec8ec53a46e3a80799` with identical clean status/fingerprint. Backend stayed at `8de10642c3d7343b197e57be0087bba0e408e174`; every dirty path present before assembly retained the same SHA-256. A new user-owned `PublishController.java` edit appeared after assembly began and was preserved rather than overwritten or claimed as generated output.
- **Representative read-cost observation**: for “发布弹窗第一次打开一直加载，刷新后正常”, the evidence-first pre-source path is root `AGENTS.md` + chaos-web `SKILL.md` + task `routing.yaml` + `fix-bug.md`, currently `38,493` bytes versus the roughly `90 KB` eager baseline recorded in Context. The domain manifest (`3,402` bytes) and mutation/testing/Managed/Closure owners (`29,886` bytes combined) stay outside that first decision. These figures are diagnostic observations, not correctness thresholds.

## Open Questions

No blocking design questions remain. D15-D18 freeze the implementation choices made under the user's execution authorization; any evidence that contradicts them returns the affected path to this section before continuing.
