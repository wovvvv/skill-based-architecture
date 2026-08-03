# Task Execution Protocol

Use this after matching the task route when the task is not one clear action with one direct check. It controls this task's goal and progress; the matched Domain Workflow remains authoritative for task-specific procedure and mandatory gates. Simple tasks skip this protocol. Classify by whether an explicit goal changes execution, not by tool-call or file count.

## Task Classifier

| Class | Signal | Action |
|---|---|---|
| Simple | one clear action, one direct check, little room to drift | execute directly; do not display an Anchor or Plan |
| Managed | dependent steps, meaningful boundaries, repeated verification, or material drift risk | establish a Task Anchor, use a concise Native Plan, and present only useful alignment |
| Design | unresolved product/architecture choice, materially different interpretations, or irreversible decision | use `plan-feature.md`; after approval, convert its result into a Managed task |

## Evidence and Knowledge Gate

- Start with the selected workflow and the smallest source/runtime slice that can resolve the current decision. When desired meaning is not implementation-ready, let [`change-contract.md`](../protocol-blocks/change-contract.md) bind it; when only technical ownership is unresolved, consume [`source-localization.md`](../protocol-blocks/source-localization.md). Clear tasks keep the direct fast path. Expand one target at a time only when ownership is unclear, evidence conflicts, a contract/generated/shared boundary is crossed, a routed file names a needed leaf, or the current premise fails.
- Do not read `domain-routing.yaml` at task startup. Read it immediately after workflow selection only for an explicit business-rule request or a governing Plan that already declares the applicable business-domain owner; for ambiguous work, read it only after minimal evidence exposes an unresolved business type/flow/state/boundary/invariant. Read every governing Plan directly through its workflow; a Plan's existence alone is not domain evidence. Keywords identify candidates, not activation. Clearly technical work skips the manifest.
- A domain route appends knowledge and never replaces the selected workflow. Load one owner by default; add another only with explicit cross-domain evidence.
- Treat `subagent-driven.md` as a cross-cutting modifier, never a first-workflow route. Read it only after the primary workflow and Task Anchor expose at least three plausible independent workstreams with useful execution overlap; task size or duration alone does not activate it.
- Before the first mutation, read `rules/change-discipline.md` and only the project/coding rules whose scope the planned change reaches. Load an adopted testing contract when constructing evidence, and load `task-closure.md` only after local execution is complete and either all goal evidence exists or only explicit delivery-dependent evidence remains.
- Treat read volume and elapsed time as diagnostic evidence, never correctness gates. Validate at the cheapest level that can falsify the material risk and stop when the declared evidence contract passes.

## Task Anchor

Before mutation on a Managed task, establish current-Session state with one observable Goal, Done When evidence, and only material Boundaries such as scope, non-goals, preservation requirements, permission, or approval limits. Derive a concise Native Plan from the matched Domain Workflow. Before verification begins, bind the material risk, fitted evidence, and stop/escalation condition in the current Session; this is a decision aid, not another persistent artifact.

For Design-derived work, retain every governing Plan path and relevant user-confirmed Decision Context. Replay the governing mainline before deriving or changing the Task Anchor; do not lose a rule, boundary, rationale, or acceptance condition. Read only decisions governing the current step; only business-bearing decisions require a routed business rule.

### Composite Plan Handoff

When one outcome consumes multiple independently authoritative Plans, identify one Integrating owner before mutation and derive exactly one Integrating Task Anchor and Native Plan. Component Plans provide their decisions, boundaries, interfaces, and local acceptance; they do not create competing anchors, live step stores, or semantic `Current Task` entries. Session-only composition does not require another file, and durable graph metadata never mirrors runtime progress.

Check each consumed interface from its owner: `done` is a frozen input; unfinished `executing` work is absorbed into the Integrating Native Plan; an included `draft` Component must close its load-bearing interface and enter execution during handoff. Exclude an unauthorized `draft` Component or keep the integration in design. A missing, `abandoned`, or replaced Component cannot drive mutation; resolve its valid owner or replan first.

If composition changes only order, a legal adapter, integrated proof, or delivery, return to the Integrating owner. If it changes a Component's meaning, invariant, boundary, accepted interface, or local acceptance, pause only the affected path and return to that Component's owning Design Slice. Apply the User Decision Drift Gate when user-confirmed meaning is involved; active Components use an explicit Decision Delta, while frozen Components require a successor that the Integrating owner then consumes. The Task Anchor remains runtime state, not a fixed chat template.

### Presentation Gate

- **Structured Brief**: Evaluate **Structured Brief first**; if any condition matches, it wins and Compact Alignment is allowed only when all Structured conditions are false. Trigger when the task is long, complex, scope-sensitive, confirmation-dependent, or lacks a visible native Plan surface. The first user-facing task-start message MUST begin with separate Goal, Done When, material Boundaries, and Steps sections in the user's language. Steps must be numbered; do not collapse the brief into prose or render empty headings:

Required shape: `<localized Goal>: <observable outcome>`; `<localized Done When>: <goal-level evidence>`; optional `<localized Boundaries>: <material limits>`; `<localized Steps>: 1. ... 2. ...`.

- **Compact Alignment**: only when no Structured condition matches, use natural-language alignment if it helps the user verify direction, usually one short sentence covering the outcome, completion proof, and any material boundary. If the native Plan/Task surface is visible, do not repeat its steps in chat.

