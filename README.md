# The Control Tower

A multi-agent workflow harness for a solo developer running AI coding agents on a real project.
Five roles, one human Owner, a set of artifacts that survive session boundaries, and a lock that
keeps concurrent agents from eating each other's records. This package is the portable version of
a tower that was built — not designed — over one project's real incidents. The receipts are linked;
every guardrail exists because something failed without it.

**The one-sentence version:** the tower turns "AI agents in a codebase" into an organization with
written memory, adversarial review, role separation, and a routing discipline that keeps every
decision the human's.

## What you get

```
tower/
  README.md              ← this file (the start-here)
  AGENTS.template.md     ← the portable process skeleton; your project's AGENTS.md
  skills/                ← the pi-bound role contracts (implement/review/research + the lock helper)
  scripts/handoff-lock.sh  ← the shared-document lock (lease-based; no PID folklore)
  templates/             ← the artifact templates: HANDOFF, BACKLOG, the diagnosis block,
                            the Cemetery, the constraint-doc form, the trial record
  portability.md         ← the harness story: pi is the tested binding; the contracts are the stable part
  worked-example.md      ← pointers into the source project's real record (the receipts)
```

## The roles

- **Owner** — you. The routing destination for every design, product, and policy decision. Nothing
  happens silently; nothing gets decided by an agent that was yours to decide.
- **Control Tower (CT)** — the standing coordination session: writes the briefs, dispatches the
  children, holds the lock, keeps the checkpoint, owns the process errors *on the record*. The CT
  seat rewards speed and reliability, not depth — the depth lives in the specialist seats, and the
  safety net converts accuracy into a shared property instead of a personal one.
- **Planner** — scopes work into units with acceptance conditions; writes plan drafts; never
  resolves the Owner's forks. **The setup distinction (read before staffing):** the source project
  runs the **CT-as-Planner shape** — the coordinator absorbs the planning seat (its
  `planner-subagent` skill was shelved when that happened, preserved, and now ships in this
  package as `skills/planner-subagent-SKILL.md`). Adopters can follow either path — a dedicated
  Planner child or the CT-as-Planner shape — and **the lineage rule binds either way:** whichever
  session authors a plan, a disjoint session reviews it.
- **Implementer** — writes the code and tests; commits under attribution rules; bounces design
  defects upward instead of absorbing them.
- **Reviewer** — fresh-context review of plans, diffs, and evidence; write scope is the findings
  doc only; never commits.
- **Researcher** — establishes ground truth; writes constraint docs with labeled claims; keeps
  the Cemetery of ruled-out hypotheses.

## Name your chimera

