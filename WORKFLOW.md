# Migration Workflow

Step-by-step procedure for restructuring a long SKILL.md or scattered rules into Skill-based architecture.

## Quick Start

For small-to-medium projects, run the scaffold and fill in content. Skip the full 9-phase process.

### Which path should I take?

Answer these questions to decide:

1. **Is the total rule content > 150 lines across all files?** (Count SKILL.md + AGENTS.md + .cursor/rules/ + README rules sections combined, not just one file)
2. **Are rules duplicated across 2+ entry files?** (e.g., AGENTS.md and .cursor/rules/ overlap)
3. **Do you have recurring pitfalls that keep being rediscovered?** (same debugging lesson learned twice)

| Answers | Path |
|---------|------|
| All No | **Minimal single SKILL.md** — use the [minimal starter template](TEMPLATES-GUIDE.md#minimal-starter-template) |
| 1 Yes, others No | **Quick Start scaffold** below — run the script, fill TODOs |
| 2+ Yes | **Full 9-phase migration** — follow [`workflows/full-migration.md`](workflows/full-migration.md) |

If the project has only one small skill, no duplicated entry files, and no growing rule/reference sprawl yet, **do not force the full architecture immediately**. Start with a single well-written `SKILL.md` using the minimal starter template in [TEMPLATES-GUIDE.md](TEMPLATES-GUIDE.md), and upgrade only when one of the conditions above becomes true.

**Step 1 — Profile and inventory before writing.** Read the target repository plus the upstream [`templates/skill/workflows/profile-project.md`](templates/skill/workflows/profile-project.md) before creating scaffold files. Inventory every existing instruction entry (`AGENTS.md`, `CLAUDE.md`, `CODEX.md`, `GEMINI.md`, `.cursor/rules/workflow.mdc`, and any project-specific equivalents) so their meaning can be migrated instead of overwritten. Start with the workflow's user brainstorm gate.

- If the user says yes / "没问题" / otherwise agrees: **do not read code yet**. First run the brainstorm, restate a short calibrated summary, and ask the user to correct or confirm it.
- Treat a clear user answer, selection, rejection, or correction as the highest-authority input for the corresponding normative product/business decision, but not as proof of current implementation. Preserve its question/context and classify it as `User-confirmed desired truth`; then read local code/config to establish `current implementation fact`.
- After the brainstorm feedback, inspect real evidence (README, build files, CI, entry points, configs, module layout, tests) and classify conclusions as `Confirmed from code/config`, `User-confirmed desired truth`, `Inferred`, or `Unknown`. A conflict with the confirmed mainline invokes [`task-execution.md` § User Decision Drift Gate](templates/skill/workflows/task-execution.md#user-decision-drift-gate); this migration workflow owns the immediate pause/consult action, not the gate's complete resolution procedure.
- Only then write project content into `rules/`, `workflows/`, `references/`, and `SKILL.md`. Normative business rules may come from faithfully preserved user-confirmed decisions with provenance; technical/current-state claims require code/config evidence.
- If the user declines brainstorming or explicitly asks to skip it, proceed with code-first evidence scanning and mark unclear conclusions as `Unknown` instead of guessing.

After the evidence scan, product projects may present **business-global-model candidates**: modules whose stable types, macro flow, states, boundaries, or invariants are repeatedly needed and not obvious from code. Explain why each candidate matters and ask `model now / later / not needed`. Only `now` adopts `workflows/profile-business-model.md.example` and creates a routed model after evidence search + user calibration. `later` and `not needed` create no file, directory, index, route, or persistent queue.

**Step 2 — Preview and apply the scaffold.** The upstream command is the only Quick Start write path. It defaults to dry-run, reports every create/preserve/conflict decision, rejects reruns over an existing skill, and never overwrites existing project entry files.

```bash
# Assumes skill-based-architecture is cloned as a sibling, or $UPSTREAM points at it.
UPSTREAM="${UPSTREAM:-../skill-based-architecture}"
NAME="<name>"          # project identifier, kebab-case
SUMMARY="<one-line project summary>"

# Read-only preflight. Existing entries are reported as PRESERVE.
bash "$UPSTREAM/scripts/scaffold-downstream.sh" \
  --target "$PWD" --name "$NAME" --summary "$SUMMARY"

# Apply only after the Agent has inspected the inventory and profile evidence.
bash "$UPSTREAM/scripts/scaffold-downstream.sh" \
  --target "$PWD" --name "$NAME" --summary "$SUMMARY" --apply
```

For every `PRESERVE` row, the Agent owns the semantic merge: extract durable project rules into the appropriate skill files, keep only entry-specific instructions in the thin shell, and integrate the generated routing bootstrap without dropping the old meaning. Do not ask the user to compare files or decide technical destinations that project evidence can establish. Before declaring migration complete, trace each inventoried source instruction to its migrated/merged destination or an explicit exclusion reason in the current task evidence.

**Why a scaffold command instead of raw copy?** Inline heredoc generation lost sections, while `cp -R templates/shells/. .` silently replaced real project instructions. `scripts/scaffold-downstream.sh` still materializes the byte-for-byte template sources, but it previews the path plan, creates only missing entry files, records the upstream baseline, and rolls back newly created paths if apply fails. Existing entry content remains untouched until the Agent performs the evidence-backed semantic merge.

**Step 3 — Fill content.** Two kinds of placeholders, two different mechanisms:

| Marker | How to fill |
|---|---|
| `{{NAME}}`, `{{SUMMARY}}` | Done by the scaffold command in Step 2 |
| `<!-- FILL: … -->` | Requires judgment — you must read each marker and write real project content |

Agent-facing check for pending project-specific content:

```bash
grep -rn 'FILL:' "skills/$NAME" AGENTS.md CLAUDE.md CODEX.md GEMINI.md .cursor
```

Every hit is mandatory for the agent before shipping the skill. A user should not have to interpret these markers; they are migration work items.

Always Read lists, Common Tasks, and shell bootstraps are generated from `skills/$NAME/routing.yaml`. Edit that manifest, then run:

```bash
bash "skills/$NAME/scripts/sync-routing.sh" "$NAME"
```

Do not hand-edit generated Always Read / Common Tasks in `SKILL.md` or generated blocks in thin shells.

**Step 4 — Verify structure and migration evidence.** After all FILLs and preserved-entry merges are resolved, run the automated smoke test:

```bash
# Fully automated — checks structure, routing, placeholders, line budgets, and description quality
bash "skills/$NAME/scripts/smoke-test.sh" "$NAME"

# Routing manifest drift check (also run by smoke-test when routing.yaml exists)
bash "skills/$NAME/scripts/sync-routing.sh" "$NAME" --check

# (Optional) Surface rules/ or references/ files with zero inbound links
(cd "skills/$NAME" && bash scripts/audit-orphans.sh)
```

`smoke-test.sh` covers structure and routing: file existence, line count budgets, placeholder/FILL residue, description word count / trigger phrases / keyword-stuffing, routing-manifest drift, routing completeness, description consistency, shell bootstrap consistency, SessionStart-hook presence, broken markdown links, and content conformance. It does **not** prove that pre-existing user instructions survived. Migration completion also requires the Step 1 source inventory and Step 2 source-to-destination evidence.

For description-quality judgment (too narrow / weak or off-language trigger phrases) — re-read the `description` block aloud and check it uses the user's actual phrasing. `smoke-test.sh` now WARNs on the over-broad / keyword-stuffed case (> 12 quoted phrases), but no script substitutes for the rest of that judgment.

For complex migrations (large projects, heavily scattered rules), follow [`workflows/full-migration.md`](workflows/full-migration.md) for the Phase 1–9 process.

## If a Phase Crashes

The scaffold command rolls back paths it created when apply itself fails. If interruption happens later during Agent-led content migration, do not rerun the scaffold over the existing skill: inspect `git status --short`, compare the current source-instruction inventory with migrated destinations, and resume from the first unverified item. Existing entry files preserved by the scaffold remain the recovery source until their semantic merge is verified.

Use `bash skills/$NAME/scripts/smoke-test.sh $NAME --phase N` to verify a specific phase before moving on (the full smoke test only passes after Phase 8). Phase 9 is a manual attestation: at least one row in `workflows/task-closure.md` § Rationalizations to Reject came from a real pressure test.

## Upgrading an Existing Downstream Project

When upstream releases new templates, hooks, scripts, or workflow improvements, do **not** re-migrate. Use the agent-led upstream refresh path documented at [`workflows/upgrade-downstream.md`](workflows/upgrade-downstream.md). The user just says "上游项目更新了,帮我更新一下" or "update from upstream", and the agent follows `skills/<name>/workflows/update-upstream.md`.
