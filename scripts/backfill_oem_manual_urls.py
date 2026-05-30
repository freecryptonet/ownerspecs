#!/usr/bin/env python3
"""backfill_oem_manual_urls.py — populate generations.oem_manual_url.

Walks the local F:\\projects\\ownerspecs\\manuals\\ directory (the canonical
PDF home per the local-canonical architecture decided 2026-05-28). The
crawler-prefixed filenames are deterministic — we re-derive the manufacturer
URL from the prefix without needing manual_inventory rows on the VPS DB.
Then matches each (brand, model, year) candidate to generations rows on
brand + fuzzy model + year overlap and writes the latest match.

This is the right shape after the on-demand pivot: we don't need to convert
or index every PDF just to surface a download link. The filename alone is
enough.

Per [[reference_source_link_gating]]: all derived URLs are manufacturer-owned
domains, so `oem_manual_url` is `public_link=1` eligible.

Supported crawlers (filename → URL derivation):
- mazda_<model>_<year>.pdf            → www.mazda.ca/globalassets/.../<file>
- nissan_<year>_<rest>.pdf            → www.nissanusa.com/content/dam/...
- infiniti_<year>_<rest>.pdf          → www.infinitiusa.com/content/dam/...
- kia_ca_<file>.pdf                   → www.kia.ca/content/dam/...
- mercedes_<chassis-slug>.pdf         → www.mbusa.com/css-oom/...
- gm_<brand>_<file>.pdf               → contentdelivery.ext.gm.com/...
- ford_<file>.pdf                     → www.fordservicecontent.com/...

Skipped (require catalog JSON lookup or have no direct URL):
- mopar_* (DocCode catalog), hyundai_* (multi-CDN), mitsu_* (NL-encoded
  filenames), genesis_ca_* (POST file_key only).

Usage:
    python scripts/backfill_oem_manual_urls.py --dry-run
    python scripts/backfill_oem_manual_urls.py --brand cadillac
    python scripts/backfill_oem_manual_urls.py            # all derivable
"""
from __future__ import annotations

import argparse
import os
import re
import sys
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
MANUALS_DIR = ROOT / "manuals"
MOPAR_URL_MAP = ROOT / "mopar_url_map.json"
HYUNDAI_URL_MAP = ROOT / "hyundai_url_map.json"
KIA_URL_MAP = ROOT / "kia_url_map.json"
TOYOTA_URL_MAP = ROOT / "toyota_url_map.json"

MONTHS = ["", "january", "february", "march", "april", "may", "june",
          "july", "august", "september", "october", "november", "december"]

# Mopar filename → brand lookup. Multi-token brands (alfa_romeo) get matched
# first so they win against the single-token fallback.
MOPAR_BRANDS = (
    ("alfa_romeo", "alfa-romeo"),
    ("chrysler",   "chrysler"),
    ("dodge",      "dodge"),
    ("fiat",       "fiat"),
    ("jeep",       "jeep"),
    ("ram",        "ram"),
)


# Hyundai chassis codes (lowercase). The chassis is the strongest disambiguator
# between same-platform sibling cars (i20 BC3 vs Bayon BC3), so we surface it
# to the gen-matching layer via the existing chassis tiebreaker (codename match).
HYUNDAI_CHASSIS = {
    "ac3", "ia",                       # i10
    "bc3", "gb", "pb",                 # i20 / Bayon (BC3 shared)
    "gde", "pde",                      # i30
    "vf",                              # i40
    "ax1",                             # Inster
    "ae",                              # IONIQ (first gen, AE)
    "ne",                              # IONIQ 5
    "ce",                              # IONIQ 6
    "jc",                              # ix20
    "os", "osn", "sx2",                # Kona
    "fe",                              # Nexo
    "dm", "tm", "mx5",                 # Santa Fe
    "tle", "nx4", "nx4e",              # Tucson
    "lx2",                             # Palisade
}


