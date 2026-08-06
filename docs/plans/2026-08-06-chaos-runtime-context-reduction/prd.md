---
date: 2026-08-06
status: done
distilled_to:
  - docs/sba-bible.md § progressive disclosure / Task Execution / Task Closure
  - references/protocols.md § Task Execution Protocol / Task Closure Protocol
  - templates/skill/SKILL.md.template
  - templates/skill/routing.yaml
  - templates/skill/scripts/sync-routing.sh
  - templates/skill/scripts/smoke-test.sh
  - templates/skill/workflows/task-execution.md
  - templates/skill/protocol-blocks/composite-plan-execution.md
  - templates/skill/protocol-blocks/user-decision-drift.md
  - templates/skill/workflows/task-closure.md
  - templates/skill/protocol-blocks/plan-knowledge-closure.md
  - templates/skill/protocol-blocks/external-delivery-verification.md
  - templates/skill/protocol-blocks/workflow-distillation-proposal.md
  - references/self-hosting-conformance.yaml
  - scripts/check-self-scenarios.sh
  - /Users/shiqi/.ai-infra/chaos/AGENTS.md
  - /Users/shiqi/.ai-infra/chaos/apps/chaos/skills/chaos/SKILL.md
  - /Users/shiqi/.ai-infra/chaos/apps/chaos/skills/chaos/routing.yaml
  - /Users/shiqi/.ai-infra/chaos/apps/chaos/skills/chaos/workflows/inspect-code.md
  - /Users/shiqi/.ai-infra/chaos/apps/chaos/skills/chaos/workflows/task-execution.md
  - /Users/shiqi/.ai-infra/chaos/apps/chaos/skills/chaos/workflows/task-closure.md
  - /Users/shiqi/.ai-infra/chaos/apps/chaos/skills/chaos/protocol-blocks/
  - /Users/shiqi/.ai-infra/chaos/apps/chaos_web/skills/chaos-web/SKILL.md
  - /Users/shiqi/.ai-infra/chaos/apps/chaos_web/skills/chaos-web/workflows/task-execution.md
  - /Users/shiqi/.ai-infra/chaos/apps/chaos_web/skills/chaos-web/workflows/task-closure.md
  - /Users/shiqi/.ai-infra/chaos/apps/chaos_web/skills/chaos-web/protocol-blocks/
---

# Plan: Chaos 高频路径上下文减负

> Current conclusion: keep `chaos` as the automatic backend task entry and preserve natural-language usage, but reduce the internal context cost one admitted slice at a time. The target is not a smaller directory or a fixed token budget; it is a smaller irrelevant-read path for representative tasks while business, permission, schema, testing, knowledge, and delivery semantics remain complete.

## Problem And Scope

The current Chaos backend app skill is a core development dependency. The reported weekly call volume is high enough that even a small repeated startup or lifecycle cost becomes material. The accompanying analysis correctly identifies context weight as a product problem, but it incorrectly treats the complete on-disk skill tree as an eager startup bundle and proposes that ordinary users avoid `#chaos`, name internal workflows, or manually request routing knowledge later.

Current installed evidence from `/Users/shiqi/ai-infra-workspace/chaos-release-0.77_shiqi_bugfix` shows a different shape:

- the complete installed `.codex/skills/chaos` tree is about 468 KB on disk;
- `Always Read` is empty;
- root `AGENTS.md` plus `chaos/AGENTS.md` contribute about 20.9 KB of entry material;
- `SKILL.md` plus `routing.yaml` contribute about 10.5 KB;
- a `fix-bug` route adds about 11.8 KB before later phase owners;
- a common Managed Bug lifecycle can cumulatively read about 86.1 KB across entry, route, `fix-bug`, Task Execution, mutation discipline, Tests-as-Spec, and Task Closure before any conditionally selected domain or Gotcha leaf;
- domain manifests, Gotchas, business leaves, source Plans, architecture references, and delivery owners are already conditional in the current contract.

These byte counts are comparative diagnostics, not correctness gates. The product problem is the combination of:

1. guaranteed entry material that repeats app-specific lifecycle and routing semantics;
2. no compact read-only code-inspection task owner, so queries such as “查一下 IterationManager 状态流转” can enter `fix-bug` or `other -> change-managed`;
3. large phase owners whose conditional branches are loaded together even when a task needs only one lifecycle responsibility;
4. route summaries and shell wording that may repeat canonical routing data;
5. high call volume amplifying every fixed read and tool round trip.

This Plan owns the reduction of the current Chaos backend runtime task path across canonical SBA rules, the Chaos meta repository, and assembled backend consumers. It does not own the general default scaffold materialization contract in `docs/plans/2026-08-04-default-downstream-simplification/prd.md`, and it does not reopen the already implemented progressive-disclosure mainline in `docs/plans/2026-07-30-evidence-driven-progressive-disclosure/prd.md`.

## Related Plan Boundaries

- `2026-07-30-evidence-driven-progressive-disclosure` remains the design source for route-first, evidence-driven expansion, empty Always Read, and phase-triggered lifecycle loading. This Plan measures and reduces remaining current-path cost without replacing that contract.
- `2026-08-04-default-downstream-simplification` remains an independent draft about what a newly materialized downstream project receives. It can complete or be abandoned without blocking this Plan, and this Plan can reduce the existing Chaos runtime without changing the generic materializer.
- `2026-08-05-rule-update-progressive-disclosure` is a completed example of splitting one monolithic owner by independently timed typed inputs. It is evidence for the method, not a requirement to split every large file.
- None of these Plans is `subplan_of` this Plan. No Integrating Plan is required yet because this Plan owns one current Chaos runtime outcome and its sequential task interfaces directly.

## Current Decisions

### D1 - System complexity must not become user prompting discipline

- `Status: confirmed`
- `Authority: user-confirmed product mainline`
- Ordinary users continue to invoke Chaos backend work in natural language. They do not need to know `fix-bug`, `change-managed`, `task-execution`, `domain-routing`, `Always Read`, or any other internal route/owner name.
- “Do not use `#chaos` for simple work”, “load routing rules only after the Agent gets stuck”, and “always name the workflow yourself” are rejected as default product guidance.
- A user may still state semantic intent such as “只读分析，不改代码”, “修复并补相关单测”, or “先讨论方案”; the system owns translation into the lightest correct route and lifecycle.

Decision Context:

- Trigger/question: whether the high-context-cost report should be addressed by changing usage habits or by reducing the system path.
- Faithful answer: the user concluded that a Plan should be written and the identified costs should be reduced one by one.
- Load-bearing meaning: user-visible complexity does not become the optimization mechanism; each reduction is implemented in canonical owners and validated through ordinary natural-language journeys.
- Evidence / Source: current conversation; `docs/sba-bible.md` highest principle and direction 4.

