---
date: 2026-08-03
status: executing
distilled_to:
  - docs/sba-bible.md
  - docs/plans/README.md
  - docs/plans/_TEMPLATE.md
  - templates/skill/workflows/plan-feature.md
  - templates/skill/workflows/task-execution.md
  - templates/skill/workflows/task-closure.md
  - references/protocols.md
  - templates/skill/conformance.yaml
  - references/self-hosting-conformance.yaml
  - scripts/check-self-scenarios.sh
  - UPSTREAM-CHANGES.md
---

# Plan: Plan Composition And Database-Change Artifacts

> Current conclusion: preserve independently authoritative Component Plans, give every composite execution exactly one Integrating owner and one Native Plan mainline, materialize that owner only under real pressure, and require every database-structure change to surface before implementation with an independently reviewable SQL artifact.

## Problem And Scope

SBA currently hands one durable source Plan to Task Execution, but it does not define what happens when one outcome must consume two or more independently authoritative Plans. The completed Requirement-Semantics delivery exposed the missing contract:

- [`2026-07-31-evidence-funnel-code-localization.md`](../2026-07-31-evidence-funnel-code-localization.md) owns the complete source-localization mechanism and can be consumed independently.
- [`2026-08-03-requirement-semantics-change-contract/prd.md`](../2026-08-03-requirement-semantics-change-contract/prd.md) consumes that mechanism and owns the composed semantics-to-source binding.
- Both Plans had their own status, decisions, task interfaces, acceptance, and Closure responsibility, but the archive shape presented them as unrelated sibling files and no explicit composition owner existed.
- Runtime execution later covered upstream implementation, canonical Chaos/chaos-web adaptation, 0.77 assembly, and delivery through a separate top-level task mainline. Component state and final delivery state had to be reconciled late.
- The root `task_plan.md` accumulated ten sections labeled `Current Task`, so historical execution records competed with the actual active mainline.

A second organic failure exposed a related physical-artifact gap. The 0.77 iteration-testing-mode dossier specified `chaos_iteration.tester_involved` in prose and application persistence code added the field, but the user did not receive a separate pre-execution schema-change checkpoint and no independently reviewable SQL sibling existed. The version remained `SEALED`; the table definition was not registered, so deployment before DB reconciliation would risk `Unknown column`.

These failures share one product problem: a Plan must make independently owned decision, execution, review, and delivery boundaries explicit without turning SBA into a task database or creating files from complexity alone.

This Plan defines:

- Component, Integrating, and true subplan ownership;
- logical Plan graph edges and physical archive shape;
- Session-only composition and pressure-triggered dossier materialization;
- one Native Plan mainline and existing lifecycle reuse;
- conflict, Decision Delta, successor, and frozen-history behavior;
- Component-first final reconciliation and Integrating Closure;
- a mandatory SQL sibling and explicit user checkpoint for database-structure changes;
- upstream implementation, archive migration, downstream adaptation, and validation boundaries.

It does not create a scheduler, project-management database, new Plan status family, mandatory Plan registry, universal multi-file taxonomy, or direct database executor.

Business-model impact: unchanged. This is a technical planning, ownership, execution, and delivery contract; it creates no project business truth.

## Decision Context

### D1 - Plan composition is a logical contract, not a mandatory third file

- Status: confirmed.
- Authority: user-confirmed.
- Decision: multiple independent Plans may form one composite outcome, but their existence alone does not create another artifact. The composition is logically first-class and physically Session-only by default.
- Materialization: create a durable Integrating Plan only when explicit user demand or real persistence, handoff, review, recovery, conflict, cross-repository delivery, authorization, integrated acceptance, or Closure pressure exists.
- Consequence: ordinary dependencies and stable protocol references remain ordinary Plan inputs; they do not automatically become composite Plans.
- Evidence / Source: current conversation and the completed Requirement-Semantics delivery.

### D2 - Lifecycle ownership decides physical nesting

- Status: confirmed and already distilled.
- Authority: user-confirmed.
- Decision: "Plan 只有在脱离父 Plan 后无法独立完成、冻结和直接消费时，才是 `subplan_of` 并物理嵌套；否则保持独立，由 Integrating Plan 使用单向 `consumes` 关系组合。"
- Durable destination: [`docs/sba-bible.md` principle 11](../../sba-bible.md).
- Consequence: functional scope containment or a broader title does not prove parent ownership. Physical nesting expresses identity, lifecycle, and Closure ownership.

