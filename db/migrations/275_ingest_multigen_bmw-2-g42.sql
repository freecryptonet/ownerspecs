-- mig 275 — multi-gen HaynesPro ingest: BMW 2 (G42, G87)
-- crawl: haynespro-crawl-bmw-2-g42-2026-05-23.json
-- modelId: d_319009165
-- 5 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — BMW 2 (G42, G87)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319009165', NOW(), 'Multi-gen ingest, 5 engines across 2 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319009165' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('B48B20A', '218i (B48B20A) 115kW', 1998, 'petrol', 'turbo', NULL),
  ('B47D20B', '220d MHEV (B47D20B) 140kW', 1995, 'hybrid', 'turbo', NULL),
  ('B48B20B', '230i (B48B20B) 180kW', 1998, 'petrol', 'turbo', NULL),
  ('S58B30A', 'M2 (S58B30A) 338kW', 2993, 'petrol', 'turbo', NULL),
  ('B58B30B', 'M240i, -xDrive (B58B30B) 275kW', 2998, 'petrol', 'turbo', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 215, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B20A'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619109873; 218i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 215 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 215, 'coolant', (SELECT id FROM engines WHERE code = 'B48B20A'), 10, 10.57, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619109873; 218i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 215 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 215, 'transmission_at', (SELECT id FROM engines WHERE code = 'B48B20A'), 9.28, 9.81, NULL, 'BMW Hypoid Axle Oil G5', 'HaynesPro typeId t_619109873; 218i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 215 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 215, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47D20B'), 5.5, 5.81, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_619037793; 220d MHEV; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 215 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 215, 'coolant', (SELECT id FROM engines WHERE code = 'B47D20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619037793; 220d MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 215 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 215, 'transmission_at', (SELECT id FROM engines WHERE code = 'B47D20B'), 9.28, 9.81, NULL, 'BMW Hypoid Axle Oil G5', 'HaynesPro typeId t_619037793; 220d MHEV; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 215 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 215, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B20B'), 5.75, 6.08, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619108694; 230i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 215 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 215, 'coolant', (SELECT id FROM engines WHERE code = 'B48B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619108694; 230i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 215 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 215, 'transmission_at', (SELECT id FROM engines WHERE code = 'B48B20B'), 9.28, 9.81, NULL, 'BMW Hypoid Axle Oil G4', 'HaynesPro typeId t_619108694; 230i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 215 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 216, 'engine_oil', (SELECT id FROM engines WHERE code = 'S58B30A'), 7, 7.4, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_619114634; M2; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 216 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 216, 'coolant', (SELECT id FROM engines WHERE code = 'S58B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619114634; M2'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 216 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 216, 'transmission_mt', (SELECT id FROM engines WHERE code = 'S58B30A'), 1.6, 1.69, NULL, 'SAE 75W-80', 'HaynesPro typeId t_619114634; M2; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 216 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'S58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 215, 'engine_oil', (SELECT id FROM engines WHERE code = 'B58B30B'), NULL, NULL, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619037792; M240i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 215 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 215, 'coolant', (SELECT id FROM engines WHERE code = 'B58B30B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619037792; M240i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 215 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 215, 'transmission_at', (SELECT id FROM engines WHERE code = 'B58B30B'), 9.28, 9.81, NULL, 'BMW DTF1', 'HaynesPro typeId t_619037792; M240i, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 215 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30B'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 215, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_319009165; Alt: BMW ATF 3+ (BMW 83 22 2 289 720)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 215 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 216, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_319009165; Alt: BMW ATF 3+ (BMW 83 22 2 289 720)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 216 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (215, 216)
  AND e.code IN ('B48B20A', 'B47D20B', 'B48B20B', 'S58B30A', 'B58B30B')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (215, 216)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (215, 216) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;