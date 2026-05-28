#!/usr/bin/env python3
"""manual_query.py — fast Claude-friendly lookup into the manuals corpus.

After convert_manuals.py + detect_sections.py have populated
manual_inventory.md_path / section_map, this script answers the questions
Claude actually asks during a moat fill:

    # which manuals do we have for a brand/model?
    manual_query.py list bmw 5-series
    manual_query.py list --brand audi
    manual_query.py list --year 2019

    # what section of a manual covers oil capacity?
    manual_query.py show <manual_id_or_filename> fluids
    manual_query.py show Gebruikershandleiding_Baleno_2018.md torques
    manual_query.py show 42 maintenance

    # text-search across the corpus (returns manual + page + context)
    manual_query.py grep "75 ft-lb" --brand suzuki
    manual_query.py grep "5W-30" --topic fluids

Outputs are designed for the Bash tool: terse multi-line text. Page numbers
correspond to the PDF (1-based). Use --json to get a parseable structure.

Reads .env.local for DB creds; falls back to the MariaDB tunnel
~/start-mariadb-tunnel.bat (127.0.0.1:3306) when running locally.
"""
from __future__ import annotations

import argparse
import json
import os
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

# Lazy DB import so `manual_query.py grep` over local files still works without
# the tunnel up.
def get_conn():
    import mysql.connector  # type: ignore
    from dotenv import load_dotenv  # type: ignore
    load_dotenv(ROOT / ".env.local")
    return mysql.connector.connect(
        host=os.environ.get("DB_HOST", "127.0.0.1"),
        port=int(os.environ.get("DB_PORT", "3306")),
        user=os.environ["DB_USER"],
        password=os.environ["DB_PASSWORD"],
        database=os.environ["DB_NAME"],
    )


PAGE_RE = re.compile(r"^<!--PAGE (\d+)-->$")


def slice_md(md_text: str, start: int, end: int) -> str:
    """Return only the lines covering pages [start, end] (1-based, inclusive)."""
    keep: list[str] = []
    cur = 0
    inside = False
    for line in md_text.splitlines():
        m = PAGE_RE.match(line)
        if m:
            cur = int(m.group(1))
            inside = start <= cur <= end
            if inside:
                keep.append(line)
            continue
        if inside:
            keep.append(line)
    return "\n".join(keep)


def resolve_manual(ident: str) -> dict | None:
    """Find a manual_inventory row by id, file_path basename, or md_path basename."""
    conn = get_conn(); cur = conn.cursor(dictionary=True)
    if ident.isdigit():
        cur.execute("SELECT * FROM manual_inventory WHERE id=%s", (int(ident),))
    else:
        # Match basename of either pdf or md. Strip extension so users can pass
        # 'BMW_X7_G07_2019_OwnersManual' or '.pdf'/'.md' suffix interchangeably.
        stem = ident.rsplit(".", 1)[0] if ident.endswith((".pdf", ".md")) else ident
        like = f"%{stem}%"
        cur.execute(
            "SELECT * FROM manual_inventory WHERE file_path LIKE %s OR md_path LIKE %s LIMIT 1",
            (like, like),
        )
    row = cur.fetchone()
    cur.close(); conn.close()
    return row


def cmd_list(args) -> int:
    conn = get_conn(); cur = conn.cursor(dictionary=True)
    where: list[str] = []
    params: list = []
    if args.brand:
        where.append("brand = %s")
        params.append(args.brand.lower())
    if args.model:
        where.append("model LIKE %s")
        params.append(f"%{args.model}%")
    if args.year:
        where.append("%s BETWEEN COALESCE(model_year_start, 1900) AND COALESCE(model_year_end, 2099)")
        params.append(args.year)
    sql = "SELECT id, brand, model, model_year_start, model_year_end, page_count, md_path, JSON_LENGTH(section_map) AS sections FROM manual_inventory"
    if where:
        sql += " WHERE " + " AND ".join(where)
    sql += " ORDER BY brand, model, model_year_start LIMIT 50"
    cur.execute(sql, params)
    rows = cur.fetchall()
    cur.close(); conn.close()
    if args.json:
        print(json.dumps(rows, default=str, indent=2))
        return 0
    if not rows:
        print("(no matching manuals)")
        return 0
    for r in rows:
        yr = f"{r['model_year_start'] or '?'}-{r['model_year_end'] or '?'}"
        md = "md" if r["md_path"] else "--"
        secs = r.get("sections") or 0
        brand = r["brand"] or "?"
        model = r["model"] or "?"
        pages = str(r["page_count"]) if r["page_count"] else "?"
        print(f"  [{r['id']:>3}] {brand:>14} {model:<22} {yr:>9}  {pages:>5}p  {md} sec={secs}")
    return 0


