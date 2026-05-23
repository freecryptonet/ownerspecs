-- mig 277 — multi-gen HaynesPro ingest: BMW 4 (F32, F33, F36, F82, F83)
-- crawl: haynespro-crawl-bmw-4-f32-2026-05-23.json
-- modelId: d_301000031
-- 16 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — BMW 4 (F32, F33, F36, F82, F83)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_301000031', NOW(), 'Multi-gen ingest, 16 engines across 8 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_301000031' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('N47D20C', '418d (N47D20C) 105kW', 1995, 'diesel', 'NA', NULL),
  ('B47D20A', '418d (B47D20A) 110kW', 1995, 'diesel', 'turbo', NULL),
  ('B38B15A', '418i (B38B15A) 100kW', 1499, 'petrol', 'NA', NULL),
  ('N20B20B', '420i, -xDrive (N20B20B) 135kW', 1997, 'petrol', 'turbo', NULL),
  ('N20B20A', '420i, -xDrive (N20B20A) 120kW', 1997, 'petrol', 'turbo', NULL),
  ('B48B20A', '420i, -xDrive (B48B20A) 135kW', 1998, 'petrol', 'turbo', NULL),
  ('N47D20D', '425d (N47D20D) 160kW', 1995, 'diesel', 'NA', NULL),
  ('B47D20B', '425d (B47D20B) 165kW', 1995, 'diesel', 'turbo', NULL),
  ('N26B20A', '428i (N26B20A) 180kW', 1997, 'petrol', 'turbo', NULL),
  ('N57D30A', '430d, -xDrive (N57D30A) 190kW', 2993, 'diesel', 'NA', NULL),
  ('B46B20B', '430i, -xDrive (B46B20B) 185kW', 1998, 'petrol', 'turbo', NULL),
  ('B48B20B', '430i, -xDrive (B48B20B) 185kW', 1998, 'petrol', 'turbo', NULL),
  ('N57D30B', '435d, -xDrive (N57D30B) 230kW', 2993, 'diesel', 'NA', NULL),
  ('N55B30A', '435i M Performance (N55B30A) 240kW', 2979, 'petrol', 'turbo', NULL),
  ('B58B30A', '440i, -xDrive (B58B30A) 240kW', 2998, 'petrol', 'turbo', NULL),
  ('S55B30A', 'M4 (S55B30A) 317kW', 2979, 'petrol', 'turbo', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20C'), 5.2, 5.49, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_311000037; 418d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20C'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_311000037; 418d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20C'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_311000037; 418d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20C'), 5.2, 5.49, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_311000037; 418d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20C'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_311000037; 418d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20C'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_311000037; 418d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20C'), 5.2, 5.49, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_311000037; 418d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20C'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_311000037; 418d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20C'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_311000037; 418d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47D20A'), 5, 5.28, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_317000093; 418d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'coolant', (SELECT id FROM engines WHERE code = 'B47D20A'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_317000093; 418d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B47D20A'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_317000093; 418d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47D20A'), 5, 5.28, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_317000093; 418d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'coolant', (SELECT id FROM engines WHERE code = 'B47D20A'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_317000093; 418d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B47D20A'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_317000093; 418d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47D20A'), 5, 5.28, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_317000093; 418d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'coolant', (SELECT id FROM engines WHERE code = 'B47D20A'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_317000093; 418d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B47D20A'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_317000093; 418d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 218, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47D20A'), 5, 5.28, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_317000093; 418d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 218 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 218, 'coolant', (SELECT id FROM engines WHERE code = 'B47D20A'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_317000093; 418d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 218 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 218, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B47D20A'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_317000093; 418d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 218 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 220, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47D20A'), 5, 5.28, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_317000093; 418d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 220 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 220, 'coolant', (SELECT id FROM engines WHERE code = 'B47D20A'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_317000093; 418d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 220 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 220, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B47D20A'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_317000093; 418d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 220 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 222, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47D20A'), 5, 5.28, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_317000093; 418d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 222 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 222, 'coolant', (SELECT id FROM engines WHERE code = 'B47D20A'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_317000093; 418d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 222 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 222, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B47D20A'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_317000093; 418d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 222 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'engine_oil', (SELECT id FROM engines WHERE code = 'B38B15A'), 4.25, 4.49, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_318011897; 418i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B38B15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'coolant', (SELECT id FROM engines WHERE code = 'B38B15A'), 7.7, 8.14, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_318011897; 418i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B38B15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B38B15A'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_318011897; 418i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B38B15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'engine_oil', (SELECT id FROM engines WHERE code = 'B38B15A'), 4.25, 4.49, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_318011897; 418i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B38B15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'coolant', (SELECT id FROM engines WHERE code = 'B38B15A'), 7.7, 8.14, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_318011897; 418i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B38B15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B38B15A'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_318011897; 418i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B38B15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'engine_oil', (SELECT id FROM engines WHERE code = 'B38B15A'), 4.25, 4.49, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_318011897; 418i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B38B15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'coolant', (SELECT id FROM engines WHERE code = 'B38B15A'), 7.7, 8.14, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_318011897; 418i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B38B15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B38B15A'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_318011897; 418i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B38B15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 218, 'engine_oil', (SELECT id FROM engines WHERE code = 'B38B15A'), 4.25, 4.49, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_318011897; 418i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 218 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B38B15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 218, 'coolant', (SELECT id FROM engines WHERE code = 'B38B15A'), 7.7, 8.14, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_318011897; 418i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 218 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B38B15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 218, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B38B15A'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_318011897; 418i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 218 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B38B15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 220, 'engine_oil', (SELECT id FROM engines WHERE code = 'B38B15A'), 4.25, 4.49, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_318011897; 418i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 220 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B38B15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 220, 'coolant', (SELECT id FROM engines WHERE code = 'B38B15A'), 7.7, 8.14, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_318011897; 418i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 220 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B38B15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 220, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B38B15A'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_318011897; 418i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 220 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B38B15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 222, 'engine_oil', (SELECT id FROM engines WHERE code = 'B38B15A'), 4.25, 4.49, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_318011897; 418i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 222 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B38B15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 222, 'coolant', (SELECT id FROM engines WHERE code = 'B38B15A'), 7.7, 8.14, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_318011897; 418i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 222 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B38B15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 222, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B38B15A'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_318011897; 418i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 222 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B38B15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'engine_oil', (SELECT id FROM engines WHERE code = 'N20B20B'), 5, 5.28, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_301001183; 420i, -xDrive; drain 8 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'coolant', (SELECT id FROM engines WHERE code = 'N20B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_301001183; 420i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N20B20B'), 1.3, 1.37, NULL, 'SAE 75W-80', 'HaynesPro typeId t_301001183; 420i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'engine_oil', (SELECT id FROM engines WHERE code = 'N20B20B'), 5, 5.28, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_301001183; 420i, -xDrive; drain 8 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'coolant', (SELECT id FROM engines WHERE code = 'N20B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_301001183; 420i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N20B20B'), 1.3, 1.37, NULL, 'SAE 75W-80', 'HaynesPro typeId t_301001183; 420i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'engine_oil', (SELECT id FROM engines WHERE code = 'N20B20B'), 5, 5.28, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_301001183; 420i, -xDrive; drain 8 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'coolant', (SELECT id FROM engines WHERE code = 'N20B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_301001183; 420i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N20B20B'), 1.3, 1.37, NULL, 'SAE 75W-80', 'HaynesPro typeId t_301001183; 420i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 218, 'engine_oil', (SELECT id FROM engines WHERE code = 'N20B20B'), 5, 5.28, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_301001183; 420i, -xDrive; drain 8 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 218 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 218, 'coolant', (SELECT id FROM engines WHERE code = 'N20B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_301001183; 420i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 218 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 218, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N20B20B'), 1.3, 1.37, NULL, 'SAE 75W-80', 'HaynesPro typeId t_301001183; 420i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 218 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 220, 'engine_oil', (SELECT id FROM engines WHERE code = 'N20B20B'), 5, 5.28, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_301001183; 420i, -xDrive; drain 8 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 220 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 220, 'coolant', (SELECT id FROM engines WHERE code = 'N20B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_301001183; 420i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 220 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 220, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N20B20B'), 1.3, 1.37, NULL, 'SAE 75W-80', 'HaynesPro typeId t_301001183; 420i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 220 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 222, 'engine_oil', (SELECT id FROM engines WHERE code = 'N20B20B'), 5, 5.28, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_301001183; 420i, -xDrive; drain 8 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 222 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 222, 'coolant', (SELECT id FROM engines WHERE code = 'N20B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_301001183; 420i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 222 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 222, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N20B20B'), 1.3, 1.37, NULL, 'SAE 75W-80', 'HaynesPro typeId t_301001183; 420i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 222 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'engine_oil', (SELECT id FROM engines WHERE code = 'N20B20A'), 5, 5.28, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_318011875; 420i, -xDrive; drain 8 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'coolant', (SELECT id FROM engines WHERE code = 'N20B20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_318011875; 420i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N20B20A'), 1.3, 1.37, NULL, 'SAE 75W-80', 'HaynesPro typeId t_318011875; 420i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'engine_oil', (SELECT id FROM engines WHERE code = 'N20B20A'), 5, 5.28, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_318011875; 420i, -xDrive; drain 8 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'coolant', (SELECT id FROM engines WHERE code = 'N20B20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_318011875; 420i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N20B20A'), 1.3, 1.37, NULL, 'SAE 75W-80', 'HaynesPro typeId t_318011875; 420i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'engine_oil', (SELECT id FROM engines WHERE code = 'N20B20A'), 5, 5.28, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_318011875; 420i, -xDrive; drain 8 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'coolant', (SELECT id FROM engines WHERE code = 'N20B20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_318011875; 420i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N20B20A'), 1.3, 1.37, NULL, 'SAE 75W-80', 'HaynesPro typeId t_318011875; 420i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B20A'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_319000505; 420i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'coolant', (SELECT id FROM engines WHERE code = 'B48B20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319000505; 420i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B48B20A'), 1.3, 1.37, NULL, 'SAE 75W-80', 'HaynesPro typeId t_319000505; 420i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B20A'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_319000505; 420i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'coolant', (SELECT id FROM engines WHERE code = 'B48B20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319000505; 420i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B48B20A'), 1.3, 1.37, NULL, 'SAE 75W-80', 'HaynesPro typeId t_319000505; 420i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B20A'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_319000505; 420i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'coolant', (SELECT id FROM engines WHERE code = 'B48B20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319000505; 420i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B48B20A'), 1.3, 1.37, NULL, 'SAE 75W-80', 'HaynesPro typeId t_319000505; 420i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 218, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B20A'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_319000505; 420i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 218 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 218, 'coolant', (SELECT id FROM engines WHERE code = 'B48B20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319000505; 420i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 218 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 218, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B48B20A'), 1.3, 1.37, NULL, 'SAE 75W-80', 'HaynesPro typeId t_319000505; 420i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 218 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 220, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B20A'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_319000505; 420i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 220 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 220, 'coolant', (SELECT id FROM engines WHERE code = 'B48B20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319000505; 420i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 220 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 220, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B48B20A'), 1.3, 1.37, NULL, 'SAE 75W-80', 'HaynesPro typeId t_319000505; 420i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 220 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 222, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B20A'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_319000505; 420i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 222 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 222, 'coolant', (SELECT id FROM engines WHERE code = 'B48B20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319000505; 420i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 222 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 222, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B48B20A'), 1.3, 1.37, NULL, 'SAE 75W-80', 'HaynesPro typeId t_319000505; 420i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 222 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20D'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_304000029; 425d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20D'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_304000029; 425d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20D'), 1.2, 1.27, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_304000029; 425d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20D'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_304000029; 425d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20D'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_304000029; 425d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20D'), 1.2, 1.27, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_304000029; 425d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20D'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_304000029; 425d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20D'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_304000029; 425d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20D'), 1.2, 1.27, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_304000029; 425d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47D20B'), 5, 5.28, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_319000779; 425d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'coolant', (SELECT id FROM engines WHERE code = 'B47D20B'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319000779; 425d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B47D20B'), 1.2, 1.27, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_319000779; 425d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47D20B'), 5, 5.28, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_319000779; 425d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'coolant', (SELECT id FROM engines WHERE code = 'B47D20B'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319000779; 425d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B47D20B'), 1.2, 1.27, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_319000779; 425d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47D20B'), 5, 5.28, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_319000779; 425d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'coolant', (SELECT id FROM engines WHERE code = 'B47D20B'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319000779; 425d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B47D20B'), 1.2, 1.27, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_319000779; 425d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 218, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47D20B'), 5, 5.28, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_319000779; 425d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 218 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 218, 'coolant', (SELECT id FROM engines WHERE code = 'B47D20B'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319000779; 425d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 218 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 218, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B47D20B'), 1.2, 1.27, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_319000779; 425d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 218 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 220, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47D20B'), 5, 5.28, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_319000779; 425d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 220 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 220, 'coolant', (SELECT id FROM engines WHERE code = 'B47D20B'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319000779; 425d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 220 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 220, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B47D20B'), 1.2, 1.27, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_319000779; 425d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 220 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 222, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47D20B'), 5, 5.28, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_319000779; 425d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 222 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 222, 'coolant', (SELECT id FROM engines WHERE code = 'B47D20B'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319000779; 425d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 222 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 222, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B47D20B'), 1.2, 1.27, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_319000779; 425d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 222 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'engine_oil', (SELECT id FROM engines WHERE code = 'N26B20A'), 5, 5.28, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_305000602; 428i; drain 8 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N26B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'coolant', (SELECT id FROM engines WHERE code = 'N26B20A'), 9.1, 9.62, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_305000602; 428i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N26B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'transmission_at', (SELECT id FROM engines WHERE code = 'N26B20A'), 1.3, 1.37, NULL, 'MTF LT3', 'HaynesPro typeId t_305000602; 428i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N26B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'engine_oil', (SELECT id FROM engines WHERE code = 'N26B20A'), 5, 5.28, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_305000602; 428i; drain 8 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N26B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'coolant', (SELECT id FROM engines WHERE code = 'N26B20A'), 9.1, 9.62, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_305000602; 428i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N26B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'transmission_at', (SELECT id FROM engines WHERE code = 'N26B20A'), 1.3, 1.37, NULL, 'MTF LT3', 'HaynesPro typeId t_305000602; 428i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N26B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'engine_oil', (SELECT id FROM engines WHERE code = 'N26B20A'), 5, 5.28, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_305000602; 428i; drain 8 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N26B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'coolant', (SELECT id FROM engines WHERE code = 'N26B20A'), 9.1, 9.62, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_305000602; 428i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N26B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'transmission_at', (SELECT id FROM engines WHERE code = 'N26B20A'), 1.3, 1.37, NULL, 'MTF LT3', 'HaynesPro typeId t_305000602; 428i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N26B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_301001184; 430d, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30A'), 7.2, 7.61, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_301001184; 430d, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'transmission_at', (SELECT id FROM engines WHERE code = 'N57D30A'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_301001184; 430d, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_301001184; 430d, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30A'), 7.2, 7.61, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_301001184; 430d, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'transmission_at', (SELECT id FROM engines WHERE code = 'N57D30A'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_301001184; 430d, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_301001184; 430d, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30A'), 7.2, 7.61, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_301001184; 430d, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'transmission_at', (SELECT id FROM engines WHERE code = 'N57D30A'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_301001184; 430d, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 218, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_301001184; 430d, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 218 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 218, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30A'), 7.2, 7.61, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_301001184; 430d, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 218 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 218, 'transmission_at', (SELECT id FROM engines WHERE code = 'N57D30A'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_301001184; 430d, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 218 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 220, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_301001184; 430d, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 220 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 220, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30A'), 7.2, 7.61, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_301001184; 430d, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 220 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 220, 'transmission_at', (SELECT id FROM engines WHERE code = 'N57D30A'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_301001184; 430d, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 220 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 222, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_301001184; 430d, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 222 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 222, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30A'), 7.2, 7.61, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_301001184; 430d, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 222 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 222, 'transmission_at', (SELECT id FROM engines WHERE code = 'N57D30A'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_301001184; 430d, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 222 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'engine_oil', (SELECT id FROM engines WHERE code = 'B46B20B'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619020828; 430i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'coolant', (SELECT id FROM engines WHERE code = 'B46B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619020828; 430i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'transmission_at', (SELECT id FROM engines WHERE code = 'B46B20B'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_619020828; 430i, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'engine_oil', (SELECT id FROM engines WHERE code = 'B46B20B'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619020828; 430i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'coolant', (SELECT id FROM engines WHERE code = 'B46B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619020828; 430i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'transmission_at', (SELECT id FROM engines WHERE code = 'B46B20B'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_619020828; 430i, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'engine_oil', (SELECT id FROM engines WHERE code = 'B46B20B'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619020828; 430i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'coolant', (SELECT id FROM engines WHERE code = 'B46B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619020828; 430i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'transmission_at', (SELECT id FROM engines WHERE code = 'B46B20B'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_619020828; 430i, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 218, 'engine_oil', (SELECT id FROM engines WHERE code = 'B46B20B'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619020828; 430i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 218 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 218, 'coolant', (SELECT id FROM engines WHERE code = 'B46B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619020828; 430i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 218 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 218, 'transmission_at', (SELECT id FROM engines WHERE code = 'B46B20B'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_619020828; 430i, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 218 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 220, 'engine_oil', (SELECT id FROM engines WHERE code = 'B46B20B'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619020828; 430i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 220 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 220, 'coolant', (SELECT id FROM engines WHERE code = 'B46B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619020828; 430i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 220 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 220, 'transmission_at', (SELECT id FROM engines WHERE code = 'B46B20B'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_619020828; 430i, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 220 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 222, 'engine_oil', (SELECT id FROM engines WHERE code = 'B46B20B'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619020828; 430i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 222 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 222, 'coolant', (SELECT id FROM engines WHERE code = 'B46B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619020828; 430i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 222 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 222, 'transmission_at', (SELECT id FROM engines WHERE code = 'B46B20B'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_619020828; 430i, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 222 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B20B'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_319000506; 430i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'coolant', (SELECT id FROM engines WHERE code = 'B48B20B'), 8, 8.45, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319000506; 430i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B48B20B'), 1.3, 1.37, NULL, 'MTF LT3', 'HaynesPro typeId t_319000506; 430i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B20B'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_319000506; 430i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'coolant', (SELECT id FROM engines WHERE code = 'B48B20B'), 8, 8.45, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319000506; 430i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B48B20B'), 1.3, 1.37, NULL, 'MTF LT3', 'HaynesPro typeId t_319000506; 430i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B20B'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_319000506; 430i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'coolant', (SELECT id FROM engines WHERE code = 'B48B20B'), 8, 8.45, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319000506; 430i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B48B20B'), 1.3, 1.37, NULL, 'MTF LT3', 'HaynesPro typeId t_319000506; 430i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 218, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B20B'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_319000506; 430i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 218 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 218, 'coolant', (SELECT id FROM engines WHERE code = 'B48B20B'), 8, 8.45, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319000506; 430i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 218 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 218, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B48B20B'), 1.3, 1.37, NULL, 'MTF LT3', 'HaynesPro typeId t_319000506; 430i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 218 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 220, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B20B'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_319000506; 430i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 220 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 220, 'coolant', (SELECT id FROM engines WHERE code = 'B48B20B'), 8, 8.45, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319000506; 430i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 220 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 220, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B48B20B'), 1.3, 1.37, NULL, 'MTF LT3', 'HaynesPro typeId t_319000506; 430i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 220 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 222, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B20B'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_319000506; 430i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 222 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 222, 'coolant', (SELECT id FROM engines WHERE code = 'B48B20B'), 8, 8.45, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319000506; 430i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 222 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 222, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B48B20B'), 1.3, 1.37, NULL, 'MTF LT3', 'HaynesPro typeId t_319000506; 430i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 222 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30B'), 6.5, 6.87, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_301001185; 435d, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30B'), 7.2, 7.61, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_301001185; 435d, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'transmission_at', (SELECT id FROM engines WHERE code = 'N57D30B'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_301001185; 435d, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30B'), 6.5, 6.87, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_301001185; 435d, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30B'), 7.2, 7.61, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_301001185; 435d, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'transmission_at', (SELECT id FROM engines WHERE code = 'N57D30B'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_301001185; 435d, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30B'), 6.5, 6.87, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_301001185; 435d, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30B'), 7.2, 7.61, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_301001185; 435d, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'transmission_at', (SELECT id FROM engines WHERE code = 'N57D30B'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_301001185; 435d, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 218, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30B'), 6.5, 6.87, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_301001185; 435d, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 218 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 218, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30B'), 7.2, 7.61, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_301001185; 435d, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 218 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 218, 'transmission_at', (SELECT id FROM engines WHERE code = 'N57D30B'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_301001185; 435d, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 218 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 220, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30B'), 6.5, 6.87, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_301001185; 435d, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 220 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 220, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30B'), 7.2, 7.61, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_301001185; 435d, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 220 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 220, 'transmission_at', (SELECT id FROM engines WHERE code = 'N57D30B'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_301001185; 435d, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 220 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 222, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30B'), 6.5, 6.87, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_301001185; 435d, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 222 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 222, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30B'), 7.2, 7.61, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_301001185; 435d, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 222 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 222, 'transmission_at', (SELECT id FROM engines WHERE code = 'N57D30B'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_301001185; 435d, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 222 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'engine_oil', (SELECT id FROM engines WHERE code = 'N55B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_619025288; 435i M Performance; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'coolant', (SELECT id FROM engines WHERE code = 'N55B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619025288; 435i M Performance'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N55B30A'), 1.2, 1.27, NULL, 'SAE 75W-80', 'HaynesPro typeId t_619025288; 435i M Performance; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'engine_oil', (SELECT id FROM engines WHERE code = 'N55B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_619025288; 435i M Performance; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'coolant', (SELECT id FROM engines WHERE code = 'N55B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619025288; 435i M Performance'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N55B30A'), 1.2, 1.27, NULL, 'SAE 75W-80', 'HaynesPro typeId t_619025288; 435i M Performance; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'engine_oil', (SELECT id FROM engines WHERE code = 'N55B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_619025288; 435i M Performance; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'coolant', (SELECT id FROM engines WHERE code = 'N55B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619025288; 435i M Performance'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N55B30A'), 1.2, 1.27, NULL, 'SAE 75W-80', 'HaynesPro typeId t_619025288; 435i M Performance; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 218, 'engine_oil', (SELECT id FROM engines WHERE code = 'N55B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_619025288; 435i M Performance; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 218 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 218, 'coolant', (SELECT id FROM engines WHERE code = 'N55B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619025288; 435i M Performance'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 218 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 218, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N55B30A'), 1.2, 1.27, NULL, 'SAE 75W-80', 'HaynesPro typeId t_619025288; 435i M Performance; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 218 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 220, 'engine_oil', (SELECT id FROM engines WHERE code = 'N55B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_619025288; 435i M Performance; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 220 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 220, 'coolant', (SELECT id FROM engines WHERE code = 'N55B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619025288; 435i M Performance'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 220 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 220, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N55B30A'), 1.2, 1.27, NULL, 'SAE 75W-80', 'HaynesPro typeId t_619025288; 435i M Performance; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 220 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 222, 'engine_oil', (SELECT id FROM engines WHERE code = 'N55B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_619025288; 435i M Performance; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 222 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 222, 'coolant', (SELECT id FROM engines WHERE code = 'N55B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619025288; 435i M Performance'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 222 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 222, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N55B30A'), 1.2, 1.27, NULL, 'SAE 75W-80', 'HaynesPro typeId t_619025288; 435i M Performance; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 222 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'engine_oil', (SELECT id FROM engines WHERE code = 'B58B30A'), 6.5, 6.87, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_319000780; 440i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'coolant', (SELECT id FROM engines WHERE code = 'B58B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319000780; 440i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B58B30A'), 1.2, 1.27, NULL, 'SAE 75W-80', 'HaynesPro typeId t_319000780; 440i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'engine_oil', (SELECT id FROM engines WHERE code = 'B58B30A'), 6.5, 6.87, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_319000780; 440i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'coolant', (SELECT id FROM engines WHERE code = 'B58B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319000780; 440i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B58B30A'), 1.2, 1.27, NULL, 'SAE 75W-80', 'HaynesPro typeId t_319000780; 440i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'engine_oil', (SELECT id FROM engines WHERE code = 'B58B30A'), 6.5, 6.87, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_319000780; 440i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'coolant', (SELECT id FROM engines WHERE code = 'B58B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319000780; 440i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B58B30A'), 1.2, 1.27, NULL, 'SAE 75W-80', 'HaynesPro typeId t_319000780; 440i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 218, 'engine_oil', (SELECT id FROM engines WHERE code = 'B58B30A'), 6.5, 6.87, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_319000780; 440i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 218 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 218, 'coolant', (SELECT id FROM engines WHERE code = 'B58B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319000780; 440i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 218 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 218, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B58B30A'), 1.2, 1.27, NULL, 'SAE 75W-80', 'HaynesPro typeId t_319000780; 440i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 218 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 220, 'engine_oil', (SELECT id FROM engines WHERE code = 'B58B30A'), 6.5, 6.87, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_319000780; 440i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 220 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 220, 'coolant', (SELECT id FROM engines WHERE code = 'B58B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319000780; 440i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 220 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 220, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B58B30A'), 1.2, 1.27, NULL, 'SAE 75W-80', 'HaynesPro typeId t_319000780; 440i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 220 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 222, 'engine_oil', (SELECT id FROM engines WHERE code = 'B58B30A'), 6.5, 6.87, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_319000780; 440i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 222 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 222, 'coolant', (SELECT id FROM engines WHERE code = 'B58B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319000780; 440i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 222 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 222, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B58B30A'), 1.2, 1.27, NULL, 'SAE 75W-80', 'HaynesPro typeId t_319000780; 440i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 222 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 223, 'engine_oil', (SELECT id FROM engines WHERE code = 'S55B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_305000606; M4; drain 20 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 223 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 223, 'coolant', (SELECT id FROM engines WHERE code = 'S55B30A'), 13.9, 14.69, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_305000606; M4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 223 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 223, 'transmission_mt', (SELECT id FROM engines WHERE code = 'S55B30A'), 1.2, 1.27, NULL, 'SAE 75W-140', 'HaynesPro typeId t_305000606; M4; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 223 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'S55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 224, 'engine_oil', (SELECT id FROM engines WHERE code = 'S55B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_305000606; M4; drain 20 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 224 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 224, 'coolant', (SELECT id FROM engines WHERE code = 'S55B30A'), 13.9, 14.69, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_305000606; M4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 224 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 224, 'transmission_mt', (SELECT id FROM engines WHERE code = 'S55B30A'), 1.2, 1.27, NULL, 'SAE 75W-140', 'HaynesPro typeId t_305000606; M4; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 224 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'S55B30A'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 217, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_301000031;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 217 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 219, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_301000031;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 219 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 221, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_301000031;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 221 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 218, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_301000031;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 218 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 220, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_301000031;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 220 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 222, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_301000031;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 222 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 223, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_301000031;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 223 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 224, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_301000031;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 224 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (217, 219, 221, 218, 220, 222, 223, 224)
  AND e.code IN ('N47D20C', 'B47D20A', 'B38B15A', 'N20B20B', 'N20B20A', 'B48B20A', 'N47D20D', 'B47D20B', 'N26B20A', 'N57D30A', 'B46B20B', 'B48B20B', 'N57D30B', 'N55B30A', 'B58B30A', 'S55B30A')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (217, 219, 221, 218, 220, 222, 223, 224)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (217, 219, 221, 218, 220, 222, 223, 224) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;