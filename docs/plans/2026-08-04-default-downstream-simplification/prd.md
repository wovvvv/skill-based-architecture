---
date: 2026-08-04
status: done
---

# Plan: Default Downstream Simplification

> Current conclusion: SBA must materialize one small but complete, self-contained downstream project Skill from real project evidence instead of copying the fixed Full scaffold into every Quick Start migration. The stable product contract is the downstream's runtime responsibilities and completion behavior, not another fixed minimal file list.

## Problem And Scope

At Plan inception, SBA documented Progressive Rigor as Single-file -> Folder-light -> Full growth under concrete pressure, but the standard Quick Start write path copied the complete `templates/skill/` tree into every admitted downstream project. That fixed-copy behavior (then measured at 42 files and about 4,964 lines, including 18 workflows, 8 scripts, 5 protocol blocks, 9 pre-populated task routes, and author-side maintenance and upstream-sync mechanisms) is the historical baseline for this Plan, not the current materializer contract.

This makes the physical product contradict its intended user contract: ordinary project members should be able to clone or pull the downstream repository and use it directly without understanding SBA tiers, profiles, capability selection, installation modes, or author-maintenance internals.

This Plan owns the default downstream delivery boundary, the single migration/materialization path, and the later reduction of duplicated runtime and maintenance responsibilities. It does not reuse `docs/plans/2026-07-15-safe-progressive-adoption/`, whose draft direction exposed profile/tier/assembly concepts that the user subsequently rejected.

## Current Decisions

### D1 - One evidence-driven materialization path

SBA will no longer treat `cp -R templates/skill/.` as the fixed output of Quick Start. The Agent must first inspect the target repository's existing instruction sources, real recurring tasks, actual harness surfaces, and already-observed maintenance pressure, then materialize the smallest complete project Skill that preserves those requirements.

Decision Context:

- Trigger/question: whether Quick Start should keep copying the Full scaffold or generate a proportionate downstream Skill.
- Faithful answer: "可以,就按这个来" after reviewing the evidence-driven, small-but-complete direction.
- Authority: user-confirmed.
- Normative meaning: ordinary users get one migration action and one complete resulting repository; they do not select or manage SBA tiers, profiles, capabilities, locks, update modes, or secondary installation steps.
- Scope: the selection is internal to the Agent and migration mechanism; the resulting downstream repository remains self-contained and directly usable after clone/pull.
- Agent-derived consequences: project-specific routes and workflows come from target evidence; unused author mechanisms are not copied merely because they exist upstream; later real pressure may add structure through ordinary project evolution rather than user-managed reinstallation.
- Evidence / Source: current conversation; `docs/sba-bible.md` principles 1, 2, 7 and direction 4; `references/progressive-rigor.md`; `scripts/scaffold-downstream.sh`; `templates/ANTI-TEMPLATES.md`.

### D2 - Stable responsibilities, evidence-selected physical shape

The default downstream core is defined by the responsibilities required to discover, route, execute, verify, and complete the project's admitted tasks. It is not defined by a universal list of files that every project must receive.

Decision Context:

- Trigger/question: whether simplification should replace the Full scaffold with another fixed minimal file set, or keep the runtime contract stable while allowing materialization to choose the smallest complete physical shape.
- Faithful answer: "这个按你说的", confirming the responsibility-first recommendation.
- Authority: user-confirmed.
- Normative meaning: two downstream projects may satisfy the same SBA product contract with different file layouts. A responsibility may be merged into an existing owner when it has no independent load, routing, ownership, or maintenance reason; it becomes a separate file only when project evidence creates such a reason.
- Scope: default downstream materialization, file admission, merging/splitting, generated validation, and later project evolution. This does not weaken the requirement that the resulting repository be complete and directly usable after clone/pull.
- Agent-derived consequences: each generated file needs a current responsibility and activation path; universally co-loaded/co-changed content should stay together; conditional task/domain/maintenance capabilities remain absent until target evidence admits them; validation proves the resulting behavior and path integrity rather than equality with a canonical file inventory.
- Evidence / Source: current conversation; `docs/sba-bible.md` principles 1, 2, 7, 8 and direction 4; current Plan D1.

### D3 - `routing.yaml` is conditional routing ownership

A true Single-file / single-task downstream does not receive an independent `routing.yaml`. Its sole admitted task procedure and activation boundary remain directly in `SKILL.md`. The route manifest materializes only when routing data gains an independent selection, sharing, generation, validation, or maintenance reason.

Decision Context:

- Trigger/question: whether every downstream must contain `routing.yaml`, or whether a Single-file / single-task Skill may keep its only route in `SKILL.md` until real routing-source pressure appears.
- Faithful answer: "做", approving the recommendation that `routing.yaml` is conditional rather than an unconditional core file.
- Authority: user-confirmed.
- Normative meaning: routing responsibility is always present, but its physical owner may be the only `SKILL.md`. Materialize `routing.yaml` when at least two independently selectable workflows exist, multiple harness shells require one generated route source, route data needs independent synchronization/validation, or the route table no longer fits the concise entry responsibility.
- Scope: task routing ownership, thin-shell generation, route validation, Single-file -> routed-skill evolution, and the migration mechanism that performs that evolution without user package selection or reinstallation.
- Agent-derived consequences: a Single-file output must still state an unambiguous sole task/fallback boundary and session recovery behavior appropriate to its harness; promotion moves route data out of `SKILL.md`, updates only actual harness consumers, and adds fitted routing checks atomically; no duplicate authoritative route table remains behind.
- Evidence / Source: current conversation; `references/progressive-rigor.md`; `references/layout.md`; `references/thin-shells.md`; current `scripts/scaffold-downstream.sh` and template validation assumptions.

### D4 - Task Execution and Task Closure materialize independently

Task Execution and Task Closure are responsibilities that apply according to task behavior; they are not a fixed pair of files installed into every downstream. A simple project's only admitted workflow may own its applicable execution, fitted verification, AAR, and completion behavior directly.

Decision Context:

- Trigger/question: whether `task-execution.md` and `task-closure.md` must always exist independently, or may a simple workflow keep those responsibilities until sharing, complexity, delayed-phase, or delivery pressure appears.
- Faithful answer: "可以", approving the independent-admission recommendation.
- Authority: user-confirmed.
- Normative meaning: materialize `task-execution.md` when Managed execution semantics such as Task Anchor, dependent Native Plan steps, decision drift, replan, pause/resume, or new-message handling are shared or independently loaded. Materialize `task-closure.md` when multiple changing workflows share completion, or AAR/knowledge reconciliation, integrity work, delayed Closure, or verified external delivery gains an independent phase. Either file may exist without the other.
- Scope: simple versus Managed execution, workflow ownership, verification and AAR placement, delivery completion, protocol loading, and later promotion from one workflow to shared cross-cutting owners.
- Agent-derived consequences: a single simple workflow embeds only the compact behavior it actually needs; once a cross-cutting protocol is split, domain workflows retain local triggers and acceptance hooks but link to the unique complete owner instead of copying it; promotion moves existing behavior atomically and validates that no task loses completion or drift handling.
- Evidence / Source: current conversation; `references/progressive-rigor.md`; current `templates/skill/workflows/task-execution.md`, `task-closure.md`, `change-managed.md`, and `fix-bug.md`; `references/protocols.md`.

### D5 - Harness surfaces follow evidence, with a minimal user question only when needed

Downstream materialization creates, merges, and validates only harness entry or registration surfaces that are already present, required by detected project/tool configuration, needed by the currently executing harness, declared by repository/team evidence, or explicitly requested. It does not emit the full Codex/Claude/Gemini/Cursor shell set by default.

Decision Context:

- Trigger/question: whether every downstream should receive all harness shells, or only the entry/registration surfaces supported by target evidence.
- Faithful answer: "可以的,并且会在需要的情况下询问用户".
- Authority: user-confirmed.
- Normative meaning: the Agent first inventories existing instruction entries, harness configuration, the current execution environment, and repository/team documentation. When that evidence leaves two materially different support scopes plausible and the choice changes generated files or maintenance obligations, ask one minimal user question. Clear evidence is acted on directly; ordinary users are not asked to select harness packages.
- Scope: `AGENTS.md`, `CLAUDE.md`, `CODEX.md`, `GEMINI.md`, Cursor/Windsurf/tool-specific rules and Skill registration, existing-entry preservation, cross-harness support intent, discovery validation, and later harness adoption.
- Agent-derived consequences: support the current harness as the no-evidence floor; preserve and semantically migrate every existing entry even when its harness is not currently active; treat `CODEX.md` and other compatibility mirrors as conditional; add later harnesses through ordinary atomic project maintenance without remigration; validate only emitted/detected surfaces and any required cross-surface consistency.
- Evidence / Source: current conversation; `references/progressive-rigor.md`; `references/thin-shells.md`; `references/per-tool-shells.md`; current `scripts/scaffold-downstream.sh` and `WORKFLOW.md` inventory behavior.

