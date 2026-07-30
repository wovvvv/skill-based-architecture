# Plan Feature Workflow

> **Inline by default.** Planning evidence and decisions belong in the main context. Read [`subagent-auxiliary.md`](subagent-auxiliary.md) only for an independent, result-only research workstream with real overlap and positive Net Benefit; planned multi-workstream execution uses [`subagent-driven.md`](subagent-driven.md).

Use this for feature/design planning and for an admitted implementation-gap dossier after standalone business modeling finishes its agreed scope. It resolves what should be done; it is not the runtime Native Plan. If the request only discusses, profiles, supplements, or migrates a business leaf, route to `profile-business-model.md` when installed; modeling duration, file count, and interview depth do not create a PRD. Simple plans stay inline unless the user asks for a file.

When the selected route is this SBA repository's self-hosting `product-direction`, read `docs/sba-bible.md` and `docs/plans/README.md` after entering this workflow. Ordinary downstream planning never loads the SBA Bible. For other durable Plans, read the local Plan archive contract only when the Complexity Gate requires a file.

## Complexity Gate

First confirm the deliverable is a feature/design Plan or an admitted Modeling Gap Intake. Standalone business modeling does not enter this workflow merely because it is complex.

| Size | Signal | Action |
|---|---|---|
| Trivial | typo, comment, obvious one-line change | skip this workflow |
| Simple | clear goal, 1–2 files, no product ambiguity | short inline plan; at most one confirmation |
| Complex | multiple files, unclear behavior, dependency, architecture choice, or long run | create `docs/plans/YYYY-MM-DD-<slug>/prd.md` |
| Large | multi-subsystem, irreversible/expensive, high uncertainty, or many unknowns | Complex plan + read [`plan-large.md`](plan-large.md) |

## Question Gate

