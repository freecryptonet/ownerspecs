-- mig 268 — multi-gen HaynesPro ingest: BMW 7 (G70, i7)
-- crawl: haynespro-crawl-bmw-7-g70-2026-05-23.json
-- modelId: d_319017039
-- 7 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — BMW 7 (G70, i7)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319017039', NOW(), 'Multi-gen ingest, 7 engines across 2 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319017039' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('B57D30B', '740d xDrive mHEV (B57D30B) 220kW', 2993, 'hybrid', 'turbo', NULL),
  ('B58B30P', '740i mHEV (B58B30P) 280kW', 2998, 'hybrid', 'turbo', NULL),
  ('B58B30S', '750e xDrive (B58B30S) 360kW', 2998, 'petrol', 'turbo', NULL),
  ('S68B44A', '760i xDrive mHEV (S68B44A) 400kW', 4395, 'hybrid', 'NA', NULL),
  ('XE2', 'i7 M70 xDrive (XE2) 485kW', 0, 'petrol', 'NA', NULL),
  ('HA0004N0', 'i7 eDrive50 (HA0004N0) 335kW', 0, 'petrol', 'NA', NULL),
  ('XE2A02N0', 'i7 xDrive 60 (XE2A02N0) 400kW', 0, 'petrol', 'NA', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 205, 'engine_oil', (SELECT id FROM engines WHERE code = 'B57D30B'), 8.3, 8.77, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_619109883; 740d xDrive mHEV; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 205 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 205, 'coolant', (SELECT id FROM engines WHERE code = 'B57D30B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619109883; 740d xDrive mHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 205 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 205, 'transmission_at', (SELECT id FROM engines WHERE code = 'B57D30B'), 8, 8.45, NULL, 'BMW DTF1', 'HaynesPro typeId t_619109883; 740d xDrive mHEV; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 205 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 205, 'engine_oil', (SELECT id FROM engines WHERE code = 'B58B30P'), 6.8, 7.19, '0W-12', 'BMW Longlife-22 FE++', 'HaynesPro typeId t_619109882; 740i mHEV; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 205 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30P'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 205, 'coolant', (SELECT id FROM engines WHERE code = 'B58B30P'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619109882; 740i mHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 205 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30P'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 205, 'transmission_at', (SELECT id FROM engines WHERE code = 'B58B30P'), 8, 8.45, NULL, 'BMW Hypoid Axle Oil G5', 'HaynesPro typeId t_619109882; 740i mHEV; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 205 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30P'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 205, 'engine_oil', (SELECT id FROM engines WHERE code = 'B58B30S'), 6.8, 7.19, '0W-12', 'BMW Longlife-22 FE++', 'HaynesPro typeId t_619112437; 750e xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 205 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30S'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 205, 'coolant', (SELECT id FROM engines WHERE code = 'B58B30S'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619112437; 750e xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 205 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30S'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 205, 'transmission_at', (SELECT id FROM engines WHERE code = 'B58B30S'), 7, 7.4, NULL, 'BMW DTF1', 'HaynesPro typeId t_619112437; 750e xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 205 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30S'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 205, 'engine_oil', (SELECT id FROM engines WHERE code = 'S68B44A'), 10.8, 11.41, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_619112438; 760i xDrive mHEV; drain 6 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 205 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S68B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 205, 'coolant', (SELECT id FROM engines WHERE code = 'S68B44A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619112438; 760i xDrive mHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 205 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S68B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 205, 'transmission_at', (SELECT id FROM engines WHERE code = 'S68B44A'), 8, 8.45, NULL, 'BMW DTF1', 'HaynesPro typeId t_619112438; 760i xDrive mHEV; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 205 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'S68B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 206, 'coolant', (SELECT id FROM engines WHERE code = 'XE2'), 18, 19.02, NULL, NULL, 'HaynesPro typeId t_619109556; i7 M70 xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 206 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'XE2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 206, 'coolant', (SELECT id FROM engines WHERE code = 'HA0004N0'), 18, 19.02, NULL, NULL, 'HaynesPro typeId t_619131107; i7 eDrive50'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 206 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'HA0004N0'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 206, 'coolant', (SELECT id FROM engines WHERE code = 'XE2A02N0'), 17.8, 18.81, NULL, NULL, 'HaynesPro typeId t_619109554; i7 xDrive 60'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 206 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'XE2A02N0'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 205, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_319017039;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 205 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 206, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_319017039;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 206 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (205, 206)
  AND e.code IN ('B57D30B', 'B58B30P', 'B58B30S', 'S68B44A', 'XE2', 'HA0004N0', 'XE2A02N0')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (205, 206)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (205, 206) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;