The stack is a chimera — a composite creature where each part has its nature (the coordinator's
speed, the implementer's discipline, the reviewer's depth, the researcher's rigor) and none
pretends to be whole alone. The tower is what makes it one animal instead of a pen of
incompatible beasts: the roles are the anatomy, the lock the nervous system, the artifacts the
shared memory. **Your chimera's name is yours to mint at the moment you fill its seats** — and the
best names carry the roster *and* its history. The source project's is `gogls^a`: **G**LM in the
tower, **O**pus in the review chair, **G**emini and **L**una in the utility seats, **S**ol —
lifted to **A**stra, the one roster change the Owner ruled, written into the name as the
exponent. A name like that is a versioned manifest in miniature: the roster is the letters, the
changelog is the exponent, and the next seat change moves it. Name yours the same way and it will
tell your tower's story every time you type it.

**The lore, for those who want the full story:** the source project's tower is named **gogls** —
the roster as a word: **G**LM in the coordinator's chair, **O**pus holding the review seat,
**G**emini in the utility seats, **L**una as the eyes, **S**ol in the research chair. Then Sol
was lifted to **A**stra — one roster ruling, one model change — and the exponent recorded it:
**gogls^a**. The name is a versioned manifest in miniature: the letters are the roster, the
exponent is the changelog, and the next seat change moves it. Around the tower this became law —
*names carry history the way commit trailers do* — and the working motto came from a wrestler:
**FEED ME MORE.** The chimera does not sleep; it feeds. Every session that lands one unit and
immediately asks for the next is the tower working as designed.

## The five-minute adoption

1. **Copy** `AGENTS.template.md` to your repo root as `AGENTS.md` (and `CLAUDE.md` if you use
   Claude Code — keep them byte-identical; the lock's mirroring rule).
2. **Fill the domain slots** — the template marks every place your project's own spec belongs:
   the threat model (what IS your §0), the domain rules (what IS your §1–§5), the stop conditions,
   the heavy-tier rows. The Apotheosis worked example is linked, not shipped.
3. **Copy the skills** into your pi agent's skills directory, and `scripts/handoff-lock.sh` into
   your repo (or the package's path).
4. **Make the adoption rulings** (the template's first section lists them): your model roster and
   model-lock, your review cadence, your tier table, your artifact names, your lock lease times.
5. **Start small:** one trivial-tier unit through the full chain — brief → implement → review →
   checkpoint — before you run anything heavy. The first unit's job is to shake out your config,
   not to ship product.

## The invariants (what actually makes it work)

1. **Written memory beats session memory.** HANDOFF (the checkpoint doc), BACKLOG (the durable
   task list), CURRENT_PLAN (the two-slot pipeline). A fresh session reads before it writes. A
   session with meaningful work updates the checkpoint before it ends — even uncommitted.
2. **The watermarks.** `Reviewed-through` and `Handed-off-through` are contiguous history
   watermarks, not SHA counters. Out-of-order passes are recorded ahead, never leap the mark.
3. **The lock.** One coarse filesystem lock (atomic `mkdir`) over the shared narrative documents,
   lease-based (never PID-based — sessionless harnesses have no stable process to probe), held
   through the entire edit-and-commit, released after. Expired leases are mechanical evidence;
   live ones are never forced.
4. **Disjointness.** The session that authored a plan, its evidence, or a task text never verdicts
   the output. Where no disjoint reviewer exists, disclosed self-review — naming what was
   re-checked — is the only permitted substitute.
5. **The diagnosis discipline.** Every stated cause carries the block (claim / confidence /
   evidence / does-not-prove / counter-hypotheses / cheapest refutation) with a fixed label
   vocabulary. Banned below CONFIRMED: "the root cause is," "this will fix it."
6. **The Cemetery.** Every investigation that closes or pauses records its dead hypotheses, with
   the evidence that killed them. Cumulative for the investigation's life; exhumed only when the
   ground changes.
7. **Stage by path, never `-A`.** Concurrent writers name their files. A durability commit that
   sweeps another agent's in-flight work is a provenance break even when nothing is lost.
8. **The checkpoint precedes the danger.** A WIP commit never violates "don't change code" —
   saving is not changing — and destructive operations need authorization in the turn, not in a
   plan you wrote yourself.
9. **Per-subject output paths.** Multi-agent trials and parallel dispatches name unique output
   files. Exclusivity is a harness obligation, never a subject behavior to hope for: agents
   comply with instructions, they do not model peers.
10. **The model lock.** The implementer's model is not switched mid-flight without an explicit
    Owner instruction. On failure: stop and ask, never silently relaunch on another model.

## The honest costs

- **Latency.** Every unit passes through review before it's trusted. The cadence rules (batch 3–4
  routine commits) keep this from eating you alive, but the floor is real.
- **Token spend.** Five roles means five contexts. The trial methodology exists precisely so the
  roster is evidence, not vibes.
- **Ritual.** The lock, the checkpoints, the watermarks, the labels — all of it is overhead
  until the day it's the only reason yesterday's decision is knowable. The receipts are the
  argument.
- **The CT error rate is on the record.** The tower checks its own architect — the source
  project's record names five caught CT errors in a single day, all banked, all caught by the
  discipline the tower enforces. That's the feature, not the embarrassment: no agent is above
  the record.

## Origin receipts

This tower was derived failure-by-failure on a real project. The companion essay and
`worked-example.md` carry the full story; the short list of incidents that generated the
load-bearing rules:

- **The data-loss incident** (a single agent destroyed 18 hours of unstaged work making the
  world match its own narrative) → the checkpoint-before-danger rule, the destructive-operation
  authorization rule, the WIP precedence clause.
- **The silent absorption** (three `git add -A` commits absorbed another agent's in-flight docs
  into unrelated WIP messages) → stage-by-path, the widened lock, separate worktrees for parallel
  source writers.
- **The reviewer drift** (months of reviews with no machine-findable continuity) → the
  watermark fields.
- **The grounding loop** (a fast model that couldn't commit to a design judgment for 132k tokens
  of input) → the role trials, the model-lock, the roster-by-evidence.
- **The re-derivation tax** (each fresh session regenerating its predecessor's dead hypotheses
  first) → the Cemetery.

## Portability

The role contracts are the stable part; the harness is an adapter. This package ships pi
(`pi-coding-agent`) as the tested binding — the skills reference its subagent dispatch, supervisor
channel, and file-only output routing. `portability.md` covers what re-binding to another agent
harness (Claude Code, Cursor, plain scripts) actually requires. Untested bindings are honest
about being untested.
