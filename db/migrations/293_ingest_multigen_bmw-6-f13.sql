-- mig 293 — multi-gen HaynesPro ingest: BMW 6 (F06, F12, F13)
-- crawl: haynespro-crawl-bmw-6-f13-2026-05-23.json
-- modelId: d_102000141
-- 5 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — BMW 6 (F06, F12, F13)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_102000141', NOW(), 'Multi-gen ingest, 5 engines across 6 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_102000141' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('N57D30B', '640d, -xDrive (N57D30B) 230kW', 2993, 'diesel', 'NA', NULL),
  ('N55B30A', '640i, -xDrive (N55B30A) 235kW', 2979, 'petrol', 'turbo', NULL),
  ('N63B44A', '650i, -xDrive (N63B44A) 300kW', 4395, 'petrol', 'turbo', NULL),
  ('N63B44B', '650i, -xDrive (N63B44B) 330kW', 4395, 'petrol', 'turbo', NULL),
  ('S63B44B', 'M6 (S63B44B) 412kW', 4395, 'petrol', 'turbo', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 257, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30B'), 6.5, 6.87, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_200000135; 640d, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 257 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 257, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30B'), 8, 8.45, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_200000135; 640d, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 257 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 257, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N57D30B'), 1.6, 1.69, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_200000135; 640d, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 257 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 258, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30B'), 6.5, 6.87, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_200000135; 640d, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 258 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 258, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30B'), 8, 8.45, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_200000135; 640d, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 258 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 258, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N57D30B'), 1.6, 1.69, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_200000135; 640d, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 258 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 259, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30B'), 6.5, 6.87, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_200000135; 640d, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 259 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 259, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30B'), 8, 8.45, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_200000135; 640d, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 259 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 259, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N57D30B'), 1.6, 1.69, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_200000135; 640d, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 259 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 257, 'engine_oil', (SELECT id FROM engines WHERE code = 'N55B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_102002258; 640i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 257 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 257, 'coolant', (SELECT id FROM engines WHERE code = 'N55B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102002258; 640i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 257 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 257, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N55B30A'), 1.2, 1.27, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_102002258; 640i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 257 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 258, 'engine_oil', (SELECT id FROM engines WHERE code = 'N55B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_102002258; 640i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 258 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 258, 'coolant', (SELECT id FROM engines WHERE code = 'N55B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102002258; 640i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 258 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 258, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N55B30A'), 1.2, 1.27, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_102002258; 640i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 258 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 259, 'engine_oil', (SELECT id FROM engines WHERE code = 'N55B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_102002258; 640i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 259 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 259, 'coolant', (SELECT id FROM engines WHERE code = 'N55B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102002258; 640i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 259 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 259, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N55B30A'), 1.2, 1.27, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_102002258; 640i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 259 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 257, 'engine_oil', (SELECT id FROM engines WHERE code = 'N63B44A'), 9, 9.51, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102002259; 650i, -xDrive; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 257 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 257, 'coolant', (SELECT id FROM engines WHERE code = 'N63B44A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102002259; 650i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 257 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 257, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N63B44A'), 1.6, 1.69, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_102002259; 650i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 257 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 258, 'engine_oil', (SELECT id FROM engines WHERE code = 'N63B44A'), 9, 9.51, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102002259; 650i, -xDrive; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 258 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 258, 'coolant', (SELECT id FROM engines WHERE code = 'N63B44A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102002259; 650i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 258 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 258, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N63B44A'), 1.6, 1.69, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_102002259; 650i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 258 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 259, 'engine_oil', (SELECT id FROM engines WHERE code = 'N63B44A'), 9, 9.51, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102002259; 650i, -xDrive; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 259 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 259, 'coolant', (SELECT id FROM engines WHERE code = 'N63B44A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102002259; 650i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 259 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 259, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N63B44A'), 1.6, 1.69, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_102002259; 650i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 259 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 257, 'engine_oil', (SELECT id FROM engines WHERE code = 'N63B44B'), 9.5, 10.04, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_201000026; 650i, -xDrive; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 257 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 257, 'coolant', (SELECT id FROM engines WHERE code = 'N63B44B'), 14.4, 15.22, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_201000026; 650i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 257 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 257, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N63B44B'), 1.6, 1.69, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_201000026; 650i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 257 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 258, 'engine_oil', (SELECT id FROM engines WHERE code = 'N63B44B'), 9.5, 10.04, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_201000026; 650i, -xDrive; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 258 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 258, 'coolant', (SELECT id FROM engines WHERE code = 'N63B44B'), 14.4, 15.22, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_201000026; 650i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 258 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 258, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N63B44B'), 1.6, 1.69, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_201000026; 650i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 258 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 259, 'engine_oil', (SELECT id FROM engines WHERE code = 'N63B44B'), 9.5, 10.04, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_201000026; 650i, -xDrive; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 259 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 259, 'coolant', (SELECT id FROM engines WHERE code = 'N63B44B'), 14.4, 15.22, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_201000026; 650i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 259 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 259, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N63B44B'), 1.6, 1.69, NULL, 'BMW ATF 3+ (BMW 83 22 5 A12 A00)', 'HaynesPro typeId t_201000026; 650i, -xDrive; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 259 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 260, 'engine_oil', (SELECT id FROM engines WHERE code = 'S63B44B'), 8.5, 8.98, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_201000020; M6; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 260 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 260, 'coolant', (SELECT id FROM engines WHERE code = 'S63B44B'), 18.5, 19.55, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_201000020; M6'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 260 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 260, 'transmission_dct', (SELECT id FROM engines WHERE code = 'S63B44B'), 7.8, 8.24, NULL, 'SAE 75W-140', 'HaynesPro typeId t_201000020; M6; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 260 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'S63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 261, 'engine_oil', (SELECT id FROM engines WHERE code = 'S63B44B'), 8.5, 8.98, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_201000020; M6; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 261 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 261, 'coolant', (SELECT id FROM engines WHERE code = 'S63B44B'), 18.5, 19.55, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_201000020; M6'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 261 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 261, 'transmission_dct', (SELECT id FROM engines WHERE code = 'S63B44B'), 7.8, 8.24, NULL, 'SAE 75W-140', 'HaynesPro typeId t_201000020; M6; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 261 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'S63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 262, 'engine_oil', (SELECT id FROM engines WHERE code = 'S63B44B'), 8.5, 8.98, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_201000020; M6; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 262 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 262, 'coolant', (SELECT id FROM engines WHERE code = 'S63B44B'), 18.5, 19.55, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_201000020; M6'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 262 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 262, 'transmission_dct', (SELECT id FROM engines WHERE code = 'S63B44B'), 7.8, 8.24, NULL, 'SAE 75W-140', 'HaynesPro typeId t_201000020; M6; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 262 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'S63B44B'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 257, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_102000141;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 257 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 258, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_102000141;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 258 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 259, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_102000141;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 259 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 260, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_102000141;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 260 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 261, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_102000141;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 261 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 262, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_102000141;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 262 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (257, 258, 259, 260, 261, 262)
  AND e.code IN ('N57D30B', 'N55B30A', 'N63B44A', 'N63B44B', 'S63B44B')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (257, 258, 259, 260, 261, 262)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (257, 258, 259, 260, 261, 262) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;