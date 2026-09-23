#!/usr/bin/env python3
r"""
RDW masses & towing lane — PROTOTYPE (ownerspecs two-lane wedge, lane 1).

Pulls per-VIN NL masses/towing from RDW open data (Socrata), aggregates PER TVV
(typegoedkeuring + variant + uitvoering) to a single document-first fact per
mass_kind, and surfaces data pollution as WITHIN-TVV disagreement (the real
import-error signal, e.g. towing wrongly 0 on parallel imports).

Grain choice (vs kentekenfeiten's cohort min/median/max): a fact must trace to a
primary source at a real grain. RDW mass fields are constant across all VINs of
one exact TVV, so the modal value per TVV = a defensible per-TVV primary fact,
with an agreement ratio = confidence. Disagreement => qa_state='flagged'.

Output: scripts/output/rdw_masses_<target>.json  (maps 1:1 onto mass_homologations
rows once mig 579 is applied). Cross-checks against a held CoC when provided.

Reuses the proven sibling logic (kentekenfeiten/scripts/etl-modellen.mjs):
soda() token+429-retry, seeded windowed sampling, cohort WHERE builders.
License: RDW Open Data CC0 -> public_link=1.

Usage (PowerShell):  python scripts\rdw_masses_prototype.py --target kia-rio
"""
import json
import os
import re
import sys
import time
import urllib.parse
import urllib.request

R = "https://opendata.rdw.nl/resource"
OUT_DIR = os.path.join(os.path.dirname(__file__), "output")
KF_ENV = r"F:\projects\kentekenfeiten\.env"
SAMPLE = 1500
BATCH = 500
AGREE_FLAG = 0.80  # < this share agreeing within a TVV -> pollution suspect
MIN_N = 10         # panel 2026-09-23: < this many VINs on a mass fact -> flagged/unverified (safety over volume)

# m9d7-ebf2 fields (superset of sibling M9D7_SELECT + typegoedkeuring + technische max + type)
M9D7_SELECT = ",".join([
    "kenteken", "typegoedkeuringsnummer", "type", "variant", "uitvoering",
    "massa_rijklaar", "massa_ledig_voertuig",
    "toegestane_maximum_massa_voertuig", "technische_max_massa_voertuig",
    "maximum_trekken_massa_geremd", "maximum_massa_trekken_ongeremd",
    "maximum_massa_samenstelling",
    "datum_eerste_toelating", "datum_eerste_tenaamstelling_in_nederland",
    "export_indicator", "handelsbenaming",
])

# mass_kind (schema) -> RDW m9d7 field  (per-VIN; aggregated to per-TVV modal)
MASS_FIELDS = {
    "running_order": "massa_rijklaar",
    "max_laden_permissible": "toegestane_maximum_massa_voertuig",
    "max_laden_technical": "technische_max_massa_voertuig",
    "max_combination": "maximum_massa_samenstelling",
    "tow_braked": "maximum_trekken_massa_geremd",
    "tow_unbraked": "maximum_massa_trekken_ongeremd",
}

# TGK per-TYPE datasets — join on typegoedkeuringsnummer(full)+codevarianttgk+codeuitvoeringtgk.
# No kenteken round-trip: these are per-type, so they attach straight to a vehicle_type.
TGK_BASIS = "byxc-wwua"   # tow-ball (kogeldruk) + dimension bounds
TGK_AXLE = "xhyb-w7xt"    # per-axle max load + track width + driven/steered/braked flags