### D3 - Durable Integrating Plans are dossiers

- Status: confirmed.
- Authority: user-confirmed.
- Decision: a Session-only Integrating Plan creates no repository artifact. Once Artifact Pressure admits persistence, the Integrating Plan uses `docs/plans/YYYY-MM-DD-<slug>/prd.md`, even when `prd.md` is currently its only internal file.
- Boundary: external independent Component Plans keep their own archive paths. Only true `subplan_of` artifacts enter the dossier.
- Anti-tax: do not pre-create `components/`, `subplans/`, `design.md`, `risks.md`, or other predicted taxonomy.

### D4 - Durable graph metadata stays minimal

- Status: confirmed.
- Authority: user-confirmed.
- Integrating edge: `prd.md` lists independently authoritative Component Plan paths under frontmatter `consumes`.
- Internal child edge: a true child identifies its lifecycle owner with `subplan_of: prd.md`.
- Successor edge: a new Plan replacing a frozen Component uses one-way `supersedes`.
- Rejected metadata: `plan_role`, `consumed_by`, mirrored Component status, mirrored acceptance, local-progress fields, and duplicate relationship indexes.
- Consequence: dossier shape plus non-empty `consumes` establishes the Integrating role. Component truth remains in the Component owner.

### D5 - One execution mainline reuses the current lifecycle

- Status: confirmed.
- Authority: user-confirmed.
- Decision: composition introduces no new durable statuses. Plans continue using `draft -> executing -> done | abandoned`; current step progress remains in exactly one Native Plan / Task Anchor.
- Handoff: before an Integrating Plan enters `executing`, every consumed interface must be stable. A `done` Component remains frozen; an included `draft` Component closes its load-bearing interface and enters `executing`; an `abandoned` Component cannot be consumed as valid input.
- Runtime: the Integrating Plan derives the only active Native Plan. Component Plans supply decisions, boundaries, and local acceptance; they do not each create a competing Task Anchor.
- Completion: runtime may record Component local acceptance, but durable `done` waits for that Component's Decision Delta, evidence, delivery, `distilled_to`, and final reconciliation.

### D6 - Component reconciliation precedes Integrating completion

- Status: confirmed.
- Authority: user-confirmed.
- Decision: final Closure enumerates `consumes`, reads each Component's own current truth, completes every affected Component reconciliation, then proves the cross-Plan contract and requested delivery before marking the Integrating Plan `done`.
- Abandonment: abandoning an Integrating Plan does not abandon independent Components. True `subplan_of` content shares the parent's lifecycle and freezes with it.
- Boundary: do not add `locally_done`, `ready_for_parent`, `waiting_for_component`, or another persistent progress state. Such progress belongs only to the Native Plan.

### D7 - Integrating Plans cannot rewrite Component contracts

- Status: confirmed.
- Authority: user-confirmed.
- Integrating ownership: order, valid adapters, exclusions, integrated acceptance, authorization, delivery, and final Closure.
- Component ownership: its own meaning, invariants, boundaries, accepted interface, and local proof.
- Active Component change: return to the owning Design Slice, record a Decision Delta, mark the replaced decision `superseded`, reconcile the Component, then replay it from the Integrating mainline.
- Frozen Component change: create a successor Plan with one-way `supersedes`; keep the old Plan immutable and update the Integrating Plan's `consumes`.
- Authority: no implicit priority exists for parent scope, later date, current implementation, or implementation convenience. User-confirmed normative conflicts return to the user; technical composition conflicts are resolved from owner and implementation evidence.

### D8 - Materialization promotes an existing owner before creating a new one

- Status: confirmed.
- Authority: user-confirmed.
- Trigger: materialize before the first mutation, delegation, or cross-boundary delivery whose correctness depends on a composition contract that now has independent persistence pressure.
- Promotion: if one active Plan already owns the common outcome, move it into a same-named dossier as `prd.md`, add `consumes`, reconcile the composition interface, preserve history, and point the single Native Plan to it.
- New artifact: create a new Integrating dossier only when no existing Plan can truthfully own the common outcome.
- Frozen migration: path and graph-metadata correction is allowed only when the frozen Plan already carried the composition semantics and no historical decision, scope, acceptance, or conclusion changes. Preserve Git history and update inbound links. New semantics require a successor instead.
- Runtime cleanup: after promotion, only one task may remain semantically `Current Task`; historical tasks become closed/history and cannot compete with the active mainline.

