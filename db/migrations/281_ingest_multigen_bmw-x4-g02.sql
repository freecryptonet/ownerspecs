-- mig 281 — multi-gen HaynesPro ingest: BMW X4 (F98, G02)
-- crawl: haynespro-crawl-bmw-x4-g02-2026-05-23.json
-- modelId: d_319001694
-- 10 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — BMW X4 (F98, G02)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319001694', NOW(), 'Multi-gen ingest, 10 engines across 3 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319001694' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('S58B30A', 'M (S58B30A) 353kW', 2993, 'petrol', 'turbo', NULL),
  ('B57D30B', 'M40d (B57D30B) 240kW', 2993, 'diesel', 'turbo', NULL),
  ('B58B30A', 'M40i (B58B30A) 260kW', 2998, 'petrol', 'turbo', NULL),
  ('B58B30B', 'M40i (B58B30B) 265kW', 2998, 'petrol', 'turbo', NULL),
  ('B47D20A', 'xDrive 20d (B47D20A) 140kW', 1995, 'diesel', 'turbo', NULL),
  ('B47D20B', 'xDrive 20d Bi-Turbo (B47D20B) 140kW', 1995, 'diesel', 'turbo', NULL),
  ('B48B20A', 'xDrive 20i (B48B20A) 135kW', 1998, 'petrol', 'turbo', NULL),
  ('B46B20B', 'xDrive 20i mHev (B46B20B) 135kW', 1998, 'hybrid', 'turbo', NULL),
  ('B57D30A', 'xDrive 30d (B57D30A) 195kW', 2993, 'diesel', 'turbo', NULL),
  ('B48B20B', 'xDrive 30i (B48B20B) 185kW', 1998, 'petrol', 'turbo', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 231, 'engine_oil', (SELECT id FROM engines WHERE code = 'S58B30A'), 7, 7.4, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_619018208; M; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 231 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 231, 'coolant', (SELECT id FROM engines WHERE code = 'S58B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619018208; M'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 231 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 231, 'transmission_at', (SELECT id FROM engines WHERE code = 'S58B30A'), 9.35, 9.88, NULL, 'BMW DTF1', 'HaynesPro typeId t_619018208; M; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 231 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'S58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 232, 'engine_oil', (SELECT id FROM engines WHERE code = 'S58B30A'), 7, 7.4, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_619018208; M; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 232 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 232, 'coolant', (SELECT id FROM engines WHERE code = 'S58B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619018208; M'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 232 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 232, 'transmission_at', (SELECT id FROM engines WHERE code = 'S58B30A'), 9.35, 9.88, NULL, 'BMW DTF1', 'HaynesPro typeId t_619018208; M; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 232 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'S58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 233, 'engine_oil', (SELECT id FROM engines WHERE code = 'S58B30A'), 7, 7.4, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_619018208; M; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 233 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 233, 'coolant', (SELECT id FROM engines WHERE code = 'S58B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619018208; M'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 233 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 233, 'transmission_at', (SELECT id FROM engines WHERE code = 'S58B30A'), 9.35, 9.88, NULL, 'BMW DTF1', 'HaynesPro typeId t_619018208; M; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 233 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'S58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 231, 'engine_oil', (SELECT id FROM engines WHERE code = 'B57D30B'), 6.5, 6.87, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_619008920; M40d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 231 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 231, 'coolant', (SELECT id FROM engines WHERE code = 'B57D30B'), 10.2, 10.78, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619008920; M40d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 231 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 231, 'transmission_at', (SELECT id FROM engines WHERE code = 'B57D30B'), 8.7, 9.19, NULL, 'BMW DTF1', 'HaynesPro typeId t_619008920; M40d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 231 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 232, 'engine_oil', (SELECT id FROM engines WHERE code = 'B57D30B'), 6.5, 6.87, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_619008920; M40d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 232 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 232, 'coolant', (SELECT id FROM engines WHERE code = 'B57D30B'), 10.2, 10.78, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619008920; M40d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 232 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 232, 'transmission_at', (SELECT id FROM engines WHERE code = 'B57D30B'), 8.7, 9.19, NULL, 'BMW DTF1', 'HaynesPro typeId t_619008920; M40d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 232 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 231, 'engine_oil', (SELECT id FROM engines WHERE code = 'B58B30A'), 6.5, 6.87, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619008919; M40i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 231 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 231, 'coolant', (SELECT id FROM engines WHERE code = 'B58B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619008919; M40i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 231 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 231, 'transmission_at', (SELECT id FROM engines WHERE code = 'B58B30A'), 8.8, 9.3, NULL, 'BMW DTF1', 'HaynesPro typeId t_619008919; M40i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 231 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 231, 'engine_oil', (SELECT id FROM engines WHERE code = 'B58B30B'), 6.5, 6.87, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619022904; M40i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 231 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 231, 'coolant', (SELECT id FROM engines WHERE code = 'B58B30B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619022904; M40i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 231 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 231, 'transmission_at', (SELECT id FROM engines WHERE code = 'B58B30B'), 8.8, 9.3, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_619022904; M40i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 231 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 232, 'engine_oil', (SELECT id FROM engines WHERE code = 'B58B30B'), 6.5, 6.87, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619022904; M40i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 232 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 232, 'coolant', (SELECT id FROM engines WHERE code = 'B58B30B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619022904; M40i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 232 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 232, 'transmission_at', (SELECT id FROM engines WHERE code = 'B58B30B'), 8.8, 9.3, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_619022904; M40i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 232 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 231, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47D20A'), 5, 5.28, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_619008921; xDrive 20d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 231 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 231, 'coolant', (SELECT id FROM engines WHERE code = 'B47D20A'), 9, 9.51, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619008921; xDrive 20d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 231 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 231, 'transmission_at', (SELECT id FROM engines WHERE code = 'B47D20A'), 8.8, 9.3, NULL, 'BMW DTF1', 'HaynesPro typeId t_619008921; xDrive 20d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 231 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 231, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47D20B'), 5.5, 5.81, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_619018207; xDrive 20d Bi-Turbo; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 231 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 231, 'coolant', (SELECT id FROM engines WHERE code = 'B47D20B'), 9, 9.51, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619018207; xDrive 20d Bi-Turbo'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 231 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 231, 'transmission_at', (SELECT id FROM engines WHERE code = 'B47D20B'), 9.28, 9.81, NULL, 'BMW DTF1', 'HaynesPro typeId t_619018207; xDrive 20d Bi-Turbo; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 231 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 232, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47D20B'), 5.5, 5.81, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_619018207; xDrive 20d Bi-Turbo; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 232 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 232, 'coolant', (SELECT id FROM engines WHERE code = 'B47D20B'), 9, 9.51, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619018207; xDrive 20d Bi-Turbo'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 232 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 232, 'transmission_at', (SELECT id FROM engines WHERE code = 'B47D20B'), 9.28, 9.81, NULL, 'BMW DTF1', 'HaynesPro typeId t_619018207; xDrive 20d Bi-Turbo; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 232 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 231, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B20A'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619008922; xDrive 20i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 231 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 231, 'coolant', (SELECT id FROM engines WHERE code = 'B48B20A'), 12.6, 13.31, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619008922; xDrive 20i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 231 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 231, 'transmission_at', (SELECT id FROM engines WHERE code = 'B48B20A'), 8.8, 9.3, NULL, 'BMW DTF1', 'HaynesPro typeId t_619008922; xDrive 20i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 231 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 232, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B20A'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619008922; xDrive 20i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 232 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 232, 'coolant', (SELECT id FROM engines WHERE code = 'B48B20A'), 12.6, 13.31, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619008922; xDrive 20i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 232 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 232, 'transmission_at', (SELECT id FROM engines WHERE code = 'B48B20A'), 8.8, 9.3, NULL, 'BMW DTF1', 'HaynesPro typeId t_619008922; xDrive 20i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 232 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 231, 'engine_oil', (SELECT id FROM engines WHERE code = 'B46B20B'), 5.8, 6.13, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619116422; xDrive 20i mHev; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 231 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 231, 'coolant', (SELECT id FROM engines WHERE code = 'B46B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619116422; xDrive 20i mHev'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 231 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 231, 'transmission_at', (SELECT id FROM engines WHERE code = 'B46B20B'), 9.28, 9.81, NULL, 'BMW DTF1', 'HaynesPro typeId t_619116422; xDrive 20i mHev; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 231 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 232, 'engine_oil', (SELECT id FROM engines WHERE code = 'B46B20B'), 5.8, 6.13, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619116422; xDrive 20i mHev; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 232 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 232, 'coolant', (SELECT id FROM engines WHERE code = 'B46B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619116422; xDrive 20i mHev'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 232 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 232, 'transmission_at', (SELECT id FROM engines WHERE code = 'B46B20B'), 9.28, 9.81, NULL, 'BMW DTF1', 'HaynesPro typeId t_619116422; xDrive 20i mHev; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 232 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 231, 'engine_oil', (SELECT id FROM engines WHERE code = 'B57D30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_619008924; xDrive 30d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 231 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 231, 'coolant', (SELECT id FROM engines WHERE code = 'B57D30A'), 10, 10.57, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619008924; xDrive 30d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 231 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 231, 'transmission_at', (SELECT id FROM engines WHERE code = 'B57D30A'), 8.8, 9.3, NULL, 'BMW DTF1', 'HaynesPro typeId t_619008924; xDrive 30d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 231 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 231, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B20B'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619008925; xDrive 30i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 231 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 231, 'coolant', (SELECT id FROM engines WHERE code = 'B48B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619008925; xDrive 30i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 231 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 231, 'transmission_at', (SELECT id FROM engines WHERE code = 'B48B20B'), 8.8, 9.3, NULL, 'BMW DTF1', 'HaynesPro typeId t_619008925; xDrive 30i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 231 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 232, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B20B'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619008925; xDrive 30i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 232 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 232, 'coolant', (SELECT id FROM engines WHERE code = 'B48B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619008925; xDrive 30i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 232 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 232, 'transmission_at', (SELECT id FROM engines WHERE code = 'B48B20B'), 8.8, 9.3, NULL, 'BMW DTF1', 'HaynesPro typeId t_619008925; xDrive 30i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 232 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 231, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_319001694; Alt: BMW ATF 3+ (BMW 83 22 2 289 720)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 231 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 232, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_319001694; Alt: BMW ATF 3+ (BMW 83 22 2 289 720)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 232 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 233, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_319001694; Alt: BMW ATF 3+ (BMW 83 22 2 289 720)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 233 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (231, 232, 233)
  AND e.code IN ('S58B30A', 'B57D30B', 'B58B30A', 'B58B30B', 'B47D20A', 'B47D20B', 'B48B20A', 'B46B20B', 'B57D30A', 'B48B20B')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (231, 232, 233)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (231, 232, 233) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;