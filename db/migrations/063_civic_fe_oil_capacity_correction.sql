-- Civic FE engine oil capacity correction + first manualslib-cited backfill.
--
-- Audit finding (2026-05-21): Our DB had 3.6 qt / 3.4 L for the 1.5L L15CA
-- Civic FE engine oil capacity, but cross-checking the Honda OM via manualslib
-- (page 668 of the 2022 Civic Sedan OM, "Engine Oil Refill Capacity" table):
--
--   1.5L engine: 3.7 US qt (3.5 L) — with filter change
--   2.0L engine: 4.4 US qt (4.2 L) — with filter change
--
-- Independently confirmed by engineoildb.com which cites Honda spec sheets:
-- "1.5T (L15B7 / L15BY / L15CA): With Filter 3.7 quarts, Without Filter 3.4 quarts."
--
-- Note: page 753 of the same OM (Specifications appendix) lists "3.4 US qt"
-- — that's the drain-refill value (filter not replaced). The 3.7 qt / 3.5 L
-- value is what an owner actually pours in during a routine oil + filter
-- service, which is what we publish.
--
-- Cross-check matrix:
--                           OURS    Honda OM p.668   engineoildb     Final
--   capacity_qt (with filt) 3.60    3.7              3.7             3.7
--   capacity_l  (with filt) 3.40    3.5              ~3.5            3.5
--   viscosity               0W-20   0W-20            0W-20           0W-20
--   filter PN               15400-PLM-A02            15400-PLM-A02   15400-PLM-A02

SET NAMES utf8mb4;

UPDATE fluid_specs
SET capacity_qt = 3.7,
    capacity_l  = 3.5,
    notes = '1.5T L15CA: 3.7 US qt / 3.5 L with filter (Honda OM p.668). 2.0L L20A: 4.4 US qt / 4.2 L (Honda OM p.668). Type R FL5 2.0T: 4.3 qt 0W-30 (separate OM).'
WHERE generation_id = 50
  AND fluid_type = 'engine_oil';

-- Register manualslib as a 2nd public source for Civic FE
INSERT INTO sources(type, citation, retrieved_at, is_public, url, notes)
SELECT 'oem_manual',
       'Honda Civic Sedan 2022 Owner''s Manual (via manualslib, p.668)',
       NOW(),
       1,
       'https://www.manualslib.com/manual/3273373/Honda-Civic-Sedan-2022.html?page=668',
       'Engine Oil Refill Capacity table: 1.5L 3.7 qt / 2.0L 4.4 qt with filter change.'
WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation='Honda Civic Sedan 2022 Owner''s Manual (via manualslib, p.668)');

-- Link the corrected oil row to the manualslib source as a 2nd citation
SET @src := (SELECT id FROM sources WHERE citation='Honda Civic Sedan 2022 Owner''s Manual (via manualslib, p.668)' LIMIT 1);
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id=50 AND fluid_type='engine_oil';

SELECT 'Civic FE oil corrected' AS status,
       capacity_qt, capacity_l, viscosity, notes
FROM fluid_specs WHERE generation_id=50 AND fluid_type='engine_oil';
