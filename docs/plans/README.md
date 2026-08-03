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
├── prd.md       # requirement/decision synthesis and links
└── <name>.md    # only the independently consumed design/evidence surface
```

`prd.md` is the directory entry, not a reason to pre-create `design.md`, `risks.md`, `database.md`, or any other taxonomy. A correct dossier may contain only `prd.md`. Name siblings by their actual question. Content always read, reviewed, and changed together stays together. If a sibling would not change a decision, task boundary, risk treatment, or proof when read alone, merge it into the current owner.

When a one-file Plan later gains real dossier or sibling pressure, it may move into a directory as `prd.md` with Git history preserved. Do not predict that pressure by pre-creating files or empty siblings.

## Semantic Contract

Use [`_TEMPLATE.md`](_TEMPLATE.md) only after materialization is admitted. A useful Plan lets an implementer and reviewer reconstruct:

- the concrete problem, scope, current owner/flow/state, and desired outcome;
- current user-confirmed decisions with compact `Decision Context` when authority matters;
- observable requirements and acceptance;
- Current -> Target design, semantic impact, activated risks, recovery, and proof when evidence makes them relevant;
- executable `Files / Consumes / Produces / Acceptance` interfaces only after decomposition is stable;
- genuine unresolved decisions, with resolved questions removed.

Headings are not the completeness unit. Add only warranted sections in a natural order. Alternatives appear only when genuinely different viable shapes or a load-bearing rejection exists. A created file, filled section list, long transcript, placeholder Task Breakdown, or successful command is not Plan readiness.

## Lifecycle

```text
no artifact -> draft -> executing -> done -> final reconciliation -> frozen
                         |
                         -> abandoned -> frozen, no distillation
```

- **draft**: active design. Confirmed decisions are superseded explicitly, not silently rewritten.
- **executing**: implementation is consuming the current mainline. At handoff, distill stable business-bearing meaning into its routed owner, initialize truthful `distilled_to:`, and pass the Plan path plus relevant decisions to Task Execution. Purely technical Plans create no business leaf.
- **done**: delivery landed. Before changing status, reconcile later Decision Deltas, implementation evidence, activated destinations, and final `distilled_to:` targets.
- **abandoned**: explain why in one short section. Do not distill an unchosen direction.

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
---
```

Omit `distilled_to` when abandoned or when final reconciliation proves no conclusion is load-bearing; state that judgment in the Plan.

## When A Plan Closes

Move only surviving, future-binding meaning into active owners:

| Conclusion | Active owner |
|---|---|
| Stable user-confirmed business type/flow/state/boundary/invariant/reason | routed `references/business/<domain>.md` as desired business truth with Plan provenance |
| Future task constraint | the routed `rules/` owner |
| Costly repeatable failed approach | `references/gotchas.md` or routed domain pitfall owner |
| Pure history and rationale for this delivery | frozen Plan only |

One destination owns the complete definition. Other audiences may keep only the smallest action hook and owner link. Do not copy the same conclusion into business, rule, Gotcha, and Plan merely for visibility.