def cmd_show(args) -> int:
    row = resolve_manual(args.manual)
    if not row:
        print(f"no manual matches '{args.manual}'", file=sys.stderr)
        return 1
    if not row.get("md_path"):
        print(f"manual {row['id']} ({row['file_path']}) has no markdown yet — run convert_manuals.py", file=sys.stderr)
        return 1
    md_path = ROOT / row["md_path"]
    if not md_path.exists():
        print(f"md_path missing on disk: {md_path}", file=sys.stderr)
        return 1
    smap = row.get("section_map")
    if isinstance(smap, (bytes, str)):
        try:
            smap = json.loads(smap)
        except Exception:
            smap = None
    smap = smap or {}
    if args.topic not in smap:
        print(f"section '{args.topic}' not detected in this manual. Known: {sorted(smap.keys())}", file=sys.stderr)
        return 2
    rng = smap[args.topic]
    start, end = int(rng["start"]), int(rng["end"])
    text = md_path.read_text(encoding="utf-8", errors="replace")
    sliced = slice_md(text, start, end)
    if args.json:
        print(json.dumps({"manual_id": row["id"], "file": row["file_path"], "topic": args.topic, "page_range": [start, end], "text": sliced}, default=str))
    else:
        print(f"# {row['brand']} {row['model']} {row['model_year_start']}-{row['model_year_end']} — {args.topic} pp {start}-{end}")
        print(f"# source pdf: {row['file_path']}")
        print()
        print(sliced)
    return 0


def cmd_grep(args) -> int:
    conn = get_conn(); cur = conn.cursor(dictionary=True)
    where: list[str] = ["md_path IS NOT NULL"]
    params: list = []
    if args.brand:
        where.append("brand = %s"); params.append(args.brand.lower())
    if args.model:
        where.append("model LIKE %s"); params.append(f"%{args.model}%")
    sql = "SELECT id, brand, model, file_path, md_path, section_map FROM manual_inventory WHERE " + " AND ".join(where)
    cur.execute(sql, params)
    manuals = cur.fetchall()
    cur.close(); conn.close()

    pat = re.compile(args.pattern, re.IGNORECASE)
    hits: list[dict] = []
    for m in manuals:
        md_path = ROOT / m["md_path"]
        if not md_path.exists():
            continue
        smap = m.get("section_map")
        if isinstance(smap, (bytes, str)):
            try:
                smap = json.loads(smap)
            except Exception:
                smap = None
        smap = smap or {}
        # If --topic given, only search within that section
        if args.topic:
            if args.topic not in smap:
                continue
            text = slice_md(md_path.read_text(encoding="utf-8", errors="replace"),
                            int(smap[args.topic]["start"]), int(smap[args.topic]["end"]))
        else:
            text = md_path.read_text(encoding="utf-8", errors="replace")
        cur_page = 0
        for line in text.splitlines():
            mm = PAGE_RE.match(line)
            if mm:
                cur_page = int(mm.group(1))
                continue
            if pat.search(line):
                hits.append({
                    "manual_id": m["id"],
                    "brand": m["brand"],
                    "model": m["model"],
                    "file": Path(m["file_path"]).name,
                    "page": cur_page,
                    "line": line.strip()[:200],
                })
                if len(hits) >= args.limit:
                    break
        if len(hits) >= args.limit:
            break

    if args.json:
        print(json.dumps(hits, default=str, indent=2))
        return 0
    if not hits:
        print("(no matches)")
        return 0
    for h in hits:
        brand = h["brand"] or "?"
        model = h["model"] or "?"
        print(f"  {brand}/{model:<20} {h['file']:<46} p{h['page']:>4}: {h['line']}")
    return 0


def main() -> int:
    ap = argparse.ArgumentParser(prog="manual_query")
    ap.add_argument("--json", action="store_true", help="emit JSON instead of text")
    sub = ap.add_subparsers(dest="cmd", required=True)

    p_list = sub.add_parser("list", help="list manuals matching filters")
    p_list.add_argument("brand", nargs="?", help="brand (optional positional)")
    p_list.add_argument("model", nargs="?", help="model substring (optional)")
    p_list.add_argument("--brand", dest="brand_opt")
    p_list.add_argument("--model", dest="model_opt")
    p_list.add_argument("--year", type=int)
    p_list.set_defaults(func=cmd_list)

    p_show = sub.add_parser("show", help="dump a section of a manual")
    p_show.add_argument("manual", help="manual id, pdf filename, or md filename")
    p_show.add_argument("topic", choices=["fluids", "torques", "maintenance", "fuses", "bulbs", "tire_pressures", "specifications"])
    p_show.set_defaults(func=cmd_show)

    p_grep = sub.add_parser("grep", help="text-search the corpus")
    p_grep.add_argument("pattern")
    p_grep.add_argument("--brand")
    p_grep.add_argument("--model")
    p_grep.add_argument("--topic", choices=["fluids", "torques", "maintenance", "fuses", "bulbs", "tire_pressures", "specifications"], help="restrict to this section")
    p_grep.add_argument("--limit", type=int, default=40)
    p_grep.set_defaults(func=cmd_grep)

    args = ap.parse_args()
    # Merge positional + opt brand/model
    if args.cmd == "list":
        args.brand = args.brand or args.brand_opt
        args.model = args.model or args.model_opt
    return args.func(args)


if __name__ == "__main__":
    sys.exit(main())
