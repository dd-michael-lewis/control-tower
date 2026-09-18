#!/bin/bash
# Shared-document write lock — acquire / release / renew / status, with bounded wait-and-retry.
# Covers HANDOFF.md, BACKLOG.md, CURRENT_PLAN.md, SCRATCHPAD.md. See CLAUDE.md / AGENTS.md §6
# "Shared-document write lock".
#
#   scripts/handoff-lock.sh acquire "Claude Opus 5 (1M context)"   # waits up to LOCK_WAIT secs
#   scripts/handoff-lock.sh renew                                  # extend before a long step
#   scripts/handoff-lock.sh release
#   scripts/handoff-lock.sh status
#
# Exit codes for `acquire`:
#   0  acquired
#   1  timed out — another live holder; report to the user, do NOT force
#   2  usage error
#
# WHY A LEASE AND NOT A PID (learned the hard way, 2026-09-10): the first version recorded `$$`
# so a blocked session could run `kill -0`. That is wrong here — `$$` is *this script's* pid, and
# it exits seconds later, so every lock read as instantly stale. There is no stable long-lived
# pid to record either: in an agentic harness each tool call is a fresh shell, and the "session"
# is not a process this script can see. A time lease needs no process identity: the holder
# declares how long it expects to need, and an expired lease is mechanical evidence of staleness
# whether the holder crashed, was closed, or simply wandered off.
set -uo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOCK="$REPO/.handoff.lock"
OWNER="$LOCK/owner"
LOCK_WAIT="${LOCK_WAIT:-300}"      # total seconds to wait for a busy lock (default 5 min)
LOCK_POLL="${LOCK_POLL:-5}"        # seconds between attempts
LOCK_LEASE="${LOCK_LEASE:-900}"    # how long a hold stays valid without renewal (default 15 min)

field() { sed -n "s/.*$1 \([0-9][0-9]*\).*/\1/p" "$OWNER" 2>/dev/null | head -1; }
expires_at() {
    local a l; a="$(field acquired)"; l="$(field lease)"
    [ -n "$a" ] && [ -n "$l" ] && echo $(( a + l )) || echo ""
}

write_owner() {
    printf '%s · acquired %s · lease %s · since %s\n' \
        "$1" "$(date +%s)" "$LOCK_LEASE" "$(date)" > "$OWNER"
}

# An expired lease is mechanical evidence of staleness, so this is the one case an agent may
# clear a lock it does not own (CLAUDE.md §6). A lock with no lease recorded is never reaped.
reap_if_expired() {
    local exp; exp="$(expires_at)"
    [ -n "$exp" ] || return 1
    [ "$(date +%s)" -ge "$exp" ] || return 1
    echo "  lease expired $(( $(date +%s) - exp ))s ago; clearing stale lock" >&2
    rm -rf "$LOCK"
    return 0
}

case "${1:-}" in
acquire)
    who="${2:-unknown agent}"
    deadline=$(( $(date +%s) + LOCK_WAIT ))
    announced=0
    while :; do
        if mkdir "$LOCK" 2>/dev/null; then
            write_owner "$who"
            echo "acquired: $(cat "$OWNER")"
            exit 0
        fi
        reap_if_expired && continue
        if [ "$announced" = 0 ]; then
            echo "waiting for lock, held by: $(cat "$OWNER" 2>/dev/null || echo '(unreadable)')" >&2
            announced=1
        fi
        if [ "$(date +%s)" -ge "$deadline" ]; then
            echo "TIMED OUT after ${LOCK_WAIT}s. Held by: $(cat "$OWNER" 2>/dev/null || echo '(unreadable)')" >&2
            echo "Report this to the user. Do not force the lock." >&2
            exit 1
        fi
        sleep "$LOCK_POLL"
    done
    ;;
renew)
    [ -d "$LOCK" ] || { echo "not held; nothing to renew" >&2; exit 1; }
    who="$(sed 's/ · acquired .*//' "$OWNER" 2>/dev/null)"
    write_owner "${who:-unknown agent}"
    echo "renewed: $(cat "$OWNER")"
    ;;
release)
    [ -d "$LOCK" ] || { echo "not held; nothing to release"; exit 0; }
    rm -rf "$LOCK"
    echo "released"
    ;;
status)
    if [ ! -d "$LOCK" ]; then echo "free"; exit 0; fi
    echo "HELD: $(cat "$OWNER" 2>/dev/null || echo '(no owner file)')"
    exp="$(expires_at)"
    if [ -z "$exp" ]; then
        echo "  no lease recorded — staleness cannot be self-diagnosed; ask the user"
    elif [ "$(date +%s)" -ge "$exp" ]; then
        echo "  lease EXPIRED $(( $(date +%s) - exp ))s ago — stale, safe to clear"
    else
        echo "  lease valid for another $(( exp - $(date +%s) ))s"
    fi
    ;;
*)
    echo "usage: $0 {acquire <agent-name>|renew|release|status}" >&2
    exit 2
    ;;
esac
