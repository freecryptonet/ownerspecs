#!/usr/bin/env python3
r"""
Plan 2 RDW->schema writer — SEED / DRY-RUN ONLY (2026-09-23).

Exercises the productionized RDW ingest lane (per
docs/superpowers/plans/2026-09-23-rdw-lane-productionization.md) on the Kia Rio YB
cohort: fetches per-TVV mass/towing facts from RDW open data, computes agreement
PER-TVV (never cohort-wide — the corrected grain, report Sec 5.4), resolves the
generation_id/market_id/fact_type_id foreign keys by READING the prod DB (read-only
SELECTs only), and writes idempotent INSERT SQL to a file for human review.

THIS SCRIPT NEVER WRITES TO THE PROD DB. It only:
  1. Calls the public RDW Socrata API (read).
  2. Runs read-only `mariadb ownerspecs -e "SELECT ..."` over SSH to resolve FKs.
  3. Writes generated SQL to scripts/output/rdw_ingest_kia_rio.sql.

Reuses scripts/rdw_masses_prototype.py's proven logic: soda()/token() (via the
shared scripts.dq.rdw_client, same client scripts/dq already uses), per-TVV
grouping + fold_tvv() modal/agreement fold, TGK axle/tow-ball joins, and
cluster_tvvs() trim clustering with the 40kg span veto. One correction vs the
prototype (per the plan's Task 2 Step 1.3): the per-TVV group key now includes
the approval EXTENSION (mig 579's vehicle_types.uk_tvv key requires it — a
variant+version pair can carry different masses under different extensions).

Usage (PowerShell, from F:\projects\ownerspecs):
    .venv-manuals\Scripts\python.exe scripts\rdw_ingest\write_cohort.py
"""
from __future__ import annotations

import datetime
import json
import os
import subprocess
import sys
from collections import Counter

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
sys.path.insert(0, ROOT)

from scripts.dq.rdw_client import soda, token  # noqa: E402

OUT_DIR = os.path.join(ROOT, "scripts", "output")
OUT_SQL = os.path.join(OUT_DIR, "rdw_ingest_kia_rio.sql")
SSH_KEY = os.path.expanduser("~/.ssh/autodtcs_key")
SSH_HOST = "root@72.62.154.119"
DB_NAME = "ownerspecs"

MIN_N = 10          # panel 2026-09-23: below this VIN count on a mass fact -> flagged, not written
AGREE_FLAG = 0.80    # below this within-TVV agreement -> flagged, not written
MASS_SPAN_VETO = 40  # kg — a trim cluster spanning more than this must NOT publish as one mass

# m9d7-ebf2 fields (RDW "Gekentekende voertuigen" — per-VIN; aggregated to per-TVV modal)
M9D7_SELECT = ",".join([
    "kenteken", "typegoedkeuringsnummer", "type", "variant", "uitvoering",
    "massa_rijklaar", "massa_ledig_voertuig",
    "toegestane_maximum_massa_voertuig", "technische_max_massa_voertuig",
    "maximum_trekken_massa_geremd", "maximum_massa_trekken_ongeremd",
    "maximum_massa_samenstelling", "cilinderinhoud", "handelsbenaming",
])

# mass_kind (schema, mig 579) -> RDW m9d7 field. massa_ledig_voertuig is DELIBERATELY absent —
# it is RDW-derived (rijklaar - 100kg, NL admin convention), never a document/weight fact
# (memory reference_rdw_field_semantics.md). NEVER add it here.
MASS_FIELDS = {
    "running_order": "massa_rijklaar",
    "max_laden_permissible": "toegestane_maximum_massa_voertuig",
    "max_laden_technical": "technische_max_massa_voertuig",
    "max_combination": "maximum_massa_samenstelling",
    "tow_braked": "maximum_trekken_massa_geremd",
    "tow_unbraked": "maximum_massa_trekken_ongeremd",
}

TGK_BASIS = "byxc-wwua"   # tow-ball (kogeldruk) + dimension bounds, per-type
TGK_AXLE = "xhyb-w7xt"    # per-axle max load + track width + driven/steered/braked flags, per-type