### D6 - Validation claims are separated by what they actually prove

Deterministic structural green, migration-evidence integrity, and live Agent behavior are independent proof layers. A validator may pass only the claim it directly establishes; no aggregate success message may promote structural consistency, phrase presence, or a static route row into semantic or behavioral correctness.

Decision Context:

- Trigger/question: after distinguishing the overweight default product from inaccurate validation, whether to first repair the validation oracle by keeping structural checks bounded, accepting both correct Single-file and complete results, rejecting mechanical marker laundering, adding source-disposition and activation evidence, and separating an opt-in live Agent journey from deterministic `check-all`.
- User source: "按你说的做".
- Authority: user-confirmed, bound to the immediately preceding validation-repair recommendation rather than the later materializer implementation.
- Normative meaning: `SKILL.md` is universal; routing, workflows, protocol owners, harness entries, Cursor registration, and conformance are strict only when actually materialized or explicitly declared. A complete scaffold remains strict for every responsibility it emits. Migration evidence must account for every inventoried decision-changing source clause, but scripts must not claim that text search proves faithful-rewrite equivalence. Default deterministic green must state that live Agent behavior was not run.
- Scope: `smoke-test.sh`, upstream validation fixtures and orchestration, source-to-destination evidence integrity, check-suite naming and terminal claims, fitted conformance usage, and an opt-in real-harness journey. Together with D1-D5, this now governs the shipped evidence-driven Quick Start materializer and its bounded proof claims.
- Agent-derived consequences: a correct Single-file Skill cannot fail merely because Full-only files are absent; renaming `FILL:` to `FILLED:` remains unresolved work and fails; verbatim mappings and activation chains are executable, rewrites retain explicit review authority, and a live runner reports external unavailability as no verdict rather than pass/fail behavior evidence.
- Evidence / Source: current conversation; `docs/sba-bible.md` principles 3 and 5 plus the explicit non-direction against using structural green as semantic proof; current `scripts/check-all.sh`, `templates/skill/scripts/smoke-test.sh`, `templates/skill/conformance.yaml`, and `scripts/check-self-scenarios.sh`.

## Requirements And Acceptance

- The user-facing migration contract remains one ordinary request such as "用 SBA 整理这个项目的规则"; no tier, profile, capability, or install-mode choice is exposed.
- Before writing, the Agent derives the target file and route set from existing project instructions, actual recurring tasks, used harnesses, and evidenced maintenance needs.
- The resulting downstream Skill is complete and self-contained: a fresh clone/pull can route and execute its admitted project tasks without requiring the SBA authoring repository at runtime.
- The materialization contract is stated in required runtime responsibilities and observable completion behavior, not an exact mandatory file count or fixed minimal directory tree.
- Projects with different task, harness, domain, and maintenance evidence may receive different physical layouts while satisfying the same discovery, routing, execution, verification, and completion contract.
- A responsibility is merged into an existing owner when it has no independent load/change reason and split only when a real route, owner, conditional activation, generation boundary, or maintenance pressure requires it.
- Generated validation proves the admitted task paths and completion behavior of the materialized result; it must not require byte equality with a universal downstream file inventory.
- A true Single-file / single-task result keeps its sole route and fallback boundary in `SKILL.md` and does not generate `routing.yaml`, routing-sync machinery, or route-manifest checks merely for structural uniformity.
- Materialize `routing.yaml` atomically when multiple workflows require selection, multiple harness entries need one route source, route data gains independent generation/validation pressure, or the concise `SKILL.md` entry can no longer own the route table cleanly.
- Routing promotion moves authoritative route data out of `SKILL.md`, updates the actually used harness entries, and enables fitted sync/integrity checks in one change; the user does not choose a mode or reinstall a capability set.
- A single simple workflow may directly own its applicable execution, fitted verification, compact AAR, and completion checks without generating independent Task Execution or Task Closure files.
- Materialize `task-execution.md` when Managed execution semantics are shared across workflows or gain an independently selected/loaded lifecycle; Simple tasks continue to bypass that protocol.
- Materialize `task-closure.md` independently when completion behavior is shared, or when delayed AAR/knowledge/integrity/delivery reconciliation forms a separate phase. Its presence does not require a separate Managed execution protocol.
- Promotion to either cross-cutting owner moves the complete shared definition atomically, leaves only local trigger/acceptance hooks in task workflows, and verifies that every changing task still reaches the applicable completion path exactly once.
- Before creating harness surfaces, inventory existing instruction files, tool configuration, the currently executing harness, and repository/team declarations; preserve every existing entry as migration evidence.
- Create or merge only the minimum entry/registration surface required by that evidence. With no other support evidence, the currently executing harness is the default supported surface.
- Ask one minimal user question only when repository evidence cannot distinguish materially different intended support scopes whose choice changes files or ongoing maintenance; do not ask users to select a standard harness package when the answer is discoverable.
- `CODEX.md`, optional native Skill registrations, and other compatibility mirrors are generated only for a proven reader; modern Codex/Copilot/OpenCode support normally shares `AGENTS.md`.
- Later harness adoption generates its minimum entry/registration and fitted discovery checks from the existing formal owner in one project-maintenance change; it does not rerun migration or duplicate rule bodies.
- A project receives only task workflows, rules, references, protocol support, harness shells, and validation needed by its admitted contract.
- Generic routes such as Fix Bug, Refactor, Plan, Review, or Update Upstream are not installed merely as universal examples; each non-fallback route needs target-project evidence.
- Existing scaffold safety remains intact: dry-run, complete create/preserve/conflict preview, preservation of existing entries, staging, apply rollback, and source-to-destination semantic evidence.
- Later project pressure may add files or routes through normal project maintenance, but does not require the user to reconfigure or reinstall a package composition.
- Verification must include at least one small project that does not receive Full author machinery and one legitimately Full project that retains every mechanism required by its evidence.
- The deterministic validator accepts a valid Single-file Skill without `routing.yaml`, workflow directories, Full maintenance scripts, four harness shells, or Cursor registration, while validating any such owner strictly when it is materialized.
- The complete-scaffold fixture separately asserts all routing, execution, Closure, maintenance, Cursor, and harness surfaces it declares, so adaptive validation cannot silently weaken Full coverage.
- `FILL:` residue and the historical `FILL:` -> `FILLED:` rename both fail; an upstream fixture must replace migration work with concrete project content before structural checks run.
- Each inventoried decision-changing source clause has exactly one mapped or excluded disposition. Verbatim mappings prove exact destination presence and a complete activation chain; faithful rewrites require explicit review evidence and are never labeled machine-proven semantic equivalence.
- Default `check-all.sh` success is bounded to deterministic structure, mapping-integrity, and fitted content contracts. Live Agent behavior is a separately requested gate, and transport/auth/model unavailability returns no behavior verdict.