# Target cohorts. hb = handelsbenaming substring; base = typegoedkeuring prefix (optional).
TARGETS = {
    # Kia Rio YB — we HOLD this CoC (VIN KNADC511AH6033656): cross-check RDW vs CoC.
    "kia-rio": {
        "merk": "KIA", "hb": ["RIO"], "base": None,
        "datum_van": "20110101", "datum_tot": "20180101",
        "coc": {  # from the held CoC §0.2/§13/§16/§18/§19/§30
            "tvv": {"typegoedkeuring": "e11*2007/46*3777*00", "variant": "B5P11", "uitvoering": "M61BZ1"},
            "masses": {"running_order": 1160, "max_laden_technical": 1620,
                       "max_combination": 2730, "tow_braked": 1110, "tow_unbraked": 450,
                       "coupling_vertical": 75},  # §19 max static vertical mass at coupling (kogeldruk)
            "axles": [{"axle": 1, "max_load_kg": 945}, {"axle": 2, "max_load_kg": 840}],  # §16.2
        },
    },
    # High-volume NL car, no CoC held — pure breadth demo.
    "vw-golf-7": {
        "merk": "VOLKSWAGEN", "hb": ["GOLF"], "base": None,
        "datum_van": "20121101", "datum_tot": "20201231", "coc": None,
    },
}


def token():
    if os.environ.get("RDW_APP_TOKEN"):
        return os.environ["RDW_APP_TOKEN"]
    try:
        with open(KF_ENV, encoding="utf-8") as f:
            m = re.search(r"^RDW_APP_TOKEN=(.+)$", f.read(), re.M)
            return m.group(1).strip() if m else None
    except OSError:
        return None


TOKEN = token()


def soda(ds, params):
    url = f"{R}/{ds}.json?" + urllib.parse.urlencode(params)
    req = urllib.request.Request(url, headers={"Accept": "application/json"})
    if TOKEN:
        req.add_header("X-App-Token", TOKEN)
    for attempt in range(1, 6):
        try:
            with urllib.request.urlopen(req, timeout=60) as res:
                return json.load(res)
        except urllib.error.HTTPError as e:
            if e.code == 429:
                time.sleep(2 * attempt)
                continue
            raise
    raise RuntimeError(f"SODA {ds} kept failing")


def q(s):
    return str(s).replace("'", "''")


def where_for(t):
    parts = [f"merk='{q(t['merk'])}'"]
    if t.get("base"):
        parts.append(f"starts_with(typegoedkeuringsnummer,'{q(t['base'])}')")
    if t.get("hb"):
        ors = " or ".join(f"upper(handelsbenaming) like '%{q(s.upper())}%'" for s in t["hb"])
        parts.append(f"({ors})")
    if t.get("datum_van"):
        parts.append(f"datum_eerste_toelating>='{q(t['datum_van'])}'")
    if t.get("datum_tot"):
        parts.append(f"datum_eerste_toelating<'{q(t['datum_tot'])}'")
    parts.append("voertuigsoort='Personenauto'")
    return " and ".join(parts)


def mulberry32(seed_str):
    h = 1779033703 ^ len(seed_str)
    for ch in seed_str:
        h = (h ^ ord(ch)) & 0xFFFFFFFF
        h = (h * 3432918353) & 0xFFFFFFFF
        h = ((h << 13) | (h >> 19)) & 0xFFFFFFFF
    a = h & 0xFFFFFFFF
    def rng():
        nonlocal a
        a = (a + 0x6D2B79F5) & 0xFFFFFFFF
        t = a
        t = (t ^ (t >> 15)) * (1 | t) & 0xFFFFFFFF
        t = (t + ((t ^ (t >> 7)) * (61 | t) & 0xFFFFFFFF)) & 0xFFFFFFFF ^ t
        return ((t ^ (t >> 14)) & 0xFFFFFFFF) / 4294967296
    return rng


