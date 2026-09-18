---
name: research-subagent
description: Launch a Researcher subagent to establish ground truth on a subsystem or on unverified third-party/framework behavior, writing a durable constraint doc via file-only output. Use this skill whenever a plan cites an [INFERRED] claim, a plan touches a subsystem with an empty row in the coverage index, load-bearing third-party or framework behavior is unverified, a wheel-spin or research-raise rule fires, or an ESCALATE line names Researcher. Use it even when the request is phrased casually, for example "find out how .task(id:) actually behaves", "we need to characterize playback", "check whether that framework claim is real", or "no constraint doc covers this". Do NOT use it for reviewing a plan or a diff (use review-subagent) or for writing code (use implement-subagent).
---

# Research subagent

Launch a Researcher child to establish ground truth and leave behind a constraint
doc that outlives the session. The child is disposable. The doc is the point.

## Repo paths

Confirm these once, then leave them alone.

| What | Path |
|---|---|
| Coverage index | `docs/research/INDEX.md` |
| Constraint docs | `docs/research/<subsystem-slug>-<YYYY-MM-DD>.md` |
| Sibling artifacts | `docs/research/<subsystem-slug>-<YYYY-MM-DD>-<kind>/` or `.py` |
| Shared cemetery | `docs/research/CEMETERY.md` |
| Launch log | `docs/evals/subagent-architecture-test-2026-09-15/LAUNCH-LOG.md` |
| Handoff | `HANDOFF.md` |
| Lock script | `scripts/handoff-lock.sh` |

Shared surfaces in `docs/research/` are uppercase and undated (`INDEX.md`,
`CEMETERY.md`) because they are living. Constraint docs are lowercase and dated
because each one is a characterization pinned to a commit SHA, not a document
that gets revised.

## Autonomy

**Launch without asking the Owner.** A research child is read-only on the repo
except for the one file it creates, cannot mutate git, and fires from a lookup
against the coverage index rather than from a judgment call. There is nothing
for the Owner to gate, and routing every launch through a human recreates the
bottleneck this architecture exists to remove.

Two checks before launching, both against state rather than memory.

### Open-child check

Read the launch log. If an open same-role child (launched, not yet handed back)
has an overlapping scope or the same intended output path, do not launch. Emit:

```
ESCALATE: Researcher — <the specific question> — overlaps open child <key> launched <time>
```

and stop. Overlapping same-role children are the collision class this
architecture claims to remove, so the parent must not create one by forgetting
what is in flight.

### Concurrent launches

Concurrent same-role children are allowed **only when launched in a single
`runs.all()` call**, with disjointness of scope and output path asserted in the
launch log entry. One deliberate fan-out decision is safe. A sequential launch
while another child is open is the risky case, because nothing forces the parent
to recall what it already started.

### Log at launch, not at hand-back

Append a row to the launch log **before** the child starts:

```
| launched | role | model | key | scope | output path | handed back | size | outcome |
```

Leave `handed back`, `size`, and `outcome` empty, and fill them at hand-back.
Outcome is one of `delivered`, `superseded`, `aborted`, `collision`. The output
path is known at launch because the parent computes it.

Logging at launch is what makes the open-child check possible and what makes
same-role overlap computable afterward. A log written only at hand-back records
nothing about what was in flight, which is the only thing the check needs.

## Launch parameters


```
agent:      researcher | scout          # choose per question, see below
model:      <your-researcher-model>   # from your roster manifest (docs/tower/AGENTS-block.md); thinking as a suffix
context:    fresh                        # always, no exceptions for research
output:     docs/research/<subsystem-slug>-<YYYY-MM-DD>.md
outputMode: file-only
```

Thinking level rides as a suffix on the model string. It is not a separate
parameter.

### Choose the agent by whether the question needs a measurement run

Two presets fit, and they differ in a way that decides the dispatch.

