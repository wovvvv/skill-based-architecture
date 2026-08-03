---
date: 2026-07-31
status: done
distilled_to:
  - templates/skill/protocol-blocks/source-localization.md
  - templates/skill/protocol-blocks/ambiguous-request-gate.md
  - templates/skill/workflows/task-execution.md
  - templates/skill/workflows/plan-feature.md
  - templates/skill/workflows/fix-bug.md
  - templates/skill/workflows/change-managed.md
  - templates/skill/conformance.yaml
  - references/self-hosting-conformance.yaml
  - scripts/check-self-scenarios.sh
  - UPSTREAM-CHANGES.md
---

# Plan: Evidence-Funnel Code Localization

> Current conclusion: introduce a conditional, single-owner source-localization protocol that narrows technical hypotheses before deep reading; do not add a new task route, fixed Token budget, or mandatory five-step ceremony.

## Problem And Scope

SBA already requires the selected workflow to inspect the smallest decision-relevant evidence, stop when the current question is resolved, and trace ownership/call paths before mutation. The active behavior is nevertheless fragmented:

- `ambiguous-request-gate.md` owns evidence-first clarification and the implementation-fact question gate;
- `task-execution.md` owns decision-relevant expansion and advance/return semantics;
- `plan-feature.md` owns the smallest concrete flow used to make a design question decision-ready;
- `fix-bug.md` and `change-managed.md` require root cause, source of truth, call chain, fan-out, and affected paths.

These owners describe **why** evidence must stay bounded and **what** semantic path must eventually be closed. They do not completely define **how to localize an unknown implementation target without broad reading**. A large repository task can therefore still jump from a vague request to directory inventory or source reading, use the model as a search engine, open every suspected consumer, or trace a call chain before candidate symbols are narrow enough.

This Plan covers source-oriented localization before implementation: code, tests, configuration, contracts, generated/derived files, and their source-of-truth relationships. It does not redesign task routing, domain binding, Task Execution, validation rigor, business modeling, or the whole repository-search product.

## Evidence Baseline

- The user-provided design specimen proposes intent disambiguation -> module location -> keyword search -> call-chain tracing -> verification, with each stage emitting a narrower result for the next.
- The specimen correctly separates semantic judgment from deterministic search, but its approximate Token quantities are observations, not correctness thresholds.
- “Keyword search does not enter the LLM” is directionally useful but not literally true in an interactive coding harness: command results return to the Agent. The implementable boundary is that the tool performs broad filtering and only bounded candidate paths, symbols, and decision-relevant snippets enter model context.
- The former `minimal-sufficient-context.md` already defined additive expansion and was intentionally removed in `96cd072` after its load-bearing behavior moved into active workflows. This Plan must not resurrect that deleted implicit-Always-Read layer.
- Current conformance checks assert smallest source/runtime slices and candidate queues, but no active scenario proves that an Agent narrows from an unknown target to bounded paths/symbols before reading implementations.

## Decision Context

### D1 - A durable Plan is required

- Trigger: the user identified this as a large requirement and explicitly requested a Plan, using the five-stage localization diagram as the design input.
- Authority: user-confirmed.
- Meaning: preserve the design, ownership, risks, validation, and implementation handoff in a durable record before editing active workflows.
- Evidence / Source: current conversation.

### D2 - Fixed resource quantities are not correctness gates

- Status: confirmed product principle.
- Meaning: Token, file, line, question, and elapsed-time measurements may expose suspicious breadth, but they cannot decide whether a localization stage is complete.
- Consequence: the protocol advances on fitted evidence and candidate/uncertainty reduction, not `2K`, `10K`, a fixed number of files, or a fixed number of stages.
- Evidence / Source: `docs/sba-bible.md` principles 9-11 and the completed evidence-driven progressive-disclosure work.

### D3 - First-release scope and owner

