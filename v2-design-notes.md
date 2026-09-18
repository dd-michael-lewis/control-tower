# Control tower pack — v2 design notes (Owner idea-dump, 2026-09-18)

## The setup wizard ("Setup control tower")

**The design ruling:** the wizard READS the harness, WRITES the project. It never writes to pi's own
config — the write surface stays inside the repo (the roster slot in the user's AGENTS.md), the read
surface on the user's configured agents. A wizard that writes the harness config owns a surface
harness updates can break and a botched write can corrupt; a wizard that records choices owns one
revertible file.

**The flow:**
1. Preface (the contract, not a compromise): *"configure your models/agents in pi as you normally
   would — the setup records your choices into the tower."* Pi users at this level have already made
   considered model selections; the wizard records, it doesn't re-derive.
2. Probe the configured agents/models read-only (the registry + per-agent defaults).
3. `ask_user_question` per role: which model (options built FROM their configured set — the wizard
   can't offer what their config can't run), the thinking level (the `:off…:max` suffixes, carried
   into the manifest as dispatch parameters), the context choice (fresh/inherit per role).
4. Emit the filled roster manifest (JSON) for human review — approved before any write.
5. Write the manifest into the block's roster slot in their AGENTS.md — one write, one surface,
   git-revertible.

**The manifest schema (the block's setup-checklist ruling #1, structured):**
`role → { model: provider/id, thinking: level, context: fresh|inherit }` — for CT, Planner,
Implementer, Reviewer, Researcher, plus any standing utility seats (vision, scouting).

**v2.5 extension:** the wizard closes by OFFERING the block's step 5 — run one trivial unit through
the full chain (brief → implement → review → checkpoint) — so setup ends at *verified*, not at
*written*. The difference between a configured tower and a working one.

**Explicitly out (Owner-ruled "overkill"):** writing models into a fresh pi install's config JSON.
If ever revisited, it needs its own safety case (backup + restore of the prior config, validation,
and a version-drift plan) — not a feature, a liability with a feature's face.

## The drift evidence (2026-09-18, live): skill-embedded pins fail exactly as predicted

The live skills' model pins drifted from the rulings with no error surfacing: the research skill
still pinned Sol after the Astra upgrade (four sites), the implement skill still pinned the
ORIGINAL `flash:low` after three seat rulings had passed over it (Astra standing, the :medium
direction, the succession). Every dispatch still worked — because the dispatcher carried the
roster mentally and overrode the pins explicitly. **The skill-embedded pin pattern has no
mechanical link to the rulings it encodes.** The manifest-driven design closes the gap
structurally: one source of truth, skills reference it, the wizard writes it, and a pin can never
again be three rulings stale without something failing to launch.

## Source material for development

The Owner's own pi configuration (the per-agent model/thinking/context setup) serves as the
development template for what the wizard reads and records.
