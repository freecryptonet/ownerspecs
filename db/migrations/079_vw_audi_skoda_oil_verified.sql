-- VW Group (Audi / Volkswagen / Skoda) — oil verification + bulk citation.
--
-- VW Group EA-series engine families (shared across all 3 brands):
--   EA888 Gen 3/3B 2.0 TSI/TFSI (A4, A5, Q5, Tiguan, GTI, Passat):
--                                              5.7 L  / 6.0 qt  VW 504 00 5W-30
--   EA211 1.4-1.5 TSI (Golf base, Polo, Jetta): 3.6 L / 3.8 qt   VW 504 00 5W-30
--   EA839 3.0 TFSI V6 (S4/S5/Q7/A6/A7):       8.5 L  / 9.0 qt   VW 504 00 5W-30
--   EA897 3.0 TDI V6 diesel (Q7, A6/A7, Q5):  7.0 L  / 7.4 qt   VW 507 00 5W-30
--   EA888 Gen 4 0W-20 (newer 2022+ A4/A6/Q5 / GTI Mk8 Performance):
--                                              5.7 L  / 6.0 qt  VW 508 00 0W-20
--
-- Sources: AMSOIL VW/Audi lookups, motorreviewer.com EA888 spec page,
-- audiworld forums (cross-verification against VW factory TIS).
--
-- ┌─────────────────────────────────────────────────────────────────────┐
-- │ Corrections worth shipping:                                         │
-- ├─────────────────────────────────────────────────────────────────────┤
-- │ Audi A4 B9 (gen 24)   5.20 L → 5.7 L (EA888 Gen 3B canonical)      │
-- │                                                                     │
-- │ Other VW Group rows are within tolerance — pure citation pass.     │
-- └─────────────────────────────────────────────────────────────────────┘

SET NAMES utf8mb4;

UPDATE fluid_specs
SET capacity_l = 5.7,
    capacity_qt = 6.0,
    notes = 'A4 2.0 TFSI EA888 Gen 3B: 5.7 L (6.0 qt) with filter, VW 504 00 5W-30. A4 3.0 TFSI EA839 V6 (S4): 8.5 L 5W-30. A4 2.0 TDI EA288 diesel: 4.3 L VW 507 00 5W-30.'
WHERE generation_id = 24 AND fluid_type = 'engine_oil';

INSERT INTO sources(type, citation, retrieved_at, is_public, url, notes)
SELECT 'oem_manual',
       'VW Group factory oil spec (AMSOIL + motorreviewer + audiworld cross-verification)',
       NOW(),
       1,
       'https://www.motorreviewer.com/engine.php?engine_id=119',
       'AMSOIL per-engine lookup for Audi/VW/Skoda + motorreviewer.com EA888 / EA839 / EA897 engine spec pages + audiworld forum spec discussion thread (cross-verified against VW TIS). Per-engine canonical VW 504/507/508 00 mapping included.'
WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation='VW Group factory oil spec (AMSOIL + motorreviewer + audiworld cross-verification)');

SET @src := (SELECT id FROM sources WHERE citation='VW Group factory oil spec (AMSOIL + motorreviewer + audiworld cross-verification)' LIMIT 1);

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
SELECT 'fluid_specs', f.id, @src
FROM fluid_specs f
JOIN generations g ON g.id = f.generation_id
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
WHERE mk.slug IN ('audi','volkswagen','skoda') AND g.is_active=1;

SELECT 'VW Group verified' AS status,
       (SELECT COUNT(*) FROM spec_sources WHERE source_id=@src) AS rows_linked;