### D2 - Measurements diagnose paths; they do not define correctness

- `Status: confirmed`
- `Authority: existing user-confirmed progressive-disclosure mainline`
- Token, byte, file, tool-call, and elapsed-time measurements compare current and target journeys and expose suspicious growth.
- No universal “under N KB”, “under N files”, or “under N seconds” rule determines correctness.
- A reduction succeeds only when each removed or delayed read cannot change the current decision, while all reads that protect semantics or authority still occur before the protected action.

### D3 - One Plan, one reduction slice at a time

- `Status: confirmed`
- `Authority: user-confirmed`
- This Plan keeps one common outcome and a stable baseline, but each candidate reduction has an independent Design Slice, implementation decision, proof, and stop condition.
- Do not approve or implement all candidates as a batch merely because they appear in this Plan.
- A slice may end as `trim`, `merge`, `split`, `reroute`, `already optimal / no change`, or `rejected`; completion of one slice does not pre-authorize the next.

### D4 - One generated root `AGENTS.md` remains the current physical mainline

- `Status: confirmed, implementation shape under review`
- `Authority: prior user-confirmed D12 in the progressive-disclosure Plan`
- Do not physically split the root `AGENTS.md` or replace it with multiple user-managed entry files.
- New evidence shows the assembled root entry is about 19.7 KB and combines canonical meta `AGENTS.md`, `apps/chaos/AGENTS.app.md`, and `apps/chaos_web/AGENTS.app.md`.
- The first slice may trim or relocate app-specific implementation wording that is already completely owned by the application skills, while retaining one generated root entry and all true cross-application Always-On invariants.
- If a proposed reduction requires a broad semantic rewrite rather than removal of duplicated/obsolete implementation detail, it must explicitly replay and supersede the prior D12 decision before implementation.

### D5 - Canonical owners change before generated consumers

- `Status: confirmed`
- Generic behavior changes begin in SBA only when they apply across real projects. Chaos-specific entry, route, workflow, and conformance behavior is owned in `/Users/shiqi/.ai-infra/chaos`.
- Generated `.codex` and `.claude` copies are updated only through the repository-owned aii assembly path and are never edited as independent owners.
- The bugfix backend/frontend business repositories remain preservation targets, not semantic sources for these app-skill changes.

### D6 - Slice 1 changes only the canonical root `AGENTS.md`

- `Status: confirmed; implementation deferred while later slices are discussed`
- `Authority: user-confirmed in the current conversation`
- Keep one generated root `AGENTS.md`, but make the canonical root source's guaranteed-read responsibility smaller: it owns product identity, true cross-application invariants, security, unknown-ownership triage, and pointers that activate the correct application/platform Skill.
- Application routing algorithms, Plan/modeling procedures, lifecycle state machines, local-development commands, test selection, and Closure mechanics remain in their existing `chaos`, `chaos-web`, or platform workflow owners and load only after application/route/phase selection.
- `/Users/shiqi/.ai-infra/chaos/apps/chaos/AGENTS.app.md` and `/Users/shiqi/.ai-infra/chaos/apps/chaos_web/AGENTS.app.md` are explicitly outside this slice and remain byte-for-byte unchanged, even where they currently repeat application Skill behavior.
- This is a root-only responsibility trim, not semantic deletion, not a physical split, and not authorization to clean up adjacent app shells.

Decision Context:

- Trigger/question: whether the proposed optimization means moving detailed application/lifecycle instructions behind the root entry so `AGENTS.md` itself stays smaller.
- Faithful answer: the user accepted that direction and asked for the concrete modification shape.
- Load-bearing meaning: Slice 1 must produce a statement-by-statement responsibility map for the canonical root source before implementation; it may not merely shorten prose, move the same block into another guaranteed-read file, or expand into the two app shell sources.
- Evidence / Source: current conversation.

### D7 - Long-task mainline is preserved by Task Anchor, not by context luck

- `Status: confirmed; detailed Task Execution reduction shape remains a later Design Slice`
- `Authority: user-confirmed in the current conversation`
- In a long execution flow, the Agent must continue to remember the original outcome and user-confirmed mainline across source discovery, workflow reclassification, implementation, verification, failures, later user messages, subagent returns, and context compaction.
- Task Anchor remains the current-task global owner of `Goal`, `Done When`, and material `Boundaries`; for Design-derived work it references the governing Plan and applicable user-confirmed decisions rather than duplicating their complete transcript.
- Native Plan and the current Workflow may be rebased or replaced when evidence changes the execution path, but they may not silently change the Anchor's goal/mainline. A material Goal, acceptance, scope, authority, or normative-mainline change pauses and returns to the user/owning Plan decision.
- Managed classification is based on dependent steps and drift risk, not mutation. A long or multi-step read-only investigation also establishes an Anchor before its first main step; Simple read-only questions do not pay that cost.
- Anchor Checkpoints refresh the original goal/mainline before each main step and after a user correction, failed premise, interruption/compaction, scope expansion, shared/irreversible action, or Closure boundary.
- Task Anchor remains current-Session runtime state. Cross-Session durability comes from the governing Plan/decision owner; a resumed task reconstructs the Anchor from that owner, the original request, current diff, current workflow, and last verified boundary.

Decision Context:

- Trigger/question: whether Task Anchor should be promoted into an overall orchestrator so a very long workflow sequence does not forget the initial goal and mainline.
- Faithful answer: the user's actual need is continuous memory of the initial goal/mainline throughout long execution; the user accepted keeping Task Anchor declarative, Native Plan as runtime steps, and Task Execution as reclassification/replanning owner rather than promoting Anchor into an orchestrator.
- Load-bearing meaning: strengthen Anchor establishment, checkpoint, transition, and recovery semantics without turning Task Anchor into a workflow selector, step engine, or persistent task database.
- Evidence / Source: current conversation.

### D8 - Slice 2 adds terminal read-only inspection, not automatic workflow transition

- `Status: confirmed`
- `Authority: user-confirmed in the current conversation`
- Explicit explanation, code-reading, call/state-flow tracing, read-only diagnosis, and read-only review intent selects one terminal `inspect-code` workflow. Explicit repair, modification, test, or delivery intent selects the applicable changing workflow directly.
- A bare symptom with no explanation or repair outcome, such as “接口 500 了” or “这里报错了”, preserves the current autonomous Bug path and enters `fix-bug`; it does not pay an `inspect-code` pre-step.
- If the user requests repair after a completed read-only answer, that is a new task intent: re-match the route and reuse still-fresh evidence without treating two complete workflows as concurrent owners.
- Simple inspection stops without Task Execution, mutation discipline, Tests-as-Spec, or Task Closure. A long or dependent read-only investigation may conditionally become Managed and load Task Execution only for Task Anchor, Native Plan, checkpoints, and recovery while `inspect-code` remains the current workflow and no mutation authority is gained.
- This Plan does not add a same-task Workflow Reclassification/Transition Gate. Reopen that architecture only if repeated real cases show that ambiguous symptoms commonly terminate as explanation-only, no-defect, or another owner; otherwise a later evidence-backed diagnosis/repair split inside the single `fix-bug` owner is the narrower optimization.

