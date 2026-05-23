-- mig 294 — multi-gen HaynesPro ingest: BMW 6 GT (G32)
-- crawl: haynespro-crawl-bmw-6-g32-2026-05-23.json
-- modelId: d_319001547
-- 6 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — BMW 6 GT (G32)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319001547', NOW(), 'Multi-gen ingest, 6 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319001547' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('B47D20B', '620d (B47D20B) 120kW', 1995, 'diesel', 'turbo', NULL),
  ('B57D30B', '630d mHev, -xDrive (B57D30B) 210kW', 2993, 'hybrid', 'turbo', NULL),
  ('B57D30A', '630d, -xDrive (B57D30A) 195kW', 2993, 'diesel', 'turbo', NULL),
  ('B48B20B', '630i (B48B20B) 190kW', 1998, 'petrol', 'turbo', NULL),
  ('B58B30C', '630i mHev (B58B30C) 190kW', 2998, 'hybrid', 'turbo', NULL),
  ('B58B30A', '640i, -xDrive (B58B30A) 250kW', 2998, 'petrol', 'turbo', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 263, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47D20B'), 5.5, 5.81, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_619032601; 620d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 263 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 263, 'coolant', (SELECT id FROM engines WHERE code = 'B47D20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619032601; 620d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 263 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 263, 'transmission_at', (SELECT id FROM engines WHERE code = 'B47D20B'), 9.28, 9.81, NULL, 'BMW Hypoid Axle Oil G3', 'HaynesPro typeId t_619032601; 620d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 263 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 263, 'engine_oil', (SELECT id FROM engines WHERE code = 'B57D30B'), 7, 7.4, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_619035730; 630d mHev, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 263 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 263, 'coolant', (SELECT id FROM engines WHERE code = 'B57D30B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619035730; 630d mHev, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 263 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 263, 'transmission_at', (SELECT id FROM engines WHERE code = 'B57D30B'), 9.35, 9.88, NULL, 'BMW DTF1', 'HaynesPro typeId t_619035730; 630d mHev, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 263 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 263, 'engine_oil', (SELECT id FROM engines WHERE code = 'B57D30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_319007359; 630d, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 263 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 263, 'coolant', (SELECT id FROM engines WHERE code = 'B57D30A'), 11.72, 12.38, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319007359; 630d, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 263 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 263, 'transmission_at', (SELECT id FROM engines WHERE code = 'B57D30A'), 8.7, 9.19, NULL, 'BMW DTF1', 'HaynesPro typeId t_319007359; 630d, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 263 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 263, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B20B'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_319007360; 630i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 263 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 263, 'coolant', (SELECT id FROM engines WHERE code = 'B48B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319007360; 630i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 263 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 263, 'transmission_at', (SELECT id FROM engines WHERE code = 'B48B20B'), NULL, NULL, NULL, 'BMW Hypoid Axle Oil G3', 'HaynesPro typeId t_319007360; 630i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 263 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 263, 'engine_oil', (SELECT id FROM engines WHERE code = 'B58B30C'), 6.5, 6.87, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619140164; 630i mHev; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 263 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 263, 'coolant', (SELECT id FROM engines WHERE code = 'B58B30C'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619140164; 630i mHev'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 263 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 263, 'transmission_at', (SELECT id FROM engines WHERE code = 'B58B30C'), 9.28, 9.81, NULL, 'BMW DTF1', 'HaynesPro typeId t_619140164; 630i mHev; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 263 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 263, 'engine_oil', (SELECT id FROM engines WHERE code = 'B58B30A'), 6.5, 6.87, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_319007361; 640i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 263 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 263, 'coolant', (SELECT id FROM engines WHERE code = 'B58B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319007361; 640i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 263 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 263, 'transmission_at', (SELECT id FROM engines WHERE code = 'B58B30A'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_319007361; 640i, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 263 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30A'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 263, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_319001547; Alt: BMW ATF 3+ (BMW 83 22 2 289 720)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 263 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (263)
  AND e.code IN ('B47D20B', 'B57D30B', 'B57D30A', 'B48B20B', 'B58B30C', 'B58B30A')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (263)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (263) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;