# Reference — Layout & Structure

## Evidence-selected layouts

There is no universal downstream tree. A real project may receive one of these
carriers, or evolve between them through ordinary maintenance:

```text
# direct / Single-file
project/skills/<name>/SKILL.md

# folder-light (only when rules or one recurring procedure need an owner)
project/skills/<name>/{SKILL.md,rules/,workflows/<procedure>.md}

# broad / routed (only when independent selection and lifecycle/check pressure exists)
project/skills/<name>/{SKILL.md,routing.yaml,rules/,workflows/,references/,scripts/}
project/<detected-entry-or-registration-surfaces>
```

`AGENTS.md`, `CLAUDE.md`, `CODEX.md`, `GEMINI.md`, Cursor registration, and
optional hooks are evidence-selected entry surfaces, not a mandatory set. The
materializer preserves existing entries and adds only detected/declared readers.
At the broad shape, splitting by **abstraction (骨架/肉)** remains useful:
abstract design theory → `architecture/`, **code maps** (module tree, dir
layout, source index) → `references/`, house style → `conventions/`, and
independently routed landmines → `gotchas/`. Add a selecting `gotchas/index.md`
only after real multi-file pressure; methodology stays in `rules/`. The
skeleton/flesh judgement test + split mechanics: [skeleton-flesh-split.md](skeleton-flesh-split.md).
For growth/topology decisions, see [progressive-rigor.md](progressive-rigor.md).
For where this skill sits in the broader agent stack, see the "Positioning"
section at the bottom of this file.

## SKILL.md Template

```md
---
name: <project-name>
description: >
  This skill should be used when the user asks to "<trigger phrase 1 in real user language>",
  "<trigger phrase 2>", or "<trigger phrase 3>".
  Activate when <condition 1> or <condition 2>.
primary: true
---

# <Project Name>

One-line summary.

## Always Read

Default to empty. Add a file only when every real task needs it before its first workflow starts; domain-specific and lifecycle-specific knowledge does not qualify.

Modifying workflows load `rules/change-discipline.md` immediately before the first mutation. That owner then links `rules/project-rules.md` and `rules/coding-standards.md`, which are read only when the planned mutation reaches their scope.

## Common Tasks

This section is only an action hook: read `routing.yaml`, match exactly one route by labels, trigger examples, and intent, fall back to `other`, then follow only that route's workflow. Exact route ids, labels, triggers, workflow paths, fallback, notes, and route metadata live only in `routing.yaml`; do not repeat rows here.

## Known Gotchas

Brief, scannable list of the most costly pitfalls. Full details in `references/gotchas.md`.

- Gotcha 1: one-line summary → see `references/gotchas.md#section`
- Gotcha 2: one-line summary → see `references/<topic>.md#section`

## Rule Priority
1. `skills/<name>/SKILL.md`
2. `skills/<name>/rules/`
3. `skills/<name>/workflows/`
4. `skills/<name>/references/`
5. Root `README.md`
6. `.cursor/rules/*.mdc` / `.claude/` (compatibility only)

## Project Boundaries
- Boundary 1
- Boundary 2
```

### Single-file and Common Tasks audit

Progressive disclosure is a loading rule, not a mandate to route every request
through a complex execution protocol. A **Single-file** skill is deliberately
allowed to have no `routing.yaml`, no `workflows/` directory, and no Task
Execution/Closure machinery when it has fewer than three topics, no recurring
procedure, and no cross-session lesson-capture need. Its `SKILL.md` may keep a
small, direct Common Tasks list, and an ordinary task should follow the rule it
needs with one direct check.

Once a skill crosses a real upgrade trigger, the Folder-light/Full form may put
task selection in `routing.yaml` and turn `Common Tasks` into the generated
action hook shown above. That hook must still select only the first relevant
workflow; it must not preload every rule or force a Simple task to read
`task-execution.md`, a domain manifest, or a Closure protocol. The selected
workflow owns its conditional reads, and `task-execution.md` retains a direct
Simple fast path while reserving Anchor/Plan ceremony for Managed or Design
work.

Audit both sides before changing tiers: name the concrete pressure that made a
new file or route independently necessary, and prove that delaying a file until
its evidence/phase boundary changes the next action. If no such pressure exists,
keep the content in the smallest truthful carrier. “Progressive disclosure”
does not justify deleting a useful direct task rule, replacing its meaning with a
generic fallback, or adding a workflow merely to make the tree look complete.

### Description as Trigger Condition

The `description` field in frontmatter is **not** a passive summary — it is what the Agent uses at runtime to decide whether to activate the skill. It should answer "is this request in this skill's domain?", not "which workflow should run?" A vague description means the skill silently never fires; an overstuffed description becomes a brittle keyword list that competes with `SKILL.md` routing.

**Bad** (too vague — Agent can't match it):
```yaml
description: Helps with API testing
```

**Good** (domain / intent-cluster phrases + activation conditions):
```yaml
description: >
  This skill should be used when the user asks to work on this repository, such as
  "这个接口报错了", "这里返回不对", "测试挂了", "fix this failing test",
  or "debug this error".
  Activate when the task requires this repo's code, rules, workflows,
  known gotchas, or validation commands.
