---
date: 2026-08-13
status: requirement-ready
authority: user-confirmed
---

# Requirement: Separate Requirement Definition From Implementation Planning

## User Source And Authority

> 你刚刚是对的,其实先明确需求再写计划(plan)其实跟我们之前说的,先读代码再写有异曲同工的感觉,本质上的目的是,先明确讨论需求这个是我们的根,然后再写plan作为实现细节,头脑风暴也是分开的,我觉得这样更好一点,原因在于我们的计划是从需求上长出来的,所以在我们明确了需求的目标(这个跟task archar可能有关),范围,模型,规则,技术选项(可选),验收标准(这个可能跟红测有关)***目标 + 范围 + 具体流程 + 规则/约束 + 可验证的验收标准。***如果需求仍不完整，最好的做法不是让 AI 猜，而是明确要求它：**“先列出你的理解、风险点和需要澄清的问题，确认后再开始写代码。”*这些都是我们的需求需要注意的地方,然后计划则是实现细节,这个我们要分开掉,***

This source is user-confirmed and is the governing authority for desired
meaning. Code, tests, runtime evidence, Task Anchor state, and implementation
Plans may expose contradictions or prove delivery, but cannot silently change
this Requirement.

## Goal

Requirement discussion is the root of feature and behavior work.
Implementation planning grows from a confirmed Requirement instead of defining,
completing, or narrowing it afterward.

## Scope And Preserved Behavior

This Requirement applies to SBA's reusable flow for work that adds or changes
user-visible behavior, a business flow or state, or an external contract. It
covers explicit Requirement-only requests, ordinary implementation requests,
Task Anchor projection, implementation binding, implementation planning,
downstream materialization, and fitted validation.

The following behavior is preserved:

- clear user wording may reach `requirement-ready` without another confirmation
  turn;
- fixed-contract maintenance and read-only work do not gain Requirement or Plan
  ceremony;
- ordinary work keeps Requirement and Plan state in the Session by default;
- users do not need to know SBA phases, route themselves between workflows, or
  identify files, classes, tests, or current code owners;
- existing frozen delivery records keep their historical evidence and graph
  meaning.

Out of scope are a mandatory PRD, universal planning files, a question ledger,
a brainstorm store, another runtime state machine, or an approval ritual for an
already clear request.

## Required Model And Flow

Requirement Definition owns the desired goal, authoritative scope and
preservation, decision-bearing actors/models/relations, concrete flow/state/
order/interaction, rules and constraints, and observable acceptance. It uses
evidence only to close a real uncertainty or expose a conflict.

```text
User request
  -> Requirement Definition
       -> clear: requirement-ready without another confirmation
       -> incomplete: current understanding + real risk/conflict
                      + minimum normative question
  -> Task Anchor projection (Goal / Done When / Boundaries)
  -> Current behavior and owner evidence
  -> Implementation Binding
  -> implementation-ready
  -> Implementation Plan / Native Plan
  -> mutation and fitted proof
  -> Closure against Requirement acceptance
```

Requirement brainstorming and implementation brainstorming are distinct.
Requirement brainstorming explores alternatives that change desired behavior,
scope, model, flow, rules, constraints, preservation, permissions, or
acceptance. Implementation brainstorming may compare only technical means that
preserve the same ready Requirement.

## Rules And Constraints

1. When desired meaning is incomplete, the Agent presents its evidence-backed
   understanding, the real risk or conflict, and only the minimum remaining
   normative question. It must not derive implementation tasks or mutate code.
2. Source and runtime evidence may establish Current behavior, canonical owner,
   feasibility, cost, constraints, and risk. It may falsify a premise, but it
   cannot choose desired product meaning.
3. Task Anchor is only the current Session projection of confirmed Goal, Done
   When, and material Boundaries. It is not a Requirement store.
4. Acceptance describes the observable result that is correct. Red tests,
   automated checks, runtime/browser readback, and human review are subordinate
   proof mechanisms selected during planning; they cannot invent acceptance.
5. An Implementation Plan owns the revisable technical realization and its
   delivery evidence. It must not copy, complete, narrow, supersede, or rewrite
   the Requirement.
6. Technical evidence that changes only Current facts, implementation owner,
   feasibility, risk, ordering, or proof causes re-binding or re-planning.
   Evidence that would change desired meaning, scope, preservation, permission,
   Done When, or acceptance returns first to Requirement Definition; only after
   the Requirement is ready again may Task Execution re-project the Anchor.
