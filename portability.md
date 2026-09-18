# Portability — the harness story

**The principle:** the role contracts are the stable part; the harness is an adapter. This
package ships **pi** (`pi-coding-agent`) as the tested binding. Anything below marked untested is
labeled untested — the package's credibility rests on not blurring that line.

## What the tower actually uses from pi

The role contracts translate into seven concrete harness capabilities. A harness that has all
seven can run the tower unchanged; one that lacks any of them needs a workaround before the
contracts bind:

1. **Fresh-context children** — every reviewer/researcher/implementer dispatch starts clean, so
   authorship disjointness means something (a reviewer who shares the planner's conversation is
   not a reviewer).
2. **Per-child model selection** — the roster manifest's seats dispatch as their own models with
   thinking levels, not whatever the parent runs.
3. **Scoped agents** — read-only children (reviewers, researchers) and write-scoped children
   (implementers) as distinct capabilities; the write scope is part of the safety model, not a
   convention.
4. **File-only output routing** — children write durable artifacts through the harness (never
   pasting findings into chat for the parent to mediate), which is what makes adversarial review
   un-mediable.
5. **A supervisor/steer channel** — children can bounce mid-run for scope rulings (the
   escalation-judgment exemplar is literally this), and receive supervisor replies without
   ending their run.
6. **Async completion with parent wake** — the parent keeps working while children run; each
   completion notifies. Without this, "the tower eats concurrently" collapses into serial
   queueing.
7. **Durable child records** — the per-run records (`events.jsonl` in pi) that make every
   child's output recoverable byte-exact. **This is the recovery backbone:** the source project's
   anomaly log documents a live episode where the primary output path flickered and these records
   were the reason nothing was lost. A harness without a per-run record equivalent loses the
   tower's crash tolerance.

## The tested bindings

**pi (the reference binding, this package).** All seven capabilities, exercised heavily: ~70
async runs in the source project's peak day, including concurrent implementer + judge + CT in one
tree with the lock discipline holding.

**Cursor sessions as subject seats (tested, the source project's live demonstration).** The
model trials ran Grok subjects as independent Cursor sessions while the judge and coordinator ran
on pi — the tower's first documented **cross-harness** operation: the briefs and artifacts lived
in the shared repo, the Owner moved between hosts, and the tower's discipline (per-subject output
paths, frozen artifacts, baseline snapshots for adjudication) is what made it work. The lessons
that generalize: subjects need only file read/write + a session that reports its own identity;
the judge needs the frozen artifacts, not the live sessions.

## The untested bindings (honest)

**Claude Code.** Has subagents with fresh context and per-child models; the output routing and
async-wake shapes differ from pi's, and this package has not verified the seven capabilities
against it. Adapters should start from the skills' contracts, not from pi's invocation syntax.

**Cursor as a full tower host.** Tested as subject seats (above); NOT tested with the lock
protocol, the concurrent-writer rules, or the artifact pipeline running inside Cursor sessions.
The known friction (from the source project's history): session-per-role works, but the shared
lock and the checkpoint discipline need a shell-capable coordinator — which is what the CT seat is.

**Scripted/CI harnesses.** Nothing in the contracts requires interactive AI at every seat — a
CI-planned reviewer or a scripted researcher is contract-compatible — but no such binding exists
yet. The v2 wizard's manifest is the natural machine interface.

## The known harness quirks (the source project's receipts)

- **Benign "failed" presentations:** children can complete with full output yet report failure
  (a persist-step interruption); the durable records recover every byte. Recover before
  believing a failure.
- **Filesystem flicker under endpoint-security agents:** session trees can flicker
  (readdir-vs-stat) under managed machines; the per-run records stayed immune in the source
  project's heaviest day. Retry-then-parent-walk before concluding anything is missing — and
  keep a standing anomaly log (`templates/anomaly-log.md`): evidence means verbatim, and the
  recovery path's immunity is a design fact worth recording as it happens.
- **Skill pins drift from rulings** when the roster is embedded in skill files rather than a
  manifest — the v2 design's motivating evidence.

*Adopters running other harnesses: append your binding's findings here — the file is a standing
record, not a one-time doc.*