**`researcher`**: read, write, web_search, fetch_content, get_search_content,
source_check. No bash. Also no grep, find or ls, so it can read paths it is
given but cannot explore the tree or execute anything.

Use it for framework and behavioral characterization. The `.task(id:)`
restart-delivery question is this shape: web-heavy, no measurement. CT supplies
the file inventory in the task text, since the child cannot build one. This
keeps mutating git off the table by capability rather than by instruction, which
is the stronger guarantee and the default preference.

**`scout`**: read, grep, find, ls, bash, write. Can explore and can execute.

Use it when the answer requires running a measurement. The precedent is
`concurrency-baselines-2026-09-11.md`, which came with
`concurrency-baseline-walker.py` and counted 18 `@unchecked Sendable`
declarations across 18 files. `researcher` can write that script and cannot run
it, so that doc could not have been produced by it.

The cost of `scout` is that the git restriction below reverts from capability to
prose. Prefer `researcher` and reach for `scout` only when a measurement is
actually owed. Record which one was used in the launch log's model column
alongside the model string.

Never use `claude-code`, `codex-exec`, `cursor-agent` or their `-writer`
variants. Those are external CLI runners and the model string reaches them only
if their runner declares native model option support, so a silent fallback to
the runner's default model is possible. A constraint doc attributed to the wrong
model is worse than no constraint doc.

### Use the write-capable shape, not the read-only shape

Two shapes exist under `file-only`. With a write-capable child the harness
instructs the child to write the output file itself, incrementally across tool
calls, with no cap. With a read-only child the harness persists the child's
final message to the path, which means the whole artifact has to fit in one
message.

Research uses the write-capable shape. Your real constraint docs run 19k to
42k, and the one-message ceiling is a limit you would hit exactly on the
documents worth having. Write access to the one output path is not a relaxation
of the child prohibitions below; everything else stays read-only.

### `output:` inside the repo is correct here

There is no path restriction. A constraint doc belongs in the tree, committed,
where the index can point at it. The fleet TUI warns about artifacts outside
its trusted roots, which is a preview-pane cosmetic and does not affect the
write.

### Fail-closed

`file-only` post-checks that the file exists and fails the launch with exit 1 if
nothing was written. A child that produces nothing gives you a failed launch,
not a silent empty artifact. Log the failure as outcome `aborted` and do not
treat a missing file as a finding of no result.

### Preflight: verify the model id

Never launch on a remembered id. Model strings go stale and a wrong
`provider/id` fails the launch outright, which is the safe failure but wastes a
turn.

```
subagent({ action: "models" })
```

Confirm the model string matches `<your-model-per-the-roster-manifest>`. The agent names are fixed
above and do not need a lookup.

If the model is absent, do not substitute a similar one and do not fall back.
Report the available list to the Owner and stop. A silent substitution changes
what the constraint doc means without anyone deciding to.

### Why `fresh`, always

A forked child inherits the parent's hypotheses and spends its first pass
regenerating them. That is the model-correlation failure this repo's workflow
docs already call out. A Researcher exists to find what the parent could not
see, so it must not start from the parent's view.

`fork` has exactly one legitimate research use: an adversarial re-check of a
conclusion the parent authored, launched deliberately and labeled as such in the
task text. It is not the default and it is not for characterization work.

### Launch

Single child:

```
subagent({
  agent: "researcher",
  task: "<task text, see below>",
  model: "<your-model-per-the-roster-manifest>",
  context: "fresh",
  output: "docs/research/<slug>-<YYYY-MM-DD>.md",
  outputMode: "file-only"
})
```

Two or more subsystems at once:

```
return await runs.all([
  { key: 'playback', agent: 'researcher', task: '...', model: '<your-model-per-the-roster-manifest>',
    output: 'docs/research/playback-<date>.md', outputMode: 'file-only' },
  { key: 'storage',  agent: 'scout',      task: '...', model: '<your-model-per-the-roster-manifest>',
    output: 'docs/research/storage-<date>.md',  outputMode: 'file-only' }
])
```

