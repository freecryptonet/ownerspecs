-- mig 248 — multi-gen HaynesPro ingest: BMW X3 (F25)
-- crawl: haynespro-crawl-bmw-x3-f25-2026-05-23.json
-- modelId: d_102000210
-- 8 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — BMW X3 (F25)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_102000210', NOW(), 'Multi-gen ingest, 8 engines across 2 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_102000210' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('N47D20C', 'sDrive 18d (N47D20C) 105kW', 1995, 'diesel', 'NA', NULL),
  ('B47D20A', 'sDrive 18d (B47D20A) 110kW', 1995, 'diesel', 'turbo', NULL),
  ('N20B16A', 'sDrive 18i (N20B16A) 125kW', 1592, 'petrol', 'turbo', NULL),
  ('N20B20A', 'xDrive 20i / sDrive- (N20B20A) 135kW', 1997, 'petrol', 'turbo', NULL),
  ('N52B30A', 'xDrive 28i (N52B30A) 190kW', 2996, 'petrol', 'NA', NULL),
  ('N57D30A', 'xDrive 30d (N57D30A) 190kW', 2993, 'diesel', 'NA', NULL),
  ('N57D30B', 'xDrive 35d (N57D30B) 230kW', 2993, 'diesel', 'NA', NULL),
  ('N55B30A', 'xDrive 35i (N55B30A) 225kW', 2979, 'petrol', 'turbo', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 166, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20C'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_201000062; sDrive 18d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 166 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 166, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20C'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_201000062; sDrive 18d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 166 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 166, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20C'), 1.2, 1.27, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_201000062; sDrive 18d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 166 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 167, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20C'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_201000062; sDrive 18d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 167 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 167, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20C'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_201000062; sDrive 18d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 167 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 167, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20C'), 1.2, 1.27, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_201000062; sDrive 18d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 167 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 166, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47D20A'), 5, 5.28, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_305000701; sDrive 18d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 166 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 166, 'coolant', (SELECT id FROM engines WHERE code = 'B47D20A'), 9.5, 10.04, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_305000701; sDrive 18d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 166 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 166, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B47D20A'), 1.2, 1.27, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_305000701; sDrive 18d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 166 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 167, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47D20A'), 5, 5.28, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_305000701; sDrive 18d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 167 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 167, 'coolant', (SELECT id FROM engines WHERE code = 'B47D20A'), 9.5, 10.04, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_305000701; sDrive 18d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 167 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 167, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B47D20A'), 1.2, 1.27, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_305000701; sDrive 18d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 167 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 166, 'engine_oil', (SELECT id FROM engines WHERE code = 'N20B16A'), 4.8, 5.07, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_318011910; sDrive 18i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 166 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 166, 'coolant', (SELECT id FROM engines WHERE code = 'N20B16A'), 7.5, 7.93, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_318011910; sDrive 18i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 166 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 166, 'transmission_at', (SELECT id FROM engines WHERE code = 'N20B16A'), NULL, NULL, NULL, 'BMW Hypoid Axle Oil G3', 'HaynesPro typeId t_318011910; sDrive 18i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 166 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 167, 'engine_oil', (SELECT id FROM engines WHERE code = 'N20B16A'), 4.8, 5.07, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_318011910; sDrive 18i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 167 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 167, 'coolant', (SELECT id FROM engines WHERE code = 'N20B16A'), 7.5, 7.93, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_318011910; sDrive 18i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 167 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 167, 'transmission_at', (SELECT id FROM engines WHERE code = 'N20B16A'), NULL, NULL, NULL, 'BMW Hypoid Axle Oil G3', 'HaynesPro typeId t_318011910; sDrive 18i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 167 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 166, 'engine_oil', (SELECT id FROM engines WHERE code = 'N20B20A'), 4.8, 5.07, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_200000082; xDrive 20i / sDrive-; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 166 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 166, 'coolant', (SELECT id FROM engines WHERE code = 'N20B20A'), 7.5, 7.93, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_200000082; xDrive 20i / sDrive-'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 166 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 166, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N20B20A'), 1.2, 1.27, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_200000082; xDrive 20i / sDrive-; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 166 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 167, 'engine_oil', (SELECT id FROM engines WHERE code = 'N20B20A'), 4.8, 5.07, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_200000082; xDrive 20i / sDrive-; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 167 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 167, 'coolant', (SELECT id FROM engines WHERE code = 'N20B20A'), 7.5, 7.93, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_200000082; xDrive 20i / sDrive-'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 167 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 167, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N20B20A'), 1.2, 1.27, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_200000082; xDrive 20i / sDrive-; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 167 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 166, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_102002256; xDrive 28i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 166 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 166, 'coolant', (SELECT id FROM engines WHERE code = 'N52B30A'), 9.3, 9.83, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102002256; xDrive 28i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 166 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 166, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N52B30A'), 1.2, 1.27, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_102002256; xDrive 28i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 166 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 166, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102002363; xDrive 30d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 166 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 166, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30A'), 10, 10.57, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102002363; xDrive 30d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 166 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 166, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N57D30A'), 1.6, 1.69, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_102002363; xDrive 30d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 166 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 167, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102002363; xDrive 30d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 167 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 167, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30A'), 10, 10.57, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102002363; xDrive 30d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 167 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 167, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N57D30A'), 1.6, 1.69, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_102002363; xDrive 30d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 167 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 166, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30B'), 6.5, 6.87, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_200000136; xDrive 35d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 166 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 166, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30B'), 12, 12.68, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_200000136; xDrive 35d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 166 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 166, 'transmission_at', (SELECT id FROM engines WHERE code = 'N57D30B'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_200000136; xDrive 35d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 166 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 167, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30B'), 6.5, 6.87, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_200000136; xDrive 35d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 167 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 167, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30B'), 12, 12.68, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_200000136; xDrive 35d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 167 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 167, 'transmission_at', (SELECT id FROM engines WHERE code = 'N57D30B'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_200000136; xDrive 35d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 167 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 166, 'engine_oil', (SELECT id FROM engines WHERE code = 'N55B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_102002017; xDrive 35i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 166 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 166, 'coolant', (SELECT id FROM engines WHERE code = 'N55B30A'), 9.3, 9.83, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102002017; xDrive 35i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 166 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 166, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N55B30A'), 1.2, 1.27, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_102002017; xDrive 35i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 166 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 167, 'engine_oil', (SELECT id FROM engines WHERE code = 'N55B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_102002017; xDrive 35i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 167 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 167, 'coolant', (SELECT id FROM engines WHERE code = 'N55B30A'), 9.3, 9.83, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102002017; xDrive 35i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 167 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 167, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N55B30A'), 1.2, 1.27, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_102002017; xDrive 35i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 167 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 166, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_102000210;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 166 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 167, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_102000210;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 167 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (166, 167)
  AND e.code IN ('N47D20C', 'B47D20A', 'N20B16A', 'N20B20A', 'N52B30A', 'N57D30A', 'N57D30B', 'N55B30A')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (166, 167)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (166, 167) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;