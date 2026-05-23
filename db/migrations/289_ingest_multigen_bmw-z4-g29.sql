-- mig 289 — multi-gen HaynesPro ingest: BMW Z4 (G29)
-- crawl: haynespro-crawl-bmw-z4-g29-2026-05-23.json
-- modelId: d_319003512
-- 3 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — BMW Z4 (G29)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319003512', NOW(), 'Multi-gen ingest, 3 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319003512' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('B58B30C', 'M40i (B58B30C) 250kW', 2998, 'petrol', 'turbo', NULL),
  ('B46B20B', 'sDrive 20i (B46B20B) 145kW', 1998, 'petrol', 'turbo', NULL),
  ('B48B20B', 'sDrive 20i (B48B20B) 145kW', 1998, 'petrol', 'turbo', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 246, 'coolant', (SELECT id FROM engines WHERE code = 'B58B30C'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619015488; M40i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 246 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 246, 'transmission_at', (SELECT id FROM engines WHERE code = 'B58B30C'), 9.28, 9.81, NULL, 'BMW Hypoid Axle Oil G4', 'HaynesPro typeId t_619015488; M40i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 246 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 246, 'coolant', (SELECT id FROM engines WHERE code = 'B46B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619022752; sDrive 20i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 246 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 246, 'transmission_at', (SELECT id FROM engines WHERE code = 'B46B20B'), 9.28, 9.81, NULL, 'BMW Hypoid Axle Oil G3', 'HaynesPro typeId t_619022752; sDrive 20i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 246 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 246, 'coolant', (SELECT id FROM engines WHERE code = 'B48B20B'), 8.4, 8.88, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619015494; sDrive 20i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 246 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 246, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B48B20B'), 9.28, 9.81, NULL, 'SAE 75W-80', 'HaynesPro typeId t_619015494; sDrive 20i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 246 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 246, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_319003512; Alt: BMW ATF 3+ (BMW 83 22 2 289 720)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 246 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (246)
  AND e.code IN ('B58B30C', 'B46B20B', 'B48B20B')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (246)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (246) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;