# hooks/ - Harness Integration Points

Two hooks ship here. Both are **opt-in**. Copy the scripts and JSON for the harness you use; context-injection scripts exit silently when their inputs are absent.

| Hook | Script | Fires on | Purpose |
|---|---|---|---|
| SessionStart | `session-start` | startup / `/clear` / `/compact` | Re-inject one router file so routing survives context summarization |
| UserPromptSubmit | `workflow-state` | every user prompt | Inject one active long-workflow hint from `.skill-workflow-state` |

See `SECURITY.md` for the trust boundary around hook-read files.

## SessionStart Policy

The SessionStart hook injects **navigation, not the knowledge base**. It never reads every `skills/*/SKILL.md`.

Resolution order:

1. `SKILL_ROUTER_PATH` - explicit router for multi-skill repos
2. `SKILL_PATH` - backward-compatible explicit single-skill path
3. `skills/router/SKILL.md` - conventional multi-skill router
4. Exactly one `skills/*/SKILL.md` - single-skill fallback

If multiple skill entries exist and no router is configured, the hook injects nothing rather than guessing.

## Workflow-State Policy

`workflow-state` is for long workflows only. It reads `.skill-workflow-state` by default:

```text
workflow=skills/<name>/workflows/plan-feature.md
status=planning
task=docs/plans/YYYY-MM-DD-slug
```

The workflow file owns the prompt text through `[workflow-state:<status>]` blocks. Missing state file, missing workflow file, or unknown status exits 0 with no output, so short tasks stay quiet. Delete `.skill-workflow-state` when the workflow completes or is abandoned.

Overrides:

| Variable | Purpose |
|---|---|
| `SKILL_WORKFLOW_STATE_FILE` | Use a non-default state file |
| `SKILL_WORKFLOW_FILE` | Fallback workflow file when the state omits `workflow=` |
| `CLAUDE_HARNESS` / `SESSION_HARNESS` | Select output shape: `claude`, `cursor`, `gemini`, or fallback |

## Install - Claude Code

```bash
mkdir -p .claude/hooks
cp templates/hooks/session-start .claude/hooks/session-start
cp templates/hooks/workflow-state .claude/hooks/workflow-state
chmod +x .claude/hooks/session-start .claude/hooks/workflow-state
test -f .claude/settings.json || cp templates/hooks/hooks.json .claude/settings.json
```

If `.claude/settings.json` already exists, merge the top-level `hooks` object from `templates/hooks/hooks.json`.

`workflow-state` only reads relative workflow files under `workflows/`, `skills/*/workflows/`, or `templates/skill/workflows/`; absolute paths, `..`, and symlinks are ignored. Both scripts need only bash and python3.

Schema check: Claude Code CLI v2.1+ uses the nested hook format (`matcher` -> `hooks[]` -> `{type,command}`). If a hook appears configured but does not fire, inspect hook events with the CLI's verbose hook output.
<!-- external-fact: verified=2026-05-06 source=https://code.claude.com/docs/en/hooks -->

## Install - Cursor

```bash
mkdir -p .cursor/hooks
cp templates/hooks/session-start .cursor/hooks/session-start
cp templates/hooks/workflow-state .cursor/hooks/workflow-state
chmod +x .cursor/hooks/session-start .cursor/hooks/workflow-state
cp templates/hooks/hooks-cursor.json .cursor/hooks.json
```

Cursor's hook contracts may differ from Claude Code's. Verify each hook fires before treating it as enforcement.

## Install - Other Harnesses

`session-start` and `workflow-state` write small JSON context payloads. Harnesses with different contracts need a thin adapter around these scripts.

## Dry Runs

```bash
# SessionStart: outputs JSON only when it can resolve exactly one router.
CLAUDE_HARNESS=claude bash .claude/hooks/session-start

# Workflow state: no state file should be a quiet pass.
bash .claude/hooks/workflow-state
```
