---
date: 2026-07-27
status: done
distilled_to:
  - REFERENCE.md
  - WORKFLOW.md
  - docs/sba-bible.md
  - docs/plans/README.md
  - docs/plans/_TEMPLATE.md
  - references/business-global-model.md
  - references/protocols.md
  - templates/skill/workflows/change-managed.md
  - templates/skill/workflows/fix-bug.md
  - templates/skill/workflows/plan-feature.md
  - templates/skill/workflows/profile-business-model.md.example
  - templates/skill/workflows/receiving-review.md
  - templates/skill/workflows/task-closure.md
  - templates/skill/workflows/task-execution.md
  - templates/skill/workflows/update-rules.md
---

# User-Confirmed Plan Mainline

## Context

Plan and brainstorm conversations contain the product owner's clearest normative decisions, but the current workflow can leave them as transient chat or frozen provenance. Later Plan edits, code reasoning, implementation, and review can then follow current code or an Agent preference instead of the user's confirmed mainline.

## Problem

The system must preserve the decision-bearing question/correction and answer inside the Plan folder, distill stable confirmed business meaning when the design is handed to implementation, and reactivate that mainline throughout delivery. Code remains evidence of current implementation, not authority to rewrite desired business truth.

## Decision Context

### D1 — Plan owns brainstorm evidence and business-rule distillation

- `Status: confirmed`
- `Authority: user-confirmed`
- User statement: “也就是我们要把头脑风暴的内容主要记在plan的文件夹内,然后在最后plan完成之后,也要以这个为主然后写入业务逻辑规则里面”
- Load-bearing meaning: keep brainstorm questions, answers, choices, corrections, and trade-offs primarily in the Plan folder; when the design is confirmed for implementation, distill its stable confirmed business conclusions into the routed business-rule owner.
- Scope: Complex / Large product and business Plans; Simple decisions remain in the conversation unless a durable Plan already exists.
- `Evidence / Source: current conversation`

### D2 — Later work must replay the recorded mainline

- `Status: confirmed`
- `Authority: user-confirmed`
- User statement: “以及我们每一次修改plan,推延代码的时候,都应该参考这个记录的内容”
- Load-bearing meaning: every later Plan edit, code reasoning or implementation step, review, and closure must read the relevant confirmed decisions; the Plan is an active decision source during delivery, not archive-only provenance.
- Scope: the affected Plan and implementation path; load only relevant confirmed decisions rather than replaying unrelated research.
- `Evidence / Source: current conversation`

### D3 — Implementation drift is an immediate user stop gate

- `Status: confirmed`
- `Authority: user-confirmed`
- User statement: “代码可以暴露约束、成本和风险，但无权替用户修改已经确认的业务主线。发现偏移必须立即停下来协商，不能静默妥协，也不能拖到最后补报。”
- Load-bearing meaning: current code may expose constraints, cost, and risk, but cannot redefine the confirmed business mainline. If implementation conflicts with or drifts from it, pause the affected path immediately, show the gap and trade-offs, and obtain a new user decision before continuing.
- Scope: changes to product meaning, business rules, scope, flow, state, boundary, invariant, acceptance, or user-visible behavior; ordinary implementation choices that preserve them do not trigger another confirmation.
- `Evidence / Source: current conversation`

## Options Considered

1. Keep discussion only in chat and summarize at Closure — rejected because context can disappear and drift is discovered too late.
2. Keep the Plan as archive-only and wait for implementation before updating business rules — rejected because later implementation lacks an activated normative source.
3. Use a Plan decision mainline, distill confirmed desired truth at implementation handoff, and track current implementation separately — chosen because it preserves user authority without claiming unimplemented code exists.

## Chosen Approach

- Store the user-confirmed decision mainline in the Plan's Decision Context with authority, source, scope, and faithful wording.
- At design-to-implementation handoff, distill stable confirmed normative business meaning into the unique routed business leaf with Requirement Provenance back to this Plan.
- Keep `desired business truth` separate from `current implementation fact`; allow an explicit gap instead of rewriting either side.
- Require Plan edits, execution, bug fixing, review, and Closure to replay the relevant mainline.
- Add an immediate drift gate: stop only the affected path, present evidence and trade-offs, and resume after the user's explicit decision.

## Requirements & Acceptance Criteria

- Reusable Plan workflow records clear user answers/corrections as confirmed authority and preserves short answers verbatim with their question/context.
- Plan handoff performs business-rule distillation before implementation begins.
- Business-model guidance supports desired truth plus current implementation fact without mixing them.
- Execution/change/fix/review workflows activate the Plan mainline and implement the immediate drift gate.
- Closure verifies user-confirmed decisions against implemented behavior and cannot defer first disclosure of drift.
- Conformance and full repository checks protect these behaviors.
- Chaos and chaos-web productized workflows carry equivalent project-specific behavior and are reassembled into `release-0.75_shiqi`.

## Out of Scope

- Plugin-market packaging or release.
- Copying whole chat transcripts into business leaves.
- Treating user statements about current code as verified implementation facts.
- Reconfirming clear answers or blocking unrelated independent work.

## Task Breakdown

### Task 1 — Update reusable SBA contracts
- **Files**: Bible, Plan/business-model/protocol references, Plan/execution/change/fix/review/record/closure templates, conformance, plan archive guidance
- **Consumes**: D1–D3
- **Produces**: generic user-confirmed mainline and drift-gate contract
- **Acceptance**: `bash scripts/check-all.sh`

### Task 2 — Update chaos productized contracts
- **Files**: root AGENTS plus chaos/chaos-web workflow and conformance sources
- **Consumes**: Task 1 semantics and project-specific Plan/business owner paths
- **Produces**: equivalent backend/frontend behavior in a fresh review-only MR from current meta-repo `origin/master`
- **Acceptance**: both app conformance, routing, smoke, orphan, reachability, route-health, and `aii lint --dir .`

### Task 3 — Reassemble delivery workspace
- **Files**: generated `.codex/.claude` skill copies under `release-0.75_shiqi`
- **Consumes**: exact pushed meta commit
- **Produces**: installed copies matching meta sources
- **Acceptance**: per-file `cmp`, preserved chaos/chaos_web repository HEADs and protected-file hashes, MR remains unmerged

## Open Questions

None. The product owner confirmed the normative mainline in D1–D3.
