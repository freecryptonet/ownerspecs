#!/usr/bin/env python3
"""crawl_ford_us.py — Ford US owner-manual harvester.

Source: https://www.ford.com/support/owner-manuals-details/owner-manuals-library

Ford's search portal looks JS-walled (Akamai Bot Manager obfuscates POSTs)
but the underlying results pages are **fully server-rendered**. Plain
requests with Mozilla UA can:

1. Fetch the "browse all" library page → contains 259 (model, year) links
   like `/support/owner-manuals-details/f150/2024`.
2. Fetch each (model, year) results page → contains 5-10 PDF URLs at
   `https://www.fordservicecontent.com/Ford_Content/Catalog/owner_information/`.
3. Download each unique PDF.

No auth, no Akamai wall on either ford.com result pages or the
fordservicecontent.com CDN.

Year range: MY2017-2027 (~11 years).
Categories per page: Owner Manual + Warranty Guide (multiple printings) +
Quick Reference Guide + Quick Start Guide. Default keeps OMs only;
--include-warranty + --include-qrg widen.

Usage:
    python scripts/crawl_ford_us.py --dry-run
    python scripts/crawl_ford_us.py
    python scripts/crawl_ford_us.py --limit 5

Local naming: `ford_<source-basename>` (filename already encodes year + model
+ doc-type — e.g. `2024_Ford_F-150_Owners_Manual_version_1_om_EN-US.pdf`).

Per [[feedback_convert_on_demand_not_bulk]] (2026-05-29): crawler stops at
download. Convert + index per-gen later.
"""
from __future__ import annotations

import argparse
import re
import sys
import time
from pathlib import Path

import requests

ROOT = Path(__file__).resolve().parent.parent
MANUALS_DIR = ROOT / "manuals"
BASE = "https://www.ford.com"
LIBRARY_URL = BASE + "/support/owner-manuals-details/owner-manuals-library"

# Pages render PDFs from fordservicecontent.com only.
PDF_CDN_RE = re.compile(
    r"https?://(?:www\.)?fordservicecontent\.com/Ford_Content/Catalog/owner_information/[^\"'<>\s]+\.pdf",
    re.I,
)
# Library page link pattern.
TUPLE_RE = re.compile(
    r"/support/owner-manuals-details/([a-z0-9-]+)/(20\d{2})\b",
    re.I,
)

HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36",
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
}


def classify(url: str) -> str:
    """Detect OM vs supplements from the filename."""
    name = url.rsplit("/", 1)[-1].lower()
    if re.search(r"_om_|owners[_-]?manual", name):
        return "om"
    if re.search(r"warranty|_wty_|_wg_", name):
        return "warranty"
    if re.search(r"qrg|quick[_-]?reference|qsg|quick[_-]?start", name):
        return "qrg"
    return "other"


def fetch_library() -> list[tuple[str, int]]:
    """Return unique (model_slug, year) tuples from the library page."""
    r = requests.get(LIBRARY_URL, headers=HEADERS, timeout=30)
    r.raise_for_status()
    seen: set[tuple[str, int]] = set()
    for m in TUPLE_RE.finditer(r.text):
        seen.add((m.group(1).lower(), int(m.group(2))))
    return sorted(seen)


def fetch_pdfs_for(slug: str, year: int, retries: int = 2) -> list[str]:
    url = f"{BASE}/support/owner-manuals-details/{slug}/{year}"
    for attempt in range(retries + 1):
        try:
            r = requests.get(url, headers=HEADERS, timeout=30)
            r.raise_for_status()
            return sorted(set(PDF_CDN_RE.findall(r.text)))
        except Exception:
            if attempt == retries:
                raise
            time.sleep(1 + attempt)
    return []


def local_name(src_url: str) -> str:
    basename = src_url.rsplit("/", 1)[-1]
    return f"ford_{basename}"


def download(url: str, dest: Path, retries: int = 2) -> int:
    for attempt in range(retries + 1):
        try:
            with requests.get(url, headers=HEADERS, stream=True, timeout=180) as r:
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


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--limit", type=int)
    ap.add_argument("--api-sleep", type=float, default=0.3)
    ap.add_argument("--pdf-sleep", type=float, default=0.4)
    ap.add_argument("--include-warranty", action="store_true")
    ap.add_argument("--include-qrg", action="store_true",
                    help="also Quick Reference / Quick Start Guides (default: OM only)")
    args = ap.parse_args()

    MANUALS_DIR.mkdir(parents=True, exist_ok=True)

    print(f"fetching library: {LIBRARY_URL}")
    try:
        tuples = fetch_library()
    except Exception as e:
        sys.exit(f"library fetch failed: {e}")
    print(f"library returned {len(tuples)} unique (model, year) tuples")

    # Stage 1 — visit each tuple page, collect PDF URLs
    print("\nStage 1/2 — scraping per-tuple result pages:")
    seen: dict[str, dict] = {}  # url → {slug, year, kind}
    api_err = empty = 0
    for i, (slug, year) in enumerate(tuples, 1):
        try:
            pdfs = fetch_pdfs_for(slug, year)
        except Exception as e:
            api_err += 1
            if api_err <= 5:
                print(f"  [{i}/{len(tuples)}] ERR {slug}/{year} ({type(e).__name__})", flush=True)
            continue
        if not pdfs:
            empty += 1
        for u in pdfs:
            kind = classify(u)
            if u in seen:
                continue
            seen[u] = {"slug": slug, "year": year, "kind": kind}
        if i % 50 == 0:
            print(f"  ...{i}/{len(tuples)} pages scraped, {len(seen)} unique PDFs, {empty} empty pages, {api_err} errors", flush=True)
        if args.api_sleep > 0 and i < len(tuples):
            time.sleep(args.api_sleep)
    print(f"\nStage 1 done. {len(seen)} unique PDFs, {empty} empty pages, {api_err} errors.")

    # Filter to selected kinds
    keep_kinds: set[str] = {"om"}
    if args.include_warranty:
        keep_kinds.add("warranty")
    if args.include_qrg:
        keep_kinds.add("qrg")

    todo: list[tuple[str, Path, dict]] = []
    for url, meta in seen.items():
        if meta["kind"] not in keep_kinds and meta["kind"] != "other":
            continue
        local = MANUALS_DIR / local_name(url)
        if local.exists() and local.stat().st_size > 0:
            continue
        todo.append((url, local, meta))
    print(f"after kind filter + on-disk check: {len(todo)} PDFs to download")
    if not todo:
        return 0
    if args.limit:
        todo = todo[: args.limit]
        print(f"--limit {args.limit}: will download first {len(todo)}")

    if args.dry_run:
        print("\n--dry-run, would download:")
        for url, local, meta in todo[:30]:
            print(f"  {meta['slug']:<22} {meta['year']} {meta['kind']:<8} -> {local.name}")
        if len(todo) > 30:
            print(f"  ... and {len(todo)-30} more")
        return 0

    # Stage 2 — download
    print(f"\nStage 2/2 — downloading {len(todo)} PDFs:")
    ok = fail = 0
    for i, (url, local, meta) in enumerate(todo, 1):
        try:
            size = download(url, local)
            ok += 1
            print(f"  [{i}/{len(todo)}] OK  {local.name} -- {meta['slug']} {meta['year']} -- {size/1024/1024:.1f} MB", flush=True)
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
