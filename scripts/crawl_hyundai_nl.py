#!/usr/bin/env python3
"""crawl_hyundai_nl.py — download Hyundai NL owner-manual PDFs.

Source: https://www.hyundai.com/nl/nl/brochures/handleidingen.html — manufacturer-owned,
hyundai.com domain → public_link=1 eligible (see reference_hyundai_manual_portals).

The portal links ~70 PDFs across i10 / i20 / i30 / i40 / ix20 / KONA /
KONA Electric / KONA Hybrid / TUCSON / TUCSON (P)HEV / SANTA FE / SANTA FE (P)HEV /
IONIQ (Hybrid/PHEV/Electric) / IONIQ 5 / IONIQ 5 N / IONIQ 6 / NEXO / BAYON / INSTER.

PDFs live on two Hyundai-owned CDNs:
  - dmassets.hyundai.com/is/content/hyundaiautoever/<name>pdf   (newer assets)
  - s7g10.scene7.com/is/content/hyundaiautoever/<name>pdf       (older assets)
Both serve `application/pdf` despite the missing dot in the URL slug.

Usage:
    python scripts/crawl_hyundai_nl.py --dry-run
    python scripts/crawl_hyundai_nl.py
    python scripts/crawl_hyundai_nl.py --limit 5
    python scripts/crawl_hyundai_nl.py --include-avn        # include AVN infotainment guides (default: skip)
    python scripts/crawl_hyundai_nl.py --with-convert       # chain convert_manuals + detect_sections

Local naming: `hyundai_<model>_<rest>.pdf` — lowercased, underscore-joined,
prefixes 'handleiding'/'instructieboekje' stripped so the brand_guess heuristic
in detect_sections lands on 'hyundai'.
"""
from __future__ import annotations

import argparse
import re
import sys
import time
from pathlib import Path
from urllib.parse import unquote, urljoin

import requests

ROOT = Path(__file__).resolve().parent.parent
MANUALS_DIR = ROOT / "manuals"
INDEX_URL = "https://www.hyundai.com/nl/nl/brochures/handleidingen.html"

# Both Hyundai-owned CDNs. The hyundaiautoever path is the constant slug for OEM manuals.
PDF_URL_RE = re.compile(
    r'https?://(?:dmassets\.hyundai\.com|s7g10\.scene7\.com)/is/content/hyundaiautoever/[^"\s\\<>]+pdf'
)

HEADERS = {
    "User-Agent": "ownerspecs-manual-crawler/0.1 (+spec verification; contact: tim@ownerspecs.com)",
    "Accept": "application/pdf,text/html;q=0.9,*/*;q=0.5",
}


def normalize_filename(url: str) -> str:
    """Turn a Hyundai CDN URL into a clean local filename.

    Input examples:
      .../hyundaiautoever/Handleiding-INSTER-AX1-EV-2025pdf
      .../hyundaiautoever/Handleiding+KONA+SX2+Electric+2025pdf
      .../hyundaiautoever/Handleiding+Tucson+%28P%29HEV+NX4+MY2025pdf
      .../hyundaiautoever/AVN+Gebruikershandleiding+i10+IA+2013-2019pdf
      .../hyundaiautoever/Instructieboekje+Kona+HEV+SX2pdf

    Output: 'hyundai_kona_sx2_electric_2025.pdf' etc.
    """
    stem = url.rsplit("/", 1)[-1]
    if stem.lower().endswith("pdf"):
        stem = stem[:-3]
    decoded = unquote(stem).replace("+", " ").replace("-", " ")
    decoded = re.sub(r"\s+", " ", decoded).strip()
    # Strip Dutch OM-prefixes so brand_guess in detect_sections gets 'hyundai'.
    for prefix in ("AVN Gebruikershandleiding ", "Gebruikershandleiding ",
                   "Instructieboekje ", "Handleiding "):
        if decoded.lower().startswith(prefix.lower()):
            decoded = decoded[len(prefix):]
            break
    body = re.sub(r"[^A-Za-z0-9]+", "_", decoded).strip("_").lower()
    return f"hyundai_{body}.pdf"


def is_avn_guide(url: str) -> bool:
    return "avn+gebruikershandleiding" in url.lower() or "avn-gebruikershandleiding" in url.lower()


def fetch_index() -> list[str]:
    r = requests.get(INDEX_URL, headers=HEADERS, timeout=30)
    r.raise_for_status()
    urls: list[str] = []
    seen: set[str] = set()
    for url in PDF_URL_RE.findall(r.text):
        if url not in seen:
            seen.add(url)
            urls.append(url)
    return urls