- Status: confirmed.
- Authority: user-confirmed.
- Meaning: first implement this as a conditional **source-localization protocol block** consumed by source-oriented workflows. Keep Task Execution as the owner of generic evidence progression and let each task workflow keep its local trigger/acceptance hook.
- Scope: code, tests, configuration, API/RPC/contracts, generated or copied files, and canonical source-of-truth paths.
- Boundary: business-model retrieval, rule/knowledge retrieval, runtime/production evidence, databases, and external systems continue using the existing generic evidence gate. Do not generalize the complete procedure until a second concrete class of localization failure proves it applies unchanged.
- Evidence / Source: current conversation.

### D4 - Progressive source-exposure boundary

- Status: confirmed.
- Authority: user-confirmed.
- Meaning: the first two localization stages use intent plus bounded directory and file-name structure without loading source bodies into model context. Stage 3 lets deterministic tools search source content and returns only bounded path/symbol/match candidates. Stage 4 is the first stage that reads selected implementation code into model context.
- Consequence: broad repository scanning happens tool-side; model exposure progresses from intent -> names/paths -> lexical candidates -> selected source. This ordering is a primary speed and Token-efficiency mechanism, not an optional optimization.
- Boundary: a target already proven concrete may skip directly to the selected-source read. Directory/file names and search results remain candidate evidence rather than ownership proof, and unbounded trees or grep output are prohibited because they can flood context without opening whole files.
- Evidence / Source: current conversation.

### D5 - Define the search contract, not a grep engine

- Status: confirmed.
- Authority: user-confirmed.
- Meaning: SBA defines the Stage 2 -> Stage 3 search contract and lets the Agent execute it with harness-native `rg` or a repository-native equivalent. SBA does not implement a grep engine, mandatory search wrapper, index service, or persistent search runtime.
- Contract: Stage 2 produces the search root/owner region, path or file-type filters, and candidate query vocabulary; Stage 3 returns bounded path/symbol/match candidates plus material filtering, truncation, empty-result, or execution-error evidence needed for refinement.
- Consequence: downstream users receive behavior guidance without a new dependency, installation step, cross-platform CLI surface, or generated maintenance artifact. A thin adapter is considered only after repeated real failures prove instruction plus native tools cannot preserve the contract.
- Evidence / Source: current conversation.

### D6 - Optional knowledge-assisted localization

- Status: confirmed.
- Authority: user-confirmed.
- Meaning: after workflow selection, source localization may progressively select technical knowledge from evidence. The first two stages still exclude source bodies: they maintain the current Session runtime localization map and may read one compact routed persisted technical map when evidence shows it can narrow the current owner/path/symbol decision.
- Boundary: persisted technical maps are optional accelerators, never prerequisites. A project with no applicable persisted map must still complete localization through directory/file names, deterministic search, and selected source evidence.
- Durable destination: `docs/sba-bible.md` principle 9.
- Evidence / Source: current conversation.

### D7 - Runtime map persistence boundary

- Status: confirmed.
- Authority: user-confirmed.
- Default: the technical map used during localization is a **runtime localization map** maintained progressively inside the current Session. It may live in model context, the harness-native Plan/current-step state, or a compact Task Anchor checkpoint, but it does not create a repository file, index, database, overview, module wiki, business leaf, or Gotcha.
- Content: candidate interpretations, current owner/module hypothesis, search root, path/type filters, query vocabulary, accepted and rejected evidence, unresolved questions, and the next action. Stage 2 makes its search contract explicit; Stage 3 matches and Stage 4 source traces update or falsify the map rather than creating a separate artifact after search.
- Compaction and lifetime: after context compaction, restore only the compact current owner/search contract/unresolved question needed for the next decision, not full trees, search output, or source-reading history. Discard the runtime map when the task ends unless a separate persistence decision passes.
- Persistent exception: create or refresh a persisted technical map only under real pressure such as repeated costly localization, a major repository reshape, stable source-of-truth/generated relationships, repeated newcomer/Agent ownership mistakes, or an explicit user request. Use the existing `profile-project` or `update-rules` lifecycle, store it under an action-routed technical `references/` owner, and require separate recording-value, activation, and maintenance judgments.
- Maintenance boundary: source evidence remains authoritative. Refresh an active persisted map when it becomes action-changingly wrong or source evidence contradicts it; retire it when it no longer changes localization decisions. Do not add timestamps, hashes, a mandatory manifest, a passive index, or periodic refresh work by default.
- Ownership boundary: a business leaf owns implementation-independent desired truth such as business types, macro flows, states, boundaries, and invariants. A technical map owns current code locations, classes, APIs, source roots, and generated/canonical relationships. A Gotcha owns a recurring costly failure pattern. A business leaf may supply terminology or constraints after delayed domain binding, but it is not a technical source map; move path/class/current-mapping details into a technical reference when the two are mixed.
- Durable destination: `docs/sba-bible.md` principle 9 and this Plan.
- Evidence / Source: current conversation.

