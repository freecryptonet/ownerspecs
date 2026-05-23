-- mig 262 — multi-gen HaynesPro ingest: BMW 1 (F20, F21)
-- crawl: haynespro-crawl-bmw-1-f20-2026-05-23.json
-- modelId: d_102000239
-- 13 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — BMW 1 (F20, F21)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_102000239', NOW(), 'Multi-gen ingest, 13 engines across 2 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_102000239' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('N47D16A', '114d (N47D16A) 70kW', 1598, 'diesel', 'NA', NULL),
  ('B37D15A', '114d (B37D15A) 70kW', 1496, 'petrol', 'NA', NULL),
  ('N13B16A', '114i (N13B16A) 75kW', 1598, 'petrol', 'NA', NULL),
  ('N47D20C', '116d (N47D20C) 85kW', 1995, 'diesel', 'NA', NULL),
  ('B38B15A', '116i (B38B15A) 80kW', 1499, 'petrol', 'NA', NULL),
  ('B47D20A', '118d (B47D20A) 100kW', 1995, 'diesel', 'turbo', NULL),
  ('B48B20A', '120i (B48B20A) 135kW', 1998, 'petrol', 'turbo', NULL),
  ('N47D20D', '125d (N47D20D) 160kW', 1995, 'diesel', 'NA', NULL),
  ('B47D20B', '125d (B47D20B) 165kW', 1995, 'diesel', 'turbo', NULL),
  ('N20B20A', '125i (N20B20A) 160kW', 1997, 'petrol', 'turbo', NULL),
  ('B48B20B', '125i (B48B20B) 165kW', 1998, 'petrol', 'turbo', NULL),
  ('N55B30A', 'M135i, -xDrive (N55B30A) 235kW', 2979, 'petrol', 'turbo', NULL),
  ('B58B30A', 'M140i, -xDrive (B58B30A) 250kW', 2998, 'petrol', 'turbo', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 197, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D16A'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_301000325; 114d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 197 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 197, 'coolant', (SELECT id FROM engines WHERE code = 'N47D16A'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_301000325; 114d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 197 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 197, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D16A'), 1.3, 1.37, NULL, 'BMW Hypoid Axle Oil G3', 'HaynesPro typeId t_301000325; 114d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 197 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 198, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D16A'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_301000325; 114d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 198 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 198, 'coolant', (SELECT id FROM engines WHERE code = 'N47D16A'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_301000325; 114d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 198 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 198, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D16A'), 1.3, 1.37, NULL, 'BMW Hypoid Axle Oil G3', 'HaynesPro typeId t_301000325; 114d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 198 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 197, 'engine_oil', (SELECT id FROM engines WHERE code = 'B37D15A'), 4.4, 4.65, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_318011898; 114d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 197 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B37D15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 197, 'coolant', (SELECT id FROM engines WHERE code = 'B37D15A'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_318011898; 114d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 197 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B37D15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 197, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B37D15A'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_318011898; 114d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 197 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B37D15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 198, 'engine_oil', (SELECT id FROM engines WHERE code = 'B37D15A'), 4.4, 4.65, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_318011898; 114d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 198 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B37D15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 198, 'coolant', (SELECT id FROM engines WHERE code = 'B37D15A'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_318011898; 114d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 198 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B37D15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 198, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B37D15A'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_318011898; 114d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 198 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B37D15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 197, 'engine_oil', (SELECT id FROM engines WHERE code = 'N13B16A'), 4.2, 4.44, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_201000017; 114i; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 197 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N13B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 197, 'coolant', (SELECT id FROM engines WHERE code = 'N13B16A'), 6.7, 7.08, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_201000017; 114i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 197 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N13B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 197, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N13B16A'), 1.3, 1.37, NULL, 'BMW Hypoid Axle Oil G3', 'HaynesPro typeId t_201000017; 114i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 197 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N13B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 198, 'engine_oil', (SELECT id FROM engines WHERE code = 'N13B16A'), 4.2, 4.44, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_201000017; 114i; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 198 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N13B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 198, 'coolant', (SELECT id FROM engines WHERE code = 'N13B16A'), 6.7, 7.08, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_201000017; 114i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 198 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N13B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 198, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N13B16A'), 1.3, 1.37, NULL, 'BMW Hypoid Axle Oil G3', 'HaynesPro typeId t_201000017; 114i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 198 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N13B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 197, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20C'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_300000158; 116d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 197 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 197, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20C'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_300000158; 116d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 197 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 197, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20C'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_300000158; 116d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 197 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 197, 'engine_oil', (SELECT id FROM engines WHERE code = 'B38B15A'), 4.25, 4.49, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_313000068; 116i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 197 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B38B15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 197, 'coolant', (SELECT id FROM engines WHERE code = 'B38B15A'), 7.7, 8.14, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_313000068; 116i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 197 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B38B15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 197, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B38B15A'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_313000068; 116i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 197 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B38B15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 198, 'engine_oil', (SELECT id FROM engines WHERE code = 'B38B15A'), 4.25, 4.49, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_313000068; 116i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 198 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B38B15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 198, 'coolant', (SELECT id FROM engines WHERE code = 'B38B15A'), 7.7, 8.14, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_313000068; 116i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 198 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B38B15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 198, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B38B15A'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_313000068; 116i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 198 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B38B15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 197, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47D20A'), 5, 5.28, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_619031696; 118d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 197 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 197, 'coolant', (SELECT id FROM engines WHERE code = 'B47D20A'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619031696; 118d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 197 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 197, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B47D20A'), 1.3, 1.37, NULL, 'SAE 75W-80', 'HaynesPro typeId t_619031696; 118d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 197 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 198, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47D20A'), 5, 5.28, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_619031696; 118d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 198 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 198, 'coolant', (SELECT id FROM engines WHERE code = 'B47D20A'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619031696; 118d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 198 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 198, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B47D20A'), 1.3, 1.37, NULL, 'SAE 75W-80', 'HaynesPro typeId t_619031696; 118d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 198 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 198, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B20A'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_319001025; 120i; drain 20 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 198 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 198, 'coolant', (SELECT id FROM engines WHERE code = 'B48B20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319001025; 120i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 198 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 198, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B48B20A'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_319001025; 120i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 198 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 197, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20D'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_200000330; 125d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 197 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 197, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20D'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_200000330; 125d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 197 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 197, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20D'), 1.2, 1.27, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_200000330; 125d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 197 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 197, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47D20B'), 5, 5.28, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_317000535; 125d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 197 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 197, 'coolant', (SELECT id FROM engines WHERE code = 'B47D20B'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_317000535; 125d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 197 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 197, 'transmission_at', (SELECT id FROM engines WHERE code = 'B47D20B'), NULL, NULL, NULL, 'BMW Hypoid Axle Oil G3', 'HaynesPro typeId t_317000535; 125d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 197 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 198, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47D20B'), 5, 5.28, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_317000535; 125d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 198 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 198, 'coolant', (SELECT id FROM engines WHERE code = 'B47D20B'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_317000535; 125d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 198 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 198, 'transmission_at', (SELECT id FROM engines WHERE code = 'B47D20B'), NULL, NULL, NULL, 'BMW Hypoid Axle Oil G3', 'HaynesPro typeId t_317000535; 125d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 198 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 197, 'engine_oil', (SELECT id FROM engines WHERE code = 'N20B20A'), 5, 5.28, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_200000328; 125i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 197 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 197, 'coolant', (SELECT id FROM engines WHERE code = 'N20B20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_200000328; 125i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 197 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 197, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N20B20A'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_200000328; 125i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 197 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 198, 'engine_oil', (SELECT id FROM engines WHERE code = 'N20B20A'), 5, 5.28, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_200000328; 125i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 198 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 198, 'coolant', (SELECT id FROM engines WHERE code = 'N20B20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_200000328; 125i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 198 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 198, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N20B20A'), 1.3, 1.37, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_200000328; 125i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 198 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 198, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B20B'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_319001038; 125i; drain 20 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 198 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 198, 'coolant', (SELECT id FROM engines WHERE code = 'B48B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319001038; 125i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 198 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 198, 'transmission_at', (SELECT id FROM engines WHERE code = 'B48B20B'), NULL, NULL, NULL, 'BMW Hypoid Axle Oil G3', 'HaynesPro typeId t_319001038; 125i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 198 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 197, 'engine_oil', (SELECT id FROM engines WHERE code = 'N55B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_201000043; M135i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 197 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 197, 'coolant', (SELECT id FROM engines WHERE code = 'N55B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_201000043; M135i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 197 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 197, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N55B30A'), 1.2, 1.27, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_201000043; M135i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 197 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 198, 'engine_oil', (SELECT id FROM engines WHERE code = 'N55B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_201000043; M135i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 198 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 198, 'coolant', (SELECT id FROM engines WHERE code = 'N55B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_201000043; M135i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 198 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 198, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N55B30A'), 1.2, 1.27, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_201000043; M135i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 198 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 198, 'engine_oil', (SELECT id FROM engines WHERE code = 'B58B30A'), 6.5, 6.87, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_319001043; M140i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 198 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 198, 'coolant', (SELECT id FROM engines WHERE code = 'B58B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319001043; M140i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 198 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 198, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B58B30A'), 1.2, 1.27, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_319001043; M140i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 198 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30A'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 197, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_102000239;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 197 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 198, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_102000239;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 198 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (197, 198)
  AND e.code IN ('N47D16A', 'B37D15A', 'N13B16A', 'N47D20C', 'B38B15A', 'B47D20A', 'B48B20A', 'N47D20D', 'B47D20B', 'N20B20A', 'B48B20B', 'N55B30A', 'B58B30A')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (197, 198)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (197, 198) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;