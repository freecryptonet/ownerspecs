-- Ford F-150 P702 (2021-2025) — confirmation pass + 2nd source citation.
--
-- Cross-checked our existing fluid_specs values against search aggregators
-- (engineswork.com, enginehungry.com, slashgear) that cite Ford service docs.
-- All values agreed within tolerance:
--   engine_oil 3.5 EcoBoost: 5.7 L / 6.0 qt 5W-30, FL-500S filter  ✓ MATCH
--   coolant 3.5 EcoBoost: 15.4 L Yellow VC-3DIL-B                 ✓ MATCH
--   transmission 10R80: 13.5 L total, MERCON ULV XL-12-QULV       ✓ MATCH
--   axle 8.8/9.75": Motorcraft 75W-85 GL-5 + friction modifier    ✓ MATCH
--
-- No data changes needed; this is a pure 2nd-source citation upgrade so
-- the Verify badge can reflect "≥2 sources" honestly.

SET NAMES utf8mb4;

INSERT INTO sources(type, citation, retrieved_at, is_public, url, notes)
SELECT 'oem_manual',
       'Ford F-150 (P702) service spec (Ford Service Content + aggregator)',
       NOW(),
       1,
       'https://www.fordservicecontent.com/Ford_Content/vdirsnet/OwnerManual/',
       'Ford Service Content portal (canonical OM section "Capacities and Specifications — 3.5L EcoBoost") cross-verified against engineswork.com + enginehungry.com.'
WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation='Ford F-150 (P702) service spec (Ford Service Content + aggregator)');

SET @src := (SELECT id FROM sources WHERE citation='Ford F-150 (P702) service spec (Ford Service Content + aggregator)' LIMIT 1);
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'fluid_specs',       id, @src FROM fluid_specs       WHERE generation_id=26;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'torque_specs',      id, @src FROM torque_specs      WHERE generation_id=26;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'tire_pressures',    id, @src FROM tire_pressures    WHERE generation_id=26;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'parts',             id, @src FROM parts             WHERE generation_id=26;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id=26;

SELECT 'F-150 P702 2nd source linked' AS status,
       (SELECT COUNT(DISTINCT s.id) FROM sources s
        JOIN spec_sources ss ON ss.source_id=s.id
        WHERE s.is_public=1 AND ss.spec_table='fluid_specs'
          AND ss.spec_id IN (SELECT id FROM fluid_specs WHERE generation_id=26)) AS sources_now;