### D9 - Every database-structure change requires a dedicated SQL artifact

- Status: confirmed.
- Authority: user-confirmed.
- Decision: whenever a Plan changes database structure, it must contain a dedicated `.sql` sibling with both the complete target DDL and the SQL statements that update the current structure and data to that target.
- Materialization: database-structure impact independently passes Artifact Pressure because the SQL has a distinct reviewer, executor, validation, and lifecycle. A previously focused Plan becomes a dossier when needed.
- Disclosure: before implementation approval, the user receives a separate schema-impact checkpoint naming the affected database/table, change, compatibility/backfill behavior, SQL artifact, execution owner, and authorization boundary. Burying the fact inside Data Contract or Task Breakdown is insufficient.
- Readiness: do not mutate persistence/application code while the schema change remains unconfirmed or the SQL dialect/current baseline/target contract is guessed.

### D10 - SQL contains target, migration, proof, and honest recovery

- Status: confirmed.
- Authority: user-confirmed for complete DDL, update SQL, and rollback/recovery behavior.
- Required surfaces:
  - complete target-state DDL derived from the real current database dialect and schema;
  - forward schema migration such as `ALTER`, table/index/constraint changes, and ordering;
  - required DML/backfill/data correction, or an explicit reason none is required;
  - read-only verification SQL for target structure and data invariants;
  - executable rollback SQL when safe, otherwise an explicit unsafe/irreversible statement with backup, stop conditions, and forward-repair recovery.
- Execution boundary: the SQL artifact is a reviewable migration contract, not automatic permission to run it. Project-owned database workflows remain authoritative. For Chaos version delivery, the platform consumes the complete declarative `CREATE TABLE`; the migration section must not be used to bypass `devops-version/workflows/sync-table-definition.md` or directly write version test/release databases.

### D11 - Implementation and downstream meta MR are authorized with isolated messaging

- Status: confirmed.
- Authority: user-confirmed.
- Decision: execute this Plan, including verified upstream implementation, canonical Chaos/chaos-web adaptation, 0.77 assembly, local reconciliation of the iteration-testing-mode SQL dossier, and creation of the downstream canonical meta MR.
- MR boundary: the downstream meta MR must describe only its own canonical changes, validation, assembly contract, and downstream dependencies. It must not mention GitHub, a GitHub PR, or an upstream repository.
- Remaining authority boundary: do not open version revision, write database definitions/data, deploy, release, publish, or merge any MR without separate authorization.
- Evidence / Source: current conversation.

## Chosen Composition Contract

### Terms And Identity

| Term | Complete owner | Independent lifecycle | Physical shape |
|---|---|---:|---|
| Focused Plan | one local requirement/design and implementation-review contract | yes | one dated `.md` unless other pressure exists |
| Component Plan | independently complete Plan consumed by one or more Integrating Plans | yes | keeps its own archive path |
| Integrating Plan | common outcome, graph edges, order, conflicts, integrated acceptance, authorization, delivery, and Closure | yes | Session-only by default; durable form is a dossier `prd.md` |
| True subplan | parent-owned decomposition that cannot independently complete, freeze, or be directly consumed | no | natural file inside the parent dossier with `subplan_of: prd.md` |
| Native Plan | current task-specific step state and one active mainline | current Session only | harness-native state; no durable repository file |
| SQL sibling | independently reviewed database target/migration/proof artifact | owned by parent Plan delivery | natural `.sql` file inside the Plan dossier; not another Plan |

The decisive Component-versus-subplan test is:

> Remove the proposed parent. Can this Plan still independently complete, freeze, and be directly consumed later?

- Yes: keep it independent and use `consumes`.
- No: it is `subplan_of` and belongs inside the parent dossier.

### Durable Graph Shape

An Integrating Plan uses repository-resolvable one-way edges:

```yaml
---
date: 2026-08-03
status: draft
consumes:
  - ../2026-07-31-evidence-funnel-code-localization.md
---
```

The `consumes` list stores paths only. It never mirrors the Component's status, decisions, acceptance, or distillation. Version 1 keeps the formal graph repository-local; cross-repository sources remain explicit provenance/task-interface references until a real portable-identity pressure proves another schema necessary.

A true child identifies its owner without creating a second lifecycle:

```yaml
---
subplan_of: prd.md
---
```

