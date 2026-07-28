# Plan Decision Records and Archive

Plans are active decision records while `draft` or `executing`, then frozen snapshots after `done` or `abandoned`. The active Plan folder is the authority for its user-confirmed brainstorm and implementation mainline; frozen Plans are historical artifacts, not default task knowledge.

## Why archive plans at all

Plans contain things that don't naturally fit into `rules/` or `references/`: the full context as it stood at the time, dead-end branches, calendar pressure, prior assumptions, who-said-what. Most of that has no ongoing value — but occasionally someone needs to ask "wait, why did we even consider doing it that way back then?", and the surviving rule alone is not enough.

The deal: archive is cheap (one file, no maintenance burden), so we keep it. During delivery, the source Plan is explicitly handed to its implementation/review tasks; outside that lineage it is **not default active knowledge**:
- It is **not** linked from `SKILL.md` routing for unrelated future tasks.
- It is required only when the current task modifies that Plan or implements/reviews its confirmed mainline.
- It is **not** maintained once frozen.

If something in here turns out to be load-bearing — i.e. an agent making a future change would do the wrong thing without it — that fragment must be **lifted into the live structure** (see "When a plan closes" below). Keeping it alive only in a plan archive is the same as losing it.

## File format

Plans take **either** of two shapes — pick by whether one file can hold the work:

### Simple plan — one file `YYYY-MM-DD-slug.md`

Default. Use when the work is a focused refactor or small feature: one or two files touched, no separate research material that wants its own file.

```yaml
---
date: 2026-05-12
status: done             # draft | executing | done | abandoned
distilled_to:            # initialize at implementation handoff when applicable; required/finally reconciled when done
  - SKILL.md § Common Pitfalls #N
  - rules/<topic>.md
  - references/gotchas.md
# omit distilled_to entirely if abandoned, or if you genuinely judged no content was load-bearing
---
```

Body follows the **canonical Plan Skeleton** — defined once in [`../../templates/skill/workflows/plan-feature.md`](../../templates/skill/workflows/plan-feature.md), mirrored by [`_TEMPLATE.md`](_TEMPLATE.md): Context → Problem → Decision Context (when user-confirmed decisions exist) → Options Considered → Chosen Approach → Requirements & Acceptance Criteria → Out of Scope → Task Breakdown (omit if single-task) → Open Questions.

### Complex plan — directory `YYYY-MM-DD-slug/`

Use when one file genuinely cannot hold the work (extensive research notes, long evidence quotes, multiple parallel investigations). Required structure:

```text
docs/plans/YYYY-MM-DD-slug/
└── prd.md          ← frontmatter goes here; everything else is your call
```

That is the entire required structure. Add whatever else this specific task needs — a decisions log, research notes, evidence snippets, a checklist — using filenames that fit the work, **not** a canonical schema. If `prd.md` is the only file that ever exists in the directory, the plan is correct and complete.

Resist pre-creating empty files. Add a sibling only when `prd.md` itself starts to bloat with content that wants to live separately. **Don't promote past behavior into a contract**: if past plans happened to use `decisions.md` or `research/`, that does not mean the next plan owes them.

`prd.md`'s *internal* sections follow the canonical Plan Skeleton (above); that shapes the document, not the directory. The "no canonical schema" rule is about **files** in the directory — the section list inside `prd.md` is canonical, the set of sibling files is not.

## Lifecycle

```
draft  →  executing  →  done       →  final reconciliation  →  archive frozen
          │
          └─ design confirmed → distill business mainline before implementation
                    ↘
                      abandoned    →  archive frozen, no distillation
```

- **draft** — being written; can change freely, but confirmed decisions are appended/superseded rather than silently overwritten.
- **executing** — work in progress. At design-to-implementation handoff, first distill business-bearing stable user-confirmed meaning into the routed owner, initialize `distilled_to:` with actual targets, and pass the Plan path/mainline to implementation. Purely technical Plans create no business leaf. Later Plan changes must replay and reconcile those records before affected code resumes.
- **done** — work landed. **Before flipping to done, reconcile later Decision Deltas, implementation evidence, all other load-bearing content, and truthful `distilled_to:` targets.** This is the final closure step, not a follow-up.
- **abandoned** — explicitly decided not to do this. Archive with a one-line `## Why Abandoned` section at the top of the body. Do **not** distill — the absence of a decision is itself the record.

Once a file moves out of `draft` / `executing`, treat it as read-only.

## When a plan closes — where load-bearing content goes

Sort each surviving conclusion (wherever in the plan directory it landed — `prd.md`, a sibling file, or a simple plan's body) into an active destination or provenance-only archive. There is no generic fourth directory called "decisions" — the Plan keeps the decision evidence while routed live files activate its stable meaning.

| Conclusion shape | Lives in | Why this location |
|---|---|---|
| User-confirmed stable business type/flow/state/boundary/invariant/reason | Routed `references/business/<domain>.md` with Requirement Provenance | The Plan retains question/answer evidence; the business leaf activates desired truth for later Plan, code, fix, review, and closure work while current implementation fact remains separate |
| "Future work must / must not do X" (a constraint on future tasks) | `rules/<topic>.md` (downstream skills) | SKILL.md routing pulls `rules/` onto every relevant task path; the constraint is read automatically when it matters |
| "We tried Y; here is why Y is wrong" (anti-pattern, footgun, rejected alternative) | `references/gotchas.md` or SKILL.md § Common Pitfalls | Already on task paths; covered by `templates/skill/workflows/maintain-docs.md` Tier-0/1/2 stale-check; the "why rejected" framing is exactly what gotchas.md exists for |
| Neither — purely "what happened, why we did it then" | Stays in the plan archive only; `distilled_to:` is omitted | Pure provenance with no future binding — archiving alone is correct |

If a conclusion fits multiple buckets (e.g. both a rule and a pitfall), it goes in both places — these are different audiences, not duplicates.

## Discoverability

Frozen Plans are **not** linked from `SKILL.md` or `REFERENCE.md` routing. An active Plan is reached through explicit implementation/review handoff and its Requirement Provenance links. Frozen Plans remain reachable from:

1. `git log docs/plans/` if you want to scan history directly.
2. `ls docs/plans/` — filename includes date, so chronological order is free.
3. Soft references in `rules/` / `references/gotchas.md` entries (e.g. "see `docs/plans/2026-05-12-thin-shells-generator.md` for rejected alternatives") when the maintainer wanted to leave breadcrumbs.

That is intentional: routing should pull active knowledge, not archaeology.
