# ANTI-TEMPLATES — Things We Intentionally Do NOT Pre-Build

This file exists so future maintainers (including agents) have to pass through a "why was this rejected?" gate before adding content to `templates/`. Over time the temptation is to put "a reasonable default" here. This list is the counter-pressure.

## Mechanism Admission Gate

Before adding a new workflow, script, hook, protocol block, generated file, or other reusable mechanism to `templates/`, ask:

> Does this reduce repeated maintenance or prevent a verified recurring failure, or does it only make the scaffold feel more complete?

Add the mechanism only if it replaces at least two repeated maintenance points, or fixes a real failure mode that has already happened or is highly likely across harnesses. Otherwise keep it as a reference note, checklist item, example, or `<!-- FILL: -->` prompt.

## Borrowed-Pattern Acceptance Test

When the candidate is **borrowed from an external skill, project, or benchmark** (an admired repo, a "how do they do it" comparison), the gate above is necessary but not sufficient — it tests *cost*, not whether the borrowed pattern is *real*. Run these four gates first; the pattern must pass **all four**, then still clear the cost gate above.

1. **Recurrence** — the pattern shows up in more than one serious source, not just the one project you are copying. One repo doing it is a data point, not a pattern.
2. **Generativity** — it guides *new* cases you have not seen yet, not just re-explains the example you copied. A rule that only fits the source's exact situation is a souvenir, not a pattern.
3. **Distinctiveness** — it is more specific than generic good advice. This is our existing **"would two real projects disagree?"** test: if every reasonable project would phrase it the same bland way, it carries no information.
4. **Boundary** — the pattern itself names where it does *not* apply, or what it costs. A pattern with no stated boundary gets over-applied.

**Cost rule:** a borrow is worth it only if it raises skill quality faster than it raises context cost. If the imported idea makes the skill heavier without making it more reliable, drop it.

**Worked example — this test itself.** Borrowed from an external meta-skill (`yao-meta-skill`, its `reference-scan.md` + `pattern-extraction-doctrine.md`) during a 2026-06-23 comparison. Applied to itself: *recurrence* — appears across that project's reference-scan and pattern-extraction docs and is standard design practice ✓; *generativity* — it guides every future "should we borrow X?" call, not just the yao comparison ✓; *distinctiveness* — it adds three gates our lone "two projects disagree?" test lacked ✓; *boundary* — scoped to borrowed-from-external candidates only, and explicitly defers to the cost gate ✓. The recurrence evidence in *our own* history is that borrow-pressure from admired projects keeps recurring (Karpathy, planning-with-files, yao-meta-skill) — which is why this gate earns a place here instead of in `references/`.

## Rejected

### Default lint/format rules
- **Why rejected:** language- and project-specific. A Go project's lint set has nothing in common with a React project's. Pre-filling this makes downstream skills lie about what they actually enforce.
- **Where it should go:** each project's `rules/coding-standards.md`, filled via `<!-- FILL: -->`.

### Default commit message format
- **Why rejected:** Conventional Commits is *not* universal. Some teams use Gitmoji, some use plain English, some have custom prefixes for ticket IDs. Predefining it tells downstream "this is how we commit" when the upstream doesn't know.
- **Where it should go:** project-specific `rules/` file or `workflows/commit.md` if the team has one.

### Predefined Common Pitfalls entries
- **Why rejected:** pitfalls come from real debugging. Pre-filling them with generic examples ("don't forget to handle null") is noise — the whole point of the gotchas file is that every entry was paid for in wasted hours.
- **Where it should go:** `references/gotchas.md` grows organically via AAR. Template ships this file **empty**.

### Default directory structure ("src/, test/, docs/")
- **Why rejected:** every language and framework has its own conventions. A Rust project has `src/` but a Next.js project has `app/`, a Go project has `cmd/`, a Python project has the package at root. Predefining is wrong for the majority.
- **Where it should go:** `rules/project-rules.md`, filled once the project's actual layout is known.

### Default test framework choice / test coverage threshold
- **Why rejected:** opinionated. Some projects use `pytest`, some use `unittest`, some are untested legacy. The 80% coverage number in common rules is itself a soft default — the template should not harden it.
- **Where it should go:** `rules/coding-standards.md` or a `rules/testing-rules.md` written by the project.

### Opt-in discipline documents in the default scaffold
- **Why rejected:** copying a Tests-as-Spec, permission/operation model, or similar opt-in doctrine into every downstream makes stored content look adopted even when no route, baseline, or project table activates it.
- **Where it should go:** an upstream adoption guide under `references/`; materialize a project file only after real pressure, then add its task path and concrete project decisions in the same change.

### Pre-populated generic task routes or duplicated route rows in SKILL.md
- **Why rejected:** task routing must reflect *this project's* actual recurring work, and exact route data needs one owner. A generic list ("Add feature", "Fix bug", "Refactor") teaches agents to route generically; copying real rows into `SKILL.md` creates a second catalog.
- **Where it should go:** `routing.yaml` with project-specific entries, then generate only the `SKILL.md` Common Tasks action hook and thin-shell blocks via `scripts/sync-routing.sh`.

