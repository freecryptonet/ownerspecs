#!/usr/bin/env python3
"""build_hyundai_url_map.py — produce hyundai_url_map.json keyed by local filename.

The hyundai.com/nl owner-manual index page lists ~70 PDFs on two Hyundai-owned
CDNs (dmassets.hyundai.com + s7g10.scene7.com — both public manufacturer-owned,
public_link=1 eligible per [[reference_source_link_gating]]).

Reuses normalize_filename from crawl_hyundai_nl.py so the local→URL key matches
exactly what the crawler wrote to disk.

Output: hyundai_url_map.json at repo root, shape {filename: url}.
backfill_oem_manual_urls.py reads it via the same load-once pattern used for
the Mopar map (mig 518 session).
"""
from __future__ import annotations

import json
import re
import sys
from pathlib import Path
from urllib.parse import unquote

import requests

ROOT = Path(__file__).resolve().parent.parent
OUT_PATH = ROOT / "hyundai_url_map.json"

INDEX_URL = "https://www.hyundai.com/nl/nl/brochures/handleidingen.html"

PDF_URL_RE = re.compile(
    r'https?://(?:dmassets\.hyundai\.com|s7g10\.scene7\.com)/is/content/hyundaiautoever/[^"\s\\<>]+pdf'
)

HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36",
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
    "Accept-Language": "en-US,en;q=0.9",
}


def normalize_filename(url: str) -> str:
    """Replicates crawl_hyundai_nl.py.normalize_filename — keep in sync."""
    stem = url.rsplit("/", 1)[-1]
    if stem.lower().endswith("pdf"):
        stem = stem[:-3]
    decoded = unquote(stem).replace("+", " ").replace("-", " ")
    decoded = re.sub(r"\s+", " ", decoded).strip()
    for prefix in (
        "AVN Gebruikershandleiding ",
        "Gebruikershandleiding ",
        "Instructieboekje ",
        "Handleiding ",
    ):
        if decoded.lower().startswith(prefix.lower()):
            decoded = decoded[len(prefix):]
            break
    body = re.sub(r"[^A-Za-z0-9]+", "_", decoded).strip("_").lower()
    return f"hyundai_{body}.pdf"


def main() -> int:
    print(f"fetching {INDEX_URL}")
    r = requests.get(INDEX_URL, headers=HEADERS, timeout=30)
    r.raise_for_status()
    urls = sorted(set(PDF_URL_RE.findall(r.text)))
    print(f"found {len(urls)} PDF URLs on index page")

    out: dict[str, str] = {}
    for url in urls:
        fname = normalize_filename(url)
        if fname in out and out[fname] != url:
            print(f"  WARN: collision on {fname}\n    keeping {out[fname]}\n    skipping {url}")
            continue
        out[fname] = url

    OUT_PATH.write_text(json.dumps(out, indent=2), encoding="utf-8")
    print(f"wrote {OUT_PATH} ({len(out)} entries)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
