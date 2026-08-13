# Executable Skill Architecture

Use this reference when a project skill must operate external systems, not only
describe project rules. The default scaffold stays rule-oriented; this is an
upgrade path for operation-heavy skills.

Executable is an execution-mode axis, not a full shape replacement. Decide it
separately from structure tier (Single-file / Folder-light / Full) and domain
topology (Single-skill / Multi-skill candidate).

## Degrees of Freedom

Before promoting a skill toward executable shape, ask: what is the most fragile
step, and how much freedom can the agent safely have?

| Freedom | Signal | Skill shape |
|---|---|---|
| High | Many valid approaches; judgment-heavy work; no fixed output contract | Pure reference or workflow prose |
| Medium | A preferred command or check exists, but parameters vary by task | Workflow prose plus inline shell or a small validator |
| Low | Fragile sequence; fixed format/API; side effects; repeated exact logic | Script/CLI-first; consider this executable shape |

Low freedom is only one half of an operation-level downshift and one signal for
whole-Skill promotion. It never justifies a script because the result would look
tidy.

## Operation-Level Deterministic Downshift

The Agent owns the goal, desired meaning, semantic parameters, target selection,
authorization, alternative generation, exception interpretation, and escalation.
A deterministic carrier owns only declared inputs, exact execution, stable
outputs/errors, and idempotency behavior.

Move one operation into a structured API, existing CLI, existing script, or a
new minimal script only when both conditions hold:

1. **Low freedom:** correctness depends on precision rather than open-ended
   judgment, such as exact counting, structured parsing, repeatable transforms,
   batch operations, idempotent replay, or fragile command assembly.
2. **Real pressure:** the operation has repeated or carries demonstrated high
   error pressure. A one-off, low-risk action with a direct cheap check stays on
   the Agent path even when scripting is possible.

Prefer the lightest existing carrier in that order. A new script is the last
choice, not the definition of rigor. Exploration, diagnosis, product trade-offs,
and semantic parameter choice remain outside the carrier. If new evidence
invalidates an input premise, stable schema, target, authority, or expected
result, return control to Agent judgment; do not hide the change behind blind
retry or a hard-coded product choice. Downshifting one operation does not by
itself promote the whole Skill to Executable shape, and no carrier expands the
current task's operation or delivery authority.

## When To Use

Adopt the executable shape only when at least two pressures are present:

- The skill calls external APIs, CLIs, databases, cloud services, or remote
  platforms as part of normal user tasks.
- The skill needs deterministic scripts because agents would otherwise rewrite
  fragile shell or HTTP logic repeatedly.
- Tasks have side effects such as deploys, writes, status transitions, or remote
  configuration updates.
- Callers need stable output contracts that hide raw API response shapes.
- Users need local, non-committed configuration such as API keys, base URLs,
  product codes, auth headers, or runtime paths.

If the project mostly records coding conventions, review rules, or recurring
procedures, stay with the normal `rules/`, `workflows/`, and `references/`
layout.

## Recommended Shape

```text
skills/<name>/
├── SKILL.md
├── conf/
│   └── .defaults/
├── scripts/
├── tools/
├── capability/
├── workflows/
├── references/
└── rules/
```

Responsibilities:

| Layer | Owns | Avoids |
|---|---|---|
| `scripts/` | How to execute: auth, HTTP, CLI wrappers, config loading, parsing | Business routing and user-facing prose |
| `tools/` | One atomic external operation: method/path/params/return/error/idempotency | Business triggers, fallback policy, multi-step flow |
| `capability/` | One domain business ability with a stable output contract | Cross-domain orchestration, user-environment side effects |
| `workflows/` | Full user intent, multi-step flow, confirmations, side effects | Repeating capability internals inline |
| `conf/.defaults/` | Copyable user-local config templates | Real secrets or project-owned runtime instances |

Dependency direction should stay one-way:

```text
workflows -> capability -> tools -> scripts
```

`scripts/` may also be called directly by workflows when the script is pure
execution infrastructure, such as project introspection or runtime argument
assembly.

## Contracts

Executable skills need contracts earlier than rule-only skills:

- Every `tool` declares idempotency and the exact input shape.
- Every `capability` declares a stable output contract; callers do not depend on
  raw tool fields.
- Every non-idempotent workflow has a confirmation point immediately before the
  side effect.
- Every local config value has a source order and a safe missing-value behavior.
- Every large or noisy external response has a way to inspect targeted fields
  without loading the whole payload into context.

## Re-Readable Execution Evidence

For a simple synchronous command, stdout and exit status may be sufficient when
the command's own contract directly proves the requested result. When execution
is long-running, asynchronous, backgrounded, noisy, terminal-truncated, or only
submits work for later completion, the workflow must name an authoritative
evidence source that can be read again. It may be a job/status API, test report,
manifest, generated artifact, deployed runtime, schema/data readback, or another
domain-owned state; it is not required to be a file.

Before accepting the readback, verify every applicable dimension:

1. **Execution identity:** this run, job, commit, input set, and requested target.
2. **Authority and provenance:** the system/artifact that owns the claimed result,
   not a precursor or copied summary.
3. **Freshness:** produced or read after the final relevant input and not merely
   an old success observed by a new command.
4. **Completeness and semantic validity:** required content is present,
   parseable, and satisfies the stable output contract.
5. **Requested terminal state:** the user's outcome, not only accepted, queued,
   started, pushed, uploaded, or another intermediate state.

File existence, stdout text, and zero exit status remain useful signals, but no
one of them is a universal success oracle. A stale, malformed, partial,
unrelated, wrong-run, or non-terminal result keeps the step open. If no
authoritative readback can prove the outcome, report `no verdict` or the exact
unproven boundary instead of manufacturing completion.

## What Not To Promote

Do not create an executable skill because the structure looks more complete.
Do not add `tools/`, `capability/`, `scripts/`, or `conf/` to the default
template. Two ordinary projects should be able to adopt the base scaffold
without inheriting operation-specific directories they do not use.

Promote this shape only from project evidence gathered by
`workflows/profile-project.md`: external execution surface, side effects,
stable output contracts, local configuration, or repeated script logic.

## Validation

Minimum validation for executable skills:

- Structural checks still pass: routing sync, link checks, orphan checks.
- Contract checks cover index-to-file consistency and registered error codes.
- Script tests cover pure parsing/config logic.
- Golden tests cover CLI output that other workflows depend on.
- Scenario tests cover high-risk user intent routes when route correctness
  matters more than file shape.
