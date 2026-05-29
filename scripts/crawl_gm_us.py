#!/usr/bin/env python3
"""crawl_gm_us.py — GM-wide owner-manual harvester (all 9 brands).

Source: https://www.cadillac.com/support/vehicle/manuals-guides (and every other
GM brand has an equivalent page running the same Web Component). Under the
hood, all of GM publishes manuals through a single public Solr index at:

    https://contentdelivery.ext.gm.com/bypass/gma-search-api/searchapi/solr/

Two relevant cores:
- `make-model-year` — enumeration of every (year, make, model) tuple GM sold
- `gma-public` — full-text search; given (year, make, model) returns PDF URLs

Covers ALL 9 historical GM brands — Buick, Cadillac, Chevrolet, GMC, Hummer,
Pontiac, Oldsmobile, Saturn, BrightDrop — and MY1993-2026. The single biggest
crawler in our portfolio (the gma-public response has full PDF URLs in
`path`; just dedup + download).

Two-stage flow (single Python script):
1. For each year in --years, query `make-model-year` to list all
   (make, model) tuples for that year (across all 9 brands).
2. For each (year, make, model), query `gma-public` to fetch the manual list.
   Filter to OMs only by default (category_key contains OWNERS_MANUALS_BROWSE);
   dedup by `path`; collect PDF URLs.
3. Download every unique URL with Mozilla UA.

Default scope: MY2018-2026 (~9 years × ~200 tuples/year × ~2 manuals avg =
~3500 OMs, ~100 GB of disk if all downloaded). Use --years to narrow.
--include-warranty / --include-qrg widen the doc filter.

Usage:
    python scripts/crawl_gm_us.py --dry-run                         # scope check
    python scripts/crawl_gm_us.py --years 2024                      # one year
    python scripts/crawl_gm_us.py --years 2020-2026 --brands Cadillac
    python scripts/crawl_gm_us.py --years 2018-2026                 # default modern era
    python scripts/crawl_gm_us.py                                   # full 1993-2026 — careful!

Per [[feedback_convert_on_demand_not_bulk]] (2026-05-29): crawler stops at
download. Convert + index per-gen later, on demand.

Local naming: `gm_<brand>_<source-basename>` — keeps the OEM filename which
already encodes (year, brand code, model, doc-type, edition). `gm_` prefix
plus the brand token so detect_sections' brand_guess resolves correctly.
"""
from __future__ import annotations

import argparse
import json
import re
import sys
import time
from pathlib import Path
from urllib.parse import quote

import requests

ROOT = Path(__file__).resolve().parent.parent
MANUALS_DIR = ROOT / "manuals"
GM_BASE = "https://contentdelivery.ext.gm.com"
SOLR_BASE = GM_BASE + "/bypass/gma-search-api/searchapi/solr"

# All 9 brands per the selector config. Capitalisation matches the Solr index.
GM_BRANDS = ["Buick", "Cadillac", "Chevrolet", "GMC", "Hummer",
             "Pontiac", "Oldsmobile", "Saturn", "BrightDrop"]

HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36",
    "Accept": "application/json, */*",
    "Referer": "https://www.cadillac.com/support/vehicle/manuals-guides",
}


def solr_call(core: str, params: list[tuple[str, str]], retries: int = 2) -> dict:
    """Hit a GM Solr core with the funky double-encoded querystring the widget uses.

    `params` is a LIST of (key, value) so we can repeat `fq` like the page does.
    The widget URL-encodes the WHOLE querystring as one blob — replicate that.
    """
    qs = "&".join(f"{k}={v}" for k, v in params)
    url = f"{SOLR_BASE}/{core}/select?{quote(qs, safe='')}"
    for attempt in range(retries + 1):
        try:
            r = requests.get(url, headers=HEADERS, timeout=30)
            r.raise_for_status()
            return r.json()
        except Exception:
            if attempt == retries:
                raise
            time.sleep(1 + attempt)
    return {}


