---
date: 2026-08-13
status: done
requirement: prd.md
supersedes:
  - ../2026-08-12-requirement-first-planning.md
distilled_to:
  - ../../sba-bible.md
  - ../../../templates/skill/workflows/define-requirement.md
  - ../../../templates/skill/protocol-blocks/change-contract.md
  - ../../../templates/skill/workflows/plan-feature.md
  - ../../../templates/skill/workflows/task-execution.md
  - ../../../templates/skill/workflows/change-managed.md
  - ../../../templates/skill/routing.yaml
  - ../../../references/self-hosting-routing.yaml
  - ../../../references/protocols.md
  - ../../task-anchor-native-plan.md
  - ../README.md
  - ../_TEMPLATE.md
  - ../../../scripts/scaffold-downstream.sh
  - ../../../templates/skill/conformance.yaml
  - ../../../references/self-hosting-conformance.yaml
  - ../../../scripts/check-self-scenarios.sh
  - ../../../scripts/check-validation-contract.sh
  - ../../../UPSTREAM-CHANGES.md
---

# Implementation Plan: Separate Requirement Definition From Implementation Planning

> Governing Requirement: [`prd.md`](prd.md). This Plan consumes that owner
> one way. It does not repeat or amend the Requirement; normative changes return
> there before this design is revised.

## Current Implementation Facts

- `templates/skill/protocol-blocks/change-contract.md` already owns the complete
  runtime translation and implementation-binding state, but its Requirement
  Contract dimensions and the boundary between semantic and technical phases
  were implicit.
- `templates/skill/workflows/plan-feature.md` owned requirement readiness,
  question gating, user-confirmed decisions, brainstorm handoff, technical
  evidence, design slices, artifact pressure, and Task Breakdown. Users can
  independently request “先讨论需求，不要写 Plan” and “基于确认需求写实现 Plan”,
  proving independent selection pressure.
- The previous flow derived a Native Plan immediately after
  `requirement-ready`, even when canonical owner, Current -> Target, and the
  affected technical path were not yet proven.
- `templates/skill/routing.yaml` routed “先帮我把这个需求问清楚” to
  `plan-feature`; self-hosting product direction and implementation planning
  also shared one workflow.
- `scripts/scaffold-downstream.sh` renders project-specific light workflows
  rather than copying every upstream workflow, so a canonical owner change must
  be explicitly carried by light materialization.
- `docs/plans/README.md` and `_TEMPLATE.md` described a Plan as a combined
  requirement/design/implementation contract. Task Anchor documentation
  already separated desired meaning, but its flow still presented Anchor and
  Native Plan as one immediate pair.
- The completed 2026-08-12 Plan established requirement-before-Plan ordering
  and no-question/no-artifact fast paths. This successor preserves those results
  while replacing its future-facing owner allocation.

## Target Binding

| Owner | Implementation responsibility | Forbidden responsibility |
|---|---|---|
| `define-requirement.md` | interaction order for evidence, Requirement brainstorm, minimum normative clarification, optional Requirement artifact gate, and readiness handoff | implementation tasks, file design, mutation, proof commands, or Plan lifecycle |
| `change-contract.md` | runtime Requirement readiness and later Implementation Binding state | routing, persistent artifacts, or Native Plan state |
| `source-localization.md` | Current behavior, canonical owner/change point, affected technical path, feasibility, cost, and risk | desired product meaning |
| Task Anchor | current-Session Goal/Done When/Boundaries projection | complete Requirement storage or implementation steps |
| `plan-feature.md` | technical options, Current -> Target design, impact/risk/recovery, proof implementation, task interfaces, dependency order, and optional Plan artifact gate | creating or editing a Governing Requirement |
| Native Plan | current implementation steps and verified step status | requirement authority or durable design truth |
| Closure | compare implementation and requested delivery to Requirement acceptance | redefining acceptance after green |

The bound runtime progression is:

```text
requirement-ready
  -> Task Anchor projection
  -> localization-required / owner-proven
  -> binding-incomplete / implementation-ready
  -> Implementation Plan / Native Plan
  -> mutation and fitted proof
```

## Implementation Decisions

### D1 - Add one independently selectable Requirement Definition workflow

Create `templates/skill/workflows/define-requirement.md` as an interaction
workflow, not another runtime protocol or state store. It consumes the Change
Contract, uses Source Localization for technical facts, and invokes the minimum
question gate only for a remaining normative blocker.

Its independent Artifact Pressure Gate defaults to Session-only Requirement
state. When the user explicitly requests a PRD/Requirement, or a real reader,
review, recovery, validator, lifecycle, or handoff requires one, it creates or
updates the smallest Governing Requirement without invoking Plan Feature.

### D2 - Make Plan Feature a strict consumer

Remove Requirement Definition, normative brainstorm ownership, and
Requirement-artifact creation from `plan-feature.md`. Its intake sequence is:

1. consume a `requirement-ready` source;
2. project its outcome/acceptance/boundaries into Task Anchor state;
3. prove Current behavior, canonical owner, Current -> Target, affected path,
   and fitted proof boundary through Source Localization;
4. reach `implementation-ready`;
5. derive technical design, Task Interfaces, and Native Plan steps;
6. apply the independent Plan Artifact Pressure Gate only when a durable
   implementation-design owner is needed.

If technical evidence exposes a normative gap, return to Requirement
Definition. Plan brainstorming remains limited to technical alternatives that
preserve the same Requirement.

### D3 - Preserve one runtime contract and one step owner

Refactor `change-contract.md` into visible Requirement Contract and
Implementation Binding phases without creating another ledger. Task Execution
establishes the Anchor after `requirement-ready`, but delays Native Plan
derivation until `implementation-ready`.

Technical evidence may update binding and Plan state. Evidence that changes
Requirement meaning must first return to Requirement Definition; Task
Execution may re-project the Anchor only after the Requirement is ready again.

### D4 - Separate acceptance truth from proof implementation

Requirement Definition records observable acceptance without selecting a test
framework or command. Plan Feature maps each acceptance criterion and material
risk to the cheapest truthful evidence. A proof that needs an unstated expected
result returns that gap to Requirement Definition.

### D5 - Activate the split without exporting author complexity

- Add independent Requirement-only routes to self-hosting and full template
  routing.
- Keep `change-managed` as the first route for direct implementation requests;
  it performs the internal handoff without making users re-route.
- Carry the same boundary through direct, Folder-light, routed, and broad
  materialization.
- Add no Always Read entry, universal PRD, question log, brainstorm store,
  mandatory Plan file, or second Native Plan.

### D6 - Give durable Requirement and Plan separate carriers

Apply Requirement and Plan Artifact Pressure independently. A Requirement-only
delivery may stop at `prd.md`. When both carriers are admitted, store normative
authority in `prd.md` and implementation design/lifecycle in `design.md`; the
Plan points to the Requirement through `requirement: prd.md` and an explicit
body link. The Requirement never points back or mirrors Plan state.

Focused Plan-only records may remain one dated file when the Governing
Requirement is an authoritative external or Session source. Existing frozen
Plans remain history rather than being mechanically rewritten.

## Requirement Input And Proof Mapping

- `R1`, `R4`, and `R5` are protected by durable-carrier review plus fitted
  conformance, scenario, and controlled owner-inversion mutations.
- `R2` and `R3` are protected by clear and incomplete natural-language
  scenarios, with live Agent evidence reported separately from structural
  checks.
- `R6` is protected by ordering and authority mutations that independently
  reject direct Anchor rewrites and Plan-owned normative changes.
- `R7` is protected across direct, Folder-light, routed, and broad fresh
  materialization paths.
- `R8` is protected by proof-layer reporting that distinguishes structural,
  migration, and live behavior claims.

## Task Interfaces

### Task 1 - Establish Requirement Definition ownership

- **Files:** `templates/skill/workflows/define-requirement.md`,
  `templates/skill/protocol-blocks/change-contract.md`, `docs/sba-bible.md`.
- **Consumes:** Governing Requirement `R1`-`R4` and D1/D3/D4.
- **Produces:** one Requirement interaction workflow, one canonical runtime
  contract, an independent Requirement artifact gate, and explicit
  acceptance/proof separation.
- **Acceptance:** Requirement-only work can finish without implementation
  design or mutation; missing normative meaning cannot be guessed.

### Task 2 - Narrow planning and runtime execution

- **Files:** `templates/skill/workflows/plan-feature.md`,
  `templates/skill/workflows/task-execution.md`,
  `templates/skill/workflows/change-managed.md`, and consumers of moved anchors.
- **Consumes:** ready Requirement, Source Localization output, D2-D4.
- **Produces:** `requirement-ready -> Task Anchor -> implementation-ready ->
  Native Plan -> mutation`, Plan-only technical design, and precise return
  behavior for normative gaps.
- **Acceptance:** no Plan is derived from an incomplete Requirement or unproven
  owner; technical evidence cannot directly rewrite Anchor meaning.

### Task 3 - Activate self-hosting and downstream behavior

- **Files:** routing manifests, generated shells, materialization owners, and
  their fitted checks.
- **Consumes:** D1, D3, D5 and current materializer evidence contract.
- **Produces:** Requirement-only routing, Plan-only routing, automatic direct
  feature handoff, and conditionally materialized light behavior.
- **Acceptance:** explicit Requirement-only work cannot enter implementation;
  direct feature requests need no user re-routing.

### Task 4 - Align durable documentation

- **Files:** `references/protocols.md`, `docs/task-anchor-native-plan.md`,
  `docs/plans/README.md`, `docs/plans/_TEMPLATE.md`, and this dossier.
- **Consumes:** D3/D4/D6.
- **Produces:** independent artifact gates, `prd.md` Requirement authority,
  `design.md` Plan lifecycle, one-way consumption, and Anchor authority rules.
