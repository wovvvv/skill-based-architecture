# Behavior-Level Failures — ❌ / ✅ Scenarios

These examples are **behavior-layer** before/after pairs: what an Agent actually says or does in the failure mode, and what the correct path looks like after the architecture's protections kick in.

Unlike the migration and project-shape illustrations in [`../EXAMPLES.md`](../EXAMPLES.md), these scenarios show the **rationalizations and drift patterns** that cause skill-based architecture to silently degrade — and the specific mechanism (薄壳 Red Flags / Session Discipline / Rationalizations Table) that catches each one.

Every scenario here was captured from a real pressure-test failure. The "reject" column rebuts the Agent's actual words, not a speculative version.

---

## Scenario 1 — Skipping the AAR on a "small" task

**Context:** User asks for a one-line bug fix. Agent applies the fix, tests pass, Agent wraps up.

### ❌ Agent behavior without Task Closure Protocol

> **Agent:** "Done. Changed one line in `UserService.js:47` to null-check the email field. All tests pass. Anything else?"

What the Agent skipped:
- Did not run the 30-second AAR scan
- Missed that the bug recurred because **the same null-check was missing in three sibling services** — a repeatable pattern worth a rule
- Did not record that null-email edge case surfaces at service boundaries, not just input validation

Cost two weeks later: same bug in `OrderService`, same debug path, same 45-minute round trip.

### ✅ Agent behavior with Task Closure Protocol + Rationalizations Table

> **Agent:** "Fix applied to `UserService.js:47`, tests pass.
>
> Running 30-second AAR:
> - New pattern? Yes — null-email check at service layer (other services likely have the same gap)
> - New pitfall? Yes — input validation at controller doesn't guarantee service-layer safety
> - Missing rule? Yes — no rule currently says "service methods must null-check all optional DTO fields"
> - Outdated rule? No
>
> 2/3 rows passed the recording threshold. Added one bullet to `references/gotchas.md#service-layer-validation` and one line to `rules/backend-rules.md`. Done."

**The mechanism that caught it:** `templates/skill/workflows/task-closure.md § Task Closure Protocol` forces the 4-question scan **before** "complete" is allowed. The Agent's borrowed time (30 seconds) is cheaper than the next duplicate bug.

**Rationalization that would have bypassed it:**

| Excuse | Reject |
|---|---|
| "The task was one line — AAR is overkill" | Small tasks are where lessons hide. 30-second scan < 45-minute re-debug. |

See [templates/skill/workflows/task-closure.md § Rationalizations to Reject](../templates/skill/workflows/task-closure.md) for the full table.

---

## Scenario 2 — Description written as passive summary → skill never activates

**Context:** User has a skill for generating API endpoints. Skill file exists, rules are good, but Agent keeps writing endpoints by hand without reading the skill.

### ❌ Passive-summary description

```yaml
---
name: api-generator
description: Helps with API development and endpoint creation.
---
```

User prompt: *"Add a `/users/:id/orders` endpoint with pagination"*

Agent behavior: Writes the endpoint from scratch. Skipped the skill entirely. Endpoint ships without the project's standard error envelope, without the pagination cursor pattern, without the auth middleware — all defined in the skill the Agent never opened.

**Why:** Claude models are biased toward *undertrigger* (safe activation). A vague summary like "helps with API development" doesn't look like an imperative match for "add a `/users/:id/orders` endpoint" — they feel like different topics even though they aren't.

### ✅ Trigger-condition description

```yaml
---
name: api-generator
description: >
  This skill should be used when the user asks to "add a new API endpoint",
  "write a REST route", "add pagination to a list endpoint", or "add auth
  to an endpoint". Activate when the task involves creating, modifying, or
  reviewing HTTP routes, request/response shapes, pagination, or endpoint-level
  authentication in this project.
---
```

Agent behavior: Skill activates immediately on "Add a `/users/:id/orders` endpoint". Reads rules, matches the "pagination" trigger, follows `workflows/add-endpoint.md`, produces a correctly-structured endpoint that passes review on the first pass.

**The mechanism that caught it:** `SKILL.md § Core Principles #7` requires ≥ 2 quoted trigger phrases + `Activate when...` condition. Project's `smoke-test.sh` check category 4 ("Content quality") flags descriptions that miss these.

**Rationalization that would have left the bad description in place:**

| Excuse | Reject |
|---|---|
| "The description reads naturally — the model will figure out activation" | Model bias is toward undertrigger; "naturally readable" ≠ "reliably activates". Quoted trigger phrases in the user's actual language raise activation rate — re-read the description aloud and check whether you hear those phrases. |

---

## Scenario 3 — Same-session new task: Agent skips re-routing

**Context:** Long session. First task was "fix a backend bug", Agent read `rules/backend-rules.md` + `workflows/fix-bug.md` and resolved it. User then asks to "add a new dashboard page" — a frontend task with completely different rules.

### ❌ Agent behavior without Session Discipline

> **Agent:** "Sure, I'll add the dashboard page. Starting with the component structure…"

