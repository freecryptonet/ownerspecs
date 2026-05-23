-- mig 261 — multi-gen HaynesPro ingest: BMW 1 (E81, E82, E87, E88)
-- crawl: haynespro-crawl-bmw-1-e87-2026-05-23.json
-- modelId: d_830
-- 14 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — BMW 1 (E81, E82, E87, E88)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_830', NOW(), 'Multi-gen ingest, 14 engines across 2 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_830' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('N47D20A', '116d (N47D20A) 85kW', 1995, 'diesel', 'NA', NULL),
  ('N47D20C', '116d (N47D20C) 85kW', 1995, 'diesel', 'NA', NULL),
  ('N43B16A', '116i (N43B16A) 90kW', 1599, 'petrol', 'NA', NULL),
  ('N43B20A', '116i (N43B20A) 90kW', 1995, 'petrol', 'NA', NULL),
  ('N45B16A', '116i, -LPG (N45B16A) 85kW', 1596, 'petrol', 'NA', NULL),
  ('M47D20TU2', '118d (M47D20TU2) 90kW', 1995, 'diesel', 'NA', NULL),
  ('N46B20B', '118i (N46B20B) 100kW', 1995, 'petrol', 'NA', NULL),
  ('M47D20TU2OL', '120d (M47D20TU2OL) 120kW', 1995, 'diesel', 'NA', NULL),
  ('N46B20C', '120i (N46B20C) 115kW', 1995, 'petrol', 'NA', NULL),
  ('N47D20B', '123d (N47D20B) 150kW', 1995, 'diesel', 'NA', NULL),
  ('N47D20D', '123d (N47D20D) 150kW', 1995, 'diesel', 'NA', NULL),
  ('N52B30A', '125i (N52B30A) 160kW', 2996, 'petrol', 'NA', NULL),
  ('N54B30A', '135i (N54B30A) 240kW', 2979, 'petrol', 'turbo', NULL),
  ('N55B30A', '135i (N55B30A) 240kW', 2979, 'petrol', 'turbo', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20A'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102001274; 116d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001274; 116d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_102001274; 116d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20A'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102001274; 116d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001274; 116d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_102001274; 116d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20C'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102002009; 116d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20C'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102002009; 116d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20C'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_102002009; 116d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20C'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102002009; 116d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20C'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102002009; 116d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20C'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_102002009; 116d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'engine_oil', (SELECT id FROM engines WHERE code = 'N43B16A'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_78820; 116i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'coolant', (SELECT id FROM engines WHERE code = 'N43B16A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78820; 116i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N43B16A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_78820; 116i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'engine_oil', (SELECT id FROM engines WHERE code = 'N43B16A'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_78820; 116i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'coolant', (SELECT id FROM engines WHERE code = 'N43B16A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78820; 116i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N43B16A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_78820; 116i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'engine_oil', (SELECT id FROM engines WHERE code = 'N43B20A'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_78850; 116i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'coolant', (SELECT id FROM engines WHERE code = 'N43B20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78850; 116i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N43B20A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_78850; 116i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'engine_oil', (SELECT id FROM engines WHERE code = 'N43B20A'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_78850; 116i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'coolant', (SELECT id FROM engines WHERE code = 'N43B20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78850; 116i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N43B20A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_78850; 116i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'engine_oil', (SELECT id FROM engines WHERE code = 'N45B16A'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_58660; 116i, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'coolant', (SELECT id FROM engines WHERE code = 'N45B16A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58660; 116i, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N45B16A'), 1.1, 1.16, NULL, 'BMW ATF 2', 'HaynesPro typeId t_58660; 116i, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'engine_oil', (SELECT id FROM engines WHERE code = 'N45B16A'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_58660; 116i, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'coolant', (SELECT id FROM engines WHERE code = 'N45B16A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58660; 116i, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N45B16A'), 1.1, 1.16, NULL, 'BMW ATF 2', 'HaynesPro typeId t_58660; 116i, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'engine_oil', (SELECT id FROM engines WHERE code = 'M47D20TU2'), 5.5, 5.81, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_58690; 118d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20TU2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'coolant', (SELECT id FROM engines WHERE code = 'M47D20TU2'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58690; 118d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20TU2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M47D20TU2'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_58690; 118d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20TU2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'engine_oil', (SELECT id FROM engines WHERE code = 'M47D20TU2'), 5.5, 5.81, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_58690; 118d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20TU2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'coolant', (SELECT id FROM engines WHERE code = 'M47D20TU2'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58690; 118d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20TU2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M47D20TU2'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_58690; 118d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20TU2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'engine_oil', (SELECT id FROM engines WHERE code = 'N46B20B'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_78830; 118i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'coolant', (SELECT id FROM engines WHERE code = 'N46B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78830; 118i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N46B20B'), 1.3, 1.37, NULL, 'Dexron VI', 'HaynesPro typeId t_78830; 118i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'engine_oil', (SELECT id FROM engines WHERE code = 'N46B20B'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_78830; 118i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'coolant', (SELECT id FROM engines WHERE code = 'N46B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78830; 118i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N46B20B'), 1.3, 1.37, NULL, 'Dexron VI', 'HaynesPro typeId t_78830; 118i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'engine_oil', (SELECT id FROM engines WHERE code = 'M47D20TU2OL'), 5.5, 5.81, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_58710; 120d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20TU2OL'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'coolant', (SELECT id FROM engines WHERE code = 'M47D20TU2OL'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58710; 120d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20TU2OL'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M47D20TU2OL'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_58710; 120d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20TU2OL'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'engine_oil', (SELECT id FROM engines WHERE code = 'M47D20TU2OL'), 5.5, 5.81, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_58710; 120d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20TU2OL'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'coolant', (SELECT id FROM engines WHERE code = 'M47D20TU2OL'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58710; 120d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20TU2OL'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M47D20TU2OL'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_58710; 120d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20TU2OL'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'engine_oil', (SELECT id FROM engines WHERE code = 'N46B20C'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_619021342; 120i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'coolant', (SELECT id FROM engines WHERE code = 'N46B20C'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619021342; 120i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N46B20C'), 1.3, 1.37, NULL, 'Dexron VI', 'HaynesPro typeId t_619021342; 120i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'engine_oil', (SELECT id FROM engines WHERE code = 'N46B20C'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_619021342; 120i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'coolant', (SELECT id FROM engines WHERE code = 'N46B20C'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619021342; 120i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N46B20C'), 1.3, 1.37, NULL, 'Dexron VI', 'HaynesPro typeId t_619021342; 120i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20B'), 5.5, 5.81, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_78880; 123d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78880; 123d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20B'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_78880; 123d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20B'), 5.5, 5.81, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_78880; 123d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78880; 123d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20B'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_78880; 123d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20D'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102002013; 123d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20D'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102002013; 123d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20D'), 1.6, 1.69, NULL, 'BMW ATF 2', 'HaynesPro typeId t_102002013; 123d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20D'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102002013; 123d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20D'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102002013; 123d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20D'), 1.6, 1.69, NULL, 'BMW ATF 2', 'HaynesPro typeId t_102002013; 123d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_102001519; 125i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'coolant', (SELECT id FROM engines WHERE code = 'N52B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001519; 125i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N52B30A'), 1.3, 1.37, NULL, 'Dexron VI', 'HaynesPro typeId t_102001519; 125i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_102001519; 125i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'coolant', (SELECT id FROM engines WHERE code = 'N52B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001519; 125i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N52B30A'), 1.3, 1.37, NULL, 'Dexron VI', 'HaynesPro typeId t_102001519; 125i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'engine_oil', (SELECT id FROM engines WHERE code = 'N54B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_619031738; 135i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N54B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'coolant', (SELECT id FROM engines WHERE code = 'N54B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619031738; 135i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N54B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N54B30A'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_619031738; 135i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N54B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'engine_oil', (SELECT id FROM engines WHERE code = 'N54B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_619031738; 135i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N54B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'coolant', (SELECT id FROM engines WHERE code = 'N54B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619031738; 135i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N54B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N54B30A'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_619031738; 135i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N54B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'engine_oil', (SELECT id FROM engines WHERE code = 'N55B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_619029191; 135i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'coolant', (SELECT id FROM engines WHERE code = 'N55B30A'), 8.2, 8.66, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619029191; 135i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N55B30A'), 1.2, 1.27, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619029191; 135i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'engine_oil', (SELECT id FROM engines WHERE code = 'N55B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_619029191; 135i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'coolant', (SELECT id FROM engines WHERE code = 'N55B30A'), 8.2, 8.66, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619029191; 135i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N55B30A'), 1.2, 1.27, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619029191; 135i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 195, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_830;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 195 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 196, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_830;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 196 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (195, 196)
  AND e.code IN ('N47D20A', 'N47D20C', 'N43B16A', 'N43B20A', 'N45B16A', 'M47D20TU2', 'N46B20B', 'M47D20TU2OL', 'N46B20C', 'N47D20B', 'N47D20D', 'N52B30A', 'N54B30A', 'N55B30A')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (195, 196)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (195, 196) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;