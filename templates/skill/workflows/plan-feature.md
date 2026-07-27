# Plan Feature Workflow

> **Inline by default.** Planning evidence and decisions belong in the main context. Read [`subagent-auxiliary.md`](subagent-auxiliary.md) only for an independent, result-only research workstream with real overlap and positive Net Benefit; planned multi-workstream execution uses [`subagent-driven.md`](subagent-driven.md).

Use this for planning requests. It resolves what should be done; it is not the runtime Native Plan. Simple plans stay inline unless the user asks for a file.

## Complexity Gate

| Size | Signal | Action |
|---|---|---|
| Trivial | typo, comment, obvious one-line change | skip this workflow |
| Simple | clear goal, 1–2 files, no product ambiguity | short inline plan; at most one confirmation |
| Complex | multiple files, unclear behavior, dependency, architecture choice, or long run | create `docs/plans/YYYY-MM-DD-<slug>/prd.md` |
| Large | multi-subsystem, irreversible/expensive, high uncertainty, or many unknowns | Complex plan + read [`plan-large.md`](plan-large.md) |

## Question Gate

- **Gate A: Derivable?** Inspect evidence first; **Gate B: Meta/lazy?** never ask the user to do Agent-available discovery; **Gate C: Blocking/preference?** ask only blocking or preference questions.

Ask one question at a time and offer concrete trade-offs for preferences.

## User-Confirmed Decision Mainline

When the Agent asks a product/business question, or the user directly selects, rejects, or corrects a direction, that clear answer is the highest-authority input for the corresponding normative decision. If it identifies one load-bearing meaning, mark the Decision Delta `Status: confirmed` without reconfirming; clarify only materially different interpretations. For Complex/Large work, keep this mainline in `prd.md` Decision Context with `Authority: user-confirmed`, the question/correction, load-bearing meaning, scope, and `Evidence / Source: current conversation`. Preserve short answers verbatim with their context; summarize long answers faithfully. Simple work may stay in conversation unless a durable Plan exists.

The confirmed answer defines `desired business truth`; code, tests, and runtime prove `current implementation fact`. Agent inference, current implementation, older documents, or an earlier proposal may expose a gap but cannot silently overwrite the user-confirmed mainline. Replacing it requires a new explicit user decision and a `superseded` Delta.

## Business-Semantics Gate

For a business-bearing module, read its routed business global model before treating code as intended behavior. Compare in this order:

1. business model — what the business says should be true;
2. architecture / rules / contracts — how the system intends to realize it;
3. code / tests / runtime — what is currently true.

Record `business-model impact: unchanged / proposed change / unknown`. A proposed change to a type system, macro flow, state machine, boundary, or core invariant is a design decision, not an implementation detail. At implementation handoff, a business-bearing Plan distills stable user-confirmed semantics into the routed model as `desired business truth`, with Plan provenance; code/tests/runtime stay separate `current implementation fact`. If no confirmed Plan yet owns stable business meaning, the optional modeling choice remains; once handoff does, create the minimum owner instead of continuing without persistence.

If new evidence overturns a load-bearing conclusion, do not silently replace it: re-check the user-confirmed mainline, chosen approach, acceptance criteria, boundaries, and Task Anchor before continuing. The Agent may verify facts, constraints, cost, and risk, but a normative business judgment requires confirmation from the business owner.

## Brainstorm — Diverge Before Converging

For Complex/Large work, inspect adjacent evidence, then generate at least two genuinely different solution shapes with honest trade-offs. Every candidate remains `proposed` until the user directly answers, selects, rejects, or corrects it; the clear response enters the user-confirmed mainline. For Large or highly ambiguous work, present the chosen design and obtain buy-in before writing Task Breakdown. Trivial/Simple work skips this.

## Complex Plan

Create only `prd.md` initially; add a sibling only when content has an independent loading reason. Use these section names, in order, only when warranted: Context; Problem; Decision Context; Options Considered; Chosen Approach; Requirements & Acceptance Criteria; Out of Scope; Task Breakdown; Open Questions.

Plans are active while `draft` or `executing`; on `done` or `abandoned`, freeze them as audit history. If the workflow-state hook is installed, point `.skill-workflow-state` at this workflow while planning and remove it at closure.

Only when the task migrates, deletes, or supersedes durable knowledge, record a compact knowledge-impact contract in the existing Plan: legacy source, active destination, owner, activation path, and validation. Do not create a migration dossier or fixed ledger for an ordinary requirement; when a many-file migration genuinely needs one, freeze it after reconciliation instead of maintaining it forever.