What the Agent skipped:
- Did not re-read `SKILL.md`
- Did not re-match Common Tasks — so it never routed to "Add page"
- Did not read `rules/frontend-rules.md` — missed the atomic design + Recoil atom conventions
- Produced a working but off-convention component that triggered 3 rounds of PR review before merge

Even worse: by this point in the session `/compact` had already fired silently. The Agent's "memory" of backend rules was a residual summary, not the actual rules. And none of that memory applied to frontend work anyway.

### ✅ Agent behavior with Session Discipline enforcement

> **Agent:** "New task detected — re-reading `SKILL.md` and re-matching route before proceeding.
>
> - SKILL.md re-read ✓
> - Task 'add a dashboard page' matches Common Tasks route: 'Add page' → read `rules/frontend-rules.md` + follow `workflows/add-page.md`
> - Reading those now, then starting work."

Then proceeds with the correct rules loaded, ships on first-pass review.

**The mechanism that caught it:** Three-layer redundancy documented in [SKILL.md § Common Pitfalls #8](../SKILL.md):

1. `SKILL.md § Session Discipline` — declares the re-match-every-task / re-read-on-change-or-compaction rule
2. `workflows/*.md § Step 0` — every workflow starts with "re-match the route; re-read its files if the route changed or context compacted"
3. `CLAUDE.md / AGENTS.md` thin shells — include the **New task in same session** auto-trigger

Each layer can be silenced by compression; the next layer catches it.

**Rationalizations that would have bypassed it:**

| Excuse | Reject |
|---|---|
| "I already read SKILL.md earlier in this session" | Context may have compressed. The new task may match a different route. Partial memory is worse than no memory. |
| "I remember the rules well enough" | Re-read costs 10 seconds; remembering wrong costs hours. |
| "The two tasks are related — backend rules partly apply" | They don't. Different layer, different conventions, different file paths. Routes are not aesthetically joinable. |

See [templates/skill/workflows/task-closure.md § Rationalizations to Reject](../templates/skill/workflows/task-closure.md) for the current canonical table.

---

## Scenario 4 — Perf edit shipped without measuring baseline

**Context:** Agent is asked to "speed up the search index rebuild." Agent rewrites the batching logic, runs the existing test suite (functional tests only, no timing assertions), tests pass, change ships.

### ❌ Agent behavior without Principle 7

> **Agent:** "Rewrote the batch loop to use parallel workers. Tests pass. Should be faster now."

What the Agent skipped:
- Did not run a benchmark before the change to capture baseline throughput
- Did not run a benchmark after the change to measure delta
- Relied on "parallel = faster" intuition — ignored that parallelism introduced lock contention on the shared index writer
- Net result: rebuild time regressed 40% under realistic document volumes; only caught in staging after a full data load, two days after merge

Cost: two days of debugging, a revert, a re-implementation with actual measurements showing where contention was.

### ✅ Agent behavior with Principle 7

> **Agent:** "Before touching the batch loop — running the perf benchmark suite to capture baseline.
>
> Baseline: 1 200 docs/s, p95 latency 420 ms.
>
> Rewriting to parallel workers… done. Re-running benchmark under identical conditions.
>
> After: 980 docs/s, p95 latency 510 ms — regression. Parallel workers are slower here, likely due to shared-writer contention.
>
> Reverting parallelism. Trying a larger batch size instead…
>
> After v2: 1 650 docs/s, p95 latency 310 ms — improvement. Shipping with delta in commit message."

**The mechanism that catches it:** the project's adopted performance/testing contract requires a before/after benchmark, and `task-execution.md` loads that contract while constructing fitted evidence. The generic scaffold owns the timing; the project owns whether performance work requires this benchmark.

**Rationalizations that would have bypassed it:**

| Excuse | Reject |
|---|---|
| "Parallel is obviously faster for I/O-bound work" | Intuition is cheap; measurement is evidence. The benchmark took 90 seconds. The revert took two days. |
| "Functional tests all pass — perf must be fine" | Functional tests do not assert timing. A regression can be functionally correct. |
| "We'll catch it in staging" | Staging with realistic data volume is two days away. The benchmark is 90 seconds away. |

---

## Scenario 5 — Vague wording triggers either blind planning or a lexical stop

**Observed:** Haiku 4.5 tests against wj-small-tools, 2026-04. Prompt: "我想把后端代码重构一下,让结构更清晰。你能帮我开始吗?"

### ❌ Agent behavior without evidence-first judgment

One failure mode scans superficially, invents a 4-phase target architecture, and asks for goals only after planning. The opposite failure mode sees the word "重构", refuses even read-only discovery, and asks the user to name a file and define "clearer". Both miss `project-rules.md`, which explicitly says "**保持现有 Java 包结构稳定，不做大规模重命名或拆分**"; one guesses past the constraint, the other transfers repository discovery to the user.

### ✅ Agent behavior with evidence-first judgment

Agent starts from the selected workflow, treats "重构 / 更清晰" as an uncertainty signal, and performs a bounded read-only inspection of package constraints, dependency structure, recent changes, and tests. It loads the project rule only when the planned scope reaches that boundary, discovers that large package moves are forbidden, and narrows the technical candidates without designing a replacement architecture. It asks one minimum question only if several materially different product outcomes remain. No mutation starts until the chosen outcome has verifiable evidence.

**Mechanism:** Ambiguous Request Gate — `templates/skill/protocol-blocks/ambiguous-request-gate.md`. It is a pre-mutation judgment contract: route likely intent, gather the smallest decision-changing evidence, then clarify only the owner decision evidence cannot supply.

### Lessons folded back upstream

1. **Shells must preserve the route-first bootstrap**, not copy a universal rule list. The workflow loads project rules only when evidence reaches their scope.
2. **Vague verbs are uncertainty signals, not objectives or blockers.** The Agent must not plan from them, but it also must not demand repository facts from the user before checking available evidence.
3. The stop condition belongs at mutation: read-only diagnosis may continue; an unresolved normative preference, authority boundary, or materially different outcome requires minimum clarification before editing.

## Scenario 6 — Absolute paths in subagent prompts bypass `isolation: worktree`

**Observed:** multiple subagent test rounds in 2026-04 (both upstream gate tests and wj-small-tools routing tests).

### ❌ Test author behavior without awareness of this pitfall

Test author writes a subagent prompt: "in `/Users/shiqi/IdeaProjects/foo` please edit `rules/change-discipline.md`." The Agent tool creates a worktree at some temp path, the subagent runs with CWD = worktree root, but **uses the absolute path from the prompt** for its Read/Edit calls. Edits therefore land in the main repo, not the worktree. When the subagent finishes with changes present, the Agent tool **still reports the worktree as clean** (the worktree is unchanged because all edits went to the absolute path outside it) and silently cleans it up — no path returned, no warning. Main branch is silently polluted. Across repeated subagent test rounds, the polluted state compounds into unnoticed edits to the main checkout.

### ✅ Test author behavior with this pitfall recorded

Test author uses **relative paths** in subagent prompts ("in this repo, edit `rules/change-discipline.md`") OR accepts that absolute-path prompts will pollute main and explicitly restores each test edit after the round. Before dispatching, the test author verifies the subagent prompt does not contain absolute paths that cross the worktree boundary.

**Mechanism:** awareness, not a tool — there is no runtime protection. `isolation: worktree` is designed to isolate *relative* working-directory edits; absolute paths escape it by design. Record this in `WORKFLOW.md § Upgrading` and in any testing workflow.

### Lessons folded back upstream

- `WORKFLOW.md § Upgrading` now includes "don't use absolute paths in subagent prompts when probing"
- Any future testing-automation documentation should emphasize: **`isolation: worktree` is not a sandbox; it is a CWD isolation**. Absolute paths, env-var-based paths, and `~/foo` paths all escape it.

---

## Scenario 7 — Agent asks the user to choose implementation facts already present in code

**Observed:** a downstream business-modeling session in `chaos`, 2026-07-29. The Agent mixed the version-to-Tag merge flow with developer-code ingress into a protected release branch, then asked the user whether developers could push directly to the release branch or had to enter through another branch. The user stopped the discussion: "这些东西代码里面都有,你为什么还在问我,你都没有代码吧".

### ❌ Agent behavior without implementation-fact closure

The Agent traces one nearby merge path, leaves the page entry, MR-creation endpoint, source branch, target branch protection, and backend guard unresolved, then turns the missing discovery into a user-facing binary choice. The question appears business-oriented but actually asks the user to reconstruct current code behavior.

### ✅ Agent behavior with implementation-fact closure

The Agent traces the two flows independently across frontend entry, API call, backend write/merge owner, target branch, and protection checks. It states the current implementation conclusion directly, cross-checks it with prior user answers, and asks only whether the future business rule should change, permit bypass, or fail closed.

**Mechanism:** [`templates/skill/protocol-blocks/ambiguous-request-gate.md` § Implementation-Fact Question Gate](../templates/skill/protocol-blocks/ambiguous-request-gate.md#implementation-fact-question-gate), activated locally by Plan, business-modeling, and Fix Bug workflows.

### Lessons folded back upstream

1. A concrete-flow question is still lazy when a decision-bearing implementation hop remains untraced.
2. Two incomplete flows must be completed separately before their relationship is discussed.
3. Code establishes current implementation fact; the user decides only the remaining normative rule.

---

## How to add new scenarios here

This file grows only via **real pressure-test failures** — same rule as the Rationalizations Table:

1. Catch an Agent behaving badly in a real session
2. Capture the exact rationalization or drift pattern verbatim
3. Write the ❌ (Agent's actual words / actions)
4. Write the ✅ (what happens once the specific mechanism activates)
5. Name the mechanism and link to its authoritative definition in this repo

**Do not add speculative scenarios.** Invented failures dilute the value of real ones.
