-- mig 258 — multi-gen HaynesPro ingest: BMW 3 (E90, E91, E92, E93)
-- crawl: haynespro-crawl-bmw-3-e90-2026-05-23.json
-- modelId: d_900
-- 20 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — BMW 3 (E90, E91, E92, E93)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_900', NOW(), 'Multi-gen ingest, 20 engines across 11 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_900' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('N47D20C', '316d (N47D20C) 85kW', 1995, 'diesel', 'NA', NULL),
  ('N45B16A', '316i (N45B16A) 85kW', 1596, 'petrol', 'NA', NULL),
  ('N43B16A', '316i (N43B16A) 90kW', 1599, 'petrol', 'NA', NULL),
  ('N45B16AC', '316i (N45B16AC) 85kW', 1596, 'petrol', 'NA', NULL),
  ('M47D20TU2uL', '318d (M47D20TU2uL) 90kW', 1995, 'diesel', 'NA', NULL),
  ('N47D20A', '318d (N47D20A) 105kW', 1995, 'diesel', 'NA', NULL),
  ('N43B20A', '318i (N43B20A) 105kW', 1995, 'petrol', 'NA', NULL),
  ('N46B20B', '318i, -LPG (N46B20B) 95kW', 1995, 'petrol', 'NA', NULL),
  ('N45B20A', '320Si, -LPG (N45B20A) 127kW', 1997, 'petrol', 'NA', NULL),
  ('M47D20TU2OL', '320d (M47D20TU2OL) 120kW', 1995, 'diesel', 'NA', NULL),
  ('N52B25A', '323i (N52B25A) 130kW', 2497, 'petrol', 'NA', NULL),
  ('M57D30T2', '325d (M57D30T2) 145kW', 2993, 'petrol', 'NA', NULL),
  ('N57D30A', '325d (N57D30A) 150kW', 2993, 'diesel', 'NA', NULL),
  ('N53B30A', '325i (N53B30A) 155kW', 2996, 'petrol', 'NA', NULL),
  ('N51B30A', '328i, -Xi (N51B30A) 172kW', 2996, 'petrol', 'NA', NULL),
  ('N52B30A', '328i, -Xi (N52B30A) 172kW', 2996, 'petrol', 'NA', NULL),
  ('N54B30A', '335i, -Xi (N54B30A) 225kW', 2979, 'petrol', 'turbo', NULL),
  ('N55B30A', '335i, -Xi (N55B30A) 225kW', 2979, 'petrol', 'turbo', NULL),
  ('S65B40A', 'M3 (S65B40A) 309kW', 3999, 'petrol', 'NA', NULL),
  ('S65B44A', 'M3 GTS/CRT (S65B44A) 331kW', 4361, 'petrol', 'NA', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20C'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102001348; 316d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20C'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001348; 316d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20C'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_102001348; 316d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20C'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102001348; 316d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20C'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001348; 316d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20C'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_102001348; 316d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20C'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102001348; 316d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20C'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001348; 316d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20C'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_102001348; 316d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20C'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102001348; 316d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20C'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001348; 316d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20C'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_102001348; 316d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20C'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102001348; 316d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20C'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001348; 316d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20C'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_102001348; 316d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20C'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102001348; 316d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20C'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001348; 316d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20C'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_102001348; 316d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20C'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102001348; 316d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20C'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001348; 316d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20C'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_102001348; 316d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20C'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102001348; 316d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20C'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001348; 316d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20C'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_102001348; 316d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'engine_oil', (SELECT id FROM engines WHERE code = 'N45B16A'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_59220; 316i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'coolant', (SELECT id FROM engines WHERE code = 'N45B16A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_59220; 316i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N45B16A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_59220; 316i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'engine_oil', (SELECT id FROM engines WHERE code = 'N45B16A'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_59220; 316i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'coolant', (SELECT id FROM engines WHERE code = 'N45B16A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_59220; 316i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N45B16A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_59220; 316i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'engine_oil', (SELECT id FROM engines WHERE code = 'N45B16A'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_59220; 316i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'coolant', (SELECT id FROM engines WHERE code = 'N45B16A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_59220; 316i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N45B16A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_59220; 316i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'engine_oil', (SELECT id FROM engines WHERE code = 'N45B16A'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_59220; 316i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'coolant', (SELECT id FROM engines WHERE code = 'N45B16A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_59220; 316i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N45B16A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_59220; 316i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'engine_oil', (SELECT id FROM engines WHERE code = 'N45B16A'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_59220; 316i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'coolant', (SELECT id FROM engines WHERE code = 'N45B16A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_59220; 316i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N45B16A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_59220; 316i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'engine_oil', (SELECT id FROM engines WHERE code = 'N45B16A'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_59220; 316i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'coolant', (SELECT id FROM engines WHERE code = 'N45B16A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_59220; 316i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N45B16A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_59220; 316i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'engine_oil', (SELECT id FROM engines WHERE code = 'N45B16A'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_59220; 316i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'coolant', (SELECT id FROM engines WHERE code = 'N45B16A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_59220; 316i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N45B16A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_59220; 316i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'engine_oil', (SELECT id FROM engines WHERE code = 'N45B16A'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_59220; 316i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'coolant', (SELECT id FROM engines WHERE code = 'N45B16A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_59220; 316i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N45B16A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_59220; 316i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'engine_oil', (SELECT id FROM engines WHERE code = 'N43B16A'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_110000420; 316i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'coolant', (SELECT id FROM engines WHERE code = 'N43B16A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_110000420; 316i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N43B16A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_110000420; 316i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'engine_oil', (SELECT id FROM engines WHERE code = 'N43B16A'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_110000420; 316i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'coolant', (SELECT id FROM engines WHERE code = 'N43B16A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_110000420; 316i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N43B16A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_110000420; 316i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'engine_oil', (SELECT id FROM engines WHERE code = 'N43B16A'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_110000420; 316i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'coolant', (SELECT id FROM engines WHERE code = 'N43B16A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_110000420; 316i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N43B16A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_110000420; 316i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'engine_oil', (SELECT id FROM engines WHERE code = 'N43B16A'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_110000420; 316i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'coolant', (SELECT id FROM engines WHERE code = 'N43B16A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_110000420; 316i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N43B16A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_110000420; 316i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'engine_oil', (SELECT id FROM engines WHERE code = 'N43B16A'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_110000420; 316i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'coolant', (SELECT id FROM engines WHERE code = 'N43B16A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_110000420; 316i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N43B16A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_110000420; 316i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'engine_oil', (SELECT id FROM engines WHERE code = 'N43B16A'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_110000420; 316i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'coolant', (SELECT id FROM engines WHERE code = 'N43B16A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_110000420; 316i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N43B16A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_110000420; 316i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'engine_oil', (SELECT id FROM engines WHERE code = 'N43B16A'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_110000420; 316i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'coolant', (SELECT id FROM engines WHERE code = 'N43B16A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_110000420; 316i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N43B16A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_110000420; 316i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'engine_oil', (SELECT id FROM engines WHERE code = 'N43B16A'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_110000420; 316i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'coolant', (SELECT id FROM engines WHERE code = 'N43B16A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_110000420; 316i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N43B16A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_110000420; 316i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'engine_oil', (SELECT id FROM engines WHERE code = 'N45B16AC'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_306000305; 316i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16AC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'coolant', (SELECT id FROM engines WHERE code = 'N45B16AC'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_306000305; 316i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16AC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N45B16AC'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_306000305; 316i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16AC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'engine_oil', (SELECT id FROM engines WHERE code = 'N45B16AC'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_306000305; 316i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16AC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'coolant', (SELECT id FROM engines WHERE code = 'N45B16AC'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_306000305; 316i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16AC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N45B16AC'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_306000305; 316i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16AC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'engine_oil', (SELECT id FROM engines WHERE code = 'N45B16AC'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_306000305; 316i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16AC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'coolant', (SELECT id FROM engines WHERE code = 'N45B16AC'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_306000305; 316i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16AC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N45B16AC'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_306000305; 316i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16AC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'engine_oil', (SELECT id FROM engines WHERE code = 'N45B16AC'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_306000305; 316i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16AC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'coolant', (SELECT id FROM engines WHERE code = 'N45B16AC'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_306000305; 316i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16AC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N45B16AC'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_306000305; 316i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16AC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'engine_oil', (SELECT id FROM engines WHERE code = 'N45B16AC'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_306000305; 316i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16AC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'coolant', (SELECT id FROM engines WHERE code = 'N45B16AC'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_306000305; 316i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16AC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N45B16AC'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_306000305; 316i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16AC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'engine_oil', (SELECT id FROM engines WHERE code = 'N45B16AC'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_306000305; 316i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16AC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'coolant', (SELECT id FROM engines WHERE code = 'N45B16AC'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_306000305; 316i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16AC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N45B16AC'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_306000305; 316i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B16AC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'engine_oil', (SELECT id FROM engines WHERE code = 'M47D20TU2uL'), 5.5, 5.81, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_59210; 318d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20TU2uL'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'coolant', (SELECT id FROM engines WHERE code = 'M47D20TU2uL'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_59210; 318d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20TU2uL'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M47D20TU2uL'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_59210; 318d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20TU2uL'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'engine_oil', (SELECT id FROM engines WHERE code = 'M47D20TU2uL'), 5.5, 5.81, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_59210; 318d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20TU2uL'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'coolant', (SELECT id FROM engines WHERE code = 'M47D20TU2uL'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_59210; 318d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20TU2uL'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M47D20TU2uL'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_59210; 318d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20TU2uL'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'engine_oil', (SELECT id FROM engines WHERE code = 'M47D20TU2uL'), 5.5, 5.81, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_59210; 318d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20TU2uL'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'coolant', (SELECT id FROM engines WHERE code = 'M47D20TU2uL'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_59210; 318d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20TU2uL'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M47D20TU2uL'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_59210; 318d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20TU2uL'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'engine_oil', (SELECT id FROM engines WHERE code = 'M47D20TU2uL'), 5.5, 5.81, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_59210; 318d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20TU2uL'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'coolant', (SELECT id FROM engines WHERE code = 'M47D20TU2uL'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_59210; 318d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20TU2uL'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M47D20TU2uL'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_59210; 318d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20TU2uL'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20A'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_78980; 318d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78980; 318d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_78980; 318d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20A'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_78980; 318d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78980; 318d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_78980; 318d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20A'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_78980; 318d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78980; 318d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_78980; 318d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20A'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_78980; 318d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78980; 318d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_78980; 318d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20A'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_78980; 318d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78980; 318d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_78980; 318d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20A'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_78980; 318d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78980; 318d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_78980; 318d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20A'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_78980; 318d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78980; 318d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_78980; 318d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20A'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_78980; 318d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78980; 318d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_78980; 318d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'engine_oil', (SELECT id FROM engines WHERE code = 'N43B20A'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_78970; 318i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'coolant', (SELECT id FROM engines WHERE code = 'N43B20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78970; 318i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N43B20A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_78970; 318i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'engine_oil', (SELECT id FROM engines WHERE code = 'N43B20A'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_78970; 318i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'coolant', (SELECT id FROM engines WHERE code = 'N43B20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78970; 318i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N43B20A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_78970; 318i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'engine_oil', (SELECT id FROM engines WHERE code = 'N43B20A'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_78970; 318i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'coolant', (SELECT id FROM engines WHERE code = 'N43B20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78970; 318i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N43B20A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_78970; 318i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'engine_oil', (SELECT id FROM engines WHERE code = 'N43B20A'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_78970; 318i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'coolant', (SELECT id FROM engines WHERE code = 'N43B20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78970; 318i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N43B20A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_78970; 318i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'engine_oil', (SELECT id FROM engines WHERE code = 'N43B20A'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_78970; 318i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'coolant', (SELECT id FROM engines WHERE code = 'N43B20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78970; 318i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N43B20A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_78970; 318i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'engine_oil', (SELECT id FROM engines WHERE code = 'N43B20A'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_78970; 318i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'coolant', (SELECT id FROM engines WHERE code = 'N43B20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78970; 318i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N43B20A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_78970; 318i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'engine_oil', (SELECT id FROM engines WHERE code = 'N43B20A'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_78970; 318i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'coolant', (SELECT id FROM engines WHERE code = 'N43B20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78970; 318i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N43B20A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_78970; 318i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'engine_oil', (SELECT id FROM engines WHERE code = 'N43B20A'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_78970; 318i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'coolant', (SELECT id FROM engines WHERE code = 'N43B20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78970; 318i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N43B20A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_78970; 318i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N43B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'engine_oil', (SELECT id FROM engines WHERE code = 'N46B20B'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_59140; 318i, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'coolant', (SELECT id FROM engines WHERE code = 'N46B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_59140; 318i, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N46B20B'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_59140; 318i, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'engine_oil', (SELECT id FROM engines WHERE code = 'N46B20B'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_59140; 318i, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'coolant', (SELECT id FROM engines WHERE code = 'N46B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_59140; 318i, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N46B20B'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_59140; 318i, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'engine_oil', (SELECT id FROM engines WHERE code = 'N46B20B'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_59140; 318i, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'coolant', (SELECT id FROM engines WHERE code = 'N46B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_59140; 318i, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N46B20B'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_59140; 318i, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'engine_oil', (SELECT id FROM engines WHERE code = 'N46B20B'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_59140; 318i, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'coolant', (SELECT id FROM engines WHERE code = 'N46B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_59140; 318i, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N46B20B'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_59140; 318i, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'engine_oil', (SELECT id FROM engines WHERE code = 'N45B20A'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_59200; 320Si, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'coolant', (SELECT id FROM engines WHERE code = 'N45B20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_59200; 320Si, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N45B20A'), 1.3, 1.37, NULL, 'SAE 75W-90', 'HaynesPro typeId t_59200; 320Si, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'engine_oil', (SELECT id FROM engines WHERE code = 'N45B20A'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_59200; 320Si, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'coolant', (SELECT id FROM engines WHERE code = 'N45B20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_59200; 320Si, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N45B20A'), 1.3, 1.37, NULL, 'SAE 75W-90', 'HaynesPro typeId t_59200; 320Si, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'engine_oil', (SELECT id FROM engines WHERE code = 'N45B20A'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_59200; 320Si, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'coolant', (SELECT id FROM engines WHERE code = 'N45B20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_59200; 320Si, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N45B20A'), 1.3, 1.37, NULL, 'SAE 75W-90', 'HaynesPro typeId t_59200; 320Si, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'engine_oil', (SELECT id FROM engines WHERE code = 'N45B20A'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_59200; 320Si, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'coolant', (SELECT id FROM engines WHERE code = 'N45B20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_59200; 320Si, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N45B20A'), 1.3, 1.37, NULL, 'SAE 75W-90', 'HaynesPro typeId t_59200; 320Si, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N45B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'engine_oil', (SELECT id FROM engines WHERE code = 'M47D20TU2OL'), 5.5, 5.81, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_59180; 320d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20TU2OL'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'coolant', (SELECT id FROM engines WHERE code = 'M47D20TU2OL'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_59180; 320d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20TU2OL'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M47D20TU2OL'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_59180; 320d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20TU2OL'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'engine_oil', (SELECT id FROM engines WHERE code = 'M47D20TU2OL'), 5.5, 5.81, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_59180; 320d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20TU2OL'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'coolant', (SELECT id FROM engines WHERE code = 'M47D20TU2OL'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_59180; 320d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20TU2OL'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M47D20TU2OL'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_59180; 320d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20TU2OL'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'engine_oil', (SELECT id FROM engines WHERE code = 'M47D20TU2OL'), 5.5, 5.81, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_59180; 320d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20TU2OL'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'coolant', (SELECT id FROM engines WHERE code = 'M47D20TU2OL'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_59180; 320d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20TU2OL'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M47D20TU2OL'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_59180; 320d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20TU2OL'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'engine_oil', (SELECT id FROM engines WHERE code = 'M47D20TU2OL'), 5.5, 5.81, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_59180; 320d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20TU2OL'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'coolant', (SELECT id FROM engines WHERE code = 'M47D20TU2OL'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_59180; 320d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20TU2OL'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M47D20TU2OL'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_59180; 320d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20TU2OL'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B25A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_58480; 323i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'coolant', (SELECT id FROM engines WHERE code = 'N52B25A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58480; 323i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N52B25A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_58480; 323i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B25A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_58480; 323i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'coolant', (SELECT id FROM engines WHERE code = 'N52B25A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58480; 323i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N52B25A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_58480; 323i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B25A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_58480; 323i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'coolant', (SELECT id FROM engines WHERE code = 'N52B25A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58480; 323i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N52B25A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_58480; 323i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B25A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_58480; 323i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'coolant', (SELECT id FROM engines WHERE code = 'N52B25A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58480; 323i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N52B25A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_58480; 323i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B25A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_58480; 323i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'coolant', (SELECT id FROM engines WHERE code = 'N52B25A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58480; 323i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N52B25A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_58480; 323i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B25A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_58480; 323i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'coolant', (SELECT id FROM engines WHERE code = 'N52B25A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58480; 323i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N52B25A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_58480; 323i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B25A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_58480; 323i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'coolant', (SELECT id FROM engines WHERE code = 'N52B25A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58480; 323i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N52B25A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_58480; 323i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B25A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_58480; 323i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'coolant', (SELECT id FROM engines WHERE code = 'N52B25A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58480; 323i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N52B25A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_58480; 323i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30T2'), 7.5, 7.93, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_78950; 325d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30T2'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78950; 325d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M57D30T2'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_78950; 325d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30T2'), 7.5, 7.93, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_78950; 325d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30T2'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78950; 325d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M57D30T2'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_78950; 325d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30T2'), 7.5, 7.93, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_78950; 325d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30T2'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78950; 325d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M57D30T2'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_78950; 325d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30T2'), 7.5, 7.93, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_78950; 325d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30T2'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78950; 325d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M57D30T2'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_78950; 325d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30T2'), 7.5, 7.93, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_78950; 325d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30T2'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78950; 325d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M57D30T2'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_78950; 325d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30T2'), 7.5, 7.93, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_78950; 325d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30T2'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78950; 325d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M57D30T2'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_78950; 325d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30T2'), 7.5, 7.93, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_78950; 325d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30T2'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78950; 325d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M57D30T2'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_78950; 325d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30T2'), 7.5, 7.93, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_78950; 325d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30T2'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78950; 325d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M57D30T2'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_78950; 325d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30A'), 7.2, 7.61, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_106000250; 325d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_106000250; 325d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N57D30A'), 1.6, 1.69, NULL, 'BMW ATF 2', 'HaynesPro typeId t_106000250; 325d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30A'), 7.2, 7.61, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_106000250; 325d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_106000250; 325d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N57D30A'), 1.6, 1.69, NULL, 'BMW ATF 2', 'HaynesPro typeId t_106000250; 325d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30A'), 7.2, 7.61, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_106000250; 325d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_106000250; 325d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N57D30A'), 1.6, 1.69, NULL, 'BMW ATF 2', 'HaynesPro typeId t_106000250; 325d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30A'), 7.2, 7.61, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_106000250; 325d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_106000250; 325d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N57D30A'), 1.6, 1.69, NULL, 'BMW ATF 2', 'HaynesPro typeId t_106000250; 325d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30A'), 7.2, 7.61, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_106000250; 325d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_106000250; 325d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N57D30A'), 1.6, 1.69, NULL, 'BMW ATF 2', 'HaynesPro typeId t_106000250; 325d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30A'), 7.2, 7.61, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_106000250; 325d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_106000250; 325d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N57D30A'), 1.6, 1.69, NULL, 'BMW ATF 2', 'HaynesPro typeId t_106000250; 325d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30A'), 7.2, 7.61, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_106000250; 325d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_106000250; 325d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N57D30A'), 1.6, 1.69, NULL, 'BMW ATF 2', 'HaynesPro typeId t_106000250; 325d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30A'), 7.2, 7.61, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_106000250; 325d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_106000250; 325d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N57D30A'), 1.6, 1.69, NULL, 'BMW ATF 2', 'HaynesPro typeId t_106000250; 325d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'engine_oil', (SELECT id FROM engines WHERE code = 'N53B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_200000078; 325i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'coolant', (SELECT id FROM engines WHERE code = 'N53B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_200000078; 325i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N53B30A'), 1.3, 1.37, NULL, 'SAE 75W-80', 'HaynesPro typeId t_200000078; 325i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'engine_oil', (SELECT id FROM engines WHERE code = 'N53B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_200000078; 325i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'coolant', (SELECT id FROM engines WHERE code = 'N53B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_200000078; 325i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N53B30A'), 1.3, 1.37, NULL, 'SAE 75W-80', 'HaynesPro typeId t_200000078; 325i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'engine_oil', (SELECT id FROM engines WHERE code = 'N53B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_200000078; 325i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'coolant', (SELECT id FROM engines WHERE code = 'N53B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_200000078; 325i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N53B30A'), 1.3, 1.37, NULL, 'SAE 75W-80', 'HaynesPro typeId t_200000078; 325i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'engine_oil', (SELECT id FROM engines WHERE code = 'N53B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_200000078; 325i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'coolant', (SELECT id FROM engines WHERE code = 'N53B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_200000078; 325i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N53B30A'), 1.3, 1.37, NULL, 'SAE 75W-80', 'HaynesPro typeId t_200000078; 325i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'engine_oil', (SELECT id FROM engines WHERE code = 'N53B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_200000078; 325i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'coolant', (SELECT id FROM engines WHERE code = 'N53B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_200000078; 325i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N53B30A'), 1.3, 1.37, NULL, 'SAE 75W-80', 'HaynesPro typeId t_200000078; 325i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'engine_oil', (SELECT id FROM engines WHERE code = 'N53B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_200000078; 325i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'coolant', (SELECT id FROM engines WHERE code = 'N53B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_200000078; 325i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N53B30A'), 1.3, 1.37, NULL, 'SAE 75W-80', 'HaynesPro typeId t_200000078; 325i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'engine_oil', (SELECT id FROM engines WHERE code = 'N53B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_200000078; 325i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'coolant', (SELECT id FROM engines WHERE code = 'N53B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_200000078; 325i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N53B30A'), 1.3, 1.37, NULL, 'SAE 75W-80', 'HaynesPro typeId t_200000078; 325i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'engine_oil', (SELECT id FROM engines WHERE code = 'N53B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_200000078; 325i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'coolant', (SELECT id FROM engines WHERE code = 'N53B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_200000078; 325i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N53B30A'), 1.3, 1.37, NULL, 'SAE 75W-80', 'HaynesPro typeId t_200000078; 325i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'engine_oil', (SELECT id FROM engines WHERE code = 'N51B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_79000; 328i, -Xi; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N51B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'coolant', (SELECT id FROM engines WHERE code = 'N51B30A'), 8.5, 8.98, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_79000; 328i, -Xi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N51B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N51B30A'), 1.3, 1.37, NULL, 'Dexron VI', 'HaynesPro typeId t_79000; 328i, -Xi; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N51B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'engine_oil', (SELECT id FROM engines WHERE code = 'N51B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_79000; 328i, -Xi; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N51B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'coolant', (SELECT id FROM engines WHERE code = 'N51B30A'), 8.5, 8.98, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_79000; 328i, -Xi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N51B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N51B30A'), 1.3, 1.37, NULL, 'Dexron VI', 'HaynesPro typeId t_79000; 328i, -Xi; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N51B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'engine_oil', (SELECT id FROM engines WHERE code = 'N51B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_79000; 328i, -Xi; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N51B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'coolant', (SELECT id FROM engines WHERE code = 'N51B30A'), 8.5, 8.98, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_79000; 328i, -Xi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N51B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N51B30A'), 1.3, 1.37, NULL, 'Dexron VI', 'HaynesPro typeId t_79000; 328i, -Xi; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N51B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'engine_oil', (SELECT id FROM engines WHERE code = 'N51B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_79000; 328i, -Xi; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N51B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'coolant', (SELECT id FROM engines WHERE code = 'N51B30A'), 8.5, 8.98, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_79000; 328i, -Xi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N51B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N51B30A'), 1.3, 1.37, NULL, 'Dexron VI', 'HaynesPro typeId t_79000; 328i, -Xi; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N51B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'engine_oil', (SELECT id FROM engines WHERE code = 'N51B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_79000; 328i, -Xi; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N51B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'coolant', (SELECT id FROM engines WHERE code = 'N51B30A'), 8.5, 8.98, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_79000; 328i, -Xi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N51B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N51B30A'), 1.3, 1.37, NULL, 'Dexron VI', 'HaynesPro typeId t_79000; 328i, -Xi; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N51B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'engine_oil', (SELECT id FROM engines WHERE code = 'N51B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_79000; 328i, -Xi; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N51B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'coolant', (SELECT id FROM engines WHERE code = 'N51B30A'), 8.5, 8.98, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_79000; 328i, -Xi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N51B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N51B30A'), 1.3, 1.37, NULL, 'Dexron VI', 'HaynesPro typeId t_79000; 328i, -Xi; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N51B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'engine_oil', (SELECT id FROM engines WHERE code = 'N51B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_79000; 328i, -Xi; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N51B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'coolant', (SELECT id FROM engines WHERE code = 'N51B30A'), 8.5, 8.98, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_79000; 328i, -Xi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N51B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N51B30A'), 1.3, 1.37, NULL, 'Dexron VI', 'HaynesPro typeId t_79000; 328i, -Xi; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N51B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'engine_oil', (SELECT id FROM engines WHERE code = 'N51B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_79000; 328i, -Xi; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N51B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'coolant', (SELECT id FROM engines WHERE code = 'N51B30A'), 8.5, 8.98, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_79000; 328i, -Xi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N51B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N51B30A'), 1.3, 1.37, NULL, 'Dexron VI', 'HaynesPro typeId t_79000; 328i, -Xi; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N51B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_619016957; 328i, -Xi; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'coolant', (SELECT id FROM engines WHERE code = 'N52B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619016957; 328i, -Xi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'transmission_at', (SELECT id FROM engines WHERE code = 'N52B30A'), 1.3, 1.37, NULL, 'MTF LT3', 'HaynesPro typeId t_619016957; 328i, -Xi; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_619016957; 328i, -Xi; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'coolant', (SELECT id FROM engines WHERE code = 'N52B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619016957; 328i, -Xi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'transmission_at', (SELECT id FROM engines WHERE code = 'N52B30A'), 1.3, 1.37, NULL, 'MTF LT3', 'HaynesPro typeId t_619016957; 328i, -Xi; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_619016957; 328i, -Xi; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'coolant', (SELECT id FROM engines WHERE code = 'N52B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619016957; 328i, -Xi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'transmission_at', (SELECT id FROM engines WHERE code = 'N52B30A'), 1.3, 1.37, NULL, 'MTF LT3', 'HaynesPro typeId t_619016957; 328i, -Xi; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_619016957; 328i, -Xi; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'coolant', (SELECT id FROM engines WHERE code = 'N52B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619016957; 328i, -Xi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'transmission_at', (SELECT id FROM engines WHERE code = 'N52B30A'), 1.3, 1.37, NULL, 'MTF LT3', 'HaynesPro typeId t_619016957; 328i, -Xi; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_619016957; 328i, -Xi; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'coolant', (SELECT id FROM engines WHERE code = 'N52B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619016957; 328i, -Xi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'transmission_at', (SELECT id FROM engines WHERE code = 'N52B30A'), 1.3, 1.37, NULL, 'MTF LT3', 'HaynesPro typeId t_619016957; 328i, -Xi; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_619016957; 328i, -Xi; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'coolant', (SELECT id FROM engines WHERE code = 'N52B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619016957; 328i, -Xi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'transmission_at', (SELECT id FROM engines WHERE code = 'N52B30A'), 1.3, 1.37, NULL, 'MTF LT3', 'HaynesPro typeId t_619016957; 328i, -Xi; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_619016957; 328i, -Xi; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'coolant', (SELECT id FROM engines WHERE code = 'N52B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619016957; 328i, -Xi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'transmission_at', (SELECT id FROM engines WHERE code = 'N52B30A'), 1.3, 1.37, NULL, 'MTF LT3', 'HaynesPro typeId t_619016957; 328i, -Xi; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_619016957; 328i, -Xi; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'coolant', (SELECT id FROM engines WHERE code = 'N52B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619016957; 328i, -Xi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'transmission_at', (SELECT id FROM engines WHERE code = 'N52B30A'), 1.3, 1.37, NULL, 'MTF LT3', 'HaynesPro typeId t_619016957; 328i, -Xi; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'engine_oil', (SELECT id FROM engines WHERE code = 'N54B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_78940; 335i, -Xi; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N54B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'coolant', (SELECT id FROM engines WHERE code = 'N54B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78940; 335i, -Xi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N54B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N54B30A'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_78940; 335i, -Xi; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N54B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'engine_oil', (SELECT id FROM engines WHERE code = 'N54B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_78940; 335i, -Xi; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N54B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'coolant', (SELECT id FROM engines WHERE code = 'N54B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78940; 335i, -Xi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N54B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N54B30A'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_78940; 335i, -Xi; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N54B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'engine_oil', (SELECT id FROM engines WHERE code = 'N54B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_78940; 335i, -Xi; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N54B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'coolant', (SELECT id FROM engines WHERE code = 'N54B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78940; 335i, -Xi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N54B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N54B30A'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_78940; 335i, -Xi; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N54B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'engine_oil', (SELECT id FROM engines WHERE code = 'N54B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_78940; 335i, -Xi; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N54B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'coolant', (SELECT id FROM engines WHERE code = 'N54B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78940; 335i, -Xi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N54B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N54B30A'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_78940; 335i, -Xi; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N54B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'engine_oil', (SELECT id FROM engines WHERE code = 'N54B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_78940; 335i, -Xi; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N54B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'coolant', (SELECT id FROM engines WHERE code = 'N54B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78940; 335i, -Xi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N54B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N54B30A'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_78940; 335i, -Xi; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N54B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'engine_oil', (SELECT id FROM engines WHERE code = 'N54B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_78940; 335i, -Xi; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N54B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'coolant', (SELECT id FROM engines WHERE code = 'N54B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78940; 335i, -Xi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N54B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N54B30A'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_78940; 335i, -Xi; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N54B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'engine_oil', (SELECT id FROM engines WHERE code = 'N54B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_78940; 335i, -Xi; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N54B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'coolant', (SELECT id FROM engines WHERE code = 'N54B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78940; 335i, -Xi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N54B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N54B30A'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_78940; 335i, -Xi; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N54B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'engine_oil', (SELECT id FROM engines WHERE code = 'N54B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_78940; 335i, -Xi; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N54B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'coolant', (SELECT id FROM engines WHERE code = 'N54B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78940; 335i, -Xi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N54B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N54B30A'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_78940; 335i, -Xi; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N54B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'engine_oil', (SELECT id FROM engines WHERE code = 'N55B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_106000248; 335i, -Xi; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'coolant', (SELECT id FROM engines WHERE code = 'N55B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_106000248; 335i, -Xi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N55B30A'), 1.6, 1.69, NULL, 'SAE 75W-80', 'HaynesPro typeId t_106000248; 335i, -Xi; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'engine_oil', (SELECT id FROM engines WHERE code = 'N55B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_106000248; 335i, -Xi; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'coolant', (SELECT id FROM engines WHERE code = 'N55B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_106000248; 335i, -Xi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N55B30A'), 1.6, 1.69, NULL, 'SAE 75W-80', 'HaynesPro typeId t_106000248; 335i, -Xi; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'engine_oil', (SELECT id FROM engines WHERE code = 'N55B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_106000248; 335i, -Xi; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'coolant', (SELECT id FROM engines WHERE code = 'N55B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_106000248; 335i, -Xi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N55B30A'), 1.6, 1.69, NULL, 'SAE 75W-80', 'HaynesPro typeId t_106000248; 335i, -Xi; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'engine_oil', (SELECT id FROM engines WHERE code = 'N55B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_106000248; 335i, -Xi; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'coolant', (SELECT id FROM engines WHERE code = 'N55B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_106000248; 335i, -Xi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N55B30A'), 1.6, 1.69, NULL, 'SAE 75W-80', 'HaynesPro typeId t_106000248; 335i, -Xi; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'engine_oil', (SELECT id FROM engines WHERE code = 'N55B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_106000248; 335i, -Xi; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'coolant', (SELECT id FROM engines WHERE code = 'N55B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_106000248; 335i, -Xi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N55B30A'), 1.6, 1.69, NULL, 'SAE 75W-80', 'HaynesPro typeId t_106000248; 335i, -Xi; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'engine_oil', (SELECT id FROM engines WHERE code = 'N55B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_106000248; 335i, -Xi; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'coolant', (SELECT id FROM engines WHERE code = 'N55B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_106000248; 335i, -Xi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N55B30A'), 1.6, 1.69, NULL, 'SAE 75W-80', 'HaynesPro typeId t_106000248; 335i, -Xi; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 192, 'engine_oil', (SELECT id FROM engines WHERE code = 'S65B40A'), 8.8, 9.3, '10W-60', NULL, 'HaynesPro typeId t_58360; M3; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 192 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S65B40A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 192, 'coolant', (SELECT id FROM engines WHERE code = 'S65B40A'), 11.4, 12.05, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58360; M3'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 192 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S65B40A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 192, 'transmission_mt', (SELECT id FROM engines WHERE code = 'S65B40A'), 1.6, 1.69, NULL, 'SAE 75W-140', 'HaynesPro typeId t_58360; M3; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 192 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'S65B40A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 193, 'engine_oil', (SELECT id FROM engines WHERE code = 'S65B40A'), 8.8, 9.3, '10W-60', NULL, 'HaynesPro typeId t_58360; M3; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 193 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S65B40A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 193, 'coolant', (SELECT id FROM engines WHERE code = 'S65B40A'), 11.4, 12.05, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58360; M3'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 193 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S65B40A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 193, 'transmission_mt', (SELECT id FROM engines WHERE code = 'S65B40A'), 1.6, 1.69, NULL, 'SAE 75W-140', 'HaynesPro typeId t_58360; M3; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 193 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'S65B40A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 194, 'engine_oil', (SELECT id FROM engines WHERE code = 'S65B40A'), 8.8, 9.3, '10W-60', NULL, 'HaynesPro typeId t_58360; M3; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 194 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S65B40A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 194, 'coolant', (SELECT id FROM engines WHERE code = 'S65B40A'), 11.4, 12.05, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58360; M3'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 194 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S65B40A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 194, 'transmission_mt', (SELECT id FROM engines WHERE code = 'S65B40A'), 1.6, 1.69, NULL, 'SAE 75W-140', 'HaynesPro typeId t_58360; M3; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 194 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'S65B40A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 192, 'engine_oil', (SELECT id FROM engines WHERE code = 'S65B44A'), 8.8, 9.3, '10W-60', NULL, 'HaynesPro typeId t_102002261; M3 GTS/CRT; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 192 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S65B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 192, 'coolant', (SELECT id FROM engines WHERE code = 'S65B44A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102002261; M3 GTS/CRT'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 192 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S65B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 192, 'transmission_mt', (SELECT id FROM engines WHERE code = 'S65B44A'), 1.6, 1.69, NULL, 'SAE 75W-140', 'HaynesPro typeId t_102002261; M3 GTS/CRT; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 192 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'S65B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 193, 'engine_oil', (SELECT id FROM engines WHERE code = 'S65B44A'), 8.8, 9.3, '10W-60', NULL, 'HaynesPro typeId t_102002261; M3 GTS/CRT; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 193 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S65B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 193, 'coolant', (SELECT id FROM engines WHERE code = 'S65B44A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102002261; M3 GTS/CRT'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 193 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S65B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 193, 'transmission_mt', (SELECT id FROM engines WHERE code = 'S65B44A'), 1.6, 1.69, NULL, 'SAE 75W-140', 'HaynesPro typeId t_102002261; M3 GTS/CRT; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 193 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'S65B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 194, 'engine_oil', (SELECT id FROM engines WHERE code = 'S65B44A'), 8.8, 9.3, '10W-60', NULL, 'HaynesPro typeId t_102002261; M3 GTS/CRT; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 194 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S65B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 194, 'coolant', (SELECT id FROM engines WHERE code = 'S65B44A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102002261; M3 GTS/CRT'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 194 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S65B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 194, 'transmission_mt', (SELECT id FROM engines WHERE code = 'S65B44A'), 1.6, 1.69, NULL, 'SAE 75W-140', 'HaynesPro typeId t_102002261; M3 GTS/CRT; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 194 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'S65B44A'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 185, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_900;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 185 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 187, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_900;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 187 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 188, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_900;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 188 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 189, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_900;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 189 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 190, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_900;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 190 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 191, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_900;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 191 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 184, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_900;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 184 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 186, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_900;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 186 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 192, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_900;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 192 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 193, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_900;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 193 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 194, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_900;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 194 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (185, 187, 188, 189, 190, 191, 184, 186, 192, 193, 194)
  AND e.code IN ('N47D20C', 'N45B16A', 'N43B16A', 'N45B16AC', 'M47D20TU2uL', 'N47D20A', 'N43B20A', 'N46B20B', 'N45B20A', 'M47D20TU2OL', 'N52B25A', 'M57D30T2', 'N57D30A', 'N53B30A', 'N51B30A', 'N52B30A', 'N54B30A', 'N55B30A', 'S65B40A', 'S65B44A')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (185, 187, 188, 189, 190, 191, 184, 186, 192, 193, 194)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (185, 187, 188, 189, 190, 191, 184, 186, 192, 193, 194) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;