Decision Context:

- Trigger/question: whether Slice 2 should only terminate explicit read-only work or also make ambiguous symptoms start in inspection and automatically replace the current workflow after classification.
- Faithful answer: the user selected Option A.
- Load-bearing meaning: solve the proven read-only misrouting without expanding this context-reduction Plan into a general workflow-transition state machine or adding an extra inspection read to ordinary Bug repair.
- Evidence / Source: current conversation; current `routing.yaml`, `fix-bug.md`, `change-managed.md`, and Task Execution ownership.

### D9 - Task Execution becomes one continuity kernel plus two conditional protocol owners

- `Status: confirmed`
- `Authority: user-confirmed in the current conversation`
- Keep `workflows/task-execution.md` as the stable Managed-task entry and compact continuity kernel. It owns evidence-bounded expansion, Task Anchor, one Native Plan/current step, proportional user alignment, Anchor Checkpoints, recovery, later-message handling, and phase handoff.
- Compress rather than extract the duplicated Task Classifier and verbose Presentation Gate: classification already occurs before Task Execution loads, while every Managed task still needs one proportional alignment decision.
- Move complete Composite Plan execution semantics behind a conditional protocol owner loaded only when one outcome consumes multiple independently authoritative Plans.
- Move the complete User Decision Drift resolution procedure behind a conditional protocol owner loaded only after code, test, runtime, review, or proposed implementation conflicts with a user-confirmed mainline. The kernel and task workflows retain only the trigger, immediate pause, and canonical-owner link.
- Do not create separate database or failure-learning protocol files in this Slice. Schema mutation remains a compact execution stop linked to the existing Plan Feature database artifact gate, permission owner, and project database workflow; Task Execution retains only the Session failure candidate and direct handoff to the existing typed Verified Failure owner after proof.
- Recitation/recovery, Evidence and Knowledge Gate, Execution Loop, New Message Gate, and compact Exit to Closure stay together because every Managed task co-loads and co-executes them. No new task runtime, loading DSL, state database, Integrating workflow, or user-visible mode is introduced.

Decision Context:

- Trigger/question: which current Task Execution responsibilities are universal Managed-task continuity and which have independently selected evidence/timing that justifies delayed loading.
- Faithful answer: the user accepted one continuity kernel plus two conditional protocol blocks.
- Load-bearing meaning: reduce irrelevant Managed-task reading through responsibility ownership and in-place compression, while preserving Task Anchor mainline continuity and every drift, schema, failure, recovery, and Closure protection before its protected action.
- Evidence / Source: current conversation; installed `task-execution.md` section/read-size analysis and current caller links.

### D10 - Task Closure remains the sole completion owner with three conditional proof protocols

- `Status: confirmed`
- `Authority: user-confirmed in the current conversation`
- Keep `workflows/task-closure.md` as the only owner of Closure entry, proportional Trigger Policy, final contract readback, fresh/fitted verification, Green Stop, lightweight AAR, `Ready for Delivery`, and `Closure Complete`.
- Add a conditional Plan/Knowledge Closure protocol for Design-derived, business-bearing, knowledge-changing, or Composite Plan work. It owns Component-first reconciliation, mainline/Decision Delta replay, business-leaf fidelity, Plan Leaf Reconciliation, Requirement Provenance, Knowledge Reciprocity, and `distilled_to:` calibration; it returns evidence to Closure and cannot declare completion.
- Add a conditional External Delivery Verification protocol only when the user requested commit, push, MR/PR, deploy, publish, database delivery, or another external artifact. It verifies the real artifact and returns `verified / blocked / stale / premise changed`; Task Closure alone converts that result into completion, retry, fitted verification, or Task Execution return.
- Add a conditional Workflow Distillation Proposal protocol only after `Closure Complete` when a plausible repeated-procedure signal already exists. It owns proposal evidence and the `extend / compose / create` recommendation; acceptance still starts the existing newly routed Rule Update workflow and grants no external authority.
- Do not add separate Composite, database, structure, or Verified Failure Closure files. Composite reconciliation is a conditional branch inside Plan/Knowledge Closure; schema readiness/delivery consumes Plan Feature, permission, project database, and external-delivery owners; structure/path work consumes `maintain-docs.md`; Verified Failure is handled before Closure and Closure only checks its outcome.
- Keep only core rationalizations/red flags in the Closure kernel and move branch-specific prevention beside the branch it protects. No conditional protocol may own a competing readiness/completion state.

Decision Context:

- Trigger/question: which Task Closure responsibilities every admitted completion path needs together and which have independent task type, phase, consumer, or authority boundaries.
- Faithful answer: the user accepted one completion kernel plus Plan/Knowledge, External Delivery, and post-completion Workflow Distillation protocols.
- Load-bearing meaning: ordinary local Closure avoids unrelated Plan/business/structure/database/delivery/distillation bodies while every specialized path still returns proof to one final completion decision.
- Evidence / Source: current conversation; installed `task-closure.md` section/read-size analysis and existing Plan Feature, maintain-docs, Rule Update, permission, and delivery ownership.

### D11 - `routing.yaml` owns route data; `SKILL.md` keeps only the route action hook

- `Status: confirmed`
- `Authority: user-confirmed in the current conversation`
- For every Skill with an independent `routing.yaml`, that manifest is the sole owner of route ids, labels, workflow paths, trigger examples, fallback, notes, and other exact first-workflow selection data.
- Keep `## Common Tasks` in `SKILL.md`, but reduce it to one compact executable hook: for each new task, read canonical `routing.yaml`, match exactly one route from labels, trigger examples, and task intent, fall back to `other` when none matches, and load only the selected workflow. The route does not preload project knowledge.
- Do not retain generated per-route rows or a partial summary containing only labels, selected triggers, or workflow names. A half-summary cannot independently select the exact route, but it can become a stale shortcut that encourages the Agent to skip the canonical manifest.
- Skill frontmatter `description` remains the coarse domain-activation owner and must not absorb route keywords or workflow steps. Thin-shell/session bootstrap remains because its independent job is to restore the manifest-read/rematch action after context loss; it does not duplicate route data.
- `sync-routing.sh` continues to generate/check the Always Read block, compact Common Tasks action hook, thin-shell bootstrap, and other generated behavior blocks, but no longer renders the complete route catalog into `SKILL.md`.
- Route count, workflow existence/path integrity, fallback, trigger health, synchronization, and reference completeness checks must read canonical `routing.yaml` directly. Validation may not infer route truth from generated Markdown rows.
- This is a generic SBA generator/validation correction because the same duplication and test coupling exist in the template plus multiple real Chaos application Skills. Chaos canonical app Skills consume the upstream contract and assembled `.codex` / `.claude` copies change only through aii.

