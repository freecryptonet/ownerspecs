#!/usr/bin/env python3
"""build_mopar_url_map.py — produce mopar_url_map.json keyed by local filename.

The Mopar `crawl_mopar_us.py` crawler downloads via direct HTTPS to
`vehicleinfo.mopar.com/.../<DocCode>.pdf`, but the DocCode is opaque and
isn't stored anywhere after the download. To attach OEM-manual URLs to
generations rows we need a filename→URL lookup. This script rebuilds
that map by re-querying the vehicleKit API for every (brand, model, year)
tuple in `mopar_tuples.json`.

Output: `mopar_url_map.json` at repo root, shape:
  {
    "mopar_jeep_wrangler_2024.pdf": "https://vehicleinfo.mopar.com/...pdf",
    ...
  }

`backfill_oem_manual_urls.py` reads this map and emits the URL for any
`mopar_*` filename present.

API courtesy: 0.4s sleep between calls (~5 min for 687 tuples).
"""
from __future__ import annotations

import argparse
import json
import re
import sys
import time
from pathlib import Path

import requests

ROOT = Path(__file__).resolve().parent.parent
TUPLES_PATH = ROOT / "mopar_tuples.json"
OUT_PATH = ROOT / "mopar_url_map.json"

API_BASE = "https://api.mopar.com/vehicleKit"
# Public APIM subscription key extracted from the mopar.com client (see crawl_mopar_us.py).
APIM_KEY = "d36a62ae69bc4245a170a0f08fc65325"
HEADERS_API = {
    "ocp-apim-subscription-key": APIM_KEY,
    "accept": "application/json",
    "referer": "https://www.mopar.com/",
    "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36",
}


def local_filename(brand: str, model: str, year: str) -> str:
    """Same convention as crawl_mopar_us.py local_filename, OM (no suffix)."""
    parts = ["mopar", brand.lower(), model.lower(), year]
    return "_".join(re.sub(r"[^a-z0-9]+", "_", p) for p in parts).strip("_") + ".pdf"


def fetch_om_url(brand: str, model: str, year: str) -> str | None:
    params = {"brand": brand, "model": model, "year": year, "market": "us", "language": "en"}
    r = requests.get(API_BASE, params=params, headers=HEADERS_API, timeout=20)
    if r.status_code == 404:
        return None
    r.raise_for_status()
    for p in r.json().get("publications", []):
        if p.get("itemtype") == "OM" and (p.get("payload") or "").endswith(".pdf"):
            return p["payload"]
    return None


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--sleep", type=float, default=0.4, help="sleep between API calls")
    ap.add_argument("--limit", type=int, help="cap tuples for testing")
    ap.add_argument("--resume", action="store_true", help="skip tuples already in the existing map")
    args = ap.parse_args()

    if not TUPLES_PATH.exists():
        sys.exit(f"missing {TUPLES_PATH}")
    tuples = json.loads(TUPLES_PATH.read_text(encoding="utf-8"))
    print(f"loaded {len(tuples)} tuples")

    existing: dict[str, str] = {}
    if args.resume and OUT_PATH.exists():
        existing = json.loads(OUT_PATH.read_text(encoding="utf-8"))
        print(f"resume mode: {len(existing)} entries already mapped")

    if args.limit:
        tuples = tuples[: args.limit]

    out = dict(existing)
    miss = err = skip = 0
    for i, t in enumerate(tuples, 1):
        fname = local_filename(t["brand"], t["model"], t["year"])
        if fname in out:
            skip += 1
            continue
        try:
            url = fetch_om_url(t["brand"], t["model"], t["year"])
        except Exception as e:
            err += 1
            if err <= 5:
                print(f"  [{i}] ERR {t['brand']}/{t['model']}/{t['year']} ({type(e).__name__})")
            continue
        if url:
            out[fname] = url
        else:
            miss += 1
        if i % 25 == 0 or i == len(tuples):
            OUT_PATH.write_text(json.dumps(out, indent=2), encoding="utf-8")
            print(f"  [{i}/{len(tuples)}] mapped={len(out)} miss={miss} err={err} skip={skip}", flush=True)
        if args.sleep > 0 and i < len(tuples):
            time.sleep(args.sleep)

    OUT_PATH.write_text(json.dumps(out, indent=2), encoding="utf-8")
    print(f"\ndone. wrote {OUT_PATH} ({len(out)} entries)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
