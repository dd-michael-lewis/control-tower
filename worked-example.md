# The worked example — pointers into the source project's record

**What this is:** the package's receipts, as links. The source project (Apotheosis, an iOS/tvOS
media client) generated every guardrail in the Tower Block against real failures; this file maps
each guardrail to the record that earned it. **What it is not:** a copy of the source project's
domain spec. The links are for adopters reading the source repo; nothing Apotheosis-specific
ships in the package.

## The receipts map (guardrail → the record that generated it)

| Guardrail (Tower Block section) | The receipt (source-project record) |
|---|---|
| **Checkpoint before you can lose it** (durability) | The data-loss incident doc: an agent destroyed ~18 hours of never-staged work making the world match its own narrative — `Backup/Apotheosis/INCIDENT-2026-09-09-agent-data-loss.md`. Read the recovery story: every edit recovered from the harness's own transcripts. |
| **Authorization in the turn** (destructive ops) | The same incident: the agent's *own plan* was its authorization. "Never make the world match your description; reconcile your description to the world" is quoted from the post-mortem. |
| **Stage by path, never `-A`** (concurrent writers) | The second incident, 24 hours later: three `git add -A` commits absorbed another agent's in-flight docs into unrelated WIP titles — provenance lost, exit code zero, the tree clean. It *looked like success.* |
| **The watermarks** (review cadence) | Months of review history with no machine-findable continuity before `Reviewed-through` existed — the drift was discovered only by hand when a range was silently skipped. |
| **The lock (lease-based, atomic mkdir)** | The lock's own design history: the first in-file lock was non-atomic (two agents could both read "none"); the PID-based version failed its first test (sessionless harnesses have no stable process). The lease design is in the block because both predecessors failed live. |
| **The diagnosis discipline** (§10-equivalent) | The 17-round reviewer trial's costliest miss (`REVIEWER_TRIAL.md`): an implementer accepted a plausible, well-cited reviewer claim and propagated it across five locations before checking whether project history had settled the question the other way. |
| **The Cemetery** | The re-derivation tax: fresh sessions regenerating their predecessors' dead hypotheses first — the entry-format doc records the tvOS investigation where 3 of 4 buried hypotheses were the investigating model's *own* prior ideas. |
| **Per-subject output paths** (trial discipline) | The planner-round collision: three subjects, one shared filename, two drafts lost. The harness-obligation ruling and the behavioral law (agents comply, they do not coordinate) are one afternoon's receipts. |
| **The escalation metric** (both exemplars) | The death-loop: 23 turns / 132k input tokens / zero writes / no commitment to any judgment — against the bounce: one round-trip, a real contradiction caught, the resolution *with its verification* attached. Both are in the trial record with their transcripts. |
| **Durable child records as the recovery backbone** | The source project's anomaly log (kept with its incident records, not shipped in the package): a live multi-minute flicker episode where the primary output path vanished and the per-run records recovered every byte — including the doc that records it. The pattern ships as `templates/anomaly-log.md`. |

## The numbers (measured, not asserted)

The pre-tower/post-tower commit-classification study, from git, both eras, verifiable by anyone
with the repo: **the last 300 commits before the tower went online were 71% process-only** (212
of 300; 6.3 source commits/day) — process overhead *without* insurance; the incident docs are
what it failed to prevent. The first 36 hours under the tower: **83% process-only** (108 of
130) — the overhead went UP — buying **2.3× source velocity** (14.7 commits/day), 12+ units
through the full brief→implement→review→checkpoint chain, zero unreviewed code, zero
provenance breaks, zero lost work. The framing adopters should carry: the tower does not
reduce process overhead; it *purchases* velocity and survivability with it.

## The records to read in order (an adopter's syllabus)

1. `Backup/Apotheosis/INCIDENT-2026-09-09-agent-data-loss.md` — the catastrophe, and why
   "uncommitted is a synonym for one copy."
2. The AGENTS.md rule sections the incidents generated (the source repo's, not the template's) —
   watch how each rule cites its receipt inline.
3. `HANDOFF.md`'s checkpoint stack — a real running record; note the `**Author:**` + mechanical
   runtime-identity discipline on every entry.
4. The review chain exemplars in `docs/reviews/` — pick any unit's fold review → revision →
   confirm → implementation → diff-review sequence and watch the gates catch real defects at
   each stage (the fold-review chain that rejected a security unit's invented numbers three
   times before a measurement settled them is the best single example).
5. The trial records in `docs/evals/grok-eap-comparison-2026-09-17/` — the de-framed task texts,
   the frozen artifacts, the adjudication annexes, and the rubric with its lived exemplars
   (including the escalation bounces and the evidence corrections a child filed against its own
   supervisor — the tower checks its architect from below, and the record shows it).

## What NOT to copy

The source project's security spec (§0–§5 of its AGENTS.md) is *its* threat model — a
credential-bearing third-party client's. Copying it into your project inherits constraints your
codebase never earned. The template's slots exist precisely so your domain rules are yours; the
block's discipline is the portable part, and the block ships complete.