def sample_rows(t):
    where = where_for(t)
    cnt = soda("m9d7-ebf2", {"$select": "count(kenteken) as n", "$where": where})
    pop = int(cnt[0]["n"]) if cnt else 0
    if pop == 0:
        return [], 0
    if pop <= SAMPLE:
        rows = soda("m9d7-ebf2", {"$select": M9D7_SELECT, "$where": where,
                                  "$order": "kenteken", "$limit": str(pop)})
        return rows, pop
    rng = mulberry32(f"{t['merk']}|{''.join(t['hb'])}")
    by_k = {}
    for _ in range((SAMPLE + BATCH - 1) // BATCH):
        offset = int(rng() * (pop - BATCH))
        rows = soda("m9d7-ebf2", {"$select": M9D7_SELECT, "$where": where,
                                  "$order": "kenteken", "$limit": str(BATCH), "$offset": str(offset)})
        for r in rows:
            by_k[r["kenteken"]] = r
    return list(by_k.values()), pop


def num(v):
    try:
        n = float(v)
        return n if n > 0 else None
    except (TypeError, ValueError):
        return None


def is_import(toel, nl):
    if not (re.match(r"^\d{8}$", str(toel) or "") and re.match(r"^\d{8}$", str(nl) or "")):
        return None
    def d(s):
        return (int(s[:4]), int(s[4:6]), int(s[6:8]))
    import datetime
    a = datetime.date(*d(toel)); b = datetime.date(*d(nl))
    return (b - a).days > 31


def modal(values):
    """Return (modal_value, agreement_ratio, n_nonnull) over a list of numbers."""
    vals = [v for v in values if v is not None]
    if not vals:
        return None, None, 0
    counts = {}
    for v in vals:
        counts[v] = counts.get(v, 0) + 1
    best = max(counts.items(), key=lambda kv: kv[1])
    return best[0], best[1] / len(vals), len(vals)


def modal_field(grp, field):
    """Weighted-modal text value of a field across a TVV's grouped rows."""
    d = {}
    for r in grp:
        v = (r.get(field) or "").strip()
        if v:
            d[v] = d.get(v, 0) + int(r["n"])
    return max(d.items(), key=lambda kv: kv[1])[0] if d else None


def measure_tvvs(t):
    """One grouped query over the whole cohort → exact per-TVV mass distributions.
    Each returned row = (TVV, mass-combo, count); we fold to modal + agreement per field.
    No sampling: per-TVV masses are constant, so GROUP BY gives the authoritative value +
    surfaces pollution as minority mass-combos within a TVV."""
    where = where_for(t)
    cnt = soda("m9d7-ebf2", {"$select": "count(kenteken) as n", "$where": where})
    pop = int(cnt[0]["n"]) if cnt else 0
    # NB: m9d7 `inrichting` is unreliable for body (RDW codes 99% of Golf as 'stationwagen',
    # merging hatch+wagon). Use `handelsbenaming` (GOLF vs GOLF VARIANT vs GOLF SPORTSVAN) as the
    # bodystyle discriminator instead — it actually separates the heavier wagon from the hatch.
    group_cols = ["typegoedkeuringsnummer", "variant", "uitvoering", "handelsbenaming", "cilinderinhoud"] + list(dict.fromkeys(MASS_FIELDS.values()))
    rows = soda("m9d7-ebf2", {
        "$select": ",".join(group_cols) + ",count(kenteken) as n",
        "$where": where, "$group": ",".join(group_cols), "$limit": "50000",
    })
    tvvs = {}
    for r in rows:
        key = (r.get("typegoedkeuringsnummer", ""), r.get("variant", ""), r.get("uitvoering", ""))
        tvvs.setdefault(key, []).append(r)
    return tvvs, pop


def fold_tvv(grp):
    """grp = list of {mass fields..., n}. Return per-field modal value + agreement + flags."""
    total = sum(int(r["n"]) for r in grp)
    masses = {}
    for kind, field in MASS_FIELDS.items():
        dist = {}  # value -> count
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
        outliers = sorted(([int(v), c] for v, c in dist.items() if v != modal_val),
                          key=lambda x: -x[1])[:3]
        masses[kind] = {
            "value_kg": int(modal_val), "unit": "kg", "n": n_nonnull,
            "agreement": round(agree, 3), "source_field": f"m9d7-ebf2.{field}",
            "qa_state": "flagged" if flags else "pending", "flags": flags,
            "minority_values": outliers,
        }
    return masses, total


def bases_of(tvv_facts):
    """Distinct approval bases (strip the *NN extension) for starts_with TGK queries."""
    return sorted({f["typegoedkeuringsnummer"].rsplit("*", 1)[0]
                   for f in tvv_facts if f["typegoedkeuringsnummer"] and "*" in f["typegoedkeuringsnummer"]})


def _latest_rev(rows):
    return max((int(r.get("volgnummerrevisieuitvoering") or 0) for r in rows), default=0)


def fetch_tgk_basis(bases):
    """(tg,var,uitv) -> tow-ball (kogeldruk) + dims, latest revision."""
    per_key = {}
    for b in bases:
        try:
            rows = soda(TGK_BASIS, {
                "$select": "typegoedkeuringsnummer,codevarianttgk,codeuitvoeringtgk,volgnummerrevisieuitvoering,"
                           "maxverticalebelastopkoppbgr,wielbasisbovengrens,lengtebovengrens,breedtebovengrens,hoogtebovengrens",
                "$where": f"starts_with(typegoedkeuringsnummer,'{q(b)}')", "$limit": "20000"})
        except Exception:
            continue
        for r in rows:
            per_key.setdefault((r.get("typegoedkeuringsnummer", ""), r.get("codevarianttgk", ""), r.get("codeuitvoeringtgk", "")), []).append(r)
    out = {}
    for key, rows in per_key.items():
        rev = _latest_rev(rows)
        r = next((x for x in rows if int(x.get("volgnummerrevisieuitvoering") or 0) == rev), rows[0])
        out[key] = r
    return out


def fetch_tgk_axles(bases):
    """(tg,var,uitv) -> [ {axle, max_load_kg, track_mm, driven, steered, braked} ] latest revision."""
    per_key = {}
    for b in bases:
        try:
            rows = soda(TGK_AXLE, {
                "$select": "typegoedkeuringsnummer,codevarianttgk,codeuitvoeringtgk,volgnummerrevisieuitvoering,"
                           "volgnummeras,aangedrevenasindicator,stuurasindicator,geremdeasindicator,"
                           "spoorbreedtebovengrens,maximummassaasbelastingbgr",
                "$where": f"starts_with(typegoedkeuringsnummer,'{q(b)}')", "$limit": "40000"})
        except Exception:
            continue
        for r in rows:
            per_key.setdefault((r.get("typegoedkeuringsnummer", ""), r.get("codevarianttgk", ""), r.get("codeuitvoeringtgk", "")), []).append(r)
    out = {}
    for key, rows in per_key.items():
        rev = _latest_rev(rows)
        axles = {}
        for r in rows:
            if int(r.get("volgnummerrevisieuitvoering") or 0) != rev:
                continue
            a = r.get("volgnummeras")
            load = num(r.get("maximummassaasbelastingbgr"))
            track = num(r.get("spoorbreedtebovengrens"))
            axles[a] = {
                "axle": int(a) if (a or "").isdigit() else a,
                "max_load_kg": int(load) if load else None,
                "track_mm": int(track) if track else None,
                "driven": r.get("aangedrevenasindicator") == "J",
                "steered": r.get("stuurasindicator") == "J",
                "braked": r.get("geremdeasindicator") == "J",
            }
        out[key] = [axles[k] for k in sorted(axles, key=lambda x: (x or ""))]
    return out


def fetch_motorcode_map(bases):
    """(tg,var,uitv) -> {motorcode, fuel, cc, electric, hybrid} (primary drive, latest revision)."""
    per = {}
    for b in bases:
        try:
            rows = soda("4by9-ammk", {
                "$select": "typegoedkeuringsnummer,codevarianttgk,codeuitvoeringtgk,volgnummerrevisieuitvoering,"
                           "volgnummeraandrijving,motorcode,cilinderinhoud,codebrandstoftypemotor,"
                           "elektromotorindicator,hybridemotorindicator",
                "$where": f"starts_with(typegoedkeuringsnummer,'{q(b)}')", "$limit": "40000"})
        except Exception:
            continue
        for r in rows:
            per.setdefault((r.get("typegoedkeuringsnummer", ""), r.get("codevarianttgk", ""), r.get("codeuitvoeringtgk", "")), []).append(r)
    out = {}
    for key, rows in per.items():
        rev = _latest_rev(rows)
        cand = [r for r in rows if int(r.get("volgnummerrevisieuitvoering") or 0) == rev] or rows
        cand.sort(key=lambda r: int(r.get("volgnummeraandrijving") or 1))
        r = cand[0]
        out[key] = {
            "motorcode": (r.get("motorcode") or "").strip() or None,
            "fuel": (r.get("codebrandstoftypemotor") or "").strip() or None,
            "cc": r.get("cilinderinhoud"),
            "electric": r.get("elektromotorindicator") == "J",
            "hybrid": r.get("hybridemotorindicator") == "J",
        }
    return out


def fetch_transmission_map(bases):
    """(tg,var,uitv) -> {trans_type, gears} (latest revision)."""
    per = {}
    for b in bases:
        try:
            rows = soda("7rjk-eycs", {
                "$select": "typegoedkeuringsnummer,codevarianttgk,codeuitvoeringtgk,volgnummerrevisieuitvoering,"
                           "codetypeversnellingsbak,aantalversnellingenbovengrens",
                "$where": f"starts_with(typegoedkeuringsnummer,'{q(b)}')", "$limit": "40000"})
        except Exception:
            continue
        for r in rows:
            per.setdefault((r.get("typegoedkeuringsnummer", ""), r.get("codevarianttgk", ""), r.get("codeuitvoeringtgk", "")), []).append(r)
    out = {}
    for key, rows in per.items():
        rev = _latest_rev(rows)
        r = next((x for x in rows if int(x.get("volgnummerrevisieuitvoering") or 0) == rev), rows[0])
        out[key] = {"trans_type": (r.get("codetypeversnellingsbak") or "").strip() or None,
                    "gears": r.get("aantalversnellingenbovengrens")}
    return out


MASS_SPAN_VETO = 40  # kg — panel 2026-09-23: cluster running-order span above this must NOT publish as one trim mass


def cluster_tvvs(facts):
    """Cluster publishable per-TVV facts into marketed trims. Key = motorcode+transmission+body
    (fallback displacement+fuel+transmission+body). Apply the 40 kg mass-span veto."""
    clusters = {}
    for f in facts:
        mc = f.get("motorcode")
        body = f.get("body") or "?"
        tr = f.get("trans_type") or "?"
        gears = f.get("gears") or "?"
        if mc:
            key = ("mc", mc, tr, gears, body)
        else:
            key = ("cc", f.get("displacement_cc") or "?", f.get("fuel") or "?", tr, body)
        clusters.setdefault(key, []).append(f)
    out = []
    for key, members in clusters.items():
        ros = [m["masses"]["running_order"]["value_kg"] for m in members if "running_order" in m["masses"]]
        if not ros:
            continue
        span = max(ros) - min(ros)
        dom = max(members, key=lambda m: m["n_vins"])
        cc = dom.get("displacement_cc")
        label = " ".join(str(x) for x in [
            dom.get("motorcode") or key[1],
            f"{round(float(cc))}cc" if cc else "",
            dom.get("fuel") or "", f"{dom.get('trans_type') or ''}{dom.get('gears') or ''}",
            dom.get("body") or "",
        ] if x and str(x).strip())
        out.append({
            "cluster_key": "|".join(str(x) for x in key), "label": label,
            "n_tvv": len(members), "total_vins": sum(m["n_vins"] for m in members),
            "dominant_tvv": f"{dom['variant']}/{dom['uitvoering']}",
            "dominant_running_order_kg": dom["masses"].get("running_order", {}).get("value_kg"),
            "running_order_range_kg": [min(ros), max(ros)], "span_kg": span,
            "fallback_key": key[0] == "cc",
            "veto": span > MASS_SPAN_VETO,
        })
    out.sort(key=lambda c: -c["total_vins"])
    return out


def main():
    target = "kia-rio"
    if "--target" in sys.argv:
        target = sys.argv[sys.argv.index("--target") + 1]
    t = TARGETS[target]
    print(f"RDW app-token: {'present' if TOKEN else 'NONE (limited to ~1000/hr)'}")
    print(f"target: {target}  where: {where_for(t)}")

    tvvs, pop = measure_tvvs(t)
    print(f"population={pop}  distinct TVVs={len(tvvs)}")
    if not tvvs:
        print("no rows — check filters")
        return

    tvv_facts = []
    for (tg, variant, uitv), grp in tvvs.items():
        masses, n_vins = fold_tvv(grp)
        tvv_facts.append({
            "typegoedkeuringsnummer": tg, "variant": variant, "uitvoering": uitv,
            "n_vins": n_vins, "masses": masses,
            "body": modal_field(grp, "inrichting"),
            "displacement_cc": modal_field(grp, "cilinderinhoud"),
        })
    tvv_facts.sort(key=lambda f: -f["n_vins"])

    # Enrich per-TVV with per-type TGK data: tow-ball (kogeldruk) + per-axle load/track/flags.
    bases = bases_of(tvv_facts)
    print(f"TGK bases to fetch: {len(bases)}")
    basis = fetch_tgk_basis(bases)
    axles = fetch_tgk_axles(bases)
    n_towball = n_axles = 0
    for f in tvv_facts:
        key = (f["typegoedkeuringsnummer"], f["variant"], f["uitvoering"])
        b = basis.get(key)
        if b:
            tb = num(b.get("maxverticalebelastopkoppbgr"))
            if tb:
                f["masses"]["coupling_vertical"] = {
                    "value_kg": int(tb), "unit": "kg", "grain": "per-type",
                    "source_field": f"{TGK_BASIS}.maxverticalebelastopkoppbgr",
                    "qa_state": "pending", "flags": [],
                }
                n_towball += 1
        ax = axles.get(key)
        if ax:
            f["axles"] = ax  # track_mm -> spec_facts(dim_axle_track); max_load_kg -> mass_homologations(max_axle)
            n_axles += 1
    print(f"enriched: tow-ball on {n_towball} TVVs, axles on {n_axles} TVVs")

    # Clustering: enrich with motorcode + transmission, then group publishable TVVs into marketed trims.
    mc_map = fetch_motorcode_map(bases)
    tr_map = fetch_transmission_map(bases)
    for f in tvv_facts:
        key = (f["typegoedkeuringsnummer"], f["variant"], f["uitvoering"])
        m = mc_map.get(key) or {}
        for k in ("motorcode", "fuel", "electric", "hybrid"):
            if k in m:
                f[k] = m[k]
        f.update(tr_map.get(key) or {})
    publishable = [f for f in tvv_facts
                   if f["masses"].get("running_order", {}).get("n", 0) >= MIN_N
                   and f["masses"]["running_order"].get("agreement", 0) >= AGREE_FLAG]
    clusters = cluster_tvvs(publishable)
    n_veto = sum(1 for c in clusters if c["veto"])
    print(f"clustering: {len(publishable)} publishable TVVs -> {len(clusters)} trim clusters; "
          f"{n_veto} exceed the {MASS_SPAN_VETO}kg span veto")

    # import share from a light sample (context; import pollution also shows as within-TVV disagreement)
    import_share = None
    try:
        srows = sample_rows(t)[0][:1000]
        flags = [is_import(r.get("datum_eerste_toelating"), r.get("datum_eerste_tenaamstelling_in_nederland")) for r in srows]
        known = [f for f in flags if f is not None]
        import_share = round(sum(1 for f in known if f) / len(known), 3) if known else None
    except Exception:
        pass

    out = {
        "target": target, "source": "RDW Open Data (CC0) — m9d7-ebf2",
        "public_link": 1, "provenance_kind": "official_open_data", "doc_type": "rdw_open",
        "population": pop, "n_tvv": len(tvv_facts), "import_share": import_share,
        "grain": "per-TVV modal over full population (no sampling)",
        "mass_span_veto_kg": MASS_SPAN_VETO,
        "n_clusters": len(clusters), "clusters": clusters,
        "tvv_facts": tvv_facts,
    }

    # CoC cross-check — match the EXACT held-CoC TVV, not the top-VIN one.
    if t.get("coc"):
        want = t["coc"]["tvv"]
        match = next((f for f in tvv_facts
                      if f["variant"] == want["variant"] and f["uitvoering"] == want["uitvoering"]
                      and f["typegoedkeuringsnummer"] == want["typegoedkeuring"]), None)
        cc = {"tvv": f"{want['variant']}/{want['uitvoering']}",
              "found": bool(match), "n_vins": match["n_vins"] if match else 0, "compare": []}
        for kind, coc_val in t["coc"]["masses"].items():
            rdw = match["masses"].get(kind, {}).get("value_kg") if match else None
            cc["compare"].append({"mass_kind": kind, "coc": coc_val, "rdw": rdw,
                                  "match": rdw == coc_val, "delta": (rdw - coc_val) if rdw is not None else None})
        cc["axle_compare"] = []
        for ca in t["coc"].get("axles", []):
            rdw_ax = next((a for a in (match.get("axles") or []) if a["axle"] == ca["axle"]), None) if match else None
            rdw_load = rdw_ax["max_load_kg"] if rdw_ax else None
            cc["axle_compare"].append({"axle": ca["axle"], "coc": ca["max_load_kg"], "rdw": rdw_load,
                                       "match": rdw_load == ca["max_load_kg"]})
        out["coc_crosscheck"] = cc

    os.makedirs(OUT_DIR, exist_ok=True)
    path = os.path.join(OUT_DIR, f"rdw_masses_{target}.json")
    with open(path, "w", encoding="utf-8") as f:
        json.dump(out, f, ensure_ascii=False, indent=2)

    # summary
    print(f"TVVs={len(tvv_facts)}  import_share={import_share}")
    flagged = sum(1 for tf in tvv_facts for m in tf["masses"].values() if m["qa_state"] == "flagged")
    print(f"flagged mass facts={flagged}")
    print(f"top trim clusters ({len(clusters)} total):")
    for c in clusters[:12]:
        v = " [VETO>40kg]" if c["veto"] else ""
        lo, hi = c["running_order_range_kg"]
        print(f"  {c['label']}: {c['total_vins']} cars, {c['n_tvv']} TVVs, RO {lo}-{hi}kg (span {c['span_kg']}){v}")
    if out.get("coc_crosscheck"):
        print(f"CoC cross-check (TVV {out['coc_crosscheck']['tvv']}, n={out['coc_crosscheck']['n_vins']}):")
        for c in out["coc_crosscheck"]["compare"]:
            mark = "N/A " if c["rdw"] is None else ("OK  " if c["match"] else "DIFF")
            note = " (RDW gap -> CoC-only)" if c["rdw"] is None else ""
            print(f"  [{mark}] {c['mass_kind']}: CoC={c['coc']} RDW={c['rdw']} delta={c['delta']}{note}")
        for c in out["coc_crosscheck"].get("axle_compare", []):
            mark = "N/A " if c["rdw"] is None else ("OK  " if c["match"] else "DIFF")
            print(f"  [{mark}] axle {c['axle']} max_load: CoC={c['coc']} RDW={c['rdw']}")
    print(f"wrote {path}")


if __name__ == "__main__":
    main()