Decision Context:

- Trigger/question: whether any route information must remain duplicated in generated `SKILL.md` for activation or compaction recovery after every new task is already required to read `routing.yaml`.
- Faithful answer: the user accepted keeping a compact Common Tasks pointer/action hook while deleting the complete generated route summary, and accepted treating the repeated template/Chaos pattern as a generic SBA capability.
- Load-bearing meaning: preserve domain discovery, exact route selection, rematch, and recovery as distinct responsibilities while removing route data that has no independent consumer or decision.
- Evidence / Source: current conversation; backend/frontend generated summary measurements, current `sync-routing.sh`, thin-shell bootstrap, smoke-test parsing, and canonical routing contracts.

## Candidate Reduction Slices

The sequence below is the current recommendation. Slice 1 through Slice 5 designs are confirmed with implementation deferred until explicit authorization.

### Slice 1 - Guaranteed root-entry cost

`Design status: confirmed; implementation not started.`

Current owners:

- `/Users/shiqi/.ai-infra/chaos/AGENTS.md` - about 13.4 KB;
- `/Users/shiqi/.ai-infra/chaos/apps/chaos/AGENTS.app.md` - about 3.1 KB;
- `/Users/shiqi/.ai-infra/chaos/apps/chaos_web/AGENTS.app.md` - about 2.9 KB;
- assembled root `AGENTS.md` - about 19.7 KB.

Question: which statements are genuinely required before every backend and frontend task, and which repeat route/lifecycle/app behavior already owned by `chaos` or `chaos-web` SKILL/workflow files?

Current recommendation: keep the product purpose, language/security rules, cross-app triage, true cross-app ownership, and canonical skill pointers in the root entry. Replace repeated backend/frontend route algorithms, lifecycle details, and app-local operating instructions with compact activation hooks or app pointers only when the application skill remains fully actionable without the duplicate text.

This is a trim/ownership reconciliation, not a physical split. Exact retained and removed semantics require user confirmation after a before/after responsibility map.

#### Slice 1 Responsibility Map

| Current owner/section | Keep in guaranteed entry | Compress to activation hook | Existing destination / reason | Slice 1 action |
|---|---|---|---|---|
| root `AGENTS.md` lines 1-12: product identity and decision baseline | Product identity, backend/frontend composition, four product-level decision priorities | Tighten the final caveat to one invariant: product priors do not replace routed business/code/runtime evidence | Application domain owners and task workflows own concrete semantics and evidence | `keep + trim` |
| root line 15: simplified-Chinese output | Complete user-facing language requirement | None | No later owner can protect communication before routing | `keep` |
| root line 16: complete routing/loading/session algorithm | Only the fact that the matching application Skill is the executable entry | Route selects the first workflow; domain/lifecycle knowledge loads only when evidence or phase requires it | Backend/frontend `SKILL.md` Path Resolution, Common Tasks/Session Discipline, and phase hooks already own the complete algorithm | `compress` |
| root lines 17-21: Decision Context, Plan, business modeling, leaf and implementation-gap procedures | One cross-application invariant: user-confirmed desired truth is distinct from code/runtime facts and cannot be silently overwritten by them | Activate the matching application Plan/modeling/knowledge-maintenance workflow when the request or evidence requires those semantics | `plan-feature.md`, `profile-business-model.md`, routed business owners, `rule-update/business-truth.md`, and `task-execution.md` own the complete action-changing procedures | `move existing ownership + remove duplicate` |
| root line 22: unknown-ownership Bug triage | Symptom/evidence decides backend, frontend, or explicit cross-app handling | Remove detailed route mechanics | Application `fix-bug` workflows own diagnosis after product-level attribution | `keep + compress` |
| root line 23: unknown-ownership feature triage | Align problem/outcome, then select backend, frontend, or explicit cross-app scope; platform actions use the installed DevOps Skill | Remove Plan path, domain-loading, leaf, legacy-bridge, and lifecycle details | Application `plan-feature.md`, business owners, and installed DevOps Skills own those procedures | `keep + compress` |
| root line 24: session/document arbitration | Formal routed Skill owners outrank transient fragments when they conflict | Re-read only the decision-relevant owner when context freshness is uncertain | Application Skill/session rules own rematch and recovery mechanics | `compress` |
| root line 25: Managed/mutation/test/Closure phase definitions | None beyond the line-16 activation invariant | None | Backend/frontend `SKILL.md` already activates `task-execution`, `change-discipline`, `tests-as-spec`, and `task-closure` at their phases | `remove duplicate` |
| root lines 28-31: credentials, log masking, CI security, non-shadowing | Complete constraints | None | These protect every application before route-specific work | `keep` |
| root line 34: Docker Compose isolation | Retain one compact cross-application environment-safety recommendation for now | None | No current canonical app/platform owner was found; deletion would orphan the only statement. A later owner migration requires locating or changing the real DevOps package source and proving downstream activation | `keep temporarily; unresolved destination` |
| root line 35: prefer `chaos/common` | None | None | Backend `SKILL.md` Common Boundaries already owns the actual DAL/DO/BO/Repo/Convert path; broader reuse must be justified by code evidence rather than a startup slogan | `remove duplicate` |
| root line 36: complex-chain end-to-end contract tests | None | None | Backend/frontend `tests-as-spec.md` and task workflows choose JUnit/Jest/integration/contract/repeatable proof at the testing phase | `remove duplicate` |
| root lines 38-42: application/DevOps/SBA pointers | Backend, frontend, platform, and meta-skill selection pointers | Remove technology inventories and repeated source-layout detail that the selected Skill resolves | Corresponding Skill descriptions, Path Resolution, and boundaries own the detail | `keep + compress` |
| backend `AGENTS.app.md` lines 3-16 | Not evaluated for mutation in this slice | None | It remains an unchanged assembly input; its duplication may be discussed only in a separately approved later slice | `no change; explicit scope exclusion` |
| frontend `AGENTS.app.md` lines 3-18 | Not evaluated for mutation in this slice | None | It remains an unchanged assembly input; its duplication may be discussed only in a separately approved later slice | `no change; explicit scope exclusion` |

#### Proposed Target Outline

The target is still one generated root file assembled from three canonical sources, but this slice mutates only the first source:

