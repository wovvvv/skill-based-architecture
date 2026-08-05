# Rule Update Workflow

Use this workflow when standalone business modeling delivers a leaf, a confirmed Plan reaches implementation handoff, Task Execution or Fix Bug supplies a verified failure after red-to-green repair, Fix Bug forwards explicit user business content for possible admission before Closure, Task Closure supplies a user-accepted workflow-distillation candidate or decides other knowledge is worth recording, the user explicitly asks to record it, or an existing rule is inaccurate. Standalone modeling delivers stable confirmed meaning directly; Plan handoff admits its user-confirmed load-bearing decisions; verified failures supply proven engineering prevention; active Bug Fix business input supplies only what the user said; accepted workflow candidates supply a consented procedure mutation; Closure decides other recording. This file decides **what, where, and how**.

## Classification Guide

Classify the candidate before reading an evidence store or destination file. Read only the selected branch; never preload both `references/gotchas.md` and `references/behavior-failures.md`.

- Long-lived must/must-not constraint → `rules/`
- Ordered task procedure or completion check → `workflows/`
- Architecture, routing, code map, dependency explanation → `references/`
- Stable project-specific macro business types/flows/states/boundaries/invariants → routed `references/business/<module>.md`
- Pitfall, footgun, failed approach → `references/gotchas.md` or a routed domain pitfall file; promote a short warning to SKILL.md only when it must surface earlier
- Agent behavior miss → `references/behavior-failures.md`
- Frozen plan provenance → `docs/plans/`; load-bearing conclusions must also enter an active destination above
- Standalone modeling provenance → compact `Modeling Provenance` in the routed business leaf; do not create a PRD for the interview, except for an admitted confirmed implementation gap
- Personal preference useful only to this user → the harness memory system, not project skill docs

## Business Leaf and Gotcha Ownership

A business leaf is the complete owner of cross-implementation normative truth: business objects, macro flows, states, boundaries, invariants, and failure semantics. A Gotcha is the complete owner of an observed or reproducible, costly, non-obvious implementation failure: symptom, current implementation root cause, tempting wrong shortcut, and repair/verification guidance. A Gotcha is not a general implementation reference or a second business-model owner.

Use these tests before writing:

- If the statement remains true after classes, APIs, storage, and frameworks are replaced, it belongs in the business leaf.
- If it only maps the current implementation and contains no failure pattern, it belongs in a technical reference.
- If it explains how the current implementation can repeatedly violate the intended behavior, it belongs in a Gotcha.

One topic may activate both files, but the records must have different shapes. Keep the complete business rule in the leaf. Keep only a minimal business anchor plus an owner link in the Gotcha, then record the implementation-specific symptom, cause, wrong shortcut, and prevention. Never copy the complete definition into both destinations. If stable business truth exists only in a Gotcha, lift it into the routed leaf and shrink the Gotcha to the implementation lesson. If a leaf contains class names, fields, endpoints, storage keys, or repair recipes, move those details to a reference or Gotcha while preserving the leaf's normative meaning and provenance.

## Task Closure Boundary

[`task-closure.md`](task-closure.md) is the only正文 source for the Trigger Policy, closure steps, Rationalizations, Red Flags, and AAR. Do not copy those sections here. This workflow owns recording threshold, fidelity, reconciliation, destination, activation, durability, and retirement.

## Plan Decision Source

