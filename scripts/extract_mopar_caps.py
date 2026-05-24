#!/usr/bin/env python3
"""Extract FLUID CAPACITIES tables from Mopar OEM owner-manual PDFs.

Uses pypdf's visitor_text API to capture text fragments with x/y coordinates,
then groups by Y bucket to reconstruct the table rows. Handles multi-page tables
by walking pages until "FLUID CAPACITIES" disappears or next major section begins.

Output: JSON file with per-gen fluid + tire pressure data.
"""
import json
import os
import re
import sys
from collections import defaultdict

import pypdf

PDFS = [
    {"gen_id": 124, "label": "Chrysler 300 LX 2008",        "file": "Chrysler_300_LX_2008_OM_Mopar.pdf"},
    {"gen_id": 86,  "label": "Chrysler Pacifica RU 2020",   "file": "Chrysler_Pacifica_RU_2020_OM_Mopar.pdf"},
    {"gen_id": 123, "label": "Dodge Charger LX 2008",       "file": "Dodge_Charger_LX_2008_OM_Mopar.pdf"},
    {"gen_id": 122, "label": "Dodge Charger LD 2017",       "file": "Dodge_Charger_LD_2017_OM_Mopar.pdf"},
    {"gen_id": 69,  "label": "Jeep Grand Cherokee WL 2023", "file": "Jeep_GrandCherokee_WL_2023_OM_Mopar.pdf"},
    {"gen_id": 37,  "label": "Jeep Wrangler JL 2020",       "file": "Jeep_Wrangler_JL_2020_OM_Mopar.pdf"},
    {"gen_id": 43,  "label": "Ram 1500 DT 2022",            "file": "Ram_1500_DT_2022_OM_Mopar.pdf"},
]


def extract_page_lines(page):
    """Return list of (y, text) tuples per text line, top-down."""
    fragments = []
    def visitor(text, cm, tm, fd, fs):
        x, y = tm[4], tm[5]
        if text and text.strip():
            fragments.append((round(y, 1), round(x, 1), text.strip()))
    page.extract_text(visitor_text=visitor)
    rows = defaultdict(list)
    for y, x, t in fragments:
        yk = round(y / 8) * 8
        rows[yk].append((x, t))
    out = []
    for yk in sorted(rows.keys(), reverse=True):
        cells = sorted(rows[yk])
        line = ' '.join(t for _, t in cells)
        out.append((yk, line))
    return out


def find_fluid_pages(reader):
    """Find pages containing 'FLUID CAPACITIES' header (typically the spec section, not TOC)."""
    matches = []
    for i, page in enumerate(reader.pages):
        text = (page.extract_text() or '').upper()
        if 'FLUID CAPACITIES' in text:
            matches.append(i)
    return matches


def main():
    src_dir = sys.argv[1] if len(sys.argv) > 1 else r'C:\Users\Z620\AppData\Local\Temp\mopar_pdfs'
    out = []
    for spec in PDFS:
        path = os.path.join(src_dir, spec['file'])
        if not os.path.exists(path):
            print(f"SKIP {spec['file']}: not found", file=sys.stderr)
            continue
        r = pypdf.PdfReader(path)
        cap_pages = find_fluid_pages(r)
        # Skip TOC pages: assume the main section is the page that has BOTH "FLUID CAPACITIES" and a capacity row (e.g. "Gallons" or "Liters")
        spec_pages = []
        for pidx in cap_pages:
            text = r.pages[pidx].extract_text() or ''
            if re.search(r"\d+\s*(Gallons|Liters|Quarts)", text):
                spec_pages.append(pidx)
        if not spec_pages:
            spec_pages = cap_pages[1:2] if len(cap_pages) > 1 else cap_pages[:1]
        # Extract lines from spec pages
        all_lines = []
        for pidx in spec_pages[:3]:  # cap at 3 pages
            lines = extract_page_lines(r.pages[pidx])
            for y, line in lines:
                all_lines.append({"page": pidx + 1, "y": y, "text": line})
        out.append({
            "gen_id": spec["gen_id"],
            "label": spec["label"],
            "spec_pages": [p + 1 for p in spec_pages],
            "lines": all_lines,
        })
        print(f"OK {spec['label']}: pages {spec_pages}, {len(all_lines)} lines extracted", file=sys.stderr)
    print(json.dumps(out, indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
