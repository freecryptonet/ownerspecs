#!/usr/bin/env python3
"""crawl_mazda_ca.py — Mazda Canada owner-manual harvester.

Source: https://www.planetemazda.com/en/owners-manual (a dealer index page) —
links point at Mazda Canada's own CDN at www.mazda.ca/globalassets which is
manufacturer-owned (public_link=1 eligible per [[reference_mazda_canada_om_portal]]).

~189 PDFs, MY2001-2025, covering Mazda2/3/5/6, CX-3/5/7/9/30/50/70/90,
MAZDASPEED3, MX-5, MX-30, RX-8, MPV, Tribute, B-Series, Protegé. Crucially
CX-70 and CX-90 are powertrain-split (cx-90-inline6/, cx-90-phev/, cx-50-hev/)
which matches our engine-specific moat rule.

No Akamai wall — plain Mozilla-UA download works.

Per [[feedback_convert_on_demand_not_bulk]] (2026-05-29): this crawler stops
at download. Conversion + indexing happen later, per-gen, on demand.

Usage:
    python scripts/crawl_mazda_ca.py --dry-run
    python scripts/crawl_mazda_ca.py
    python scripts/crawl_mazda_ca.py --limit 5

Local naming: `mazda_<model>[_<powertrain>]_<year>.pdf` parsed from the URL
path so brand_guess in detect_sections lands on 'mazda'.
"""
from __future__ import annotations

import argparse
import re
import sys
import time
from pathlib import Path
from urllib.parse import unquote

import requests

ROOT = Path(__file__).resolve().parent.parent
MANUALS_DIR = ROOT / "manuals"
INDEX_URL = "https://www.planetemazda.com/en/owners-manual"

# Only Mazda's own CDN. The 2 dealer-CDN outliers (img.sm360.ca) and 2 HTML
# viewer URLs (mazda.ca/en/digital-owners-manual/...) are intentionally skipped:
# - dealer CDN isn't manufacturer-owned and the dealer may purge it
# - HTML viewer pages are session-bound, not PDFs (Audi-shape; per
#   feedback_convert_on_demand_not_bulk, drive those per gen-fill instead)
PDF_URL_RE = re.compile(
    r'https?://www\.mazda\.ca/globalassets/[^"\s\\<>]+\.pdf',
    re.I,
)

# Parse model folder + filename from the path:
#   .../manuals/vehicles/<model-folder>/<filename>.pdf
# model-folder is e.g. 'cx-5', 'cx-90-inline6', 'mazda3-sport', 'mx-5'.
# We use this as our model token because the filename styles vary.
PATH_RE = re.compile(
    r"/manuals/vehicles/(?P<model>[^/]+)/(?P<file>[^/]+)\.pdf$",
    re.I,
)
# Year extracted from the filename: 2025_, _2025, 2025-, 2025my_, etc.
# Followed by any non-digit so we don't capture into "20250101" or similar.
YEAR_RE = re.compile(r"(?:^|[^0-9])(20[0-2]\d)(?:my)?(?=\D|$)", re.I)

HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36",
    "Accept": "application/pdf,text/html;q=0.9,*/*;q=0.5",
}


def parse_meta(url: str) -> dict:
    """Pull (model, year) out of the URL path + filename."""
    m = PATH_RE.search(url)
    if not m:
        return {"model": None, "year": None, "file": None}
    model = m.group("model").lower()
    file = m.group("file").lower()
    y = YEAR_RE.search(file)
    year = int(y.group(1)) if y else None
    return {"model": model, "year": year, "file": file}


def local_filename(meta: dict, url: str) -> str:
    """mazda_cx-5_2025.pdf  /  mazda_cx-90_inline6_2025.pdf

    For URLs we can't parse cleanly, fall back to the URL basename with the
    'mazda_' prefix so we still get a deterministic name.
    """
    model = meta.get("model")
    year = meta.get("year")
    if not model:
        base = url.rsplit("/", 1)[-1].lower()
        return f"mazda_ca_{base}"
    parts = ["mazda", model]
    if year:
        parts.append(str(year))
    else:
        # No year in the filename — preserve the doc code so revisions don't clash.
        token = re.sub(r"[^a-z0-9]+", "_", (meta.get("file") or "")).strip("_")
        if token:
            parts.append(token)
    safe = "_".join(parts).replace("__", "_").strip("_")
    return f"{safe}.pdf"


def fetch_index() -> list[str]:
    r = requests.get(INDEX_URL, headers=HEADERS, timeout=30)
    r.raise_for_status()
    urls: list[str] = []
    seen: set[str] = set()
    for url in PDF_URL_RE.findall(r.text):
        url = unquote(url)
        if url not in seen:
            seen.add(url)
            urls.append(url)
    return urls


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
    ap.add_argument("--sleep", type=float, default=1.0)
    args = ap.parse_args()

    MANUALS_DIR.mkdir(parents=True, exist_ok=True)
    print(f"fetching index: {INDEX_URL}")
    urls = fetch_index()
    print(f"found {len(urls)} PDF URLs on mazda.ca/globalassets")

    todo: list[tuple[str, Path, dict]] = []
    dups = 0
    for url in urls:
        meta = parse_meta(url)
        local = MANUALS_DIR / local_filename(meta, url)
        if local.exists() and local.stat().st_size > 0:
            dups += 1
            continue
        todo.append((url, local, meta))

    print(f"new: {len(todo)}, already present: {dups}")
    if args.limit:
        todo = todo[: args.limit]
        print(f"limited to first {len(todo)}")
    if not todo:
        return 0

    if args.dry_run:
        print("\n--dry-run, would download:")
        for url, local, meta in todo:
            print(f"  {meta.get('model') or '?':<22} {str(meta.get('year') or '?'):>5} -> {local.name}")
        return 0

    ok = fail = 0
    for i, (url, local, meta) in enumerate(todo, 1):
        try:
            size = download(url, local)
            ok += 1
            print(f"  [{i}/{len(todo)}] OK  {local.name} -- {meta.get('model') or '?'} {meta.get('year') or '?'} -- {size/1024:.0f} KB", flush=True)
        except Exception as e:
            fail += 1
            print(f"  [{i}/{len(todo)}] ERR {local.name} -- {type(e).__name__}: {e}", flush=True)
        if i < len(todo) and args.sleep > 0:
            time.sleep(args.sleep)

    print(f"\nDone. downloaded={ok} failed={fail}")
    print("\nPer feedback_convert_on_demand_not_bulk: PDFs are now in manuals/.")
    print("Convert + index per-gen on demand, do NOT bulk-run convert_manuals.")
    return 0 if fail == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
