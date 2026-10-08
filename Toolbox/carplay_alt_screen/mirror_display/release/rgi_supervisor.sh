#!/bin/sh
# Always-on Allemon arrow renderer; Java owns data and display contexts.
set -eu
PATH=${PATH:+$PATH:}/proc/boot:/armle/bin:/bin:/usr/bin:/mnt/app/armle/bin:/eso/bin
export PATH
HERE=$(CDPATH= cd "${0%/*}" && pwd) || exit 2
TMP_ROOT=${ALT111_MIRROR_TMP_ROOT:-/tmp}
BIN=${RGI_RENDERER_BIN:-$HERE/../rgi/maneuver_render}
PIDFILE=$TMP_ROOT/altscreen_rgi_supervisor.pid
CHILDFILE=$TMP_ROOT/altscreen_rgi_renderer.pid
LOCK=$TMP_ROOT/altscreen_rgi_supervisor.lock
LOG=$TMP_ROOT/maneuver_render.log
DISABLED=$TMP_ROOT/mmi-rgi.disabled
STOP=$TMP_ROOT/altscreen_mirror.stop.requested
MAX_RESTARTS=${RGI_MAX_RESTARTS:-3}
case "$MAX_RESTARTS" in ''|*[!0-9]*) exit 2 ;; esac
[ -x "$BIN" ] || { echo "RGI_SUPERVISOR=FAIL reason=missing_renderer"; exit 2; }
stale=0
if [ -f "$PIDFILE" ]; then
  old=$(cat "$PIDFILE" 2>/dev/null || true)
  case "$old" in ''|*[!0-9]*) ;; *)
    if kill -0 "$old" 2>/dev/null; then echo "RGI_SUPERVISOR=ALREADY_RUNNING"; exit 0; fi
    stale=1 ;;
  esac
fi
# A live owner holds the lock through its child's wait/reap. An interrupted
# launcher can leave it stale; only reclaim after the owner is proven absent.
if [ "$stale" = 1 ]; then rmdir "$LOCK" 2>/dev/null || true; fi
mkdir "$LOCK" 2>/dev/null || exit 0
echo "$$" > "$PIDFILE"
child=""
cleanup() {
  trap - 0 1 2 15
  if [ -n "$child" ]; then
    kill -TERM "$child" 2>/dev/null || true
    n=0
    while kill -0 "$child" 2>/dev/null && [ "$n" -lt 2 ]; do sleep 1; n=$((n+1)); done
    kill -KILL "$child" 2>/dev/null || true
    wait "$child" 2>/dev/null || true
  fi
  rm -f "$PIDFILE" "$CHILDFILE"
  rmdir "$LOCK" 2>/dev/null || true
  echo "RGI_SUPERVISOR=STOPPED owner=$$" >> "$LOG"
}
trap cleanup 0
trap 'exit 0' 1 2 15
failures=0
echo "RGI_SUPERVISOR=STARTED owner=$$ restart_limit=$MAX_RESTARTS" >> "$LOG"
while [ ! -f "$DISABLED" ] && [ ! -f "$STOP" ]; do
  if [ -d /proc/boot ] && [ -d /mnt/app ]; then
    LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}/proc/boot:/usr/lib:/armle/lib:/armle/lib/dll:/lib:/mnt/app/usr/lib:/eso/lib
    export LD_LIBRARY_PATH
  fi
  started=$(date +%s)
  (cd "${BIN%/*}" && LD_PRELOAD= exec "$BIN") >> "$LOG" 2>&1 &
  child=$!
  echo "$child" > "$CHILDFILE"
  rc=0
  wait "$child" || rc=$?
  child=""
  rm -f "$CHILDFILE"
  [ ! -f "$DISABLED" ] && [ ! -f "$STOP" ] || break
  elapsed=$(($(date +%s)-started))
  [ "$elapsed" -lt 60 ] || failures=0
  failures=$((failures+1))
  echo "RGI_RENDERER_EXIT rc=$rc uptime=$elapsed consecutive=$failures" >> "$LOG"
  if [ "$failures" -gt "$MAX_RESTARTS" ]; then
    echo "RGI_SUPERVISOR=RESTART_LIMIT action=WAIT_FOR_NEXT_START" >> "$LOG"
    break
  fi
  sleep $((failures*2))
done
