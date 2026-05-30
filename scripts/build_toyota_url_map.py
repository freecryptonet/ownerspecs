#!/usr/bin/env python3
"""build_toyota_url_map.py — produce toyota_url_map.json keyed by local filename.

Two public Toyota Europe APIs feed this:

1. `diva-api.tweddle.app/pubhub/info/products` — full catalog (brand, model,
   modelType, year, ngtdModelId) for Toyota + Lexus EU. ~thousands of entries.

2. `customerportal.tweddle-aws.eu/_next/data/{build}/publications.json` —
   per-(brand, model, modelType, ngtdModelId, generationId, year, language)
   returns the OM/NM/UG publications list with partNumbers + ditaIds.

The viewer URL `customerportal.tweddle-aws.eu/pdf/{partNumber}?modelType=&lineOffDate=`
is a fully public, gen-specific HTML wrapper that streams the underlying S3 PDF.
We use that URL as the manual URL — works without auth, doesn't require
resolving to S3 each time, and stays stable across builds.

Per Tim (2026-05-30): ship as-is. `public_link=0` and never name the OEM's
publishing vendor in any rendered column.

Output: toyota_url_map.json {local_filename: viewer_url}.
Local filename convention: `toyota_eu_<model>_<modelType>_<year>.pdf`,
sanitised lowercase + underscores.

API courtesy: 0.2s sleep between publications.json calls. With ~400 unique
(model, modelType) tuples and 5-year coverage each, roughly 6-10 min.
"""
from __future__ import annotations

import argparse
import json
import re
import sys
import time
from pathlib import Path
from collections import defaultdict

import requests

ROOT = Path(__file__).resolve().parent.parent
OUT_PATH = ROOT / "toyota_url_map.json"

DIVA_BASE = "https://diva-api.tweddle.app"
PORTAL_BASE = "https://customerportal.tweddle-aws.eu"

# Tweddle Next.js build id — pinned to whatever the portal currently serves.
# Re-fetch the manuals page first and parse it from the buildManifest meta if
# this hard-coded value ever 404s.
BUILD_ID = "TME-692f62c90cc37c3258da4b11af3f5901d7f6c584"

HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36",
    "Accept": "application/json, text/plain, */*",
}


def slugify(s: str) -> str:
    return re.sub(r"[^a-z0-9]+", "_", s.lower()).strip("_")


def local_filename(brand: str, model: str, model_type: str, year: str) -> str:
    return f"{slugify(brand)}_eu_{slugify(model)}_{slugify(model_type)}_{year}.pdf"


def viewer_url(part_number: str, model_type: str, line_off_date: str) -> str:
    # Tweddle expects the lineOffDate as YYYY-MM-DD (strip time)
    line_off = (line_off_date or "")[:10]
    return (
        f"{PORTAL_BASE}/pdf/{part_number}"
        f"?modelType={requests.utils.quote(model_type)}"
        f"&lineOffDate={line_off}"
    )


def fetch_products() -> list[dict]:
    r = requests.get(f"{DIVA_BASE}/pubhub/info/products?", headers=HEADERS, timeout=30)
    r.raise_for_status()
    return r.json()


def fetch_publications(brand: str, model: str, model_type: str, ngtd_model_id: str,
                       years: list[int]) -> list[dict]:
    """Hit Next.js data endpoint. Returns publications list."""
    qs = [
        f"brand={requests.utils.quote(brand)}",
        f"model={requests.utils.quote(model)}",
        f"modelType={requests.utils.quote(model_type)}",
        f"ngtdModelId={ngtd_model_id}",
        "language=en",
    ]
    for i, y in enumerate(years):
        qs.append(f"year%5B{i}%5D={y}")
    url = f"{PORTAL_BASE}/_next/data/{BUILD_ID}/publications.json?{'&'.join(qs)}"
    r = requests.get(url, headers=HEADERS, timeout=30)
    if r.status_code != 200:
        return []
    try:
        j = r.json()
    except json.JSONDecodeError:
        return []
    return ((j.get("pageProps") or {}).get("publications") or {}).get("items") or []


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--sleep", type=float, default=0.2)
    ap.add_argument("--brand", default="Toyota", help="Toyota or Lexus")
    ap.add_argument("--limit", type=int, help="cap tuples for testing")
    ap.add_argument("--resume", action="store_true")
    args = ap.parse_args()

    print(f"fetching pubhub/info/products …")
    try:
        products = fetch_products()
    except Exception as e:
        sys.exit(f"products fetch failed: {e}")
    print(f"got {len(products)} products total")

    brand_filter = args.brand
    products = [p for p in products if p.get("brand") == brand_filter]
    print(f"{brand_filter}-only: {len(products)} entries")

    # Group by (model, modelType, ngtdModelId) so we batch year ranges in one call
    groups: dict[tuple[str, str, str], list[str]] = defaultdict(list)
    for p in products:
        key = (p["model"], p["modelType"], p.get("ngtdModelId", ""))
        groups[key].append(p["year"])
    tuples = sorted(groups.items())
    print(f"unique (model, modelType, ngtdModelId): {len(tuples)}")

    out: dict[str, str] = {}
    if args.resume and OUT_PATH.exists():
        out = json.loads(OUT_PATH.read_text(encoding="utf-8"))
        print(f"resume mode: {len(out)} entries already mapped")

    if args.limit:
        tuples = tuples[: args.limit]

    om_count = err = 0
    for i, ((model, model_type, ngtd_model_id), years) in enumerate(tuples, 1):
        year_ints = sorted({int(y) for y in years if y.isdigit()}, reverse=True)
        if not year_ints:
            continue
        try:
            pubs = fetch_publications(brand_filter, model, model_type, ngtd_model_id, year_ints)
        except Exception as e:
            err += 1
            if err <= 5:
                print(f"  [{i}] ERR {model}/{model_type}: {type(e).__name__}")
            continue
        # Filter to OM only and keep all years
        for p in pubs:
            if p.get("publicationType") != "OM":
                continue
            part_number = p.get("partNumber")
            year = p.get("year")
            line_off_date = p.get("lineOffDate") or ""
            if not (part_number and year):
                continue
            fname = local_filename(brand_filter, model, model_type, year)
            out[fname] = viewer_url(part_number, model_type, line_off_date)
            om_count += 1
        if i % 25 == 0 or i == len(tuples):
            OUT_PATH.write_text(json.dumps(out, indent=2), encoding="utf-8")
            print(f"  [{i}/{len(tuples)}] mapped={len(out)} OMs_seen={om_count} err={err}", flush=True)
        if args.sleep > 0 and i < len(tuples):
            time.sleep(args.sleep)

    OUT_PATH.write_text(json.dumps(out, indent=2), encoding="utf-8")
    print(f"\ndone. wrote {OUT_PATH} ({len(out)} entries)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
