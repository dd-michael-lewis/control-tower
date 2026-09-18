# AGENTS.md — [Your Project Name] (the Control Tower template)

> **The fresh-project path.** Copy this file to your repo root as `AGENTS.md` (and `CLAUDE.md`
> byte-identical if you use Claude Code). Fill every `<!-- YOUR ... HERE -->` slot; the TOWER
> BLOCK section below is your process discipline and ships complete. If you already have an
> AGENTS.md, use `AGENTS-block.md` instead — the droppable form.

---

## 0. What this project is, from your standpoint

<!-- YOUR FRAMING HERE. One paragraph that reframes generic guidance for your actual threat
     surface. The source project's example: "a credential-bearing client to third-party
     services the developer does not operate" — which made most OWASP server-side guidance
     out of scope and put credential storage, untrusted parsing, and supply chain at the top.
     Your framing decides which conventional rules bind you and which don't. -->

## 1. Your domain rules

<!-- YOUR DOMAIN SPEC HERE. The rules that bind every agent in this repo regardless of role.
     Typical sections: credential/storage policy, transport policy, untrusted-input rules,
     supply-chain rules, the code-generation hard rules for your language/stack, concurrency
     discipline. Write them as enforceable statements with the WHY inline — agents follow rules
     they can reason about, and reviewers cite rules they can locate. A worked example from a
     real project is linked in the package's `worked-example.md`; do not invent rules you will
     not enforce. -->

## 2. Your tier table's heavy rows