- **Acceptance:** no current documentation assigns Requirement ownership to a
  Plan, Task Anchor, or proof mechanism.

### Task 5 - Mutation-protect and close

- **Files:** fitted conformance, scenarios, validation mutations,
  `UPSTREAM-CHANGES.md`, and this Plan's evidence.
- **Consumes:** Tasks 1-4 and the Governing Requirement acceptance IDs.
- **Produces:** baseline, controlled negative mutations, materialization matrix,
  upstream guidance, and final reconciliation.
- **Acceptance:** each historical authority inversion independently makes the
  fitted contract red while correct fresh carriers remain green.

## Implementation Order And Return Conditions

1. Implement Task 1 without entering Plan mechanics.
2. Implement Task 2 and repair every moved-anchor consumer before routing.
3. Implement Task 3 as one activation unit and inspect fresh materialization.
4. Implement Task 4, including the physical Requirement/Plan split.
5. Implement Task 5, run baseline and independent mutations, then fitted
   scenarios and the Bucket A suite.
6. Reconcile the final owner graph and freeze this Plan at `done`.

Return to Requirement Definition before further mutation whenever technical
evidence would change a governing goal, scope, model/flow, rule, constraint,
preservation, permission, or acceptance. Rebind and replan directly only when
the Requirement remains unchanged.

## Technical Open Questions

None. The Governing Requirement fixes the authority and artifact boundaries;
current evidence closes the remaining owner, routing, materialization, and
proof decisions.

## Implementation And Closure Evidence

- Canonical ownership was separated without a second runtime ledger:
  `define-requirement.md` performs Requirement interaction,
  `change-contract.md` owns runtime readiness and binding, Source Localization
  proves Current ownership, Task Anchor projects Goal/Done When/Boundaries, and
  `plan-feature.md` derives revisable technical means after
  `implementation-ready`.
- Self-hosting routing, generated shells, direct/Folder-light/routed/broad
  carriers, existing-project migration, durable archive docs, and affected
  lifecycle consumers preserve `requirement-ready -> Task Anchor ->
  implementation-ready -> Native Plan -> mutation` without mandatory
  artifacts.
- Original implementation proof passed Requirement/Plan validator mutations
  `24/0`, self-hosting scenarios `606/0`, template conformance `672/0`,
  self-hosting conformance `662/0`, routing generator checks, self-shell
  equality, Bash syntax, and whitespace validation.
- The original full `bash scripts/check-all.sh --base HEAD` run exited `0` and
  covered materialization/migration, routing/shell checks, smoke,
  orphan/reachability, path integrity, controlled mutations, scenarios, and
  both conformance layers. These checks proved their deterministic contract,
  not all live Agent behavior.
- Independent read-only forward behavior was reported separately: the
  incomplete business-rule request passed by returning concrete understanding,
  real boundary risks, and one normative question without a Plan or mutation;
  the clear feature probe and optional external validator had no verdict.
- The original implementation and requested local Closure were complete. No
  external delivery was part of that Closure claim.

This later archive correction splits the formerly mixed file into independent
Requirement and Plan carriers. Its current validation evidence belongs to the
delivery that changes the archive contract and is not backfilled into this
frozen implementation evidence.

### Archive-Correction And Carrier Evidence

- The former mixed carrier is now physically split: `prd.md` preserves the
  Governing Requirement and source-faithful user clauses; `design.md` owns
  Current facts, Current -> Target design, tasks, proof, and lifecycle through
  a one-way `requirement: prd.md` edge.
- New carrier rules distinguish three pressure-fitted shapes: a Requirement-only
  dossier may stop at `prd.md`; an external/Session-backed focused Plan may use
  one dated `.md`; when both durable owners exist, the Plan is `design.md` and
  never uses `prd.md` as its technical or lifecycle owner. Frozen historical
  Plan-shaped `prd.md` records remain unchanged audit history.
- The same boundary is active in Large Plan synthesis, confirmed implementation
  gap intake, light downstream materialization, archive/template documentation,
  and database-change dossiers.
- Fresh direct validation passes on the final source: template conformance
  `718/0`, self-hosting conformance `707/0`, self scenarios `663/0`, and the
  controlled mutation/materialization contract `24/0`. The mutation set rejects
  deletion of the separate-carrier/link/no-`prd.md`-Plan-owner clauses and
  independently rejects injection of the old `prd.md` technical-owner claim.
- Semantic Before/After checks pass `12/0`: the actual user source clauses remain
  in `prd.md`; Current Implementation Facts and Task Interfaces exist only in
  `design.md`; the one-way Requirement link is present.
- Fresh `bash scripts/check-all.sh --base HEAD` exits `0` after the correction
  and ends with “All deterministic upstream structure and contract checks
  passed.” Live Agent behavior remains a separate downstream/installed proof
  and is not inferred from this deterministic result.
