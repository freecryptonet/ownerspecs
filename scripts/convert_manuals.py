#!/usr/bin/env python3
"""convert_manuals.py — batch-convert PDFs in manuals/ to .md alongside.

For every PDF under manuals/ where no sibling .md exists (or .pdf is newer than
the .md), run pymupdf4llm with page_chunks=True and stitch the pages into one
markdown file with HTML page markers ('<!--PAGE n-->') so a downstream section
detector can recover page numbers.

Why this exists: the current workflow re-runs pypdf per query, costing 30-60s
per spec lookup. After one-shot conversion every query is a `grep` over a small
markdown file. Section_map + manual_inventory wires up the rest.

Usage:
    python scripts/convert_manuals.py                  # converts everything new
    python scripts/convert_manuals.py --force          # reconvert even if .md exists
    python scripts/convert_manuals.py --only foo.pdf   # one file
    python scripts/convert_manuals.py --workers 4      # parallel (default: 2)
    python scripts/convert_manuals.py --skip-large 1000  # skip PDFs > N pages

Run inside the venv that has pymupdf4llm:
    F:\\projects\\ownerspecs\\.venv-manuals\\Scripts\\python.exe scripts/convert_manuals.py
"""
from __future__ import annotations

import argparse
import os
import sys
import time
from concurrent.futures import ProcessPoolExecutor, as_completed
from pathlib import Path
from typing import Iterable

import pymupdf
import pymupdf4llm

ROOT = Path(__file__).resolve().parent.parent
MANUALS_DIR = ROOT / "manuals"


def needs_conversion(pdf: Path, force: bool) -> bool:
    md = pdf.with_suffix(".md")
    if force:
        return True
    if not md.exists():
        return True
    return pdf.stat().st_mtime > md.stat().st_mtime


def convert_one(pdf_path_str: str, skip_large: int | None) -> dict:
    """Run in a worker process. Returns {file, pages, sec, ok, err?}."""
    pdf = Path(pdf_path_str)
    t0 = time.time()
    try:
        doc = pymupdf.open(pdf)
        n_pages = doc.page_count
        if skip_large and n_pages > skip_large:
            doc.close()
            return {"file": pdf.name, "pages": n_pages, "sec": 0, "ok": False,
                    "err": f"skipped: {n_pages} pages > --skip-large={skip_large}"}
        doc.close()

        chunks = pymupdf4llm.to_markdown(
            str(pdf),
            page_chunks=True,
            show_progress=False,
            ignore_images=True,
        )
        parts = []
        for ch in chunks:
            page = ch.get("metadata", {}).get("page_number", 0)
            text = ch.get("text", "").rstrip()
            parts.append(f"<!--PAGE {page}-->\n{text}\n")
        md = "\n".join(parts)
        out = pdf.with_suffix(".md")
        out.write_text(md, encoding="utf-8")
        return {"file": pdf.name, "pages": n_pages,
                "sec": round(time.time() - t0, 1), "ok": True,
                "chars": len(md)}
    except Exception as e:
        return {"file": pdf.name, "pages": 0,
                "sec": round(time.time() - t0, 1), "ok": False,
                "err": f"{type(e).__name__}: {e}"}


def collect_pdfs(only: str | None) -> list[Path]:
    if only:
        p = MANUALS_DIR / only if not Path(only).is_absolute() else Path(only)
        if not p.exists():
            sys.exit(f"--only target not found: {p}")
        return [p]
    return sorted(MANUALS_DIR.glob("*.pdf"))


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--force", action="store_true", help="reconvert even if .md exists and is newer")
    ap.add_argument("--only", help="convert just this one file (name or absolute path)")
    ap.add_argument("--workers", type=int, default=2, help="parallel workers (default 2)")
    ap.add_argument("--skip-large", type=int, default=None,
                    help="skip PDFs with more than N pages (e.g. 1000 to skip FSMs)")
    ap.add_argument("--limit", type=int, default=None,
                    help="convert at most N files this run (for batched runs that don't burn the CPU all night)")
    args = ap.parse_args()

    all_pdfs = collect_pdfs(args.only)
    todo = [p for p in all_pdfs if needs_conversion(p, args.force)]
    skipped_uptodate = len(all_pdfs) - len(todo)

    print(f"manuals dir: {MANUALS_DIR}")
    print(f"found {len(all_pdfs)} PDFs, {len(todo)} need conversion, {skipped_uptodate} already up-to-date")
    if args.skip_large:
        print(f"will skip PDFs > {args.skip_large} pages")
    if args.limit and len(todo) > args.limit:
        todo = todo[: args.limit]
        print(f"--limit {args.limit}: processing first {len(todo)} this run; rerun to continue")
    if not todo:
        return

    t_start = time.time()
    ok = fail = 0
    with ProcessPoolExecutor(max_workers=args.workers) as ex:
        futures = {ex.submit(convert_one, str(p), args.skip_large): p for p in todo}
        for i, fut in enumerate(as_completed(futures), 1):
            r = fut.result()
            tag = "OK " if r["ok"] else "ERR"
            extra = f" {r.get('chars', 0)} chars" if r["ok"] else f" ({r.get('err','')})"
            print(f"  [{i}/{len(todo)}] {tag} {r['file']} — {r['pages']}p {r['sec']}s{extra}", flush=True)
            if r["ok"]:
                ok += 1
            else:
                fail += 1
    total = round(time.time() - t_start, 1)
    print(f"\nDone. ok={ok} fail={fail} total={total}s "
          f"({round(total/max(1, len(todo)), 1)}s/manual avg)")


if __name__ == "__main__":
    main()
