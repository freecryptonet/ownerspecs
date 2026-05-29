#!/usr/bin/env python3
"""crawl_genesis_ca.py — Genesis Canada Download Centre harvester.

Source: https://www.genesis.com/ca/en/owners/owners-resources/download-centre.html

Genesis US is login-walled (`owners.genesis.com` MyGenesis portal) — same
posture as Kia US / Mazda US. Genesis CA's Download Centre is public; the
catalog of ALL (model × year) PDFs is rendered on a single HTML page as
inline `pdfDownload('<file_key>', '<filename>', '<MANUAL|CATALOG>', '<model>')`
JS calls (CSS show/hides per model — no API per (year, model) like Kia).

Each `file_key` is delivered by `POST /wsvc/ca/api/v2/downloadcenter/pdfdownload`
with body `file_key=<id>`. Response is `application/force-download` with the
real filename in `Content-Disposition`.

Stage 1 (Playwright, done once via mcp__playwright__browser_evaluate):
  → scrape all pdfDownload(...) calls from the page → save genesis_ca_catalog.json

Stage 2 (this script): POST each MANUAL file_key, write PDF to manuals/.

By default keeps Owner's Manuals only (filenames containing 'Owners_Manual',
'OwnersManual', 'VehicleManual', or 'OwnerManual'). Use --include-service to
also grab Service Passport + Service Maintenance Package PDFs.

Usage:
    python scripts/crawl_genesis_ca.py --catalog genesis_ca_catalog.json --dry-run
    python scripts/crawl_genesis_ca.py --catalog genesis_ca_catalog.json
    python scripts/crawl_genesis_ca.py --catalog genesis_ca_catalog.json --limit 5

Local naming: `genesis_ca_<source-filename>` (filename comes from the catalog
itself, e.g. `2026_G70_Owners_Manual_EN.pdf`). `genesis_ca_` prefix so
detect_sections' brand_guess resolves to 'genesis' and market is unambiguous.

Per [[feedback_convert_on_demand_not_bulk]]: crawler stops at download.
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
BASE = "https://www.genesis.com"
DOWNLOAD_URL = BASE + "/wsvc/ca/api/v2/downloadcenter/pdfdownload"

HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36",
    "Accept": "application/pdf, application/force-download, */*",
    "Referer": "https://www.genesis.com/ca/en/owners/owners-resources/download-centre.html",
    "Origin": "https://www.genesis.com",
}

OM_PATTERNS = (
    re.compile(r"owners?_manual", re.I),
    re.compile(r"vehiclemanual", re.I),
    re.compile(r"owner_?manual_en", re.I),
)
SERVICE_PATTERNS = (
    re.compile(r"service[-_]passport", re.I),
    re.compile(r"servicemaintenance", re.I),
)


def is_om(filename: str) -> bool:
    return any(p.search(filename) for p in OM_PATTERNS)


def is_service(filename: str) -> bool:
    return any(p.search(filename) for p in SERVICE_PATTERNS)


def safe_local_name(filename: str) -> str:
    """`2026_G70_Owners_Manual_EN.pdf` → `genesis_ca_2026_g70_owners_manual_en.pdf`."""
    name = filename.lower()
    # Strip wonky characters that came through the JS string (parens, spaces, %20)
    name = re.sub(r"[^a-z0-9._-]+", "_", name).strip("_")
    if not name.endswith(".pdf"):
        name += ".pdf"
    return f"genesis_ca_{name}"


def download(file_key: str, dest: Path, retries: int = 2) -> int:
    for attempt in range(retries + 1):
        try:
            with requests.post(DOWNLOAD_URL, data={"file_key": file_key}, headers=HEADERS, stream=True, timeout=120) as r:
                r.raise_for_status()
                ct = (r.headers.get("Content-Type") or "").lower()
                if "pdf" not in ct and "force-download" not in ct and "octet-stream" not in ct:
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
    ap.add_argument("--catalog", default="genesis_ca_catalog.json",
                    help="JSON with [{fileKey, filename, kind, model}, ...] scraped from the download-centre page")
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--limit", type=int)
    ap.add_argument("--sleep", type=float, default=0.5)
    ap.add_argument("--include-service", action="store_true",
                    help="also keep Service Passport + Service Maintenance Package PDFs (default: OMs only)")
    args = ap.parse_args()

    cat_path = Path(args.catalog)
    if not cat_path.is_absolute():
        cat_path = ROOT / cat_path
    if not cat_path.exists():
        sys.exit(f"catalog not found: {cat_path}")
    entries = json.loads(cat_path.read_text(encoding="utf-8"))
    if not isinstance(entries, list) or not entries:
        sys.exit("catalog should be a non-empty list")
    print(f"loaded catalog with {len(entries)} entries")

    MANUALS_DIR.mkdir(parents=True, exist_ok=True)

    # Filter: keep MANUAL kind + OM filename pattern; optionally service-related
    seen_filename: set[str] = set()
    todo: list[tuple[str, str, Path, dict]] = []
    for e in entries:
        if (e.get("kind") or "").upper() != "MANUAL":
            continue
        fn = e.get("filename") or ""
        if not (is_om(fn) or (args.include_service and is_service(fn))):
            continue
        # The same Service Passport file shows up under every model; dedupe by name
        if fn in seen_filename:
            continue
        seen_filename.add(fn)
        local = MANUALS_DIR / safe_local_name(fn)
        if local.exists() and local.stat().st_size > 0:
            continue
        todo.append((e["fileKey"], fn, local, {"model": e.get("model"), "filename": fn}))

    print(f"filtered to {len(todo)} new OM-ish PDFs to download")
    if not todo:
        return 0
    if args.limit:
        todo = todo[: args.limit]
        print(f"--limit {args.limit}: will download first {len(todo)}")

    if args.dry_run:
        print("\n--dry-run, would download:")
        for fk, fn, local, meta in todo:
            print(f"  {meta['model']:<20} -> {local.name}")
        return 0

    print(f"\nDownloading {len(todo)} PDFs:")
    ok = fail = 0
    for i, (fk, fn, local, meta) in enumerate(todo, 1):
        try:
            size = download(fk, local)
            ok += 1
            print(f"  [{i}/{len(todo)}] OK  {local.name} -- {meta['model']} -- {size/1024:.0f} KB", flush=True)
        except Exception as e:
            fail += 1
            print(f"  [{i}/{len(todo)}] ERR {local.name} -- {type(e).__name__}: {e}", flush=True)
        if i < len(todo) and args.sleep > 0:
            time.sleep(args.sleep)

    print(f"\nDone. downloaded={ok} failed={fail}")
    print("\nPer feedback_convert_on_demand_not_bulk: PDFs are now in manuals/.")
    return 0 if fail == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
