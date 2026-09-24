#!/usr/bin/env bash
# PRE-FLIGHT (panel option B): validate the symlink + pm2 runtime mechanics against the real
# VPS using the CURRENT .next as "release 0" — NO rebuild. Proves the only VPS-untested layer
# (symlink layout + pm2 restart + NEXT_DISTDIR handling) cheaply before risking a 15.8k-page
# build. Auto-rolls-back the bootstrap on any failure.
#
# RUN ON THE VPS as the deploy user, from /home/deploy/ownerspecs.
set -uo pipefail
APP="os"; PORT="3004"; ROOT="/home/deploy/ownerspecs"; cd "$ROOT"
REL_DIR="$ROOT/.next-releases"; TS="$(date -u +%Y%m%d-%H%M%S)"
mkdir -p "$REL_DIR"

echo "baseline / : $(curl -fsS -o /dev/null -w '%{http_code}' http://127.0.0.1:$PORT/ 2>/dev/null || echo 000)"

BOOTSTRAPPED=""
if [ -L "$ROOT/.next" ]; then
  echo "already a symlink -> $(readlink "$ROOT/.next"); skipping bootstrap"
elif [ -d "$ROOT/.next" ]; then
  echo "bootstrapping symlink layout from real .next ..."
  mv "$ROOT/.next" "$REL_DIR/release-$TS"
  ln -sfn "$REL_DIR/release-$TS" "$ROOT/.next"
  BOOTSTRAPPED="$REL_DIR/release-$TS"
  echo ".next -> $(readlink "$ROOT/.next")"
else
  echo "FATAL: no .next present"; exit 1
fi

NEXT_DISTDIR="" pm2 restart "$APP" --update-env >/dev/null
STALE="$(pm2 jlist 2>/dev/null | node -e 'let r="";try{r=require("fs").readFileSync(0,"utf8")}catch(e){}let v="";try{const a=JSON.parse(r||"[]");const p=a.find(x=>x&&x.name===process.argv[1]);const d=p&&p.pm2_env&&p.pm2_env.NEXT_DISTDIR;if(typeof d==="string"&&d.length)v=d}catch(e){}process.stdout.write(v)' "$APP" 2>/dev/null || true)"
echo "pm2 NEXT_DISTDIR after restart: '${STALE:-<empty, good>}'"

fail=0
for u in "/" "/honda/civic-sedan-x-2016-2021" "/honda/civic-sedan-x-2016-2021/oil-capacity" "/kia/rio-yb-hatchback-2018-2023"; do
  code=000
  for a in 1 2 3 4 5 6; do
    code="$(curl -fsS -o /dev/null -w '%{http_code}' "http://127.0.0.1:$PORT$u" 2>/dev/null || echo 000)"
    [ "$code" = "200" ] && break; sleep 5
  done
  echo "  $code  $u"; [ "$code" = "200" ] || fail=1
done
# also confirm a static _next asset resolves through the symlink (grab one from the homepage HTML)
ASSET="$(curl -fsS "http://127.0.0.1:$PORT/" 2>/dev/null | grep -oE '/_next/static/[^"]+\.js' | head -1 || true)"
if [ -n "$ASSET" ]; then
  ac="$(curl -fsS -o /dev/null -w '%{http_code}' "http://127.0.0.1:$PORT$ASSET" 2>/dev/null || echo 000)"
  echo "  $ac  (static asset) $ASSET"; [ "$ac" = "200" ] || fail=1
fi

if [ "$fail" = "0" ] && [ -z "$STALE" ]; then
  echo "=== PREFLIGHT_OK — symlink+pm2 mechanics validated on the VPS ==="
  exit 0
else
  echo "=== PREFLIGHT_FAIL — rolling back the bootstrap ==="
  if [ -n "$BOOTSTRAPPED" ] && [ -d "$BOOTSTRAPPED" ]; then
    rm -f "$ROOT/.next"; mv "$BOOTSTRAPPED" "$ROOT/.next"
    NEXT_DISTDIR="" pm2 restart "$APP" --update-env >/dev/null; sleep 8
    echo "post-rollback / : $(curl -fsS -o /dev/null -w '%{http_code}' http://127.0.0.1:$PORT/ 2>/dev/null || echo 000)"
  fi
  exit 1
fi
