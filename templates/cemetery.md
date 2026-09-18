# The Cemetery (§10.7) — ruled-out hypotheses that survive session boundaries

One line per corpse: the hypothesis, the evidence that killed it, and — where the answer was a
measurement — the measurement itself.

**Rules:**
- A hypothesis goes in only when something killed it. "We didn't get to it" is a next step, not a
  burial. A padded Cemetery is worse than none — it stops the next session from testing live ideas.
- Carry it forward: when a checkpoint supersedes an earlier one, the Cemetery is inherited.
- Exhume when the ground changes: a refutation is valid against the code that was measured. If the
  relevant code changed, say so explicitly rather than leaving a stale "do not revisit."
- Confidence labels apply: "refuted by measurement" and "refuted by reasoning" are different
  claims, and the difference is exactly what a later session needs to decide whether to re-test.

**Worked example shape:**
- Environment-invalidation cascade from `\.entryAction` — the liveness probe returned ok at the
  grace gate; nothing invalidated. [Refuted by measurement]
- Deprecated value-form navigation push as the freeze cause — the baseline pushes cleanly and does
  not freeze. [Refuted by measurement]