7. Requirement and Plan each have their own Artifact Pressure Gate. Neither
   borrows the other's gate. A Requirement artifact exists only when explicitly
   requested or independently needed for review, recovery, validation,
   lifecycle, or handoff. A Plan artifact exists only under its own independent
   implementation-design pressure.
8. A Requirement-only PRD is a complete deliverable. It neither creates nor
   implies implementation planning, mutation, delivery evidence, or execution
   progress.
9. When both artifacts exist, the Plan links to and consumes the Governing
   Requirement one way. The Requirement never links back to the Plan, mirrors
   Plan status, or owns implementation progress.

## Behavior Cases

| Request or evidence | Required behavior |
|---|---|
| “先讨论这个需求，不要写代码或 Plan” | Complete the Requirement or return one minimum normative question; do not enter implementation planning or mutation. |
| A clear status-grouped defect-filter request | Reach `requirement-ready` with zero questions when the wording is sufficient, establish the Anchor and implementation binding, then derive the Native Plan before mutation. |
| “优化这里” with several plausible user outcomes | Inspect only the evidence needed to expose the differing meanings, present current understanding and real risk, and ask one normative question. |
| The user asks which file or class should change | The Agent discovers the technical owner; it does not transfer repository indexing to the user. |
| Code contradicts the confirmed desired flow | Report the conflict and return to Requirement Definition; never fit desired meaning silently to Current behavior. |
| The user provides a complete issue or PRD | Consume it as Requirement authority without demanding a duplicate confirmation or document. |
| A proposed red test needs an unstated expected result | Return the missing expected behavior to Requirement Definition; the proof author cannot choose it. |
| Acceptance is subjective visual quality | State the observable user judgment in the Requirement and keep the later proof mechanism subordinate to it. |
| One fixed-contract maintenance correction | Keep the direct path; do not add Requirement or Plan ceremony. |

## Observable Acceptance

`R1.` A natural request to form or update only a PRD Requirement can finish in
Requirement Definition with a durable `requirement-ready` owner and without
entering implementation planning or mutation.

`R2.` A clear ordinary feature request reaches `requirement-ready` without a
ceremonial question, projects a Task Anchor, proves implementation binding, then
derives a Native Plan before mutation.

`R3.` An incomplete request produces concrete current understanding, one real
risk/conflict, and the minimum normative question; it produces no
implementation Plan or code change.

`R4.` A durable Requirement contains source/authority, goal, scope and preserved
behavior, load-bearing model/flow, rules/constraints, observable acceptance,
and confirmed or superseded normative decisions, with no technical realization
or execution progress.

`R5.` A durable Implementation Plan identifies its Governing Requirement by a
one-way link and contains only implementation facts and means. Removing the
Requirement does not leave a second normative owner inside the Plan.

`R6.` If technical evidence changes only implementation premises, the Agent
rebinds or replans without editing the Task Anchor. If it changes normative
meaning, the Agent returns to Requirement Definition and does not re-project
the Anchor until the Requirement is ready again.

`R7.` Direct, Folder-light, routed, and broad downstream carriers preserve the
same behavior without forcing ordinary projects to create either artifact.

`R8.` Structural validation proves structure and contract only; any live Agent
behavior claim remains separately evidenced.

## Confirmed And Superseded Normative Decisions

Confirmed:

- Requirement is the authority for target and acceptance; Plan is a revisable
  means.
- Logical separation is mandatory, while persistence remains pressure-driven.
- Requirement-only durable delivery is valid and complete.
- Requirement and Plan persistence decisions are independent.
- Plan consumption is one-way and cannot create a second Requirement owner.
- Clear requirements retain the zero-question path.

Superseded:

- Requirement Definition and implementation design may share Plan Feature as
  one interactive owner.
- A durable Requirement may be stored as a mutable section inside an
  Implementation Plan when both need independent lifecycle ownership.
- Technical evidence may directly revise Task Anchor Goal, Done When, or
  Boundaries before returning to Requirement Definition.

## Requirement Readiness

This Requirement is `requirement-ready`. No user-owned choice remains for the
responsibility split, fast path, source-authority boundary, acceptance/proof
relationship, independent artifact gates, Requirement-only delivery, or
one-way Plan consumption. Any future change to those meanings requires a new
Requirement decision; implementation evidence alone cannot amend this owner.
