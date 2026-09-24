#!/usr/bin/env bash
# Atomic symlink-swap deploy for ownerspecs (pm2 app `os`, port 3004) — eliminates the
# `rm -rf .next` live-500 window AND the "no .next" gap of a plain mv-swap.
#
# Layout:  .next  is a SYMLINK -> .next-releases/<timestamp>  (a real build dir).
# Deploy:  build into a fresh release dir (out-of-place, live symlink untouched), then flip
#          the symlink with a single atomic `ln -sfn`. Rollback = relink the previous release.
# First run bootstraps the layout from the existing real `.next` with no downtime (moving a
# dir does not break the running process's already-open file handles on Linux).
#
# RUN ON THE VPS as the deploy user, from /home/deploy/ownerspecs:
#   USE_SPEC_FACTS=0 bash scripts/deploy-atomic.sh   # flag OFF (also: false/off)
#   USE_SPEC_FACTS=1 bash scripts/deploy-atomic.sh   # flag ON  (also: true/on)
# The app reads the flag via lib/specFacts.isSpecFactsEnabled(), which strict-equals "1".
# We normalize any accepted alias to exactly "1"/"0" below so the token can't drift.
#
# Requires next.config.ts: distDir: process.env.NEXT_DISTDIR || ".next"
set -euo pipefail

APP="os"; PORT="3004"; ROOT="/home/deploy/ownerspecs"
REL_DIR="$ROOT/.next-releases"
KEEP=3                       # how many old releases to retain for rollback
cd "$ROOT"

# --- 0. single-instance lock (flock, no TOCTOU) ---------------------------------------
exec 9>"$ROOT/.deploy.lock"
if ! flock -n 9; then echo "ABORT: another deploy holds the lock. Never build concurrently."; exit 1; fi

# Normalize to the exact token the app expects ("1"), accepting friendly aliases so a
# `USE_SPEC_FACTS=true` invocation can't silently no-op (that exact mismatch shipped a 404).
case "$(printf '%s' "${USE_SPEC_FACTS:-0}" | tr '[:upper:]' '[:lower:]')" in
  1|true|on|yes) FLAG=1 ;;
  *)             FLAG=0 ;;
esac
TS="$(date -u +%Y%m%d-%H%M%S)"
NEW_REL="$REL_DIR/$TS"
echo "=== deploy-atomic USE_SPEC_FACTS=$FLAG  release=$TS  $(date -u +%FT%TZ) ==="
mkdir -p "$REL_DIR"

# --- 1. build env (NEXT_DISTDIR points at the NEW real release dir) --------------------
set -a; source .env.local; set +a
export USE_SPEC_FACTS="$FLAG"
# NEXT_DISTDIR must be RELATIVE to the project root: Next resolves distDir via
# path.join(projectDir, distDir), so an ABSOLUTE value gets concatenated AFTER the project
# dir (-> /home/deploy/ownerspecs/home/deploy/ownerspecs/.next-releases/...), producing a
# doubly-nested build with no $NEW_REL/server/app. The relative form resolves to exactly
# $NEW_REL because we cd'd to $ROOT above. $NEW_REL stays absolute for the script's fs ops.
export NEXT_DISTDIR=".next-releases/$TS"
export NODE_OPTIONS="--max-old-space-size=3072"

# --- 1b. SOURCE-ONLY type check (the real safety gate) ---------------------------------
# Next's build-time TS check is disabled (next.config typescript.ignoreBuildErrors) because its
# generated route validator mis-resolves module paths under the nested-release + .next-symlink
# layout. tsconfig.build.json excludes all generated .next output and checks our source only.
echo "type-checking source (tsconfig.build.json) ..."
if ! npx --no-install tsc --noEmit -p tsconfig.build.json > /tmp/deploy_tsc.log 2>&1; then
  echo "TYPE CHECK FAILED — aborting deploy, live .next UNTOUCHED. Last lines:"; tail -30 /tmp/deploy_tsc.log; exit 1
fi
echo "type check OK"

# --- 2. build out-of-place (live symlink/.next keeps serving) --------------------------
rm -rf "$NEW_REL"
echo "building into $NEW_REL ..."
if ! npm run build > /tmp/deploy_build.log 2>&1; then
  echo "BUILD FAILED — live .next UNTOUCHED, zero downtime. Last lines:"; tail -25 /tmp/deploy_build.log
  rm -rf "$NEW_REL"; exit 1
fi
if grep -qE "Type error|Failed to compile|Error occurred prerendering|Command failed" /tmp/deploy_build.log; then
  echo "BUILD LOG SHOWS ERRORS — live .next UNTOUCHED:"; grep -nE "Type error|Failed to compile|Error occurred prerendering|Command failed" /tmp/deploy_build.log | head
  rm -rf "$NEW_REL"; exit 1
fi
if [ ! -d "$NEW_REL/server/app" ]; then
  echo "BUILD PRODUCED NO app OUTPUT — live .next UNTOUCHED."; rm -rf "$NEW_REL"; exit 1
fi
echo "build OK: $NEW_REL"

# --- 3. record current target for rollback, then flip the symlink ATOMICALLY ----------
PREV_TARGET=""
if [ -L "$ROOT/.next" ]; then
  PREV_TARGET="$(readlink -f "$ROOT/.next" || true)"