# Known model tokens, longest first so 'IONIQ 5 N' matches before 'IONIQ 5'.
# Patterns assume `base` has had underscores normalized to spaces — \b in
# Python's re treats '_' as a word char, so without normalization it never
# fires inside our slug-style filenames.
MODEL_PATTERNS: list[tuple[str, re.Pattern]] = [
    # IONIQ 5 N — must NOT capture "IONIQ 5 NE 2023" (NE is the chassis code).
    # Match the compact form 'ioniq5n' OR 'ioniq 5 n' followed by non-letter.
    ("IONIQ 5 N",       re.compile(r"\bioniq ?5 ?n(?![a-z])", re.I)),
    ("IONIQ 5",         re.compile(r"\bioniq ?5\b", re.I)),
    ("IONIQ 6",         re.compile(r"\bioniq ?6\b", re.I)),
    ("IONIQ Plug-in",   re.compile(r"\bioniq\b.*(plug.?in|phev)", re.I)),
    ("IONIQ Electric",  re.compile(r"\bioniq\b.*(electric|\bev\b)", re.I)),
    ("IONIQ Hybrid",    re.compile(r"\bioniq\b.*(hybrid|\bhev\b)", re.I)),
    ("IONIQ",           re.compile(r"\bioniq\b", re.I)),
    ("KONA Electric",   re.compile(r"\bkona\b.*(electric|\bev\b)", re.I)),
    ("KONA Hybrid",     re.compile(r"\bkona\b.*(hybrid|\bhev\b)", re.I)),
    ("KONA N",          re.compile(r"\bkona\b.*\bosn\b", re.I)),  # KONA N's chassis suffix
    ("KONA",            re.compile(r"\bkona\b", re.I)),
    ("TUCSON Hybrid",   re.compile(r"\btucson\b.*(hev|phev|hybrid)", re.I)),
    ("TUCSON",          re.compile(r"\btucson\b", re.I)),
    ("SANTA FE Hybrid", re.compile(r"\bsanta ?fe\b.*(hev|phev|hybrid)", re.I)),
    ("SANTA FE",        re.compile(r"\bsanta ?fe\b", re.I)),
    ("BAYON",           re.compile(r"\bbayon\b", re.I)),
    ("NEXO",            re.compile(r"\bnexo\b", re.I)),
    ("INSTER",          re.compile(r"\binster\b", re.I)),
    ("i10",             re.compile(r"\bi10\b", re.I)),
    ("i20 N",           re.compile(r"\bi20\b.*\bn\b", re.I)),
    ("i20",             re.compile(r"\bi20\b", re.I)),
    ("i30 N",           re.compile(r"\bi30\b.*\bn\b", re.I)),
    ("i30",             re.compile(r"\bi30\b", re.I)),
    ("i40",             re.compile(r"\bi40\b", re.I)),
    ("ix20",            re.compile(r"\bix20\b", re.I)),
]


def classify(local_name: str) -> dict:
    """Best-effort model/year extraction from the local filename."""
    base = local_name.replace("hyundai_", "").rsplit(".", 1)[0]
    # Normalize underscores to spaces so \b works at slug-token boundaries.
    base = base.replace("_", " ")
    model = None
    for name, pat in MODEL_PATTERNS:
        if pat.search(base):
            model = name
            break
    # Year: prefer 4-digit '2024' / '2025', else MY2024, else first range like 2017-2019
    year = None
    m = re.search(r"\b(20[0-2]\d)(?:\s|_|-)(20[0-2]\d)\b", base)
    if m:
        year = (int(m.group(1)), int(m.group(2)))
    else:
        m = re.search(r"(?:my)?[_\s]?(20[0-2]\d)\b", base, re.I)
        if m:
            year = (int(m.group(1)), int(m.group(1)))
    return {"model": model, "year": year}


def download(url: str, dest: Path, retries: int = 2) -> int:
    for attempt in range(retries + 1):
        try:
            with requests.get(url, headers=HEADERS, stream=True, timeout=60) as r:
                r.raise_for_status()
                ct = r.headers.get("Content-Type", "").lower()
                if "pdf" not in ct:
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
    ap.add_argument("--include-avn", action="store_true",
                    help="include AVN infotainment user-guide PDFs (default: skipped — they're not OMs)")
    ap.add_argument("--with-convert", action="store_true",
                    help="after downloading, chain convert_manuals + detect_sections --write-db")
    args = ap.parse_args()

    MANUALS_DIR.mkdir(parents=True, exist_ok=True)
    print(f"fetching index: {INDEX_URL}")
    urls = fetch_index()
    print(f"found {len(urls)} PDF links")

    if not args.include_avn:
        before = len(urls)
        urls = [u for u in urls if not is_avn_guide(u)]
        print(f"skipped {before - len(urls)} AVN guides (use --include-avn to keep)")

    todo: list[tuple[str, Path, dict]] = []
    dups = 0
    for url in urls:
        local = MANUALS_DIR / normalize_filename(url)
        if local.exists() and local.stat().st_size > 0:
            dups += 1
            continue
        todo.append((url, local, classify(local.name)))

    print(f"new: {len(todo)}, already present: {dups}")
    if args.limit:
        todo = todo[: args.limit]
        print(f"limited to first {len(todo)}")
    if not todo:
        return 0

    if args.dry_run:
        print("\n--dry-run, would download:")
        for url, local, meta in todo:
            yr = f"{meta['year'][0]}-{meta['year'][1]}" if meta["year"] else "?"
            print(f"  {meta.get('model') or '?':<18} {yr:>9} -> {local.name}  ({url})")
        return 0

    ok = fail = 0
    new_files: list[Path] = []
    for i, (url, local, meta) in enumerate(todo, 1):
        try:
            size = download(url, local)
            ok += 1
            new_files.append(local)
            yr = f"{meta['year'][0]}-{meta['year'][1]}" if meta["year"] else "?"
            print(f"  [{i}/{len(todo)}] OK  {local.name} -- {meta.get('model') or '?'} {yr} -- {size/1024:.0f} KB", flush=True)
        except Exception as e:
            fail += 1
            print(f"  [{i}/{len(todo)}] ERR {local.name} -- {type(e).__name__}: {e}", flush=True)
        if i < len(todo) and args.sleep > 0:
            time.sleep(args.sleep)

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
        print("\n-> detect_sections --write-db ...")
        ds = subprocess.run([py, str(ROOT / "scripts" / "detect_sections.py"), "--write-db"],
                            cwd=str(ROOT), check=False)
        return ds.returncode

    return 0 if fail == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