### D8 - Internal-by-default interaction visibility

- Status: confirmed.
- Authority: user-confirmed.
- Default: the localization funnel and runtime map are internal black-box execution state. Ordinary users do not receive stage-by-stage narration, candidate churn, search mechanics, or raw intermediate evidence merely to prove the protocol ran.
- Normal output: expose the compact localization conclusion needed to make the result reviewable: owner/change point, supporting evidence, affected boundary, next action/proof, and residual uncertainty.
- Explicit visibility: when the user asks to inspect, audit, or display the localization process, expose the requested funnel stages and their decision-bearing evidence without dumping unbounded trees, matches, or source history.
- Decision visibility: surface an intermediate checkpoint even without an audit request only when the user must decide or authorize something: a normative choice remains, materially different owners or scopes survive, truncation materially affects confidence, the target premise fails, repository/ownership boundaries change, or mutation requires new authority.
- Boundary: concise progress updates may report the current outcome or blocker, but must not turn internal stages into a mandatory user-facing ceremony.
- Evidence / Source: current conversation.

## Proposed Localization Contract

### Trigger And Skip Gate

Enter the protocol only when the current workflow cannot name a sufficiently evidenced owner, entry point, symbol, source-of-truth file, or change point.

Skip it when the target is already concrete and a direct read/check can confirm it. Re-enter it when the target premise fails, multiple owners survive, a generated/shared boundary appears, or the observed call/data/state path contradicts the working conclusion.

The protocol is not a task route. `fix-bug`, `change-managed`, `plan-feature`, review, or another workflow remains the first workflow and owns task-specific meaning.

### Adaptive Evidence Funnel

| Stage | Current question | Preferred evidence/action | Output consumed next | Advance / return condition |
|---|---|---|---|---|
| 1. Outcome interpretation | What technical outcomes could the user's words mean? | User wording, selected workflow, known product/technical boundary, current Session runtime map, and at most one evidence-selected persisted project/source map; no repository source-body read | A bounded set of materially different technical interpretations with stated unknowns, recorded in the runtime map | Advance when one interpretation is evidenced or several concrete candidates remain; ask only if the unresolved difference is normative. |
| 2. Owner-region localization | Which repository/app/module/source-of-truth region could own that interpretation? | Bounded directory/file-name enumeration and, only when Stage 1 evidence selects it, one persisted routed module/source map; no source-body read | An updated runtime map plus a search contract: candidate search root/owner region, path or type filters, query vocabulary, and the reason for each boundary | Advance when the contract is narrow enough for deterministic search; return to Stage 1 if no candidate region can implement the outcome. |
| 3. Deterministic candidate search | Which exact symbols, strings, schema keys, routes, tests, or registrations express the behavior? | Consume the Stage 2 contract through harness-native `rg` or a proven repository-native index/parser; return bounded matches without surrounding implementation bodies | Bounded symbol/file/line candidates, relevance evidence, and any material filter/truncation/empty/error state | Advance when at least one candidate can anchor a semantic trace; refine the query or return to Stage 2 when results are empty, noisy, truncated, or searched under the wrong boundary. |
| 4. Decision-relevant trace | Which candidate is the actual producer/owner/change point, and how does the behavior flow? | First selected-source read into model context; then read only decision-bearing callers/readers/writers/guards/tests and trace control, data, state, provenance, generated source, or API/RPC paths as required | Current implementation fact, owner/change-point hypothesis, required semantic hops, and contradictions | Advance when every hop that can change the current decision is closed; return to Stage 2/3 when the trace crosses into another owner or disproves the candidate. |
| 5. Localization confirmation | Is this the correct owning boundary, and what else must stay consistent or prove the change? | Direct/indirect consumer check, source/derived mapping, contract/schema/test evidence, targeted history/runtime evidence when required | Final localization conclusion, reason, affected-path boundary, proof target, and explicit residual uncertainty | Exit only when the conclusion changes the next implementation/review action or satisfies the current read-only request. |

