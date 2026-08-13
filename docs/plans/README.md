# Implementation Plan Records And Archive

Plans are implementation-design and implementation-review contracts while
`draft` or `executing`, then frozen snapshots after `done` or `abandoned`. They
consume a `requirement-ready` source; they do not own, complete, narrow, or
rewrite its goal, scope, model/flow, rules, constraints, preservation,
permissions, or acceptance. They are not default task knowledge and are not
full conversation transcripts.

This archive can hold both Governing Requirements and Implementation Plans, but
they remain separate authorities. In a new dossier, `prd.md` owns normative
Requirement meaning and `design.md` owns implementation design and Plan
lifecycle. The Plan points to the Requirement one way. A Requirement-only
dossier may correctly stop with `prd.md` and no Plan.

## Independent Artifact Pressure Gates

Requirement and Plan state remain Session-only by default. Each artifact must
pass its own pressure gate; complexity, activity, file count, duration, or
pressure on the other artifact is not evidence.

- **Requirement Artifact Pressure Gate:** Requirement Definition creates or
  updates the smallest Governing Requirement only when the user explicitly asks
  for a Requirement/PRD, or the Requirement has an independent recovery,
  handoff, review, validator, conflict, or lifecycle reader. A Requirement-only
  PRD is a complete `requirement-ready` deliverable. It creates no Plan, Task
  Breakdown, proof command, code mutation, or live implementation status.
- **Plan Artifact Pressure Gate:** after `implementation-ready`, Plan Feature
  creates the smallest Implementation Plan only when the user explicitly asks
  for that artifact, or implementation design has independent recovery,
  handoff, review, validation, conflict-resolution, or lifecycle pressure. Plan
  pressure cannot create a Requirement artifact on Plan Feature's behalf.

If Plan pressure reveals that the Requirement also needs a durable owner,
return to Requirement Definition and create or update that owner first. Reach
`requirement-ready` again, then let the Plan link to it. The Plan never copies,
narrows, completes, modifies, supersedes, or replaces the Requirement.

## When A Plan File Exists

Requirement-bearing work first closes the desired outcome, authoritative scope,
preserved behavior, decision-bearing model/flow/rules, boundaries, and
observable acceptance through Requirement Definition. It then projects Goal,
Done When, and material Boundaries into a Task Anchor and proves the current
owner, Current -> Target, affected paths, and high-cost boundaries until
`implementation-ready`. Only then may a Plan derive technical means and proof
steps. Clear wording can reach requirement readiness without questions, but
apparent implementation locality cannot skip this order.

