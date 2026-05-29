#!/usr/bin/env python3
"""crawl_nissan_us.py — Nissan US owner-manual harvester.

Source: https://www.nissanusa.com/owners/manuals-guides.html — JS-rendered page
that reveals PDF URLs via an AEM JSON search endpoint. Unlike Toyota/Honda/
Subaru/Mazda US, Nissan does NOT gate OMs behind a login — every PDF on the
JSON output is reachable with a plain Mozilla-UA request.

PDFs live on `nissanusa.com/content/dam/Nissan/us/manuals-and-guides/` (manufacturer-
owned CDN, public_link=1 eligible).

The endpoint takes `/<Model>/<Year>/suffix.html` and returns clean JSON:

    {
      "totalResults": 8,
      "results": [
        {
          "name": "OWNER'S MANUAL AND MAINTENANCE INFORMATION",
          "desc": "...",
          "size": "3 MB",
          "location": "/content/dam/Nissan/us/manuals-and-guides/altima/2024/2024-nissan-altima-owner-manual.pdf",
          "rank": 1,
          "lastModifiedDate": 1711059966861,
          "mimeType": "application/pdf"
        },
        ...
      ]
    }

For each (model, year) we keep the OM only by default. `--include-supplements`
keeps QRG, NissanConnect, towing/warranty/safety guides too.

Usage:
    python scripts/crawl_nissan_us.py --dry-run
    python scripts/crawl_nissan_us.py
    python scripts/crawl_nissan_us.py --limit 5
    python scripts/crawl_nissan_us.py --include-supplements

Per [[feedback_convert_on_demand_not_bulk]] (2026-05-29): crawler stops at
download. Convert + index per-gen later, on demand.

Local naming: `nissan_<year>_<rest-of-source-filename>.pdf` — keeps the model
+ doc-type tokens from the OEM filename, but moves `nissan_` to the front so
detect_sections' brand_guess heuristic lands on 'nissan'.
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
MANUALS_DIR = ROOT / "manuals"
BASE = "https://www.nissanusa.com"
SEARCH_TMPL = (
    BASE
    + "/owners/manuals-guides/_jcr_content/root/responsivegrid/pagesection/"
    + "page-section-par/columns12/col1-par/manualsandguidessear.search.json/"
    + "{model}/{year}/suffix.html"
)

# 34-model list pulled from the page's <select id="model-list"> on 2026-05-29.
# Stable across the year — Nissan adds/removes maybe one model per refresh.
MODELS = [
    "Altima", "Altima Coupe", "ARIYA", "Armada", "Cube", "Frontier", "GT-R",
    "Juke", "Kicks", "Kicks Play", "LEAF", "Maxima", "Murano", "Murano CrossCabriolet",
    "NV Cargo", "NV Passenger", "NV200 Compact Cargo", "Pathfinder", "Pathfinder Armada",
    "Quest", "Rogue", "Rogue Select", "Rogue Sport", "Sentra", "Titan", "Titan XD",
    "Versa", "Versa Note", "Xterra", "Z", "350Z", "370Z", "Murano Cross Cabriolet",
]
# 14 valid years (2013-2026 dropdown range; older years lack PDFs in this portal).
YEARS = list(range(2013, 2027))

HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36",
    "Accept": "application/json, text/html;q=0.9, */*;q=0.5",
}

OM_NAME_RE = re.compile(r"OWNER.S MANUAL", re.I)


def fetch_results(model: str, year: int, retries: int = 2) -> list[dict]:
    url = SEARCH_TMPL.format(model=requests.utils.quote(model), year=year)
    for attempt in range(retries + 1):
        try:
            r = requests.get(url, headers=HEADERS, timeout=20)
            if r.status_code == 404:
                return []
            r.raise_for_status()
            try:
                j = json.loads(r.text)
            except json.JSONDecodeError:
                # The endpoint returns text/html but body is JSON; if it returns
                # actual HTML we treat it as "no data".
                return []
            return j.get("results") or []
        except Exception:
            if attempt == retries:
                raise
            time.sleep(1 + attempt)
    return []


def normalize_local_name(src_loc: str) -> str:
    """Turn the source DAM path into a clean local filename.

    Source:    /content/dam/Nissan/us/manuals-and-guides/altima/2024/2024-nissan-altima-owner-manual.pdf
    Local:     nissan_2024_altima-owner-manual.pdf

    Strips the leading '<year>-nissan-' so the result still starts with the brand
    token for detect_sections' brand_guess (split-on-underscore-take-first).
    """
    basename = src_loc.rsplit("/", 1)[-1].lower()
    # Strip leading 'YYYY-nissan-' if present, then re-prefix
    m = re.match(r"^(\d{4})-nissan-(.+\.pdf)$", basename)
    if m:
        return f"nissan_{m.group(1)}_{m.group(2)}"
    return f"nissan_{basename}"


def classify(result: dict) -> str:
    """Return 'om' for the main owner's manual, 'sup' for supplements."""
    name = (result.get("name") or "").upper()
    loc = (result.get("location") or "").lower()
    if OM_NAME_RE.search(name) and "owner-manual" in loc:
        return "om"
    return "sup"


