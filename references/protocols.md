# Reference — Protocols & Verification

## Contents

- [Meta-Workflow Templates](#meta-workflow-templates)
- [Task Execution Protocol](#task-execution-protocol)
- [Task Closure Protocol](#task-closure-protocol)
- [Verified Failure Learning](#verified-failure-learning)
- [Proactive Workflow Distillation](#proactive-workflow-distillation)
- [Recording Threshold](#recording-threshold)
- [Where To Record](#where-to-record)
- [Recording Destination Guide](#recording-destination-guide)
- [Generalization Rule](#generalization-rule)
- [When References Alone Are Not Enough](#when-references-alone-are-not-enough)
- [Skill Activation Verification](#skill-activation-verification)

## Meta-Workflow Templates

The canonical workflow templates live under `templates/skill/workflows/`. Every project should adopt at least these:

- [`task-execution.md`](../templates/skill/workflows/task-execution.md) — cross-cutting task-start and progress contract: Simple/Managed/Design classification, Task Anchor state with proportional presentation, harness-native Plan, per-step Anchor Checkpoints, verified-failure Session handoff, user-confirmed Plan-mainline replay, immediate implementation-drift stop gate, evidence-backed advancement, and replan/new-message gates.
- [`task-closure.md`](../templates/skill/workflows/task-closure.md) — cross-cutting closure gate (verified-failure outcome accounting, Task Closure Protocol, AAR, post-completion workflow proposal, Rationalizations, Red Flags); referenced by every behavior-changing workflow at closure.
- [`update-rules.md`](../templates/skill/workflows/update-rules.md) — complete durable owner for verified failures, accepted workflow candidates, and ordinary recording: first proven actionable prevention, workflow ownership/provenance/downstream consumption, lifecycle outcomes, recurrence/authority, threshold, fidelity, reconciliation, activation, destination durability, sync, and retirement.
- [`maintain-docs.md`](../templates/skill/workflows/maintain-docs.md) — independent-load-reason audit, semantic before/after reconciliation, file health, split/merge/index decisions, and reference integrity.

For a higher-level orientation and the minimal starter scaffold, see [`TEMPLATES-GUIDE.md`](../TEMPLATES-GUIDE.md).

## Task Execution Protocol

Canonical source: [`templates/skill/workflows/task-execution.md`](../templates/skill/workflows/task-execution.md).

Task Execution sits after route selection and before Task Closure. One clear action with one direct check stays Simple; other tasks establish Task Anchor state and use the visible native Plan for step display rather than duplicating it in chat. Long, complex, scope-sensitive, confirmation-dependent, or no-native-Plan work escalates presentation while the state remains runtime state, not a fixed chat template. Design-derived work carries every governing Plan path and relevant user-confirmed Decision Context. Composite execution identifies one Integrating owner, checks Component interfaces from their owners, and derives exactly one Native Plan/semantic `Current Task`; it adds no mirror status or runtime store. Each main step refreshes the applicable decision and evidence boundary through an Anchor Checkpoint.

If implementation conflicts with that mainline, invoke the canonical [`task-execution.md` § User Decision Drift Gate](../templates/skill/workflows/task-execution.md#user-decision-drift-gate) immediately. Composite conflicts return to the narrowest owner: Integrating for order/legal adapters/integrated proof, Component for its meaning or interface. Schema-structure work also pauses application mutation until the Plan's explicit impact checkpoint, authoritative baseline, dedicated SQL artifact, execution owner, and authorization boundary are ready. This reference does not duplicate either gate's complete procedure. Before verification, bind material risk to fitted evidence and a stop/escalation condition; stop when that evidence proves the contract rather than treating test count as evidence quality.

The separation is load-bearing: Workflow owns the reusable domain procedure and mandatory gates; Task Anchor owns this task's outcome; Native Plan owns current runtime step state; Task Closure owns the readiness and final completion decisions. Closure may begin with only explicit delivery-dependent Done When evidence outstanding, declare `Ready for Delivery` after local checks, remain open across authorized delivery, and complete only after the requested artifact is verified. It does not grant delivery authority. A user-visible Plan may group Workflow steps but cannot replace the Workflow or weaken a gate. New independent tasks re-route and replace the old Anchor/Plan; refinements update the current one.

For the user-facing design and examples, see [`docs/task-anchor-native-plan.md`](../docs/task-anchor-native-plan.md).

## Task Closure Protocol

Canonical source: [`templates/skill/workflows/task-closure.md`](../templates/skill/workflows/task-closure.md#task-closure-protocol).

This reference deliberately gives only the operating summary: task closure applies only when the **Trigger Policy** admits the task (code or doc was changed). For those tasks, closure means main-work verification, accounting for every already-proven failure outcome, the 30-second AAR scan for additional lessons, and any triggered recording, path-integrity, route-path, cross-reference, behavior-validation, or external-fact checks. Closure does not diagnose root cause or defer a proven actionable lesson until final AAR. Composite Closure reconciles every affected Component owner to `done` before integrated acceptance and delivery; stale, abandoned, unresolved, or replaced inputs block completion. Schema-changing work verifies the Plan-local SQL contract separately from any project-owned DB delivery. For requested commit, push, MR, deploy, publish, or similar delivery, Closure distinguishes local readiness from completion and verifies the actual artifact before closing. Keep the exact gate wording and trigger table in `task-closure.md` so the protocol does not drift across guide/reference copies.

**Pure Q&A, code explanation, read-only investigation, and advice with no file
changes are exempt** — do not enter the protocol, do not run AAR, do not run
`smoke-test.sh`. `smoke-test.sh` is a skill structure/routing/link validator,
not a default closure action for ordinary code changes or read-only work.

### Blast-Radius Buckets (closure trigger refinement)

The Trigger Policy table in `task-closure.md` asks "what kind of file changed?"
Blast-radius buckets give the **file-path classification** used to answer that
for this repo. Classification is by path alone — no content inspection, no
intent judgment.

**Bucket A — full closure (AAR + smoke-test + path-integrity gates):**

- `SKILL.md`
- `AGENTS.md`, `CLAUDE.md`, `CODEX.md`, `GEMINI.md` (entry shells)
- `references/self-hosting-routing.yaml`
- `scripts/*.sh`
- `templates/skill/SKILL.md.template`, `templates/skill/routing.yaml`, `templates/skill/*.tpl`

**Bucket B — lightweight AAR only (no smoke-test):**

- `templates/skill/rules/*.md`
- `templates/skill/workflows/*.md` (excluding `*.example`)
- `references/*.md` linked from `SKILL.md` body (`progressive-rigor.md`,
  `multi-skill-routing.md`, `skill-composition.md`, `layout.md`,
  `protocols.md`)
- `workflows/full-migration.md`

**Bucket C — skip closure entirely:**

- `README.md`, `README.zh-CN.md`
- `examples/**`
- `docs/**`
- `UPSTREAM-CHANGES*.md`
- `templates/skill/workflows/*.md.example`
- `references/*.md` not linked from `SKILL.md` body

**Bucket rules:**

- **Multiple files in one task** → take the max bucket (A > B > C). One A-bucket edit anywhere in the task pulls the whole closure into A.
- **Path not in any list** → default to B (conservative). Promote to A or C in the next routing maintenance pass.
- **Trivial edit in an A-bucket file** (typo, whitespace, comment) still triggers full closure. The bucket measures **what could break**, not **what changed semantically**. Letting the model judge "real vs trivial" is unreliable; the rule is mechanical by design.

The bucket lists are **per-repo** — they encode this repo's blast-radius
layout. A downstream project using the meta-skill maintains its own list under
the same A/B/C headings, anchored in its own `references/protocols.md`.

> **Reconcile tip (gate 3)**: before writing a recorded lesson, run `./scripts/skill-asset where <keywords>` to surface existing sections that may already cover the topic. Avoids duplicate sections accumulating across files. See [`scripts/README.md`](../scripts/README.md) for `where` / `related` / `group` usage.

### AAR Scan

Use the canonical questions and exemptions in
[`templates/skill/workflows/task-closure.md`](../templates/skill/workflows/task-closure.md#after-action-review).
Do not maintain a second question list here.

## Verified Failure Learning

Canonical semantics: [`templates/skill/workflows/update-rules.md` § Verified Failure Input](../templates/skill/workflows/update-rules.md#verified-failure-input). Task Execution owns the Session-only candidate and proof handoff; Fix Bug triggers the handoff immediately after red-to-green; Rule Update owns durable meaning and authority; Closure checks that every verified failure has one completed outcome.

Do not persist a raw message or first hypothesis. Once the root cause, repair, fitted proof, and stable future action are proven, write or reconcile that prevention directly in its nearest canonical rule, Gotcha, workflow, reference, or existing executable owner and activate it before the next mistake-prone action. The first proven actionable occurrence does not wait for a second occurrence, ordinary Recording Threshold, or final AAR. A transient failure with no stable future action receives no durable write and creates no candidate ledger, counter, chronology, Memory route, or database.

Recurrence identity is the same proven root cause, applicability boundary, and prevention action; retries inside one unresolved task remain one occurrence. On a later independent recurrence, first test whether the prevention was reached and acted on. Repair missing/inert activation before adding prose. Strengthen to a machine gate only under Rule Update's local/reversible/authorized boundary; shared, costly, external, or higher-scope promotion still requires its existing authority.

## Proactive Workflow Distillation

Canonical timing and proposal semantics: [`task-closure.md` § Post-Completion Workflow Distillation](../templates/skill/workflows/task-closure.md#post-completion-workflow-distillation). Canonical accepted-mutation semantics: [`update-rules.md` § Accepted Workflow-Distillation Input](../templates/skill/workflows/update-rules.md#accepted-workflow-distillation-input).

Two independently completed semantic instances may justify one optional result-first question after `Closure Complete`; retries inside unfinished work do not. Match goal, ordered relations, inputs/outputs, integrated acceptance, and authority rather than commands. Inspect existing owners and stay silent for pure composition; otherwise recommend one `extend` or `create`. Decline/defer creates no candidate record and suppresses the same Session proposal.

Acceptance starts a newly routed maintenance task, not automatic workflow generation or external delivery. Resolve canonical provenance, keep one complete orchestration owner plus thin local hooks, assemble/install through the real owner path, and verify every affected downstream consumer. The accepted workflow mutation does not inherit commit, push, MR, deploy, database, work-item, version, reviewer, publish, merge, or other external authority.

## Recording Threshold

Ordinary AAR, user-requested, or Agent-observed candidates record only when at least 2 of these 3 are true. Verified Failure Input and confirmed Plan/business-model handoffs bypass only this admission threshold and still pass fidelity, reconciliation, activation, generalization, durability, and authority gates:

1. **Repeatable** — likely to recur in future work
2. **Costly** — missing it wastes meaningful time or causes real regressions
3. **Not obvious from code** — a future reader would not infer it quickly from implementation alone

Typical high-value records:

- framework lifecycle gotchas
- registration timing pitfalls
- hidden routing dependencies
- non-obvious synchronization or state reset requirements

Skip recording:

- one-off workarounds
- style preferences
- facts already obvious from existing code
- content already well covered by official docs and not project-specific

Passing the threshold is only admission. Before writing, follow the three canonical gates in [`update-rules.md`](../templates/skill/workflows/update-rules.md): preserve decision-bearing meaning (**fidelity**), integrate/correct/retire existing knowledge before adding (**reconciliation**), and prove an action-changing task path (**activation**).

## Where To Record

*Operating summary — canonical: [`update-rules.md`](../templates/skill/workflows/update-rules.md) § Where To Record. Keep the two in sync when destinations change.*

Use the lightest useful destination:

- Stable constraint or convention → `rules/`
- Pitfall, lifecycle gotcha, architecture note, source index → `references/`
- Stable project-specific user-confirmed macro business types, flows, states, boundaries, invariants, and reasons → routed `references/business/<module>.md` at Plan implementation handoff; preserve `desired business truth`, Requirement Provenance, and any known gap from separately evidenced `current implementation fact`

When one topic touches both destinations, the business leaf owns the complete cross-implementation normative rule. The Gotcha keeps only a minimal owner link plus the distinct implementation-specific symptom, root cause, wrong shortcut, and repair/verification guidance. Ordinary current implementation maps belong in technical references. Do not copy the complete business definition into the Gotcha or leave stable business truth owned only by a Gotcha.
- Ordered task step or completion check → `workflows/`
- Task routing changed → `routing.yaml`, then `scripts/sync-routing.sh`
- Always-read set changed → `routing.yaml`, then `scripts/sync-routing.sh`
- Business domain owner changed → update the owner and `domain-routing.yaml` atomically, then run routing/orphan/reachability checks
- Tool entry routing or Always Read changed → `routing.yaml`, then regenerate thin-shell generated blocks (`AGENTS.md`, `CLAUDE.md`, `CODEX.md`, `GEMINI.md`, `.cursor/rules/*.mdc`)

Prefer integrating into the closest existing entry/section over creating a parallel entry or file. Create a new file only when a real task selects it independently and activation points to it.

## Recording Destination Guide

*Operating summary — canonical: [`update-rules.md`](../templates/skill/workflows/update-rules.md) § Recording Destination. Keep in sync.*

When the user explicitly asks to "record this", "remember this", or "save this for later", the agent must decide where to store the knowledge. Many AI tools (Claude Code, Gemini CLI) have their own memory systems (e.g., `~/.claude/projects/.../memory/`) that auto-load each session. These compete with the skill's documentation structure.

**Decision test:** "Would a different agent or person working on this same project benefit from this knowledge?"

| Answer | Destination | Examples |
|---|---|---|
| **Yes** — project-level knowledge | `skills/<name>/references/`, `rules/`, or `workflows/` | Technical patterns, conventions, pitfalls, architecture notes |
| **No** — personal/user-level knowledge | Agent's own memory system (`~/.claude/.../memory/`, etc.) | Communication preferences, personal shortcuts, user-specific context |

**Default to skill docs.** In practice, most "record this" requests during development are technical and project-scoped. The agent's own memory should only be used for content that is truly personal and would not help another contributor.

Apply the same threshold plus fidelity/reconciliation/activation gates as AAR-initiated recordings. If the user says a business-model candidate is for “later”, keep it only in the current session; do not create a memory entry, file, directory, index, or placeholder route.

## Generalization Rule

Use the durability test that matches the destination:

- Generic rules, workflows, architecture notes, and gotchas must remain useful in another project of the same type: `specific finding → reusable pattern → consequence`.
- Business global models are intentionally project-specific; require **cross-implementation stability** instead. If modules/classes are renamed and APIs, storage, or frameworks are replaced, the macro business statement must still hold.

Do not erase legitimate business names merely to satisfy cross-project reuse, and do not admit code names/fields/paths into a business model merely because they are project-specific.

For worked examples of good vs bad records, see [`templates/skill/workflows/update-rules.md`](../templates/skill/workflows/update-rules.md) (the canonical Generalization Rule section).

## When References Alone Are Not Enough

Recording a pitfall in `references/` preserves it, but does **not** guarantee a future task will read it.

If a lesson is both:

- **costly** enough to repeatedly waste meaningful time, and
- **task-relevant** to a recurring workflow such as fixing bugs, adding pages, adding renderers, or wiring multi-step integrations

then do **not** leave it buried in `references/` only. Also surface it in at least one activation path:

- add or update a completion check in the relevant `workflows/*.md`
- update the owning workflow so concrete evidence activates the pitfall/reference; for business truth, register the owner in `domain-routing.yaml`
- if the lesson is really a stable constraint, promote a concise summary into `rules/`

Rule of thumb:

- `references/` stores the explanation
- `workflows/` prevents omission at task closure
- `routing.yaml`-generated `SKILL.md` Common Tasks and thin-shell bootstraps select the workflow; the workflow owns later evidence-based activation

If a future agent could still miss the lesson while following the normal task path, the knowledge is stored but not yet activated.

## Skill Activation Verification

Phase 8 checks structural correctness; full runtime activation still needs human judgment. `smoke-test.sh` now partly automates two of these — it WARNs on a missing SessionStart hook (Pitfall #7, §1d) and on a keyword-stuffed description (§4c). The rest below remain manual. Use these additional checks after migration.

### Description Quality Check

| Check | Pass criteria |
|---|---|
| Length | ≥ 20 words or ≥ 40 CJK characters |
| Trigger phrases | At least 2 quoted trigger phrases in the user's actual language(s) (e.g. "refactor project rules", "重构项目规则") |
| Format | Third-person: "This skill should be used when…" |
| Scope | Coarse domain / intent-cluster activation; not "helps with development" and not a list of every workflow |
| Specificity | Mentions concrete activation conditions, not just category labels |

A description that fails these checks may silently never fire — the skill exists but the Agent never picks it up.

Re-read the `description` block aloud after editing frontmatter. Listen for over-broad scope, workflow keyword stuffing, missing quoted phrases in the user's actual language, and (in multi-skill repos) duplicate trigger phrases shared with another skill. The earlier `check-description-routing.sh` script was removed in 2026-05 — it parsed 125 lines of YAML to surface things a human eyeballs in 30 seconds; the discipline is content judgment, not a tooling gap.

### Routing Coverage Check

Verify that `SKILL.md` Common Tasks covers the project's actual task distribution:

1. List the 5–10 most common task types in the project
2. For each, confirm `routing.yaml` has a matching entry with correct file routing
3. If a common task is missing, add it — uncovered tasks fall through to the generic "Other" route and may miss important rules/references
4. Run `scripts/sync-routing.sh --check` so generated `SKILL.md` Always Read / Common Tasks and thin-shell blocks cannot drift