The funnel is adaptive, not mechanically linear. A known symbol may begin at Stage 3; a generated file may jump from Stage 2 to its canonical generator; contradictory tracing may return to Stage 1. Stages may discover more physical files when a real semantic path crosses boundaries, but the active hypothesis space and unresolved decision must become narrower. File count alone is not monotonicity.

## Runtime Map State And Persistence

The runtime localization map is the funnel's current decision state, not a document generated after search. It starts as soon as interpretation or ownership hypotheses exist and is refined only by evidence that changes the next action.

- **Runtime contents:** candidate meanings; current repository/app/module/source-of-truth owner; search root; path/type filters; query vocabulary; accepted evidence; rejected candidates and reasons; unresolved questions; next action.
- **Stage updates:** Stage 1 records interpretations and unknowns; Stage 2 records the bounded owner region and executable search contract; Stage 3 adds lexical candidates, empty/noisy/truncated/error evidence, and exclusions; Stage 4 replaces guesses with verified current-code facts and semantic hops; Stage 5 emits the compact final localization conclusion.
- **Default storage:** model context, harness-native Plan/current-step state, or a compact Task Anchor checkpoint. It creates no repository artifact and is discarded after the task.
- **Compaction recovery:** preserve only the current owner hypothesis, search contract, decisive evidence/exclusions, unresolved question, and next action. Do not restore full directory trees, raw search results, or all source snippets merely to recreate history.
- **Persisted-map admission:** ordinary localization never creates one. Repeated costly misses, structural repository change, stable generated/canonical relationships, repeated ownership mistakes, or explicit user demand may trigger a separate `profile-project` / `update-rules` decision.
- **Persisted-map activation:** storage alone is insufficient. A route or workflow must select the map from evidence, and reading it must change the next owner/search/source decision. A passive overview or index is not an activated map.
- **Refresh and retirement:** verify against source whenever a persisted map influences localization. Correct it when source contradiction makes it wrong; retire it when its premise disappears or it no longer changes action. No scheduled refresh, timestamp, content hash, mandatory registry, or repository-wide map generation is introduced.

### Business leaf, technical map, and Gotcha

- A business leaf remains the complete owner of desired business truth that survives implementation replacement. It can constrain interpretation only after evidence-delayed domain binding.
- A persisted technical map is a current-implementation reference: modules, paths, symbols, APIs, source roots, and source/derived relationships. It is always subordinate to fresh source evidence.
- A Gotcha records a recurring failure shape, root cause, tempting wrong shortcut, and prevention. It does not become a general module/source map.
- If a business leaf currently contains classes, paths, endpoints, or current mappings, preserve its normative rule and move the code-coupled mapping into an independently activated technical reference. Do not make every business leaf a localization map.

## Tool And Context Boundary