1. Root `AGENTS.md`: product identity and decision baseline; Chinese output; desired-truth/current-fact invariant; compact unknown Bug/feature triage; security constraints; compact backend/frontend/DevOps/SBA pointers; the temporarily retained environment-isolation recommendation.
2. Backend `apps/chaos/AGENTS.app.md`: unchanged in this slice.
3. Frontend `apps/chaos_web/AGENTS.app.md`: unchanged in this slice.

The changed root source does not restate route tables, `domain-routing` gates, Plan/leaf creation rules, Task Anchor/Decision Drift definitions, or mutation/test/Closure phase procedures. Those remain reachable through the selected canonical Skill/workflow and are covered by existing conformance plus representative journey checks. Any duplicate source-search, local-launcher, routing, or lifecycle text still present in the unchanged app shells remains out of scope rather than being claimed as removed.

### Slice 2 - Read-only code inspection path

`Design status: confirmed; implementation not started.`

Current evidence: `routing.yaml` has no independent read-only owner. “查状态流转 / 看调用链 / 解释实现 / 分析原因但不改代码” can enter a mutation-oriented workflow.

The concrete collisions are:

| Natural-language intent | Current route | Current workflow pressure |
|---|---|---|
| “查一下这个链路” | `fix-bug` | Requires defect classification, mutation discipline, red-to-green acceptance, implementation, verified-failure handling, and Task Closure |
| “为什么这里 500” / “帮我看下异常” | `fix-bug` | Diagnosis is coupled to a complete repair lifecycle even when the user did not request a change |
| “看一下这块代码” / “帮我分析这个后端问题” | `other` | Falls into `change-managed`, whose contract is explicitly for changes, fan-out, mutation, verification, and Closure |
| “查 IterationManager 状态流转，只分析不改” | `fix-bug` or `other` depending wording | No owner can terminate after a decision-ready explanation without entering a changing workflow |

Confirmed target:

1. Add one backend task route with an internal id such as `inspect-code`, selected from ordinary natural language; users never need to name the id.
2. Add one compact `workflows/inspect-code.md` owner for code explanation, call-chain/state-flow tracing, read-only diagnosis, and read-only code review.
3. Move only explanation/read-only-language triggers such as “查调用链”, “解释状态流转”, “为什么这样实现”, “分析原因”, “只读看看”, and “review 一下但不要改” out of `fix-bug` / `other`. Explicit “修复 / 修改 / 解决 / 补测试 / 提交” requests remain on mutation routes. Bare symptoms with no explanation or repair outcome remain on `fix-bug`.
4. The workflow starts from the named file/method/API/runtime fact, expands only to producers, consumers, guards, state, failure, or UI/API exits needed to answer the question, and stops when the requested conclusion is evidence-backed.
5. A Simple inspection does not load `task-execution.md`, `change-discipline.md`, `tests-as-spec.md`, or `task-closure.md`. A long/dependent inspection may load Task Execution only for Managed continuity while retaining `inspect-code` as the current workflow; no read-only path activates mutation, testing, Closure, patch, test, Plan, business-leaf, AAR, or delivery work.
6. It does not load `domain-routing.yaml` for ordinary technical explanation. Explicit business-rule questions or evidence showing that the answer depends on a business type, flow, state, boundary, or invariant may activate one business owner before the dependent conclusion.
7. If the user later turns a completed/read-only request into a change request, treat that as a new task, re-match to `fix-bug`, `plan-feature`, `do-bo-modeling`, or another changing route, and reuse still-fresh evidence where applicable. An initial request that already includes a repair outcome never selects `inspect-code` first.

This should be implemented in the canonical Chaos backend app Skill first. There is not yet enough cross-project implementation evidence to add the route to the generic SBA template, and this Slice does not pre-authorize a corresponding `chaos-web` route.

Automatic `inspect-code -> changing workflow` transition is intentionally not part of this Slice. The design is evidence-triggered rather than permanently prohibited: reopen it only after repeated real requests prove that routing bare symptoms directly to `fix-bug` commonly loads repair lifecycle unnecessarily. Until then, preserve one complete Bug owner and consider independently timed diagnosis/repair knowledge inside `fix-bug` before adding a general workflow-transition model.

### Slice 3 - Long-task mainline and Task Execution fan-out

`Design status: confirmed; implementation not started.`

Current installed `task-execution.md` is about 16.5 KB. It is already delayed until a task becomes Managed, but the complete owner includes ambiguity, drift, composite Plan, database, pause/resume, delegation, context recovery, and Closure entry semantics.

Confirmed requirement: every Managed task, including a long read-only investigation, has one Task Anchor that preserves the initial Goal/Done When/Boundaries and governing mainline. Each main step performs an Anchor Checkpoint; workflow transition may rebase Native Plan but cannot silently change the Anchor.

Confirmed target:

1. Keep one stable `task-execution.md` kernel containing the Evidence and Knowledge Gate, compact Task Anchor and Plan-mainline reference, Workflow/Native Plan boundary, proportional presentation rule, Recitation/Recovery Loop, Execution Loop, New Message Gate, and compact lifecycle handoffs.
2. Replace the full classifier table with the minimum runtime upgrade/reclassification rule because `SKILL.md` and the selected workflow already decide whether Task Execution loads.
3. Compress the fixed Presentation template into the preserved behavior: Structured alignment only for long/complex/scope-sensitive/confirmation-dependent/no-native-Plan work; otherwise natural compact alignment; never duplicate visible Native Plan steps; proceed unless a real decision or authority boundary blocks.
4. Add one conditionally loaded Composite Plan execution protocol. The kernel retains the trigger and one-owner/one-Anchor/one-Native-Plan invariant; the protocol owns Component state intake, conflict return, successor handling, and integrated execution acceptance.
5. Add one conditionally loaded User Decision Drift protocol. Local workflows and the kernel retain the detection and immediate pause; the protocol is the one complete owner of evidence, user decision, `proposed/confirmed/superseded` transition, Plan/business-leaf/Anchor synchronization, and resume conditions.
6. Keep the schema trigger as a compact link to existing Plan/database/permission owners, and keep only the Session failure candidate plus proof handoff to the existing Verified Failure owner. Do not add near-duplicate small files for either branch.
7. Update canonical callers, deep links, conformance, scenarios, and generated consumers so every extracted definition has one owner and ordinary Managed journeys do not load either conditional protocol without its trigger.

This is a trim plus two evidence-routed extractions, not a file-count target. The Task Anchor/Checkpoint/recovery kernel remains complete enough to preserve the original Goal, Done When, Boundaries, and governing mainline throughout long mutation and long read-only work.

### Slice 4 - Task Closure progressive disclosure

`Design status: confirmed; implementation not started.`

Current installed `task-closure.md` is about 19.9 KB and contains ordinary local verification/AAR, Plan and business reconciliation, verified-failure accounting, integrity work, database closure, external delivery completion, and post-completion workflow distillation.

