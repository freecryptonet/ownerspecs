#!/usr/bin/env python3
"""crawl_mitsubishi_nl.py — download Mitsubishi NL owner-manual PDFs.

Source: https://www.mitsubishi-motors.nl/handleidingen — manufacturer-owned,
direct PDFs, public_link=1 eligible (see reference_mitsubishi_manual_portal).

The portal links 87 manuals across ASX / Colt / Eclipse Cross / Grandis /
Lancer / Outlander / Outlander PHEV / Pajero / Pajero Sport / Space Star,
covering MY1998–MY2026. URL pattern:
  /content/dam/mitsubishi-motors-nl/downloads/handleidingen/<Model>_MY<YY>[_extra].pdf

Usage:
    python scripts/crawl_mitsubishi_nl.py --dry-run         # list, no downloads
    python scripts/crawl_mitsubishi_nl.py                   # download missing
    python scripts/crawl_mitsubishi_nl.py --limit 5         # only 5 new ones
    python scripts/crawl_mitsubishi_nl.py --with-convert    # also run convert + detect

The script is idempotent: a PDF already present in manuals/ (matched by
filename) is skipped. New files land as `mitsu_<model>_my<yy>[_extra].pdf`
(lowercased, underscore-joined) so they're identifiable in manual_inventory.
"""
from __future__ import annotations

import argparse
import re
import sys
import time
from pathlib import Path
from urllib.parse import urljoin

import requests

ROOT = Path(__file__).resolve().parent.parent
MANUALS_DIR = ROOT / "manuals"
BASE = "https://www.mitsubishi-motors.nl"
INDEX_URL = f"{BASE}/handleidingen"
PDF_HREF_RE = re.compile(
    r'href="(/content/dam/mitsubishi-motors-nl/downloads/handleidingen/[^"]+\.[pP][dD][fF])"'
)
# Filename pattern: <Model_with_underscores>_MY<yy>[_extra].pdf
NAME_RE = re.compile(
    r"^(?P<model>[A-Za-z_]+?)_MY(?P<my>\d{2,3})(?:_(?P<extra>[A-Za-z0-9%_]+))?\.[pP][dD][fF]$"
)

HEADERS = {
    "User-Agent": "ownerspecs-manual-crawler/0.1 (+spec verification; contact: tim@ownerspecs.com)",
    "Accept": "application/pdf,text/html;q=0.9,*/*;q=0.5",
}


def parse_year(my: str) -> int:
    """MY98 -> 1998, MY26 -> 2026, MY155 -> 2015 (mid-year facelift)."""
    if len(my) == 3:
        # e.g. '155' = 2015.5 = mid-year facelift, treat as 2015
        my = my[:2]
    n = int(my)
    return 1900 + n if n >= 90 else 2000 + n


def normalize_filename(src_filename: str) -> str:
    """ASX_MY11.pdf -> mitsu_asx_my11.pdf.

    Lowercase, prefix 'mitsu_', preserve the rest for traceability.
    URL-decoded so 'aanvulling%20HEV' becomes 'aanvulling_HEV'.
    """
    name = src_filename.replace("%20", "_")
    return f"mitsu_{name.lower()}"


def fetch_index() -> list[tuple[str, str]]:
    """Return list of (src_filename, absolute_url) tuples extracted from the portal."""
    r = requests.get(INDEX_URL, headers=HEADERS, timeout=30)
    r.raise_for_status()
    pairs: list[tuple[str, str]] = []
    seen: set[str] = set()
    for href in PDF_HREF_RE.findall(r.text):
        url = urljoin(BASE, href)
        src_name = href.rsplit("/", 1)[-1]
        if src_name in seen:
            continue
        seen.add(src_name)
        pairs.append((src_name, url))
    return pairs


