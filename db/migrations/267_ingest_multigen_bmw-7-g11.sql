-- mig 267 — multi-gen HaynesPro ingest: BMW 7 (G11, G12)
-- crawl: haynespro-crawl-bmw-7-g11-2026-05-23.json
-- modelId: d_317000028
-- 11 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — BMW 7 (G11, G12)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_317000028', NOW(), 'Multi-gen ingest, 11 engines across 2 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_317000028' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('B47D20B', '725d (B47D20B) 155kW', 1995, 'diesel', 'turbo', NULL),
  ('B57D30B', '730d mHev, -xDrive (B57D30B) 220kW', 2993, 'hybrid', 'turbo', NULL),
  ('B57D30A', '730d, Ld, -xDrive (B57D30A) 195kW', 2993, 'diesel', 'turbo', NULL),
  ('B48B20B', '730i, Li (B48B20B) 190kW', 1998, 'petrol', 'turbo', NULL),
  ('B58B30A', '740i, Li (B58B30A) 240kW', 2998, 'petrol', 'turbo', NULL),
  ('B58B30C', '740i, Li, -xDrive (B58B30C) 250kW', 2998, 'petrol', 'turbo', NULL),
  ('B57D30C', '750d, Ld, -xDrive (B57D30C) 294kW', 2993, 'diesel', 'turbo', NULL),
  ('N63B44C', '750i, Li, -xDrive (N63B44C) 330kW', 4395, 'petrol', 'turbo', NULL),
  ('N63B44D', '750i, Li,- xDrive (N63B44D) 390kW', 4395, 'petrol', 'turbo', NULL),
  ('N74B66B', 'M760Li xDrive (N74B66B) 448kW', 6592, 'petrol', 'NA', NULL),
  ('N74B66C', 'M760Li xDrive (N74B66C) 430kW', 6592, 'petrol', 'NA', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 203, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47D20B'), 5, 5.28, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_619019702; 725d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 203 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 203, 'coolant', (SELECT id FROM engines WHERE code = 'B47D20B'), 9.4, 9.93, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619019702; 725d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 203 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 203, 'transmission_at', (SELECT id FROM engines WHERE code = 'B47D20B'), NULL, NULL, NULL, 'BMW Synthetik OSP (BMW 83 22 2 365 987)', 'HaynesPro typeId t_619019702; 725d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 203 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 204, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47D20B'), 5, 5.28, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_619019702; 725d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 204 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 204, 'coolant', (SELECT id FROM engines WHERE code = 'B47D20B'), 9.4, 9.93, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619019702; 725d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 204 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 204, 'transmission_at', (SELECT id FROM engines WHERE code = 'B47D20B'), NULL, NULL, NULL, 'BMW Synthetik OSP (BMW 83 22 2 365 987)', 'HaynesPro typeId t_619019702; 725d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 204 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 204, 'engine_oil', (SELECT id FROM engines WHERE code = 'B57D30B'), 7, 7.4, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_619035160; 730d mHev, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 204 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 204, 'coolant', (SELECT id FROM engines WHERE code = 'B57D30B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619035160; 730d mHev, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 204 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 204, 'transmission_at', (SELECT id FROM engines WHERE code = 'B57D30B'), 9.35, 9.88, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_619035160; 730d mHev, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 204 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 203, 'engine_oil', (SELECT id FROM engines WHERE code = 'B57D30B'), 7, 7.4, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_619035160; 730d mHev, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 203 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 203, 'coolant', (SELECT id FROM engines WHERE code = 'B57D30B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619035160; 730d mHev, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 203 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 203, 'transmission_at', (SELECT id FROM engines WHERE code = 'B57D30B'), 9.35, 9.88, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_619035160; 730d mHev, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 203 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 203, 'engine_oil', (SELECT id FROM engines WHERE code = 'B57D30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_318011914; 730d, Ld, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 203 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 203, 'coolant', (SELECT id FROM engines WHERE code = 'B57D30A'), 8.9, 9.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_318011914; 730d, Ld, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 203 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 203, 'transmission_at', (SELECT id FROM engines WHERE code = 'B57D30A'), 8.7, 9.19, NULL, 'BMW DTF1', 'HaynesPro typeId t_318011914; 730d, Ld, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 203 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 204, 'engine_oil', (SELECT id FROM engines WHERE code = 'B57D30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_318011914; 730d, Ld, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 204 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 204, 'coolant', (SELECT id FROM engines WHERE code = 'B57D30A'), 8.9, 9.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_318011914; 730d, Ld, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 204 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 204, 'transmission_at', (SELECT id FROM engines WHERE code = 'B57D30A'), 8.7, 9.19, NULL, 'BMW DTF1', 'HaynesPro typeId t_318011914; 730d, Ld, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 204 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 203, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B20B'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_319001070; 730i, Li; drain 20 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 203 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 203, 'coolant', (SELECT id FROM engines WHERE code = 'B48B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319001070; 730i, Li'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 203 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 203, 'transmission_at', (SELECT id FROM engines WHERE code = 'B48B20B'), NULL, NULL, NULL, 'BMW Synthetik OSP (BMW 83 22 2 365 987)', 'HaynesPro typeId t_319001070; 730i, Li; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 203 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 204, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B20B'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_319001070; 730i, Li; drain 20 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 204 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 204, 'coolant', (SELECT id FROM engines WHERE code = 'B48B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319001070; 730i, Li'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 204 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 204, 'transmission_at', (SELECT id FROM engines WHERE code = 'B48B20B'), NULL, NULL, NULL, 'BMW Synthetik OSP (BMW 83 22 2 365 987)', 'HaynesPro typeId t_319001070; 730i, Li; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 204 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 203, 'engine_oil', (SELECT id FROM engines WHERE code = 'B58B30A'), 6.2, 6.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_318011916; 740i, Li; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 203 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 203, 'coolant', (SELECT id FROM engines WHERE code = 'B58B30A'), 11.3, 11.94, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_318011916; 740i, Li'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 203 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 203, 'transmission_at', (SELECT id FROM engines WHERE code = 'B58B30A'), NULL, NULL, NULL, 'BMW Synthetik OSP (BMW 83 22 2 365 987)', 'HaynesPro typeId t_318011916; 740i, Li; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 203 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 204, 'engine_oil', (SELECT id FROM engines WHERE code = 'B58B30A'), 6.2, 6.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_318011916; 740i, Li; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 204 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 204, 'coolant', (SELECT id FROM engines WHERE code = 'B58B30A'), 11.3, 11.94, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_318011916; 740i, Li'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 204 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 204, 'transmission_at', (SELECT id FROM engines WHERE code = 'B58B30A'), NULL, NULL, NULL, 'BMW Synthetik OSP (BMW 83 22 2 365 987)', 'HaynesPro typeId t_318011916; 740i, Li; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 204 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 203, 'engine_oil', (SELECT id FROM engines WHERE code = 'B58B30C'), 6.5, 6.87, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619017661; 740i, Li, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 203 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 203, 'coolant', (SELECT id FROM engines WHERE code = 'B58B30C'), NULL, NULL, NULL, '(Green fluid)', 'HaynesPro typeId t_619017661; 740i, Li, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 203 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 203, 'transmission_at', (SELECT id FROM engines WHERE code = 'B58B30C'), 9.28, 9.81, NULL, 'BMW DTF1', 'HaynesPro typeId t_619017661; 740i, Li, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 203 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 204, 'engine_oil', (SELECT id FROM engines WHERE code = 'B58B30C'), 6.5, 6.87, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619017661; 740i, Li, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 204 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 204, 'coolant', (SELECT id FROM engines WHERE code = 'B58B30C'), NULL, NULL, NULL, '(Green fluid)', 'HaynesPro typeId t_619017661; 740i, Li, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 204 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 204, 'transmission_at', (SELECT id FROM engines WHERE code = 'B58B30C'), 9.28, 9.81, NULL, 'BMW DTF1', 'HaynesPro typeId t_619017661; 740i, Li, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 204 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 203, 'engine_oil', (SELECT id FROM engines WHERE code = 'B57D30C'), 6.5, 6.87, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_319001041; 750d, Ld, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 203 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 203, 'coolant', (SELECT id FROM engines WHERE code = 'B57D30C'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319001041; 750d, Ld, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 203 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 203, 'transmission_at', (SELECT id FROM engines WHERE code = 'B57D30C'), 8.7, 9.19, NULL, 'BMW DTF1', 'HaynesPro typeId t_319001041; 750d, Ld, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 203 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 204, 'engine_oil', (SELECT id FROM engines WHERE code = 'B57D30C'), 6.5, 6.87, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_319001041; 750d, Ld, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 204 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 204, 'coolant', (SELECT id FROM engines WHERE code = 'B57D30C'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319001041; 750d, Ld, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 204 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 204, 'transmission_at', (SELECT id FROM engines WHERE code = 'B57D30C'), 8.7, 9.19, NULL, 'BMW DTF1', 'HaynesPro typeId t_319001041; 750d, Ld, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 204 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 203, 'engine_oil', (SELECT id FROM engines WHERE code = 'N63B44C'), 10, 10.57, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_318011919; 750i, Li, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 203 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 203, 'coolant', (SELECT id FROM engines WHERE code = 'N63B44C'), 9.2, 9.72, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_318011919; 750i, Li, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 203 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 203, 'transmission_at', (SELECT id FROM engines WHERE code = 'N63B44C'), 8.7, 9.19, NULL, 'BMW DTF1', 'HaynesPro typeId t_318011919; 750i, Li, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 203 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 203, 'engine_oil', (SELECT id FROM engines WHERE code = 'N63B44D'), 10.5, 11.1, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_619017666; 750i, Li,- xDrive; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 203 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 203, 'coolant', (SELECT id FROM engines WHERE code = 'N63B44D'), NULL, NULL, NULL, '(Green fluid)', 'HaynesPro typeId t_619017666; 750i, Li,- xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 203 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 203, 'transmission_at', (SELECT id FROM engines WHERE code = 'N63B44D'), 8.7, 9.19, NULL, 'BMW DTF1', 'HaynesPro typeId t_619017666; 750i, Li,- xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 203 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 204, 'engine_oil', (SELECT id FROM engines WHERE code = 'N63B44D'), 10.5, 11.1, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_619017666; 750i, Li,- xDrive; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 204 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 204, 'coolant', (SELECT id FROM engines WHERE code = 'N63B44D'), NULL, NULL, NULL, '(Green fluid)', 'HaynesPro typeId t_619017666; 750i, Li,- xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 204 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 204, 'transmission_at', (SELECT id FROM engines WHERE code = 'N63B44D'), 8.7, 9.19, NULL, 'BMW DTF1', 'HaynesPro typeId t_619017666; 750i, Li,- xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 204 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 203, 'engine_oil', (SELECT id FROM engines WHERE code = 'N74B66B'), 12, 12.68, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_319005541; M760Li xDrive; drain 20 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 203 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N74B66B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 203, 'coolant', (SELECT id FROM engines WHERE code = 'N74B66B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319005541; M760Li xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 203 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N74B66B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 203, 'transmission_at', (SELECT id FROM engines WHERE code = 'N74B66B'), 9.3, 9.83, NULL, 'BMW DTF1', 'HaynesPro typeId t_319005541; M760Li xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 203 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N74B66B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 204, 'engine_oil', (SELECT id FROM engines WHERE code = 'N74B66B'), 12, 12.68, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_319005541; M760Li xDrive; drain 20 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 204 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N74B66B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 204, 'coolant', (SELECT id FROM engines WHERE code = 'N74B66B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319005541; M760Li xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 204 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N74B66B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 204, 'transmission_at', (SELECT id FROM engines WHERE code = 'N74B66B'), 9.3, 9.83, NULL, 'BMW DTF1', 'HaynesPro typeId t_319005541; M760Li xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 204 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N74B66B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 203, 'engine_oil', (SELECT id FROM engines WHERE code = 'N74B66C'), 12, 12.68, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_619017665; M760Li xDrive; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 203 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N74B66C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 203, 'coolant', (SELECT id FROM engines WHERE code = 'N74B66C'), NULL, NULL, NULL, '(Green fluid)', 'HaynesPro typeId t_619017665; M760Li xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 203 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N74B66C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 203, 'transmission_at', (SELECT id FROM engines WHERE code = 'N74B66C'), 9.3, 9.83, NULL, 'BMW DTF1', 'HaynesPro typeId t_619017665; M760Li xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 203 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N74B66C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 204, 'engine_oil', (SELECT id FROM engines WHERE code = 'N74B66C'), 12, 12.68, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_619017665; M760Li xDrive; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 204 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N74B66C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 204, 'coolant', (SELECT id FROM engines WHERE code = 'N74B66C'), NULL, NULL, NULL, '(Green fluid)', 'HaynesPro typeId t_619017665; M760Li xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 204 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N74B66C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 204, 'transmission_at', (SELECT id FROM engines WHERE code = 'N74B66C'), 9.3, 9.83, NULL, 'BMW DTF1', 'HaynesPro typeId t_619017665; M760Li xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 204 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N74B66C'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 203, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_317000028; Alt: BMW ATF 3+ (BMW 83 22 2 289 720)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 203 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 204, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_317000028; Alt: BMW ATF 3+ (BMW 83 22 2 289 720)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 204 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (203, 204)
  AND e.code IN ('B47D20B', 'B57D30B', 'B57D30A', 'B48B20B', 'B58B30A', 'B58B30C', 'B57D30C', 'N63B44C', 'N63B44D', 'N74B66B', 'N74B66C')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (203, 204)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (203, 204) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;