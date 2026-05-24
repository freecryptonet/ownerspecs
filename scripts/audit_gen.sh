#!/usr/bin/env bash
# audit_gen.sh — check a generation's moat-data completeness against per-table thresholds.
#
# Usage:
#   bash scripts/audit_gen.sh <gen_slug_or_id>
#
# Examples:
#   bash scripts/audit_gen.sh challenger-lc-coupe-2008-2023
#   bash scripts/audit_gen.sh 332
#
# Exit codes:
#   0  PASS: all minimums met, gen is ready to commit
#   1  FAIL: one or more tables below the mandatory minimum
#   2  ERROR: gen not found / DB connection error / bad arg
#
# Thresholds documented in memory/feedback_gen_completion_checklist.md.
# Run this BEFORE committing a gen-add mig.

set -u

if [ -z "${1:-}" ]; then
  echo "Usage: bash scripts/audit_gen.sh <gen_slug_or_id>"
  echo "       bash scripts/audit_gen.sh challenger-lc-coupe-2008-2023"
  exit 2
fi

ARG="$1"
SSH_KEY="${SSH_KEY:-$HOME/.ssh/autodtcs_key}"
SSH_HOST="${SSH_HOST:-root@72.62.154.119}"
SSH_OPTS="-i $SSH_KEY -o ConnectTimeout=10"

# Resolve arg → gen_id (numeric) or look up by slug
if [[ "$ARG" =~ ^[0-9]+$ ]]; then
  GEN_ID="$ARG"
else
  GEN_ID=$(ssh $SSH_OPTS "$SSH_HOST" "mariadb ownerspecs -BNe \"SELECT id FROM generations WHERE slug='$ARG' LIMIT 1;\"" 2>/dev/null)
  if [ -z "$GEN_ID" ]; then
    echo "ERROR: no generation with slug '$ARG'"
    exit 2
  fi
fi

# Fetch counts in a single round-trip
COUNTS=$(ssh $SSH_OPTS "$SSH_HOST" "mariadb ownerspecs -BNe \"
  SELECT g.slug,
         g.display_name,
         (SELECT COUNT(*) FROM fluid_specs       fs WHERE fs.generation_id=g.id),
         (SELECT COUNT(*) FROM electrical_specs  es WHERE es.generation_id=g.id),
         (SELECT COUNT(*) FROM bulbs             b  WHERE b.generation_id=g.id),
         (SELECT COUNT(*) FROM fuses             fu WHERE fu.generation_id=g.id),
         (SELECT COUNT(*) FROM tire_pressures    tp WHERE tp.generation_id=g.id),
         (SELECT COUNT(*) FROM torque_specs      ts WHERE ts.generation_id=g.id),
         (SELECT COUNT(*) FROM service_intervals si WHERE si.generation_id=g.id),
         (SELECT COUNT(*) FROM parts             p  WHERE p.generation_id=g.id),
         (SELECT COUNT(*) FROM procedures        pr WHERE pr.generation_id=g.id AND LENGTH(pr.body_md)>=100)
    FROM generations g
   WHERE g.id=$GEN_ID;\"" 2>/dev/null)

if [ -z "$COUNTS" ]; then
  echo "ERROR: generation id=$GEN_ID not found or DB query failed"
  exit 2
fi

# Parse tab-separated fields
IFS=$'\t' read -r SLUG NAME FLUIDS ELEC BULBS FUSES TIRES TORQUES SVC PARTS PROCS <<< "$COUNTS"

# Thresholds (min = mandatory; target = best practice)
declare -A MIN
MIN[fluids]=8    ; MIN[elec]=1    ; MIN[bulbs]=6  ; MIN[fuses]=5
MIN[tires]=2     ; MIN[torques]=3 ; MIN[svc]=5    ; MIN[parts]=2

declare -A TARGET
TARGET[fluids]=15 ; TARGET[elec]=1   ; TARGET[bulbs]=10 ; TARGET[fuses]=8
TARGET[tires]=5   ; TARGET[torques]=5; TARGET[svc]=10   ; TARGET[parts]=4
TARGET[procs]=2

declare -A VALS
VALS[fluids]=$FLUIDS ; VALS[elec]=$ELEC ; VALS[bulbs]=$BULBS ; VALS[fuses]=$FUSES
VALS[tires]=$TIRES   ; VALS[torques]=$TORQUES ; VALS[svc]=$SVC ; VALS[parts]=$PARTS
VALS[procs]=$PROCS

# Color helpers (TTY only)
if [ -t 1 ]; then
  RED=$'\e[31m' ; GREEN=$'\e[32m' ; YELLOW=$'\e[33m' ; CYAN=$'\e[36m' ; BOLD=$'\e[1m' ; RESET=$'\e[0m'
else
  RED='' ; GREEN='' ; YELLOW='' ; CYAN='' ; BOLD='' ; RESET=''
fi

echo
echo "${BOLD}Gen audit:${RESET} ${CYAN}$SLUG${RESET} (id=$GEN_ID)"
echo "          ${NAME:-(no display_name)}"
echo
printf "  %-12s %5s   %5s   %5s   %s\n" "Table" "rows" "min" "target" "Status"
echo  "  -----------+-------+-------+-------+----------"

FAIL_COUNT=0
WARN_COUNT=0

check() {
  local label="$1" key="$2"
  local val=${VALS[$key]}
  local min=${MIN[$key]:-}
  local target=${TARGET[$key]}
  local status
  if [ -n "$min" ] && [ "$val" -lt "$min" ]; then
    status="${RED}[FAIL]${RESET} below mandatory minimum"
    FAIL_COUNT=$((FAIL_COUNT + 1))
  elif [ "$val" -lt "$target" ]; then
    status="${YELLOW}[WARN]${RESET} below target"
    WARN_COUNT=$((WARN_COUNT + 1))
  else
    status="${GREEN}[ OK ]${RESET}"
  fi
  printf "  %-12s %5d   %5s   %5d   %b\n" "$label" "$val" "${min:--}" "$target" "$status"
}

check "fluid_specs"   fluids
check "electrical"    elec
check "bulbs"         bulbs
check "fuses"         fuses
check "tire_pressur"  tires
check "torque_specs"  torques
check "svc_intervals" svc
check "parts"         parts
check "procedures*"   procs

echo
echo "  * procedures count = rows with body_md length >= 100 chars"
echo

if [ "$FAIL_COUNT" -gt 0 ]; then
  echo "${BOLD}${RED}OVERALL: FAIL${RESET} — $FAIL_COUNT mandatory minimum(s) below threshold."
  echo "  Add the missing data BEFORE committing. See memory/feedback_gen_completion_checklist.md."
  exit 1
fi

if [ "$WARN_COUNT" -gt 0 ]; then
  echo "${BOLD}${YELLOW}OVERALL: PASS (with warnings)${RESET} — $WARN_COUNT table(s) below target. Acceptable but mention in commit message."
  exit 0
fi

echo "${BOLD}${GREEN}OVERALL: PASS${RESET} — all moat tables meet target depth. Ready to commit."
exit 0