It does not own independent `status` or `distilled_to`. The parent `prd.md` links the child in its synthesis so the relation is navigable from both task entry and direct child reads without duplicating state.

A successor replaces a frozen future-facing contract one-way:

```yaml
---
date: 2026-08-04
status: draft
supersedes:
  - ../2026-07-31-evidence-funnel-code-localization.md
---
```

The old Plan remains frozen. No `superseded_by` back-reference is added.

### Integrating Plan Minimum Meaning

The Integrating `prd.md` owns only warranted composition semantics in natural sections:

- the common observable outcome that requires multiple Components;
- each Component's provided interface or role, by link rather than copied body;
- dependency/order and any allowed parallel work;
- composition conflicts and their owning decision source;
- integrated acceptance that no Component proves alone;
- authorization and delivery boundaries across repositories or systems;
- final Closure conditions and Component disposition.

These are completeness dimensions, not seven mandatory headings. A field or section appears only when it changes implementation, risk, review, or proof.

### Session-Only To Durable Promotion

Composition begins in the current Session plus the Native Plan. A compact runtime synthesis may hold source paths, common goal, dependency order, integrated Done When, and current authorization.

Materialize only when one of these pressures becomes concrete:

- explicit user request;
- cross-Session or compaction recovery of load-bearing composition decisions;
- independent consumer, reviewer, validator, or lifecycle;
- cross-repository, cross-team, or delegated delivery;
- conflict, exception, Decision Delta, or successor coordination;
- integrated acceptance not reconstructable from one Component;
- Component local completion not proving overall delivery;
- separate permission boundaries for code, DB, commit, MR, deploy, or publish;
- final Closure requiring cross-Component reconciliation;
- an independently consumed artifact such as a database SQL sibling.

When pressure appears, promotion is one transaction:

1. Find whether an existing active Plan truthfully owns the common outcome.
2. Promote that owner to a dossier, or create a new Integrating dossier only when none exists.
3. Add exact `consumes` paths and the smallest composition synthesis.
4. Reconcile every included Component interface and status precondition.
5. Replace the runtime source path with the Integrating `prd.md`.
6. Keep only one active Native Plan and one semantic `Current Task`.
7. Remove or close duplicate runtime mainlines; retain history only as closed progress.
8. Verify inbound links, graph paths, status truth, and absence of duplicate active artifacts.

### Execution And Lifecycle

Before Integrating execution:

| Component state | Required disposition |
|---|---|
| `done` | consume unchanged as frozen input |
| `executing` | absorb its remaining local work into the one Integrating Native Plan |
| `draft`, included now | close the consumed interface and transition it to `executing` during the handoff |
| `draft`, outside current authorization | exclude it or keep the Integrating Plan `draft` |
| `abandoned` | select/create a valid successor, remove it, or abandon/replan the integration |

Only the Integrating Native Plan carries live step status. It may sequence Component acceptance, but it does not write mirror progress into durable frontmatter.

Final reconciliation proceeds in owner order:

```text
Component local acceptance in Native Plan
    -> Component Decision Delta / proof / distilled_to / delivery reconciliation
    -> Component done
    -> cross-Plan interface and integrated acceptance
    -> requested delivery artifact verification
    -> Integrating Plan done and frozen
```

Abandoning the Integrating Plan leaves independent Components unchanged. True subplans freeze with their parent.

### Conflict And Supersession

Use the narrowest owner that can resolve the conflict without changing another contract:

- order, legal adapter, exclusion, integrated proof, or delivery conflict -> Integrating Plan;
- meaning, invariant, boundary, accepted interface, or local acceptance conflict -> Component owner.

Pause only the affected Native Plan path. Independent work may continue only when it cannot prejudge the unresolved decision.

An active Component records an explicit Decision Delta and supersedes the old decision internally. A frozen Component creates a successor Plan. Integrating Closure rejects:

- missing or `abandoned` consumed paths;
- simultaneous consumption of old and successor owners for one interface;
- unresolved Decision Deltas;
- integration exceptions that violate a Component invariant;
- new conclusions that remain only in runtime state;
- parent/date/current-code precedence without explicit authority.

## Database-Change Artifact Contract

### Activation And User Checkpoint

Activate this gate when evidence shows a Plan will add/drop/rename a table, column, index, constraint, sequence, partition, trigger, type, or other persistent schema structure. Seed DML and data correction use the same SQL sibling when they are required for the schema transition or delivery.