- Treat the funnel primarily as a **model-context exposure boundary**. A Stage 3 search tool may scan repository content, but source bodies do not enter model context until Stage 4 selects a candidate for semantic tracing.
- Stage 1 exposes intent/current task evidence, the compact runtime map, and at most one evidence-selected persisted project/source map; Stage 2 exposes bounded directory/file names and at most one evidence-selected persisted module/source map; Stage 3 exposes bounded lexical candidates; Stage 4 exposes selected source fragments. Persisted maps are optional fast paths and do not change the source-body boundary.
- Prefer deterministic repository tools for candidate generation: `rg --files`, `rg -l`, `rg -n`, language/server indexes, build metadata, structured manifests, or an existing code-intelligence tool when the project already owns one.
- SBA owns the tool-independent search contract, not the search implementation. Do not add a mandatory `search.sh`, install `rg`, or normalize every harness behind a new CLI unless repeated scenario evidence proves native execution cannot preserve the contract.
- Run broad matching outside full-source reading. Return path lists before content; return symbol/line matches before whole files; read only the fragment needed to choose the next hop.
- Do not dump the whole directory tree, full search output, every callsite, or every suspected consumer into context. Directory/file-name enumeration must also be filtered: “names only” is not permission to return the entire repository tree. Bound output by the current question and disclose when results were truncated or filtered.
- Use structured parsers/indexes when repository-native and reliable; do not require a new code graph, database, daemon, embedding index, or search runtime as part of SBA.
- The Agent owns semantic interpretation, query refinement, owner selection, call/data/state tracing, conflict handling, and stop/return decisions. Search tools do not decide business meaning or the final change boundary.

## Semantic Ownership

### Recommended shape

- New complete owner: `templates/skill/protocol-blocks/source-localization.md`.
- `task-execution.md`: one conditional activation hook when the current step cannot name its owner/path/symbol/change point; retain generic unresolved-question/evidence/advance-return ownership.
- `ambiguous-request-gate.md`: one hook when technical ambiguity requires repository localization before asking the user.
- `plan-feature.md`: one hook inside the implementation-fact Question Gate when the smallest concrete flow lacks an entry/owner.
- `fix-bug.md`: local trigger before reproduction/root-cause tracing when the failing behavior's entry/owner is unknown; acceptance requires the root cause trace to consume the localization result.
- `change-managed.md`: local trigger before source-of-truth/fan-out mapping when canonical ownership is unknown; acceptance requires the final source/derived map to consume the result.
- Review workflows receive a hook only if an actual review scenario cannot localize a finding through the changed diff and existing source Plan.

The complete funnel, stage transitions, skip/return behavior, and tool boundary live once. Consumers keep only the trigger, immediate action, current-task acceptance responsibility, and owner link.

The source-localization protocol owns the runtime map shape and its task-lifetime use, but it does not own persistent knowledge creation. `profile-project` / `update-rules` remain the admission and maintenance paths for an exceptional persisted technical map. Routed business leaves and Gotchas keep their existing semantic ownership and are never silently repurposed as source maps.

### Rejected shapes

1. **Copy five steps into every workflow.** Directly actionable but creates competing complete definitions and change fan-out.
2. **Put the full funnel in `task-execution.md`.** Reaches Managed tasks but bloats a generic lifecycle owner with code-specific procedure and loads irrelevant detail for non-source tasks.
3. **Add `localize-code` as a sibling task route.** A source-location subproblem must compose with Fix Bug/Plan/Change/Review; making it the first workflow would compete with task intent.
4. **Restore Minimal Sufficient Context as Always Read.** Recreates a deliberately removed co-loaded layer and makes all tasks pay for code-localization detail.
5. **Require a code graph/runtime index.** May be useful project tooling, but SBA should specify the retrieval contract and consume available tools rather than becoming a code-intelligence runtime.
6. **Implement a generic grep engine or mandatory wrapper.** This would add dependency, quoting, portability, output, ignore-rule, and downstream-distribution responsibilities without improving the semantic owner decision; use the existing harness/repository search tool behind one contract.

## Requirements And Acceptance