# ---------------------------------------------------------------------------
# Cohort definition — ported from the plan's COHORTS["kia-rio-yb"] entry. The
# `base` filter (not just merk+hb+dates) is what actually disambiguates this from
# the OLDER Kia Rio UB generation (approval base e11*2007/46*0195, 2011-2017) —
# confirmed empirically below (see BLOCKER-check note in main()).
# ---------------------------------------------------------------------------
COHORT = {
    "key": "kia-rio-yb",
    "merk": "KIA",
    "hb": ["RIO"],
    "exclude": [],
    "base": "e11*2007/46*3777",
    "datum_van": "20110101",
    "datum_tot": "20180101",
    "brand_name": "Kia",
    "model_name": "Rio",
    "gen_slug_hint": "rio-yb",
    "coc": {
        "tvv": {"approval_base": "e11*2007/46*3777", "approval_extension": "00",
                "variant": "B5P11", "version": "M61BZ1"},
        "masses": {"running_order": 1160, "max_laden_technical": 1620,
                   "max_combination": 2730, "tow_braked": 1110, "tow_unbraked": 450,
                   "coupling_vertical": 75},
        "axles": [{"axle": 1, "max_load_kg": 945}, {"axle": 2, "max_load_kg": 840}],
    },
}


def q(s):
    return str(s).replace("'", "''")


def where_for(c):
    parts = [f"merk='{q(c['merk'])}'"]
    if c.get("base"):
        parts.append(f"starts_with(typegoedkeuringsnummer,'{q(c['base'])}')")
    if c.get("hb"):
        ors = " or ".join(f"upper(handelsbenaming) like '%{q(s.upper())}%'" for s in c["hb"])
        parts.append(f"({ors})")
    for ex in c.get("exclude", []):
        parts.append(f"not (upper(handelsbenaming) like '%{q(ex.upper())}%')")
    if c.get("datum_van"):
        parts.append(f"datum_eerste_toelating>='{q(c['datum_van'])}'")
    if c.get("datum_tot"):
        parts.append(f"datum_eerste_toelating<'{q(c['datum_tot'])}'")
    parts.append("voertuigsoort='Personenauto'")
    return " and ".join(parts)


def num(v):
    try:
        n = float(v)
        return n if n > 0 else None
    except (TypeError, ValueError):
        return None


def split_approval(tg):
    """'e11*2007/46*3777*00' -> ('e11*2007/46*3777', '00'). Extension IS part of TVV
    identity (mig 579 uk_tvv) — same variant+version under a different extension can
    carry a different mass (plan Task 2 Step 1.3: F5P41/M52AZ1 1104kg@*04 vs 1127kg@*06)."""
    if not tg or "*" not in tg:
        return tg or "", ""
    base, ext = tg.rsplit("*", 1)
    return base, ext


def modal_field(grp, field):
    d = {}
    for r in grp:
        v = (r.get(field) or "").strip()
        if v:
            d[v] = d.get(v, 0) + int(r["n"])
    return max(d.items(), key=lambda kv: kv[1])[0] if d else None


def measure_tvvs(c):
    """Grouped SoQL query -> per-TVV mass distributions. Group key is the CORRECTED
    4-tuple (approval_base, approval_extension, variant, uitvoering), not the
    prototype's 2-tuple that silently dropped the extension."""
    where = where_for(c)
    cnt = soda("m9d7-ebf2", {"$select": "count(kenteken) as n", "$where": where})
    pop = int(cnt[0]["n"]) if cnt else 0
    if pop == 0:
        return {}, 0
    group_cols = ["typegoedkeuringsnummer", "type", "variant", "uitvoering",
                  "handelsbenaming", "cilinderinhoud"] + list(dict.fromkeys(MASS_FIELDS.values()))
    rows = soda("m9d7-ebf2", {
        "$select": ",".join(group_cols) + ",count(kenteken) as n",
        "$where": where, "$group": ",".join(group_cols), "$limit": "50000",
    })
    tvvs = {}
    for r in rows:
        base, ext = split_approval(r.get("typegoedkeuringsnummer", ""))
        key = (base, ext, r.get("variant", ""), r.get("uitvoering", ""))
        tvvs.setdefault(key, []).append(r)
    return tvvs, pop