# Toyota EU multi-word model heads — first N tokens of the filename body
# resolve to a single DB model_slug.
TOYOTA_MULTIWORD_MODELS = {
    ("gr", "86"):       "gr-86",
    ("gr", "supra"):    "gr-supra",
    ("gr", "yaris"):    "gr-yaris",
    ("gt", "86"):       "gt-86",
    ("land", "cruiser"): "land-cruiser",
    ("toyota", "c", "hr"): "c-hr",
    ("aygo", "x"):      "aygo-x",
    ("corolla", "cross"): "corolla-cross",
    ("yaris", "cross"): "yaris-cross",
    ("yaris", "grmn"):  "yaris-grmn",
    ("proace", "city"): "proace-city",
    ("proace", "max"):  "proace-max",
    ("proace", "verso"): "proace-verso",
    ("urban", "cruiser"): "urban-cruiser",
}
# Numeric series → chassis codename. Land Cruiser 150 = J150 etc.
TOYOTA_CHASSIS_HINTS: dict[str, dict[str, str]] = {
    "land-cruiser": {"70": "J70", "100": "J100", "150": "J150", "200": "J200", "250": "J250", "300": "J300"},
    "gr-supra":     {"a90": "A90"},
    "prius":        {},
    "rav4":         {},
}
TOYOTA_BODY_TOKENS = {
    "sedan": "sedan", "saloon": "sedan",
    "hatchback": "hatchback", "hatch": "hatchback",
    "wagon": "wagon", "estate": "wagon",
    "coupe": "coupe", "convertible": "convertible",
    "cabrio": "cabriolet", "cabriolet": "cabriolet",
    "suv": "suv", "pickup": "pickup",
}


def parse_toyota_filename(name: str) -> dict | None:
    """`toyota_eu_corolla_corolla_hybrid_hatchback_2024.pdf` →
    `{model: corolla, year: 2024, chassis: None, body_hint: hatchback}` —
    with the body suffix appended to model so the existing body discriminator
    catches it (model becomes 'corolla-hatchback' if Touring Sports is detected).
    """
    body = name[len("toyota_eu_"):].removesuffix(".pdf")
    m = re.match(r"^(.+)_(20\d{2})$", body)
    if not m:
        return None
    rest, year = m.group(1), int(m.group(2))
    # Skip wheelchair-accessible (WAV) sub-variants — niche, would cross-attach
    # to the base nameplate gen and out-rank the real OM by year.
    if "_wav_" in f"_{rest}_":
        return None
    tokens = rest.split("_")
    # Multi-word head detection (3-token first, then 2-token)
    model: str | None = None
    for length in (3, 2):
        if len(tokens) >= length:
            head = tuple(tokens[:length])
            if head in TOYOTA_MULTIWORD_MODELS:
                model = TOYOTA_MULTIWORD_MODELS[head]
                tokens = tokens[length:]
                break
    if not model:
        model = tokens[0]
        tokens = tokens[1:]
    # Chassis hint from numeric series
    chassis = ""
    chassis_map = TOYOTA_CHASSIS_HINTS.get(model, {})
    for t in tokens:
        if t in chassis_map:
            chassis = chassis_map[t].lower()
            break
    # Body hint — append as model suffix so the body discriminator runs
    body_hint = ""
    for t in tokens:
        if t in TOYOTA_BODY_TOKENS:
            body_hint = TOYOTA_BODY_TOKENS[t]
            break
    if body_hint:
        model = f"{model}-{body_hint}"
    return {"brand": "toyota", "model": model, "year": year, "chassis": chassis}


def parse_hyundai_filename(name: str) -> dict | None:
    """`hyundai_santa_fe_p_hev_mx5_2024.pdf` → {model:'santa-fe', chassis:'mx5', year:2024}."""
    body = name[len("hyundai_"):].removesuffix(".pdf")
    tokens = body.split("_")
    if not tokens:
        return None
    # Multi-token model heads
    if tokens[0] == "santa" and len(tokens) >= 2 and tokens[1] == "fe":
        model, rest = "santa-fe", tokens[2:]
    elif tokens[0] == "ioniq" and len(tokens) >= 2 and tokens[1] in {"5", "6"}:
        model, rest = f"ioniq-{tokens[1]}", tokens[2:]
    elif tokens[0] == "ioniq5n":
        model, rest = "ioniq-5", tokens[1:]
    else:
        model, rest = tokens[0], tokens[1:]
    # Bayon override — i20 N-Line filename mistakenly starts with i20
    if "bayon" in rest and model == "i20":
        model = "bayon"
    chassis: str | None = None
    for tok in rest:
        if tok in HYUNDAI_CHASSIS:
            chassis = tok
            break
    year: int | None = None
    for tok in rest:
        m = re.match(r"^(?:my)?(20\d{2})$", tok)
        if m:
            year = int(m.group(1))
            break
    if year is None:
        return None  # un-dated PDFs (e.g. kona_sx2.pdf) can't be range-filtered safely
    return {"brand": "hyundai", "model": model, "year": year, "chassis": chassis or ""}


