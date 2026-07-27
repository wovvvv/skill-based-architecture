# Ambiguous Request Gate

Use this before mutation when wording leaves the requested outcome unclear. Vague wording is a signal, not an automatic blocker: the Agent should improve its decision view before transferring technical discovery back to the user.

## Evidence-First Decision

1. Route the request by its likely intent and inspect the smallest read-only evidence set that can resolve it: loaded rules, code, docs, config, tests, runtime evidence, and prior Session context.
2. Derive the likely technical scope, constraints, and verifiable outcome. Separate confirmed facts, reasonable assumptions, and unknowns.
3. Proceed with bounded investigation when evidence can narrow the problem. Surface non-blocking assumptions without asking the user to choose details the repository can answer.
4. Ask one minimum question only when the remaining unknown is a normative product or business preference, an authority boundary, or a choice that produces materially different outcomes.
5. Do not mutate until the requested outcome is concrete enough to verify.

## Boundaries

- Read-only discovery is allowed when it directly reduces the request ambiguity; speculative implementation or architecture is not.
- A concrete module/file is not required when evidence can identify the owning boundary.
- Prior-turn scope remains valid until contradicted.
- If evidence exposes several plausible product outcomes, report the distinction and ask for the missing owner decision; do not silently select one.

## Failure Modes

- Lexical stop: treating `refactor / optimize / clean up / 整理 / 重构 / 优化` as blockers without reading project evidence.
- User-as-index: asking which file or module before checking the repository's source of truth.
- Speculative plan: proposing phases or target architecture before the outcome and constraints are evidenced.
- Hidden assumption: mutating on an unresolved product preference instead of requesting the minimum clarification.