def fold_tvv(grp):
    """PER-TVV modal + agreement fold (report Sec 5.4 — the load-bearing correctness
    fix: called once per TVV group, never pooled across TVVs). Identical algorithm to
    scripts/rdw_masses_prototype.py's fold_tvv()."""
    total = sum(int(r["n"]) for r in grp)
    masses = {}
    for kind, field in MASS_FIELDS.items():
        dist = {}
        for r in grp:
            v = num(r.get(field))
            if v is not None:
                dist[v] = dist.get(v, 0) + int(r["n"])
        n_nonnull = sum(dist.values())
        if not dist:
            continue
        modal_val, modal_n = max(dist.items(), key=lambda kv: kv[1])
        agree = modal_n / n_nonnull
        flags = []
        if n_nonnull < MIN_N:
            flags.append(f"low_n:{n_nonnull}")
        if agree < AGREE_FLAG:
            flags.append(f"within_tvv_disagreement:{agree:.2f}")
        n_missing = total - n_nonnull
        if kind.startswith("tow") and n_missing > 0:
            flags.append(f"missing_on_{n_missing}/{total}")
        masses[kind] = {
            "value_kg": int(modal_val), "n": n_nonnull, "agreement": round(agree, 3),
            "qa_state": "flagged" if flags else "pending", "flags": flags,
        }
    return masses, total


def _latest_rev(rows):
    return max((int(r.get("volgnummerrevisieuitvoering") or 0) for r in rows), default=0)


def fetch_tgk_basis(bases):
    per_key = {}
    for b in bases:
        try:
            rows = soda(TGK_BASIS, {
                "$select": "typegoedkeuringsnummer,codevarianttgk,codeuitvoeringtgk,"
                           "volgnummerrevisieuitvoering,maxverticalebelastopkoppbgr",
                "$where": f"starts_with(typegoedkeuringsnummer,'{q(b)}')", "$limit": "20000"})
        except Exception:
            continue
        for r in rows:
            per_key.setdefault((r.get("typegoedkeuringsnummer", ""), r.get("codevarianttgk", ""),
                                r.get("codeuitvoeringtgk", "")), []).append(r)
    out = {}
    for key, rows in per_key.items():
        rev = _latest_rev(rows)
        out[key] = next((x for x in rows if int(x.get("volgnummerrevisieuitvoering") or 0) == rev), rows[0])
    return out


def fetch_tgk_axles(bases):
    per_key = {}
    for b in bases:
        try:
            rows = soda(TGK_AXLE, {
                "$select": "typegoedkeuringsnummer,codevarianttgk,codeuitvoeringtgk,"
                           "volgnummerrevisieuitvoering,volgnummeras,maximummassaasbelastingbgr",
                "$where": f"starts_with(typegoedkeuringsnummer,'{q(b)}')", "$limit": "40000"})
        except Exception:
            continue
        for r in rows:
            per_key.setdefault((r.get("typegoedkeuringsnummer", ""), r.get("codevarianttgk", ""),
                                r.get("codeuitvoeringtgk", "")), []).append(r)
    out = {}
    for key, rows in per_key.items():
        rev = _latest_rev(rows)
        axles = {}
        for r in rows:
            if int(r.get("volgnummerrevisieuitvoering") or 0) != rev:
                continue
            a = r.get("volgnummeras")
            load = num(r.get("maximummassaasbelastingbgr"))
            axles[a] = {"axle": int(a) if (a or "").isdigit() else a,
                        "max_load_kg": int(load) if load else None}
        out[key] = [axles[k] for k in sorted(axles, key=lambda x: (x or ""))]
    return out


def fetch_motorcode_map(bases):
    per = {}
    for b in bases:
        try:
            rows = soda("4by9-ammk", {
                "$select": "typegoedkeuringsnummer,codevarianttgk,codeuitvoeringtgk,"
                           "volgnummerrevisieuitvoering,volgnummeraandrijving,motorcode",
                "$where": f"starts_with(typegoedkeuringsnummer,'{q(b)}')", "$limit": "40000"})
        except Exception:
            continue
        for r in rows:
            per.setdefault((r.get("typegoedkeuringsnummer", ""), r.get("codevarianttgk", ""),
                            r.get("codeuitvoeringtgk", "")), []).append(r)
    out = {}
    for key, rows in per.items():
        rev = _latest_rev(rows)
        cand = [r for r in rows if int(r.get("volgnummerrevisieuitvoering") or 0) == rev] or rows
        cand.sort(key=lambda r: int(r.get("volgnummeraandrijving") or 1))
        out[key] = (cand[0].get("motorcode") or "").strip() or None
    return out


