-- mig 273 — multi-gen HaynesPro ingest: BMW 2 (F22, F23, F87)
-- crawl: haynespro-crawl-bmw-2-f22-2026-05-23.json
-- modelId: d_302000002
-- 12 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — BMW 2 (F22, F23, F87)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_302000002', NOW(), 'Multi-gen ingest, 12 engines across 3 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_302000002' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('N47D20C', '218d (N47D20C) 105kW', 1995, 'diesel', 'NA', NULL),
  ('B47D20A', '218d (B47D20A) 110kW', 1995, 'diesel', 'turbo', NULL),
  ('B38B15A', '218i (B38B15A) 100kW', 1499, 'petrol', 'NA', NULL),
  ('B48B20A', '218i (B48B20A) 100kW', 1998, 'petrol', 'turbo', NULL),
  ('N20B20B', '220i (N20B20B) 135kW', 1997, 'petrol', 'turbo', NULL),
  ('N47D20D', '225d (N47D20D) 160kW', 1995, 'diesel', 'NA', NULL),
  ('B47D20B', '225d (B47D20B) 165kW', 1995, 'diesel', 'turbo', NULL),
  ('N20B20A', '228i, -xDrive (N20B20A) 180kW', 1997, 'petrol', 'turbo', NULL),
  ('B48B20B', '230i (B48B20B) 185kW', 1998, 'petrol', 'turbo', NULL),
  ('N55B30A', 'M2 (N55B30A) 272kW', 2979, 'petrol', 'turbo', NULL),
  ('S55B30A', 'M2 CS (S55B30A) 331kW', 2979, 'petrol', 'turbo', NULL),
  ('B58B30A', 'M240i, -xDrive (B58B30A) 250kW', 2998, 'petrol', 'turbo', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 211, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20C'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_304000030; 218d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 211 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 211, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20C'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_304000030; 218d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 211 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 211, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20C'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_304000030; 218d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 211 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 212, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20C'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_304000030; 218d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 212 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 212, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20C'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_304000030; 218d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 212 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 212, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20C'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_304000030; 218d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 212 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 211, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47D20A'), 5, 5.28, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_318011900; 218d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 211 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 211, 'coolant', (SELECT id FROM engines WHERE code = 'B47D20A'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_318011900; 218d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 211 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 211, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B47D20A'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_318011900; 218d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 211 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 212, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47D20A'), 5, 5.28, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_318011900; 218d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 212 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 212, 'coolant', (SELECT id FROM engines WHERE code = 'B47D20A'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_318011900; 218d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 212 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 212, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B47D20A'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_318011900; 218d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 212 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 211, 'engine_oil', (SELECT id FROM engines WHERE code = 'B38B15A'), 4.25, 4.49, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_313000116; 218i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 211 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B38B15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 211, 'coolant', (SELECT id FROM engines WHERE code = 'B38B15A'), 7.7, 8.14, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_313000116; 218i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 211 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B38B15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 211, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B38B15A'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_313000116; 218i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 211 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B38B15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 212, 'engine_oil', (SELECT id FROM engines WHERE code = 'B38B15A'), 4.25, 4.49, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_313000116; 218i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 212 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B38B15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 212, 'coolant', (SELECT id FROM engines WHERE code = 'B38B15A'), 7.7, 8.14, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_313000116; 218i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 212 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B38B15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 212, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B38B15A'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_313000116; 218i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 212 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B38B15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 211, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B20A'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619036821; 218i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 211 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 211, 'coolant', (SELECT id FROM engines WHERE code = 'B48B20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619036821; 218i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 211 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 211, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B48B20A'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_619036821; 218i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 211 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 212, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B20A'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619036821; 218i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 212 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 212, 'coolant', (SELECT id FROM engines WHERE code = 'B48B20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619036821; 218i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 212 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 212, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B48B20A'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_619036821; 218i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 212 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 211, 'engine_oil', (SELECT id FROM engines WHERE code = 'N20B20B'), 5, 5.28, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_302000260; 220i; drain 8 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 211 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 211, 'coolant', (SELECT id FROM engines WHERE code = 'N20B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_302000260; 220i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 211 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 211, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N20B20B'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_302000260; 220i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 211 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 212, 'engine_oil', (SELECT id FROM engines WHERE code = 'N20B20B'), 5, 5.28, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_302000260; 220i; drain 8 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 212 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 212, 'coolant', (SELECT id FROM engines WHERE code = 'N20B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_302000260; 220i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 212 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 212, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N20B20B'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_302000260; 220i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 212 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 211, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20D'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_304000044; 225d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 211 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 211, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20D'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_304000044; 225d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 211 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 211, 'transmission_at', (SELECT id FROM engines WHERE code = 'N47D20D'), NULL, NULL, NULL, 'BMW Hypoid Axle Oil G3', 'HaynesPro typeId t_304000044; 225d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 211 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 212, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20D'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_304000044; 225d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 212 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 212, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20D'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_304000044; 225d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 212 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 212, 'transmission_at', (SELECT id FROM engines WHERE code = 'N47D20D'), NULL, NULL, NULL, 'BMW Hypoid Axle Oil G3', 'HaynesPro typeId t_304000044; 225d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 212 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 211, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47D20B'), 5, 5.28, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_318011902; 225d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 211 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 211, 'coolant', (SELECT id FROM engines WHERE code = 'B47D20B'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_318011902; 225d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 211 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 211, 'transmission_at', (SELECT id FROM engines WHERE code = 'B47D20B'), 1.3, 1.37, NULL, 'MTF LT3', 'HaynesPro typeId t_318011902; 225d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 211 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 212, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47D20B'), 5, 5.28, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_318011902; 225d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 212 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 212, 'coolant', (SELECT id FROM engines WHERE code = 'B47D20B'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_318011902; 225d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 212 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 212, 'transmission_at', (SELECT id FROM engines WHERE code = 'B47D20B'), 1.3, 1.37, NULL, 'MTF LT3', 'HaynesPro typeId t_318011902; 225d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 212 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 211, 'engine_oil', (SELECT id FROM engines WHERE code = 'N20B20A'), 5, 5.28, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_311000022; 228i, -xDrive; drain 8 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 211 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 211, 'coolant', (SELECT id FROM engines WHERE code = 'N20B20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_311000022; 228i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 211 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 211, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N20B20A'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_311000022; 228i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 211 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 212, 'engine_oil', (SELECT id FROM engines WHERE code = 'N20B20A'), 5, 5.28, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_311000022; 228i, -xDrive; drain 8 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 212 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 212, 'coolant', (SELECT id FROM engines WHERE code = 'N20B20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_311000022; 228i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 212 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 212, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N20B20A'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_311000022; 228i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 212 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 211, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B20B'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_319001037; 230i; drain 20 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 211 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 211, 'coolant', (SELECT id FROM engines WHERE code = 'B48B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319001037; 230i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 211 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 211, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B48B20B'), NULL, NULL, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_319001037; 230i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 211 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 212, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B20B'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_319001037; 230i; drain 20 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 212 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 212, 'coolant', (SELECT id FROM engines WHERE code = 'B48B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319001037; 230i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 212 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 212, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B48B20B'), NULL, NULL, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_319001037; 230i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 212 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 213, 'engine_oil', (SELECT id FROM engines WHERE code = 'N55B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_318011904; M2; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 213 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 213, 'coolant', (SELECT id FROM engines WHERE code = 'N55B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_318011904; M2'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 213 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 213, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N55B30A'), 1.2, 1.27, NULL, 'SAE 75W-140', 'HaynesPro typeId t_318011904; M2; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 213 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 211, 'engine_oil', (SELECT id FROM engines WHERE code = 'N55B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_318011904; M2; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 211 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 211, 'coolant', (SELECT id FROM engines WHERE code = 'N55B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_318011904; M2'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 211 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 211, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N55B30A'), 1.2, 1.27, NULL, 'SAE 75W-140', 'HaynesPro typeId t_318011904; M2; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 211 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 212, 'engine_oil', (SELECT id FROM engines WHERE code = 'N55B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_318011904; M2; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 212 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 212, 'coolant', (SELECT id FROM engines WHERE code = 'N55B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_318011904; M2'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 212 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 212, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N55B30A'), 1.2, 1.27, NULL, 'SAE 75W-140', 'HaynesPro typeId t_318011904; M2; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 212 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 213, 'engine_oil', (SELECT id FROM engines WHERE code = 'S55B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_619029194; M2 CS; drain 20 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 213 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 213, 'coolant', (SELECT id FROM engines WHERE code = 'S55B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619029194; M2 CS'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 213 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 213, 'transmission_mt', (SELECT id FROM engines WHERE code = 'S55B30A'), 1.6, 1.69, NULL, 'SAE 75W-140', 'HaynesPro typeId t_619029194; M2 CS; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 213 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'S55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 211, 'engine_oil', (SELECT id FROM engines WHERE code = 'B58B30A'), 6.2, 6.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_319001042; M240i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 211 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 211, 'coolant', (SELECT id FROM engines WHERE code = 'B58B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319001042; M240i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 211 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 211, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B58B30A'), 1.2, 1.27, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_319001042; M240i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 211 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 212, 'engine_oil', (SELECT id FROM engines WHERE code = 'B58B30A'), 6.2, 6.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_319001042; M240i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 212 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 212, 'coolant', (SELECT id FROM engines WHERE code = 'B58B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319001042; M240i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 212 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 212, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B58B30A'), 1.2, 1.27, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_319001042; M240i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 212 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30A'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 211, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_302000002;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 211 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 212, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_302000002;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 212 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 213, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_302000002;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 213 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (211, 212, 213)
  AND e.code IN ('N47D20C', 'B47D20A', 'B38B15A', 'B48B20A', 'N20B20B', 'N47D20D', 'B47D20B', 'N20B20A', 'B48B20B', 'N55B30A', 'S55B30A', 'B58B30A')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (211, 212, 213)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (211, 212, 213) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;