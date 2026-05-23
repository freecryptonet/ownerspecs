-- mig 259 — multi-gen HaynesPro ingest: BMW 5 (E60, E61)
-- crawl: haynespro-crawl-bmw-5-e60-2026-05-23.json
-- modelId: d_810
-- 22 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — BMW 5 (E60, E61)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_810', NOW(), 'Multi-gen ingest, 22 engines across 5 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_810' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('M47D20T2', '520d (M47D20T2) 120kW', 1995, 'diesel', 'NA', NULL),
  ('N47D20A', '520d (N47D20A) 130kW', 1995, 'diesel', 'NA', NULL),
  ('N47D20C', '520d (N47D20C) 130kW', 1995, 'diesel', 'NA', NULL),
  ('M54B22', '520i (M54B22) 125kW', 2171, 'petrol', 'NA', NULL),
  ('N46B20B', '520i (N46B20B) 115kW', 1995, 'petrol', 'NA', NULL),
  ('N43B20A', '520i (120/125 kW) (N43B20A) 125kW', 1995, 'petrol', 'NA', NULL),
  ('N52B25A', '523i (N52B25A) 140kW', 2497, 'petrol', 'NA', NULL),
  ('N53B25A', '523i, -LPG (N53B25A) 140kW', 2497, 'petrol', 'NA', NULL),
  ('M57D25TU', '525d (M57D25TU) 130kW', 2497, 'petrol', 'NA', NULL),
  ('M57D30 (306D3)', '525d (M57D30 (306D3)) 155kW', 2993, 'petrol', 'NA', NULL),
  ('M57D30T2', '525d, Xd (M57D30T2) 145kW', 2993, 'petrol', 'NA', NULL),
  ('M54B25', '525i, -LPG (M54B25) 141kW', 2494, 'petrol', 'NA', NULL),
  ('N53B30A', '525i, Xi (N53B30A) 160kW', 2996, 'petrol', 'NA', NULL),
  ('M57D30TU', '530d (M57D30TU) 160kW', 2993, 'petrol', 'NA', NULL),
  ('M54B30', '530i, -LPG (M54B30) 170kW', 2979, 'petrol', 'NA', NULL),
  ('N52B30A', '530i, Xi (N52B30A) 190kW', 2996, 'petrol', 'NA', NULL),
  ('M57D30TUTOP', '535d (M57D30TUTOP) 200kW', 2993, 'petrol', 'NA', NULL),
  ('M57D30T2TOP', '535d (M57D30T2TOP) 210kW', 2993, 'petrol', 'NA', NULL),
  ('N62B40A', '540i, -LPG (N62B40A) 225kW', 4000, 'petrol', 'NA', NULL),
  ('N62B44A', '545i, -LPG (N62B44A) 245kW', 4398, 'petrol', 'NA', NULL),
  ('N62B48B', '550i, -LPG (N62B48B) 270kW', 4799, 'petrol', 'NA', NULL),
  ('S85B50A', 'M5, -LPG (S85B50A) 373kW', 4999, 'petrol', 'NA', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'engine_oil', (SELECT id FROM engines WHERE code = 'M47D20T2'), 5.5, 5.81, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_58620; 520d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'coolant', (SELECT id FROM engines WHERE code = 'M47D20T2'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58620; 520d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M47D20T2'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_58620; 520d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'engine_oil', (SELECT id FROM engines WHERE code = 'M47D20T2'), 5.5, 5.81, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_58620; 520d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'coolant', (SELECT id FROM engines WHERE code = 'M47D20T2'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58620; 520d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M47D20T2'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_58620; 520d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'engine_oil', (SELECT id FROM engines WHERE code = 'M47D20T2'), 5.5, 5.81, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_58620; 520d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'coolant', (SELECT id FROM engines WHERE code = 'M47D20T2'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58620; 520d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M47D20T2'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_58620; 520d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'engine_oil', (SELECT id FROM engines WHERE code = 'M47D20T2'), 5.5, 5.81, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_58620; 520d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'coolant', (SELECT id FROM engines WHERE code = 'M47D20T2'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58620; 520d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M47D20T2'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_58620; 520d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20A'), 5.75, 6.08, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_79020; 520d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20A'), 11, 11.62, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_79020; 520d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'transmission_at', (SELECT id FROM engines WHERE code = 'N47D20A'), 1.6, 1.69, NULL, 'SAE 75W-80', 'HaynesPro typeId t_79020; 520d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20A'), 5.75, 6.08, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_79020; 520d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20A'), 11, 11.62, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_79020; 520d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'transmission_at', (SELECT id FROM engines WHERE code = 'N47D20A'), 1.6, 1.69, NULL, 'SAE 75W-80', 'HaynesPro typeId t_79020; 520d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20A'), 5.75, 6.08, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_79020; 520d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20A'), 11, 11.62, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_79020; 520d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'transmission_at', (SELECT id FROM engines WHERE code = 'N47D20A'), 1.6, 1.69, NULL, 'SAE 75W-80', 'HaynesPro typeId t_79020; 520d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20A'), 5.75, 6.08, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_79020; 520d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20A'), 11, 11.62, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_79020; 520d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'transmission_at', (SELECT id FROM engines WHERE code = 'N47D20A'), 1.6, 1.69, NULL, 'SAE 75W-80', 'HaynesPro typeId t_79020; 520d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20C'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102002015; 520d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20C'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102002015; 520d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20C'), 1.6, 1.69, NULL, 'BMW ATF 2', 'HaynesPro typeId t_102002015; 520d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20C'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102002015; 520d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20C'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102002015; 520d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20C'), 1.6, 1.69, NULL, 'BMW ATF 2', 'HaynesPro typeId t_102002015; 520d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'engine_oil', (SELECT id FROM engines WHERE code = 'M54B22'), 6.5, 6.87, '5W-30', 'BMW Longlife-01', 'HaynesPro typeId t_58470; 520i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B22'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'coolant', (SELECT id FROM engines WHERE code = 'M54B22'), 9.8, 10.36, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58470; 520i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B22'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'transmission_at', (SELECT id FROM engines WHERE code = 'M54B22'), 1.6, 1.69, NULL, 'SAE 75W-80', 'HaynesPro typeId t_58470; 520i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B22'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'engine_oil', (SELECT id FROM engines WHERE code = 'M54B22'), 6.5, 6.87, '5W-30', 'BMW Longlife-01', 'HaynesPro typeId t_58470; 520i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B22'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'coolant', (SELECT id FROM engines WHERE code = 'M54B22'), 9.8, 10.36, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58470; 520i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B22'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'transmission_at', (SELECT id FROM engines WHERE code = 'M54B22'), 1.6, 1.69, NULL, 'SAE 75W-80', 'HaynesPro typeId t_58470; 520i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B22'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'engine_oil', (SELECT id FROM engines WHERE code = 'N46B20B'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_619019584; 520i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'coolant', (SELECT id FROM engines WHERE code = 'N46B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619019584; 520i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N46B20B'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_619019584; 520i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'engine_oil', (SELECT id FROM engines WHERE code = 'N46B20B'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_619019584; 520i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'coolant', (SELECT id FROM engines WHERE code = 'N46B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619019584; 520i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N46B20B'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_619019584; 520i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'engine_oil', (SELECT id FROM engines WHERE code = 'N46B20B'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_619019584; 520i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'coolant', (SELECT id FROM engines WHERE code = 'N46B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619019584; 520i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N46B20B'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_619019584; 520i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'engine_oil', (SELECT id FROM engines WHERE code = 'N46B20B'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_619019584; 520i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'coolant', (SELECT id FROM engines WHERE code = 'N46B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619019584; 520i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N46B20B'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_619019584; 520i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'engine_oil', (SELECT id FROM engines WHERE code = 'N43B20A'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_58670; 520i (120/125 kW); drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'coolant', (SELECT id FROM engines WHERE code = 'N43B20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58670; 520i (120/125 kW)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'transmission_at', (SELECT id FROM engines WHERE code = 'N43B20A'), 1.3, 1.37, NULL, 'MTF LT3', 'HaynesPro typeId t_58670; 520i (120/125 kW); Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'engine_oil', (SELECT id FROM engines WHERE code = 'N43B20A'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_58670; 520i (120/125 kW); drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'coolant', (SELECT id FROM engines WHERE code = 'N43B20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58670; 520i (120/125 kW)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'transmission_at', (SELECT id FROM engines WHERE code = 'N43B20A'), 1.3, 1.37, NULL, 'MTF LT3', 'HaynesPro typeId t_58670; 520i (120/125 kW); Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'engine_oil', (SELECT id FROM engines WHERE code = 'N43B20A'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_58670; 520i (120/125 kW); drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'coolant', (SELECT id FROM engines WHERE code = 'N43B20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58670; 520i (120/125 kW)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'transmission_at', (SELECT id FROM engines WHERE code = 'N43B20A'), 1.3, 1.37, NULL, 'MTF LT3', 'HaynesPro typeId t_58670; 520i (120/125 kW); Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'engine_oil', (SELECT id FROM engines WHERE code = 'N43B20A'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_58670; 520i (120/125 kW); drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'coolant', (SELECT id FROM engines WHERE code = 'N43B20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58670; 520i (120/125 kW)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'transmission_at', (SELECT id FROM engines WHERE code = 'N43B20A'), 1.3, 1.37, NULL, 'MTF LT3', 'HaynesPro typeId t_58670; 520i (120/125 kW); Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B25A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_619021376; 523i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'coolant', (SELECT id FROM engines WHERE code = 'N52B25A'), 9.8, 10.36, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619021376; 523i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'transmission_at', (SELECT id FROM engines WHERE code = 'N52B25A'), 1.3, 1.37, NULL, 'MTF LT3', 'HaynesPro typeId t_619021376; 523i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B25A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_619021376; 523i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'coolant', (SELECT id FROM engines WHERE code = 'N52B25A'), 9.8, 10.36, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619021376; 523i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'transmission_at', (SELECT id FROM engines WHERE code = 'N52B25A'), 1.3, 1.37, NULL, 'MTF LT3', 'HaynesPro typeId t_619021376; 523i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B25A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_619021376; 523i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'coolant', (SELECT id FROM engines WHERE code = 'N52B25A'), 9.8, 10.36, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619021376; 523i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'transmission_at', (SELECT id FROM engines WHERE code = 'N52B25A'), 1.3, 1.37, NULL, 'MTF LT3', 'HaynesPro typeId t_619021376; 523i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B25A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_619021376; 523i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'coolant', (SELECT id FROM engines WHERE code = 'N52B25A'), 9.8, 10.36, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619021376; 523i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'transmission_at', (SELECT id FROM engines WHERE code = 'N52B25A'), 1.3, 1.37, NULL, 'MTF LT3', 'HaynesPro typeId t_619021376; 523i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'engine_oil', (SELECT id FROM engines WHERE code = 'N53B25A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_78930; 523i, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'coolant', (SELECT id FROM engines WHERE code = 'N53B25A'), 10, 10.57, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78930; 523i, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'transmission_at', (SELECT id FROM engines WHERE code = 'N53B25A'), 1.3, 1.37, NULL, 'MTF LT3', 'HaynesPro typeId t_78930; 523i, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'engine_oil', (SELECT id FROM engines WHERE code = 'N53B25A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_78930; 523i, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'coolant', (SELECT id FROM engines WHERE code = 'N53B25A'), 10, 10.57, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78930; 523i, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'transmission_at', (SELECT id FROM engines WHERE code = 'N53B25A'), 1.3, 1.37, NULL, 'MTF LT3', 'HaynesPro typeId t_78930; 523i, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'engine_oil', (SELECT id FROM engines WHERE code = 'N53B25A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_78930; 523i, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'coolant', (SELECT id FROM engines WHERE code = 'N53B25A'), 10, 10.57, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78930; 523i, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'transmission_at', (SELECT id FROM engines WHERE code = 'N53B25A'), 1.3, 1.37, NULL, 'MTF LT3', 'HaynesPro typeId t_78930; 523i, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'engine_oil', (SELECT id FROM engines WHERE code = 'N53B25A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_78930; 523i, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'coolant', (SELECT id FROM engines WHERE code = 'N53B25A'), 10, 10.57, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78930; 523i, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'transmission_at', (SELECT id FROM engines WHERE code = 'N53B25A'), 1.3, 1.37, NULL, 'MTF LT3', 'HaynesPro typeId t_78930; 523i, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D25TU'), 8.25, 8.72, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_58540; 525d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D25TU'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'coolant', (SELECT id FROM engines WHERE code = 'M57D25TU'), 9.6, 10.14, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58540; 525d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D25TU'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M57D25TU'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_58540; 525d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D25TU'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D25TU'), 8.25, 8.72, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_58540; 525d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D25TU'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'coolant', (SELECT id FROM engines WHERE code = 'M57D25TU'), 9.6, 10.14, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58540; 525d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D25TU'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M57D25TU'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_58540; 525d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D25TU'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D25TU'), 8.25, 8.72, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_58540; 525d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D25TU'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'coolant', (SELECT id FROM engines WHERE code = 'M57D25TU'), 9.6, 10.14, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58540; 525d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D25TU'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M57D25TU'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_58540; 525d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D25TU'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D25TU'), 8.25, 8.72, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_58540; 525d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D25TU'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'coolant', (SELECT id FROM engines WHERE code = 'M57D25TU'), 9.6, 10.14, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58540; 525d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D25TU'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M57D25TU'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_58540; 525d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D25TU'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30 (306D3)'), 7.7, 8.14, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_619032600; 525d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30 (306D3)'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30 (306D3)'), 9.6, 10.14, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619032600; 525d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30 (306D3)'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M57D30 (306D3)'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_619032600; 525d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30 (306D3)'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30 (306D3)'), 7.7, 8.14, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_619032600; 525d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30 (306D3)'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30 (306D3)'), 9.6, 10.14, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619032600; 525d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30 (306D3)'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M57D30 (306D3)'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_619032600; 525d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30 (306D3)'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30 (306D3)'), 7.7, 8.14, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_619032600; 525d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30 (306D3)'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30 (306D3)'), 9.6, 10.14, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619032600; 525d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30 (306D3)'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M57D30 (306D3)'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_619032600; 525d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30 (306D3)'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30 (306D3)'), 7.7, 8.14, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_619032600; 525d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30 (306D3)'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30 (306D3)'), 9.6, 10.14, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619032600; 525d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30 (306D3)'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M57D30 (306D3)'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_619032600; 525d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30 (306D3)'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30T2'), 7.7, 8.14, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_79010; 525d, Xd; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30T2'), 9.6, 10.14, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_79010; 525d, Xd'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M57D30T2'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_79010; 525d, Xd; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30T2'), 7.7, 8.14, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_79010; 525d, Xd; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30T2'), 9.6, 10.14, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_79010; 525d, Xd'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M57D30T2'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_79010; 525d, Xd; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30T2'), 7.7, 8.14, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_79010; 525d, Xd; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30T2'), 9.6, 10.14, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_79010; 525d, Xd'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M57D30T2'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_79010; 525d, Xd; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30T2'), 7.7, 8.14, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_79010; 525d, Xd; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30T2'), 9.6, 10.14, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_79010; 525d, Xd'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M57D30T2'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_79010; 525d, Xd; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'engine_oil', (SELECT id FROM engines WHERE code = 'M54B25'), 6.5, 6.87, '5W-30', 'BMW Longlife-01', 'HaynesPro typeId t_58490; 525i, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B25'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'coolant', (SELECT id FROM engines WHERE code = 'M54B25'), 9.8, 10.36, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58490; 525i, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B25'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'transmission_at', (SELECT id FROM engines WHERE code = 'M54B25'), 1.6, 1.69, NULL, 'SAE 75W-80', 'HaynesPro typeId t_58490; 525i, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B25'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'engine_oil', (SELECT id FROM engines WHERE code = 'M54B25'), 6.5, 6.87, '5W-30', 'BMW Longlife-01', 'HaynesPro typeId t_58490; 525i, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B25'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'coolant', (SELECT id FROM engines WHERE code = 'M54B25'), 9.8, 10.36, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58490; 525i, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B25'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'transmission_at', (SELECT id FROM engines WHERE code = 'M54B25'), 1.6, 1.69, NULL, 'SAE 75W-80', 'HaynesPro typeId t_58490; 525i, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B25'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'engine_oil', (SELECT id FROM engines WHERE code = 'N53B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_79030; 525i, Xi; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'coolant', (SELECT id FROM engines WHERE code = 'N53B30A'), 11, 11.62, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_79030; 525i, Xi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N53B30A'), 1.3, 1.37, NULL, 'SAE 75W-80', 'HaynesPro typeId t_79030; 525i, Xi; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'engine_oil', (SELECT id FROM engines WHERE code = 'N53B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_79030; 525i, Xi; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'coolant', (SELECT id FROM engines WHERE code = 'N53B30A'), 11, 11.62, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_79030; 525i, Xi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N53B30A'), 1.3, 1.37, NULL, 'SAE 75W-80', 'HaynesPro typeId t_79030; 525i, Xi; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'engine_oil', (SELECT id FROM engines WHERE code = 'N53B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_79030; 525i, Xi; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'coolant', (SELECT id FROM engines WHERE code = 'N53B30A'), 11, 11.62, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_79030; 525i, Xi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N53B30A'), 1.3, 1.37, NULL, 'SAE 75W-80', 'HaynesPro typeId t_79030; 525i, Xi; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'engine_oil', (SELECT id FROM engines WHERE code = 'N53B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_79030; 525i, Xi; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'coolant', (SELECT id FROM engines WHERE code = 'N53B30A'), 11, 11.62, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_79030; 525i, Xi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N53B30A'), 1.3, 1.37, NULL, 'SAE 75W-80', 'HaynesPro typeId t_79030; 525i, Xi; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30TU'), 8.25, 8.72, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_58550; 530d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30TU'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30TU'), 9.6, 10.14, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58550; 530d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30TU'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M57D30TU'), 1.6, 1.69, NULL, 'BMW ATF 2', 'HaynesPro typeId t_58550; 530d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30TU'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30TU'), 8.25, 8.72, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_58550; 530d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30TU'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30TU'), 9.6, 10.14, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58550; 530d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30TU'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M57D30TU'), 1.6, 1.69, NULL, 'BMW ATF 2', 'HaynesPro typeId t_58550; 530d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30TU'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'engine_oil', (SELECT id FROM engines WHERE code = 'M54B30'), 6.5, 6.87, '5W-30', 'BMW Longlife-01', 'HaynesPro typeId t_58500; 530i, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B30'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'coolant', (SELECT id FROM engines WHERE code = 'M54B30'), 9.8, 10.36, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58500; 530i, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B30'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'transmission_at', (SELECT id FROM engines WHERE code = 'M54B30'), 1.6, 1.69, NULL, 'SAE 75W-80', 'HaynesPro typeId t_58500; 530i, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B30'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'engine_oil', (SELECT id FROM engines WHERE code = 'M54B30'), 6.5, 6.87, '5W-30', 'BMW Longlife-01', 'HaynesPro typeId t_58500; 530i, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B30'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'coolant', (SELECT id FROM engines WHERE code = 'M54B30'), 9.8, 10.36, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58500; 530i, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B30'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'transmission_at', (SELECT id FROM engines WHERE code = 'M54B30'), 1.6, 1.69, NULL, 'SAE 75W-80', 'HaynesPro typeId t_58500; 530i, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B30'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_58600; 530i, Xi; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'coolant', (SELECT id FROM engines WHERE code = 'N52B30A'), 12, 12.68, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58600; 530i, Xi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N52B30A'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_58600; 530i, Xi; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_58600; 530i, Xi; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'coolant', (SELECT id FROM engines WHERE code = 'N52B30A'), 12, 12.68, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58600; 530i, Xi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N52B30A'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_58600; 530i, Xi; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_58600; 530i, Xi; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'coolant', (SELECT id FROM engines WHERE code = 'N52B30A'), 12, 12.68, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58600; 530i, Xi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N52B30A'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_58600; 530i, Xi; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_58600; 530i, Xi; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'coolant', (SELECT id FROM engines WHERE code = 'N52B30A'), 12, 12.68, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58600; 530i, Xi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N52B30A'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_58600; 530i, Xi; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30TUTOP'), 8.5, 8.98, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_58560; 535d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30TUTOP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30TUTOP'), 9.6, 10.14, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58560; 535d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30TUTOP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'transmission_at', (SELECT id FROM engines WHERE code = 'M57D30TUTOP'), NULL, NULL, NULL, 'SAE 75W-90', 'HaynesPro typeId t_58560; 535d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30TUTOP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30TUTOP'), 8.5, 8.98, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_58560; 535d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30TUTOP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30TUTOP'), 9.6, 10.14, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58560; 535d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30TUTOP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'transmission_at', (SELECT id FROM engines WHERE code = 'M57D30TUTOP'), NULL, NULL, NULL, 'SAE 75W-90', 'HaynesPro typeId t_58560; 535d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30TUTOP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30TUTOP'), 8.5, 8.98, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_58560; 535d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30TUTOP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30TUTOP'), 9.6, 10.14, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58560; 535d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30TUTOP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'transmission_at', (SELECT id FROM engines WHERE code = 'M57D30TUTOP'), NULL, NULL, NULL, 'SAE 75W-90', 'HaynesPro typeId t_58560; 535d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30TUTOP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30TUTOP'), 8.5, 8.98, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_58560; 535d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30TUTOP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30TUTOP'), 9.6, 10.14, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58560; 535d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30TUTOP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'transmission_at', (SELECT id FROM engines WHERE code = 'M57D30TUTOP'), NULL, NULL, NULL, 'SAE 75W-90', 'HaynesPro typeId t_58560; 535d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30TUTOP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30T2TOP'), 7.7, 8.14, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_58570; 535d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2TOP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30T2TOP'), 9.6, 10.14, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58570; 535d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2TOP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M57D30T2TOP'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_58570; 535d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2TOP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30T2TOP'), 7.7, 8.14, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_58570; 535d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2TOP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30T2TOP'), 9.6, 10.14, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58570; 535d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2TOP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M57D30T2TOP'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_58570; 535d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2TOP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30T2TOP'), 7.7, 8.14, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_58570; 535d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2TOP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30T2TOP'), 9.6, 10.14, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58570; 535d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2TOP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M57D30T2TOP'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_58570; 535d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2TOP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30T2TOP'), 7.7, 8.14, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_58570; 535d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2TOP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30T2TOP'), 9.6, 10.14, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58570; 535d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2TOP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M57D30T2TOP'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_58570; 535d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2TOP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'engine_oil', (SELECT id FROM engines WHERE code = 'N62B40A'), 8, 8.45, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_58640; 540i, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B40A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'coolant', (SELECT id FROM engines WHERE code = 'N62B40A'), 13.8, 14.58, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58640; 540i, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B40A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N62B40A'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_58640; 540i, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B40A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'engine_oil', (SELECT id FROM engines WHERE code = 'N62B40A'), 8, 8.45, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_58640; 540i, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B40A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'coolant', (SELECT id FROM engines WHERE code = 'N62B40A'), 13.8, 14.58, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58640; 540i, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B40A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N62B40A'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_58640; 540i, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B40A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'engine_oil', (SELECT id FROM engines WHERE code = 'N62B40A'), 8, 8.45, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_58640; 540i, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B40A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'coolant', (SELECT id FROM engines WHERE code = 'N62B40A'), 13.8, 14.58, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58640; 540i, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B40A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N62B40A'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_58640; 540i, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B40A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'engine_oil', (SELECT id FROM engines WHERE code = 'N62B40A'), 8, 8.45, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_58640; 540i, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B40A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'coolant', (SELECT id FROM engines WHERE code = 'N62B40A'), 13.8, 14.58, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58640; 540i, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B40A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N62B40A'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_58640; 540i, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B40A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'engine_oil', (SELECT id FROM engines WHERE code = 'N62B44A'), 8, 8.45, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_58530; 545i, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'coolant', (SELECT id FROM engines WHERE code = 'N62B44A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58530; 545i, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N62B44A'), 1.6, 1.69, NULL, 'BMW ATF 2', 'HaynesPro typeId t_58530; 545i, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'engine_oil', (SELECT id FROM engines WHERE code = 'N62B44A'), 8, 8.45, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_58530; 545i, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'coolant', (SELECT id FROM engines WHERE code = 'N62B44A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58530; 545i, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N62B44A'), 1.6, 1.69, NULL, 'BMW ATF 2', 'HaynesPro typeId t_58530; 545i, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'engine_oil', (SELECT id FROM engines WHERE code = 'N62B48B'), 8, 8.45, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_58650; 550i, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B48B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'coolant', (SELECT id FROM engines WHERE code = 'N62B48B'), 13.8, 14.58, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58650; 550i, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B48B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N62B48B'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_58650; 550i, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B48B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'engine_oil', (SELECT id FROM engines WHERE code = 'N62B48B'), 8, 8.45, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_58650; 550i, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B48B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'coolant', (SELECT id FROM engines WHERE code = 'N62B48B'), 13.8, 14.58, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58650; 550i, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B48B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N62B48B'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_58650; 550i, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B48B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'engine_oil', (SELECT id FROM engines WHERE code = 'N62B48B'), 8, 8.45, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_58650; 550i, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B48B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'coolant', (SELECT id FROM engines WHERE code = 'N62B48B'), 13.8, 14.58, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58650; 550i, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B48B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N62B48B'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_58650; 550i, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B48B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'engine_oil', (SELECT id FROM engines WHERE code = 'N62B48B'), 8, 8.45, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_58650; 550i, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B48B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'coolant', (SELECT id FROM engines WHERE code = 'N62B48B'), 13.8, 14.58, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58650; 550i, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B48B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N62B48B'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_58650; 550i, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B48B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 183, 'engine_oil', (SELECT id FROM engines WHERE code = 'S85B50A'), NULL, NULL, '10W-60', NULL, 'HaynesPro typeId t_58610; M5, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 183 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S85B50A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 183, 'coolant', (SELECT id FROM engines WHERE code = 'S85B50A'), 10, 10.57, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58610; M5, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 183 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S85B50A'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 179, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_810;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 179 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 181, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_810;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 181 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 180, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_810;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 180 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 182, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_810;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 182 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 183, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_810;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 183 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (179, 181, 180, 182, 183)
  AND e.code IN ('M47D20T2', 'N47D20A', 'N47D20C', 'M54B22', 'N46B20B', 'N43B20A', 'N52B25A', 'N53B25A', 'M57D25TU', 'M57D30 (306D3)', 'M57D30T2', 'M54B25', 'N53B30A', 'M57D30TU', 'M54B30', 'N52B30A', 'M57D30TUTOP', 'M57D30T2TOP', 'N62B40A', 'N62B44A', 'N62B48B', 'S85B50A')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (179, 181, 180, 182, 183)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (179, 181, 180, 182, 183) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;