def list_mmy_for_year(year: int) -> list[dict]:
    """All (make, model) tuples GM sold in `year` across the 9 brands."""
    j = solr_call("make-model-year", [
        ("q", f"year:{year} AND region:GMNA"),
        ("rows", "500"),
        ("fl", "year,make_en,model_en"),
    ])
    docs = (j.get("response") or {}).get("docs") or []
    return [{"year": int(d.get("year")), "make": d.get("make_en"), "model": d.get("model_en")}
            for d in docs if d.get("make_en") and d.get("model_en")]


def search_manuals(year: int, make: str, model: str) -> list[dict]:
    """Solr search for manuals matching `year + MAKE + MODEL` (en_US, PDFs only)."""
    q = f"+{year} +{make.upper()} +{model.upper()}"
    qf = ("title_en^200.0 title_es^200 title_ar^200 title_pt^200 title_ru^200 "
          "title_th^200 title_fr^200 title_ko^200 category_translated^150.0 "
          "category_translated_path^120.0 category_key_path^90.0 mmy^80.0 category_key^75")
    j = solr_call("gma-public", [
        ("defType", "edismax"),
        ("fl", "imdocid,path,title_ordered,category_key,file_type,locale"),
        ("fq", "channel:*MANUALS*"),
        ("fq", "source:aem"),
        ("fq", "file_type:application/pdf"),
        ("fq", "locale:en_US"),
        ("q", q),
        ("rows", "50"),
        ("qf", qf),
        ("stopwords", "true"),
    ])
    docs = (j.get("response") or {}).get("docs") or []
    return [d for d in docs if (d.get("file_type") or "").endswith("pdf")]


def is_owner_manual(doc: dict, include_warranty: bool, include_qrg: bool) -> bool:
    keys = " ".join(doc.get("category_key") or []).upper()
    if "OWNERS_MANUALS_BROWSE" in keys:
        return True
    if include_qrg and "QUICK_REFERENCE_MANUALS_BROWSE" in keys:
        return True
    if include_warranty and "WARRANTY_MANUALS_BROWSE" in keys:
        return True
    return False


def local_name(brand: str, src_path: str) -> str:
    basename = src_path.rsplit("/", 1)[-1]
    safe_brand = re.sub(r"[^a-z0-9]+", "_", brand.lower()).strip("_")
    return f"gm_{safe_brand}_{basename}"


def download(url: str, dest: Path, retries: int = 2) -> int:
    for attempt in range(retries + 1):
        try:
            with requests.get(url, headers=HEADERS, stream=True, timeout=300) as r:
                r.raise_for_status()
                ct = (r.headers.get("Content-Type") or "").lower()
                if "pdf" not in ct and "octet-stream" not in ct:
                    raise RuntimeError(f"unexpected content-type {ct}")
                tmp = dest.with_suffix(dest.suffix + ".part")
                size = 0
                with tmp.open("wb") as f:
                    for chunk in r.iter_content(chunk_size=128 * 1024):
                        if chunk:
                            f.write(chunk)
                            size += len(chunk)
                tmp.replace(dest)
                return size
        except Exception:
            if attempt == retries:
                raise
            time.sleep(2 + attempt * 2)
    return 0