def fetch_transmission_map(bases):
    per = {}
    for b in bases:
        try:
            rows = soda("7rjk-eycs", {
                "$select": "typegoedkeuringsnummer,codevarianttgk,codeuitvoeringtgk,"
                           "volgnummerrevisieuitvoering,codetypeversnellingsbak,"
                           "aantalversnellingenbovengrens",
                "$where": f"starts_with(typegoedkeuringsnummer,'{q(b)}')", "$limit": "40000"})
        except Exception:
            continue
        for r in rows:
            per.setdefault((r.get("typegoedkeuringsnummer", ""), r.get("codevarianttgk", ""),
                            r.get("codeuitvoeringtgk", "")), []).append(r)
    out = {}
    for key, rows in per.items():
        rev = _latest_rev(rows)
        r = next((x for x in rows if int(x.get("volgnummerrevisieuitvoering") or 0) == rev), rows[0])
        out[key] = {"trans_type": (r.get("codetypeversnellingsbak") or "").strip() or None,
                    "gears": r.get("aantalversnellingenbovengrens")}
    return out


def cluster_tvvs(facts):
    clusters = {}
    for f in facts:
        mc = f.get("motorcode")
        body = f.get("body") or "?"
        tr = f.get("trans_type") or "?"
        gears = f.get("gears") or "?"
        key = ("mc", mc, tr, gears, body) if mc else ("cc", f.get("displacement_cc") or "?", tr, body)
        clusters.setdefault(key, []).append(f)
    out = []
    for key, members in clusters.items():
        ros = [m["masses"]["running_order"]["value_kg"] for m in members if "running_order" in m["masses"]]
        if not ros:
            continue
        span = max(ros) - min(ros)
        dom = max(members, key=lambda m: m["total_n"])
        out.append({
            "cluster_key": "|".join(str(x) for x in key),
            "n_tvv": len(members), "total_vins": sum(m["total_n"] for m in members),
            "dominant_tvv": f"{dom['variant']}/{dom['version']}",
            "running_order_range_kg": [min(ros), max(ros)], "span_kg": span,
            "veto": span > MASS_SPAN_VETO,
        })
    out.sort(key=lambda c: -c["total_vins"])
    return out


# ---------------------------------------------------------------------------
# Read-only FK resolution against the prod DB, over SSH. NEVER issues a write.
# ---------------------------------------------------------------------------
def mariadb_ro(sql):
    if "\"" in sql:
        raise ValueError("read-only helper query must not contain double quotes")
    remote_cmd = f'mariadb {DB_NAME} -B -e "{sql}"'
    proc = subprocess.run(["ssh", "-i", SSH_KEY, SSH_HOST, remote_cmd],
                           capture_output=True, text=True, timeout=60)
    if proc.returncode != 0:
        raise RuntimeError(f"read-only query failed: {proc.stderr.strip()}")
    lines = [ln for ln in proc.stdout.splitlines() if ln != ""]
    if not lines:
        return []
    header = lines[0].split("\t")
    return [dict(zip(header, ln.split("\t"))) for ln in lines[1:]]


def resolve_fks(cohort):
    """Read-only. Returns a dict of resolved FK facts + a list of blockers (empty = OK)."""
    blockers = []

    gens = mariadb_ro(
        "SELECT g.id, g.slug, g.start_year, g.end_year FROM generations g "
        "JOIN models mo ON mo.id=g.model_id JOIN makes ma ON ma.id=mo.make_id "
        f"WHERE ma.name='{cohort['brand_name']}' AND mo.name='{cohort['model_name']}' "
        f"AND g.slug LIKE '{cohort['gen_slug_hint']}%'")
    if len(gens) != 1:
        blockers.append(
            f"generation lookup for {cohort['brand_name']} {cohort['model_name']} "
            f"(slug~'{cohort['gen_slug_hint']}%') returned {len(gens)} rows, expected exactly 1: {gens}")
        generation_id = None
    else:
        generation_id = int(gens[0]["id"])

    markets = mariadb_ro("SELECT id, code FROM markets WHERE code='NL'")
    nl_market_id = int(markets[0]["id"]) if markets else None
    nl_market_exists = bool(markets)

    fact_types = mariadb_ro("SELECT id, code FROM fact_types WHERE code='mass_running_order'")
    mass_running_order_ft_id = int(fact_types[0]["id"]) if fact_types else None

    uk_market = mariadb_ro("SELECT id FROM markets WHERE code='UK'")
    uk_market_id = int(uk_market[0]["id"]) if uk_market else None

    return {
        "generation_id": generation_id,
        "generation_row": gens[0] if gens else None,
        "nl_market_exists": nl_market_exists,
        "nl_market_id": nl_market_id,
        "mass_running_order_ft_exists": bool(fact_types),
        "mass_running_order_ft_id": mass_running_order_ft_id,
        "uk_market_id": uk_market_id,
        "blockers": blockers,
    }


