> **Package note (2026-09-18):** this is the REAL planner-subagent skill, recovered from the source
> project's shelf where it was preserved when the CT absorbed the Planner seat — adapted here for the
> package: the model pin is a roster-manifest slot and the launch-log path is genericized. The
> source project runs the CT-as-Planner shape (see the README's setup distinction); this skill ships
> for adopters who want the dedicated seat. The lineage rule binds either way.

---

# Planner subagent

Launch a Planner child to decompose a work item and return a plan draft. The
child drafts. The parent folds. Nothing shared gets written by a child.

## Repo paths

Confirm these once, then leave them alone.

| What | Path |
|---|---|
| Plan drafts | `docs/plans/drafts/<slug>-<YYYY-MM-DD>.md` |
| Binding plan | `CURRENT_PLAN.md` |
| Coverage index | `docs/research/INDEX.md` |
| Launch log | `<your launch log — see the block's trial discipline>` |
| Backlog | `BACKLOG.md` |
| Handoff | `HANDOFF.md` |
| Lock script | `scripts/handoff-lock.sh` |

Create `docs/plans/drafts/` if it does not exist. Drafts live apart from
`docs/plans/` so that a draft is never mistaken for binding text.

## Autonomy

**Never launch a Planner child without the Owner's go-ahead.** This is not about
cost. It is the lineage rule: the session that launches a Planner child cannot
review the resulting plan, so launching one creates a routing obligation only
the Owner can discharge. That decision belongs to the Owner at request time, not
after a draft exists and the routing turns out to be awkward.

Request it with the escalation line plus a routing companion line:

```
ESCALATE: Planner — <the specific question> — <why this session cannot answer it>
REVIEW-ROUTING: <proposed reviewer outside this lineage, or "Owner">
```

Then stop and wait. A declined request is a recorded decision, not a defect;
record it in `HANDOFF.md` with the reason and carry on.

The routing line is the load-bearing half. Without it the Owner is approving a
launch whose review cost is invisible, which is how a plan ends up reviewed by
the session that framed it on a technicality.

### On approval

1. Read the launch log. If an open Planner child overlaps the work item, say so
   and do not launch, even with approval. Two drafts of one item is the
   collision class this architecture claims to remove.
2. Append a row to the launch log **before** the child starts, with `handed
   back` and `outcome` empty:

   ```
   | launched | role | model | key | scope | output path | handed back | outcome |
   ```

3. Record the approved review routing in the same row's scope field, so the
   obligation is recoverable without reading back through `HANDOFF.md`.

**Every session gets a row, not only children.** The launch log's denominator feeds
the test window's conditions 1 and 2, which divide app-source churn by launches.
Children are read-only and cannot produce app source, so a children-only log makes
those conditions permanently satisfied while measuring nothing. Append a row for
**every** session: parent, child, Implementer, and any session started by hand
outside the harness. Prefix the role with `peer-` for a hand-started session, so
peer-session collisions stay countable separately from mechanism collisions. See
`docs/evals/subagent-architecture-test-2026-09-15/CONDITIONS.md` § Definitions.

## Launch parameters

```
model:      <your-planner-model>     # from your roster manifest; thinking as a suffix
context: fresh
```

Thinking level rides as a suffix on the model string. It is not a separate
parameter.

### Preflight: verify the model id

```
subagent({ action: "models" })
```

Copy the exact `provider/id` from the result and confirm it matches
`<your-model-per-the-roster-manifest>`.

If it is absent, do not substitute a similar model and do not fall back. Report
the available list to the Owner and stop.

External CLI-backed agents receive the model string only if their runner
declares support for native model options. Check the tool-reference guide before
relying on it for this role.

### Why `fresh`

A forked Planner inherits the parent's framing, and the parent here is the
Reviewer that will end up judging the resulting work. Fresh context forces the
parent to state the scope explicitly in the task text instead of letting the
child absorb it, which is the difference between a plan that answers a question
and a plan that ratifies one.

`fork` is legitimate for one case only: an adversarial re-plan, launched
deliberately to attack a plan the parent already holds, labeled as such in the
task text.

### Launch

```
subagent({
  agent: "<agent>",
  task: "<task text, see below>",
  model: "openai/gpt-5.6-sol:high"
})
```

Do not fan out Planner children over the same work item. Two drafts of one item
is the collision class this architecture exists to remove, and merging them
recreates the fold that propagated a wrong file reference into binding plan text
on 2026-09-15. Fan out only across genuinely disjoint items, each writing its
own draft path.

## Task text

Include:

1. The work item and its boundary. What is in, what is explicitly out.
2. The tier you believe applies, offered as a claim the child may reject.
3. Every constraint doc that bears on it, by path, plus its baseline SHA.
4. The subsystems you believe are touched, and the index status of each.
5. Open questions already owed to the Owner, so the child does not re-derive
   them as new.
6. The output contract below, verbatim.

## Output contract

State this to the child verbatim.

**Create exactly one new file** at
`docs/plans/drafts/<slug>-<YYYY-MM-DD>.md`. New file only. Never write
`CURRENT_PLAN.md`; that path belongs to the parent.

Required sections:

```markdown
# <Work item>

## Objective
## Tier
## Subsystems touched
## Units
## Constraint docs cited
## Open questions
```

- **Tier**: Trivial, Standard, or Heavy, declared explicitly with the reason.
- **Subsystems touched**: one row per subsystem, each stating whether
  `docs/research/INDEX.md` shows coverage, and at what baseline SHA. An empty
  row means Researcher is owed before the unit can proceed; say so in the plan
  rather than leaving it to be noticed later.
- **Units**: each with scope and an acceptance condition. A unit with no
  acceptance condition is not a unit.
- Every claim carries an evidence label, `[VERIFIED]`, `[INFERRED]`, or
  `[ASSUMED]`. An unlabeled claim is a defect. An `[INFERRED]` claim that is
  load-bearing fires the research trigger and the plan must say which unit it
  blocks.
- **Constraint docs cited**: by path, with the baseline SHA each was written
  against. If a cited doc's baseline is far behind `HEAD`, mark the citation
  stale.

**Return to the parent, and nothing more:**

```
path:      docs/plans/drafts/<slug>-<date>.md
tier:      <Trivial|Standard|Heavy>
units:     <count>
uncovered: <subsystem names with empty index rows, or "none">
blocking:  <load-bearing [INFERRED] claims, or "none">
open:      <one line per question owed to Owner, or "none">
```

No plan text in the return. The parent reads the draft when it folds it.

## Child prohibitions

Read-only on the repo except for the one draft file it creates.

- No writes to `CURRENT_PLAN.md`, `HANDOFF.md`, `BACKLOG.md`,
  `docs/research/INDEX.md`, `AGENTS.md`, `CLAUDE.md`, or `.cursor/`.
- No writes to app source or tests. A Planner that edits code has stopped
  planning.
- No mutating git: no `commit`, `add`, `clean`, `checkout`, `stash`, `reset`,
  `rm`. Read-only git is expected and fine.

## Parent duties after hand-back

All shared writes under the lock:

1. Acquire `.handoff.lock` via `scripts/handoff-lock.sh`.
2. Fold the draft into `CURRENT_PLAN.md`. Check every file path and every doc
   citation against the repo during the fold. This is the step that failed last
   time, and it failed by carrying a reference forward without checking it.
3. Update `BACKLOG.md` with any unit that is blocked on coverage.
4. Log the fold in `HANDOFF.md`, including the draft path so the lineage is
   recoverable.
5. Release the lock.
6. Close the launch log row: hand-back time and outcome.
7. Commit, or hand to an Implementer. Children never commit.

Leave the draft in place after folding. It is the record of what the child
actually said, as distinct from what the parent folded.

## Lineage rule, and it binds here

Disjointness binds `(role, session, lineage)`, never model identity.

**A session that launches a Planner child may not be the session that reviews
the resulting plan.** The parent writes the child's task text, so the parent
framed the artifact. Reviewing it satisfies `(role, session)` on a technicality
and defeats what the rule is for.

After folding, route plan review to a Reviewer outside the lineage, or to the
Owner. Record the routing in `HANDOFF.md` so the disjointness is auditable
rather than assumed.

This is the one place where a Planner child differs from a Researcher child. A
Researcher establishes ground truth and the parent may review it freely. A
Planner produces the artifact under judgment, and the parent is compromised as
its judge.

## What plan review cannot catch

Plan review catches errors of commission. It does not catch scope the plan never
considered, because there is nothing on the page to review. When the plan's
`uncovered` list is non-empty, treat that as the known gap and launch research
before the unit proceeds, rather than relying on review to surface what is
absent.