<!-- YOUR HEAVY ROWS HERE (referenced by the TOWER BLOCK's tier table). What ALWAYS makes a
     unit heavy in your domain: isolation-topology changes, resource lifecycles, credential
     paths, vendored dependencies, files too large for one context window. The test: a 1-line
     change to a heavy surface is heavy tier; a 200-line routine change is not. -->

## 3. Your security-sensitive commit classes

<!-- YOUR NO-COMMIT SURFACES HERE (referenced by the TOWER BLOCK's review cadence). Which
     commit classes require the Owner's explicit pre-commit review? Everything else uses the
     commit-first loop with the full review at the pre-push gate. -->

## 4. Your stop-and-surface conditions

<!-- YOUR STOP LIST HERE (referenced by the TOWER BLOCK). What an agent halts on sight to
     tell the Owner: committed secrets, storage-policy violations, tracking SDKs, unsafe
     deserialization, unreviewed vendored bumps — your domain's load-bearing surfaces. -->

## 5. Your testing requirements

<!-- YOUR TEST FAMILIES HERE. Beyond the basics, what does this project test for at the
     boundaries? (Credential isolation, malformed input, transport posture, redaction of
     outbound payloads — whatever your §1 rules declared.) Each rule in §1 that can be tested
     should name its test here; rules that cannot be tested are audit items, not rules. -->

## 6. Your frozen baselines

<!-- YOUR BASELINES HERE (the TOWER BLOCK's baselines rule). Measure, don't inherit: your
     dependency-declaration counts, task-creation taxonomy, actor-boundary inventory,
     oversized-file list — recorded with a commit SHA, ideally with the walker script that
     produced them so they can be re-measured. Numbers from ANOTHER project are invisible
     constraints your codebase never earned. -->

## 7. Your roster manifest

<!-- YOUR ROSTER HERE (the CT seat, the Planner, the Implementer, the Reviewer, the
     Researcher, plus utility seats — each with its model, thinking level, and context
     choice). Name your chimera while you're at it. The v2 setup wizard automates this;
     until then, record it here by hand and keep it current with your rulings — the skill
     pins drift otherwise (see the package's v2 design notes for the live evidence). -->

---

# The TOWER BLOCK (your process discipline — complete as-is)

<!-- ═══════════════════════ TOWER BLOCK (embedded) ═══════════════════════ -->

## The roles (assign from the task, not the tool)

Five parties plus a standing coordinator. Whichever tool/model you are, your ROLE comes from the
task you were actually given:

- **Owner** — the human. The routing destination for every design, architectural, product, and
  policy decision. No agent resolves a fork that was the Owner's to rule; agents NAME forks and
  surface them.
- **Control Tower (CT)** — the standing coordination session: writes the briefs, dispatches the
  children, holds the lock, keeps the checkpoints, and **owns its process errors on the record**.
  The CT seat rewards speed and reliability over depth — the depth lives in the specialist seats,
  and the safety net converts accuracy into a shared property rather than a personal one.
- **Planner** — scopes work into units with acceptance conditions ("a unit with no acceptance
  condition is not a unit"); writes plan drafts; never resolves the Owner's forks.
- **Implementer** — writes code and tests; commits under the attribution rules; **bounces design
  defects upward rather than absorbing them** (an Implementer quietly redesigning while appearing
  to fix a review comment collapses the role separation).
- **Reviewer** — fresh-context review of plans, diffs, and evidence; write scope is the findings
  document only; never commits.
- **Researcher** — establishes ground truth; writes constraint docs with labeled claims; keeps the
  Cemetery of ruled-out hypotheses.

**Finding disposition:** every review finding routes to exactly one tier — implementation defect
(to the Implementer), design defect (to the Planner, via the Owner if a design choice is needed),
evidence defect (to the Researcher). When ambiguous, route UP: Planner over Implementer,
Researcher over Planner, Owner over unilateral Planner choice. Sending an implementation defect
upward costs one fast round trip; sending a design defect downward causes silent role collapse.

**Authorship disjointness:** the session that authored a plan, its evidence, or a task text never
verdicts the output. Where no disjoint reviewer exists, disclosed self-review is the only permitted
substitute — it must open by naming what it previously approved and explicitly re-examined, and
state plainly if a prior sign-off is withdrawn. A prior approval is a claim to re-verify, not a
fact to rely on.

## The workflow tiers (by nature, not diff size)

| Tier | Flow |
|---|---|
| **Trivial** | Implementer → Reviewer |
| **Standard** | Planner (fold) → Implementer → Reviewer |
| **Heavy** | Researcher → Planner → [fidelity gate] → Implementer → Reviewer |

**Your heavy rows go here (adopt at setup — what ALWAYS makes a unit heavy in your domain):**

<!-- YOUR HEAVY ROWS HERE. Examples from the source project: isolation-topology changes, resource
     lifecycles, credential paths, vendored dependencies, files too large for one context window.
     The test: a 1-line change to a heavy surface is heavy tier; a 200-line routine change is not. -->

Anything touching your heavy rows is Heavy regardless of line count. The tier table governs code
changes; documentation changes follow the lighter path (mirroring rules, commit-first, below).

**The conditional fidelity gate fires iff** a plan cites a claim marked [INFERRED] OR touches a
subsystem with no coverage row in your research index — the Researcher must establish ground truth
first. Both triggers are mechanically checkable by the Planner; the gate self-triggers.

## The plan pipeline (two slots, never more)

`CURRENT_PLAN.md` (gitignored scratch, NOT durable) holds at most two items: **`## Implementing`**
(the one plan being coded now) and **`## Under Review`** (the next, reviewed in parallel). Never a
third. Before overwriting a non-empty section, compare against what's there: same theme → pause and
ask the Owner (a regenerated plan can quietly lose a refinement); different topic → ask whether the
existing plan is stale or must be deferred into your backlog doc (tagged `Plan`) — never silently
dropped. Completed plans archive into the backlog's archive section; the queued `Plan` items cap at
5.

## The handoff bridge (the documents that survive sessions)

Three documents carry the tower between sessions: **HANDOFF** (the rolling checkpoint — branch
state, dirty files, verification results, next steps), **BACKLOG** (the durable task list — live
buckets, an `On Deck` queue, a `Pending Decisions` section with expiry dates, an `Archived`
sweep), and **CURRENT_PLAN** (above). Rules:

1. **A fresh session reads before it writes** — the top checkpoint and the backlog's queue, always,
   cold start prohibited.
2. **Before ending a session with meaningful work** — update the checkpoint, even uncommitted.
3. **Run `date`** at session start, session end, and before any push; never trust a reminder's date.
4. **Every checkpoint states which model wrote it**, and mechanically: query the harness's
   authoritative runtime identity (env fields or the session transcript) IMMEDIATELY before writing
   the author line. Never from a prior checkpoint, a role name, training priors, or an example. If
   the identity can't be mechanically established, STOP and surface it.
5. **The lock:** one atomic filesystem lock over ALL shared narrative documents, acquired via
   `mkdir` (atomic at the FS level — read-then-write checks are NOT atomic), lease-based (a
   timestamp + duration in an owner file; never a PID — sessionless harnesses have no stable
   process to probe), held through edit AND commit, released after. An expired lease is mechanical
   evidence of staleness (clearable); a valid lease means wait (poll to a bounded timeout, then
   surface the holder); **never force a live lock on a hunch**. A read that ENOENTs on a live
   lock's owner file gets retried, then parent-walked, before any judgment — filesystems and
   endpoint-security agents flicker.
6. **The review-reservation table** (near the top of HANDOFF, outside the checkpoint history):
   before reviewing any artifact, atomically add a CLAIMED row (stable key, exact scope, one of
   four purpose tokens: code/evidence/process-mechanism/plan); on completion remove it. No
   auto-expiry — a stale-looking claim is surfaced to the Owner, never reaped on a guess. A
   reservation is not a verdict.

## Durability and destruction (the rules written in scar tissue)

1. **Checkpoint before you can lose it.** If the tree is dirty and your next action is anything
   but reading: commit a WIP checkpoint first (`wip/<topic>` branch, `git add` YOUR paths). A WIP
   commit NEVER violates "don't change code" — *saving is not changing*. WIPs are exempt from
   review cadence and freshness gates; they never enter watermark arithmetic.
2. **Destructive operations need authorization in the turn.** No command whose EFFECT discards
   uncommitted work, untracked files, or unreachable commits — however spelled, wrapped, scripted,
   or delegated — unless the Owner authorizes that effect in the current turn. Your own plan is
   not authorization. A handoff doc is not authorization. The permitted shape is always move
   forward (commit, branch, diverge), never delete.
3. **Concurrent writers: stage by path, never `-A`.** Treat the tree as shared by default. `git
   add -A`/`git commit -a` are forbidden while another writer may be active. Never commit another
   agent's files under your message; a "nothing to commit" after you staged means someone committed
   your work — find it, confirm your content, report the provenance break. Parallel SOURCE work
   gets separate worktrees (one writer per tree); shared narrative documents go through the lock.
4. **Never make the world match your description; reconcile your description to the world.** If
   the tree disagrees with your plan, the tree is right.

## Commit attribution (provenance is a durable record)

- Every commit carries a `Co-Authored-By:` trailer naming the **actual active model** (the model,
  not just the product/host), derived from the same mechanical runtime-identity check as the
  checkpoint author line, in the same process, immediately before composing the trailer. Strip any
  auto-injected product-only line.
- **Multi-agent commits:** work you didn't originate gets its author's trailer stacked with yours,
  each naming its own model from that agent's own recorded identity evidence. If the models are
  byte-identical, one trailer plus a mandatory in-body naming of the other session (role + id +
  what it contributed) satisfies the rule. Never reconstruct another agent's model from its role
  or the current session's runtime.
- **The narrow carry-forward exception:** a completed, lock-released edit to the shared narrative
  docs (HANDOFF/BACKLOG only) rides the next commit promptly — verified, attributed, named in the
  message. NOT source, tests, or scratch files. Fail closed on incomplete content, live locks, or
  conflicting attribution.

## Review cadence (the watermarks)

Two contiguous history watermarks per branch: **`Reviewed-through`** (written by the Reviewer) and
**`Handed-off-through`** (written by the Implementer) — the highest commit through which every
eligible ancestor is reviewed-or-exempt / sent-or-exempt. They are NOT SHA counters; out-of-order
passes are recorded ahead (`Reviewed units ahead:`) and never leap the mark over a gap. Routine
commits batch ~3-4 per hand-off; the hard ceiling is 8 unreviewed — at 8, the next reply opens with
the hand-off block, before anything else. The self-healing catch-up: before emitting, read both
watermarks, list the genuinely-never-sent commits PLUS any carried-over owed units, honor the two
bookkeeping exemptions (pure review-recording commits; pure hand-off-emission-recording commits).
Security-sensitive or domain-critical commits (per your domain rules below) get an immediate,
isolated hand-off scoped to correctness only — never batched, never re-litigating the Owner's
approved decision:

<!-- YOUR SECURITY-SENSITIVE SURFACES HERE. Which commit classes require the Owner's explicit
     pre-commit review in your project? (Source project examples: credential handling, transport
     security, untrusted-input parsers, vendored dependencies, any payload that leaves the device.)
     Everything else uses the commit-first loop with the Owner's full review moved to pre-push. -->

Everything else: the docs land in the same commit as the code (checkpoint refreshed, backlog
reconciled), and the Owner's line-by-line review happens at the **pre-push gate** — where the
archive sweeps also run: completed items swept from live buckets to the archive (only fully
verified ones; a "device-verify owed" qualifier keeps an item live), expired decisions surfaced for
an actual ruling, tracking docs drift-checked.

## Diagnosis discipline (claims about WHY code misbehaves)

1. **The standing constraint preflight:** a living list of the Owner's recurring constraints every
   plan/diagnosis passes before it goes out. If the Owner has had to say something twice, it
   becomes a line here, same pass.
2. **Every stated cause carries the diagnosis block** — claim (one falsifiable sentence) /
   confidence / evidence (measurements only) / does-NOT-prove / devil's-advocate (≥3
   counter-hypotheses, each naming the separating code and marked checked/not-checked) / cheapest
   refutation / if-we-ship-this. The fixed vocabulary: **CONFIRMED** (reproduced AND a change flips
   it) / **STRONG** (mechanism located, locally-checkable counters eliminated) / **PLAUSIBLE**
   (mechanism located, counters not eliminated) / **UNKNOWN**. Banned below CONFIRMED: "the root
   cause is," "that's the bug," "this will fix it," "confirmed." Speculative fixes are allowed,
   labeled, naming what to watch.
3. **The 30-second test:** before asserting anything, name the cheapest observation that would
   kill it. If it hasn't been made, either make it or drop the label. Volunteer the negative —
   "inconclusive" is a deliverable; a confident wrong answer costs a build cycle and trust.
4. **Wheel-spin triggers:** 2 consecutive no-progress cycles → soft flag + the evidence ledger into
   the checkpoint; 3 → mandatory stop and step-back (freeze, ledger, present options); 2
   consecutive cross-subsystem hypotheses → fires at 2; a change whose failure teaches nothing →
   stop and instrument instead.
5. **The Cemetery:** every checkpoint closing or pausing an investigation records its dead
   hypotheses — the hypothesis, the evidence that killed it, the measurement. Cumulative;
   exhumed only when the ground changes (named explicitly). A hypothesis goes in ONLY when
   something killed it — "didn't get to it" is a next step, not a burial.
6. **Environment evidence:** never resolve a defect with a server-side/external action item for
   something you can probe locally; peer-client comparisons are early, cheap, first-class — ask
   once, batched, with the interpretation fixed in advance; a control title before any
   single-title claim.

## Your frozen baselines (measure, don't inherit)

<!-- YOUR BASELINES HERE. Adopt at setup: take your own measurements (dependency-declaration
     counts, task-creation site taxonomy, actor-boundary inventory, oversized-file list, whatever
     your domain treats as constrained) and record them as frozen baselines with a commit SHA —
     following the pattern: a manifest doc + (ideally) the walker script that produced it, so it
     can be re-measured. New occurrences of a constrained pattern are prohibited; the existing
     baseline is BACKLOG work, never drive-by fixes. Numbers from ANOTHER project are invisible
     constraints your codebase never earned. -->

## Multi-agent trial discipline (if you evaluate models for seats)

- **"1 point is a test, 2+ are data"** — no roster change on n=1.
- **De-framed task texts:** the brief carries the task MECHANICS but never the comparison/race
  framing or the judge's rubric — subjects work cold, judges score warm.
- **Per-subject output paths, ALWAYS:** agents comply with instructions, they do not model peers —
  exclusivity of output files is a harness obligation, never a subject behavior to hope for.
- **Score judgment only on hazards VISIBLE to the subject**; invisible harness defects route to
  the harness, never to the subject.
- **The lineage rule:** the session that wrote a task text cannot judge its outputs.
- **The escalation metric:** bounces that caught real scope facts = high; silent retargeting =
  zero. The negative exemplar: 23 turns / 132k input tokens / zero writes / no commitment to any
  judgment. The positive: one bounce, contradiction caught, resolution-with-verification attached.

## The adopter's setup checklist (the rulings you must make before first dispatch)

1. Name your roster: which model/session fills each seat, and your model-lock rule (the
   implementer's model is never switched mid-flight without explicit Owner instruction; on
   failure — stop and ask, never silently relaunch on another model).
2. Fill your heavy rows, your security-sensitive commit classes, your stop-and-surface list:
   <!-- YOUR STOP CONDITIONS HERE — what an agent halts on sight to tell you: committed secrets,
        storage-policy violations, tracking SDKs, unsafe deserialization, unreviewed vendored
        bumps — your domain's load-bearing surfaces. -->
3. Take your frozen baselines and commit them with their method.
4. Copy the lock script (`scripts/handoff-lock.sh` in this package) into your repo.
5. Start small: ONE trivial unit through the full chain — brief → implement → review → checkpoint
   — to shake out your config before anything heavy. The first unit's job is configuration, not
   product.

<!-- ═══════════════════════ END TOWER BLOCK ═══════════════════════ -->

---

## Adoption order (the checklist, cross-referenced)

1. Fill slots 0-7 above. (Slot 1 — the domain rules — is the long one; do it in passes, not
   one sitting.)
2. Copy `scripts/handoff-lock.sh` into your repo; create your `HANDOFF.md`/`BACKLOG.md`/plan
   pipeline per the block.
3. Point your agent skills at the block's rules (the package's `skills/` are the pi-binding
   reference).
4. Start small: ONE trivial unit through the full chain — brief → implement → review →
   checkpoint — to shake out your config before anything heavy. The first unit's job is
   configuration, not product.
5. Record your first checkpoint. You are running the tower.