def parse_mopar_filename(name: str) -> tuple[str, str, int] | None:
    """`mopar_alfa_romeo_4c_coupe_2015.pdf` → ('alfa-romeo', '4c-coupe', 2015)."""
    body = name[len("mopar_"):].removesuffix(".pdf")
    for prefix, db_brand in MOPAR_BRANDS:
        if body.startswith(prefix + "_"):
            rest = body[len(prefix) + 1:]
            # rest is "<model_tokens>_<year>"
            m = re.match(r"^(.+)_(20\d{2}|19\d{2})$", rest)
            if not m:
                return None
            model_tokens, year = m.group(1), int(m.group(2))
            return db_brand, model_tokens.replace("_", "-"), year
    return None


def derive_from_filename(
    name: str,
    mopar_map: dict[str, str] | None = None,
    hyundai_map: dict[str, str] | None = None,
    kia_map: dict[str, str] | None = None,
    toyota_map: dict[str, str] | None = None,
) -> dict | None:
    """Parse a crawler-prefixed filename → {brand, model, year, url, size_mb_est}.

    Returns None if the prefix isn't one we can derive.
    """
    nlow = name.lower()

    # Mopar — URL is opaque (Azure-DocCode in path), so we need a precomputed
    # filename→URL map produced by `build_mopar_url_map.py`.
    if nlow.startswith("mopar_"):
        if not mopar_map or nlow not in mopar_map:
            return None
        parsed = parse_mopar_filename(nlow)
        if not parsed:
            return None
        brand, model, year = parsed
        return {"brand": brand, "model": model, "year": year, "url": mopar_map[nlow]}

    # Hyundai — URLs have lossy filename normalisation ((P)HEV, mixed separators)
    # so we ship a precomputed map from `build_hyundai_url_map.py` and parse only
    # the (model, chassis, year) signal from the filename.
    if nlow.startswith("hyundai_"):
        if not hyundai_map or nlow not in hyundai_map:
            return None
        parsed = parse_hyundai_filename(nlow)
        if not parsed:
            return None
        parsed["url"] = hyundai_map[nlow]
        return parsed

    # Toyota EU — URLs are on the OEM's publishing-partner viewer (Tweddle
    # diva-api). Not a manufacturer-owned domain so `public_link=0` in the
    # source row, and per [[feedback_never_name_data_vendor]] the vendor name
    # is never rendered. The URL map is built by `build_toyota_url_map.py`.
    if nlow.startswith("toyota_eu_"):
        if not toyota_map or nlow not in toyota_map:
            return None
        parsed = parse_toyota_filename(nlow)
        if not parsed:
            return None
        parsed["url"] = toyota_map[nlow]
        return parsed

    # Mazda CA — only consider "-inline6/-phev/-hev/-hybrid" as variant; everything
    # else (cx-30, cx-5, cx-90, mx-5, b-series) is the full model slug. The
    # previous non-greedy `(.+?)` regex split "cx-5" into model="cx"/variant="5".
    if nlow.startswith("mazda_"):
        m = re.match(r"^mazda_(.+?)(?:-(inline6|phev|hev|hybrid))?_(20\d{2})\.pdf$", nlow)
        if not m:
            return None
        model_main, variant, year = m.group(1), m.group(2), int(m.group(3))
        url = f"https://www.mazda.ca/globalassets/mazda-canada/en/pdf/manuals/vehicles/{model_main}{'-' + variant if variant else ''}/{year}_{model_main}{'-' + variant if variant else ''}_manual_en_optimized.pdf"
        return {"brand": "mazda", "model": model_main, "year": year, "url": url}

    # Nissan US
    if nlow.startswith("nissan_"):
        m = re.match(r"^nissan_(20\d{2})_([a-z0-9-]+)-owner-manual\.pdf$", nlow)
        if not m:
            return None
        year, model = int(m.group(1)), m.group(2)
        oem_file = f"{year}-nissan-{model}-owner-manual.pdf"
        url = f"https://www.nissanusa.com/content/dam/Nissan/us/manuals-and-guides/{model}/{year}/{oem_file}"
        return {"brand": "nissan", "model": model, "year": year, "url": url}

    # Infiniti US — corpus uses two separators (`_2013_ex37-` and `_2014-q60-coupe-`)
    if nlow.startswith("infiniti_"):
        m = re.match(r"^infiniti_(20\d{2})[_-]([a-z0-9-]+?)-owner-manual.*\.pdf$", nlow)
        if not m:
            return None
        year, model = int(m.group(1)), m.group(2)
        oem_file = f"{year}-infiniti-{model}-owner-manual.pdf"
        url = f"https://www.infinitiusa.com/content/dam/Infiniti/US/manuals_guides/{model}/{year}/{oem_file}"
        return {"brand": "infiniti", "model": model, "year": year, "url": url}

    # Kia CA — three filename eras + URL map fallback.
    # Era A (2011-2016): `kia_ca_<YY><model>_en.pdf` (no separator, _en suffix)
    # Era B (2017-2021): `kia_ca_<YY><model>.pdf` (no separator, no _en)
    # Era C (2022+):     `kia_ca_<YY>-<model>.pdf` (dash, no _en)
    # Era U (undated):   `kia_ca_<model>.pdf` (no year — assumed first published)
    # URL — CDN paths vary by year so we use kia_url_map.json instead of
    # reconstructing.
    if nlow.startswith("kia_ca_"):
        if not kia_map or nlow not in kia_map:
            return None
        rest = nlow[len("kia_ca_"):].removesuffix(".pdf")
        # Era A: leading 2-digit year, optional `_en` trail, no separator
        m = re.match(r"^(\d{2})([a-z][a-z0-9]*)(?:_en)?$", rest)
        if m:
            yy = int(m.group(1))
            year = 2000 + yy if yy < 90 else 1900 + yy
            model = m.group(2)
            return {"brand": "kia", "model": model, "year": year, "url": kia_map[nlow]}
        # Era C: <YY>-<model> with optional variant
        m = re.match(r"^(\d{2})-([a-z0-9-]+)$", rest)
        if m:
            yy = int(m.group(1))
            year = 2000 + yy if yy < 90 else 1900 + yy
            model = m.group(2)
            return {"brand": "kia", "model": model, "year": year, "url": kia_map[nlow]}
        # Era D (4-digit year_):
        m = re.match(r"^(20\d{2})_([a-z0-9-]+)_owners_manual_en$", rest)
        if m:
            year, model = int(m.group(1)), m.group(2)
            return {"brand": "kia", "model": model, "year": year, "url": kia_map[nlow]}
        # Era U: bare model name (no year). Year unknown → skip (no range filter).
        return None

    # Mercedes US
    if nlow.startswith("mercedes_"):
        slug = name[len("mercedes_"):].removesuffix(".pdf")
        # Extract year/month/chassis-code from <body>-<year>-<MM>-<chassis>-<infotainment>
        m = re.match(r"^([a-z0-9-]+?)-(\d{4})-(\d{2})-([a-z0-9]+)-([a-z]+)$", slug, re.I)
        if not m:
            return None
        body, year, mm, chassis = m.group(1), int(m.group(2)), int(m.group(3)), m.group(4)
        if not 1 <= mm <= 12:
            return None
        month_name = MONTHS[mm]
        out = re.sub(r"-(\d{4})-(\d{2})-", f"-{year}-{month_name}-", slug, count=1)
        url = f"https://www.mbusa.com/css-oom/assets/en-us/pdf/mercedes-{out}-operators-manual-1.pdf"
        # Body slug determines model; e.g. 'c-class-sedan' → 'c-class', 'gle-coupe' → 'gle'
        # We use the body slug as the "model" for matching.
        return {"brand": "mercedes-benz", "model": body, "year": year, "url": url, "chassis": chassis}

    # GM (all 9 brands)
    if nlow.startswith("gm_"):
        m = re.match(r"^gm_([a-z-]+)_(.+\.pdf)$", name)
        if not m:
            return None
        brand, oem_file = m.group(1), m.group(2)
        # Try to extract model + year from the OEM filename: <YY>_<BRANDCODE>_<Model>_OM_...
        meta = re.match(r"^(\d{2})_[A-Z]+_([A-Za-z0-9_-]+?)_OM_", oem_file)
        if meta:
            yy = int(meta.group(1))
            year = 2000 + yy
            model = meta.group(2).lower().replace("_", "-")
        else:
            return None  # supplements/insertable warranty docs — skip
        url = f"https://contentdelivery.ext.gm.com/content/dam/cope/en_us/public/pdf_assets/active/owners_manuals_browse/{oem_file}"
        return {"brand": brand, "model": model, "year": year, "url": url}

    # Ford US
    if nlow.startswith("ford_"):
        oem_file = name[len("ford_"):]
        # Filename patterns: '2024_Ford_F-150_Owners_Manual_version_1_om_EN-US.pdf'
        m = re.match(r"^(20\d{2})_Ford_([A-Z0-9_-]+?)_Owners?[_-]?Manual", oem_file, re.I)
        if m:
            year, model = int(m.group(1)), m.group(2).lower().replace("_", "-")
        else:
            # Legacy: '2014-CMAX-Owner-Manual-version-1_OM_EN_11_2013.pdf'
            m = re.match(r"^(20\d{2})[-_]([A-Z0-9_-]+?)[-_]Owners?[-_]?Manual", oem_file, re.I)
            if not m:
                return None
            year, model = int(m.group(1)), m.group(2).lower().replace("_", "-")
        url = f"https://www.fordservicecontent.com/Ford_Content/Catalog/owner_information/{oem_file}"
        return {"brand": "ford", "model": model, "year": year, "url": url}

    return None