elif [ -d "$ROOT/.next" ]; then
  # First run: convert the real dir into the symlink layout (no downtime — open FDs survive the mv).
  echo "bootstrapping symlink layout from existing real .next ..."
  mv "$ROOT/.next" "$REL_DIR/bootstrap-$TS"
  PREV_TARGET="$REL_DIR/bootstrap-$TS"
fi
# ACCEPTED MICRO-RISK: between this ln -sfn and the completed pm2 restart below, the old
# (still-running) node process could theoretically serve a request whose code-split chunk
# just moved under it (webpack chunk paths are release-relative). Mitigated by restarting
# immediately after the symlink flip and by deploying off-peak; the window is milliseconds
# on a low-traffic first slice, so a heavier fix (e.g. dual-process drain) isn't worth it here.
ln -sfn "$NEW_REL" "$ROOT/.next"   # atomic: single rename of the symlink

# runtime must resolve distDir to ".next" (the symlink) and NOT inherit NEXT_DISTDIR.
NEXT_DISTDIR="" pm2 restart "$APP" --update-env >/dev/null
# hard-verify the runtime env has no stale NEXT_DISTDIR pointing at a build dir.
# Parse `pm2 jlist` as JSON rather than grepping `pm2 env` text — the text format has
# bitten us before (quoting/wrapping quirks can both false-positive and false-negative
# a plain grep). node -e reads pm2's own JSON so this can only match a real field value.
STALE_DISTDIR="$(pm2 jlist 2>/dev/null | node -e '
  let raw = "";
  try { raw = require("fs").readFileSync(0, "utf8"); } catch (e) {}
  let val = "";
  try {
    const apps = JSON.parse(raw || "[]");
    const app = apps.find((a) => a && a.name === process.argv[1]);
    const v = app && app.pm2_env && app.pm2_env.NEXT_DISTDIR;
    if (typeof v === "string" && v.length > 0) val = v;
  } catch (e) { /* malformed jlist output — treat as "no stale value" */ }
  process.stdout.write(val);
' "$APP" 2>/dev/null || true)"
if [ -n "$STALE_DISTDIR" ]; then
  echo "WARN: pm2 still exposes NEXT_DISTDIR=$STALE_DISTDIR — forcing a clean restart"; pm2 delete "$APP" >/dev/null 2>&1 || true
  ( cd "$ROOT" && NEXT_DISTDIR="" pm2 start npm --name "$APP" -- start >/dev/null )
fi

# --- 4. healthcheck: homepage (force-dynamic/SSR) + a deep SSG route + a control page --
# Poll with retries instead of one fixed sleep — tolerates cold-start (first request after
# restart can be slow to compile/serve) without either a flaky false-fail or an over-long wait.
ok=1
check() {
  local url="$1" attempt code
  for attempt in 1 2 3 4 5 6; do
    code="$(curl -fsS -o /dev/null -w '%{http_code}' "http://127.0.0.1:$PORT$url" 2>/dev/null || echo 000)"
    if [ "$code" = "200" ]; then echo "  $code  $url  (attempt $attempt)"; return 0; fi
    sleep 5
  done
  echo "  $code  $url  (FAILED after $attempt attempts)"
  ok=0
}
echo "healthcheck:"
# Base pages that MUST render in every build state (verified live: all 200 today).
check "/"                                                  # homepage (force-dynamic/SSR)
check "/honda/civic-sedan-x-2016-2021"                     # control gen hub
check "/honda/civic-sedan-x-2016-2021/oil-capacity"        # control topic page WITH data
# Slice-1 target: Rio /towing renders ONLY when the flag is ON (flag-OFF it correctly 404s —
# the Rio gen has zero legacy towing data, so notFound() is expected). Checking it flag-OFF
# would cause a FALSE rollback. So assert 200 there only for the flag-ON deploy.
if [ "$FLAG" = "1" ]; then
  check "/kia/rio-yb-hatchback-2018-2023/towing"           # slice-1 deep SSG route (verified masses)
fi

if [ "$ok" = "1" ]; then
  echo "=== DEPLOY OK — all healthchecks 200. release=$TS ==="
  # Prune old releases (keep newest $KEEP). NEVER delete the release the live symlink
  # currently points at, or PREV_TARGET (the rollback target) — compare full resolved
  # paths, not a basename substring grep, so a timestamp prefix collision can't false-match.
  CURRENT_TARGET="$(readlink -f "$ROOT/.next" || true)"
  while IFS= read -r d; do
    d="${d%/}"
    [ -z "$d" ] && continue
    [ "$d" = "$CURRENT_TARGET" ] && continue
    [ -n "$PREV_TARGET" ] && [ "$d" = "$PREV_TARGET" ] && continue
    rm -rf "$d"
  done < <(ls -1dt "$REL_DIR"/*/ 2>/dev/null | sed 's:/$::' | tail -n +$((KEEP+1)))
  exit 0
else
  echo "HEALTHCHECK FAILED — ROLLING BACK to $PREV_TARGET"
  if [ -n "$PREV_TARGET" ] && [ -d "$PREV_TARGET" ]; then
    ln -sfn "$PREV_TARGET" "$ROOT/.next"
    NEXT_DISTDIR="" pm2 restart "$APP" --update-env >/dev/null
    sleep 8
    echo "post-rollback /: $(curl -fsS -o /dev/null -w '%{http_code}' "http://127.0.0.1:$PORT/" || echo 000) (failed build kept at $NEW_REL)"
  else
    echo "NO valid PREV_TARGET to roll back to — manual intervention needed. Failed build at $NEW_REL"
  fi
  exit 1
fi
