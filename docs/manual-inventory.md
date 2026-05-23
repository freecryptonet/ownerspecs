# Owner-manual PDF inventory

A local PDF archive + DB inventory of every owner manual / FSM / workshop
manual we have on disk. Solves the **mid-cycle revision** problem:
the same MY can carry corrected spec values between manual revisions
(BMW LC-87 → LC-18 1/1/2019, VW 508.00 LL IV FE rev 2019, Honda Type 2
BLUE coolant rev). Citing "the 2020 Civic OM" is ambiguous when there
are 4 print revisions for that MY; citing
`Honda 2020 Civic Owner's Manual — Edition 31TBA610 (Rev C, Aug 2020), p. 432`
is not.

## Folder

```
F:/projects/ownerspecs/manuals/
```

Gitignored — PDFs are big binaries, no point versioning them in git. The
DB table `manual_inventory` is the index.

Naming is free. The scan script reads metadata directly from the PDF
title page + colophon, so you can drop PDFs in with any filename. (A
naming convention helps human browsing — `audi-a4-b9-lci-2021-en-US.pdf`
is easier to skim — but isn't required.)

## How to use

```bash
# 1) Open the MariaDB tunnel (port 3306 → VPS)
~/start-mariadb-tunnel.bat

# 2) Drop PDFs into manuals/  (subfolders are walked recursively)

# 3) Scan — incremental, only new SHA256s
npm run manuals:scan

# Dry run (parse but don't write to DB):
npm run manuals:scan:dry

# Re-parse every PDF in the folder (useful after improving heuristics):
npm run manuals:reindex
```

The script will print one line per PDF showing what it extracted:

```
manuals/audi/audi-a4-b9-lci-2021-en-US.pdf — brand=audi my=2020-2025 edition=Stand: 11.2020 pages=312
```

## Schema (mig 216)

```sql
manual_inventory (
  id, file_path, sha256 UNIQUE, manual_type ENUM('owner','service','workshop','parts','quickref','other'),
  brand, model, model_year_start, model_year_end,
  edition_code,            -- e.g. "31TBA610", "Stand: 11.2020", "OMACU01U"
  edition_label,           -- e.g. "First Printing", "Revision C"
  publication_date, language (BCP-47), region (US/EU/CA/JP/...),
  page_count, title_text, extracted_at, notes
)

-- Sources can link to a specific manual edition:
sources.manual_inventory_id INT NULL  -- FK → manual_inventory.id

-- Citations carry the page number:
spec_sources.page_number SMALLINT NULL
```

## Citing a manual in a migration

When you write a spec migration based on a PDF in the inventory:

```sql
-- 1) Find / create the sources row, pointing at the inventory row:
INSERT INTO sources (citation, manual_inventory_id, is_public, public_link, retrieved_at)
SELECT
  CONCAT(mi.brand, ' ', mi.model_year_start, ' ',
         COALESCE(mi.model,''), ' Owner''s Manual — Edition ', mi.edition_code) AS citation,
  mi.id, 1, 0, NOW()
FROM manual_inventory mi
WHERE mi.sha256 = '<sha from the scan output>';
SET @s_om := LAST_INSERT_ID();

-- 2) Cite per spec row, with the page number:
INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number) VALUES
  ('fluid_specs', <fluid_spec_id>, @s_om, 432);
```

Note `is_public=1, public_link=0` per the link-gating policy (mig 194):
manufacturer-owned manuals are first-party sources we cite by name, but
we never link to a paid/redistribute-restricted PDF.

## Edition-code heuristics

Brand-specific patterns the parser looks for. Extend `scripts/scan_manuals.ts`
when you hit a brand whose code isn't caught:

| Brand | Pattern | Example |
|---|---|---|
| Honda | `\d{2}[A-Z]{3}\d{3}[A-Z]?` | `31TBA610`, `30TVAA01` |
| Audi / VW | `Stand: MM.YYYY` | `Stand: 11.2020` |
| VW Group p/n | `NNN.NNN.NNN XX` | `8W0.012.722 EG` |
| BMW | `Bestell-Nr / Order No / Référence` | `01 40 2 985 633` |
| Toyota / Lexus | `OM[A-Z0-9]{5,8}` | `OMACU01U`, `OM33B81U` |
| Mercedes | `MYNN` | `MY24` |

If a PDF gets no `edition_code` extracted (column ends up NULL),
the SHA256 still uniquely identifies it — citations can fall back
to "`Brand YYYY Model Owner's Manual (sha:abc12345...)`" until the
heuristic is tuned.

## When to re-scan

- After adding new PDFs (incremental — only new SHA256s touched)
- After improving edition-code heuristics (`npm run manuals:reindex`)
- When auditing whether a recent OEM revision changed a spec we cite
  (look up `model + model_year_start` → multiple `edition_code` rows =
   potentially divergent specs across the print run)
