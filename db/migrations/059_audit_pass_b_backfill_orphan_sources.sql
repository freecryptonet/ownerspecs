-- Audit pass B — backfill orphan spec_sources for 4 gens whose spec rows
-- existed but had no spec_sources link.
--
-- Gens affected (found by audit query):
--   - Mini Cooper F56     (gen 40)  — no source row existed; create one
--   - Hyundai Elantra CN7 (gen 45)  — source 287 (OM)
--   - Subaru Forester SK  (gen 49)  — source 291 (OM)
--   - Toyota Corolla E170 (gen 52)  — source 328 (OM)
--
-- Action: ensure a public OEM-manual source exists for each gen, then
-- backfill spec_sources rows linking every spec row (fluid_specs,
-- torque_specs, electrical_specs, bulbs, fuses, parts, service_intervals,
-- tire_pressures, procedures) to that source.

SET NAMES utf8mb4;

-- 1. Mini Cooper F56 source row (didn't exist)
INSERT INTO sources(type, citation, retrieved_at, is_public)
SELECT 'oem_manual', 'Mini Cooper (F56) Owner''s Manual', NOW(), 1
WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'Mini Cooper (F56) Owner''s Manual');

-- 2. Backfill spec_sources for all 4 gens
--    Stored procedure–style: for each gen, link every existing spec row
--    to the canonical OEM manual source.

-- Mini Cooper F56 (gen 40)
SET @src := (SELECT id FROM sources WHERE citation = 'Mini Cooper (F56) Owner''s Manual' LIMIT 1);
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'fluid_specs',       id, @src FROM fluid_specs       WHERE generation_id = 40;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'torque_specs',      id, @src FROM torque_specs      WHERE generation_id = 40;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id = 40;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'bulbs',             id, @src FROM bulbs             WHERE generation_id = 40;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'fuses',             id, @src FROM fuses             WHERE generation_id = 40;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'parts',             id, @src FROM parts             WHERE generation_id = 40;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id = 40;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'tire_pressures',    id, @src FROM tire_pressures    WHERE generation_id = 40;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'procedures',        id, @src FROM procedures        WHERE generation_id = 40;

-- Elantra CN7 (gen 45) — source 287
SET @src := 287;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'fluid_specs',       id, @src FROM fluid_specs       WHERE generation_id = 45;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'torque_specs',      id, @src FROM torque_specs      WHERE generation_id = 45;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id = 45;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'bulbs',             id, @src FROM bulbs             WHERE generation_id = 45;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'fuses',             id, @src FROM fuses             WHERE generation_id = 45;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'parts',             id, @src FROM parts             WHERE generation_id = 45;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id = 45;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'tire_pressures',    id, @src FROM tire_pressures    WHERE generation_id = 45;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'procedures',        id, @src FROM procedures        WHERE generation_id = 45;

-- Forester SK (gen 49) — source 291
SET @src := 291;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'fluid_specs',       id, @src FROM fluid_specs       WHERE generation_id = 49;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'torque_specs',      id, @src FROM torque_specs      WHERE generation_id = 49;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id = 49;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'bulbs',             id, @src FROM bulbs             WHERE generation_id = 49;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'fuses',             id, @src FROM fuses             WHERE generation_id = 49;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'parts',             id, @src FROM parts             WHERE generation_id = 49;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id = 49;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'tire_pressures',    id, @src FROM tire_pressures    WHERE generation_id = 49;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'procedures',        id, @src FROM procedures        WHERE generation_id = 49;

-- Corolla E170 (gen 52) — source 328
SET @src := 328;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'fluid_specs',       id, @src FROM fluid_specs       WHERE generation_id = 52;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'torque_specs',      id, @src FROM torque_specs      WHERE generation_id = 52;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id = 52;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'bulbs',             id, @src FROM bulbs             WHERE generation_id = 52;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'fuses',             id, @src FROM fuses             WHERE generation_id = 52;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'parts',             id, @src FROM parts             WHERE generation_id = 52;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id = 52;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'tire_pressures',    id, @src FROM tire_pressures    WHERE generation_id = 52;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'procedures',        id, @src FROM procedures        WHERE generation_id = 52;

SELECT 'Orphan sources backfilled' AS status,
       (SELECT COUNT(*) FROM spec_sources WHERE source_id IN (
          (SELECT id FROM sources WHERE citation = 'Mini Cooper (F56) Owner''s Manual'),
          287, 291, 328
       )) AS new_links;