Durable planning starts only after that Requirement formation. Complexity changes analysis depth, not materialization timing. Create a Plan file only after [`plan-feature.md` § Artifact Pressure Gate](../../templates/skill/workflows/plan-feature.md#artifact-pressure-gate) admits it: the user explicitly requests an artifact, a load-bearing implementation decision needs persistence/handoff, an independent implementation consumer/reviewer/validator/lifecycle exists, a cross-module implementation conflict needs one reconciled owner, or an integrated design surface has become harder to use than an extracted owner.

A concrete problem or Complex/Large label does not automatically create a file. Create the smallest current carrier; every later sibling must pass the applicable gate independently.

## Physical Shape

Use one dated file for a focused one-file record when the Plan consumes an
authoritative Session or external Requirement source:

```text
docs/plans/YYYY-MM-DD-<slug>.md
```

Use a directory when the durable object is a named dossier, must collect multiple admitted topics, follows an existing local archive contract, or already has an independently justified sibling:

```text
docs/plans/YYYY-MM-DD-<slug>/
├── prd.md          # Governing Requirement; normative authority
├── design.md       # only when an independent Implementation Plan is admitted
└── <name>.<ext>    # only another independently consumed evidence/SQL surface
```

`prd.md` is the normative entry, not a reason to pre-create `design.md`,
`risks.md`, `database.md`, or any other taxonomy. A correct dossier may contain only `prd.md` when Requirement-only delivery is all that passed pressure. When
`design.md` is admitted, it declares `requirement: prd.md`, links the same owner
in its body, and contains no Requirement copy. Name other siblings by their
actual question. Content that has no independent consumer stays in its current
owner, but normative and implementation content never merge merely because the
same people read both.

When a one-file Plan later gains a durable Requirement owner, move it into the
resulting dossier as `design.md` with Git history preserved and add the one-way
Requirement link. Do not predict that pressure by pre-creating files or empty
siblings.

Historical frozen dossiers may already use `prd.md` as their Plan entry. Keep
those records frozen and interpret their graph metadata under the contract that
created them; do not rewrite audit history merely to match the new naming. Any
new Requirement or implementation decision uses a successor dossier with
separate owners.

### Plan Composition

A reference or dependency does not by itself make a composite Plan. Composition exists when one common Requirement-governed outcome needs technical work from multiple independently maintained Plans to share execution order, conflict handling, integrated proof, authorization, delivery, or final Closure. Governing Requirements remain the normative authorities for every Component and the common outcome.

Use this independence test before nesting a Plan:

> Remove the proposed parent. Can this Plan still independently complete, freeze, and be directly consumed later?

- **Yes:** it is an independent Component Plan. Keep its own archive path and lifecycle; a durable Integrating Plan points to it with one-way `consumes`.
- **No:** it is a true subplan. In a new dossier, place it naturally under the `design.md` Plan owner, give it `subplan_of: design.md`, and let it share the parent's lifecycle rather than creating an independent `status` or `distilled_to`. For a frozen legacy Plan whose `prd.md` was already the Plan owner, continue to give it `subplan_of: prd.md`; never introduce that relation from a new Requirement `prd.md`.

Composite execution remains Session-only by default, with one harness-native Plan and one active mainline. Plan count alone never creates another file. Materialize only when the composition itself has concrete persistence pressure such as independent recovery, review, conflict resolution, cross-repository delivery, authorization, integrated proof, or final Closure.

A durable Integrating Plan uses `design.md` as its Plan entry and points to its
Governing Requirement or Requirements. It owns Component technical roles,
dependency order, implementation composition conflicts, authorization/delivery
mechanics, integrated proof, and final Closure without copying Component
bodies, status, Requirement meaning, or acceptance. Promote an existing truthful owner into that dossier before creating a third Plan. A frozen Plan may undergo path and graph-metadata correction only when its existing content already owns the technical composition semantics; any new normative or implementation decision requires a successor in the owner that changed.

## Semantic Contract

Use [`_TEMPLATE.md`](_TEMPLATE.md) only after materialization is admitted. A useful Plan lets an implementer and reviewer reconstruct:

- the governing Requirement path, or precise authoritative external/Session
  source, plus authority, readiness, and supersession state without copying its
  normative body;
- current implementation facts, owner/flow/state, Current -> Target binding, and affected technical boundaries;
- implementation decisions and genuine technical alternatives with their evidence;
- Current -> Target design, semantic impact, activated risks, recovery, and proof when evidence makes them relevant;
- the mapping from each Requirement acceptance criterion to its fitted proof;
- executable `Files / Consumes / Produces / Acceptance` interfaces only after decomposition is stable;
- genuine unresolved technical decisions, with resolved questions removed.

Headings are not the completeness unit. The Requirement and its acceptance
govern every later design and Task Interface; Plan steps and test code cannot
backfill, narrow, or invent the target. A normative question that can change
goal, scope, model/flow, rules, constraints, preservation, permission, or
acceptance returns to Requirement Definition. Add only warranted sections in a
natural order. Alternatives appear only when genuinely different technical
shapes preserve the same Requirement. A created file, filled section list, long
transcript, placeholder Task Breakdown, or successful command is not Plan
readiness.

Technical evidence that changes only Current facts, implementation owner,
feasibility, impact, risk, ordering, recovery, or proof updates Implementation
Binding and the Plan while leaving Task Anchor unchanged. Evidence that would
change Goal, normative scope, preservation, permission, Done When, acceptance,
or desired meaning returns to Requirement Definition. Only after the
Requirement is ready again may Task Execution re-project the Anchor.

## Database-Structure Changes

Any change to a database table, column, index, constraint, or other persisted structure independently passes Artifact Pressure. Before application or persistence code enters implementation, separately disclose the affected database object, structural change, compatibility/backfill behavior, SQL artifact path, execution owner, and authorization boundary. A database-impact sentence buried in a general design section is insufficient.

The Plan must be a dossier and contain a naturally named `.sql` sibling. That SQL file is an independently reviewable target/migration/proof artifact, not another Plan, and must contain:

- complete target-state DDL derived from the authoritative current schema, database dialect/version, constraints, indexes, and comments;
- forward schema update SQL plus required DML/backfill/data correction, or an explicit reason no data update is required;
- read-only verification SQL proving the target structure and data invariants;
- executable rollback SQL when reversal is proven safe, otherwise an explicit unsafe/irreversible statement with backup, stop conditions, and forward-repair recovery;
- the project-owned execution workflow and a clear statement that the artifact does not itself authorize a database write.

Do not guess a type, default, nullability, ordering, index, comment, migration, or historical-data behavior. When independently executed dialects require different syntax, use separate natural SQL siblings. When the Plan has no database-structure impact, create no placeholder SQL file or database section.

## Lifecycle

```text
no artifact -> draft -> executing -> final reconciliation -> done -> frozen
                         |
                         -> abandoned -> frozen, no distillation
```

- **draft**: active implementation design consuming one named Governing Requirement. Technical decisions may change; normative changes return to the Requirement owner and cannot directly update Task Anchor.
- **executing**: implementation is consuming the current Requirement mainline and Plan design. At handoff, distill stable business-bearing meaning through its Requirement-owned route, initialize truthful `distilled_to:`, and pass the Requirement plus Plan paths to Task Execution. Purely technical Plans create no business leaf.
- **done**: delivery landed. Before changing status, reconcile later Requirement Decision Deltas, implementation evidence, activated destinations, and final `distilled_to:` targets.
- **abandoned**: explain why in one short section. Do not distill an unchosen direction.

For an Integrating Plan, final reconciliation reads every Component Requirement and `consumes` Plan owner directly, completes each affected owner's reconciliation, then proves the integrated result against the common Requirement acceptance and requested delivery. A required Component that is missing, abandoned, unresolved, still `draft`/`executing`, or replaced by an unconsumed successor blocks Integrating `done`.

Frozen Plans are read-only audit history. Outside direct implementation/review lineage, they are reached by explicit path, provenance link, `git log docs/plans/`, or archive search, not by default routing.

## Frontmatter

```yaml
---
date: YYYY-MM-DD
status: draft            # draft | executing | done | abandoned
# requirement: prd.md    # when a durable sibling Requirement exists
distilled_to:            # initialize at implementation handoff when applicable
  - rules/<topic>.md
  - references/business/<domain>.md
  - references/gotchas.md
# consumes:              # durable Integrating Plan only; repository-resolvable paths
#   - ../YYYY-MM-DD-<component>.md
# supersedes:            # successor Plan only; never add a reverse link to the frozen Plan
#   - ../YYYY-MM-DD-<frozen-plan>.md
---
```

Omit `distilled_to` when abandoned or when final reconciliation proves no conclusion is load-bearing; state that judgment in the Plan.

Use only the graph relation that matches actual ownership:

- `requirement` belongs to `design.md` and points one way to its Governing Requirement. The Requirement has no reverse Plan field or Plan-status mirror.
- `consumes` belongs to the Integrating `design.md` and points to independent Component Plans. It stores paths only, never mirrored decisions, acceptance, distillation, or status.
- `subplan_of: design.md` belongs to a true child inside a new dossier. A true subplan has no independent `date`, `status`, or `distilled_to`; the parent links it from the synthesis. `subplan_of: prd.md` remains valid only for a frozen legacy Plan whose existing Plan entry is `prd.md`.
- `supersedes` belongs to a successor and points one-way to a frozen owner whose future-facing contract it replaces. The old Requirement or Plan remains unchanged.

Do not add `plan_role`, `components`, `consumed_by`, Component status mirrors, or subplan progress fields. All graph paths must resolve from the file that declares them.

## When A Plan Closes

Move only surviving, future-binding meaning into active owners:

| Conclusion | Active owner |
|---|---|
| Stable user-confirmed business type/flow/state/boundary/invariant/reason | routed `references/business/<domain>.md` as desired business truth with Requirement provenance |
| Future task constraint | the routed `rules/` owner |
| Costly repeatable failed approach | `references/gotchas.md` or routed domain pitfall owner |
| Pure history and rationale for this delivery | frozen Plan only |

One destination owns the complete definition. Other audiences may keep only the smallest action hook and owner link. Do not copy the same conclusion into business, rule, Gotcha, and Plan merely for visibility.
