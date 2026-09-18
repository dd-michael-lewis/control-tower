# The §10.3 diagnosis block (copy into any stated cause — chat, plan, or findings entry)

### Diagnosis — <symptom>
Claim:               <one falsifiable sentence>
Confidence:          CONFIRMED | STRONG | PLAUSIBLE | UNKNOWN
Evidence:            <measurements only — log lines, probe results, file:line>
Does NOT prove:      <the gap between the measurement and the claim>
Devil's advocate:    >=3 counter-hypotheses; each names the code/log that separates it;
                     each marked checked / not-checked
Cheapest refutation: <the single observation that would kill this — and whether it has been made>
If we ship this:     <what the user should see change; and if nothing changes, the next check is X>

**The fixed vocabulary:** CONFIRMED (cause reproduced AND a change flips it) / STRONG (mechanism
located, locally-checkable counters eliminated) / PLAUSIBLE (mechanism located, counters not
eliminated) / UNKNOWN (nothing located). Banned below CONFIRMED: "the root cause is," "that's the
bug," "fixed," "this will fix it." Speculative fixes are allowed, labeled as such, naming what to
watch so the user builds no expectation the fix cannot meet.

**The wheel-spin triggers:** 2 consecutive no-progress cycles → soft flag + the evidence ledger
into the checkpoint. 3 → mandatory stop and step-back. 2 consecutive cross-subsystem hypotheses →
fires regardless. A change whose failure teaches nothing → stop and instrument instead.