def normalize(s: str) -> str:
    return re.sub(r"[^a-z0-9]+", "", (s or "").lower())


# Suffix-on-candidate-model → required gen body_type. Disambiguates same-chassis
# manuals where the OEM publishes separate PDFs per body (Infiniti G sedan/coupe/
# convertible, Mercedes C-class sedan/wagon, etc.) onto the correct gen row.
BODY_SUFFIX_TO_BODY = {
    "sedan": "sedan",
    "wagon": "wagon",
    "coupe": "coupe",
    "convertible": "convertible",
    "cabriolet": "cabriolet",
    "cabrio": "cabriolet",
    "roadster": "convertible",
    "hatchback": "hatchback",
    "hatch": "hatchback",
    "suv": "suv",
    "pickup": "pickup",
    "truck": "pickup",
}
# Powertrain variant suffix → must appear in gen.slug. E.g. "q70-hybrid" should
# only attach to gen `q70-hybrid-y51-...`, never `q70-y51-...`.
POWERTRAIN_VARIANT_TOKENS = ("hybrid", "phev", "plugin", "ev")


def extract_body_suffix(model: str) -> str | None:
    for suf, body in BODY_SUFFIX_TO_BODY.items():
        if model.endswith("-" + suf):
            return body
    return None


def extract_powertrain_variant(model: str) -> str | None:
    for tok in POWERTRAIN_VARIANT_TOKENS:
        if f"-{tok}" in model or model.endswith(tok):
            return tok
    return None