def classify(src_filename: str) -> dict:
    """Pull model / year / supplement-flag from the source filename."""
    m = NAME_RE.match(src_filename)
    if not m:
        return {"model": None, "year": None, "is_supplement": False, "raw_my": None}
    model = m.group("model").replace("_", " ").strip()
    my = m.group("my")
    year = parse_year(my)
    extra = (m.group("extra") or "").lower()
    is_supplement = "aanvulling" in extra
    return {
        "model": model,
        "year": year,
        "is_supplement": is_supplement,
        "raw_my": my,
        "extra": extra or None,
    }


def download(url: str, dest: Path, retries: int = 2) -> int:
    """Stream a PDF to disk. Returns size in bytes."""
    for attempt in range(retries + 1):
        try:
            with requests.get(url, headers=HEADERS, stream=True, timeout=60) as r:
                r.raise_for_status()
                ct = r.headers.get("Content-Type", "").lower()
                if "pdf" not in ct and not url.lower().endswith((".pdf",)):
                    raise RuntimeError(f"unexpected content-type {ct} for {url}")
                tmp = dest.with_suffix(dest.suffix + ".part")
                size = 0
                with tmp.open("wb") as f:
                    for chunk in r.iter_content(chunk_size=64 * 1024):
                        if chunk:
                            f.write(chunk)
                            size += len(chunk)
                tmp.replace(dest)
                return size
        except Exception as e:
            if attempt == retries:
                raise
            time.sleep(2 + attempt * 2)
    return 0  # unreachable


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true", help="list, don't download")
    ap.add_argument("--limit", type=int, help="only download this many new files")
    ap.add_argument("--sleep", type=float, default=1.0, help="seconds between downloads (default 1)")
    ap.add_argument("--with-convert", action="store_true",
                    help="after downloading, run convert_manuals.py + detect_sections.py --write-db")
    args = ap.parse_args()

    MANUALS_DIR.mkdir(parents=True, exist_ok=True)
    print(f"fetching index: {INDEX_URL}")
    pairs = fetch_index()
    print(f"found {len(pairs)} PDF links on the portal")

    todo: list[tuple[str, str, Path, dict]] = []
    skipped = 0
    for src_name, url in pairs:
        local = MANUALS_DIR / normalize_filename(src_name)
        if local.exists() and local.stat().st_size > 0:
            skipped += 1
            continue
        todo.append((src_name, url, local, classify(src_name)))

    print(f"new: {len(todo)}, already present: {skipped}")
    if args.limit:
        todo = todo[: args.limit]
        print(f"limited to first {len(todo)}")
    if not todo:
        print("nothing to download.")
        return 0

    if args.dry_run:
        print("\n--dry-run, would download:")
        for src, url, local, meta in todo:
            print(f"  {meta.get('model') or '?':<22} MY{meta.get('raw_my')} -> {local.name}  ({url})")
        return 0

    ok = fail = 0
    new_files: list[Path] = []
    for i, (src, url, local, meta) in enumerate(todo, 1):
        try:
            size = download(url, local)
            ok += 1
            new_files.append(local)
            print(f"  [{i}/{len(todo)}] OK  {local.name} — {meta.get('model') or '?'} MY{meta.get('raw_my')} — {size/1024:.0f} KB", flush=True)
        except Exception as e:
            fail += 1
            print(f"  [{i}/{len(todo)}] ERR {local.name} — {type(e).__name__}: {e}", flush=True)
        if i < len(todo) and args.sleep > 0:
            time.sleep(args.sleep)

    print(f"\nDone. downloaded={ok} failed={fail}")

    if args.with_convert and new_files:
        print("\n-> converting new PDFs to markdown ...")
        import subprocess
        py = sys.executable
        cv = subprocess.run([py, str(ROOT / "scripts" / "convert_manuals.py"),
                             "--workers", "2", "--skip-large", "1000"],
                            cwd=str(ROOT), check=False)
        if cv.returncode != 0:
            print("convert_manuals exited non-zero; skipping detect_sections")
            return 1
        print("\n-> detect_sections --write-db ...")
        ds = subprocess.run([py, str(ROOT / "scripts" / "detect_sections.py"), "--write-db"],
                            cwd=str(ROOT), check=False)
        return ds.returncode

    return 0 if fail == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