Before implementation approval, show a separate checkpoint:

```text
Database structure change: yes
Affected owner: <database / schema / table>
Target change: <observable schema outcome>
Compatibility/backfill: <old rows, old clients, mixed-version behavior>
SQL artifact: <Plan-relative path>
Execution owner: <migration tool / DBA / version platform / repository workflow>
Current authorization: <plan/code/db/deploy boundaries>
```

The Plan remains `draft` while the schema change is unconfirmed, the current schema/dialect is unknown, or the SQL artifact is incomplete. The Agent may perform read-only discovery needed to build the contract; it must not guess the database type from a Java/ORM field or defer disclosure until final deployment.

### SQL File Shape

Name the sibling by the actual database change, for example:

```text
2026-07-29-iteration-testing-mode/
├── prd.md
└── chaos-iteration-tester-involved.sql
```

The file header states:

- database engine and version/dialect evidence;
- database/schema/table owner;
- source of the current schema baseline;
- execution owner and whether direct execution is forbidden;
- compatibility, locking, availability, and transaction assumptions that affect safety.

The file contains, in an order valid for its execution contract:

1. complete target-state DDL;
2. forward schema update SQL from the verified current state;
3. DML/backfill/data correction or an explicit no-data-update reason;
4. read-only verification SQL;
5. safe executable rollback SQL, or an explicit unsafe/irreversible statement with backup, stop conditions, and forward-repair recovery.

Do not use placeholders such as `BOOLEAN_OR_TINYINT`, guessed lengths, omitted indexes, or "DBA fills this later" in an implementation-ready Plan. Distinct database/dialect execution owners receive naturally named independent SQL siblings rather than one mixed non-executable file.

### Execution Ownership

The SQL sibling is the review and handoff contract; the project workflow remains the mutation owner.

For the current Chaos version workflow:

- read the live version table definition and database engine/version;
- derive the complete target `CREATE TABLE` containing `tester_involved` with the real type/default/nullability/order/comment/index context;
- derive the forward migration and any historical-row treatment for review;
- state that direct execution against version test/release databases is forbidden;
- use `devops-version/workflows/sync-table-definition.md` after separate authorization;
- if the version is `SEALED`, stop and request authorization before opening revision;
- write the complete declarative target through the platform and read it back before claiming DB delivery.

The current 0.77 iteration-testing-mode dossier remains noncompliant until this artifact and checkpoint exist. This Plan does not itself authorize changing that business dossier or opening version revision.

## Requirements And Acceptance

- **R1 - One execution mainline:** a composite outcome has one Integrating owner and one active Native Plan; Component Plans never compete as simultaneous Task Anchors.
- **R2 - No automatic third Plan:** two or more Plan paths alone do not materialize an Integrating artifact.
- **R3 - Independent authority preserved:** reusable Component Plans keep their archive path, decisions, lifecycle, proof, and distillation.
- **R4 - True child nesting:** only a Plan that fails the independent completion/freeze/direct-consumption test may use `subplan_of` and physical nesting.
- **R5 - Durable Integrating shape:** pressure-admitted Integrating Plans use a dossier with `prd.md`; no predicted sibling taxonomy is created.
- **R6 - Minimal graph:** `consumes`, `subplan_of`, and `supersedes` are one-way path relations; no mirrored status or reverse-consumer ledger exists.
- **R7 - Existing lifecycle:** composition introduces no new durable status or runtime state database.
- **R8 - Stable handoff:** every consumed interface is stable before Integrating execution; draft/abandoned inputs cannot silently drive mutation.
- **R9 - Runtime/durable separation:** local Component progress stays in the Native Plan; the dossier owns decisions, not live steps.
- **R10 - Component-first completion:** every affected Component completes its own reconciliation before integrated acceptance and final delivery can complete the Integrating Plan.
- **R11 - No implicit override:** parent scope, later dates, current code, and implementation convenience cannot supersede Component authority.
- **R12 - Frozen evolution:** semantic changes to frozen Plans use successor artifacts and one-way `supersedes`; frozen content is not rewritten.
- **R13 - Promotion before creation:** materialization reuses an existing truthful owner before adding a new Integrating dossier.
- **R14 - One Current Task:** runtime ledgers may retain history, but only one entry is semantically current.
- **R15 - Schema disclosure:** any database-structure change is separately disclosed before implementation approval.
- **R16 - SQL artifact:** every database-structure change has a dedicated Plan-local `.sql` sibling with complete target DDL and forward update SQL.
- **R17 - No guessed schema:** current schema, dialect, type, constraints, and data behavior come from authoritative evidence.
- **R18 - Honest recovery:** rollback is executable when safe; unsafe reversals state backup, stop, and forward-repair behavior.
- **R19 - Execution owner preserved:** SQL presence does not grant DB-write authority or bypass the project migration/version workflow.
- **R20 - Evidence-bearing Closure:** path existence, green structure checks, code compilation, or an exit code cannot replace Component, integration, SQL, and delivery proof.

