# Knowledge Reconciliation

Use this owner for an ordinary Closure lesson, explicit user-requested non-business record, Agent-observed reusable knowledge not admitted by another Rule Update owner, correction of inaccurate/over-broad knowledge, retirement of an obsolete premise, or repair of a missed/inert rule when no Verified Failure escalation is active. Before a persistent change or no-write decision, consume [`workflows/update-rules.md` § Shared Durable-Write Contract](../update-rules.md#shared-durable-write-contract) once.

## Ordinary Recording Threshold

For a new ordinary AAR, user-requested, or Agent-observed record, at least two must pass:

1. **Repeatable** - likely to recur.
2. **Costly** - absence wastes meaningful time or causes regressions.
3. **Not obvious** - code alone would not quickly reveal it.

Outdated or false existing content is corrected directly and need not re-earn the threshold. User-confirmed business meaning, proven engineering failure, and accepted workflow mutation use their typed owners rather than this threshold.

## Upgrade Plan Gate

For discipline rules whose only job is changing behavior under pressure, require an observed/known failure or a baseline scenario; do not codify a hunch. For external absorbs, benchmark/eval lessons, major template or default-scaffold changes, Always Read/routing changes, or reusable mechanisms, require the user's approval of an exact upgrade Plan before editing. State the evidence, candidates and rejections, impact, activation path, net benefit over context/complexity cost, why a lighter destination is insufficient, and the cheapest meaningful validation.

## When Not to Record

- one-off workaround or minor preference with no stable prevention action;
- fact immediately obvious from code or already covered by official docs;
- session transcript, chronological debug log, or date-named narrative under `references/`;
- unconfirmed inference presented as intent;
- `later` business-model candidate, which remains Session-only with no file, index, route, or memory record;
- content whose only purpose is moving an eval or benchmark score.

## Learn, Correct, Retire

Classify the documentation result before editing:

1. missing ordinary knowledge -> Recording Threshold plus the shared durable-write contract;
2. outdated or inaccurate knowledge -> correct in place and check consumers;
3. obsolete premise -> delete it or scope a temporary legacy remainder with reason and date;
4. rule existed but was missed or inert -> repair activation/prominence instead of duplicating it.

Use [`workflows/maintain-docs.md`](../maintain-docs.md) for full-file reorganization, split/merge, selecting-index admission, line/load-reason audits, and orphan/reachability mechanics. Knowledge Reconciliation decides durable meaning and activation; it does not turn one record into a library-cleanup task.

## Knowledge-Specific Completion

- [ ] New ordinary knowledge passed at least two threshold tests; correction/retirement did not pretend to be an AAR.
- [ ] A behavior-changing mechanism had real failure/baseline evidence and any required upgrade Plan approval.
- [ ] A `when not to record` case produced no durable artifact.
- [ ] Correction, retirement, or activation repair checked affected consumers without broad unrelated reorganization.
- [ ] Generic knowledge passed cross-project generalization through the shared contract.