# ---------------------------------------------------------------------------
# SQL generation. Idempotent: markets/fact_types/vehicle_types key off their real
# UNIQUE keys (INSERT IGNORE); documents/mass_homologations/spec_facts have no
# natural unique key in mig 579, so we use INSERT ... SELECT ... WHERE NOT EXISTS
# keyed on the natural identity (generation/vehicle_type/market/mass_kind/fact_type,
# valid_to IS NULL) — a re-run of this exact SQL file inserts nothing new. This is a
# simplified stand-in for the full plan's Task 6 planner (which also version-forwards
# a CHANGED value via valid_to/supersedes_id) — that logic is NOT implemented here;
# re-running after a genuine value change would just no-op rather than version, which
# is safe (no duplicate/no clobber) but not the final behaviour.
# ---------------------------------------------------------------------------
def build_sql(cohort, fks, tvv_facts, coc_check):
    today = datetime.date.today().isoformat()
    retrieved = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    gen_id = fks["generation_id"]
    lines = []
    a = lines.append

    a("-- Plan 2 RDW->schema writer — GENERATED SQL, DRY-RUN OUTPUT (NOT APPLIED).")
    a(f"-- Cohort: {cohort['key']}  where: {where_for(cohort)}")
    a(f"-- Generated: {retrieved}  by scripts/rdw_ingest/write_cohort.py")
    a("-- Review before applying. Idempotent: safe to run more than once (see header docstring")
    a("-- for the one caveat — value CHANGES on rerun no-op instead of version-forwarding).")
    a("")
    a("SET NAMES utf8mb4;")
    a("")

    a("-- 0. markets: NL is absent from the current `markets` table (confirmed via read-only")
    a("--    SELECT — see report). Additive, keyed on the real UNIQUE constraint uk_markets_code.")
    a("INSERT INTO markets (code, name, is_active) VALUES ('NL', 'Netherlands', 1)")
    a("  ON DUPLICATE KEY UPDATE name = VALUES(name);")
    a("SET @market_nl = (SELECT id FROM markets WHERE code='NL');")
    a("")

    a("-- 1. fact_types: additive vocab entry for the CoC-doc-verifiable running-order mass as a")
    a("--    scalar spec_facts fact (separate from its typed mass_homologations row — see the")
    a("--    write_cohort.py summary for why this duplication exists / open question for Tim).")
    a("INSERT INTO fact_types (code, category, default_unit, value_kind)")
    a("  VALUES ('mass_running_order', 'mass', 'kg', 'num')")
    a("  ON DUPLICATE KEY UPDATE category = VALUES(category);")
    a("SET @ft_mass_running_order = (SELECT id FROM fact_types WHERE code='mass_running_order');")
    a("")

    a(f"-- 2. documents: ONE row for this ingest run (generation_id={gen_id}). No natural unique")
    a("--    key on `documents` (mig 579) -> idempotency via WHERE NOT EXISTS on a stable cohort")
    a("--    tag in `notes`.")
    a("INSERT INTO documents (doc_type, provenance_kind, generation_id, market_id, citation,")
    a("    public_link, license, retrieved_at, notes)")
    a("SELECT 'rdw_open', 'official_open_data', "
      f"{gen_id}, @market_nl, 'RDW Open Data (CC0)',")
    a(f"    1, 'CC0', NOW(), 'cohort:{cohort['key']} | RDW m9d7-ebf2 pull {retrieved} | "
      f"where={q(where_for(cohort))}'")
    a("WHERE NOT EXISTS (")
    a("  SELECT 1 FROM documents")
    a(f"  WHERE doc_type='rdw_open' AND generation_id={gen_id} AND market_id=@market_nl")
    a(f"    AND notes LIKE 'cohort:{cohort['key']}%'")
    a(");")
    a("SET @doc_id = (SELECT id FROM documents")
    a(f"  WHERE doc_type='rdw_open' AND generation_id={gen_id} AND market_id=@market_nl")
    a(f"    AND notes LIKE 'cohort:{cohort['key']}%' ORDER BY id DESC LIMIT 1);")
    a("")

    n_vt = n_mh = n_sf = 0
    a("-- 3. vehicle_types — one row per publishable TVV (total registrations >= "
      f"{MIN_N}). Idempotent via the real UNIQUE key uk_tvv.")
    for f in tvv_facts:
        if not f["publishable"]:
            continue
        n_vt += 1
        base, ext, variant, version = f["base"], f["ext"], f["variant"], f["version"]
        twin_key = f"{variant.lower()}|{version.lower()}"
        label = f["handelsbenaming"] or cohort["model_name"]
        a(f"INSERT IGNORE INTO vehicle_types (generation_id, category, approval_base, "
          f"approval_extension, tvv_type, tvv_variant, tvv_version, market_twin_key, "
          f"approval_market_id, commercial_label) VALUES (")
        a(f"  {gen_id}, 'M1', '{q(base)}', '{q(ext)}', '{q(f['rdw_type'] or '')}', "
          f"'{q(variant)}', '{q(version)}', '{q(twin_key)}',")
        a(f"  (SELECT id FROM markets WHERE code='UK'), '{q(label)}');")
    a("")

    a("-- 4. mass_homologations — per publishable TVV, per mass_kind. Flagged mass facts")
    a(f"--    (n<{MIN_N} or within-TVV agreement<{AGREE_FLAG}) are SKIPPED entirely, not written")
    a("--    pending (write-side gate, stricter than the render-side qa_state gate).")
    a("--    `conditions` carries the n/agreement audit trail as a stopgap (mig 579 has no")
    a("--    structured column for it yet — flagged as a migration-580 candidate).")
    a("--    Idempotent via WHERE NOT EXISTS keyed on (vehicle_type_id, market_id, mass_kind,")
    a("--    axle_index, valid_to IS NULL).")
    for f in tvv_facts:
        if not f["publishable"]:
            continue
        base, ext, variant, version = f["base"], f["ext"], f["variant"], f["version"]
        vt_where = (f"vt.approval_base='{q(base)}' AND vt.approval_extension='{q(ext)}' "
                    f"AND vt.tvv_variant='{q(variant)}' AND vt.tvv_version='{q(version)}'")
        for kind, m in f["masses"].items():
            if m["qa_state"] == "flagged":
                continue
            n_mh += 1
            cond = f"n={m['n']};agreement={m['agreement']}"
            a(f"INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, "
              f"mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, "
              f"qa_state)")
            a(f"SELECT {gen_id}, vt.id, @market_nl, '{kind}', NULL, {m['value_kg']}, "
              f"'{q(cond)}', @doc_id, CURDATE(), 'pending'")
            a(f"FROM vehicle_types vt WHERE {vt_where}")
            a("AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id "
              f"AND mh.market_id=@market_nl AND mh.mass_kind='{kind}' AND mh.axle_index IS NULL "
              "AND mh.valid_to IS NULL);")
        # coupling_vertical (per-type TGK tow-ball, deterministic — no n/agreement)
        if f.get("coupling_vertical") is not None:
            n_mh += 1
            a(f"INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, "
              f"mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, "
              f"qa_state)")
            a(f"SELECT {gen_id}, vt.id, @market_nl, 'coupling_vertical', NULL, "
              f"{f['coupling_vertical']}, 'per-type TGK basis (byxc-wwua), deterministic', "
              f"@doc_id, CURDATE(), 'pending'")
            a(f"FROM vehicle_types vt WHERE {vt_where}")
            a("AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id "
              "AND mh.market_id=@market_nl AND mh.mass_kind='coupling_vertical' "
              "AND mh.axle_index IS NULL AND mh.valid_to IS NULL);")
        # per-axle max load (per-type TGK axle, deterministic)
        for ax in f.get("axles") or []:
            if ax.get("max_load_kg") is None:
                continue
            n_mh += 1
            a(f"INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, "
              f"mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, "
              f"qa_state)")
            a(f"SELECT {gen_id}, vt.id, @market_nl, 'max_axle', {int(ax['axle'])}, "
              f"{ax['max_load_kg']}, 'per-type TGK axle (xhyb-w7xt), deterministic', @doc_id, "
              f"CURDATE(), 'pending'")
            a(f"FROM vehicle_types vt WHERE {vt_where}")
            a("AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id "
              f"AND mh.market_id=@market_nl AND mh.mass_kind='max_axle' "
              f"AND mh.axle_index={int(ax['axle'])} AND mh.valid_to IS NULL);")
    a("")

    a("-- 5. spec_facts — massa_rijklaar as a document-verifiable scalar fact (CoC S13 value).")
    a("--    massa_ledig_voertuig is DELIBERATELY never written here (RDW-derived, not a")
    a("--    document fact — see reference_rdw_field_semantics.md).")
    a("--    Idempotent via WHERE NOT EXISTS keyed on (vehicle_type_id, fact_type_id, market_id,")
    a("--    valid_to IS NULL).")
    for f in tvv_facts:
        if not f["publishable"]:
            continue
        ro = f["masses"].get("running_order")
        if not ro or ro["qa_state"] == "flagged":
            continue
        base, ext, variant, version = f["base"], f["ext"], f["variant"], f["version"]
        vt_where = (f"vt.approval_base='{q(base)}' AND vt.approval_extension='{q(ext)}' "
                    f"AND vt.tvv_variant='{q(variant)}' AND vt.tvv_version='{q(version)}'")
        n_sf += 1
        a(f"INSERT INTO spec_facts (generation_id, vehicle_type_id, fact_type_id, value_num, "
          f"unit, market_id, source_document_id, valid_from, qa_state)")
        a(f"SELECT {gen_id}, vt.id, @ft_mass_running_order, {ro['value_kg']}, 'kg', @market_nl, "
          f"@doc_id, CURDATE(), 'pending'")
        a(f"FROM vehicle_types vt WHERE {vt_where}")
        a("AND NOT EXISTS (SELECT 1 FROM spec_facts sf WHERE sf.vehicle_type_id=vt.id "
          "AND sf.fact_type_id=@ft_mass_running_order AND sf.market_id=@market_nl "
          "AND sf.valid_to IS NULL);")
    a("")

    return "\n".join(lines), {"vehicle_types": n_vt, "mass_homologations": n_mh, "spec_facts": n_sf}


