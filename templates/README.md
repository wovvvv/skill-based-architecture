# templates/ — Canonical Materializer Sources

This directory is the upstream source catalog, not a universal downstream file
tree. Quick Start first inventories the target repository, then
`scripts/scaffold-downstream.sh` selects the smallest complete carriers and
copies or renders only the owners admitted by that evidence. A generated
project never needs to understand SBA tiers, profiles, capability packs, or
install modes.

The files here remain canonical sources for independently materialized owners.
They are intentionally richer than the result a small project receives. The
fitted result, not equality with this directory, is the downstream contract.

`SKILL.md` carrier sources intentionally use the `.template` suffix. Codex-style
skill loaders may recursively scan installed skills for `SKILL.md`; leaving raw
template files with placeholder frontmatter under `templates/` makes them look
like broken real skills. The materializer selects one carrier, renders it as
the downstream `SKILL.md`, and leaves unselected sources upstream.

## Layout

```
templates/
├── skill/                    → canonical owners selected into skills/{{NAME}}/
│   ├── SKILL.single.md.template   (direct Single-file carrier)
│   ├── SKILL.routed.md.template   (routed Folder-light/broad carrier)
│   ├── SKILL.md.template          (complete broad/full carrier when admitted)
│   ├── routing.yaml               (only when routing has an independent owner)
│   ├── domain-routing.yaml        (only with a real business owner)
│   ├── rules/                     (selected rule owners)
│   ├── workflows/                 (selected procedures/lifecycle owners)
│   ├── references/                (selected current-code/gotcha owners)
│   ├── protocol-blocks/            (only when a selected workflow links them)
│   └── scripts/                   (fitted checks and maintenance owners)
│       ├── smoke-test.sh                (fully automated structural + routing checks)
│       ├── sync-routing.sh              (generate/check routing action hook + shell bootstraps from routing.yaml)
│       ├── sync-vendor.sh               (mechanical vendor-file sync from an upstream clone; base = synced_sha)
│       ├── upstream-status.sh           (am-I-behind reporter + wrong-checkout guard; reads .upstream-sync)
│       ├── route-health.sh              (static routing-quality lint; advisory)
│       ├── audit-orphans.sh             (content-tier files with zero inbound links)
│       ├── route-reachability.sh        (task-route activation, including workflows)
│       └── check-version-conformance.sh (downstream contract: required/forbidden phrases + files)
├── shells/                   → selected repo-root entry/registration surfaces
│   ├── AGENTS.md / CLAUDE.md / CODEX.md / GEMINI.md
│   ├── .cursor/rules/workflow.mdc
│   └── .cursor/skills/{{NAME}}/SKILL.md.template
├── hooks/                    → optional hooks only for a harness that adopts them
│   ├── session-start              (bash, per-harness JSON branching — re-inject one router)
│   ├── workflow-state             (bash, UserPromptSubmit — inject one active workflow hint)
│   ├── hooks.json                 (Claude Code settings fragment — SessionStart + UserPromptSubmit)
│   ├── hooks-cursor.json          (Cursor config — same as above, per-harness wiring)
│   ├── README.md                  (rollout / tuning / false-positive mitigations, per-hook)
│   └── SECURITY.md                (trust boundary: what may vs must not be written to hook-read files)
```

## Rendering and migration work

Two kinds — each with a different "fill" mechanism:

| Marker | Meaning | Filled by |
|---|---|---|
| `{{NAME}}`, `{{SUMMARY}}` | Materializer metadata substitution | Rendered while staging the admitted owner |
| `<!-- FILL: … -->` | Canonical-source author guidance | Replace with project evidence before that owner is shipped |
| `<!-- OPTIONAL: … -->` | Advanced or organically-grown content | Materialize only after a real route/owner pressure appears |

The materializer rejects unresolved project-facing markers in its staged result.
It does not claim that generic text is the target project's semantic content:
the Agent must still fill the admitted owners, merge preserved entries, and
produce session-scoped source-to-destination migration evidence. Users should
not have to interpret markers or choose a package composition.

## Size Review Budgets

Line counts trigger review, not automatic splitting. The SKILL dual budget and structural checks are machine-enforced where stated; other rows require the independent-load-reason judgment in `workflows/maintain-docs.md`.

