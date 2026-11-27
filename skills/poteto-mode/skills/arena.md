---
name: arena
description: "Spawn N parallel candidates at the same task, pick a base, graft the strongest parts of the losers into it. Use for 'arena this', 'throw it in the arena', or when one attempt at a non-trivial artifact would lock in the wrong shape."
disable-model-invocation: true
---

# Arena

Track progress in a todo list with one entry per phase (Frame, Fan out, Cross-judge, Pick, Graft, Verify) before launching anything.

## Phase A: Frame

Every candidate gets the same prompt, so the prompt is the contract.

1. State the artifact each candidate is producing.
2. Derive the rubric, 3-6 concrete gradeable criteria for what success looks like on *this* task. It is the picker's tool in Phase D. Candidates only see the task.
3. Pick the panel seats from [models.md](../models.md). Keep at least two independent runners for a panel verdict and name missing seats. Spawn more for multiple design directions, and repeat one model only when generation, not independent judgment, is the constraint.
4. **isolate** each writing candidate in a worktree at the same base (or give non-repository artifacts disjoint output directories), per the [separate-before-serializing-shared-state](../principles/principle-separate-before-serializing-shared-state.md) principle skill.

## Phase B: Fan out

Use **spawn** for all N candidates before **wait**. Give each the same task and shared grounding path, its own output path, and instructions to produce the artifact and a short rationale naming the alternatives it considered and what it rejected.

If a candidate produces no output, proceed with N-1 and note the dropout.

## Phase C: Cross-judge

After all Phase B candidates stop, **spawn** one read-only cross-judge per [models.md](../models.md). The judge scores each candidate by path label on each rubric criterion and recommends a base while you read in Phase D. If no eligible different-vendor judge can run, report the omission.

## Phase D: Pick a base

Read every candidate end to end before picking. Score each against the rubric criterion by criterion, not on holistic feel, and compare with the cross-judge when Phase C ran one. Agreement on the base confirms the pick. Disagreement means one of you is biased or the rubric was ambiguous. Read both rationales before deciding.

Pick the base a future maintainer can extend most easily without breaking invariants. When two feel tied, prefer the cleaner boundary or smaller API, per the [Laziness Protocol](../principles/principle-laziness-protocol.md).

## Phase E: Graft

Walk each losing candidate once more for what is worth porting into the base, usually one or two things per candidate, not most of it. Fold each graft in by hand, per the [redesign-from-first-principles](../principles/principle-redesign-from-first-principles.md) principle skill, so the result stays coherent under one mental model. Don't paste mechanically.

If the candidates converge on one shape, that is strong agreement. Note it and ship the consensus shape. No graft is needed. If they wildly diverge, Phase A was under-specified. Reframe and re-run rather than averaging the divergence.

## Phase F: Verify

Verify the synthesized artifact like any other output, per the [prove-it-works](../principles/principle-prove-it-works.md) principle skill. If verification finds a problem the arena missed, either Phase A was wrong (re-frame and re-run) or a candidate caught it and you missed the graft (go back to Phase E). Don't paper over it.

## Outputs

One synthesized artifact, with a short synthesis note alongside naming the base and why, the cross-judge's verdict or that Phase C skipped the judge, each graft with its source candidate, what was rejected and why, any convergence or dropouts, and the verification result. Use **close** after collecting the reports and preserving the artifacts you need.
