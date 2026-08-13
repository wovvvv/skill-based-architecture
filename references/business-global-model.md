# Reference — Business Global Models

Use this optional pattern for product/business projects where an Agent repeatedly needs stable domain meaning before it can plan or classify a bug. Do not install it for every project and do not create empty `references/business/` placeholders.

## Contents

- [What belongs here](#what-belongs-here)
- [Lifecycle and storage shape](#lifecycle-and-storage-shape)
- [Trigger paths](#trigger-paths)
- [Desired truth and implementation fact](#desired-truth-and-implementation-fact)
- [Confirmed implementation gap intake](#confirmed-implementation-gap-intake)
- [Plan and bug-fix consumption](#plan-and-bug-fix-consumption)
- [Semantic read-back](#semantic-read-back)
- [Routing recipe](#routing-recipe)
- [Orthogonal task and domain routing](#orthogonal-task-and-domain-routing)
- [Cross-owner reads](#cross-owner-reads)
- [Provenance and retirement](#provenance-and-retirement)

## What belongs here

A business global model is project-specific but implementation-independent. It records low-volatility facts such as:

- why a module exists and where its business boundary sits;
- stable concepts, actors, type systems, or decision matrices;
- macro flow progression and business lifecycle;
- business states, permitted transitions, and terminal states;
- cross-module relationships and invariants that survive ordinary feature work.

Use the implementation-independence test:

> If frameworks, classes, APIs, tables, and storage were replaced, would this statement still be true?

If no, keep it in code maps, technical references, gotchas, tests, contracts, or the current plan instead.

Do not record:

- Controller/Manager/method names, API fields, database columns, config keys, or runtime paths;
- page/component implementation details;
- one requirement's task breakdown or rejected technical design;
- one bug's repair narrative, temporary compatibility branch, or volatile edge rule;
- unverified inference presented as business intent.

The content list is a menu, not a template quota. A module without a meaningful state machine does not need a state-machine section. Never add empty headings for symmetry.

## Lifecycle and storage shape

The default storage unit is a business domain, not a code module. Start absent. Create the directory only when the first real model is confirmed:

```text
references/business/
└── merge-task.md
```

Do not create an `index.md` for one file. Keep `references/business/<domain>.md` while the domain remains one independently selected decision surface.

Run a split review, without splitting automatically, when any pressure appears:

- after deduplication and heading cleanup, the leaf grows beyond about 120 nonblank lines or more than 10 substantive H2 sections, excluding routing and provenance boilerplate;
- at least two real request patterns repeatedly use different parts of the leaf;
- one part has a stable task signal and the rest is irrelevant to that task.

Line and section counts only trigger review. First check the boundary: content with a different stable business owner or domain boundary becomes a sibling `references/business/<other-domain>.md`, not a nested submodule.

For content that still belongs to the same domain and owner, split only into independently routed business submodules:

```text
references/business/<domain>/
├── index.md
├── overview.md          # optional: shared domain-wide invariants
├── <submodule-a>.md
└── <submodule-b>.md
```

Each leaf represents one business submodule or decision surface. Do not split by document aspect into `types.md`, `states.md`, or `lifecycle.md` when real tasks still need those aspects together. Before splitting, answer all four:

1. Which real request reads this candidate without all siblings?
2. Which route, workflow, or index selects it?
3. Can it be understood without loading the siblings?
4. Does the split reduce irrelevant context?

If every caller loads and changes the files together, keep or restore one file. `index.md` selects a submodule from task signals and carries no business body. `overview.md` is optional and exists only when multiple submodules need the same domain-wide invariants without duplicating them. Independent generation/ownership may justify separate files, but it does not justify co-loading them at runtime.

## Trigger paths

### Project initialization

During project profiling:

1. Inspect modules, entry points, stable enums/types, states, tests, and existing docs.
2. Present only modules that appear to have durable business semantics.
3. Ask the user per candidate: model now, later, or not needed.
4. Create files only for "now".

"Later" is session-only. Do not create a candidate queue, empty file, empty index, or placeholder route. If the gap recurs in another session, detect and ask again.

### Daily work

Classify the current module knowledge before acting:

| State | Action |
|---|---|
| No model, the gap affects the decision, and no confirmed Requirement owns stable business meaning | Explain the missing macro meaning; ask whether to model now or continue without persistence |
| Confirmed Requirement reaches implementation handoff with stable business meaning but no model | Create the minimum routed owner and record desired truth plus Requirement provenance; this handoff has already passed admission |
| Model exists but one area is unclear | Inspect code/tests; ask only the minimal business question; update the existing file in place |
| Newly confirmed desired truth is demonstrably unmet by current implementation | Write the truth and explicit gap into the model immediately; create or reuse one draft gap dossier, continue the agreed modeling scope, then hand the complete gap set to planning |
| Model conflicts with code/tests/runtime and has clear user-confirmed provenance | Treat the model as desired truth; classify an implementation bug or invoke the User Decision Drift Gate. Do not ask code and the confirmed model to compete for authority |
| Model conflicts but provenance is absent/ambiguous, or the user is considering supersession | Ask only which normative intent should govern; then classify bug/design/doc drift |
| Model is sufficient | Use it without asking again |

Full modeling follows: evidence scan → remove implementation/one-off details → close decision-relevant implementation facts → user brainstorm → preserve stable confirmed meaning in the model → semantic read-back → activate it in routing. Standalone modeling does not create a Plan merely because the interview is long or complex. When modeling is already part of feature/design work, the Governing Requirement and routed business model own confirmed meaning while the existing Plan consumes those sources one way; otherwise use the narrow confirmed-gap intake below.

## Desired truth and implementation fact

This section is the canonical information-model definition for desired truth versus implementation fact. The routed business model owns stable, user-confirmed `desired business truth`: the normative types, flow, states, boundaries, invariants, and reasons future work must follow. Standalone modeling writes that meaning directly into the model with compact Modeling Provenance when useful; a confirmed feature/design Requirement writes it at implementation handoff with Requirement Provenance, and its Plan only consumes that source. Do not wait for code completion and do not copy the full chat transcript.

Code, tests, and runtime separately prove `current implementation fact`. The model must not imply that desired truth is already implemented: state a known alignment gap or link to the implementation evidence when the distinction matters. Current code may expose constraints, cost, and risk, but it cannot silently redefine the confirmed business mainline.

When later implementation evidence challenges desired truth, replay the existing user-confirmed Requirement decision before editing, return the normative choice to Requirement Definition, record the new answer as a Decision Delta, mark the old decision `superseded`, and reconcile the business model before affected implementation continues. A Plan cannot make this change itself.

## Confirmed implementation gap intake

Standalone modeling defaults to the routed business model, not a PRD. A difference becomes a `confirmed implementation gap` and opens the narrow dossier exception only when all four conditions hold:

1. the `desired business truth` is stable, cross-implementation, and explicitly user-confirmed;
2. code, tests, or runtime evidence proves the current implementation does not satisfy it;
3. the difference, applicability, and impact are explicit enough to classify as an implementation gap rather than an inference, candidate, or evidence-needed item;
4. the gap needs implementation design, acceptance, or delivery tracking rather than a documentation-only correction.

On admission, write both the confirmed truth and the explicit gap into the business model immediately. Reuse an authoritative Governing Requirement for the same scope when one exists; otherwise create one draft `docs/plans/YYYY-MM-DD-<domain>-implementation-gaps/prd.md` on the first admitted gap and collect later gaps from the same agreed modeling scope into that Requirement owner. Never create one PRD per gap or a second dossier for the same scope. If an Implementation Plan already exists, link it to this owner rather than writing the confirmed truth into the Plan; when Plan pressure arrives later, Plan Feature creates or reuses the separate `design.md` consumer.

The intake `prd.md` stores only Requirement and implementation-handoff input: user-confirmed Requirement Decision Context, `Authority: user-confirmed`, `Evidence / Source: current conversation`, current implementation evidence clearly labeled as such, the explicit gap and impact, the unique owner model, and Knowledge Impact. It is not an Implementation Plan or interview transcript; technical solution, Task Breakdown, proof commands, live status, Agent reading history, unconfirmed candidates, and differences without implementation evidence do not enter it.

The first gap does not interrupt the modeling task. Finish the user's agreed leaf scope, then show the deduplicated gap set, shared dependencies/root causes, and impact boundaries before handing the existing Requirement owner to Plan Feature. Planning consumes acceptance and completes only solution/proof design in `design.md`, discussing one substantial topic at a time. If the user pauses, keep the Requirement draft and leave the confirmed truth plus gap active in the business model; do not imply that an Implementation Plan exists.

## Plan and bug-fix consumption

For a routed business module, use this order:

```text
business global model  -> user-confirmed desired business truth
architecture/rules     -> how the design intends to realize it
code/tests/runtime     -> current implementation fact
comparison             -> plan, bug fix, design change, or clarification
```

Code proves current behavior, not correctness by itself. A conflict with the user-confirmed mainline triggers [`task-execution.md` § User Decision Drift Gate](../templates/skill/workflows/task-execution.md#user-decision-drift-gate): stop the affected path immediately and consult the user. That workflow owns the complete evidence, decision, and resume procedure; do not reproduce it here or defer first disclosure to review/Closure.

Before a business-sensitive bug fix, classify:

- `IMPLEMENTATION_BUG` — code violates the confirmed model; continue the bugfix loop.
- `DESIGN_CHANGE` — the proposed fix changes a type definition, flow direction, state machine, or core invariant; stop the bugfix and switch to planning with explicit user approval.
- `INSUFFICIENT_BUSINESS_CONTEXT` — there is not enough stable meaning to define the expected result; run the missing/unclear path above.

Obvious technical failures such as compilation errors, crashes, or unconditional 500s do not require business modeling unless their correct behavior is itself ambiguous.

## Semantic read-back

Do not silently compress a brainstorm into a lossy sentence. The business model is the default authority for stable standalone-modeling conclusions. An existing feature/design Requirement or confirmed-gap dossier additionally owns its decision-bearing discussion; a Plan only consumes that meaning. Before writing or changing macro semantics:

1. Preserve the Agent question or user correction, direct answer/selection/rejection, authority, scope, and source. For standalone modeling, keep only compact Modeling Provenance in the leaf when durable traceability is useful. For an existing Requirement or admitted gap dossier, preserve Requirement Decision Context with `Authority: user-confirmed` and `Evidence / Source: current conversation`. Keep short answers verbatim with context; summarize long answers faithfully.
2. List the load-bearing definition, condition, boundary/counterexample, and reason actually needed for future decisions.
3. Draft the durable business text without forcing fixed headings or copying the transcript.
4. Ask whether a fresh Agent could reconstruct the same key decision from the draft alone.
5. Show the user the final meaning for confirmation only when the prior answer remains materially ambiguous; do not reconfirm a clear answer.

"Type 4 is a version merge" is insufficient if the confirmed meaning also depends on source/target identities, distinction from another type, or a forbidden target.

## Routing recipe

Do not add business files to `always_read` or task routes. The first admitted business owner and its `domain-routing.yaml` registration are one atomic change:

```yaml
domain_overlays:
  - id: merge-task
    labels: { en: Merge task domain, zh: 合并任务领域 }
    required_reads: [references/business/merge-task.md]
    trigger_examples: [版本合并, merge task]
```

The file is optional only while the project has zero domain owners. Valid states are: no business owner and no manifest, or one-or-more owners and a non-empty validated manifest. After a domain genuinely splits, register the smallest independently selected leaf. Use a module `index.md` only when it actively selects a leaf from evidence; a passive file list is not activation.

For explicit modeling requests, copy and adapt `workflows/profile-business-model.md.example`, rename it to a real workflow, and add a project-specific route. Do not add that route to non-business projects.

## Orthogonal task and domain routing

When the same domain knowledge may accompany different task workflows, do not duplicate one complete route per task/domain pair. `routing.yaml` selects exactly one first workflow. Only after workflow selection does evidence decide whether to read optional `domain-routing.yaml`; a domain entry appends knowledge and must not declare or replace a workflow.

```yaml
# routing.yaml
tasks:
  - id: fix-bug
    labels: { en: Fix bug, zh: 修复 bug }
    workflow: workflows/fix-bug.md
    trigger_examples: [接口报错, fix this bug]

# domain-routing.yaml
domain_overlays:
  - id: billing
    labels: { en: Billing domain, zh: 计费领域 }
    required_reads: [references/business/billing.md]
    trigger_examples: [账单, 计费规则, invoice policy]
```

Explicit business-rule requests and source Plans that already declare the applicable business-domain owner may evaluate the domain manifest immediately after workflow selection. A source Plan is read directly by its workflow and does not activate a domain merely because it exists. Ambiguous work first inspects the smallest implementation/runtime evidence and evaluates the manifest only when an unresolved decision depends on a business type, flow, state, boundary, or invariant. Clearly technical work never reads it. Keywords identify candidates only. Bind one domain owner by default and expand only with explicit cross-domain evidence. Keep only current-Session provenance such as `task_route_id`, selected `domain_owner_id`, and why the current decision required it; do not persist a task database.

## Cross-owner reads

When a domain has one owner but another app must consume it, keep the business model at the owner and declare an owner root instead of copying the model. Cross-owner references use `owner:<owner-id>:<path>`:

```yaml
# domain-routing.yaml
owner_roots:
  billing-service: services/billing

domain_overlays:
  - id: billing
    labels: { en: Billing domain, zh: 计费领域 }
    required_reads:
      - owner:billing-service:skills/billing/references/business/billing.md
    trigger_examples: [账单, 计费规则, invoice policy]
```

Owner ids and roots are project declarations, never SBA hard-coded app names. Roots and target paths must be workspace-relative and may not traverse parents. Validate target existence from the real workspace root:

```bash
bash scripts/sync-routing.sh <skill-root> --check --workspace-root <workspace-root>
```

Without `--workspace-root`, the validator may prove syntax, declared ownership, and path safety only; it must report target existence as unverified rather than presenting a complete green result. The project assembler should supply this root so ordinary users do not configure it manually.

## Provenance and retirement

Requirement provenance is conditional, not a permanent double-maintenance protocol. Standalone modeling normally uses the active leaf alone, with compact Modeling Provenance only when useful. When a confirmed Requirement creates or changes durable business meaning, or a confirmed implementation gap opens the narrow intake exception, let the dossier name the active destination and let the active leaf retain the source needed to reconstruct that decision. At implementation handoff the Requirement remains normative while the Plan consumes it: later Requirement Decision Deltas reconcile the leaf, Requirement, and affected Plan before code continues; after final `done`, the Plan freezes and the leaf remains the routed source. A migration dossier, when needed for many legacy sources, is a temporary reconciliation artifact and freezes after migration; ordinary future requirements do not keep updating it.

Before deleting or superseding durable knowledge, prove destination, owner, normal activation path, fitted validation, and any intentionally unretained content. Keep that proof in the existing Plan or migration record; do not create a fixed ledger or extra file when the same contract already fits there.