Confirmed target:

1. Keep one `task-closure.md` completion kernel with Entry Gate, Trigger Policy, final Done Contract/Anchor readback, fresh/fitted verification and Green Stop, already-triggered outcome checks, lightweight AAR, proportional integrity hooks, readiness, and the sole `Closure Complete` decision.
2. Add one conditional Plan/Knowledge Closure protocol for Design-derived, business-bearing, knowledge-changing, and Composite Plan tasks. It owns complete Component/mainline/business-leaf/Plan Leaf/Knowledge Reciprocity reconciliation and returns pass/block evidence to the kernel.
3. Add one conditional External Delivery Verification protocol only for requested shared-system artifacts. It verifies actual refs, branches, MR/PR state, deployed/published outputs, or database migration/schema readback and returns a typed result without granting authority or declaring completion.
4. Add one conditional Workflow Distillation Proposal protocol after `Closure Complete` and only when an already-plausible repeat signal exists. It preserves the previously confirmed proposal timing and sends accepted work to the existing typed Rule Update owner as a new task.
5. Move Chaos full-structure commands and complete path/integrity mechanics to or behind the existing `maintain-docs.md` owner; the Closure kernel retains only the path-classification trigger and consumes the result.
6. Keep schema and Verified Failure as compact outcome checks against their existing owners. Do not re-run failure diagnosis, duplicate SQL artifact contracts, or infer database delivery from a reviewed SQL file.
7. Keep core rationalizations in the kernel; place delivery-, Plan/knowledge-, structure-, or failure-specific rationalizations with the owner that changes the applicable next action.

All conditional protocols return reconciliation or proof to `task-closure.md`. None owns `Ready for Delivery`, `Closure Complete`, delivery authority, or a parallel task-completion state.

### Slice 5 - `SKILL.md` and `routing.yaml` duplication

`Design status: confirmed; implementation not started.`

Current installed backend `SKILL.md` is 84 lines / about 6.7 KB, its `routing.yaml` is 100 lines / about 3.8 KB, and the generated Common Tasks route catalog contributes 12 lines / about 2.4 KB inside `SKILL.md`. The frontend has the same ownership shape: about 6.6 KB in `SKILL.md`, including an 11-line / about 2.1 KB generated route catalog. The generic SBA template uses the same generator and validation contract.

The frontmatter description already activates the Skill at a coarse domain level. Every new task and every shell/session recovery path is separately required to read `routing.yaml` and select exactly one route from its labels, trigger examples, and intent. Therefore the per-route Markdown catalog has no independent route-selection or recovery decision; it repeats data that the next mandatory read must consume anyway.

Confirmed target:

1. Preserve the `## Common Tasks` heading as a compact action hook, not a route catalog. It instructs the Agent to read canonical `routing.yaml`, select exactly one route, fall back to `other`, and load only the selected workflow.
2. Remove generated per-route labels, workflow links, trigger examples, and notes from `SKILL.md`. Do not replace them with a shorter partial catalog.
3. Keep the frontmatter description domain-level and keep thin-shell/session bootstraps as independent compaction-recovery hooks; neither becomes a second route-data owner.
4. Change the generic `sync-routing.sh` contract so it generates/checks the compact hook and existing shell/behavior blocks without rendering the full route catalog.
5. Move smoke/conformance assertions for route count, workflow path, fallback, trigger quality, synchronization, and references to direct `routing.yaml` validation. A missing or malformed canonical manifest must fail even when Markdown looks plausible; a valid manifest must not depend on generated route rows.
6. Apply the generic contract to canonical Chaos backend/frontend Skills through their project-owned source and aii assembly path. Installed `.codex` and `.claude` copies remain generated consumers.

This is ownership convergence, not removal of routing. Exact selection becomes more reliable because one structured source owns all route data, while the always-visible surfaces retain only the actions needed to reach and recover that source.

### Slice 6 - Final canonical/downstream reconciliation

After admitted slices are complete:

- reconcile generic conclusions into SBA only where cross-project evidence exists;
- adapt canonical Chaos backend/frontend owners without flattening their project-specific differences;
- run aii assembly into the authorized downstream workspace;
- verify canonical / `.codex` / `.claude` equality;
- prove backend/frontend business-code dirty state was preserved;
- freeze this Plan only after all implemented slices have current evidence and rejected slices have reasons.

## Requirements And Acceptance

- Natural-language backend requests continue to activate `chaos`; no optimization requires users to suppress `#chaos`, name route ids, or request rule loading manually.
- The system distinguishes read-only inspection, Simple mutation, Managed mutation, business-bearing work, schema change, and external delivery from evidence and lifecycle, not from file count or user knowledge of SBA.
- No candidate file is split because it is large. Every new owner needs an independently selected task, phase, consumer, authority boundary, or maintenance lifecycle.
- Content universally loaded and changed together remains together unless generation/ownership proves another boundary.
- Every deleted or moved statement has a unique destination, owner, normal activation path, and fitted non-regression proof.
- True cross-application Always-On invariants remain in the single generated root entry; app-local complete procedures remain in application skill owners.
- Simple pure Q&A/read-only journeys do not load mutation, testing, Managed execution, or Closure protocols.
- Long or dependent read-only journeys may become Managed for drift control and then establish Task Anchor/Native Plan without activating mutation, testing, or Closure owners.
- Workflow or premise changes may rebase the one Native Plan, but the original Goal/Done When/Boundaries and governing user-confirmed mainline remain stable until an explicit user/Plan decision changes them.
- Simple changing journeys load only the task workflow plus phase owners actually activated by mutation, testing, and completion.
- Complex, business-bearing, schema-changing, permission-sensitive, and externally delivered journeys retain all currently required gates before their protected actions.
- Rule, route, shell, generated block, or structure changes pass applicable sync, conformance, smoke, orphan, reachability, route-health, path-integrity, and representative behavior checks.
- Measurements report current and target path differences but never become fixed correctness thresholds.
- No database-structure change is involved in the Plan itself.

## Representative Validation Journeys