### Default product-knowledge taxonomy or empty business-model placeholders
- **Why rejected:** business-bearing projects disagree on module boundaries and on which macro facts are stable. Pre-creating product-context/use-case/domain/state/sequence trees, an empty `references/business/`, empty module files, or a placeholder index creates false completeness and invites volatile details to fill the space.
- **Where it should go:** adopt [`references/business-global-model.md`](../references/business-global-model.md) only after a real module passes the admission test. Start with one `references/business/<module>.md`; split or add an index only when independent task reads prove the need.

### Workflow-level child skills by default
- **Why rejected:** `fix-bug`, `add-feature`, `review`, and `update-docs` are usually procedures inside one project skill, not separate activation domains. Pre-building them as child skills turns one project rule system into competing descriptions that all share the same Always Read files.
- **Where it should go:** `workflows/*.md` under the primary project skill. Split into multiple skills only when trigger language and rules genuinely diverge, such as app vs deploy vs data-migration.

### Executable skill directories by default
- **Why rejected:** `scripts/`, `tools/`, `capability/`, and `conf/.defaults/` are correct only for operation-heavy skills that call APIs/CLIs, run scripts, manage local config, or perform side effects. Pre-building them tells ordinary rule-only projects to maintain unused execution surfaces.
- **Where it should go:** `references/executable-skill-architecture.md` and project-specific downstream skills that pass the executable-pressure test in `workflows/profile-project.md`.

### Scenario test harness by default
- **Why rejected:** scenario harnesses depend on the agent runtime, isolation model, mock strategy, and cost tolerance. A default harness would either bind the scaffold to one tool or become too vague to protect behavior.
- **Where it should go:** `references/scenario-testing.md` as a recipe; downstream projects add their own harness only for high-risk routes.

### Trigger phrases in the `description` field
- **Why rejected:** these are the single highest-value piece of project knowledge for skill activation, and they must come from real user language. A generic "This skill should be used when the user asks to 'do X'" trains the agent to never match.
- **Language rule:** if users ask in Chinese or another non-English language, the quoted phrases must include that language. English-only examples are not neutral defaults for multilingual teams.
- **Where it should go:** `<!-- FILL: -->` comment forcing the author to stop and think about what their users actually say.

### Concrete subagent task specs (worked dispatch/return envelopes)
- **Why rejected:** the `subagent-driven.md` workflow and `subagent-contract.md` block ship the envelope shape; the actual Task Ref, Role, scope, and evidence are entirely task-specific. Shipping a worked example tempts downstream agents to copy its content instead of proving provenance and acceptance for *this* task.
- **Where it should go:** each dispatch writes its own contract inline. The protocol-block is a fill-in form, not a sample.

### Subagent type registries / harness-specific dispatch code
- **Why rejected:** Claude Code's `Task` tool, Cursor's agent modes, and other harnesses have incompatible subagent primitives. Predefining a "use this subagent type for X" mapping would lie to every harness except one.
- **Where it should go:** nowhere in `templates/`. Harness-specific runtime decisions belong in each project's own tooling, outside the skill contract.

### Plugin marketplace manifests (`.claude-plugin/marketplace.json`)
- **Why rejected:** out of scope for the current plan. Adding packaging metadata turns `templates/` into a distribution mechanism and invites a different class of drift (version pinning, plugin schemas). Revisit as a separate feature.

## No Universal Agent-Behavior Aggregation

A pre-filled catch-all `rules/agent-behavior.md` is intentionally rejected. It mixes concerns selected at different times, duplicates workflow owners, and charges every downstream task for behavior that only mutation, Managed execution, delegation, or Closure needs.

Put each reusable contract at its first action-changing boundary:

- request ambiguity and implementation-fact closure -> `protocol-blocks/ambiguous-request-gate.md`
- mutation safety and semantic repair depth -> `rules/change-discipline.md`
- evidence expansion, task state, and progress -> `workflows/task-execution.md`
- delegation admission and orchestration -> the `workflows/subagent-*.md` owners
- recording and completion -> `workflows/update-rules.md` and `workflows/task-closure.md`

When a real failure exposes a missing rule, update the active owner that would have changed the next action. `references/behavior-failures.md` may preserve the incident evidence, but it is not a reason to recreate a universal runtime file or a file-specific edit hook.

## Rules for Adding New Rejections

When you decide NOT to add something to `templates/`, record it here with:

1. **What** was considered
2. **Why rejected** (concrete reason, not "felt wrong")
3. **Where it should go instead**

This list should grow over time. A short list means review was lazy, not that the boundary is well-understood.

## Homogeneity Drift Log

Record the result of each "two different projects" spot-check here. Format:

```
YYYY-MM-DD — Go CLI (proj-a) vs Next.js site (proj-b)
  ✅ Skeleton: identical (shells, hooks, protocol-blocks) — expected
  ⚠️  rules/coding-standards.md: 3 lines identical → those 3 lines might be too generic, review
  ✅ gotchas.md: empty in both — correct
  ✅ routing.yaml task routes: fully different — correct
```

<!-- FILL: add drift log entries as they are run. The log is the main evidence that B.5/B.6 is working. -->