Do not expose protocol labels merely to prove an Anchor exists. After any needed alignment, proceed without waiting unless a blocking design choice, authority boundary, shared/irreversible action, or scope expansion requires user input.

Use the harness's native Plan/Task surface to hold step state. If none exists, keep a concise checklist in the current session. This protocol does not create durable planning files or recover task state across Sessions.

## Workflow Boundary

Workflow is the reusable procedure and owner of domain gates/evidence; Native Plan is its task-specific instance and sole runtime step owner; Task Anchor owns Goal, Done When, and material Boundaries. A user-visible Plan may group Workflow steps but cannot omit or semantically reorder a mandatory gate.

## Database-Structure Mutation Gate

When evidence shows a table, column, index, constraint, sequence, trigger, type, or other persistent schema structure will change, do not mutate persistence/application code until the governing Plan's Database-Change Artifact Gate has passed: the user saw and confirmed a separate schema-impact checkpoint, the real current schema and dialect are known, a dedicated Plan-local SQL sibling is implementation-ready, and the project execution owner plus current DB authorization are explicit. Read-only discovery may continue. The SQL artifact is a review/handoff contract, never permission to bypass the project migration workflow or write a database.

## Recitation Loop

Before each main Plan step, bring a compact Anchor Checkpoint into current attention: `Goal`, remaining `Done When`, `Current Step` with unresolved question/evidence/advance-or-return condition, and only currently relevant `Boundaries`.

For Design-derived work, the checkpoint also names relevant user-confirmed decisions and, when business-bearing, any declared `desired business truth` / `current implementation fact` gap. Reference the Plan; do not duplicate its transcript.

Run the checkpoint again after a later user message, a failed check or surprising premise change, a Subagent return, an interruption/compaction, and immediately before scope expansion, a shared/irreversible action, or Closure. Keep it internal unless a status update or changed Goal matters to the user; do not narrate it before every tool call.

If the Goal or Done When can no longer be stated accurately from the current Session, stop mutation and reconstruct them from the user request, matched route, and Workflow before continuing. Do not invent missing task state or create persistence as a fallback.

## Execution Loop

1. Keep exactly one main step active; pending steps remain explicit.
2. Run the Anchor Checkpoint, then name the current step's unresolved question, the evidence that could resolve or falsify it, and the advance/return condition before acting.
3. Mark the step complete only when the resulting evidence satisfies that condition and either changes the next decision, is consumed by the next step, or satisfies remaining Done When evidence. Running a command, generating a file, receiving a successful exit code, writing code, spending effort, or a worker's claim is not completion evidence by itself.
4. If evidence satisfies the condition, advance only after confirming the next step serves the Goal and respects Boundaries. If it contradicts the premise, return to the owning earlier step; if it is inconclusive, keep the step open and change the check or escalate under the declared condition.
5. If evidence changes the premise, scope, ordering, or Done When, update the Anchor and remaining Plan before more mutation. Tell the user when the Goal itself must change.
6. Never silently overwrite a load-bearing conclusion. Re-check every governing Plan's user-confirmed mainline, chosen approach, acceptance, Boundaries, and Task Anchor; obtain the business owner's confirmation before adopting a normative business judgment.

Independent Subagents may work concurrently, but the main task keeps one integration/decision focus. Their outputs are candidate evidence until the main Agent reviews them and runs the owning step's check.

## User Decision Drift Gate

This section is the canonical owner of the gate's trigger, pause/resume behavior, required evidence, and decision transition. Domain workflows may repeat a task-specific trigger, immediate pause, or acceptance check for local actionability, but they link here instead of copying the complete gate.

Code may expose constraints, cost, and risk, but it has no authority to modify a user-confirmed business mainline. Trigger this gate when current or in-progress implementation conflicts with a confirmed product meaning, business rule, scope, flow, state, boundary, invariant, acceptance condition, or user-visible behavior. Ordinary implementation choices that preserve those decisions do not trigger it.

On trigger:

1. Pause the affected implementation path immediately; do not wait for review or Closure. Independent work may continue only when it cannot prejudge the decision.
2. Preserve the existing `Authority: user-confirmed` Decision Delta. State the confirmed mainline, `current implementation fact`, exact gap, constraint/cost/risk, and materially different options.
3. Mark every alternative `proposed`. Ask the user one decision-bearing question and do not mutate the affected path until the answer is clear.
4. Record the answer in the Plan Decision Context. If it changes the mainline, mark the prior decision `superseded`, reconcile any routed business rule, then update the Task Anchor and resume.

Never silently compromise to fit current code, and never treat a late disclosure in review/Closure as satisfying this gate.

## New Message Gate

For each later user message: a refinement/correction updates the current Anchor and remaining Plan; a new independent outcome re-matches the route and replaces them; a status question reports Goal/current step/verified results without changing state; pause/stop leaves unverified steps incomplete.

## Exit To Closure

Enter `task-closure.md` only when every non-delivery Plan step is verified, local acceptance evidence is present, Boundaries were respected, no stale Plan/Component branch remains, and every triggered User Decision Drift Gate has an explicit resolution reflected in its owner and, for business-bearing decisions, its active rule. Any remaining Done When evidence must be explicitly delivery-dependent and named. Closure performs Component-first reconciliation, decides `Ready for Delivery`, remains open across authorized delivery, verifies the requested artifact, and makes the final completion decision; it does not finish implementation work or grant delivery authority.