- Every localization stage declares its current unresolved question, fitted evidence, output, and advance/return condition.
- A command, path list, symbol match, file read, or successful exit code is not stage completion unless its output narrows the decision or is consumed by the next stage.
- The model-context boundary is enforced: no source-body read during Stages 1-2; Stage 3 performs deterministic tool-side search and returns bounded matches; Stage 4 is the first selected implementation read.
- Stage 2 produces a usable search contract and Stage 3 reports enough result-state evidence to refine or return; no mandatory SBA search executable, index, daemon, or tool installation is introduced.
- The runtime localization map is maintained in the current Session and discarded by default; ordinary localization creates no repository map, index, database, overview, module wiki, business leaf, or Gotcha.
- Applicable persisted technical maps are loaded one at a time from evidence and remain optional; absence of a map cannot block or degrade the completeness of the directory/file-name/search/source fallback path.
- A persisted map is admitted only through a separate recording, activation, and maintenance decision, remains subordinate to source evidence, and is refreshed or retired only when it changes active localization behavior.
- Business leaves own implementation-independent desired truth, technical maps own current implementation locations/relationships, and Gotchas own recurring failure patterns; none substitutes for another merely because it can narrow a search.
- Known targets skip irrelevant stages; failed premises return to the owning earlier stage instead of broadening to whole-repository reading.
- Deterministic search filters candidates before deep source reading. Only bounded, decision-relevant results enter context.
- The protocol preserves route-first and evidence-delayed domain binding. A domain keyword in a path/search result remains a candidate, not domain activation.
- Source-of-truth, generated/copied targets, producer/consumer chains, full/incremental/read/write paths, contracts, and tests are expanded only when the current trace activates them.
- No fixed Token/file/step threshold, code-graph dependency, persistent retrieval database, new routing DSL, or mandatory user-visible stage mode is introduced.
- Intermediate stages and runtime-map details remain internal by default. The final localization conclusion is reviewable; full or partial funnel evidence is surfaced only for an explicit localization-audit request or a decision/authorization checkpoint the Agent cannot resolve alone.
- Ordinary users do not choose search stages, tools, or file limits. They answer only a remaining normative question the repository cannot decide.
- The final localization result is compact: owner/change point, evidence, affected path, next action/proof, and residual uncertainty. It is runtime evidence, not a new durable artifact by default.

## Validation Scenarios

1. **Known symbol/local change:** begin at deterministic search or direct read, confirm one caller/test boundary, and skip intent/module inventory.
2. **Ambiguous UI/API behavior:** form bounded frontend/backend interpretations, identify candidate app/module paths, search exact route/schema identifiers, then trace only the selected API/state path.
3. **Exposure-order regression:** an ambiguous target cannot load source bodies while interpreting intent or enumerating owner regions; source enters model context only after deterministic search yields a selected candidate.
4. **Noisy keyword:** many lexical matches do not trigger whole-file reads; refine by owner/path/contract and return a bounded candidate set.
5. **No result:** an empty `rg` result keeps localization open, changes the query or returns to owner interpretation, and cannot be reported as “not implemented” without stronger evidence.
6. **Generated/copied file:** locate the observed output, follow provenance to the canonical generator/source, and prohibit editing the derived target as the owner.
7. **Cross-module trace:** allow the physical file set to grow only along the proven semantic path; stop when producer, write/state transition, guards, reader, and proof are decision-complete.
8. **Business-looking keyword in a technical task:** keep the domain unbound unless the unresolved decision actually depends on business type/flow/state/boundary/invariant.
9. **Read-only locate request:** return the owner/change point and evidence without entering mutation, validation, or Closure machinery that the request does not need.
10. **No-map project:** complete the entire funnel through bounded names/paths, deterministic search, and selected source reads; create no map file as a side effect.
11. **Stale persisted map:** use it only as a candidate accelerator, let contradictory source evidence return/refine the localization, and correct or retire the map through its separate owner rather than forcing code to fit it.
12. **Context compaction:** recover only the compact owner/search contract/decisive evidence/unresolved question/next action and continue without replaying full trees, raw matches, or prior source bodies.
13. **Ordinary black-box task:** run the funnel internally and return only the compact, reviewable localization conclusion without stage narration or raw candidate churn.
14. **Explicit localization audit:** expose the requested stages, evidence, exclusions, and return decisions while preserving bounded-output and source-exposure rules.