## Material Risks And Proof

### Graph metadata becomes a project-management system

- Invariant: SBA remains a Skill and uses the harness Native Plan.
- Failure: composition adds registries, mirrored status, dashboards, schedulers, or a new state family.
- Boundary: permit only repository-resolvable `consumes`, `subplan_of`, and `supersedes`; live progress remains runtime-only.
- Proof: conformance forbids rejected fields and scenarios prove one Native Plan.

### Directory nesting falsely claims exclusive ownership

- Invariant: reusable Component authority is not captured by one Integrating dossier.
- Failure: moving an independent Plan under one parent hides DAG reuse and changes lifecycle meaning.
- Boundary: apply the independent completion/freeze/direct-consumption test before nesting.
- Proof: scenarios cover one Component consumed by two Integrating Plans and a true child that cannot survive its parent.

### Frozen history is rewritten during migration

- Invariant: frozen decisions remain audit truth.
- Failure: archive cleanup edits a frozen Plan's meaning or acceptance to look compliant.
- Boundary: frozen migration may change path/entry metadata only when existing content already owns the relation; semantic additions require a successor.
- Proof: Git diff/content comparison plus inbound-link and path-integrity checks.

### Integrating completion hides stale Components

- Invariant: global `done` implies every required local owner and cross-owner contract is reconciled.
- Failure: Integrating tasks complete while a Component remains `executing`, stale, abandoned, or superseded.
- Boundary: Closure enumerates `consumes`, verifies statuses/decisions/proof from owners, then runs integrated acceptance.
- Proof: negative scenario with stale Component blocks Integrating `done`.

### SQL artifact is mistaken for execution permission

- Invariant: project DB owner and user authorization govern mutation.
- Failure: an Agent runs the Plan SQL directly against a managed environment or bypasses the version platform.
- Boundary: SQL header names execution owner and direct-run policy; Task Execution keeps DB mutation behind the project workflow and permission gate.
- Proof: Chaos scenario requires complete target DDL for platform write and rejects direct version-database `ALTER` execution.

### Complete DDL and migration SQL drift

- Invariant: applying the forward migration produces the declared target schema and compatible data.
- Failure: full `CREATE TABLE` says one type/default/index while `ALTER` or backfill produces another.
- Boundary: derive both from one verified current baseline and compare target/forward results before handoff.
- Proof: structured/parser or database-native validation when available; otherwise explicit semantic diff plus representative temporary-schema execution.

### Fabricated rollback damages data

- Invariant: recovery is truthful and safer than the failure it addresses.
- Failure: a mandatory-looking down migration drops populated data or reverts an irreversible transform.
- Boundary: executable rollback only when proven safe; otherwise declare irreversibility and provide backup, stop, and forward repair.
- Proof: scenario rejects placeholder/destructive rollback without recovery evidence.

## Executable Task Breakdown

### T1 - Implement The Plan Composition Archive Contract

- **Files:** `docs/sba-bible.md`, `docs/plans/README.md`, `docs/plans/_TEMPLATE.md`, `templates/skill/workflows/plan-feature.md`.
- **Consumes:** D1-D4, D8, the Chosen Composition Contract, and the existing Artifact Pressure/Plan Mainline Handoff contracts.
- **Produces:** Component/Integrating/subplan identity, durable dossier shape, `consumes`/`subplan_of`/`supersedes` ownership, promotion-before-creation, frozen migration boundary, and natural Plan synthesis requirements.
- **Acceptance:** a fresh Agent distinguishes dependency, reusable Component, and true child; creates no Integrating file from Plan count alone; and never adds rejected mirror fields.

### T2 - Implement Single-Mainline Execution And Component-First Closure

