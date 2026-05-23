-- mig 307 — multi-gen HaynesPro ingest: Audi Q3 (FJ)
-- crawl: haynespro-crawl-audi-q3-fj-2026-05-23.json
-- modelId: d_319023857
-- 3 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Audi Q3 (FJ)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319023857', NOW(), 'Multi-gen ingest, 3 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319023857' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('DXDB', '1.5 eTFSI (DXDB) 110kW', 1498, 'petrol', 'turbo', NULL),
  ('DXPA', '2.0 TDI (DXPA) 110kW', 1968, 'diesel', 'turbo', NULL),
  ('DNPB', '2.0 TFSI (DNPB) 195kW', 1984, 'petrol', 'turbo', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 282, 'engine_oil', (SELECT id FROM engines WHERE code = 'DXDB'), 4.3, 4.54, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619151993; 1.5 eTFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 282 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DXDB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 282, 'coolant', (SELECT id FROM engines WHERE code = 'DXDB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619151993; 1.5 eTFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 282 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DXDB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 282, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DXDB'), 7.4, 7.82, NULL, NULL, 'HaynesPro typeId t_619151993; 1.5 eTFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 282 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DXDB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 282, 'engine_oil', (SELECT id FROM engines WHERE code = 'DXPA'), NULL, NULL, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619151994; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 282 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DXPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 282, 'coolant', (SELECT id FROM engines WHERE code = 'DXPA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619151994; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 282 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DXPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 282, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DXPA'), 7.4, 7.82, NULL, NULL, 'HaynesPro typeId t_619151994; 2.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 282 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DXPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 282, 'engine_oil', (SELECT id FROM engines WHERE code = 'DNPB'), NULL, NULL, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619151992; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 282 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DNPB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 282, 'coolant', (SELECT id FROM engines WHERE code = 'DNPB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619151992; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 282 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DNPB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 282, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DNPB'), 7.4, 7.82, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619151992; 2.0 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 282 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DNPB'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 282, 'brake_fluid', NULL, 1, 1.06, NULL, 'VW 501 14', 'HaynesPro chassis d_319023857; Alt: DOT 4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 282 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (282)
  AND e.code IN ('DXDB', 'DXPA', 'DNPB')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (282)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (282) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;