When the user approves the design and requests implementation, first run the **Plan Mainline Handoff**: replay the latest confirmed/superseded Decisions; for business-bearing work, distill stable confirmed meaning through [`update-rules.md`](update-rules.md); initialize truthful `distilled_to:` targets; and retain the Plan path plus relevant decisions as implementation inputs. Then pass its chosen outcome, acceptance criteria, boundaries, and task breakdown to [`task-execution.md`](task-execution.md). The dossier owns decisions, not live step status.

## Task Breakdown

For two or more dependent tasks, declare an executable interface per task:

```markdown
### Task N — <verb-noun>
- **Files**: owned, shared-read-only, and forbidden paths
- **Consumes**: earlier/existing interfaces this task needs
- **Produces**: exact interfaces later tasks depend on
- **Acceptance**: literal command or observable behavior
```

Task heading maps to Task Ref; Role is chosen at dispatch; Files+Produces map to Outputs; shared Files+Consumes to Inputs; forbidden paths to Forbidden Zones; Acceptance to Acceptance Criteria. This is a possible Mode 2 handoff, not automatic delegation: task count is not worker count, and only independent, mechanically reviewable, net-positive workstreams dispatch. Projects that explicitly adopt the upstream Tests-as-Spec guide may add their own routed test-case contract here.

## Complex Steps

1. Scan related live rules, routed business models, gotchas/pitfalls, and SKILL.md Common Pitfalls. When modifying an existing active Plan, first replay its relevant user-confirmed Decision Context; unrelated historical plans are not active truth.
2. Create `docs/plans/YYYY-MM-DD-<slug>/prd.md`; do not pre-create empty siblings.
3. Inspect similar code, entry points, config, tests, and current docs before questioning. A wide result-only inventory may use `subagent-auxiliary.md` only after its Admission Test passes; decision evidence stays inline.
4. Run the Question Gate; keep unknowns explicit instead of converting them into assumptions. Record clear answers, selections, rejections, and corrections through User-Confirmed Decision Mainline.
5. State scope, `business-model impact`, acceptance criteria, and out-of-scope items.
6. Record at least two real options when a choice exists, then the chosen trade-off. Load [`plan-large.md`](plan-large.md) only if the Complexity Gate classified the task Large.
7. Give implementers/reviewers the exact Plan path, relevant user-confirmed decisions, reading list, and task interfaces. Invoke Mode 2 only for the independent subset with real overlap and positive Net Benefit; keep serial/core work with the main agent.
8. Before implementation handoff, distill load-bearing conclusions through `update-rules.md`: constraints → rules; rejected alternatives → gotchas/Pitfalls; business-bearing stable confirmed meaning → routed model as desired truth; pure provenance stays in Plan. Apply the required gates; initialize `distilled_to:` with actual targets.
9. Read back the user-confirmed mainline, requirements, acceptance, chosen approach, out-of-scope, unresolved decisions, and the Plan path. On later Plan edits, repeat this replay before changing a confirmed decision.
10. If implementation starts now, instantiate the approved result through `task-execution.md`; otherwise stop at the approved design. At final `done`, reconcile any later Decision Deltas and implementation evidence before freezing.

## Decision Completeness

Before declaring ready, check decisions rather than section count: external dependency failure behavior and persisted state; concrete migration artifact for schema/contract changes; conflicts between repeated claims/cross-file links; and whether every blocker appears in Open Questions. For business work, ensure current code is not treated as authority over the user-confirmed mainline and desired truth is not presented as current implementation fact.

## Completion Checklist

- [ ] Complexity, Question, Brainstorm, and Business-Semantics gates were applied where relevant
- [ ] Clear user answers/corrections were faithfully recorded in the Decision Context and not redundantly reconfirmed or silently overwritten
- [ ] Complex plan uses only warranted canonical sections and testable acceptance criteria
- [ ] Multi-task entries declare Files / Consumes / Produces / Acceptance
- [ ] Large tasks loaded `plan-large.md`; non-Large tasks did not
- [ ] Required reading, trade-offs, out-of-scope, and unresolved decisions are explicit
- [ ] Multi-file claims/cross-links were checked for drift before freeze
- [ ] Plan Mainline Handoff passed the Plan path plus relevant decisions to Task Execution and, for business-bearing work, distilled confirmed business meaning before implementation
- [ ] On final `done`, later deltas and implementation evidence were reconciled; activated targets and `distilled_to:` match
- [ ] `.skill-workflow-state` was removed or reflects the active state

[workflow-state:planning]
Keep `prd.md` short, inspect evidence before asking, and apply the business-semantics gate when macro business meaning affects the plan.
[/workflow-state:planning]
