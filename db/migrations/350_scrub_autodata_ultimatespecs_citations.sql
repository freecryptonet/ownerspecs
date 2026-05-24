-- mig 350 — scrub the 29 public 'Auto-Data.net' / 'Ultimatespecs.com'
-- citations missed by mig 346, plus 2 fluid_specs.notes + 1 sources.notes
-- vendor mentions. Surfaced 2026-05-24 during the live UI/UX audit on
-- /bmw/3-series-sedan-g20-2019-2022 (Sources block rendered the vendor
-- names verbatim) and /bmw/5-series-g30-sedan-2017-2020.
--
-- Approach (option A — clean merge, not in-place rename):
--   1. 13 of the 29 sources have ZERO spec_sources cites (orphans left
--      behind from a family-pull batch) -> DELETE.
--   2. The remaining 16 cluster naturally into 5 chassis families
--      (F30/F31, G20/G21, G30/G31, G60/G61, BMW M3/M5 lineage) plus
--      8 standalone M-variants. For each family, pick the canonical
--      keeper (the source with the widest spec_sources coverage),
--      repoint the family's spec_sources rows to that keeper via
--      INSERT IGNORE (the uk on spec_sources auto-dedupes), then
--      DELETE the loser sources + their now-orphaned spec_sources rows.
--   3. RENAME each remaining keeper to a vendor-neutral
--      'Manufacturer catalogue — <chassis>' label. The Sources block
--      still tells the reader 'this came from the manufacturer's
--      published spec catalogue' without naming the aggregator.
--   4. fluid_specs.notes -> strip vendor mention, keep the chemistry note.
--   5. sources.notes (id 592) -> strip vendor mention from internal note.

SET NAMES utf8mb4;

START TRANSACTION;

-- ---------------------------------------------------------------------------
-- STEP 1: drop the 13 orphan vendor sources (zero spec_sources cites)
-- ---------------------------------------------------------------------------
-- Verified via:
--   SELECT s.id FROM sources s LEFT JOIN spec_sources ss ON ss.source_id=s.id
--   WHERE s.is_public=1 AND s.citation REGEXP 'auto.?data|ultimatespecs'
--   GROUP BY s.id HAVING COUNT(ss.source_id)=0;

DELETE FROM sources WHERE id IN (666, 669, 670, 671, 672, 673, 674, 675, 684, 685, 686)
  AND is_public = 1
  AND citation REGEXP 'auto.?data|ultimatespecs';

-- ---------------------------------------------------------------------------
-- STEP 2 — Family merges. Pattern per family:
--   a) INSERT IGNORE INTO spec_sources (...) SELECT ... FROM spec_sources WHERE source_id IN (losers)
--      -- repoints loser cites onto keeper; uk dedupes silently
--   b) DELETE FROM spec_sources WHERE source_id IN (losers)
--   c) DELETE FROM sources WHERE id IN (losers)
-- ---------------------------------------------------------------------------

-- F30/F31 family — keep 627 (Ultimatespecs, widest: 4 gens), merge 626 + 630
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT spec_table, spec_id, 627 FROM spec_sources WHERE source_id IN (626, 630);
DELETE FROM spec_sources WHERE source_id IN (626, 630);
DELETE FROM sources WHERE id IN (626, 630);

-- G20/G21 family — keep 629 (Ultimatespecs, widest: 4 gens), merge 628 + 649
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT spec_table, spec_id, 629 FROM spec_sources WHERE source_id IN (628, 649);
DELETE FROM spec_sources WHERE source_id IN (628, 649);
DELETE FROM sources WHERE id IN (628, 649);

-- G30/G31 family — keep 653 (Ultimatespecs, widest: 4 gens), merge 652 + 657
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT spec_table, spec_id, 653 FROM spec_sources WHERE source_id IN (652, 657);
DELETE FROM spec_sources WHERE source_id IN (652, 657);
DELETE FROM sources WHERE id IN (652, 657);

-- G60/G61 family — only 662 has cites in this family (666/671 already gone in step 1)

-- ---------------------------------------------------------------------------
-- STEP 3 — Rename remaining keepers to vendor-neutral labels.
-- ---------------------------------------------------------------------------

UPDATE sources SET citation = 'Manufacturer catalogue — BMW 3 Series F30/F31 (2012-2019)' WHERE id = 627;
UPDATE sources SET citation = 'Manufacturer catalogue — BMW 3 Series G20/G21 (2019-present)' WHERE id = 629;
UPDATE sources SET citation = 'Manufacturer catalogue — BMW 5 Series G30/G31 (2017-2024)' WHERE id = 653;
UPDATE sources SET citation = 'Manufacturer catalogue — BMW 5 Series G60/G61 (2023-present)' WHERE id = 662;
UPDATE sources SET citation = 'Manufacturer catalogue — BMW M3 (F80) 2014-2018'              WHERE id = 676;
UPDATE sources SET citation = 'Manufacturer catalogue — BMW M3 (G80) 2020-2024'              WHERE id = 677;
UPDATE sources SET citation = 'Manufacturer catalogue — BMW M3 (G80 LCI) 2024-present'       WHERE id = 678;
UPDATE sources SET citation = 'Manufacturer catalogue — BMW M3 Touring (G81) 2022-2024'      WHERE id = 679;
UPDATE sources SET citation = 'Manufacturer catalogue — BMW M3 Touring (G81 LCI) 2024-present' WHERE id = 680;
UPDATE sources SET citation = 'Manufacturer catalogue — BMW M5 (F90) 2018-2023'              WHERE id = 681;
UPDATE sources SET citation = 'Manufacturer catalogue — BMW M5 (G90) 2024-present'           WHERE id = 682;
UPDATE sources SET citation = 'Manufacturer catalogue — BMW M5 Touring (G99) 2024-present'   WHERE id = 683;

-- ---------------------------------------------------------------------------
-- STEP 4 — fluid_specs.notes vendor mention -> rewritten chemistry note.
-- ---------------------------------------------------------------------------

UPDATE fluid_specs
SET notes = 'OEM manual specifies BMW-approved long-life coolant only.'
WHERE id IN (1634, 1867)
  AND notes LIKE '%uto-data%';

-- ---------------------------------------------------------------------------
-- STEP 5 — sources.notes (id 592) vendor mention -> sanitised internal note.
-- ---------------------------------------------------------------------------

UPDATE sources
SET notes = 'Cross-verified against Wikipedia for length/width/height/wheelbase. Fuel tank cross-verified.'
WHERE id = 592
  AND notes LIKE '%uto-data%';

-- ---------------------------------------------------------------------------
-- POST-CHECK — should all return 0
-- ---------------------------------------------------------------------------

SELECT 'leftover sources.citation (public)' col, COUNT(*) n
  FROM sources WHERE is_public=1
    AND citation REGEXP 'auto.?data|ultimatespecs|haynespro|workshopdata|startmycar'
UNION ALL
SELECT 'leftover sources.notes (public)', COUNT(*)
  FROM sources WHERE is_public=1
    AND notes REGEXP 'auto.?data|ultimatespecs|haynespro|workshopdata|startmycar'
UNION ALL
SELECT 'leftover fluid_specs.notes', COUNT(*)
  FROM fluid_specs
  WHERE notes REGEXP 'auto.?data|ultimatespecs|haynespro|workshopdata|startmycar'
UNION ALL
SELECT 'spec_sources orphans (source_id missing)', COUNT(*)
  FROM spec_sources ss LEFT JOIN sources s ON s.id = ss.source_id
  WHERE s.id IS NULL;

COMMIT;