def strip_known_suffixes(model: str) -> str:
    """Drop a body or powertrain suffix to canonicalise model_slug for matching.

    "g-coupe" → "g"  (body)
    "q70-hybrid" → "q70"  (powertrain)
    "proace-max" → "proace-max"  (max is a nameplate differentiator, NOT a
    suffix — don't strip. PROACE Max stays its own model.)
    """
    for suf in BODY_SUFFIX_TO_BODY:
        if model.endswith("-" + suf):
            return model[: -len(suf) - 1]
    for tok in POWERTRAIN_VARIANT_TOKENS:
        if model.endswith("-" + tok):
            return model[: -len(tok) - 1]
    return model


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--brand", help="filter to this brand")
    args = ap.parse_args()

    try:
        import mysql.connector
        from dotenv import load_dotenv
    except ImportError:
        sys.exit("need mysql-connector-python + python-dotenv in the venv")

    load_dotenv(ROOT / ".env.local")
    conn = mysql.connector.connect(
        host=os.environ.get("DB_HOST", "127.0.0.1"),
        port=int(os.environ.get("DB_PORT", "3307")),
        user=os.environ["DB_USER"],
        password=os.environ["DB_PASSWORD"],
        database=os.environ["DB_NAME"],
    )
    cur = conn.cursor(dictionary=True)

    # Mopar + Hyundai URL maps are optional — load if present.
    import json
    mopar_map: dict[str, str] | None = None
    if MOPAR_URL_MAP.exists():
        mopar_map = json.loads(MOPAR_URL_MAP.read_text(encoding="utf-8"))
        print(f"loaded mopar URL map: {len(mopar_map)} entries")
    hyundai_map: dict[str, str] | None = None
    if HYUNDAI_URL_MAP.exists():
        hyundai_map = json.loads(HYUNDAI_URL_MAP.read_text(encoding="utf-8"))
        print(f"loaded hyundai URL map: {len(hyundai_map)} entries")
    kia_map: dict[str, str] | None = None
    if KIA_URL_MAP.exists():
        kia_map = json.loads(KIA_URL_MAP.read_text(encoding="utf-8"))
        print(f"loaded kia URL map: {len(kia_map)} entries")
    toyota_map: dict[str, str] | None = None
    if TOYOTA_URL_MAP.exists():
        toyota_map = json.loads(TOYOTA_URL_MAP.read_text(encoding="utf-8"))
        print(f"loaded toyota URL map: {len(toyota_map)} entries")

    # Walk filesystem — plus pull in URL-map keys for brands whose PDFs are
    # hosted on a vendor CDN and not mirrored locally (Toyota EU via Tweddle).
    candidates: dict[tuple[str, str], list[dict]] = defaultdict(list)
    parsed = skipped = 0
    on_disk = {p.name for p in MANUALS_DIR.glob("*.pdf")}
    virtual_filenames: set[str] = set()
    if toyota_map:
        virtual_filenames.update(toyota_map.keys())
    all_filenames = on_disk | virtual_filenames
    for fname in all_filenames:
        meta = derive_from_filename(fname, mopar_map, hyundai_map, kia_map, toyota_map)
        if not meta:
            skipped += 1
            continue
        if args.brand and meta["brand"] != args.brand.lower():
            continue
        if fname in on_disk:
            meta["size_mb"] = round((MANUALS_DIR / fname).stat().st_size / 1024 / 1024, 1)
        else:
            meta["size_mb"] = None  # remote-only
        candidates[(meta["brand"], meta["model"])].append(meta)
        parsed += 1
    print(f"local PDFs: parsed={parsed} skipped={skipped}")

    # Pull gens
    cur.execute("""
        SELECT g.id AS gen_id, g.slug AS gen_slug, g.start_year, g.end_year,
               g.body_type, g.codename,
               mk.slug AS make_slug, mk.name AS make_name,
               m.slug AS model_slug, m.name AS model_name,
               g.oem_manual_url AS current_url
        FROM generations g
        JOIN models m ON m.id = g.model_id
        JOIN makes mk ON mk.id = m.make_id
        WHERE g.is_active = 1
    """)
    gens = cur.fetchall()
    print(f"active generations: {len(gens)}")

    updates: list[tuple] = []
    matched_brands: dict[str, int] = defaultdict(int)
    for g in gens:
        if g["current_url"]:
            continue
        make_norm = normalize(g["make_slug"]) or normalize(g["make_name"])
        model_norm_set = {normalize(g["model_slug"]), normalize(g["model_name"])}
        # Also allow stripping body-style words from the gen display
        for word in ("sedan", "coupe", "suv", "hatch", "wagon", "cabriolet", "convertible"):
            for m in list(model_norm_set):
                if m.endswith(word):
                    model_norm_set.add(m[: -len(word)])
        model_norm_set.discard("")
        gen_end = g["end_year"] or 2100
        # Chassis tiebreaker: when two same-body gens differ only by chassis
        # (g-class W465 ICE vs E465 EQG, AMG GT C190 coupe vs R190 roadster), the
        # candidate filename usually carries the chassis code as its own token —
        # prefer the candidate whose chassis matches gen.codename. Score becomes
        # (chassis_match_bool, year) so chassis match overrides "latest year".
        # Hardening: if gen has a codename AND any model+body+year-eligible
        # candidate carries a chassis token, we require a chassis match — stops
        # Land Cruiser J250/J300 gens picking up the J70 PDF just because year
        # overlaps and no chassis-tagged J250 candidate exists.
        gen_codename_norm = normalize(g["codename"]) if g.get("codename") else None
        best: dict | None = None
        best_score: tuple[bool, int] | None = None
        saw_chassis_field = False
        saw_chassis_match = False
        for (b, m), cands in candidates.items():
            b_norm = normalize(b)
            if not (b_norm == make_norm or b_norm.startswith(make_norm) or make_norm.startswith(b_norm)):
                continue
            # Strip body/powertrain suffix from the candidate model so we can
            # require an exact match against gen.model_slug. The previous
            # bidirectional-startswith allowed "proace-max" to match DB "proace"
            # because the longer string started with the shorter — wrong for
            # sibling nameplates that share a prefix (Toyota PROACE / PROACE Max).
            m_norm = normalize(strip_known_suffixes(m))
            hit = False
            for mn in model_norm_set:
                if mn and m_norm == mn:
                    hit = True
                    break
            if not hit:
                continue
            # Body-style discrimination — when the candidate filename names a body
            # (g-sedan, c-class-sedan), require the gen row to be of that body.
            candidate_body = extract_body_suffix(m)
            if candidate_body:
                if (g["body_type"] or "").lower() != candidate_body:
                    continue
            # Powertrain-variant discrimination — "q70-hybrid" should never
            # attach to a non-hybrid gen, and vice-versa.
            candidate_variant = extract_powertrain_variant(m)
            gen_slug_l = (g["gen_slug"] or "").lower()
            gen_is_hybrid = "hybrid" in gen_slug_l or "phev" in gen_slug_l
            if candidate_variant == "hybrid":
                if not gen_is_hybrid:
                    continue
            elif candidate_variant is None and gen_is_hybrid:
                continue
            for c in cands:
                if c["year"] < g["start_year"] or c["year"] > gen_end:
                    continue
                if c.get("chassis"):
                    saw_chassis_field = True
                chassis_match = bool(
                    gen_codename_norm
                    and c.get("chassis")
                    and normalize(c["chassis"]) == gen_codename_norm
                )
                if chassis_match:
                    saw_chassis_match = True
                score = (chassis_match, c["year"])
                if best is None or score > best_score:
                    best = c
                    best_score = score
        # Hardening: drop the match when gen has codename + chassis info was
        # available but none of the candidates carried this gen's codename.
        if (best is not None and gen_codename_norm
                and saw_chassis_field and not saw_chassis_match):
            best = None
        if best:
            matched_brands[best["brand"]] += 1
            updates.append((best["url"], best["size_mb"], best["year"], g["gen_id"]))

    print(f"matched {len(updates)} generations:")
    for b, n in sorted(matched_brands.items(), key=lambda x: -x[1]):
        print(f"  {b:<15} {n}")

    if args.dry_run:
        print("\nsample matches (first 15):")
        for url, size_mb, year, gen_id in updates[:15]:
            print(f"  gen #{gen_id} year={year} size={size_mb} MB")
            print(f"    {url}")
        return 0

    if not updates:
        return 0

    cur.executemany(
        """UPDATE generations
           SET oem_manual_url=%s,
               oem_manual_pdf_size_mb=%s,
               oem_manual_year_referenced=%s,
               oem_manual_verified_at=CURDATE()
           WHERE id=%s""",
        updates,
    )
    conn.commit()
    print(f"\nupdated {cur.rowcount} generation rows")
    cur.close()
    conn.close()
    return 0


if __name__ == "__main__":
    sys.exit(main())