- **Files:** `templates/skill/workflows/task-execution.md`, `templates/skill/workflows/task-closure.md`, and only the smallest protocol summary in `references/protocols.md` if required for self-hosting consistency.
- **Consumes:** D5-D8, current Task Anchor/Execution Loop/User Decision Drift/Closure owners.
- **Produces:** multiple-source-Plan handoff, one active Native Plan, Component state preconditions, affected-path conflict return, Component-first final reconciliation, integrated delivery proof, and one-current-task behavior.
- **Acceptance:** runtime status is not duplicated into Plan metadata; stale/abandoned/superseded Components block completion; abandoning an Integrating Plan preserves independent Components.

### T3 - Implement The Database-Change Plan Artifact Gate

- **Files:** `templates/skill/workflows/plan-feature.md`, `docs/plans/README.md`, `docs/plans/_TEMPLATE.md`, `templates/skill/workflows/task-execution.md`, and `templates/skill/workflows/task-closure.md`.
- **Consumes:** D9-D10 and the Database-Change Artifact Contract.
- **Produces:** evidence-triggered dossier/SQL admission, explicit pre-execution schema-impact checkpoint, SQL completeness/readiness rules, project-owned execution boundary, and final SQL/DB reconciliation.
- **Acceptance:** a schema-changing Plan cannot become implementation-ready with prose-only DDL, guessed types, missing forward migration/backfill/proof/recovery, or undisclosed DB authorization; non-DB Plans create no SQL file.

### T4 - Migrate The Current Composite Archive Without Creating A Third Plan

- **Files:** move `docs/plans/2026-08-03-requirement-semantics-change-contract.md` to `docs/plans/2026-08-03-requirement-semantics-change-contract/prd.md`; add its repository-local `consumes` path; update every inbound link. Keep `docs/plans/2026-07-31-evidence-funnel-code-localization.md` independent and unchanged except for unavoidable link correction if evidence proves one.
- **Consumes:** D2-D4 and D8; the existing Requirement-Semantics content that already declares the localization Plan authoritative.
- **Produces:** one durable Integrating dossier expressing the relationship already present in the frozen content, with preserved decisions, acceptance, status, and Git history.
- **Acceptance:** semantic content diff is empty apart from entry metadata/link-path changes; old path has no active duplicate; all links resolve; the Evidence-Funnel Plan remains directly consumable.

### T5 - Add Structural And Behavior Proof

- **Files:** `templates/skill/conformance.yaml`, `references/self-hosting-conformance.yaml`, `scripts/check-self-scenarios.sh`, and existing temporary scaffold/forward-test surfaces only when needed.
- **Consumes:** R1-R20 and Material Risks And Proof.
- **Produces:** positive owner/edge/readiness assertions and negative checks against auto-materialization, mirror metadata, multiple Native Plan mainlines, stale Component completion, frozen rewrite, prose-only schema change, direct DB execution, and fake rollback.
- **Acceptance:** targeted conformance/scenarios, path integrity, temporary downstream instantiation, fresh forward runs, and full Bucket A validation pass; structural green is supplemented by semantic review of at least one composite and one DB-change journey.

### T6 - Publish An Explicit Downstream Adaptation Contract

- **Files:** `UPSTREAM-CHANGES.md` plus the canonical Chaos/chaos-web Plan/Execution/Closure/conformance owners only after upstream validation and separate downstream authorization.
- **Consumes:** verified T1-T5 behavior and project-owned Plan/permission/database workflows.
- **Produces:** source-to-destination mapping that preserves Chaos/chaos-web business semantics, current version/iteration DB workflow ownership, Tests-as-Spec/browser/permission boundaries, and generated-copy ownership.
- **Acceptance:** canonical sources consume the behavior without blind-copying generic workflows; `aii` assembly produces byte-identical `.codex`/`.claude` copies; business-code dirty work remains untouched.

### T7 - Reconcile The Organic 0.77 Database-Change Plan

- **Files:** `/Users/shiqi/ai-infra-workspace/chaos-release-0.77_shiqi/chaos/docs/requirements/2026-07-29-iteration-testing-mode/prd.md` and a new natural SQL sibling such as `chaos-iteration-tester-involved.sql`.
- **Consumes:** the live version-platform `chaos_iteration` definition, actual database engine/version, current PRD decisions, and `devops-version/workflows/sync-table-definition.md`.
- **Produces:** explicit schema-impact checkpoint in the PRD plus complete target DDL, forward update, historical-data treatment, verification, and rollback/recovery SQL contract.
- **Acceptance:** no type/default/nullability/index/comment is guessed; target and forward migration agree; the SQL declares platform execution ownership; the business Plan no longer claims DB readiness while the version remains `SEALED` or unregistered.
- **Authorization boundary:** reading current definitions and editing the dossier require downstream execution authorization. Opening version revision, platform writeback, commit, push, MR, deploy, or publish require their own explicit authorization and verified Closure.