| Path | Budget | Enforcement |
|---|---|---|
| `shells/*` | ≤ 60 lines | Thin shells must stay thin; > 60 = content leaking in. Routed shells include the generated Always Read + `routing.yaml` bootstrap; direct shells point to the sole procedure. Both use the evidence-first request-clarity judgment when that block is admitted (see `protocol-blocks/ambiguous-request-gate.md`) |
| `skill/routing.yaml` | ≤ 120 lines | Single source of truth for generated Always Read, first-workflow routes, trigger examples, and thin-shell bootstraps; project-specific after fill |
| `skill/rules/project-rules.md`, `skill/rules/coding-standards.md` | ≤ 20 lines for starter carriers | Generated only when a folder/broad result needs an independent rule owner; fill from target evidence |
| `skill/rules/change-discipline.md` | ≤ 40 lines | Canonical pre-mutation semantic and mutation boundary; loaded by modifying workflows, never Always Read |
| `hooks/session-start`, `hooks/workflow-state` | ≤ 150 lines each | Optional hook scripts. Keep per-harness branching in-script; see `hooks/README.md` |
| `hooks/README.md` | ≤ 150 lines | Per-hook rollout guidance; allowed larger because it documents optional installs + tuning |
| `skill/workflows/task-execution.md`, `profile-project.md`, `plan-feature.md`, `plan-large.md`, `update-upstream.md`, `fix-bug.md`, `change-managed.md`, `edit-templates.md`, `subagent-auxiliary.md`, `subagent-driven.md`, `subagent-orchestration.md` | ≤ 100 lines | Cross-cutting execution plus task-specific/conditionally selected workflows stay lean |
| `skill/workflows/profile-business-model.md.example` | ≤ 100 lines | Optional business-model workflow; stays inactive until a downstream renames it and adds a real route |
| `skill/workflows/update-rules.md`, `maintain-docs.md` | ≤ 250 lines | Protocol-heavy workflows allowed more room |
| `skill/protocol-blocks/*` | ≤ 40 lines each | One idea per block |
| `skill/SKILL*.md.template` | dual budget: description ≤ 25 lines + body ≤ 90 lines | Direct, routed, and complete carriers each stay within the cap; only the selected carrier is materialized. |
| `skill/scripts/smoke-test.sh` | ≤ 980 lines | Structural test harness; optional overlay line accounting is isolated from the task core; the next substantial concern should replace/simplify existing checks |
| `skill/scripts/sync-routing.sh` | ≤ 520 lines | Dependency-free generator/checker; optional domain-manifest parsing and generic cross-owner path validation stay internal so domain-free projects gain no extra files or setup |
| `skill/scripts/sync-vendor.sh` | ≤ 160 lines | Mechanical vendor sync; base check via upstream git history — no new state files |
| `skill/sync-manifest.yaml` | ≤ 40 lines | Vendor-class file list only; project-owned/generated/runtime-data paths never belong here |
| `skill/scripts/audit-orphans.sh`, `route-reachability.sh` | ≤ 120 lines each | Recursive zero-inbound and task-activation checks, including nested `references/business/`; heuristic, run before deleting flagged files |
| `skill/references/gotchas.md` | ≤ 25 lines (seed) | MUST stay near-empty — content grows post-deployment |
| `skill/references/behavior-failures.md` | ≤ 25 lines (seed) | MUST stay near-empty — cross-cutting Agent contract failures logged via AAR |

Anything over budget needs either splitting or rejection. See `ANTI-TEMPLATES.md`.

## Growth Health

Review these signals during major template or skill updates. A threshold does
not force an automatic refactor; it forces an explicit decision.

| Signal | Review when | Default action |
|---|---:|---|
| `SKILL.md` description lines | > 25 | Split intent clusters or shorten activate-when clause |
| `SKILL.md` body lines | > 90 | Move detail to routed files or downgrade scope |
| Always Read files | > 3 | Demote domain-specific files to task routes |
| Concrete routes | > 10 | Group routes, merge low-frequency tasks, or evaluate multi-skill split |
| `references/` orphans | > 0 | Add an activation path or delete the reference |
| Workflow line count | > budget row above | Split only if sections are independently navigable |
| Check script line count | > budget row above | Extract checks or reject new mechanism weight |
| High-risk route scenarios | 0 covered | Add contract/scenario tests before trusting behavior |

Executable-skill pressure is a separate signal: if project evidence shows
external APIs/CLIs, remote side effects, repeated script logic, local config, or
stable output contracts, read `references/executable-skill-architecture.md`
before expanding the base template.

## The "Would Two Real Projects Disagree?" Test

Before adding anything to this directory, answer:

> "A Go backend microservice and a React animation site both pull this template. Would they both agree on this content?"

- **Yes** → it's structural protocol; may go in `templates/`.
- **No / probably not** → it's project-specific; move to `<!-- FILL: -->` comment or `examples/` instead.

No exceptions. If this test is hand-waved, `templates/` slides into opinionated defaults and downstream projects start looking identical.

New reusable mechanisms must also pass the [Mechanism Admission Gate](ANTI-TEMPLATES.md#mechanism-admission-gate): reduce repeated maintenance or prevent a verified recurring failure; otherwise keep them out of `templates/` as mechanisms.

## Anti-Drift Checks

Run these when templates change:

1. **Placeholder audit** — `grep -r '{{' templates/` lists every placeholder; it must match the Quick Start substitution set.
2. **Loader-safety audit** — `find templates -name 'SKILL.md'` returns no rows; template sources stay `SKILL.md.template` until materialized.
3. **FILL audit** — `grep -r 'FILL:' templates/` returns only required migration-work markers.
4. **Routing audit** — run `sync-routing.sh --check` on a routed result and instantiate direct, folder-light, and broad samples through the canonical materializer.
5. **Integrity audit** — run `audit-orphans.sh` for link reachability and `route-reachability.sh` for real task activation; two-root skills pass the namespace/routing arguments documented by those scripts.
6. **Homogeneity spot-check** — compare two unlike toy projects; skeleton may match, project rules/routes must not.
7. **Upstream check suite** — run `bash scripts/check-all.sh`; it instantiates a temporary downstream and enforces the upstream change-note contract.
