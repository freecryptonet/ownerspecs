#!/usr/bin/env python3
"""crawl_kia_ca.py — Kia Canada owner-manual harvester.

Source: https://www.kia.ca/en/owners/kia-ownership/owner-resources — public-facing
'Find a Document' selector that hits an AEM JSON endpoint per (year, model).
Kia US is login-walled (owners.kia.com SAML); Kia CA is the canonical English
Kia OM source, same posture as Mazda CA → Mazda US per
[[reference_mazda_canada_om_portal]].

AEM endpoint (no auth):

    https://www.kia.ca/content/marketing/ca/en/owners/kia-ownership/owner-resources/
      jcr:content/root/container/container/find_a_document.docs.json
        ?_lang=en&_year=<YEAR>&_model=<lowercase-model-slug>

Returns JSON grouped by document tag (warranty / owner):

    {"docs":[
      {"tag":{"id":"documents:warranty",...},"documents":[{"path":"/content/dam/marketing/documents/en/warranty/2023-2024.pdf","title":"2023 - 2024"},...]},
      {"tag":{"id":"documents:owner",...},"documents":[{"path":"/content/dam/marketing/documents/en/owners/2024/24-niro-hev-phev.pdf","title":"2024 Niro HEV/PHEV"}]}
    ]}

PDFs live on `kia.ca/content/dam/...` (manufacturer-owned). `public_link=1` eligible
per the mig 194 policy. Mozilla UA is sufficient — no Akamai wall.

Usage:
    python scripts/crawl_kia_ca.py --dry-run
    python scripts/crawl_kia_ca.py
    python scripts/crawl_kia_ca.py --limit 5
    python scripts/crawl_kia_ca.py --include-warranty   # default: OM only

Per [[feedback_convert_on_demand_not_bulk]] (2026-05-29): crawler stops at
download. Convert + index per-gen later, on demand.

Local naming: `kia_ca_<source-basename>.pdf` — keeps the source filename which
already encodes (year, model, variant) like '24-niro-hev-phev.pdf'. `kia_ca_`
prefix so detect_sections' brand_guess heuristic resolves to brand=kia and the
market is unambiguous when we cite for a US gen.
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
BASE = "https://www.kia.ca"
DOCS_TMPL = (
    BASE
    + "/content/marketing/ca/en/owners/kia-ownership/owner-resources/"
    + "jcr:content/root/container/container/find_a_document.docs.json"
    + "?_lang=en&_year={year}&_model={model}"
)

# Model + year ranges pulled from the live <select> on 2026-05-29.
MODELS = [
    "amanti", "borrego", "cadenza", "carnival", "carnival-hev", "ev3", "ev4",
    "ev5", "ev6", "ev9", "ev9-gt", "forte", "forte5", "k4", "k4-hatchback",
    "k5", "k900", "magentis", "niro", "niro-ev", "niro-phev", "optima",
    "optima-hybrid", "optima-phev", "pv5", "rio", "rio5", "rondo", "sedona",
    "seltos", "sephia", "sorento", "sorento-hev", "sorento-phev", "soul",
    "soul-ev", "spectra", "sportage", "sportage-hev", "sportage-phev",
    "stinger", "telluride",
]
# Year dropdown range — 2000-2027.
YEARS = list(range(2000, 2028))

HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36",
    "Accept": "application/json, text/plain;q=0.9, */*;q=0.5",
}


def fetch_docs(year: int, model: str, retries: int = 2) -> list[dict]:
    """Return the docs JSON for (year, model); empty list when nothing exists."""
    url = DOCS_TMPL.format(year=year, model=model)
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
            return j.get("docs") or []
        except Exception:
            if attempt == retries:
                raise
            time.sleep(1 + attempt)
    return []


def local_filename(src_path: str) -> str:
    """`/content/dam/marketing/documents/en/owners/2024/24-niro-hev-phev.pdf`
    → `kia_ca_24-niro-hev-phev.pdf`. brand_guess in detect_sections splits on
    '_' so the first token is 'kia'."""
    basename = src_path.rsplit("/", 1)[-1].lower()
    if not basename.endswith(".pdf"):
        basename += ".pdf"
    return f"kia_ca_{basename}"


def is_owner_manual(tag_id: str) -> bool:
    return "owner" in (tag_id or "").lower()


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
    ap.add_argument("--include-warranty", action="store_true",
                    help="also download warranty PDFs (default: OM only)")
    args = ap.parse_args()

    MANUALS_DIR.mkdir(parents=True, exist_ok=True)
    print(f"Kia CA crawler — {len(MODELS)} models × {len(YEARS)} years = {len(MODELS)*len(YEARS)} probes")

    seen: set[str] = set()
    todo: list[tuple[str, Path, dict]] = []
    api_err = empty = 0
    print("\nStage 1/2 — AEM lookup per (year, model):")
    probes = [(y, m) for y in YEARS for m in MODELS]
    for i, (y, m) in enumerate(probes, 1):
        try:
            doc_groups = fetch_docs(y, m)
        except Exception as e:
            api_err += 1
            print(f"  [{i}/{len(probes)}] ERR  {y} {m}  ({type(e).__name__})", flush=True)
            continue
        had_hit = False
        for group in doc_groups:
            tag_id = (group.get("tag") or {}).get("id") or ""
            is_om = is_owner_manual(tag_id)
            if not is_om and not args.include_warranty:
                continue
            for d in group.get("documents") or []:
                path = d.get("path") or ""
                if not path.endswith(".pdf"):
                    continue
                if path in seen:
                    continue
                seen.add(path)
                local = MANUALS_DIR / local_filename(path)
                if local.exists() and local.stat().st_size > 0:
                    had_hit = True
                    continue
                kind = "om" if is_om else "war"
                todo.append((BASE + path, local, {"year": y, "model": m, "kind": kind, "title": d.get("title") or ""}))
                had_hit = True
        if not had_hit:
            empty += 1
        if i % 100 == 0:
            print(f"  ...{i}/{len(probes)} probes done, {len(todo)} new PDFs queued, {empty} empty, {api_err} errors", flush=True)
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
            print(f"  {meta['model']:<22} MY{meta['year']} {meta['kind']:<3} -> {local.name}")
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
    print("Convert + index per-gen on demand, do NOT bulk-run convert_manuals.")
    return 0 if fail == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