## Validation Scenarios

1. **One focused Plan:** remains inline or one file; no `consumes`, dossier, or new runtime ceremony appears.
2. **Ordinary stable dependency:** a Plan references a stable rule/protocol/finished Plan without cross-lifecycle coordination; no Integrating artifact is created.
3. **Reusable Component:** one source-localization Plan is consumed by two different Integrating outcomes and keeps one independent path.
4. **True child:** a rollout decomposition loses meaning when its parent is removed, uses `subplan_of`, and shares parent lifecycle.
5. **Pressure promotion:** one active Plan already owns the common outcome; it becomes `prd.md` and no third Plan appears.
6. **No existing owner:** two independent Plans require a new cross-repository acceptance/Closure owner; one new Integrating dossier is created.
7. **Single mainline:** multiple consumed Plans produce one Task Anchor and one semantic `Current Task`.
8. **Active conflict:** a Component Decision Delta pauses only the affected path, updates the Component, and is replayed by the Integrating Plan.
9. **Frozen conflict:** a successor with `supersedes` replaces the consumed path; the frozen old Plan remains unchanged.
10. **Stale Component:** Integrating Closure fails while a required Component is `draft`, `executing`, abandoned, or superseded by an unconsumed successor.
11. **Integrating abandonment:** independent Components retain their states; a true subplan freezes with the parent.
12. **Frozen structural migration:** moving an already-integrating Plan to `prd.md` preserves semantic content and link history.
13. **Schema change disclosure:** an ORM/entity field implies a new column; Plan Feature identifies DB impact, obtains the current schema, shows the explicit checkpoint, and creates the SQL sibling before implementation handoff.
14. **Complete SQL:** target DDL, forward migration, backfill/no-backfill reason, verification, and rollback/recovery agree.
15. **Managed DB owner:** Chaos version delivery consumes full declarative DDL through the platform and refuses direct version-database migration execution.
16. **No DB impact:** API/state/UI-only changes do not create a placeholder SQL file or database section.
17. **Unsafe rollback:** destructive/irreversible change rejects a fake down migration and records backup, stop, and forward repair.
18. **Cross-dialect pressure:** independently executed database dialects receive separate natural SQL artifacts rather than mixed non-executable SQL.

## Rollout And Compatibility

1. Implement and validate generic upstream owners first.
2. Perform the current frozen archive structural migration and prove path integrity.
3. Run fresh composite and DB-change forward scenarios, then full Bucket A Closure.
4. Publish the source-to-destination adaptation contract.
5. With separate authorization, adapt canonical Chaos/chaos-web meta sources and assemble through `aii`; never hand-edit generated `.codex`/`.claude` copies.
6. With separate downstream business authorization, reconcile the 0.77 iteration-testing-mode dossier and SQL artifact from live DB evidence.
7. With separate external-write authorization, open version revision if required, register the table definition, and read it back. SQL-file completion alone is not DB delivery.

Existing one-file Plans remain valid. Do not bulk-convert historical archives merely to match the new shape. Migrate only an active/frozen Plan whose real composition or independently consumed artifact now requires the dossier, and apply the frozen-history boundary above.

## Open Questions

None. Implementation, canonical downstream adaptation, 0.77 assembly, local SQL-dossier reconciliation, and the downstream canonical meta MR are authorized. DB registration, deploy, release, publish, and MR merge remain separate authorization gates.

## Plan Mainline Handoff Readiness

Implementation handoff:

- replay D1-D10 and preserve user authority separately from Agent-derived fields and file choices;
- use the initialized `distilled_to` list above and remove any target that final implementation proves unnecessary;
- retain this Plan path in the Task Anchor;
- derive one Native Plan from T1-T7 according to the user's authorized scope;
- keep unrelated working-tree changes and historical untracked Plans untouched;
- preserve D11's downstream MR messaging and external-write boundaries through Closure.

The user authorized execution on 2026-08-03. T1-T7 now run through one Native Plan; external database writes and MR merge remain unauthorized.