1. **Read-only state trace** - “帮我查一下 IterationManager 的状态流转，只分析，不改代码。” Expected: one read-only task owner, minimal code/reference evidence, no mutation/test/Managed/Closure owner.
2. **Simple localized fix** - one known Java owner, one behavioral change, one targeted regression. Expected: no Managed Task Execution unless evidence expands scope; mutation/test/Closure load only at their phase.
3. **Ambiguous backend Bug** - symptom known, owner/root cause unknown. Under the current recommended Slice 2 boundary, expected: retain `fix-bug` as the single current workflow, use its evidence gates before mutation, and do not route through terminal `inspect-code`. A future progressive split of the Bug workflow requires a separately confirmed owner/state design.
4. **Cross-module state change** - several producers/consumers and a user-confirmed Plan. Expected: complete Task Execution, Plan replay, drift gate, fitted verification, and Closure remain available.
5. **Business-bearing behavior conflict** - code conflicts with confirmed domain truth. Expected: delayed domain owner activates before dependent reasoning; desired truth is not inferred from code.
6. **Schema change** - a new/changed column, index, constraint, or table. Expected: Plan database checkpoint, dedicated SQL sibling, execution owner, permission boundary, and database Closure remain intact.
7. **External delivery** - commit/push/MR requested. Expected: local readiness and verified external artifact remain separate; delivery-specific knowledge loads only at the delivery boundary.
8. **Context recovery** - task resumes after compaction. Expected: original Goal/Done When/Boundaries, governing mainline, current workflow, current diff, last verified boundary, and next-decision evidence recover without replaying the complete skill tree or silently changing acceptance.

For each journey, record:

- entry files and bytes before the first source/runtime evidence;
- conditional knowledge files and the decision that activated each one;
- lifecycle files and their phase;
- time/tool calls to the first decision-ready result where observable;
- semantic acceptance and any route/owner regression;
- before/after difference and stop condition.

## Task Interfaces

### T1 - Reconcile the single root entry

- Files: canonical Chaos meta `AGENTS.md`, its assembly contract, and existing validation anchors. The two `apps/*/AGENTS.app.md` sources are preservation inputs and must not be edited.
- Consumes: D1-D5 and Slice 1 user decision.
- Produces: one smaller but complete canonical root source and assembled root entry, or an evidence-backed `no change` conclusion, with both app shell sources unchanged.
- Acceptance: a responsibility map accounts for every current root statement; backend/frontend normal tasks retain activation and cross-app safety; assembled output and current behavior checks pass; both app shell files are byte-equal to their pre-change state.

### T2 - Establish the read-only journey owner

- Files: SBA routing/template owners only if generic evidence admits them; canonical Chaos backend `routing.yaml`, `SKILL.md`, selected workflow owner, conformance/scenario coverage, and generated consumers.
- Consumes: completed T1 evidence and Slice 2 user decision.
- Produces: a natural-language read-only path that avoids mutation lifecycle owners, or a proven current-owner fast path.
- Acceptance: Journey 1 reaches source evidence and returns a complete explanation without mutation/test/Closure loading; explicit repair and bare symptoms do not detour through `inspect-code`; a later repair request re-matches as a new task intent while reusing still-fresh evidence; a long/dependent read-only investigation may use Managed continuity without changing workflow or gaining mutation authority.

### T3 - Preserve long-task mainline and reduce Task Execution fan-out

- Files: SBA and Chaos Task Execution owners/callers/conformance selected by the Slice 3 continuity-kernel and independent-load tests.
- Consumes: completed prior slices and Slice 3 user decision.
- Produces: one compact Managed-task continuity kernel plus conditionally loaded Composite Plan execution and User Decision Drift protocol owners.
- Acceptance: long mutation and long read-only journeys retain original Goal/Done When/Boundaries and governing mainline across main steps, premise/workflow changes, later messages, failures, and compaction; ordinary Managed journeys do not load composite/drift bodies without their evidence trigger; schema and verified-failure protections still activate through their existing owners; Simple journeys do not pay Managed overhead.

### T4 - Reduce Task Closure fan-out

- Files: SBA and Chaos Task Closure owners/callers/conformance only after the Slice 4 independent-load test passes.
- Consumes: completed prior slices and Slice 4 user decision.
- Produces: one compact completion kernel plus conditionally loaded Plan/Knowledge Closure, External Delivery Verification, and post-completion Workflow Distillation Proposal owners.
- Acceptance: ordinary local Closure does not load Plan/business/structure/database/delivery/distillation bodies without their trigger; Composite, schema, integrity, verified-failure, external-delivery, and proposal journeys still consume their complete canonical owners; only `task-closure.md` declares `Ready for Delivery` or `Closure Complete`.

### T5 - Audit `SKILL.md` / routing duplication

- Files: generic SBA `SKILL.md` template, routing generation/sync owner, smoke/conformance/reference consumers, thin shells, canonical Chaos backend/frontend `SKILL.md` and routing owners, and generated consumers selected by Slice 5 evidence.
- Consumes: completed prior slices and Slice 5 user decision.
- Produces: one structured route-data owner plus compact `SKILL.md` and shell action hooks, with no generated per-route Markdown catalog.
- Acceptance: Skill discovery remains domain-driven; every new task and compaction recovery reads canonical `routing.yaml`, selects exactly one route, falls back to `other`, and loads only the selected workflow; route count/path/fallback/trigger/reference checks derive directly from the manifest; template and canonical/assembled Chaos surfaces remain synchronized; representative entry bytes decrease without changing route outcomes.

### T6 - Assemble, validate, reconcile, and freeze

- Files: every implemented canonical owner, this Plan, true semantic destinations, and repository-owned generated consumers.
- Consumes: T1-T5 completed/rejected outcomes.
- Produces: final source/generated equality, representative journey evidence, business-worktree preservation proof, `distilled_to:` reconciliation, and `status: done`.
- Acceptance: all admitted changes pass fitted Bucket A/B Closure; no implemented conclusion remains only in the Plan; rejected candidates have explicit no-change reasons.

## Boundaries

- Do not require route ids or SBA vocabulary in user prompts.
- Do not defer rules until after an error when they protect a decision or mutation boundary.
- Do not use the complete on-disk skill size as evidence of eager loading.
- Do not claim a percentage improvement without representative before/after evidence.
- Do not create a context database, read ledger, loading DSL, scoring runtime, route counter, usage signature store, or candidate queue.
- Do not add a new workflow merely to make the directory look cleaner; a read-only workflow requires a real independently selected task contract.
- Do not remove root product, language, security, cross-app triage, ownership, or permission semantics without an active replacement.
- Do not weaken business provenance, Decision Drift, database artifact, verified-failure, knowledge reciprocity, Task Closure, or external delivery proof.
- Do not edit installed `.codex` / `.claude` copies directly or modify backend/frontend business code as part of skill reduction.
- Do not commit, push, create an MR, assemble downstream, or perform other external delivery without separate user authorization at the applicable slice.

## Open Questions

None. Slice 1 through Slice 5 have user-confirmed design boundaries.

## Implementation Authorization

Authorized on 2026-08-06 for local implementation in this SBA repository, canonical Chaos adaptation where required, aii assembly into `/Users/shiqi/ai-infra-workspace/chaos-release-0.77_shiqi_bugfix`, downstream workflow audit, and downstream-to-SBA reverse validation. Commit, push, MR, merge, deploy, publish, database work, and other external/shared-system delivery remain unauthorized.

