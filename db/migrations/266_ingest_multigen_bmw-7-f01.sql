-- mig 266 — multi-gen HaynesPro ingest: BMW 7 (F01, F02, F04)
-- crawl: haynespro-crawl-bmw-7-f01-2026-05-23.json
-- modelId: d_102000073
-- 9 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — BMW 7 (F01, F02, F04)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_102000073', NOW(), 'Multi-gen ingest, 9 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_102000073' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('N57D30A', '725d (N57D30A) 155kW', 2993, 'diesel', 'NA', NULL),
  ('N52B30A', '730i (N52B30A) 190kW', 2996, 'petrol', 'NA', NULL),
  ('N57D30B', '740d, -xDrive (N57D30B) 225kW', 2993, 'diesel', 'NA', NULL),
  ('N54B30A', '740i (N54B30A) 240kW', 2979, 'petrol', 'turbo', NULL),
  ('N55B30A', '740i (N55B30A) 235kW', 2979, 'petrol', 'turbo', NULL),
  ('N57D30C', '750d, -xDrive (N57D30C) 280kW', 2993, 'diesel', 'NA', NULL),
  ('N63B44A', '750i, Li, -xDrive (N63B44A) 300kW', 4395, 'petrol', 'turbo', NULL),
  ('N63B44B', '750i, Li, -xDrive (N63B44B) 330kW', 4395, 'petrol', 'turbo', NULL),
  ('N74B60A', '760i (N74B60A) 400kW', 5972, 'petrol', 'NA', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 202, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30A'), 7, 7.4, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_619032610; 725d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 202 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 202, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30A'), 8.9, 9.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619032610; 725d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 202 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 202, 'transmission_at', (SELECT id FROM engines WHERE code = 'N57D30A'), NULL, NULL, NULL, 'BMW ATF 2', 'HaynesPro typeId t_619032610; 725d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 202 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 202, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_619039589; 730i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 202 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 202, 'coolant', (SELECT id FROM engines WHERE code = 'N52B30A'), 9.6, 10.14, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619039589; 730i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 202 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 202, 'transmission_at', (SELECT id FROM engines WHERE code = 'N52B30A'), NULL, NULL, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_619039589; 730i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 202 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 202, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30B'), 7, 7.4, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102001232; 740d, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 202 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 202, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30B'), 8.9, 9.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001232; 740d, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 202 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 202, 'transmission_at', (SELECT id FROM engines WHERE code = 'N57D30B'), NULL, NULL, NULL, 'BMW ATF 2', 'HaynesPro typeId t_102001232; 740d, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 202 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 202, 'engine_oil', (SELECT id FROM engines WHERE code = 'N54B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_106000133; 740i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 202 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N54B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 202, 'coolant', (SELECT id FROM engines WHERE code = 'N54B30A'), 9, 9.51, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_106000133; 740i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 202 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N54B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 202, 'transmission_at', (SELECT id FROM engines WHERE code = 'N54B30A'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_106000133; 740i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 202 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N54B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 202, 'engine_oil', (SELECT id FROM engines WHERE code = 'N55B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_201000024; 740i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 202 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 202, 'coolant', (SELECT id FROM engines WHERE code = 'N55B30A'), 10.2, 10.78, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_201000024; 740i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 202 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 202, 'transmission_at', (SELECT id FROM engines WHERE code = 'N55B30A'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_201000024; 740i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 202 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 202, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30C'), 6.5, 6.87, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_201000022; 750d, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 202 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 202, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30C'), 11.9, 12.57, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_201000022; 750d, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 202 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 202, 'transmission_at', (SELECT id FROM engines WHERE code = 'N57D30C'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_201000022; 750d, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 202 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 202, 'engine_oil', (SELECT id FROM engines WHERE code = 'N63B44A'), 8.5, 8.98, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102001230; 750i, Li, -xDrive; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 202 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 202, 'coolant', (SELECT id FROM engines WHERE code = 'N63B44A'), 13.5, 14.27, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001230; 750i, Li, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 202 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 202, 'transmission_at', (SELECT id FROM engines WHERE code = 'N63B44A'), NULL, NULL, NULL, 'BMW ATF 2', 'HaynesPro typeId t_102001230; 750i, Li, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 202 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 202, 'engine_oil', (SELECT id FROM engines WHERE code = 'N63B44B'), 9.5, 10.04, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_201000023; 750i, Li, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 202 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 202, 'coolant', (SELECT id FROM engines WHERE code = 'N63B44B'), 12.6, 13.31, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_201000023; 750i, Li, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 202 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 202, 'transmission_at', (SELECT id FROM engines WHERE code = 'N63B44B'), NULL, NULL, NULL, 'BMW ATF 2', 'HaynesPro typeId t_201000023; 750i, Li, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 202 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 202, 'engine_oil', (SELECT id FROM engines WHERE code = 'N74B60A'), 10.5, 11.1, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102001231; 760i; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 202 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N74B60A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 202, 'coolant', (SELECT id FROM engines WHERE code = 'N74B60A'), 15.1, 15.96, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001231; 760i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 202 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N74B60A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 202, 'transmission_at', (SELECT id FROM engines WHERE code = 'N74B60A'), NULL, NULL, NULL, 'SAE 75W-90', 'HaynesPro typeId t_102001231; 760i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 202 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N74B60A'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 202, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_102000073; Alt: BMW ATF 3+ (BMW 83 22 2 289 720)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 202 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (202)
  AND e.code IN ('N57D30A', 'N52B30A', 'N57D30B', 'N54B30A', 'N55B30A', 'N57D30C', 'N63B44A', 'N63B44B', 'N74B60A')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (202)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (202) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;