## Implementation And Evidence

The approved contract is implemented in the local SBA checkout. The materializer now inventories target evidence before mutation, derives `direct`, `folder`, or `broad` internally, and keeps the user-facing migration request to one ordinary natural-language action. It previews `CREATE`, `PRESERVE`, and `CONFLICT`, preserves existing entries, stages writes, guards parent-directory symlinks and destination boundaries, rolls back newly created paths on apply failure, and remains dry-run by default. Temporary evidence is Agent-only and session-scoped; it is not written into the downstream repository.

The emitted carriers are responsibility-fitted rather than a universal file list:

- An empty target produces a complete Single-file carrier whose sole route and fallback boundary live in `SKILL.md`; it does not create an empty `routing.yaml` or unsupported harness/author surfaces.
- A target with one evidenced recurring procedure produces a Folder-light direct carrier with only the admitted rule/workflow owners; Task Execution and Task Closure remain absent when their independent pressure is absent.
- A broad/complete fixture retains every surface it independently declares, including routed selection, managed execution, closure, harness registration, maintenance checks, and conformance. Existing-project migration preserves old entries while recording their semantic destination and activation path.
- Managed Execution and Closure are admitted independently. The `managed-only`, `closure-only`, `both`, and `neither` combinations each materialize and validate without dangling links or implicit co-installation.

The validation contract was fitted to the materialized result. It accepts valid Single-file and Folder-light carriers while checking every owner that is actually emitted or explicitly declared. It rejects unresolved `FILL:` content and the mechanical `FILL:` -> `FILLED:` laundering, requires exactly one disposition for each decision-changing source clause, requires a complete activation chain for verbatim mappings, and requires explicit review evidence for faithful rewrites. Routing, smoke, orphan, reachability, link, conformance, and upstream checks remain strict only where their owner is present. YAML labels/triggers preserve quotes and backslashes, and the parent-symlink guard was exercised on macOS Bash 3.2.

The current proof layers are intentionally separate:

| Proof layer | Result | What it establishes | What it does not establish |
|---|---|---|---|
| Deterministic structure and fitted contracts | **PASS** — `bash scripts/check-all.sh --base HEAD` exited `0`; self-hosting conformance `485 passed, 0 failed` | Materializer journeys, declared-owner integrity, paths/routes/links, syntax, and deterministic content contracts | Natural-language semantic equivalence or real Agent choice/obedience |
| Migration-evidence integrity | **PASS** — source-disposition and activation-chain checks passed; existing-project journey passed | Every decision-changing source clause has one disposition and an executable/review-backed destination path | That a faithful rewrite is semantically equivalent merely because its text is present |
| Live Agent behavior | **NO VERDICT** — `bash scripts/check-all.sh --base HEAD --live-agent` could not establish a live transport; WebSocket disconnected, HTTP fallback timed out, and the runner returned `401 Unauthorized` / invalid API key | Nothing about behavior for this run; the named harness/prompt/temporary-target attempt was recorded | It must not be reported as either behavior pass or behavior failure |

The deterministic run also covered empty-target Single-file, one-procedure Folder-light direct, broad/complete, existing-project migration, fitted validation, and the self-hosting route/link/conformance checks. No commit, push, MR/PR, merge, assembly, deployment, publication, database, or other shared-system action belongs to this Plan execution.

## Boundaries

- Do not solve this by adding user-visible `--minimal`, `--full`, capability packs, profiles, locks, or reconfigure/update modes.
- Do not replace the Full scaffold with another fixed "minimal" file list whose contents every downstream receives regardless of evidence.
- Do not create an empty, single-row, or duplicate `routing.yaml` only to satisfy the current Full scaffold's implementation assumptions.
- Do not remove `routing.yaml` from a project whose workflows, harness shells, generation, or validation already depend on it without first moving those responsibilities to a complete owner.
- Do not generate `task-execution.md` for tasks that are always one clear action with one direct check, and do not generate `task-closure.md` for a read-only Skill with no admitted change or delivery path.
- Do not force Task Execution and Task Closure to appear or disappear together; admit each from its own consumers, phase boundary, and failure pressure.
- Do not remove completion, AAR, drift, or delivery checks merely to reduce file count, and do not duplicate a split cross-cutting protocol back into each task workflow.
- Do not create the full harness shell set merely for advertised compatibility, and do not ask the user a multi-select installation question before inspecting project evidence.
- Do not delete, overwrite, or ignore an existing instruction entry because its harness is not currently active; migrate its durable meaning and preserve the required local shell behavior.
- Do not silently choose current-harness-only support when repository evidence also makes team-wide cross-harness support materially plausible; use the minimal user question in that unresolved case.
- Do not equate a smaller default with partial or incomplete installation; each generated downstream is complete for its admitted project contract.
- Do not delete the proven scaffold safety behavior while changing materialization.
- Do not finalize file deletion or movement before the unconditional runtime core and conditional materialization boundaries are discussed and confirmed.
- Do not make model/network-dependent journeys part of every deterministic maintenance run, and do not silently skip them while claiming behavior passed.
- Do not make a static trigger literal, route target, phrase-presence check, or activation link claim that a real Agent selected, read, or obeyed it.
- Do not require a persistent downstream migration ledger; source-disposition evidence remains session-scoped unless independent project lifecycle pressure admits a durable owner.
- No database-structure change is involved.

## Closed Decisions

The remaining maintenance boundary is closed. Scaffold orchestration, migration-evidence fixtures, and the live-Agent journey remain upstream-only because they serve SBA authors and proof collection rather than a downstream runtime consumer. Routing, smoke, orphan, reachability, conformance, and upstream scripts materialize only when the target has a real consumer, declared owner, or repeatable maintenance pressure; a complete fixture keeps them strict because it explicitly declares those responsibilities. No author machinery is emitted merely for symmetry, and later pressure is handled by ordinary project maintenance without asking users to choose a capability pack or reinstall a composition.

## Residual Boundaries

- Safe materialization, path checks, and a `READY FOR SEMANTIC MERGE` terminal message prove that the scaffold can be applied safely; they do not claim that the Agent has completed the semantic merge of an existing entry.
- Source-to-destination evidence proves mapping completeness and activation reachability. It does not make an arbitrary natural-language rewrite machine-proven equivalent; faithful rewrites retain explicit review evidence.
- The live journey proves only that the named harness, prompt, temporary target, and terminal-result handling were attempted. External transport/authentication was unavailable in this run, so there is no real behavior conclusion.
- This Plan covers local SBA implementation and local proof only. Commit, push, MR/PR creation or update, approval, merge, downstream assembly/install, deploy, publish, database, and other shared-system delivery remain outside its requested scope.
