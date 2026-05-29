#!/usr/bin/env python3
"""crawl_infiniti_us.py — Infiniti US owner-manual harvester.

Source: https://www.infinitiusa.com/owners/manuals-warranties.html

Infiniti US is a near-clone of the Nissan US portal — same AEM ContentFragment
search endpoint, same response shape, same DAM CDN pattern. Confirms the
**Nissan group convention** (Nissan + Infiniti both public-direct).

AEM endpoint (no auth):

    https://www.infinitiusa.com/owners/manuals-warranties/_jcr_content/root/
      responsivegrid/pagesection/page-section-par/
      manualsandguidessear.search.json/<Model>/<Year>/suffix.html

Response shape (identical to Nissan):

    {
      "totalResults": 7,
      "results": [
        {
          "name": "Owner's Manual and Maintenance Information",
          "size": "8 MB",
          "location": "/content/dam/Infiniti/US/manuals_guides/qx60/2024/2024-infiniti-qx60-owner-manual.pdf",
          "rank": 1,
          "lastModifiedDate": 1712896673868,
          "mimeType": "application/pdf"
        },
        ...
      ]
    }

`location` joins to `https://www.infinitiusa.com` for the absolute URL. PDFs
serve `application/pdf` to any Mozilla UA — no Akamai wall.

Per [[feedback_convert_on_demand_not_bulk]] (2026-05-29): crawler stops at
download. Convert + index per-gen later, on demand.

Usage:
    python scripts/crawl_infiniti_us.py --dry-run
    python scripts/crawl_infiniti_us.py
    python scripts/crawl_infiniti_us.py --limit 5
    python scripts/crawl_infiniti_us.py --include-supplements

Local naming: `infiniti_<year>_<rest-of-source-filename>.pdf` — keeps the model
+ doc-type tokens from the OEM filename, prefix moved to the front so
detect_sections' brand_guess heuristic resolves to 'infiniti'.
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
BASE = "https://www.infinitiusa.com"
SEARCH_TMPL = (
    BASE
    + "/owners/manuals-warranties/_jcr_content/root/responsivegrid/pagesection/"
    + "page-section-par/manualsandguidessear.search.json/{model}/{year}/suffix.html"
)

# 24 models from the live <select id="model-list"> on 2026-05-29.
MODELS = [
    "EX", "FX", "G Convertible", "G Coupe", "G Sedan", "JX", "M", "M Hybrid",
    "Q40", "Q50", "Q50 Hybrid", "Q60 Convertible", "Q60 Coupe", "Q70", "Q70 Hybrid",
    "QX30", "QX50", "QX55", "QX56", "QX60", "QX60 Hybrid", "QX65", "QX70", "QX80",
]
# Wider year range than Nissan — Infiniti rebrand from 2014 (G→Q, FX→QX) was
# a hard break, but the portal probably keeps older PDFs too.
YEARS = list(range(2008, 2027))

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
                return []
            return j.get("results") or []
        except Exception:
            if attempt == retries:
                raise
            time.sleep(1 + attempt)
    return []


def normalize_local_name(src_loc: str) -> str:
    """Turn the source DAM path into a clean local filename.

    Source:    /content/dam/Infiniti/US/manuals_guides/qx60/2024/2024-infiniti-qx60-owner-manual.pdf
    Local:     infiniti_2024_qx60-owner-manual.pdf

    Strips the leading 'YYYY-infiniti-' so the result still starts with the
    brand token for detect_sections' brand_guess.
    """
    basename = src_loc.rsplit("/", 1)[-1].lower()
    m = re.match(r"^(\d{4})-infiniti-(.+\.pdf)$", basename)
    if m:
        return f"infiniti_{m.group(1)}_{m.group(2)}"
    return f"infiniti_{basename}"


def classify(result: dict) -> str:
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
    ap.add_argument("--api-sleep", type=float, default=0.3)
    ap.add_argument("--pdf-sleep", type=float, default=0.5)
    ap.add_argument("--include-supplements", action="store_true",
                    help="also download InTouch / QRG / towing / warranty (default: OM only)")
    args = ap.parse_args()

    MANUALS_DIR.mkdir(parents=True, exist_ok=True)
    print(f"Infiniti US crawler — {len(MODELS)} models × {len(YEARS)} years = {len(MODELS)*len(YEARS)} probes")

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
        if i % 100 == 0:
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
    return 0 if fail == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