- This section owns the evidence-before-questioning contract. **Gate A: Implementation facts closed?** execute [`ambiguous-request-gate.md` § Implementation-Fact Question Gate](../protocol-blocks/ambiguous-request-gate.md#implementation-fact-question-gate), then trace the smallest concrete business flow relevant to the decision (`actor/trigger -> caller and actual write target/branch/state -> ordering, guards, and failure -> UI/API carrier/exit`). Close every decision-bearing hop, trace distinct flows independently, and form an evidence-backed working conclusion. **Gate B: Meta/lazy?** never ask the user to do Agent-available discovery. **Gate C: Normative and blocking?** ask only a remaining normative decision that could change the future rule, invariant, failure semantics, or acceptance.

Do not ask before implementation fact closure, and do not combine two incomplete flows into a binary choice. Which API a page calls, whether it directly writes the target, which endpoint creates a merge/review request, which existing branch or task flow feeds a target, branch protection, current call order, and current state progression are `current implementation fact`; state them with evidence. Ask the user only whether the future path may bypass the current flow, whether failure must block, which business object is a prerequisite, or whether an existing process/invariant should change.

Ask one question at a time and offer concrete trade-offs for preferences. Present the working conclusion and ask the user to correct, complete, or choose against it. Treat questions as a decision-relevant uncertainty budget, not an exhaustive questionnaire: cross-check implementation evidence against existing user-confirmed answers. If they agree and no unresolved normative ambiguity could change the current decision, accept the point and stop asking; never ask the user to restate an implementation fact the evidence already proves. If they conflict, show the conflict and ask only which normative meaning governs. Do not open with abstract prompts such as "what is X essentially, why does it exist, and when does it end?" when a concrete flow can be inspected. If the user says the answer is in code, stop the question, finish the trace, state the implementation conclusion, and ask only any remaining normative ambiguity. The working conclusion remains `proposed` / `current implementation fact`; only existing or new user-confirmed input can establish normative business meaning.

## User-Confirmed Decision Mainline

This section is the canonical owner of Decision Delta capture and Plan Mainline Handoff for feature/design Plans. When the Agent asks a product/business question, or the user directly selects, rejects, or corrects a direction, that clear answer is the highest-authority input for the corresponding normative decision. If it identifies one load-bearing meaning, mark the Delta `Status: confirmed` without reconfirming; clarify only materially different interpretations. For Complex/Large work, keep the question/correction, answer, `Authority: user-confirmed`, load-bearing meaning, scope, and `Evidence / Source: current conversation` in `prd.md`; preserve short answers verbatim with context and summarize long answers faithfully. Simple work may stay in conversation unless a durable Plan exists. Standalone business modeling writes clear stable meaning directly into the routed leaf; it does not create a feature Plan merely to store the interview.

The confirmed answer remains normative. For business-bearing work, the routed business model owns `desired business truth` while code, tests, and runtime prove `current implementation fact`; those sources may expose a gap but cannot silently overwrite the Plan mainline. Replacing it requires a new explicit user decision and a `superseded` Delta.

## Business-Semantics Gate

Do not infer business-bearing scope from keywords alone. For an explicit business-rule request or a source Plan that already declares the applicable business-domain owner, evaluate `domain-routing.yaml` immediately after this workflow is selected. Read an existing source Plan directly; its existence alone does not activate a domain. For ambiguous product/feature work, inspect minimal implementation evidence first and evaluate the domain manifest only when the remaining decision depends on business semantics. After activation, read the selected business model before treating code as intended behavior. Compare in this order:

1. business model — what the business says should be true;
2. architecture / rules / contracts — how the system intends to realize it;
3. code / tests / runtime — what is currently true.

Record `business-model impact: unchanged / proposed change / unknown`. A proposed change to a type system, macro flow, state machine, boundary, or core invariant is a design decision, not an implementation detail. At implementation handoff, a business-bearing Plan distills stable user-confirmed semantics into the routed model as `desired business truth`, with Plan provenance; code/tests/runtime stay separate `current implementation fact`. If no confirmed Plan yet owns stable business meaning, the optional modeling choice remains; once handoff does, create the minimum owner instead of continuing without persistence.

If new evidence overturns a load-bearing conclusion, do not silently replace it: re-check the user-confirmed mainline, chosen approach, acceptance criteria, boundaries, and Task Anchor before continuing. The Agent may verify facts, constraints, cost, and risk, but a normative business judgment requires confirmation from the business owner.

## Modeling Gap Intake Handoff

Accept confirmed implementation gaps only after `profile-business-model.md` finishes the user's agreed modeling scope. Do not let planning preempt active leaf modeling and do not create another dossier.

1. Reuse the existing draft gap dossier or feature/design Plan; never create one PRD per gap.
2. Require each item to contain user-confirmed desired truth, current implementation evidence, an explicit gap and impact, the unique owner leaf, and Knowledge Impact. Return incomplete items to `proposed` / evidence-needed rather than turning them into implementation promises.
3. Show the full deduplicated gap set first: topics, shared dependencies/root causes, boundaries, risks, and recommended order. Gaps sharing one owner or repair boundary become one Plan topic instead of mechanical separate tasks.
4. Complete Chosen Approach, Requirements & Acceptance Criteria, Out of Scope, Task Breakdown, and Open Questions while preserving confirmed Decisions without reconfirming the business rule.
5. Use the Plan-Complete Brainstorm Handoff below to discuss one substantial topic at a time. Facts already established by implementation evidence are adopted directly.
6. If the user pauses, keep the dossier `draft` and stop. Run Plan Mainline Handoff only after load-bearing topics converge and the user requests implementation.

## Brainstorm — Diverge Before Converging

Before a Plan is complete, Complex/Large work inspects adjacent evidence and generates at least two genuinely different solution shapes with honest trade-offs. Every candidate remains `proposed` until the user directly answers, selects, rejects, or corrects it; the clear response enters the user-confirmed mainline. For Large or highly ambiguous work, present the chosen design and obtain buy-in before writing Task Breakdown. Trivial work skips divergence; Simple work does not invent a second option but still applies the handoff below when a real question remains.

### Plan-Complete Brainstorm Handoff

A written and internally checked Plan does not end the planning conversation. Unless the user explicitly asked for the artifact only, paused, or stopped discussion, automatically enter a detailed user-facing brainstorm before offering implementation.

Depth follows real decision pressure, not a fixed question or word count:

- **Simple**: discuss one topic only when a remaining question could change implementation, acceptance, or user experience; adopt points already proved by code plus user answers.
- **Complex**: discuss at least the most decision-bearing open topic. If Open Questions is empty, pressure-test the highest-blast-radius or easiest-to-miss assumption in Chosen Approach.
- **Large**: reuse the independent perspectives selected by `plan-large.md` and discuss them one at a time in risk/uncertainty order; never compress them into one confirmation checklist.

Before the first topic, replay enough mainline context that the user need not reopen the PRD or code: Problem, Chosen Approach, key business/data/state flow, preserved behavior and boundaries, and why the evidence supports this direction. Then cover exactly one topic with:

1. **Current conclusion** — what the Plan intends to do, not just a field or option label;
2. **Evidence and constraints** — what code, config, tests, contracts, or prior confirmed decisions establish;
3. **Remaining question** — what is still `proposed` and why evidence cannot decide it for the user;
4. **Impact and trade-offs** — concrete effects on flow, compatibility/migration, implementation, testing, or recovery;
5. **Agent recommendation** — preferred direction, reason, cost, and boundary where it does not apply;
6. **User decision point** — ask the user to correct, complete, reject, or choose against that conclusion.

The topic must be detailed enough to decide. Do not collapse it into a three-line summary, a naming/default/editability checklist, or an instruction to read the PRD first. After each answer, write the Decision Delta and update affected Chosen Approach, acceptance, and Open Questions before moving to the next independent topic. Stop only when no substantial ambiguity can change the design/acceptance, the user defers it, or the user ends discussion. Never invent options or repeat confirmed facts for ceremony.

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
7. After internal Plan checks, run Plan-Complete Brainstorm Handoff: replay the mainline, discuss one real topic in decision-ready detail, and write each answer back before proceeding.
8. Give implementers/reviewers the exact Plan path, relevant user-confirmed decisions, reading list, and task interfaces. Invoke Mode 2 only for the independent subset with real overlap and positive Net Benefit; keep serial/core work with the main agent.
9. Before implementation handoff, distill load-bearing conclusions through `update-rules.md`: constraints → rules; rejected alternatives → gotchas/Pitfalls; business-bearing stable confirmed meaning → routed model as desired truth; pure provenance stays in Plan. Apply the required gates; initialize `distilled_to:` with actual targets.
10. Read back the user-confirmed mainline, requirements, acceptance, chosen approach, out-of-scope, unresolved decisions, and the Plan path. On later Plan edits, repeat this replay before changing a confirmed decision.
11. Only after the Brainstorm Handoff converges and the user requests implementation, instantiate the approved result through `task-execution.md`; otherwise keep the Plan active and continue discussion. At final `done`, reconcile any later Decision Deltas and implementation evidence before freezing.

## Decision Completeness

Before declaring ready, check decisions rather than section count: external dependency failure behavior and persisted state; concrete migration artifact for schema/contract changes; conflicts between repeated claims/cross-file links; and whether every blocker appears in Open Questions. For business work, ensure current code is not treated as authority over the user-confirmed mainline and desired truth is not presented as current implementation fact.

## Completion Checklist

- [ ] Complexity, Question, Brainstorm, and Business-Semantics gates were applied where relevant
- [ ] Implementation facts were closed before questioning; distinct flows were traced separately and no interface, write target, branch protection, call order, or state progression was presented as a user choice
- [ ] Plan completion automatically entered a detailed Brainstorm Handoff unless the user requested artifact-only/pause/stop; no three-line summary or batch confirmation ended the conversation early
- [ ] Each brainstorm topic explained current conclusion, evidence, remaining question, impact/trade-offs, recommendation, and one user decision point
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
Keep `prd.md` short, close implementation facts before asking, apply the business-semantics gate when macro business meaning affects the plan, and enter detailed Brainstorm Handoff after internal Plan checks.
[/workflow-state:planning]
