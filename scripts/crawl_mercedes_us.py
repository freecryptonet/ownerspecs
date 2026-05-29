#!/usr/bin/env python3
"""crawl_mercedes_us.py — Mercedes-Benz US owner-manual harvester.

Source: https://www.mbusa.com/en/owners/manuals

Mercedes US is the rare premium-OEM exception: **public direct PDFs, no login**.
Each chassis edition has a stable slug `<body>-<year>-<MM>-<chassis>-<infotainment>`
and the PDF lives at a predictable transform of that slug:

    chassis slug: c-class-sedan-2025-10-w206-mbux
    PDF URL:      https://www.mbusa.com/css-oom/assets/en-us/pdf/
                    mercedes-c-class-sedan-2025-october-w206-mbux-operators-manual-1.pdf

Transform: `-MM-` → `-<month-name>-`, prefix `mercedes-`, suffix `-operators-manual-1.pdf`.

Two-stage flow:
- Stage 1 (Playwright, done once): scrape `/manuals` for the latest 41 chassis slugs
  → mercedes_us_chassis.json
- Stage 2 (this script): derive PDF URL per slug, download with Mozilla UA.

The transform works on ~7/8 modern MBUX editions; older `-audio` and some
`-comand` infotainment editions need per-chassis Playwright scraping (not
implemented in v1 — Tim's instinct on the on-demand pivot means we don't
need every historical Mercedes edition right now).

Usage:
    python scripts/crawl_mercedes_us.py --chassis mercedes_us_chassis.json --dry-run
    python scripts/crawl_mercedes_us.py --chassis mercedes_us_chassis.json
    python scripts/crawl_mercedes_us.py --chassis mercedes_us_chassis.json --limit 5

Local naming: `mercedes_<slug>.pdf` (slug already encodes model + year + chassis
+ infotainment, e.g. `mercedes_c-class-sedan-2025-10-w206-mbux.pdf`). `mercedes_`
prefix so detect_sections' brand_guess resolves to 'mercedes' and the market is
unambiguous when citing.

Per [[feedback_convert_on_demand_not_bulk]] (2026-05-29): crawler stops at
download. Convert + index per-gen later, on demand.
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
BASE = "https://www.mbusa.com"
PDF_ROOT = BASE + "/css-oom/assets/en-us/pdf"

MONTHS = ["", "january", "february", "march", "april", "may", "june",
          "july", "august", "september", "october", "november", "december"]

HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36",
    "Accept": "application/pdf,*/*;q=0.5",
    "Referer": "https://www.mbusa.com/en/owners/manuals",
}


def chassis_to_pdf_url(chassis_path: str) -> str:
    """`/en/owners/manuals/c-class-sedan-2025-10-w206-mbux` →
       `https://www.mbusa.com/css-oom/assets/en-us/pdf/mercedes-c-class-sedan-2025-october-w206-mbux-operators-manual-1.pdf`"""
    slug = chassis_path.split("/")[-1]

    def repl_month(m: re.Match) -> str:
        y, mm = m.group(1), m.group(2)
        idx = int(mm)
        return f"-{y}-{MONTHS[idx]}-" if 1 <= idx <= 12 else m.group(0)

    out = re.sub(r"-(\d{4})-(\d{2})-", repl_month, slug, count=1)
    return f"{PDF_ROOT}/mercedes-{out}-operators-manual-1.pdf"


def chassis_to_local_name(chassis_path: str) -> str:
    slug = chassis_path.split("/")[-1]
    return f"mercedes_{slug}.pdf"


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


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--chassis", default="mercedes_us_chassis.json",
                    help="JSON list of '/en/owners/manuals/<slug>' paths (scrape once via Playwright)")
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--limit", type=int)
    ap.add_argument("--sleep", type=float, default=1.0)
    args = ap.parse_args()

    cat_path = Path(args.chassis)
    if not cat_path.is_absolute():
        cat_path = ROOT / cat_path
    if not cat_path.exists():
        sys.exit(f"chassis list not found: {cat_path}")
    chassis_paths = json.loads(cat_path.read_text(encoding="utf-8"))
    if not isinstance(chassis_paths, list) or not chassis_paths:
        sys.exit("chassis list should be a non-empty list of '/en/owners/manuals/...' paths")
    print(f"loaded {len(chassis_paths)} chassis paths")

    MANUALS_DIR.mkdir(parents=True, exist_ok=True)

    todo: list[tuple[str, Path, dict]] = []
    for c in chassis_paths:
        pdf_url = chassis_to_pdf_url(c)
        local = MANUALS_DIR / chassis_to_local_name(c)
        if local.exists() and local.stat().st_size > 0:
            continue
        todo.append((pdf_url, local, {"chassis": c.split("/")[-1]}))

    print(f"new (not yet on disk): {len(todo)}")
    if not todo:
        return 0
    if args.limit:
        todo = todo[: args.limit]
        print(f"--limit {args.limit}: will download first {len(todo)}")

    if args.dry_run:
        print("\n--dry-run, would download:")
        for url, local, meta in todo:
            print(f"  {meta['chassis']:<50} -> {local.name}")
            print(f"    {url}")
        return 0

    print(f"\nDownloading {len(todo)} PDFs (Mercedes OMs are 30-60 MB each):")
    ok = fail = 0
    for i, (url, local, meta) in enumerate(todo, 1):
        try:
            size = download(url, local)
            ok += 1
            print(f"  [{i}/{len(todo)}] OK  {local.name} ({size/1024/1024:.1f} MB)", flush=True)
        except requests.HTTPError as e:
            fail += 1
            print(f"  [{i}/{len(todo)}] 404 {local.name} (URL transform missed — likely older non-MBUX edition)", flush=True)
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
