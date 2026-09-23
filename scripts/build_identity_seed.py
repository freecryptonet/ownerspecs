#!/usr/bin/env python3
"""
Build the ownerspecs identity seed from kentekenfeiten's curated
approval-base -> model/generation mapping.

Input : F:\projects\kentekenfeiten\curatie\generatie-curatie.tsv (~1.6k rows)
Output: scripts/output/identity_seed.json  (makes / models / generations w/ parsed bases + trade names)

Also serves as a validation run for lib/euTypeApproval.ts: it parses every
approval base in the curatie file and reports parse success/failure stats.
The parse logic here is a faithful port of parseEuTypeApproval() — keep in sync.

DB-independent: produces the raw material to seed identity + vehicle_aliases
AFTER migration 579 is applied and generations are (re)created. Run locally.
"""
import csv
import json
import re
import os

CURATIE = r"F:\projects\kentekenfeiten\curatie\generatie-curatie.tsv"
OUT_DIR = os.path.join(os.path.dirname(__file__), "output")
OUT = os.path.join(OUT_DIR, "identity_seed.json")

APPROVAL_COUNTRIES = {
    "e1": "Germany", "e2": "France", "e3": "Italy", "e4": "Netherlands",
    "e5": "Sweden", "e6": "Belgium", "e7": "Hungary", "e8": "Czech Republic",
    "e9": "Spain", "e11": "United Kingdom", "e12": "Austria", "e13": "Luxembourg",
    "e17": "Finland", "e18": "Denmark", "e19": "Romania", "e20": "Poland",
    "e21": "Portugal", "e23": "Greece", "e24": "Ireland", "e25": "Croatia",
    "e26": "Slovenia", "e27": "Slovakia", "e28": "Belarus", "e29": "Estonia",
    "e32": "Latvia", "e34": "Bulgaria", "e36": "Lithuania", "e49": "Cyprus",
    "e50": "Malta",
}
DIRECTIVE_ERAS = [
    (re.compile(r"^70/156$"), "Pre-1998 (original EU framework directive)"),
    (re.compile(r"^98/14$"), "1998-2001 (EU Framework Directive 98/14/EC)"),
    (re.compile(r"^2001/116$"), "2001-2007 (EU Framework Directive 2001/116/EC)"),
    (re.compile(r"^2007/46$"), "2007-2020 (EU Framework Directive 2007/46/EC)"),
    (re.compile(r"^2018/858$"), "2020-present (EU Framework Regulation 2018/858)"),
]


def parse_eu_type_approval(raw):
    """Faithful port of lib/euTypeApproval.ts parseEuTypeApproval()."""
    if not raw:
        return None
    trimmed = raw.strip()
    normalized = re.sub(r"\s+", "", trimmed)
    normalized = re.sub(r"[★☆✱✳✴]", "*", normalized)
    normalized = re.sub(r"x", "*", normalized, flags=re.IGNORECASE)
    normalized = normalized.lower()
    parts = normalized.split("*")
    if len(parts) < 3:
        return None
    if not re.match(r"^e\d+$", parts[0]):
        return None
    authority = parts[0]
    directive = parts[1]
    era = next((lbl for pat, lbl in DIRECTIVE_ERAS if pat.match(directive)),
               f"Directive {directive} (era unknown)")
    sequence = parts[2]
    extension = parts[3] if len(parts) > 3 else None
    return {
        "base": f"{authority}*{directive}*{sequence}",
        "authority": authority,
        "country": APPROVAL_COUNTRIES.get(authority, "Unknown EU member state"),
        "directive": directive,
        "directive_era": era,
        "sequence": sequence,
        "extension": extension,
    }


def slugify(s):
    s = (s or "").strip().lower()
    s = s.replace("&", " en ")
    s = re.sub(r"[^a-z0-9]+", "-", s)
    return s.strip("-")