Agents may differ per child in one fan-out, as above: a characterization pass
and a measurement pass are different shapes and do not need the same preset.

Fanning out is safe here only because each child writes a distinct output path.
Two children never write the same file, so there is nothing to serialize.
Preserve that property and concurrent research cannot collide.

**The parent computes the output path, so it knows it before launch.** That is
what lets the launch log record the path at launch time rather than at hand-back,
and it is what makes the open-child check possible.

## Task text

Give the child the question, not the conclusion. Include:

1. The precise question, stated so it can come back false.
2. The subsystem or framework surface in scope, and what is out of scope.
3. Any hypothesis the parent holds, labeled as a hypothesis to be tested rather
   than a premise to be confirmed.
4. **The baseline SHA**, from `git rev-parse HEAD` run by the parent before
   launch. The child records it; it does not determine it.
5. **The doc being superseded**, if this is a re-characterization, with its
   baseline, so the child can diff rather than start over.
6. The output contract below, verbatim.

Do not include the parent's reasoning chain. If the child needs it to do the
work, the question is underspecified.

Items 4 and 5 are supplied rather than returned because under `file-only` the
parent receives only a pointer. Anything the parent needs for the index fold has
to be either known at launch or grepped afterward, and known at launch is
cheaper.

## Output contract

State this to the child verbatim.

**Write the constraint doc to the output path the harness gives you.** Do not
choose your own filename and do not create a second document. Never edit or
overwrite any existing constraint doc, including a prior doc for the same
subsystem: re-characterization is supersession, and the parent handles the
repointing.

Sibling artifacts are allowed when the characterization produced them: a walker
or measurement script, or a directory of briefs. Give them the same dated slug
(`<subsystem-slug>-<YYYY-MM-DD>-lane-briefs/`, `<subsystem-slug>-walker.py`) and
name them in the doc's own `## Artifacts` section, since the parent will not see
a return value. Do not hide a measurement behind prose describing it; if a
script produced a number, ship the script.

Required sections:

```markdown
# <Subsystem or surface>

## Question
## Method
## Findings
## Baseline
## Cemetery
## Artifacts
## Open
```

- **Findings**: every claim carries an evidence label, `[VERIFIED]`,
  `[INFERRED]`, or `[ASSUMED]`. An unlabeled claim is a defect.
- **Baseline**: the SHA supplied in the task text, on its own line as a full
  SHA. Mandatory. The coverage index does not count a doc as coverage without a
  commit-SHA baseline, so a doc that omits it has done the work and earned
  nothing.
- **Cemetery**: every hypothesis ruled out, with what ruled it out, one per
  line. The parent greps this section, so keep it to flat lines rather than
  prose. Negative results are the first thing lost and the most expensive to
  rediscover.
- **Artifacts**: sibling files by path, or `none`.
- **Open**: what remains owed, and to whom.

**There is no return value to write.** Under `file-only` the parent receives the
saved path plus size and line count, and nothing else. Do not write a summary
for the parent, do not restate findings in your final message, and do not
assume the parent will read the body. Everything that matters goes in the
document.

That routing is deliberate. The Owner reads the raw file; the parent holds only
a pointer and cannot soften a finding on the way through.

## Child prohibitions

The child is read-only on the repo except for the output path the harness gave
it and any sibling artifacts named in the doc.

- No writes to `docs/research/INDEX.md`, `docs/research/CEMETERY.md`,
  `HANDOFF.md`, `BACKLOG.md`, `CURRENT_PLAN.md`, `AGENTS.md`, `CLAUDE.md`, or
  `.cursor/`.
- No writes to app source or tests.
- No mutating git: no `commit`, `add`, `clean`, `checkout`, `stash`, `reset`,
  `rm`. Read-only git (`log`, `show`, `rev-parse`, `diff`) is expected and
  fine.

