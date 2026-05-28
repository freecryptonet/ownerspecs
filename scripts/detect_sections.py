#!/usr/bin/env python3
"""detect_sections.py — scan converted .md files for moat-relevant sections.

Reads each manuals/*.md, finds the page ranges where the following sections
live, and writes the result into manual_inventory.section_map:

    fluids          — engine oil / coolant / fluid capacities
    torques         — torque spec tables
    maintenance     — maintenance / service schedule
    fuses           — fuse box layout
    bulbs           — bulb specifications
    tire_pressures  — placard / pressure recommendations
    specifications  — back-of-book technical data summary

Multilingual heuristic (en/nl/de/fr/es). Conservative: better to over-report
the page window than miss the section — downstream queries grep within the
window anyway.

Heuristic:
1. Walk the markdown line by line, tracking the current page via the
   '<!--PAGE n-->' markers convert_manuals.py emits.
2. On every line, check whether it's a heading (starts with '#' or a bold
   '**...**' line) AND its lowercased text contains a section keyword.
3. If multiple matches fire close together (within MAX_GAP pages), merge them
   into one range. Final range = [first_match - 1, last_match + WINDOW].
4. Ignore matches that look like TOC entries (line ends with a page number
   like '... 7-23').

Usage:
    python scripts/detect_sections.py                    # scans all .md, writes JSON to stdout
    python scripts/detect_sections.py --write-db         # also UPDATE manual_inventory.section_map
    python scripts/detect_sections.py --only foo.md      # one file
"""
from __future__ import annotations

import argparse
import json
import os
import re
import sys
from pathlib import Path
from typing import Iterable

ROOT = Path(__file__).resolve().parent.parent
MANUALS_DIR = ROOT / "manuals"

# How far apart two matches can be before we treat them as separate sections.
# A typical OM has the same keyword in the TOC AND in the actual section ~200
# pages apart, so we merge clusters that are within ~30 pages.
MAX_GAP = 80
# After the last keyword match, how many additional pages we include in the
# range to capture the rest of the section body.
WINDOW = 10

PAGE_RE = re.compile(r"^<!--PAGE (\d+)-->$")
TOC_TAIL_RE = re.compile(r"\b\d+\s*[-–]\s*\d+\s*$")  # 'something 7-23' = TOC line
HEADING_RE = re.compile(r"^\s*(#{1,4}\s+|\*\*[^*]+\*\*\s*$)")

# Section keyword patterns. All matched case-insensitively as substrings of the
# heading line. Add languages as we encounter them.
SECTIONS: dict[str, list[str]] = {
    "fluids": [
        "fluid capacit", "fluid capacity", "capacities and recommended",
        "recommended fluid", "engine oil and", "engine oil specification",
        "adding engine oil", "topping up engine oil",
        "vulhoeveelheid", "vloeistoffen", "vloeistofcapaciteit",
        "aanbevolen vloeistof", "aanbevolen brandstof",
        "betriebsstoffe", "fullmengen", "fuellmengen", "füllmengen",
        "auffüllmenge", "auffüllmengen", "motoröl nachfüllen",
        "capacités et", "capacités de remplissage", "liquides",
        "capacidades", "líquidos recomendados",
    ],
    "torques": [
        "torque spec", "tightening torque", "torque value",
        "anziehdrehmoment", "drehmoment",
        "aandraaikoppel", "aanhaalmoment",
        "couple de serrage", "couples de serrage",
        "par de apriete",
    ],
    "maintenance": [
        "maintenance schedule", "service schedule", "scheduled maintenance",
        "periodic maintenance", "maintenance under severe",
        "service requirements", "service indicator",
        "onderhoudsschema", "onderhoud onder", "periodiek onderhoud",
        "schema voor periodiek onderhoud",
        "wartungsplan", "wartungsarbeiten", "inspektions",
        "plan d'entretien", "entretien périodique",
        "plan de mantenimiento", "mantenimiento periódico",
    ],
    "fuses": [
        "fuse box", "fuse panel", "fuse identification", "fuses (",
        "replacing fuses", "fuse assignment", "fuse rating",
        "zekeringen", "zekeringkast", "zekeringschema",
        "sicherung", "sicherungen", "sicherungsbelegung",
        "boîte à fusibles", "fusibles",
        "caja de fusibles",
    ],
    "bulbs": [
        "bulb specification", "bulb chart", "replacement bulb",
        "een bolletje vervangen", "lampen vervang", "gloeilampen",
        "leuchtmittel", "lampenwechsel", "glühlampen",
        "ampoules", "remplacement des ampoules",
        "bombillas",
    ],
    "tire_pressures": [
        "tire pressure", "tyre pressure", "tire and loading",
        "tire inflation pressure", "tyre inflation pressure",
        "bandenspann", "bandenspanning",
        "reifendruck", "reifenfülldruck",
        "pression des pneus", "pression de gonflage",
        "presión de los neumáticos",
    ],
    "specifications": [
        "technical data", "specifications", "vehicle specifications",
        "technische gegevens", "specificaties",
        "technische daten",
        "caractéristiques techniques", "données techniques",
        "características técnicas", "datos técnicos",
    ],
}


def is_heading(line: str) -> bool:
    return bool(HEADING_RE.match(line))


def looks_like_toc(line: str) -> bool:
    """TOC entries usually end in 'something  7-23' or '..... 412'."""
    s = line.rstrip()
    # Trailing 'N-MM' or dots-then-digits patterns
    if TOC_TAIL_RE.search(s):
        return True
    if re.search(r"\.{3,}\s*\d+\s*\*?\*?\s*$", s):
        return True
    return False