## Final Reconciliation And Reverse Validation

`Status: done; frozen after local Closure on 2026-08-06.`

### Execution order and canonical evidence

The authorized order was followed: SBA first, canonical Chaos adaptation second, aii assembly into the named downstream third, downstream representative-journey audit fourth, and reverse validation back to SBA last.

- SBA `bash scripts/check-all.sh --base HEAD` exited `0`: temporary downstream smoke `49 passed / 0 failed`, existing-project smoke `49 / 0`, self-scenario `501 / 0`, self-hosting conformance `415 / 0`, orphan/reachability checks green, and upstream maintenance checks green.
- Canonical Chaos backend conformance was `805 / 0`, smoke `56 / 0` with only the existing fresh-migration `Known Gotchas` warnings, skill orphan `0 / 37`, skill reachability `0 / 38`, and route health `12 task routes + 11 domain overlays, no quality smells`.
- Canonical Chaos frontend conformance was `759 / 0`, smoke `58 / 0` with the same existing fresh-migration warnings, skill orphan `0 / 38`, skill reachability `0 / 38`, and route health `10 task routes + 11 domain overlays, no quality smells`.
- Canonical sync checks pass structurally. Code-root target checks are intentionally evaluated against the downstream workspace, because the canonical meta checkout does not contain the generated business code roots.

### Downstream assembly and preservation

`aii update release-0.77_shiqi_bugfix --no-pull --no-self-upgrade` was run after the canonical correction and exited `0`. Recursive comparison proves canonical backend/frontend owners equal both `.codex` and `.claude` consumers; each Codex/Claude pair is also byte-equal. `aii status` ends with the target iteration `一致，无告警`; warnings printed for other iterations are not target failures.

The downstream checks were run from the installed skill roots with the real workspace root for code-root validation. Both backend harnesses passed sync, smoke, conformance, skill orphan/reachability, code orphan/reachability, and route health. Both frontend harnesses passed sync, smoke, conformance, skill orphan/reachability, and route health. The frontend code-root audit retains one pre-existing orphan, `references/project-overview.md`; the downstream migration Plan already records it as unrelated to the current migration. It is not an installed-skill regression, was not created by this Plan, and was not deleted or edited because its canonical owner is the downstream business/docs repository outside this scope. This residual is an explicit limitation of the code-root audit, not a claim of zero code-root orphans.

Business-worktree protection is proven against the final snapshots, not by an unsafe equality claim during concurrent editing:

- frontend stayed on `release-0.77_shiqi_bugfix` at `423652ae00735827374dde1f2f6a91ed9206256a`; its final dirty snapshot remained unstaged and conflict-free (`status=9e20ee21d378142776e7d9451e44dc29c75f382886c8bc8ca0a0dabf5a62f3a0`, `unstaged=f1e3a0aab2131e4c2d9455c0f413a86457558349feee77e28253e2c49578bfd0`, empty staged/unmerged streams).
- backend stayed on `release-0.77_shiqi_bugfix` at `1b3d4a0b255e6bb8b4809b93b519cd9836c97199`; another editor continued changing its dirty diff during the assembly window, but the branch, HEAD, staged stream, and unmerged stream were never changed by assembly. The final snapshot is `status=98e7b64ec0684a69bdf14fc5cf3a5c1d30ba7b445a5c3314a2121cbb338e4e81`, `unstaged=32887eb0657d6e917c5d07da726f40f2bd95e6df191f7802ad47bf08f04beed3`, empty staged/unmerged streams. Therefore backend pre/post byte identity is deliberately not claimed.
- Canonical app-shell preservation hashes remain unchanged: backend `AGENTS.app.md` `a1a17d271113f6c9466d82c2fd2f3bc4cb5952d22e3a289d238c87f119dc9df0`; frontend `AGENTS.app.md` `4628ef56e713c4becf21680ba3807fa99a71297212b253660eab770666ba6ec0`.

### Downstream representative journey audit

The installed behavior matches the intended user contract:

1. Explicit backend read-only tracing selects terminal `inspect-code`, reads only decision-relevant code/reference evidence, and does not load mutation, testing, or Closure owners.
2. A long/dependent read-only investigation may load Task Execution only for Anchor, Native Plan, checkpoint, and recovery continuity; it gains no mutation authority.
3. A bare backend symptom remains on the autonomous `fix-bug` path; an explicit repair request enters the changing workflow directly; “修复” after a completed read-only answer is a new route match, not concurrent workflow composition.
4. Simple mutation keeps the direct fast path; Managed execution and Task Closure appear only when dependent steps, drift risk, or completion evidence require them.
5. Composite Plan work has one Integrating owner, one Anchor, one Native Plan, and typed Component evidence; components do not create competing task state.
6. User Decision Drift pauses the affected path immediately, marks alternatives `proposed`, marks the old decision `superseded`, and resumes only after the user/Plan owner settles the delta.
7. Ordinary local Closure does not preload Plan/Knowledge, external-delivery, or workflow-distillation bodies. External delivery loads its proof owner only for a requested artifact, and only Closure declares `Ready for Delivery` / `Closure Complete`.
8. Workflow-distillation proposal is considered only after `Closure Complete` and two independently completed instances; the instances may be in the same Session or across tasks/Sessions. Composition alone, retries inside one unfinished result, decline/defer, blocked work, and unverified work produce no proposal.
9. Context compaction re-matches the route and restores only the current workflow plus decision-relevant evidence; it does not replay the complete Skill tree or silently change the Anchor mainline.

### Reverse validation result

The SBA generic owner contracts were re-read against the assembled Chaos consumers. Project-specific differences are valid adaptations: Chaos adds backend permission/devops-version and frontend UI/API/cross-application ownership, while the generic typed protocols and one-kernel/one-completion-owner boundaries remain intact. One actual semantic defect was found: both Chaos workflow-distillation owners had omitted the generic rule that the two independent instances may be compared across Sessions. That gap was repaired in both canonical app owners and their conformance contracts, then reassembled and revalidated in all four installed roots. No SBA generic owner required a further change.

The remaining intentionally unresolved scope is explicit: the generated iteration-root `AGENTS.md` still contains the unchanged application-module layers, and frontend has no dedicated terminal `inspect-code` route because this Plan admitted that route as backend-only. Neither is reported as solved by this Plan.

### Closure outcome

All admitted slices have canonical owners, normal activation paths, and current fitted evidence; no implementation conclusion remains only in this Plan. The frontend code-root orphan is recorded as a pre-existing out-of-scope residual, not hidden or “fixed” by deleting downstream material. No commit, push, MR, merge, deploy, publish, database, work-item, version-revision, or other external/shared-system action was performed for this Plan. The Plan is therefore reconciled, marked `done`, and frozen.
