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


def derive_from_filename(name: str, mopar_map: dict[str, str] | None = None) -> dict | None:
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

    # Mazda CA
    if nlow.startswith("mazda_"):
        m = re.match(r"^mazda_([a-z0-9-]+?)(?:-([a-z0-9]+))?_(20\d{2})\.pdf$", nlow)
        if not m:
            return None
        model_main, variant, year = m.group(1), m.group(2), int(m.group(3))
        # Most use 'optimized' suffix; some powertrain-split use docids — skip those for the safe path.
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

    # Kia CA — new format only (post-2018)
    if nlow.startswith("kia_ca_"):
        rest = name[len("kia_ca_"):]
        m = re.match(r"^(\d{2})-([a-z0-9-]+)\.pdf$", rest, re.I)
        if m:
            yy = int(m.group(1))
            year = 2000 + yy if yy < 90 else 1900 + yy
            model = m.group(2)
            url = f"https://www.kia.ca/content/dam/marketing/documents/en/owners/{year}/{rest.lower()}"
            return {"brand": "kia", "model": model, "year": year, "url": url}
        m = re.match(r"^(20\d{2})_([a-z0-9-]+)_owners_manual_en\.pdf$", rest, re.I)
        if m:
            year, model = int(m.group(1)), m.group(2)
            url = f"https://www.kia.ca/content/dam/marketing/documents/en/owners/{year}/{rest.lower()}"
            return {"brand": "kia", "model": model, "year": year, "url": url}
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

    # Mopar URL map is optional — load if present.
    mopar_map: dict[str, str] | None = None
    if MOPAR_URL_MAP.exists():
        import json
        mopar_map = json.loads(MOPAR_URL_MAP.read_text(encoding="utf-8"))
        print(f"loaded mopar URL map: {len(mopar_map)} entries")

    # Walk filesystem
    candidates: dict[tuple[str, str], list[dict]] = defaultdict(list)
    parsed = skipped = 0
    for p in MANUALS_DIR.glob("*.pdf"):
        meta = derive_from_filename(p.name, mopar_map)
        if not meta:
            skipped += 1
            continue
        if args.brand and meta["brand"] != args.brand.lower():
            continue
        meta["size_mb"] = round(p.stat().st_size / 1024 / 1024, 1)
        candidates[(meta["brand"], meta["model"])].append(meta)
        parsed += 1
    print(f"local PDFs: parsed={parsed} skipped={skipped}")

    # Pull gens
    cur.execute("""
        SELECT g.id AS gen_id, g.slug AS gen_slug, g.start_year, g.end_year,
               g.body_type,
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
        best: dict | None = None
        for (b, m), cands in candidates.items():
            b_norm = normalize(b)
            if not (b_norm == make_norm or b_norm.startswith(make_norm) or make_norm.startswith(b_norm)):
                continue
            m_norm = normalize(m)
            hit = False
            for mn in model_norm_set:
                if not mn:
                    continue
                if m_norm == mn or m_norm.startswith(mn) or mn.startswith(m_norm):
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
                if best is None or c["year"] > best["year"]:
                    best = c
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
