# Harness anomaly log — a standing evidence record (template)

**Purpose:** durable, timestamped evidence of reproducible agent-harness anomalies on YOUR
machines — kept per the same discipline as the Cemetery. Every future occurrence gets appended:
date, the exact command, the verbatim output, and the recovery that worked. **Evidence means
verbatim** — no summaries, no paraphrase.

**The format per entry:**

```
## Anomaly <N> — <the short name> (LIVE / prior art <date>)

**Symptom:** what presents. **The recovery that works:** the exact procedure (the
recovery path matters as much as the anomaly — document the immutable records that save you).

**Evidence <k> — <timestamp> (commands run back-to-back, same shell):**
<the verbatim command + output sequence>

**Impact (contained / open):** what it can and cannot destroy.
**Hypotheses (unverified, for the ticket):** the correlation candidates, marked as such.
```

**The rules that make it useful:**
- **Retry-then-parent-walk before believing any "missing" state** — filesystem flicker (often
  endpoint-security-adjacent) makes reads ENOENT on files that verifiably exist; retry, then
  enumerate the parent, before any judgment.
- **Know your immutable records.** The harness's per-run records (in pi: the async-run
  directories' `events.jsonl`) are typically the recovery backbone — in the source project's
  live episode, they were readable throughout while the primary output path flickered. Document
  YOUR recovery path's immunity as a design fact; it's the difference between an annoying
  anomaly and lost work.
- **No hosts, credentials, tokens, or content in entries** — bytes, timings, vendor names, and
  ticket numbers only. Evidence for tickets, not leaks.
- **Benign-failure presentations deserve entries too:** children completing with full output yet
  reporting failure (persist-step interruptions) are recovered the same way — "recover before
  believing a failure" is a standing rule, and the log is where the recoveries get recorded.