The project has lost roughly 18 hours to `git clean -fd` and destroyed
provenance to add-all commits. A child with write access to one path and no git
cannot reproduce either, and the shared surfaces stay single-writer, which is
what keeps concurrent research from contending.

**The strength of this guarantee depends on which agent was dispatched.** Under
`researcher` there is no bash, so mutating git is impossible rather than
forbidden. Under `scout` bash is present, so the list above is prose the child
is instructed to follow. That asymmetry is the reason to prefer `researcher` and
reach for `scout` only when a measurement is actually owed.

## Parent duties after hand-back

The launch returns `savedPath` plus size and line count. Nothing else. The
parent already knows the baseline SHA and the superseded doc, because it
supplied both in the task text. Only the cemetery has to come out of the file.

**Extract the cemetery with a targeted read, not a full read.** Reading a 40k
document into the parent to copy six lines out of it is the fan-in cost this
architecture exists to avoid:

```
sed -n '/^## Cemetery/,/^## /p' <savedPath>
```

Then, all of it under the lock:

1. Acquire `.handoff.lock` via `scripts/handoff-lock.sh`. It uses atomic
   `mkdir` and waits up to 300s, so it is real mutual exclusion rather than a
   convention.
2. Fill or repoint the subsystem row in `docs/research/INDEX.md` with the doc
   path and the baseline SHA. Without the SHA the row is decoration and the
   index does not count it as coverage.
3. If this was a supersession, mark the prior doc superseded in the index with
   the date, leaving the file in place. Nothing is deleted. A superseded doc is
   still the record of what was true at its baseline, and this project has
   already lost provenance twice.
4. Append the extracted cemetery lines to `docs/research/CEMETERY.md`. Create
   the file if absent. Do not put cemetery entries in `HANDOFF.md`: the cemetery
   is append-only for the life of the project, `HANDOFF.md` is the
   highest-contention file every session reads, and a cemetery scattered across
   checkpoints cannot be handed to a break-glass session as a unit, which is
   what the break-glass input rule requires.
5. Log the hand-back in `HANDOFF.md`, including the doc path.
6. Release the lock.
7. Close the launch log row: hand-back time, **reported size**, and outcome.
8. Commit, or dispatch an Implementer to commit. Children never commit.

Log the size because thin coverage is the failure mode that already happened
here. Five docs from the 09-11 burst ran 2.3k to 3.6k against 19k to 42k for
every doc outside it, and the count-based tally hid it. Size comes back free
under `file-only`, so record it and the pattern is visible without an audit.

**Give the Owner the path.** Your summary is a convenience, never a substitute,
and if the two disagree the file wins.

## Disjointness

Disjointness binds `(role, session, lineage)`, never model identity. Running the
same model in a fresh session is not a bar.

The parent may read and act on a Researcher child's output freely. The child
established ground truth against the world; it did not author an artifact the
parent is judging, so there is no conflict.

This is the difference from review. The parent authors plans, so a review of a
plan is the case where framing matters, and it is handled in
`review-subagent`: `fresh` context, task text carrying the artifact by path and
the criteria only, and `file-only` output so the parent cannot soften a finding
on the way to the Owner.

## When the coverage index is the trigger

Check the index before launching, and record what you found. A plan that touches
a subsystem with an empty row fires this skill mechanically, from a lookup rather
than from someone remembering to escalate. That is the whole reason the check
belongs to a session holding the index and not to the session producing the
claim: a producing session cannot reliably notice that it is relying on
something unverified.

If a row is filled but its baseline SHA is far behind `HEAD`, the coverage is
stale rather than absent. Say which it is in the launch decision. Stale coverage
is a supersession pass, not a fresh characterization, and the task text should
name the doc being superseded and its baseline so the child can diff against it
rather than start over.

Thin coverage is a third case and the easiest to miss. A filled row pointing at
a doc that is short and cited once is a row that looks like coverage and is not.
When the trigger fires against such a row, treat it as absent.