def download(url: str, dest: Path, retries: int = 2) -> int:
    for attempt in range(retries + 1):
        try:
            with requests.get(url, headers=HEADERS, stream=True, timeout=120) as r:
                r.raise_for_status()
                ct = r.headers.get("Content-Type", "").lower()
                if "pdf" not in ct:
                    raise RuntimeError(f"unexpected content-type {ct}")
                tmp = dest.with_suffix(dest.suffix + ".part")
                size = 0
                with tmp.open("wb") as f:
                    for chunk in r.iter_content(chunk_size=64 * 1024):
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


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--limit", type=int)
    ap.add_argument("--api-sleep", type=float, default=0.4)
    ap.add_argument("--pdf-sleep", type=float, default=0.5)
    ap.add_argument("--include-supplements", action="store_true",
                    help="also download QRG, NissanConnect, towing/warranty/safety guides (default: OM only)")
    args = ap.parse_args()

    MANUALS_DIR.mkdir(parents=True, exist_ok=True)
    print(f"Nissan US crawler — {len(MODELS)} models × {len(YEARS)} years = {len(MODELS)*len(YEARS)} probes")

    # Stage 1: collect (location, name) tuples by hitting the API per (model, year)
    seen: set[str] = set()
    todo: list[tuple[str, Path, dict]] = []
    api_err = empty = 0
    print("\nStage 1/2 — API lookup per (model, year):")
    probes = [(m, y) for m in MODELS for y in YEARS]
    for i, (m, y) in enumerate(probes, 1):
        try:
            results = fetch_results(m, y)
        except Exception as e:
            api_err += 1
            print(f"  [{i}/{len(probes)}] ERR  {m} {y}  ({type(e).__name__})", flush=True)
            continue
        if not results:
            empty += 1
        for r in results:
            loc = r.get("location") or ""
            if not loc.endswith(".pdf"):
                continue
            kind = classify(r)
            if kind == "sup" and not args.include_supplements:
                continue
            if loc in seen:
                continue
            seen.add(loc)
            url = BASE + loc
            local = MANUALS_DIR / normalize_local_name(loc)
            if local.exists() and local.stat().st_size > 0:
                continue
            todo.append((url, local, {"model": m, "year": y, "kind": kind, "name": r.get("name") or ""}))
        if i % 50 == 0:
            print(f"  ...{i}/{len(probes)} probes done, {len(todo)} new PDFs queued, {empty} empty results, {api_err} errors", flush=True)
        if args.api_sleep > 0 and i < len(probes):
            time.sleep(args.api_sleep)

    print(f"\nStage 1 done. unique new PDFs: {len(todo)}, empty probes: {empty}, errors: {api_err}")
    if not todo:
        return 0

    if args.limit:
        todo = todo[: args.limit]
        print(f"--limit {args.limit}: will download first {len(todo)}")

    if args.dry_run:
        print("\n--dry-run, would download:")
        for url, local, meta in todo[:25]:
            print(f"  {meta['model']:<20} MY{meta['year']} {meta['kind']:<3} -> {local.name}")
        if len(todo) > 25:
            print(f"  ... and {len(todo)-25} more")
        return 0

    print(f"\nStage 2/2 — downloading {len(todo)} PDFs:")
    ok = fail = 0
    for i, (url, local, meta) in enumerate(todo, 1):
        try:
            size = download(url, local)
            ok += 1
            print(f"  [{i}/{len(todo)}] OK  {local.name} -- {meta['model']} {meta['year']} -- {size/1024:.0f} KB", flush=True)
        except Exception as e:
            fail += 1
            print(f"  [{i}/{len(todo)}] ERR {local.name} -- {type(e).__name__}: {e}", flush=True)
        if i < len(todo) and args.pdf_sleep > 0:
            time.sleep(args.pdf_sleep)

    print(f"\nDone. downloaded={ok} failed={fail}")
    print("\nPer feedback_convert_on_demand_not_bulk: PDFs are now in manuals/.")
    print("Convert + index per-gen on demand, do NOT bulk-run convert_manuals.")
    return 0 if fail == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