def parse_years(spec: str) -> list[int]:
    out: set[int] = set()
    for part in spec.split(","):
        part = part.strip()
        if "-" in part:
            a, b = part.split("-", 1)
            out.update(range(int(a), int(b) + 1))
        elif part:
            out.add(int(part))
    return sorted(out)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--years", default="2018-2026",
                    help="Year range or comma list (e.g. '2018-2026', '2024', '2020,2023-2025'). Default modern era.")
    ap.add_argument("--brands", default=None,
                    help="Comma list of brands to keep (default: all 9). Case-sensitive: " + ",".join(GM_BRANDS))
    ap.add_argument("--include-warranty", action="store_true")
    ap.add_argument("--include-qrg", action="store_true",
                    help="also Quick Reference / Convenience Guides")
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--limit", type=int)
    ap.add_argument("--api-sleep", type=float, default=0.25)
    ap.add_argument("--pdf-sleep", type=float, default=0.5)
    args = ap.parse_args()

    years = parse_years(args.years)
    wanted_brands = set(args.brands.split(",")) if args.brands else set(GM_BRANDS)
    print(f"GM crawler: {len(years)} years × {len(wanted_brands)} brands")

    MANUALS_DIR.mkdir(parents=True, exist_ok=True)

    # Stage 1 — enumerate (year, make, model) tuples
    print("\nStage 1/3 — enumerating (year, make, model) via make-model-year Solr core:")
    mmy: list[dict] = []
    for i, y in enumerate(years, 1):
        try:
            tuples = [t for t in list_mmy_for_year(y) if t["make"] in wanted_brands]
            mmy.extend(tuples)
            print(f"  [{i}/{len(years)}] {y}: {len(tuples)} (make, model) tuples", flush=True)
        except Exception as e:
            print(f"  [{i}/{len(years)}] {y}: ERR {type(e).__name__}: {e}", flush=True)
        if args.api_sleep > 0 and i < len(years):
            time.sleep(args.api_sleep)
    print(f"\nStage 1 done. {len(mmy)} (year, make, model) tuples to search.")

    # Stage 2 — search manuals per tuple, dedup by URL
    print("\nStage 2/3 — searching gma-public Solr core per tuple:")
    seen: dict[str, dict] = {}  # path → first {brand, year, title}
    api_err = 0
    for i, t in enumerate(mmy, 1):
        try:
            docs = search_manuals(t["year"], t["make"], t["model"])
        except Exception as e:
            api_err += 1
            if api_err <= 5:
                print(f"  [{i}/{len(mmy)}] ERR {t['make']}/{t['model']}/{t['year']}: {type(e).__name__}", flush=True)
            continue
        for d in docs:
            if not is_owner_manual(d, args.include_warranty, args.include_qrg):
                continue
            path = d.get("path") or ""
            if not path.endswith(".pdf"):
                continue
            if path in seen:
                continue
            seen[path] = {"brand": t["make"], "year": t["year"], "model": t["model"],
                         "title": d.get("title_ordered") or ""}
        if i % 50 == 0:
            print(f"  ...{i}/{len(mmy)} tuples searched, {len(seen)} unique PDFs queued, {api_err} api errors", flush=True)
        if args.api_sleep > 0 and i < len(mmy):
            time.sleep(args.api_sleep)
    print(f"\nStage 2 done. {len(seen)} unique PDFs, {api_err} API errors.")

    # Filter already-on-disk
    todo: list[tuple[str, Path, dict]] = []
    for path, meta in seen.items():
        local = MANUALS_DIR / local_name(meta["brand"], path)
        if local.exists() and local.stat().st_size > 0:
            continue
        todo.append((path, local, meta))
    print(f"new (not yet on disk): {len(todo)}")
    if not todo:
        return 0
    if args.limit:
        todo = todo[: args.limit]
        print(f"--limit {args.limit}: will download first {len(todo)}")

    if args.dry_run:
        print("\n--dry-run, would download (first 30):")
        for url, local, meta in todo[:30]:
            print(f"  {meta['brand']:<12} {meta['year']} {meta['model']:<22} -> {local.name}")
        if len(todo) > 30:
            print(f"  ... and {len(todo)-30} more")
        return 0

    # Stage 3 — download
    print(f"\nStage 3/3 — downloading {len(todo)} PDFs:")
    ok = fail = 0
    for i, (url, local, meta) in enumerate(todo, 1):
        try:
            size = download(url, local)
            ok += 1
            print(f"  [{i}/{len(todo)}] OK  {local.name} -- {meta['brand']} {meta['year']} {meta['model']} -- {size/1024/1024:.1f} MB", flush=True)
        except Exception as e:
            fail += 1
            print(f"  [{i}/{len(todo)}] ERR {local.name} -- {type(e).__name__}: {e}", flush=True)
        if i < len(todo) and args.pdf_sleep > 0:
            time.sleep(args.pdf_sleep)

    print(f"\nDone. downloaded={ok} failed={fail}")
    print("\nPer feedback_convert_on_demand_not_bulk: PDFs are now in manuals/.")
    return 0 if fail == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
