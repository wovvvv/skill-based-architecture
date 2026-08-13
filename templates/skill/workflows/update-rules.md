# Rule Update Workflow

Use this workflow when the user explicitly asks to record, remember, correct, retire, or update durable project knowledge and the input type is not already known. It is the compact shared durable-write contract plus the ambiguous-request dispatcher. Known typed callers enter the applicable execution owner directly and consume this shared contract from there.

## Shared Durable-Write Contract

Read this section once when an execution owner evaluates a persistent change or a no-write reconciliation. Reuse it within the same unchanged Session instead of rereading it for every candidate.

### Input and Destination Classification

First classify the input and select exactly one execution owner:

- user-confirmed desired business meaning -> [`workflows/rule-update/business-truth.md`](rule-update/business-truth.md);
- proven engineering failure and prevention -> [`workflows/rule-update/verified-failure.md`](rule-update/verified-failure.md);
- ordinary AAR knowledge, explicit non-business recording, correction, or retirement -> [`workflows/rule-update/knowledge-reconciliation.md`](rule-update/knowledge-reconciliation.md);
- user-accepted repeated workflow mutation -> [`workflows/rule-update/workflow-distillation.md`](rule-update/workflow-distillation.md).

Then choose the nearest durable destination before reading a broad evidence store:

- long-lived must/must-not constraint -> `rules/`;
- ordered task procedure or completion check -> `workflows/`;
- architecture, routing, code map, dependency explanation -> `references/`;
- stable project-specific macro business types/flows/states/boundaries/invariants -> routed `references/business/<domain>.md`;
- costly non-obvious implementation failure -> `references/gotchas.md` or a routed domain pitfall file;
- cross-cutting Agent contract failure -> `references/behavior-failures.md`;
- frozen Requirement provenance -> its Requirement archive owner, while load-bearing normative meaning also enters the active business/rule owner;
- frozen Plan technical provenance -> `docs/plans/`, while load-bearing technical conclusions also enter an active destination;
- personal preference useful only to this user -> the harness memory system, not project skill docs.

Inspect only the destination family selected by the evidence; never preload both `references/gotchas.md` and `references/behavior-failures.md`.

### Source, Authority, and Fidelity

Preserve the candidate's real source and authority. Code, tests, runtime evidence, a Bug, or an Agent summary may prove implementation facts but cannot create user intent. A durable update never grants commit, push, MR, deploy, publish, database, work-item, version, reviewer, merge, promotion, shared-system, or other authority that the current task does not already have.

Do not persist a lossy conversation summary. Preserve every fact that changes a future decision:

- the definition or identity being distinguished;
- applicability conditions;
- boundary, counterexample, or forbidden case;
- the reason or consequence that explains why the distinction matters.

No fixed section template is required. Ask: can a fresh Agent, reading only the proposed record, reconstruct the same key judgment without the conversation? If not, restore the missing meaning before writing.

### Reconciliation Gate

Search likely destinations and read the nearest three to five candidate entries, not the whole library by default. Compare meaning and root cause, then return exactly one result:

1. **`no-write`** - an active owner already covers the durable meaning.
2. **`extend`** - the same rule or root cause needs another condition, symptom, boundary, or counterexample.
3. **`correct`** - existing meaning is inaccurate, over-broad, or obsolete.
4. **`retire`** - the premise no longer exists; delete it or keep only a scoped legacy remainder.
5. **`add`** - a genuinely distinct rule, root cause, or procedure has its own activation path.

For Gotchas, different symptoms of one root cause stay in one entry. Never default to appending at file end or preserving chronology as document structure.

### Activation Check

No durable write is complete until it has a normal path that is reached and changes action:

1. Which exact route, workflow line, rule summary, or selecting index leads the next relevant task here?
2. Is that trigger guaranteed to fire before the protected decision or mistake-prone action?
3. What changes after reading it: a file opened, check run, branch rejected, workflow selected, or step skipped?

If no answer exists, add the nearest pointer in the same change, promote a concise constraint into an active owner, or return `no-write`. Orphan, reachability, and smoke checks prove structure, not actionability.

### Placement and Generalization

Use the lightest shape that preserves meaning: edit one sentence in place when it fits; expand the matching section for several related conditions; create a section or file only when a real task selects it independently. An index is valid only when task signals use it to select the next read.

Generic rules, workflows, architecture notes, references, and Gotchas must remain useful in another project of the same type: `specific finding -> reusable pattern -> consequence`. Business models are intentionally project-specific and instead require cross-implementation stability after classes, APIs, storage, and frameworks are replaced.

### Synchronization and Verification

- Update canonical sources before generated or installed consumers; never hand-edit copies as independent owners.
- A new or renamed workflow/reference needs an owning link; change `routing.yaml` only when task-to-workflow selection changes, then run routing sync/check.
- A task route, Always Read set, or domain route change requires regenerated entry/shell blocks and fitted route, orphan, and reachability checks.
- A rule/reference meaning change requires a targeted search for repeated invariants and stale consumers.
- A migrated, deleted, or superseded record requires a reviewable destination, owner, normal activation path, fitted validation, and an account of intentionally unretained content.
- Re-run every deliverable check affected by the durable write or its activation edge.

## Ambiguous Request Dispatcher

For requests such as `记录一下`, `更新规则`, `这个以后要注意`, or `remember this`, inspect only enough evidence to identify the input's source and lifecycle. Select exactly one execution owner from the classification above and continue there. Do not run all four branches, create a candidate ledger, or treat keywords as proof of business meaning, verified failure, or workflow identity.

If the input type is already known, skip this dispatcher and enter the typed owner directly.

## Workflow Boundaries

[`task-closure.md`](task-closure.md) owns the Trigger Policy, Closure steps, Rationalizations, Red Flags, AAR questions, readiness, and completion. [`maintain-docs.md`](maintain-docs.md) owns full-file reorganization, split/merge, index admission, line/load-reason audits, and path-integrity mechanics. Rule Update owns durable reconciliation and activation, not those lifecycle or structural procedures.

## Completion Criteria

- [ ] Exactly one input owner and one nearest destination family were selected.
- [ ] Source, authority, definitions, conditions, boundaries/counterexamples, and reasons were preserved.
- [ ] Reconciliation returned `no-write`, `extend`, `correct`, `retire`, or `add`.
- [ ] Every persistent result has an action-changing activation path.
- [ ] Placement is the lightest sufficient shape and passes the destination's durability test.
- [ ] Canonical, routed, generated, and consumer surfaces were synchronized and re-verified where affected.
- [ ] No authority expanded.
