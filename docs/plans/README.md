# Plan Decision Records And Archive

Plans are current requirement/design and implementation-review contracts while `draft` or `executing`, then frozen snapshots after `done` or `abandoned`. They are not default task knowledge and are not full conversation transcripts.

## When A Plan File Exists

Planning starts in the conversation plus the harness-native Plan. Complexity changes analysis depth, not materialization timing. Create a durable Plan only after [`plan-feature.md` § Artifact Pressure Gate](../../templates/skill/workflows/plan-feature.md#artifact-pressure-gate) admits it: the user explicitly requests an artifact, a load-bearing decision needs persistence/handoff, an independent consumer/reviewer/validator/lifecycle exists, a cross-module conflict needs one reconciled owner, or an integrated surface has become harder to use than an extracted owner.

A concrete problem or Complex/Large label does not automatically create a file. Create the smallest current carrier; every later sibling must pass the same gate independently.

## Physical Shape

Use one dated file for a focused one-file record:

```text
docs/plans/YYYY-MM-DD-<slug>.md
```

Use a directory when the durable object is a named dossier, must collect multiple admitted topics, follows an existing local archive contract, or already has an independently justified sibling:

```text
docs/plans/YYYY-MM-DD-<slug>/
├── prd.md          # requirement/decision synthesis and links
└── <name>.<ext>    # only the independently consumed design/evidence/SQL surface
```

`prd.md` is the directory entry, not a reason to pre-create `design.md`, `risks.md`, `database.md`, or any other taxonomy. A correct dossier may contain only `prd.md`. Name siblings by their actual question. Content always read, reviewed, and changed together stays together. If a sibling would not change a decision, task boundary, risk treatment, or proof when read alone, merge it into the current owner.

When a one-file Plan later gains real dossier or sibling pressure, it may move into a directory as `prd.md` with Git history preserved. Do not predict that pressure by pre-creating files or empty siblings.

### Plan Composition

A reference or dependency does not by itself make a composite Plan. Composition exists when multiple independently authoritative Plans must share execution order, conflict handling, integrated acceptance, authorization, delivery, or final Closure under one outcome.

Use this independence test before nesting a Plan:

> Remove the proposed parent. Can this Plan still independently complete, freeze, and be directly consumed later?

- **Yes:** it is an independent Component Plan. Keep its own archive path and lifecycle; a durable Integrating Plan points to it with one-way `consumes`.
- **No:** it is a true subplan. Place it naturally inside the parent dossier, give it `subplan_of: prd.md`, and let it share the parent's lifecycle rather than creating an independent `status` or `distilled_to`.

Composite execution remains Session-only by default, with one harness-native Plan and one active mainline. Plan count alone never creates another file. Materialize only when the composition itself has concrete persistence pressure such as independent recovery, review, conflict resolution, cross-repository delivery, authorization, integrated acceptance, or final Closure.

A durable Integrating Plan always uses a dossier with `prd.md` as its entry. It owns the common outcome, Component roles, dependency order, composition conflicts, integrated acceptance, authorization/delivery boundary, and final Closure without copying Component bodies or status. Promote an existing truthful owner into that dossier before creating a third Plan. A frozen Plan may undergo path and graph-metadata correction only when its existing content already owns the composition semantics; any new decision, scope, acceptance, or conclusion requires a successor Plan.

## Semantic Contract

Use [`_TEMPLATE.md`](_TEMPLATE.md) only after materialization is admitted. A useful Plan lets an implementer and reviewer reconstruct:

- the concrete problem, scope, current owner/flow/state, and desired outcome;
- current user-confirmed decisions with compact `Decision Context` when authority matters;
- observable requirements and acceptance;
- Current -> Target design, semantic impact, activated risks, recovery, and proof when evidence makes them relevant;
- executable `Files / Consumes / Produces / Acceptance` interfaces only after decomposition is stable;
- genuine unresolved decisions, with resolved questions removed.

Headings are not the completeness unit. Add only warranted sections in a natural order. Alternatives appear only when genuinely different viable shapes or a load-bearing rejection exists. A created file, filled section list, long transcript, placeholder Task Breakdown, or successful command is not Plan readiness.

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

- **draft**: active design. Confirmed decisions are superseded explicitly, not silently rewritten.
- **executing**: implementation is consuming the current mainline. At handoff, distill stable business-bearing meaning into its routed owner, initialize truthful `distilled_to:`, and pass the Plan path plus relevant decisions to Task Execution. Purely technical Plans create no business leaf.
- **done**: delivery landed. Before changing status, reconcile later Decision Deltas, implementation evidence, activated destinations, and final `distilled_to:` targets.
- **abandoned**: explain why in one short section. Do not distill an unchosen direction.

For an Integrating Plan, final reconciliation reads every `consumes` owner directly, completes each affected Component's own reconciliation, then proves the cross-Plan contract and requested delivery. A required Component that is missing, abandoned, unresolved, still `draft`/`executing`, or replaced by an unconsumed successor blocks Integrating `done`.

Frozen Plans are read-only audit history. Outside direct implementation/review lineage, they are reached by explicit path, provenance link, `git log docs/plans/`, or archive search, not by default routing.

## Frontmatter

```yaml
---
date: YYYY-MM-DD
status: draft            # draft | executing | done | abandoned
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

- `consumes` belongs to the Integrating `prd.md` and points to independent Component Plans. It stores paths only, never mirrored decisions, acceptance, distillation, or status.
- `subplan_of: prd.md` belongs to a true child inside the dossier. A true subplan has no independent `date`, `status`, or `distilled_to`; the parent links it from the synthesis.
- `supersedes` belongs to a successor and points one-way to a frozen Plan whose future-facing contract it replaces. The old Plan remains unchanged.

Do not add `plan_role`, `components`, `consumed_by`, Component status mirrors, or subplan progress fields. All graph paths must resolve from the file that declares them.

## When A Plan Closes

Move only surviving, future-binding meaning into active owners:

| Conclusion | Active owner |
|---|---|
| Stable user-confirmed business type/flow/state/boundary/invariant/reason | routed `references/business/<domain>.md` as desired business truth with Plan provenance |
| Future task constraint | the routed `rules/` owner |
| Costly repeatable failed approach | `references/gotchas.md` or routed domain pitfall owner |
| Pure history and rationale for this delivery | frozen Plan only |

One destination owns the complete definition. Other audiences may keep only the smallest action hook and owner link. Do not copy the same conclusion into business, rule, Gotcha, and Plan merely for visibility.