def heading_text(line: str) -> str:
    """Strip leading '#' / '**' markers so substring match is reliable."""
    s = line.strip()
    s = re.sub(r"^#{1,4}\s+", "", s)
    s = re.sub(r"^\*\*", "", s)
    s = re.sub(r"\*\*\s*$", "", s)
    return s.lower()


def find_matches(md_text: str) -> dict[str, list[int]]:
    """Return {section: [page_numbers_with_matching_heading]}."""
    matches: dict[str, list[int]] = {k: [] for k in SECTIONS}
    current_page = 0
    for raw in md_text.splitlines():
        m = PAGE_RE.match(raw)
        if m:
            current_page = int(m.group(1))
            continue
        if not is_heading(raw):
            continue
        if looks_like_toc(raw):
            continue
        ht = heading_text(raw)
        if not ht:
            continue
        for section, keywords in SECTIONS.items():
            for kw in keywords:
                if kw in ht:
                    matches[section].append(current_page)
                    break
    return matches


def cluster_pages(pages: list[int]) -> tuple[int, int] | None:
    """Pick the densest cluster of pages and return (start, end+WINDOW)."""
    if not pages:
        return None
    pages = sorted(set(pages))
    # Group into clusters where consecutive pages are <= MAX_GAP apart.
    clusters: list[list[int]] = [[pages[0]]]
    for p in pages[1:]:
        if p - clusters[-1][-1] <= MAX_GAP:
            clusters[-1].append(p)
        else:
            clusters.append([p])
    # Prefer the cluster with the most matches; if tied, the latest (real
    # section usually comes AFTER the TOC).
    clusters.sort(key=lambda c: (len(c), c[-1]), reverse=True)
    best = clusters[0]
    return max(1, best[0] - 1), best[-1] + WINDOW


def detect(md_path: Path) -> dict:
    text = md_path.read_text(encoding="utf-8", errors="replace")
    raw_matches = find_matches(text)
    out: dict[str, dict[str, int]] = {}
    for section, pages in raw_matches.items():
        rng = cluster_pages(pages)
        if rng:
            out[section] = {"start": rng[0], "end": rng[1]}
    return out


def iter_targets(only: str | None) -> Iterable[Path]:
    if only:
        p = MANUALS_DIR / only if not Path(only).is_absolute() else Path(only)
        if not p.exists():
            sys.exit(f"--only target not found: {p}")
        return [p]
    return sorted(MANUALS_DIR.glob("*.md"))


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--only", help="scan one .md file (name or absolute path)")
    ap.add_argument("--write-db", action="store_true",
                    help="UPDATE manual_inventory.section_map by file_path")
    ap.add_argument("--dump", action="store_true",
                    help="print the full {file: section_map} JSON to stdout")
    args = ap.parse_args()

    targets = list(iter_targets(args.only))
    if not targets:
        print("no .md files found under manuals/")
        return

    results: dict[str, dict] = {}
    for md in targets:
        smap = detect(md)
        rel = md.relative_to(ROOT).as_posix()
        results[rel] = smap
        if not args.dump:
            keys = ",".join(sorted(smap.keys())) or "(none detected)"
            print(f"  {md.name}: {keys}")

    if args.dump:
        print(json.dumps(results, indent=2))

    if args.write_db:
        try:
            import mysql.connector  # type: ignore
        except ImportError:
            sys.exit("--write-db needs mysql-connector-python in this venv")
        from dotenv import load_dotenv  # type: ignore
        import hashlib
        import pymupdf
        load_dotenv(ROOT / ".env.local")
        conn = mysql.connector.connect(
            host=os.environ["DB_HOST"], port=int(os.environ.get("DB_PORT", "3306")),
            user=os.environ["DB_USER"], password=os.environ["DB_PASSWORD"],
            database=os.environ["DB_NAME"],
        )
        cur = conn.cursor()
        updated = inserted = 0
        for rel, smap in results.items():
            pdf_rel = rel.replace(".md", ".pdf")
            cur.execute(
                "UPDATE manual_inventory SET md_path=%s, section_map=%s, md_converted_at=NOW(), md_converter=%s WHERE file_path=%s",
                (rel, json.dumps(smap) if smap else None, "pymupdf4llm", pdf_rel),
            )
            if cur.rowcount:
                updated += 1
                continue
            # Orphan PDF — insert a minimal inventory row so manual_query can find it.
            # Tim's richer scan_manuals.ts can refine brand/model/year later.
            pdf_full = ROOT / pdf_rel
            if not pdf_full.exists():
                continue
            doc = pymupdf.open(pdf_full)
            page_count = doc.page_count
            doc.close()
            sha = hashlib.sha256(pdf_full.read_bytes()).hexdigest()
            # Brand guess from filename: first underscore-separated token in lowercase
            stem = pdf_full.stem
            brand_guess = stem.split("_")[0].lower() if "_" in stem else None
            cur.execute(
                """INSERT INTO manual_inventory
                   (file_path, sha256, manual_type, brand, page_count, md_path,
                    section_map, md_converted_at, md_converter, extracted_at)
                   VALUES (%s, %s, 'owner', %s, %s, %s, %s, NOW(), 'pymupdf4llm', NOW())
                   ON DUPLICATE KEY UPDATE md_path=VALUES(md_path),
                       section_map=VALUES(section_map),
                       md_converted_at=NOW(), md_converter='pymupdf4llm'""",
                (pdf_rel, sha, brand_guess, page_count, rel,
                 json.dumps(smap) if smap else None),
            )
            inserted += 1
        conn.commit()
        cur.close(); conn.close()
        print(f"\nDB: updated={updated} stub_inserted={inserted}")


if __name__ == "__main__":
    main()
