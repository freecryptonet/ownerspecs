#!/usr/bin/env python3
"""crawl_mopar_us.py — Stellantis NA owner-manual harvester.

Source: https://www.mopar.com/en-us/owners-information-sitemap.html (sitemap
is Akamai-walled to scripted UAs, hence the two-stage approach below).

Discovered 2026-05-25 (memory: reference_mopar_owners_portal): 687 (brand,
model, year) tuples across Alfa Romeo / Chrysler / Dodge / Fiat / Jeep / Ram
from MY2005 to MY2027. Per-tuple metadata (including the OM PDF URL) is
served by an Azure APIM endpoint at api.mopar.com/vehicleKit with a public
subscription key. PDFs are on vehicleinfo.mopar.com which is NOT Akamai-blocked.

Workflow:
    # Stage 1 (already done): tuples extracted from sitemap via Playwright →
    #                          F:\\projects\\ownerspecs\\mopar_tuples.json

    # Stage 2 (this script): hit vehicleKit API per tuple, filter OM/QRG,
    #                         download PDFs to manuals/.

Usage:
    python scripts/crawl_mopar_us.py --tuples mopar_tuples.json --dry-run
    python scripts/crawl_mopar_us.py --tuples mopar_tuples.json
    python scripts/crawl_mopar_us.py --tuples mopar_tuples.json --limit 10
    python scripts/crawl_mopar_us.py --tuples mopar_tuples.json --include-qrg
    python scripts/crawl_mopar_us.py --tuples mopar_tuples.json --with-convert

Local naming: `mopar_<brand>_<model>_<year>.pdf` — lowercased, brand prefix so
detect_sections' filename heuristic resolves to brand=mopar (then we backfill
brand=chrysler/dodge/jeep/ram/fiat/alfa from the model string in SQL).

Stellantis NA is the canonical OEM source for these brands per the memory —
their PDFs are public_link=1 eligible (vehicleinfo.mopar.com is manufacturer-owned).
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
API_BASE = "https://api.mopar.com/vehicleKit"
# Public APIM subscription key extracted from the website's own client. Required
# header for the API to respond; absent it returns 401.
APIM_KEY = "d36a62ae69bc4245a170a0f08fc65325"

HEADERS_API = {
    "ocp-apim-subscription-key": APIM_KEY,
    "accept": "application/json",
    "referer": "https://www.mopar.com/",
    "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36",
}
HEADERS_PDF = {
    "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36",
}


def local_filename(brand: str, model: str, year: str, suffix: str) -> str:
    """mopar_jeep_wrangler_2020.pdf  /  mopar_jeep_wrangler_2020_qrg.pdf"""
    b = brand.lower()
    m = model.lower().replace("_", "_")
    parts = ["mopar", b, m, year]
    if suffix:
        parts.append(suffix.lower())
    safe = "_".join(re.sub(r"[^a-z0-9]+", "_", p) for p in parts).strip("_")
    return f"{safe}.pdf"


def fetch_pubs(brand: str, model: str, year: str, retries: int = 2) -> list[dict]:
    """Call vehicleKit, return the publications list (possibly empty)."""
    params = {"brand": brand, "model": model, "year": year, "market": "us", "language": "en"}
    for attempt in range(retries + 1):
        try:
            r = requests.get(API_BASE, params=params, headers=HEADERS_API, timeout=20)
            if r.status_code == 404:
                return []
            r.raise_for_status()
            return r.json().get("publications", [])
        except Exception:
            if attempt == retries:
                raise
            time.sleep(1 + attempt)
    return []


def download(url: str, dest: Path, retries: int = 2) -> int:
    for attempt in range(retries + 1):
        try:
            with requests.get(url, headers=HEADERS_PDF, stream=True, timeout=60) as r:
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
    ap.add_argument("--tuples", default="mopar_tuples.json",
                    help="JSON file with [{brand,model,year}, ...] (extract via Playwright once)")
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--limit", type=int, help="max tuples to process")
    ap.add_argument("--include-qrg", action="store_true",
                    help="also download Quick Reference Guides (smaller, less moat value; default: OM only)")
    ap.add_argument("--api-sleep", type=float, default=0.5,
                    help="sleep between API calls (default 0.5s)")
    ap.add_argument("--pdf-sleep", type=float, default=0.5,
                    help="sleep between PDF downloads (default 0.5s)")
    ap.add_argument("--with-convert", action="store_true",
                    help="after downloading, chain convert_manuals + detect_sections --write-db")
    args = ap.parse_args()

    tuples_path = Path(args.tuples)
    if not tuples_path.is_absolute():
        tuples_path = ROOT / tuples_path
    if not tuples_path.exists():
        sys.exit(f"tuples file not found: {tuples_path}")
    tuples = json.loads(tuples_path.read_text(encoding="utf-8"))
    if not isinstance(tuples, list) or not tuples or "brand" not in tuples[0]:
        sys.exit(f"tuples file shape wrong; expected list of {{brand,model,year}}")
    print(f"loaded {len(tuples)} (brand,model,year) tuples")

    MANUALS_DIR.mkdir(parents=True, exist_ok=True)
    if args.limit:
        tuples = tuples[: args.limit]
        print(f"limited to first {len(tuples)}")

    want_types = {"OM"} | ({"QRG"} if args.include_qrg else set())

    # Stage A: hit API for each tuple, collect (url, local_path, meta)
    todo: list[tuple[str, Path, dict]] = []
    no_pub = api_err = 0
    print("\nStage 1/2 — API lookup per tuple:")
    for i, t in enumerate(tuples, 1):
        try:
            pubs = fetch_pubs(t["brand"], t["model"], t["year"])
        except Exception as e:
            print(f"  [{i}/{len(tuples)}] API ERR {t['brand']}/{t['model']}/{t['year']} -- {type(e).__name__}: {e}", flush=True)
            api_err += 1
            continue
        had_pdf = False
        for p in pubs:
            itype = p.get("itemtype")
            payload = p.get("payload", "")
            if itype not in want_types or not payload.endswith(".pdf"):
                continue
            suffix = "" if itype == "OM" else "qrg"
            local = MANUALS_DIR / local_filename(t["brand"], t["model"], t["year"], suffix)
            if local.exists() and local.stat().st_size > 0:
                had_pdf = True
                continue
            todo.append((payload, local, {"brand": t["brand"], "model": t["model"], "year": t["year"], "itemtype": itype}))
            had_pdf = True
        if not had_pdf:
            no_pub += 1
        if args.api_sleep > 0 and i < len(tuples):
            time.sleep(args.api_sleep)
        if i % 50 == 0:
            print(f"  ...{i}/{len(tuples)} tuples scanned, {len(todo)} new PDFs queued", flush=True)
    print(f"\nStage 1 done. new={len(todo)} no_pub={no_pub} api_err={api_err}")
    if not todo:
        return 0

    if args.dry_run:
        print("\n--dry-run, would download:")
        for url, local, meta in todo[:20]:
            print(f"  {meta['brand']:<12}/{meta['model']:<20} MY{meta['year']} ({meta['itemtype']}) -> {local.name}")
        if len(todo) > 20:
            print(f"  ... and {len(todo)-20} more")
        return 0

    # Stage B: download PDFs
    print(f"\nStage 2/2 — downloading {len(todo)} PDFs:")
    ok = fail = 0
    new_files: list[Path] = []
    for i, (url, local, meta) in enumerate(todo, 1):
        try:
            size = download(url, local)
            ok += 1
            new_files.append(local)
            print(f"  [{i}/{len(todo)}] OK  {local.name} ({size/1024:.0f} KB)", flush=True)
        except Exception as e:
            fail += 1
            print(f"  [{i}/{len(todo)}] ERR {local.name} -- {type(e).__name__}: {e}", flush=True)
        if args.pdf_sleep > 0 and i < len(todo):
            time.sleep(args.pdf_sleep)

    print(f"\nDone. downloaded={ok} failed={fail}")

    if args.with_convert and new_files:
        import subprocess
        py = sys.executable
        print("\n-> convert_manuals --workers 4 ...")
        cv = subprocess.run([py, str(ROOT / "scripts" / "convert_manuals.py"),
                             "--workers", "4", "--skip-large", "1000"],
                            cwd=str(ROOT), check=False)
        if cv.returncode != 0:
            return 1
        print("\n-> detect_sections --write-db (needs MariaDB tunnel up on :3307) ...")
        ds = subprocess.run([py, str(ROOT / "scripts" / "detect_sections.py"), "--write-db"],
                            cwd=str(ROOT), check=False)
        return ds.returncode

    return 0 if fail == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
