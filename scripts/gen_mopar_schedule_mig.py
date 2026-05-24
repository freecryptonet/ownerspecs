#!/usr/bin/env python3
"""Generate mig 364 — insert maintenance-schedule data from Mopar for 5 Stellantis gens.

Reads scripts/mopar_schedules.json (scraped 2026-05-25), maps Mopar action text → service slug,
computes interval from checkmarks, and emits INSERT INTO service_intervals SQL.

Inspection-only items (CV joints, suspension visual check, brake linings, parking brake) skipped —
they're generic and duplicate existing inspection rows. Focus on real replace/change/flush actions.
"""
import json
import os
import re
import sys

# Mopar gen_id → existing source row id from mig 363
SOURCE_BY_GEN = {
    86:  862,   # Pacifica RU
    122: 860,   # Charger LD
    69:  858,   # Grand Cherokee WL
    37:  864,   # Wrangler JL
    43:  861,   # Ram 1500 DT
}

# Action text patterns → (service_slug, skip?)
# Order matters — first match wins.
MAPPINGS = [
    # SKIP inspection-only items (already covered by existing inspection rows)
    (re.compile(r"^Inspect (the )?CV", re.I), None),
    (re.compile(r"Inspect front suspension", re.I), None),
    (re.compile(r"Inspect (the )?brake linings", re.I), None),
    (re.compile(r"^Adjust park", re.I), None),
    (re.compile(r"Inspect (the )?front and rear axle (fluid|surfaces)", re.I), None),
    (re.compile(r"^Inspect transfer case fluid\b", re.I), None),
    (re.compile(r"^Inspect (the )?front accessory drive tensioner", re.I), None),
    (re.compile(r"^Inspect accessory drive belt tensioner", re.I), None),
    (re.compile(r"Inspect and replace PCV", re.I), "pcv_valve"),
    # KEEP real replaceable services
    (re.compile(r"^Replace (engine )?air (cleaner|filter)", re.I), "engine_air_filter"),
    (re.compile(r"^Replace (the )?(cabin|air conditioning)/?(cabin|air conditioning)?( air)? filter", re.I), "cabin_filter"),
    (re.compile(r"Replace .*spark.*plug", re.I), "spark_plugs"),
    (re.compile(r"Flush and replace the engine.*coolant", re.I), "coolant_flush"),
    (re.compile(r"Replace .*PCV valve", re.I), "pcv_valve"),
    (re.compile(r"Replace .*(accessory )?drive belt", re.I), "drive_belt"),
    (re.compile(r"Change the manual transmission fluid", re.I), "transmission_mt"),
    (re.compile(r"Change .*transfer case fluid", re.I), "transfer_case"),
    (re.compile(r"Change .*axle fluid", re.I), "axle_fluid_change"),
    (re.compile(r"replace the Evaporative System Fresh Air Filter", re.I), "evap_fresh_air_filter"),
    (re.compile(r"replace accessory drive belt with", re.I), "drive_belt"),
]


def map_action(text):
    for rx, slug in MAPPINGS:
        if rx.search(text):
            return slug
    return None


def compute_interval(checked):
    """Given a sorted list of milestone-mileages with checkmarks, return (miles_normal, interval).
    Returns (None, None) if not parseable.
    """
    if not checked:
        return None, None
    checked = sorted(checked)
    first = checked[0]
    if len(checked) == 1:
        return first, first
    # Compute gap; verify it's consistent (within 1k)
    gaps = [checked[i+1] - checked[i] for i in range(len(checked) - 1)]
    if all(abs(g - gaps[0]) < 1000 for g in gaps):
        return first, gaps[0]
    # Irregular — use first checkpoint only as "miles_normal"
    return first, None


def km(mi):
    """Approx mile-to-km conversion (1.609)."""
    return None if mi is None else int(round(mi * 1.609344))


def sql_quote(s):
    return "'" + s.replace("\\", "\\\\").replace("'", "''") + "'"


def main():
    path = sys.argv[1] if len(sys.argv) > 1 else os.path.join(os.path.dirname(__file__), 'mopar_schedules.json')
    data = json.load(open(path, encoding='utf-8'))

    print("-- mig 364: maintenance-schedule data from Mopar.com for 5 Stellantis gens")
    print("-- Scraped 2026-05-25 from www.mopar.com/en-us/my-vehicle/maintenance-schedule.html")
    print("-- Inspection-only items skipped (already covered by existing rows). Real replace/change/flush only.")
    print()

    insert_rows = []  # list of dicts to insert
    citation_rows = []

    for sched in data['schedules']:
        gen_id = sched['gen_id']
        source_id = SOURCE_BY_GEN.get(gen_id)
        print(f"-- gen {gen_id} ({sched['label']})")
        for row in sched['rows']:
            slug = map_action(row['action'])
            if slug is None:
                continue
            first, interval = compute_interval(row['checked'])
            if first is None:
                continue
            is_severe = row.get('severe', False)
            note = row['action']
            # Truncate to 255
            note = (note[:252] + '...') if len(note) > 255 else note
            row_d = {
                'gen_id': gen_id,
                'service': slug,
                'miles_normal': first if not is_severe else None,
                'miles_severe': first if is_severe else None,
                'km_normal': km(first) if not is_severe else None,
                'km_severe': km(first) if is_severe else None,
                'notes': note,
                'source_id': source_id,
            }
            insert_rows.append(row_d)
            print(f"--   {slug:30s} {'severe' if is_severe else 'normal'} @{first}mi  ({note[:60]})")

    print()
    print("INSERT INTO service_intervals")
    print("  (generation_id, service, miles_normal, miles_severe, km_normal, km_severe, notes)")
    print("VALUES")
    rows_sql = []
    for r in insert_rows:
        mn = 'NULL' if r['miles_normal'] is None else str(r['miles_normal'])
        ms = 'NULL' if r['miles_severe'] is None else str(r['miles_severe'])
        kn = 'NULL' if r['km_normal'] is None else str(r['km_normal'])
        ks = 'NULL' if r['km_severe'] is None else str(r['km_severe'])
        rows_sql.append(f"  ({r['gen_id']}, {sql_quote(r['service'])}, {mn}, {ms}, {kn}, {ks}, {sql_quote(r['notes'])})")
    print(',\n'.join(rows_sql) + ';')
    print()
    # Cite each gen's set with its Mopar source
    # Need to grab the IDs of just-inserted rows. Use a JOIN-by-notes trick.
    print("-- Cite each new row to the gen's Mopar Owner's Manual source")
    print("INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)")
    print("  SELECT 'service_intervals', si.id, CASE")
    for gen_id, src in SOURCE_BY_GEN.items():
        print(f"      WHEN si.generation_id = {gen_id} THEN {src}")
    print("    END")
    print("  FROM service_intervals si")
    print(f"  WHERE si.generation_id IN ({','.join(map(str, SOURCE_BY_GEN.keys()))})")
    print(f"    AND si.id > (SELECT MAX(id)-{len(insert_rows)+5} FROM service_intervals);")
    # The id-window trick: identify rows just inserted by being in the last N IDs.


if __name__ == "__main__":
    main()
