-- mig 254 — multi-gen HaynesPro ingest: BMW 5 (F10, F11, F18)
-- crawl: haynespro-crawl-bmw-5-f10-2026-05-23.json
-- modelId: d_102000140
-- 17 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — BMW 5 (F10, F11, F18)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_102000140', NOW(), 'Multi-gen ingest, 17 engines across 5 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_102000140' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('N47D20C', '518d (N47D20C) 105kW', 1995, 'diesel', 'NA', NULL),
  ('B47D20A', '518d (B47D20A) 120kW', 1995, 'diesel', 'turbo', NULL),
  ('N20B20B', '520i (N20B20B) 135kW', 1997, 'petrol', 'turbo', NULL),
  ('N20B20A', '520i (N20B20A) 120kW', 1997, 'petrol', 'turbo', NULL),
  ('N20B20D', '520i (N20B20D) 135kW', 1997, 'petrol', 'turbo', NULL),
  ('N20B16A', '520i (N20B16A) 125kW', 1592, 'petrol', 'turbo', NULL),
  ('N52B25A', '523i (N52B25A) 150kW', 2497, 'petrol', 'NA', NULL),
  ('N53B30A', '523i (N53B30A) 150kW', 2996, 'petrol', 'NA', NULL),
  ('N57D30A', '525d (N57D30A) 150kW', 2993, 'diesel', 'NA', NULL),
  ('N47D20D', '525d, -xDrive (N47D20D) 160kW', 1995, 'diesel', 'NA', NULL),
  ('N52B30A', '528i (N52B30A) 190kW', 2996, 'petrol', 'NA', NULL),
  ('N57D30B', '535d (N57D30B) 220kW', 2993, 'diesel', 'NA', NULL),
  ('N55B30A', '535i, -xDrive (N55B30A) 225kW', 2979, 'petrol', 'turbo', NULL),
  ('N63B44A', '550i, -xDrive (N63B44A) 300kW', 4395, 'petrol', 'turbo', NULL),
  ('N63B44B', '550i, -xDrive (N63B44B) 330kW', 4395, 'petrol', 'turbo', NULL),
  ('S63B44B', 'M5 (S63B44B) 412kW', 4395, 'petrol', 'turbo', NULL),
  ('N57D30C', 'M550d xDrive (N57D30C) 280kW', 2993, 'diesel', 'NA', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20C'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_301000797; 518d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20C'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_301000797; 518d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20C'), 1.2, 1.27, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_301000797; 518d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20C'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_301000797; 518d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20C'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_301000797; 518d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20C'), 1.2, 1.27, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_301000797; 518d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20C'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_301000797; 518d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20C'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_301000797; 518d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20C'), 1.2, 1.27, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_301000797; 518d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20C'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_301000797; 518d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20C'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_301000797; 518d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20C'), 1.2, 1.27, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_301000797; 518d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47D20A'), 5, 5.28, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_619143288; 518d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'coolant', (SELECT id FROM engines WHERE code = 'B47D20A'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619143288; 518d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B47D20A'), 1.2, 1.27, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_619143288; 518d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47D20A'), 5, 5.28, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_619143288; 518d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'coolant', (SELECT id FROM engines WHERE code = 'B47D20A'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619143288; 518d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B47D20A'), 1.2, 1.27, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_619143288; 518d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'engine_oil', (SELECT id FROM engines WHERE code = 'N20B20B'), 5, 5.28, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_200000068; 520i; drain 8 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'coolant', (SELECT id FROM engines WHERE code = 'N20B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_200000068; 520i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N20B20B'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_200000068; 520i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'engine_oil', (SELECT id FROM engines WHERE code = 'N20B20B'), 5, 5.28, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_200000068; 520i; drain 8 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'coolant', (SELECT id FROM engines WHERE code = 'N20B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_200000068; 520i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N20B20B'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_200000068; 520i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'engine_oil', (SELECT id FROM engines WHERE code = 'N20B20B'), 5, 5.28, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_200000068; 520i; drain 8 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'coolant', (SELECT id FROM engines WHERE code = 'N20B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_200000068; 520i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N20B20B'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_200000068; 520i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'engine_oil', (SELECT id FROM engines WHERE code = 'N20B20B'), 5, 5.28, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_200000068; 520i; drain 8 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'coolant', (SELECT id FROM engines WHERE code = 'N20B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_200000068; 520i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N20B20B'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_200000068; 520i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'engine_oil', (SELECT id FROM engines WHERE code = 'N20B20A'), 5, 5.28, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619032596; 520i; drain 8 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'coolant', (SELECT id FROM engines WHERE code = 'N20B20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619032596; 520i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N20B20A'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_619032596; 520i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'engine_oil', (SELECT id FROM engines WHERE code = 'N20B20A'), 5, 5.28, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619032596; 520i; drain 8 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'coolant', (SELECT id FROM engines WHERE code = 'N20B20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619032596; 520i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N20B20A'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_619032596; 520i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'engine_oil', (SELECT id FROM engines WHERE code = 'N20B20A'), 5, 5.28, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619032596; 520i; drain 8 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'coolant', (SELECT id FROM engines WHERE code = 'N20B20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619032596; 520i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N20B20A'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_619032596; 520i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'engine_oil', (SELECT id FROM engines WHERE code = 'N20B20A'), 5, 5.28, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619032596; 520i; drain 8 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'coolant', (SELECT id FROM engines WHERE code = 'N20B20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619032596; 520i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N20B20A'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_619032596; 520i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'engine_oil', (SELECT id FROM engines WHERE code = 'N20B20D'), 5, 5.28, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619032597; 520i; drain 8 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'coolant', (SELECT id FROM engines WHERE code = 'N20B20D'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619032597; 520i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N20B20D'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_619032597; 520i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'engine_oil', (SELECT id FROM engines WHERE code = 'N20B20D'), 5, 5.28, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619032597; 520i; drain 8 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'coolant', (SELECT id FROM engines WHERE code = 'N20B20D'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619032597; 520i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N20B20D'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_619032597; 520i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'engine_oil', (SELECT id FROM engines WHERE code = 'N20B20D'), 5, 5.28, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619032597; 520i; drain 8 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'coolant', (SELECT id FROM engines WHERE code = 'N20B20D'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619032597; 520i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N20B20D'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_619032597; 520i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'engine_oil', (SELECT id FROM engines WHERE code = 'N20B20D'), 5, 5.28, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619032597; 520i; drain 8 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'coolant', (SELECT id FROM engines WHERE code = 'N20B20D'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619032597; 520i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N20B20D'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_619032597; 520i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'engine_oil', (SELECT id FROM engines WHERE code = 'N20B16A'), 5, 5.28, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_319001050; 520i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'coolant', (SELECT id FROM engines WHERE code = 'N20B16A'), 9.9, 10.46, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319001050; 520i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'transmission_at', (SELECT id FROM engines WHERE code = 'N20B16A'), 1.3, 1.37, NULL, 'MTF LT3', 'HaynesPro typeId t_319001050; 520i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'engine_oil', (SELECT id FROM engines WHERE code = 'N20B16A'), 5, 5.28, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_319001050; 520i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'coolant', (SELECT id FROM engines WHERE code = 'N20B16A'), 9.9, 10.46, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319001050; 520i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'transmission_at', (SELECT id FROM engines WHERE code = 'N20B16A'), 1.3, 1.37, NULL, 'MTF LT3', 'HaynesPro typeId t_319001050; 520i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'engine_oil', (SELECT id FROM engines WHERE code = 'N20B16A'), 5, 5.28, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_319001050; 520i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'coolant', (SELECT id FROM engines WHERE code = 'N20B16A'), 9.9, 10.46, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319001050; 520i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'transmission_at', (SELECT id FROM engines WHERE code = 'N20B16A'), 1.3, 1.37, NULL, 'MTF LT3', 'HaynesPro typeId t_319001050; 520i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'engine_oil', (SELECT id FROM engines WHERE code = 'N20B16A'), 5, 5.28, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_319001050; 520i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'coolant', (SELECT id FROM engines WHERE code = 'N20B16A'), 9.9, 10.46, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319001050; 520i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'transmission_at', (SELECT id FROM engines WHERE code = 'N20B16A'), 1.3, 1.37, NULL, 'MTF LT3', 'HaynesPro typeId t_319001050; 520i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B25A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_102001349; 523i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'coolant', (SELECT id FROM engines WHERE code = 'N52B25A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001349; 523i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'transmission_at', (SELECT id FROM engines WHERE code = 'N52B25A'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_102001349; 523i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B25A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_102001349; 523i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'coolant', (SELECT id FROM engines WHERE code = 'N52B25A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001349; 523i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'transmission_at', (SELECT id FROM engines WHERE code = 'N52B25A'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_102001349; 523i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'engine_oil', (SELECT id FROM engines WHERE code = 'N53B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_102001362; 523i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'coolant', (SELECT id FROM engines WHERE code = 'N53B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001362; 523i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N53B30A'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_102001362; 523i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'engine_oil', (SELECT id FROM engines WHERE code = 'N53B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_102001362; 523i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'coolant', (SELECT id FROM engines WHERE code = 'N53B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001362; 523i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N53B30A'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_102001362; 523i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'engine_oil', (SELECT id FROM engines WHERE code = 'N53B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_102001362; 523i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'coolant', (SELECT id FROM engines WHERE code = 'N53B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001362; 523i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N53B30A'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_102001362; 523i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'engine_oil', (SELECT id FROM engines WHERE code = 'N53B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_102001362; 523i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'coolant', (SELECT id FROM engines WHERE code = 'N53B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001362; 523i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N53B30A'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_102001362; 523i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30A'), 7, 7.4, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102001356; 525d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30A'), 8, 8.45, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001356; 525d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N57D30A'), 1.2, 1.27, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_102001356; 525d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30A'), 7, 7.4, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102001356; 525d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30A'), 8, 8.45, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001356; 525d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N57D30A'), 1.2, 1.27, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_102001356; 525d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30A'), 7, 7.4, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102001356; 525d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30A'), 8, 8.45, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001356; 525d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N57D30A'), 1.2, 1.27, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_102001356; 525d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30A'), 7, 7.4, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102001356; 525d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30A'), 8, 8.45, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001356; 525d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N57D30A'), 1.2, 1.27, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_102001356; 525d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20D'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_200000067; 525d, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20D'), 8, 8.45, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_200000067; 525d, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20D'), 1.2, 1.27, NULL, 'SAE 75W-80', 'HaynesPro typeId t_200000067; 525d, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20D'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_200000067; 525d, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20D'), 8, 8.45, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_200000067; 525d, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20D'), 1.2, 1.27, NULL, 'SAE 75W-80', 'HaynesPro typeId t_200000067; 525d, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20D'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_200000067; 525d, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20D'), 8, 8.45, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_200000067; 525d, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20D'), 1.2, 1.27, NULL, 'SAE 75W-80', 'HaynesPro typeId t_200000067; 525d, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20D'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_200000067; 525d, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20D'), 8, 8.45, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_200000067; 525d, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20D'), 1.2, 1.27, NULL, 'SAE 75W-80', 'HaynesPro typeId t_200000067; 525d, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_619032599; 528i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'coolant', (SELECT id FROM engines WHERE code = 'N52B30A'), 9, 9.51, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619032599; 528i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'transmission_at', (SELECT id FROM engines WHERE code = 'N52B30A'), NULL, NULL, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619032599; 528i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_619032599; 528i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'coolant', (SELECT id FROM engines WHERE code = 'N52B30A'), 9, 9.51, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619032599; 528i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'transmission_at', (SELECT id FROM engines WHERE code = 'N52B30A'), NULL, NULL, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619032599; 528i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_619032599; 528i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'coolant', (SELECT id FROM engines WHERE code = 'N52B30A'), 9, 9.51, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619032599; 528i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'transmission_at', (SELECT id FROM engines WHERE code = 'N52B30A'), NULL, NULL, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619032599; 528i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_619032599; 528i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'coolant', (SELECT id FROM engines WHERE code = 'N52B30A'), 9, 9.51, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619032599; 528i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'transmission_at', (SELECT id FROM engines WHERE code = 'N52B30A'), NULL, NULL, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619032599; 528i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30B'), 7, 7.4, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102001978; 535d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30B'), 8, 8.45, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001978; 535d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'transmission_at', (SELECT id FROM engines WHERE code = 'N57D30B'), NULL, NULL, NULL, 'BMW Hypoid Axle Oil G1', 'HaynesPro typeId t_102001978; 535d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30B'), 7, 7.4, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102001978; 535d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30B'), 8, 8.45, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001978; 535d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'transmission_at', (SELECT id FROM engines WHERE code = 'N57D30B'), NULL, NULL, NULL, 'BMW Hypoid Axle Oil G1', 'HaynesPro typeId t_102001978; 535d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30B'), 7, 7.4, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102001978; 535d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30B'), 8, 8.45, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001978; 535d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'transmission_at', (SELECT id FROM engines WHERE code = 'N57D30B'), NULL, NULL, NULL, 'BMW Hypoid Axle Oil G1', 'HaynesPro typeId t_102001978; 535d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30B'), 7, 7.4, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102001978; 535d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30B'), 8, 8.45, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001978; 535d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'transmission_at', (SELECT id FROM engines WHERE code = 'N57D30B'), NULL, NULL, NULL, 'BMW Hypoid Axle Oil G1', 'HaynesPro typeId t_102001978; 535d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'engine_oil', (SELECT id FROM engines WHERE code = 'N55B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_102001355; 535i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'coolant', (SELECT id FROM engines WHERE code = 'N55B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001355; 535i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N55B30A'), 1.2, 1.27, NULL, 'SAE 75W-80', 'HaynesPro typeId t_102001355; 535i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'engine_oil', (SELECT id FROM engines WHERE code = 'N55B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_102001355; 535i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'coolant', (SELECT id FROM engines WHERE code = 'N55B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001355; 535i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N55B30A'), 1.2, 1.27, NULL, 'SAE 75W-80', 'HaynesPro typeId t_102001355; 535i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'engine_oil', (SELECT id FROM engines WHERE code = 'N55B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_102001355; 535i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'coolant', (SELECT id FROM engines WHERE code = 'N55B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001355; 535i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N55B30A'), 1.2, 1.27, NULL, 'SAE 75W-80', 'HaynesPro typeId t_102001355; 535i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'engine_oil', (SELECT id FROM engines WHERE code = 'N55B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_102001355; 535i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'coolant', (SELECT id FROM engines WHERE code = 'N55B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001355; 535i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N55B30A'), 1.2, 1.27, NULL, 'SAE 75W-80', 'HaynesPro typeId t_102001355; 535i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'engine_oil', (SELECT id FROM engines WHERE code = 'N63B44A'), 8.5, 8.98, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102001353; 550i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'coolant', (SELECT id FROM engines WHERE code = 'N63B44A'), 11.4, 12.05, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001353; 550i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N63B44A'), 1.6, 1.69, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_102001353; 550i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'engine_oil', (SELECT id FROM engines WHERE code = 'N63B44A'), 8.5, 8.98, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102001353; 550i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'coolant', (SELECT id FROM engines WHERE code = 'N63B44A'), 11.4, 12.05, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001353; 550i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N63B44A'), 1.6, 1.69, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_102001353; 550i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'engine_oil', (SELECT id FROM engines WHERE code = 'N63B44A'), 8.5, 8.98, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102001353; 550i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'coolant', (SELECT id FROM engines WHERE code = 'N63B44A'), 11.4, 12.05, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001353; 550i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N63B44A'), 1.6, 1.69, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_102001353; 550i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'engine_oil', (SELECT id FROM engines WHERE code = 'N63B44A'), 8.5, 8.98, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102001353; 550i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'coolant', (SELECT id FROM engines WHERE code = 'N63B44A'), 11.4, 12.05, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001353; 550i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N63B44A'), 1.6, 1.69, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_102001353; 550i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'engine_oil', (SELECT id FROM engines WHERE code = 'N63B44B'), 8.5, 8.98, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_301000798; 550i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'coolant', (SELECT id FROM engines WHERE code = 'N63B44B'), 11.4, 12.05, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_301000798; 550i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N63B44B'), 1.6, 1.69, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_301000798; 550i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'engine_oil', (SELECT id FROM engines WHERE code = 'N63B44B'), 8.5, 8.98, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_301000798; 550i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'coolant', (SELECT id FROM engines WHERE code = 'N63B44B'), 11.4, 12.05, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_301000798; 550i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N63B44B'), 1.6, 1.69, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_301000798; 550i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'engine_oil', (SELECT id FROM engines WHERE code = 'N63B44B'), 8.5, 8.98, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_301000798; 550i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'coolant', (SELECT id FROM engines WHERE code = 'N63B44B'), 11.4, 12.05, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_301000798; 550i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N63B44B'), 1.6, 1.69, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_301000798; 550i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'engine_oil', (SELECT id FROM engines WHERE code = 'N63B44B'), 8.5, 8.98, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_301000798; 550i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'coolant', (SELECT id FROM engines WHERE code = 'N63B44B'), 11.4, 12.05, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_301000798; 550i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N63B44B'), 1.6, 1.69, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_301000798; 550i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 176, 'engine_oil', (SELECT id FROM engines WHERE code = 'S63B44B'), 8.5, 8.98, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_200000134; M5; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 176 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 176, 'coolant', (SELECT id FROM engines WHERE code = 'S63B44B'), 18.5, 19.55, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_200000134; M5'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 176 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 176, 'transmission_dct', (SELECT id FROM engines WHERE code = 'S63B44B'), 8.6, 9.09, NULL, 'SAE 75W-140', 'HaynesPro typeId t_200000134; M5; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 176 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'S63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30C'), 6.5, 6.87, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_200000336; M550d xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30C'), 12.6, 13.31, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_200000336; M550d xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'transmission_at', (SELECT id FROM engines WHERE code = 'N57D30C'), NULL, NULL, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_200000336; M550d xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30C'), 6.5, 6.87, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_200000336; M550d xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30C'), 12.6, 13.31, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_200000336; M550d xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'transmission_at', (SELECT id FROM engines WHERE code = 'N57D30C'), NULL, NULL, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_200000336; M550d xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30C'), 6.5, 6.87, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_200000336; M550d xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30C'), 12.6, 13.31, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_200000336; M550d xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'transmission_at', (SELECT id FROM engines WHERE code = 'N57D30C'), NULL, NULL, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_200000336; M550d xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30C'), 6.5, 6.87, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_200000336; M550d xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30C'), 12.6, 13.31, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_200000336; M550d xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'transmission_at', (SELECT id FROM engines WHERE code = 'N57D30C'), NULL, NULL, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_200000336; M550d xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30C'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 172, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_102000140;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 172 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 174, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_102000140;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 174 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 173, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_102000140;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 173 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 175, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_102000140;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 175 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 176, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_102000140;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 176 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (172, 174, 173, 175, 176)
  AND e.code IN ('N47D20C', 'B47D20A', 'N20B20B', 'N20B20A', 'N20B20D', 'N20B16A', 'N52B25A', 'N53B30A', 'N57D30A', 'N47D20D', 'N52B30A', 'N57D30B', 'N55B30A', 'N63B44A', 'N63B44B', 'S63B44B', 'N57D30C')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (172, 174, 173, 175, 176)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (172, 174, 173, 175, 176) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;