```

Guidelines:
- **Enough length** — aim for ≥ 20 English-style words or ≥ 40 CJK characters; short descriptions fail to activate reliably
- **Use the user's actual language(s)** — if users ask in Chinese, include Chinese quoted phrases alongside English; do not rely on translation / semantic similarity alone
- **Include quoted trigger phrases** — exact phrases the user would say for the skill's domain / intent cluster
- **Third-person format** — "This skill should be used when…" not "I help with…"
- **Include activation conditions** — describe the context, not just the action
- **Do not enumerate workflows** — `fix-bug`, `release`, `maintain-docs`, etc. belong in `routing.yaml` task routes unless they identify a separate domain skill
- **Name near-miss anti-triggers** — list three similar user requests that should NOT activate this skill. If you cannot name them, the description is probably too broad; move workflow verbs into `routing.yaml` or split the domain.

#### Trap: a step-summary in the description suppresses reading the body

The guidelines above prevent a *vague* or *keyword-stuffed* description. The opposite failure is a description that is too **procedural**. The `description` is always-loaded (injected for matching); the body loads on demand. An agent stops reading once it has "enough to act" — so a description that summarizes *how* the skill works becomes enough to act on, and the body is never opened. The agent then runs a lossy version of the procedure.

Evidence (superpowers eval): a description reading `...dispatches subagent per task with code review between tasks` made the agent run **one** review though the body specified **two** (spec-compliance then code-quality); cutting it back to `Use when executing implementation plans with independent tasks` made the agent read the body and run both.

This is distinct from keyword-stuffing: keyword-stuffing leaks *which workflows exist* (competes with routing); a step-summary leaks *how a workflow runs* (suppresses the body). A description can avoid the first and still fail the second.

**Bad** (step-summary — agent acts on it, skips the workflow):
```yaml
description: Use when migrating rules — consolidate scattered docs into one skill folder and generate thin shells
```

**Good** (trigger only — agent must open the workflow to learn the steps):
```yaml
description: >
  This skill should be used when the user asks to "把规则迁移到 skills 目录",
  "整理项目规则", or "migrate project rules to skills".
