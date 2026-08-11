# CLAUDE.md

Formal docs live under `skills/`. Read `skills/*/SKILL.md` — default to `primary: true` skill; only switch when task clearly matches another skill's description.

<!-- external-fact: verified=2026-04-28 source=https://code.claude.com/docs/en/skills -->

Conflicts between loaded project instructions → formal docs in `skills/{{NAME}}/` win. This does not override Claude native skill name precedence: personal `~/.claude/skills/<same-name>` overrides project `.claude/skills/<same-name>`.

<!-- The <always-applicable> and <task-routing> XML tags below are load-bearing.
     Rationale: LLMs parse XML-tag blocks as discrete hard-constraint sections
     more reliably than plain markdown headings, especially after context
     compression. See skill's references/thin-shells.md § XML-Tag Injection. -->

<always-applicable>

**Always Read (every task, before workflow selection)**

<!-- ALWAYS_READ_START -->
- None by default; workflows load knowledge at evidence and phase boundaries.
<!-- ALWAYS_READ_END -->

**Request-clarity judgment**: vague wording is a signal, not an automatic blocker. Use bounded read-only project evidence to derive scope; ask only for an unresolved normative preference, authority boundary, or materially different outcome. Do not mutate before the outcome is verifiable.
<!-- REQUEST_CLARITY_OWNER_START -->
See `skills/{{NAME}}/protocol-blocks/ambiguous-request-gate.md`.
<!-- REQUEST_CLARITY_OWNER_END -->

</always-applicable>

Route metadata lives in `skills/{{NAME}}/routing.yaml`; the bootstrap below tells agents how to match it.

<task-routing>

**Quick Routing (survives context truncation)**

<!-- ROUTING_BOOTSTRAP_START -->
Task routes live in `skills/{{NAME}}/routing.yaml`.

For every new task:
1. Read `skills/{{NAME}}/routing.yaml`.
2. Match exactly one task route by `labels`, `trigger_examples`, and task intent; if none matches, use `other`.
3. Follow only that route's `workflow`; the task route does not preload knowledge.
4. Let the workflow inspect the smallest evidence that can decide the next action.
5. Only when an explicit business-rule request, a source Plan already declares the applicable business-domain owner, or evidence proves an unresolved decision is business-bearing, read optional `skills/{{NAME}}/domain-routing.yaml`. Read a governing source Plan directly through its workflow; its existence alone does not activate a domain. Keywords identify candidates only. Append one domain owner's reads by default; never replace the task workflow.
6. Load mutation, testing, managed-execution, and closure contracts only when their phase begins.
<!-- ROUTING_BOOTSTRAP_END -->

</task-routing>

<!-- BEHAVIOR_BLOCK_START -->
## Auto-Triggers

- **New task in same session** → always re-match the route from canonical `routing.yaml`. After a route change, read the new workflow; after compaction, recover only the current workflow and decision-relevant evidence. Then execute one clear action/check directly. Otherwise follow `skills/{{NAME}}/workflows/task-execution.md` to establish a Task Anchor, present only useful alignment, use the harness-native Plan without repeating visible steps in chat, and run its compact Anchor Checkpoint before each main step. This is Session recitation, not planning-file persistence. Can't tell if context compacted? Re-read the current workflow.
- Before any requested commit/push/MR/deploy/publish delivery, or before declaring any non-trivial task complete → enter Task Closure Protocol (see `skills/{{NAME}}/workflows/task-closure.md`); `Ready for Delivery` is not completion
- When user asks to "record/save/remember" something → project-level knowledge goes to `skills/{{NAME}}/` docs; personal preferences go to agent memory

## Red Flags — STOP

- "Just this once I'll skip the AAR" → stop. See `skills/{{NAME}}/workflows/task-closure.md` § Rationalizations to Reject.
<!-- BEHAVIOR_BLOCK_END -->