def main():
    print(f"RDW app-token: {'present' if token() else 'NONE (throttled ~1000/hr)'}")
    print(f"cohort: {COHORT['key']}  where: {where_for(COHORT)}")

    # ---- FK resolution (read-only) ----
    fks = resolve_fks(COHORT)
    if fks["blockers"]:
        print("\nBLOCKER — cannot proceed:")
        for b in fks["blockers"]:
            print(f"  - {b}")
        sys.exit(1)
    print(f"generation_id resolved: {fks['generation_id']} ({fks['generation_row']})")
    print(f"NL market exists: {fks['nl_market_exists']} (will INSERT if absent)")
    print(f"fact_types.mass_running_order exists: {fks['mass_running_order_ft_exists']} "
          "(will INSERT IGNORE if absent)")

    # ---- RDW fetch ----
    tvvs, pop = measure_tvvs(COHORT)
    print(f"\npopulation={pop}  distinct TVVs (corrected grain, incl. extension)={len(tvvs)}")
    if not tvvs:
        print("no rows returned — check cohort filters")
        sys.exit(1)

    tvv_facts = []
    for (base, ext, variant, version), grp in tvvs.items():
        masses, total_n = fold_tvv(grp)
        tvv_facts.append({
            "base": base, "ext": ext, "variant": variant, "version": version,
            "rdw_type": modal_field(grp, "type"),
            "handelsbenaming": modal_field(grp, "handelsbenaming"),
            "displacement_cc": modal_field(grp, "cilinderinhoud"),
            "total_n": total_n, "masses": masses,
            "publishable": total_n >= MIN_N,
        })
    tvv_facts.sort(key=lambda f: -f["total_n"])

    # ---- TGK enrichment (per-type: tow-ball + axles + motorcode + transmission) ----
    bases = sorted({f["base"] for f in tvv_facts if f["base"]})
    print(f"TGK bases to fetch: {len(bases)}")
    basis = fetch_tgk_basis(bases)
    axles = fetch_tgk_axles(bases)
    mc_map = fetch_motorcode_map(bases)
    tr_map = fetch_transmission_map(bases)
    for f in tvv_facts:
        full_tg = f"{f['base']}*{f['ext']}"
        key = (full_tg, f["variant"], f["version"])
        b = basis.get(key)
        if b:
            tb = num(b.get("maxverticalebelastopkoppbgr"))
            f["coupling_vertical"] = int(tb) if tb else None
        else:
            f["coupling_vertical"] = None
        f["axles"] = axles.get(key) or []
        f["motorcode"] = mc_map.get(key)
        f.update(tr_map.get(key) or {})

    publishable = [f for f in tvv_facts if f["publishable"]]
    clusters = cluster_tvvs([f for f in publishable if "running_order" in f["masses"]
                              and f["masses"]["running_order"]["qa_state"] != "flagged"])
    n_veto = sum(1 for c in clusters if c["veto"])

    # ---- CoC cross-check (Kia Rio held CoC: VIN KNADC511AH6033656) ----
    want = COHORT["coc"]["tvv"]
    match = next((f for f in tvv_facts if f["base"] == want["approval_base"]
                  and f["ext"] == want["approval_extension"] and f["variant"] == want["variant"]
                  and f["version"] == want["version"]), None)
    coc_check = {"found": bool(match), "compare": []}
    if match:
        for kind, coc_val in COHORT["coc"]["masses"].items():
            if kind == "coupling_vertical":
                rdw = match.get("coupling_vertical")
            else:
                rdw = match["masses"].get(kind, {}).get("value_kg")
            coc_check["compare"].append({"mass_kind": kind, "coc": coc_val, "rdw": rdw,
                                          "match": rdw == coc_val})
        for ca in COHORT["coc"]["axles"]:
            rdw_ax = next((x for x in match["axles"] if x["axle"] == ca["axle"]), None)
            rdw_load = rdw_ax["max_load_kg"] if rdw_ax else None
            coc_check["compare"].append({"mass_kind": f"axle_{ca['axle']}_max_load",
                                          "coc": ca["max_load_kg"], "rdw": rdw_load,
                                          "match": rdw_load == ca["max_load_kg"]})

    # ---- Build + write SQL ----
    sql_text, counts = build_sql(COHORT, fks, tvv_facts, coc_check)
    os.makedirs(OUT_DIR, exist_ok=True)
    with open(OUT_SQL, "w", encoding="utf-8") as fh:
        fh.write(sql_text)

    # ---- Summary ----
    n_publishable = len(publishable)
    n_flagged_masses = sum(1 for f in tvv_facts for m in f["masses"].values()
                            if m["qa_state"] == "flagged")
    print(f"\n{'='*70}\nSUMMARY\n{'='*70}")
    print(f"TVVs total (corrected grain): {len(tvv_facts)}")
    print(f"TVVs publishable (total_n>={MIN_N}): {n_publishable}")
    print(f"Trim clusters: {len(clusters)} ({n_veto} exceed the {MASS_SPAN_VETO}kg span veto)")
    print(f"Flagged (skipped) mass facts across all TVVs: {n_flagged_masses}")
    print(f"Rows generated -> vehicle_types={counts['vehicle_types']}  "
          f"mass_homologations={counts['mass_homologations']}  spec_facts={counts['spec_facts']}")
    print(f"\nSample publishable TVVs (top 5 by total_n):")
    for f in publishable[:5]:
        ro = f["masses"].get("running_order", {})
        print(f"  {f['variant']}/{f['version']} ext={f['ext']}: n={f['total_n']} "
              f"running_order={ro.get('value_kg')}kg (agree={ro.get('agreement')}, "
              f"qa={ro.get('qa_state')})")
    print(f"\nCoC cross-check (VIN KNADC511AH6033656, TVV "
          f"{want['variant']}/{want['version']}):")
    if not coc_check["found"]:
        print("  TVV NOT FOUND in this cohort's RDW pull — cross-check FAILED")
    else:
        all_match = all(c["match"] or c["rdw"] is None for c in coc_check["compare"])
        for c in coc_check["compare"]:
            mark = "N/A " if c["rdw"] is None else ("OK  " if c["match"] else "DIFF")
            print(f"  [{mark}] {c['mass_kind']}: CoC={c['coc']} RDW={c['rdw']}")
        print(f"  overall: {'PASS' if all_match else 'DIFF FOUND'}")
    print(f"\nwrote {OUT_SQL}")

    # persist a JSON audit trail alongside the SQL (same convention as the prototype)
    audit_path = os.path.join(OUT_DIR, "rdw_ingest_kia_rio.json")
    with open(audit_path, "w", encoding="utf-8") as fh:
        json.dump({"cohort": COHORT["key"], "where": where_for(COHORT), "population": pop,
                   "fks": {k: v for k, v in fks.items() if k != "blockers"},
                   "tvv_facts": tvv_facts, "clusters": clusters, "coc_crosscheck": coc_check,
                   "counts": counts}, fh, ensure_ascii=False, indent=2, default=str)
    print(f"wrote {audit_path}")


if __name__ == "__main__":
    main()
