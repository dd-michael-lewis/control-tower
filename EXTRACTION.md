# Extraction provenance

Extracted from the source project at commit `d819aa3547e0a969f245aa25cd452377e3f8c52c` on 2026-09-18. The package was authored
in-repo over 2026-09-17/18 and is content-complete at extraction time.

**The one breaking-link note:** `worked-example.md` links into the source project's repository
(the receipts map - the incident docs, the trial records, the review chains). Those links resolve
in the source repo, not here; the map's explanatory value stands without them. If the source
record is ever published, update the pointers.

**The anomaly-log decision (2026-09-18):** the package ships the anomaly-log *template*
(`templates/anomaly-log.md` — the pattern: verbatim evidence, retry-then-parent-walk, the
recovery-path-immunity rule), NOT the source project's live log. The real log stays with its
owning project as ticket evidence — the package's ship-the-method-not-the-data principle.
