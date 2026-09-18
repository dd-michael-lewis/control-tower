# The constraint-doc form (the Researcher's output contract)

Six sections, every claim labeled. An unlabeled claim is a defect.

1. **Method** — what was inspected, at which commit SHA, read-only.
2. **Facts (labeled)** — [VERIFIED] claims cite file:line; [INFERRED] claims state what they block;
   [ASSUMED] claims are marked as assumptions.
3. **Baseline** — the commit the doc was authored against; the doc cites it and retires with drift.
4. **Counter-hypotheses** — each named, each marked checked (the separating code was verified) or
   not-checked, with the separating code/log named either way.
5. **Cemetery candidates** — hypotheses this investigation killed, with the evidence.
6. **Open questions** — what this doc does NOT settle; inconclusive is a deliverable.

The coverage index (INDEX.md) lists each subsystem, its constraint doc, baseline SHA, and date.
A plan citing a claim tagged [INFERRED], or touching a subsystem with no coverage row, fires the
Researcher fidelity gate before implementation.
