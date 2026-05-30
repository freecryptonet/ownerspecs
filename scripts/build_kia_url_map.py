#!/usr/bin/env python3
"""build_kia_url_map.py — produce kia_url_map.json keyed by local filename.

The kia.ca/content/marketing AEM endpoint returns owner-manual paths per
(year, model) tuple. The local crawler preserved each path verbatim under
`kia_ca_<basename>.pdf`, but the **CDN folder layout varies by year** (some
under /owners/<year>/, some under /owners/<model>/, some flat /owners/),
so the URL isn't deterministic from filename. We re-query the endpoint and
map filename → full URL.

Output: kia_url_map.json at repo root, shape {filename: url}.

API courtesy: 0.3s sleep between calls (~6 min for 41 models × 28 years).
"""
from __future__ import annotations

import argparse
import json
import sys
import time
from pathlib import Path

import requests

ROOT = Path(__file__).resolve().parent.parent
OUT_PATH = ROOT / "kia_url_map.json"

BASE = "https://www.kia.ca"
DOCS_TMPL = (
    BASE
    + "/content/marketing/ca/en/owners/kia-ownership/owner-resources/"
    + "jcr:content/root/container/container/find_a_document.docs.json"
    + "?_lang=en&_year={year}&_model={model}"
)

MODELS = [
    "amanti", "borrego", "cadenza", "carnival", "carnival-hev", "ev3", "ev4",
    "ev5", "ev6", "ev9", "ev9-gt", "forte", "forte5", "k4", "k4-hatchback",
    "k5", "k900", "magentis", "niro", "niro-ev", "niro-phev", "optima",
    "optima-hybrid", "optima-phev", "pv5", "rio", "rio5", "rondo", "sedona",
    "seltos", "sephia", "sorento", "sorento-hev", "sorento-phev", "soul",
    "soul-ev", "spectra", "sportage", "sportage-hev", "sportage-phev",
    "stinger", "telluride",
]
YEARS = list(range(2000, 2028))

HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36",
    "Accept": "application/json, text/plain;q=0.9, */*;q=0.5",
}


def local_filename(path: str) -> str:
    """`/content/dam/.../24-niro-hev-phev.pdf` → `kia_ca_24-niro-hev-phev.pdf`.

    Same convention as crawl_kia_ca.py.local_filename — keep in sync.
    """
    basename = path.rsplit("/", 1)[-1].lower()
    if not basename.endswith(".pdf"):
        basename += ".pdf"
    return f"kia_ca_{basename}"


def fetch_docs(year: int, model: str, retries: int = 2) -> list[dict]:
    url = DOCS_TMPL.format(year=year, model=model)
    for attempt in range(retries + 1):
        try:
            r = requests.get(url, headers=HEADERS, timeout=20)
            if r.status_code == 404:
                return []
            r.raise_for_status()
            try:
                return json.loads(r.text).get("docs") or []
            except json.JSONDecodeError:
                return []
        except Exception:
            if attempt == retries:
                raise
            time.sleep(1 + attempt)
    return []


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--sleep", type=float, default=0.3)
    ap.add_argument("--resume", action="store_true")
    args = ap.parse_args()

    existing: dict[str, str] = {}
    if args.resume and OUT_PATH.exists():
        existing = json.loads(OUT_PATH.read_text(encoding="utf-8"))
        print(f"resume mode: {len(existing)} entries already mapped")

    out = dict(existing)
    tuples = [(y, m) for m in MODELS for y in YEARS]
    print(f"scanning {len(tuples)} (year, model) tuples")
    miss = err = 0
    for i, (year, model) in enumerate(tuples, 1):
        try:
            docs = fetch_docs(year, model)
        except Exception as e:
            err += 1
            if err <= 5:
                print(f"  [{i}] ERR {model}/{year}: {type(e).__name__}")
            continue
        if not docs:
            miss += 1
        for d in docs:
            tag_id = (d.get("tag") or {}).get("id", "")
            if "owner" not in tag_id.lower():
                continue
            for doc in d.get("documents", []):
                path = doc.get("path") or ""
                if not path or not path.endswith(".pdf"):
                    continue
                fname = local_filename(path)
                url = BASE + path
                if fname in out and out[fname] != url:
                    pass  # later year wins by iteration order
                out[fname] = url
        if i % 100 == 0 or i == len(tuples):
            OUT_PATH.write_text(json.dumps(out, indent=2), encoding="utf-8")
            print(f"  [{i}/{len(tuples)}] mapped={len(out)} miss={miss} err={err}", flush=True)
        if args.sleep > 0 and i < len(tuples):
            time.sleep(args.sleep)

    OUT_PATH.write_text(json.dumps(out, indent=2), encoding="utf-8")
    print(f"\ndone. wrote {OUT_PATH} ({len(out)} entries)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