Validation must include conformance at the complete owner, thin-hook assertions at consumers, self-hosting scenarios that fail against broad/eager behavior, and fresh-agent forward runs on at least one known-target and one ambiguous-target repository task. Structural green checks alone do not prove reduced context or correct localization.

## Risks And Controls

- **Ceremony risk:** a rigid five-step checklist can slow known-target work. Control: explicit trigger/skip gate and adaptive entry.
- **False narrowing:** an early lexical match can prematurely exclude the true owner. Control: keep hypotheses/evidence explicit and return when tracing contradicts the candidate.
- **Call-chain explosion:** tracing every caller recreates broad reading. Control: close only hops capable of changing the current decision; defer suspected consumers.
- **Tool coupling:** requiring `rg` or a specific language server can break portability. Control: specify deterministic-search semantics, prefer `rg`, and allow repository-native equivalents.
- **Hidden truncation:** bounded output can omit the true candidate. Control: disclose filters/truncation and expand only when current evidence remains inconclusive.
- **Ownership duplication:** task workflows may restate the full funnel for convenience. Control: one complete protocol owner plus thin local hooks and conformance `must_not_contain` checks for copied stage procedures.
- **Persistence creep:** a useful runtime map can be mistaken for a reason to generate project indexes or wikis on every task. Control: Session-only default, explicit pressure-triggered admission, and no map artifact in the first release.
- **Stale-map anchoring:** an old persisted map can override current source evidence. Control: treat maps as candidate accelerators, require source verification, and correct or retire contradicted owners.
- **Semantic-owner mixing:** business leaves, technical maps, and Gotchas can accumulate the same path/class/rule content. Control: preserve desired truth in the business leaf, current mapping in technical references, and recurring failures in Gotchas with action-changing links rather than duplicate definitions.
- **Black-box opacity:** hiding all intermediate evidence can make a consequential conclusion impossible to judge. Control: always return the compact final evidence boundary, honor explicit audit requests, and surface checkpoints when user judgment or authority is required.
- **Unmeasured benefit:** structural activation does not prove context savings. Control: compare representative before/after reads and decisions while treating correctness/semantic completeness as non-negotiable gates.

## Likely Implementation Surface After Approval

The interaction contract is confirmed. The smallest expected implementation surface is:

- add the protocol owner and its template/conformance registration;
- add thin activation/acceptance hooks to the audited source-oriented workflows;
- update self-hosting summaries only where they must activate the same owner;
- add behavior-failure/scenario evidence for broad-read and premature-stop regressions;
- add an upstream-change note for downstream productized adaptations;
- run full Bucket A validation if templates, conformance, scripts, or generated routing/shell surfaces change.

No search script, grep engine, index service, dependency installer, generated search configuration, persistent map file, map manifest, module wiki, or repository-wide source overview is part of the expected first-release surface. The protocol may consume an already admitted and activated technical reference, but ordinary localization never creates or refreshes one; that remains a separate `profile-project` / `update-rules` task.

SBA Bible principle 9 now records the confirmed knowledge-assisted localization boundary. No new Bible principle or ordinary-task Always Read requirement is introduced.

## Implementation Status

Implementation completed on 2026-08-03 through the integrating [Requirement-Semantics Change Contract Plan](2026-08-03-requirement-semantics-change-contract.md). The 29-line `source-localization.md` protocol is the complete technical owner; its workflow hooks, conformance registrations, anti-duplication checks, known-target and ambiguous-target fresh runs, temporary downstream instantiation, and full Bucket A suite are green. The implementation adds no search executable, index service, task route, eager source read, or persistent localization map. This Plan is `done`; the later separately authorized Phase 2 adapted the verified owner into the canonical Chaos/chaos-web meta skills and assembled byte-identical 0.77 copies without changing business repositories.