def parse_years(jaren):
    """'2012-2020' -> (2012, 2020); '2020-heden' -> (2020, None)."""
    if not jaren:
        return (None, None)
    m = re.match(r"(\d{4})\s*-\s*(\d{4}|heden|present)?", jaren.strip())
    if not m:
        return (None, None)
    start = int(m.group(1))
    end_raw = m.group(2)
    end = None if (not end_raw or end_raw in ("heden", "present")) else int(end_raw)
    return (start, end)


def main():
    makes = {}      # slug -> name
    models = {}     # (make_slug, model_slug) -> name
    generations = []
    stats = {"rows": 0, "base_tokens": 0, "parsed_ok": 0, "failed": 0, "failures": []}

    with open(CURATIE, encoding="utf-8") as f:
        reader = csv.DictReader(f, delimiter="\t")
        for row in reader:
            stats["rows"] += 1
            merk = (row.get("merk") or "").strip()
            model = (row.get("model") or "").strip()
            codename = (row.get("generatie") or "").strip()
            jaren = (row.get("jaren") or "").strip()
            base_field = (row.get("base") or "").strip()
            handels = (row.get("handelsbenaming_bevat") or "").strip()
            voertuigsoort = (row.get("voertuigsoort") or "").strip()
            aantal = (row.get("aantal") or "").strip()
            datum_van = (row.get("datum_van") or "").strip()
            datum_tot = (row.get("datum_tot") or "").strip()
            if not merk:
                continue

            make_slug = slugify(merk)
            model_slug = slugify(model) if model else ""
            makes[make_slug] = merk
            if model_slug:
                models[(make_slug, model_slug)] = model

            start_year, end_year = parse_years(jaren)

            parsed_bases = []
            for token in [b.strip() for b in base_field.split(";") if b.strip()]:
                stats["base_tokens"] += 1
                p = parse_eu_type_approval(token)
                if p:
                    stats["parsed_ok"] += 1
                    parsed_bases.append(p)
                else:
                    stats["failed"] += 1
                    if len(stats["failures"]) < 25:
                        stats["failures"].append({"row": stats["rows"], "make": merk,
                                                  "model": model, "base": token})

            trade_names = [t.strip() for t in handels.split("|") if t.strip()]

            generations.append({
                "make": merk, "make_slug": make_slug,
                "model": model, "model_slug": model_slug,
                "codename": codename,
                "start_year": start_year, "end_year": end_year, "jaren": jaren,
                "datum_van": datum_van, "datum_tot": datum_tot,
                "aantal": int(aantal) if aantal.isdigit() else None,
                "voertuigsoort": voertuigsoort,
                "bases": parsed_bases,
                "trade_names": trade_names,
            })

    out = {
        "source": "kentekenfeiten/curatie/generatie-curatie.tsv",
        "generated_note": "identity seed for ownerspecs document-first model; feeds makes/models/generations/vehicle_aliases after mig 579 applied",
        "makes": [{"slug": s, "name": n} for s, n in sorted(makes.items())],
        "models": [{"make_slug": ms, "slug": sl, "name": nm}
                   for (ms, sl), nm in sorted(models.items())],
        "generations": generations,
        "stats": stats,
    }
    os.makedirs(OUT_DIR, exist_ok=True)
    with open(OUT, "w", encoding="utf-8") as f:
        json.dump(out, f, ensure_ascii=False, indent=2)

    print(f"rows={stats['rows']} makes={len(makes)} models={len(models)} "
          f"generations={len(generations)}")
    print(f"base tokens={stats['base_tokens']} parsed_ok={stats['parsed_ok']} "
          f"failed={stats['failed']}")
    if stats["failures"]:
        print("sample failures:")
        for fl in stats["failures"][:10]:
            print(f"  row {fl['row']}: {fl['make']} {fl['model']} -> '{fl['base']}'")
    print(f"wrote {OUT}")


if __name__ == "__main__":
    main()
