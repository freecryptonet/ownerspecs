-- mig 283 — multi-gen HaynesPro ingest: BMW X6 (F16, F86)
-- crawl: haynespro-crawl-bmw-x6-f16-2026-05-23.json
-- modelId: d_304000001
-- 6 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — BMW X6 (F16, F86)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_304000001', NOW(), 'Multi-gen ingest, 6 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_304000001' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('S63B44B', 'M (S63B44B) 423kW', 4395, 'petrol', 'turbo', NULL),
  ('N57D30A', 'xDrive 30d (N57D30A) 190kW', 2993, 'diesel', 'NA', NULL),
  ('N55B30A', 'xDrive 35i (N55B30A) 225kW', 2979, 'petrol', 'turbo', NULL),
  ('N57D30B', 'xDrive 40d (N57D30B) 230kW', 2993, 'diesel', 'NA', NULL),
  ('N63B44B', 'xDrive 50i (N63B44B) 330kW', 4395, 'petrol', 'turbo', NULL),
  ('N57D30C', 'xDrive M50d (N57D30C) 280kW', 2993, 'diesel', 'NA', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 235, 'engine_oil', (SELECT id FROM engines WHERE code = 'S63B44B'), 9.5, 10.04, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_317000091; M; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 235 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 235, 'coolant', (SELECT id FROM engines WHERE code = 'S63B44B'), 16.8, 17.75, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_317000091; M'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 235 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 235, 'transmission_at', (SELECT id FROM engines WHERE code = 'S63B44B'), 8.7, 9.19, NULL, 'BMW DTF1', 'HaynesPro typeId t_317000091; M; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 235 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'S63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 235, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_305000596; xDrive 30d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 235 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 235, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30A'), 12.6, 13.31, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_305000596; xDrive 30d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 235 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 235, 'transmission_at', (SELECT id FROM engines WHERE code = 'N57D30A'), 8.7, 9.19, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_305000596; xDrive 30d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 235 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 235, 'engine_oil', (SELECT id FROM engines WHERE code = 'N55B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_317000232; xDrive 35i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 235 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 235, 'coolant', (SELECT id FROM engines WHERE code = 'N55B30A'), 10.3, 10.88, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_317000232; xDrive 35i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 235 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 235, 'transmission_at', (SELECT id FROM engines WHERE code = 'N55B30A'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_317000232; xDrive 35i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 235 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 235, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30B'), 6.5, 6.87, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_311000043; xDrive 40d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 235 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 235, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30B'), 12.6, 13.31, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_311000043; xDrive 40d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 235 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 235, 'transmission_at', (SELECT id FROM engines WHERE code = 'N57D30B'), 8.7, 9.19, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_311000043; xDrive 40d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 235 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 235, 'engine_oil', (SELECT id FROM engines WHERE code = 'N63B44B'), 9.5, 10.04, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_311000044; xDrive 50i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 235 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 235, 'coolant', (SELECT id FROM engines WHERE code = 'N63B44B'), 14.9, 15.74, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_311000044; xDrive 50i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 235 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 235, 'transmission_at', (SELECT id FROM engines WHERE code = 'N63B44B'), 8.7, 9.19, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_311000044; xDrive 50i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 235 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 235, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30C'), 6.5, 6.87, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_311000045; xDrive M50d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 235 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 235, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30C'), 12.6, 13.31, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_311000045; xDrive M50d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 235 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 235, 'transmission_at', (SELECT id FROM engines WHERE code = 'N57D30C'), 8.7, 9.19, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_311000045; xDrive M50d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 235 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30C'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 235, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_304000001; Alt: BMW ATF 3+ (BMW 83 22 2 289 720)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 235 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (235)
  AND e.code IN ('S63B44B', 'N57D30A', 'N55B30A', 'N57D30B', 'N63B44B', 'N57D30C')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (235)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (235) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;