```

**Check — applies at every summary→detail link, not just the description:** does the description or any `routing.yaml` label/trigger/metadata field carry HOW an agent could execute without opening the body or workflow file? If yes, the agent will do exactly that and skip the detail — strip it to WHEN + which-file; the steps live only in the body/workflow. (Same shortcut as Pitfall #8 "I already know the rules", generalized: any layer that leaks enough HOW gets the layer below it skipped.)

Re-read the `description` block aloud after changing frontmatter. Listen for over-broad scope, workflow keyword stuffing, near-misses you cannot exclude, and (in multi-skill repos) duplicate trigger phrases between skills. No script substitutes for this judgment.

The template above uses evidence-separated stages:

- **Always Read** — empty by default; add only a file every real task needs before workflow selection
- **Common Tasks** — one generated action hook points to canonical `routing.yaml`; it contains no route rows or knowledge bundle
- **Domain selection** — optional `domain-routing.yaml`, evaluated by the workflow only after an explicit business-rule request, known owner, or decision-relevant evidence requires business semantics

**Keep routing in sync:** When task-to-workflow selection or Always Read changes, update `routing.yaml`. When a business owner is first added or changed, update `domain-routing.yaml` atomically. Run `scripts/sync-routing.sh` for both cases; it validates the optional domain manifest without copying it into startup summaries.

**Task-route sizing:** Keep `routing.yaml` to 8–10 task procedures maximum. Beyond that, route selection itself becomes noisy. Merge low-frequency procedures into a real fallback workflow; do not encode business domains into the task table.

**"Other / unlisted task" matching:** The fallback entry still selects one real workflow, normally the generic task-execution workflow. It must not hide executable search instructions inside the `workflow` field.

This keeps per-task reading to the minimum set needed, rather than loading all rules for every task.

## Relation to Official Skill Template / Spec

Anthropic's public [`skills` repository](https://github.com/anthropics/skills) defines the **minimal** skill shape: a folder with a `SKILL.md`, plus frontmatter where `name` identifies the skill and `description` explains what it does and when to use it.

This meta-skill does **not** replace that minimum. It starts one level later:

- Use the official-style minimal single `SKILL.md` when the skill is still small, self-contained, and not scattered across multiple entry files.
- Upgrade to `skills/<name>/` with `rules/`, `workflows/`, and `references/` only when the skill starts to sprawl: long files, duplicated entries, or recurring knowledge that needs active maintenance.

Rule of thumb:

- Official template answers: "How do I create a valid skill?"
- `skill-based-architecture` answers: "How do I keep a growing project skill precise, navigable, and maintainable?"

Do not copy the full official spec into project docs. Link to the canonical source when helpful, and keep local docs focused on project structure and task routing.

## Positioning in the Agent Stack

Where this skill sits, and what it does **not** cover. Read this when an agent feels unstable and you need to decide whether the fix belongs here, in prompt phrasing, or in a different harness layer.

### Three layers of agent reliability

Agent reliability lives on three layers. This skill is **not** a silver bullet — it acts on the second and a slice of the third.

| Layer | Question it answers | What this skill provides |
|---|---|---|
| **Prompt Engineering** | How do I phrase the task so the model understands? | Indirect — via the `description` frontmatter as a trigger condition, and via the writing style guidance for rules / workflows |
| **Context Engineering** | How do I deliver the right information to the model? | **Primary focus** — empty-by-default Always Read + canonical manifest routing, thin-shell bootstraps, registration entry, progressive disclosure |
| **Harness Engineering** | How does the surrounding system keep execution stable when the model alone is not enough? | **Partial** — Session Discipline + Rationalizations Table + SessionStart hook = a minimal harness for *context re-injection across long sessions* |

### The Four-Primitive Audit

When an agent feels unstable, the root cause is rarely the model. Ask these four questions before blaming the prompt:

1. **State** — Is there an explicit marker of what step we are on, or does the agent re-derive it each turn?
2. **Validation** — Is there a check at each critical node, or do we only verify at the end?
3. **Orchestration** — Is there a task plan with checkpoints, or does every failure restart from step 1?
4. **Recovery** — Is there a resume path after a failed step, or does the agent always re-run everything?

Three "no"s = this is a harness problem, not a model problem. Re-tuning the prompt will not help.

### What this skill does **not** cover

Treat these as orthogonal concerns — do **not** extend this meta-skill's templates beyond the narrow migration scaffolding already provided:

- **Tool-execution stability** (browser clicks that silently no-op, API calls that return half-complete responses, page DOM changing under the agent). Use a verification-focused skill (e.g. superpowers' `verification-before-completion`) or a dedicated tool-agent harness.
- **General long-chain checkpoint / resume.** Migration is one-shot — if a phase crashes, the documented path is "wipe the partial scaffold and rerun" rather than a state machine. Broader application workflows that genuinely need pause/resume need project-specific state, validation, and recovery inside that project's own `rules/` or `workflows/`.
- **Multi-agent orchestration.** See superpowers' `subagent-driven-development` or equivalent. This skill only routes *within one agent's session*.

Adding state / validation / recovery primitives beyond the migration scaffold is that downstream project's own engineering work — it belongs in the project's `rules/` or `workflows/`, not in this meta-skill.