[`plan-feature.md` § User-Confirmed Decision Mainline](plan-feature.md#user-confirmed-decision-mainline) owns Decision Delta capture and authority. This workflow consumes that record: read the Plan's relevant Decision Context and preserve its confirmed answer, authority, scope, load-bearing meaning, and evidence without recreating or reinterpreting the schema. Unselected brainstorm candidates remain `proposed` and do not become active rules.

This workflow owns distillation and reconciliation, not the Plan schema or business information model. At design-to-implementation handoff, transfer stable confirmed normative business meaning into the routed model as `desired business truth` with Requirement Provenance; keep separately evidenced `current implementation fact` and any known gap explicit.

A confirmed Plan handoff bypasses only the Recording Threshold for its load-bearing, stable business meaning: Plan classification and user authority already provide admission. It must still pass Fidelity, Reconciliation, Activation, Generalization, and durability checks. If the Plan is purely technical or contains no stable business semantics, do not create a business leaf; other new records still run every gate below.

## Standalone Business-Model Input

Explicit standalone modeling routes to `profile-business-model.md` when the project adopts that workflow. Stable, clear, user-confirmed, cross-implementation business meaning is written directly into the unique routed leaf with conditions, reasons, boundaries/counterexamples, and compact Modeling Provenance when useful. Do not require a feature Plan, apply the ordinary Recording Threshold as a reason to re-justify the modeling task, or create a PRD for interview history.

When the project adopts business modeling, its local `business-global-model.md` section **Confirmed implementation gap intake** owns the narrow exception. When a confirmed truth is demonstrably unmet and passes all four admission conditions, write truth and gap into the leaf immediately, then let `profile-business-model.md` create or reuse one draft gap dossier, continue the agreed modeling scope, and hand the complete gap set to Plan Feature. Unconfirmed candidates, Agent reading history, and differences without implementation evidence never trigger the exception. Projects without that routed model/workflow do not activate this path.

## Active Bug-Fix Input

The only business-recording source during Fix Bug is the user's explicit business statement: a correction, answer, expected rule, rationale, boundary, or rejected direction that carries business meaning. [`fix-bug.md`](fix-bug.md) may invoke this workflow before Closure, and the Agent may decide whether that user content is durable enough to persist. Preserve the user's meaning faithfully, then apply Recording Threshold (unless correcting existing content), Fidelity, Reconciliation, Activation, Generalization, and provenance here.

Do not derive a business rule from the Bug. Bug symptoms, root cause, repaired behavior, code, tests, runtime evidence, and Agent summaries are not `desired business truth`; an implementation suggestion is not business content merely because the user said it. Reusable engineering lessons discovered while fixing the Bug enter Verified Failure Input immediately after fitted red-to-green proof and go to technical rule, Gotcha, workflow, reference, or executable prevention owners, never into business as user intent. Fix Bug owns noticing and immediate invocation; this workflow owns admission, fidelity, reconciliation, provenance, activation, and the user-content-only boundary.

## Verified Failure Input

Use this input after Task Execution or Fix Bug proves all of: the failure boundary, root cause, completed repair, fitted red-to-green evidence, and a stable prevention action that can change a future task. Rejected hypotheses, unresolved causes, raw messages, and retries remain Session-only. A first proven actionable failure bypasses only the Recording Threshold; when the write is within current authority, reconcile it directly into its canonical owner and activate it in the same change rather than waiting for another occurrence or final AAR. Every other gate below still applies; an authority boundary returns `requires-user-authority` instead of mutating.

Return exactly one lifecycle outcome:

1. **`covered/no-write`** — an active owner already changes the required next action.
2. **`extend-existing`** — the same root cause/prevention needs another applicability condition or symptom.
3. **`correct-existing`** — current knowledge is inaccurate, over-broad, obsolete, or must be retired.
4. **`add-and-activate`** — a distinct prevention is added to the nearest canonical owner with its action-changing path.
5. **`transient/no-write`** — no stable future action exists, such as a one-off command mistake or transient external interruption.
6. **`requires-user-authority`** — intended meaning, personal/team promotion, or a shared/costly enforcement boundary needs a user decision.
7. **`escalate-prevention`** — applicable written prevention was reached yet the same mistake recurred, so a stronger scoped mechanism is justified.

Match recurrence by `same proven root cause + same applicability boundary + same prevention action`; raw text only finds candidates, and retries inside one unresolved task are one occurrence. On independent recurrence, first verify whether the active prevention was reached before the mistake-prone action. If it was missed or inert, repair activation instead of adding prose. If it was reached and still failed, strengthen the earliest triggering tool only when the gate stays inside the authorized repository/task scope, is local, low-cost, reversible, uses existing tooling/dependencies, has fitted proof, and keeps a scoped escape path.

Ask before changing CI, hooks, server-side enforcement, default shared build/test commands, hard-failure policy, dependencies/plugins/services, team or cross-repository rules, public/external contracts, shared/non-local state, difficult rollback, or materially increased routine cost. Failure learning never grants commit, push, MR, deploy, publish, database, production, or other external authority. Project-local prevention writes to project owners by default; iteration/personal/team promotion remains an explicit higher-scope action.

## Accepted Workflow-Distillation Input

Use this input only after Task Closure presents one evidence-backed proposal and the user accepts it. That acceptance is the approved upgrade plan for the described workflow mutation and starts a newly routed maintenance task without another start confirmation. It bypasses only the ordinary Recording Threshold and redundant upgrade-plan approval; Fidelity, Reconciliation, Activation, Generalization, durability, validation, provenance, and authority gates still apply.

Reconstruct the accepted contract from at least two independently completed semantic instances: reusable goal, ordered stage relations, inputs/outputs, integrated acceptance, authority checkpoints, runtime parameters, and only evidence-proven conditional branches. Then inspect existing owners and choose exactly one result:

1. **`extend`** — the owner of the same result/acceptance is missing a stage, parameter, branch, authority check, proof, route, or local action hook.
2. **`compose`** — complete owners already express the sequence. With no durable gap, make no workflow change; a missing route/hook belongs to `extend`, not a wrapper.
3. **`create`** — no owner has the independently reusable goal, cross-step decisions/state, authority checkpoints, and integrated acceptance. Create one complete orchestration owner; consumers keep only evidence-required trigger, participation, and acceptance hooks.

Resolve provenance before mutation: the canonical owner may be downstream-owned, meta-generated, or package/market-maintained. Edit only that owner, use the repository-owned assembly/install path, and verify every affected downstream consumer and harness surface. A source-only change without downstream consumption is incomplete; generated or installed copies are never independent owners and must not be hand-edited in parallel. If canonical-source mutation or required assembly crosses current authority, return `requires-user-authority` without mutation.

Workflow acceptance authorizes only the described durable mutation and fitted local verification. It never grants commit, push, MR, deploy, publish, database, work-item, version-revision, reviewer-selection, merge, tenant/session, team-promotion, or other external/shared-system authority.

## Recording Gates

Run the applicable gates in order. A record that fails any required gate does not ship.

### Recording Threshold

For ordinary AAR, user-requested, or Agent-observed new knowledge, at least two must pass. Verified Failure Input and confirmed Plan/business-model handoffs use their explicit admission contracts and bypass only this threshold:

1. **Repeatable** — likely to recur.
2. **Costly** — absence wastes meaningful time or causes regressions.
3. **Not obvious** — code alone would not quickly reveal it.

Outdated or false existing content is corrected directly; it need not re-earn the threshold.

### Evidence / Upgrade Gate

- For discipline rules whose only job is changing behavior under pressure, require an observed/known failure or run a baseline scenario; do not codify a hunch.
- For external absorbs, benchmark/eval lessons, major template/default-scaffold changes, Always Read/routing changes, or reusable mechanisms, require the user's approval of an exact upgrade plan before editing.
- State the evidence, net benefit over context/complexity cost, why a lighter destination is insufficient, and the cheapest meaningful validation.

### Fidelity Gate

Do not persist a lossy conversation summary. Preserve every fact that changes a future decision:

- the definition or identity being distinguished;
- applicability conditions;
- boundary, counterexample, or forbidden case;
- the reason/consequence that explains why the distinction matters.

No fixed four-section template is required. The test is semantic: can a fresh Agent, reading only the proposed record, reconstruct the same key judgment without the conversation? If not, restore the missing load-bearing meaning before writing.

Creating a business model or changing its macro types, flow direction, states, boundaries, or invariants requires a user-facing read-back only when the recorded answer is materially ambiguous. A clear user-confirmed answer is not reconfirmed. Deliver stable desired meaning directly for standalone modeling or at Plan handoff for feature/design work; do not claim implementation alignment until code, tests, and behavior prove it.

### Reconciliation Gate (search before record)

Search likely destinations and read the nearest 3–5 candidate entries, not the entire library by default:

```bash
grep -ri "<concept/root cause>" skills/<name>/rules/ skills/<name>/references/ skills/<name>/workflows/
grep -E '^#{2,3} ' <candidate-file>
grep -oP '\*\*\[([^\]]+)\]' <candidate-file> | sort | uniq -c | sort -rn
```

Then choose exactly one outcome:

1. **No write** — an existing entry already covers the durable meaning.
2. **Extend in place** — same root cause or rule, new symptom/condition/counterexample.
3. **Correct in place** — existing meaning is inaccurate or over-broad.
4. **Retire** — premise no longer exists; delete or mark a scoped legacy remainder.
5. **Add independently** — genuinely different root cause/constraint with its own activation path.

For Gotchas this five-way decision is mandatory. Different symptoms of one root cause belong in one entry. Never default to appending at file end, and never preserve chronology as document structure.

### Activation Check

No new reference or business-model content ships without a declared path that is both reached and acted on:

1. Which exact route, workflow line, rule summary, or selecting index will lead the next relevant task here?
2. Is that trigger guaranteed to fire for the task the record protects?
3. What next action changes after reading it — a file opened, check run, branch rejected, or workflow selected?

If no answer exists, add the nearest pointer in the same change, promote a concise constraint into a routed rule/workflow, or skip the record. `audit-orphans`, route reachability, and smoke tests prove structural reach, not actionability.

At Single-file tier, do not escalate the architecture merely to store one lesson. At Folder-light tier, a SKILL.md route or rules bullet may activate it. Verified Failure Input owns recurrence-to-machine-gate graduation; this check only proves the written prevention changes the next applicable action.

## Placement and Shape

Choose the lightest shape that preserves meaning:

| Need | Shape |
|---|---|
| One sentence that fits an existing rule/entry | edit that entry in place |
| Several conditions/explanations on an existing topic | expand the matching section |
| Distinct procedure or independently routed topic | new section/file only if it has its own load reason |

Place content under the most relevant H2/H3 in logical order. Create a new section at the correct conceptual position only when no section fits. A file index is valid only when multiple independent files exist and task signals use the index to select the next read; a passive directory listing is not activation.

Gotcha/rule entries use a reusable `**[topic]**` tag. Reuse existing tags; repeated tags are a prompt to compare root causes, not permission to accumulate parallel entries.

### Generalization Rule

Apply the durability test that matches the destination:

- Generic rules, workflows, architecture notes, and gotchas must make sense in another project of the same type: `specific finding → reusable pattern → consequence`.
- Business global models are intentionally project-specific. They must instead be **cross-implementation stable**: after renaming modules/classes and replacing APIs, storage, or frameworks, the macro business statement remains true.

Do not force business names out of a business model merely to make it cross-project generic. Do not put code names, fields, paths, or one-off requirements into it merely because they are project-specific.

## Sync Targets

| Change | Required follow-up |
|---|---|
| New/renamed workflow or non-domain reference | update its owning workflow/link; update `routing.yaml` only when task-to-workflow selection changes; run `scripts/sync-routing.sh` |
| First/new business domain owner | create/update `references/business/<domain>.md` and `domain-routing.yaml` atomically; run routing sync/check plus orphan and reachability checks |
| Task route / Always Read / domain route changed | regenerate SKILL.md and thin-shell blocks from `routing.yaml`; validate optional `domain-routing.yaml` in the same command |
| Rule/reference meaning changed | grep workflows for repeated invariants and update stale copies |
| Standalone modeling confirms stable business meaning | reconcile it directly into the routed leaf; add compact Modeling Provenance when useful and no PRD unless the confirmed-gap exception passes |
| Standalone modeling confirms an implementation gap | write truth and gap into the leaf; create/reuse one draft gap dossier, continue the agreed modeling scope, then hand the complete gap set to Plan Feature |
| Plan confirmed for implementation | reconcile load-bearing conclusions into active destinations; set truthful `distilled_to:` and Requirement Provenance before coding |
| Plan or user-confirmed decision changed | replay the prior mainline, record the Delta/supersession, and reconcile affected rules before implementation resumes |
| Business implementation aligned/changed | update current implementation evidence and reconcile any declared gap without rewriting desired truth |
| Workflow-distillation proposal accepted | resolve canonical provenance, mutate one owner, assemble/install through the owned path, and verify every affected downstream consumer |

## When NOT to Record

- one-off workaround or minor preference with no stable prevention action;
- fact immediately obvious from code or already covered by official docs;
- session transcript, chronological debug log, or date-named narrative under `references/`;
- unconfirmed inference presented as intent;
- “later” business-model candidate — keep it only in the current session, with no file/directory/index/route;
- content whose only purpose is moving an eval/benchmark score (Goodhart test: would you write it without the metric?).

## Learn, Correct, Retire

When a task exposes a documentation failure, classify it before editing:

1. missing knowledge → its applicable admission contract (ordinary threshold or Verified Failure Input) + all remaining recording gates;
2. outdated/inaccurate knowledge → correct in place and check consumers;
3. obsolete premise → delete, or scope a temporary legacy remainder with reason/date;
4. rule existed but was missed → improve its activation/prominence instead of duplicating it.

When deleting/renaming a file, update routing and inbound links, run sync, and inspect orphan/reachability results. For durable knowledge, deletion additionally requires a reviewable destination, owner, normal activation path, fitted validation, and an explicit account of intentionally unretained content. Put this proof in the existing Plan or migration record; do not create a fixed ledger solely to satisfy the gate. Use `maintain-docs.md` for full-file reorganization, split/merge, index, and independent-load-reason audits.

## Completion Criteria

- [ ] Destination was classified before writing
- [ ] New knowledge passed its applicable admission contract and evidence gates; outdated content was corrected directly
- [ ] Fidelity preserved definitions, conditions, boundaries/counterexamples, and reasons
- [ ] User-confirmed records preserve question/correction, answer, authority, scope, and applicable leaf/Plan provenance; ordinary standalone modeling created no PRD, confirmed gaps use one dossier, and proposed candidates were not promoted
- [ ] Reconciliation selected no-write / extend / correct / retire / independent-add
- [ ] Gotchas were merged by root cause and placed by topic, not appended chronologically
- [ ] Business leaves own complete normative truth; Gotchas contain only distinct implementation failure experience plus a minimal owner link
- [ ] Generic content passed cross-project generalization; business models passed cross-implementation stability
- [ ] New/changed content has an action-changing activation path
- [ ] Every Verified Failure Input returned one lifecycle outcome; first proven actionable prevention was written directly, while transient/no-write had no stable future action
- [ ] Every accepted workflow candidate returned `extend` / pure `compose` / `create`; durable mutations have one canonical owner, an action-changing path, and verified downstream consumption without authority expansion
- [ ] Routing, generated entries, consumers, and plan `distilled_to:` were synchronized where triggered
- [ ] Desired business truth and current implementation fact remain distinct; known implementation gaps are explicit
