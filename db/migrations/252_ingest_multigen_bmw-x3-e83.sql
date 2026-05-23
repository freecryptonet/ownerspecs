-- mig 252 — multi-gen HaynesPro ingest: BMW X3 (E83)
-- crawl: haynespro-crawl-bmw-x3-e83-2026-05-23.json
-- modelId: d_840
-- 11 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — BMW X3 (E83)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_840', NOW(), 'Multi-gen ingest, 11 engines across 2 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_840' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('M47D20T2oL', '2.0d (M47D20T2oL) 110kW', 1995, 'diesel', 'NA', NULL),
  ('N47D20A', '2.0d (N47D20A) 130kW', 1995, 'diesel', 'NA', NULL),
  ('N46B20B', '2.0i, -LPG (N46B20B) 110kW', 1995, 'petrol', 'NA', NULL),
  ('M54B25', '2.5i, -LPG (M54B25) 141kW', 2494, 'petrol', 'NA', NULL),
  ('N52B25A', '2.5si, -LPG (N52B25A) 160kW', 2497, 'petrol', 'NA', NULL),
  ('M57D30TU', '3.0d (M57D30TU) 150kW', 2993, 'petrol', 'NA', NULL),
  ('M57D30T2', '3.0d (M57D30T2) 160kW', 2993, 'petrol', 'NA', NULL),
  ('M54B30', '3.0i, -LPG (M54B30) 170kW', 2979, 'petrol', 'NA', NULL),
  ('M57D30T2TOP', '3.0sd (M57D30T2TOP) 210kW', 2993, 'petrol', 'NA', NULL),
  ('N52B30A', '3.0si (N52B30A) 200kW', 2996, 'petrol', 'NA', NULL),
  ('N47D20C', 'xDrive 18d (N47D20C) 105kW', 1995, 'diesel', 'NA', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 170, 'engine_oil', (SELECT id FROM engines WHERE code = 'M47D20T2oL'), 5.3, 5.6, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_58800; 2.0d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 170 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20T2oL'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 170, 'coolant', (SELECT id FROM engines WHERE code = 'M47D20T2oL'), 9.6, 10.14, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58800; 2.0d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 170 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20T2oL'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 170, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M47D20T2oL'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_58800; 2.0d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 170 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20T2oL'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 171, 'engine_oil', (SELECT id FROM engines WHERE code = 'M47D20T2oL'), 5.3, 5.6, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_58800; 2.0d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 171 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20T2oL'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 171, 'coolant', (SELECT id FROM engines WHERE code = 'M47D20T2oL'), 9.6, 10.14, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58800; 2.0d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 171 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20T2oL'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 171, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M47D20T2oL'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_58800; 2.0d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 171 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M47D20T2oL'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 171, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20A'), 5.3, 5.6, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_58780; 2.0d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 171 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 171, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58780; 2.0d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 171 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 171, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20A'), 1.6, 1.69, NULL, 'SAE 75W-80', 'HaynesPro typeId t_58780; 2.0d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 171 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 170, 'engine_oil', (SELECT id FROM engines WHERE code = 'N46B20B'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_58830; 2.0i, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 170 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 170, 'coolant', (SELECT id FROM engines WHERE code = 'N46B20B'), 9, 9.51, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58830; 2.0i, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 170 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 170, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N46B20B'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_58830; 2.0i, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 170 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 171, 'engine_oil', (SELECT id FROM engines WHERE code = 'N46B20B'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_58830; 2.0i, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 171 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 171, 'coolant', (SELECT id FROM engines WHERE code = 'N46B20B'), 9, 9.51, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58830; 2.0i, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 171 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 171, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N46B20B'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_58830; 2.0i, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 171 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 170, 'engine_oil', (SELECT id FROM engines WHERE code = 'M54B25'), 6.2, 6.55, '5W-30', 'BMW Longlife-01', 'HaynesPro typeId t_58760; 2.5i, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 170 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B25'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 170, 'coolant', (SELECT id FROM engines WHERE code = 'M54B25'), 10.6, 11.2, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58760; 2.5i, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 170 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B25'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 170, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M54B25'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_58760; 2.5i, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 170 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B25'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 171, 'engine_oil', (SELECT id FROM engines WHERE code = 'M54B25'), 6.2, 6.55, '5W-30', 'BMW Longlife-01', 'HaynesPro typeId t_58760; 2.5i, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 171 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B25'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 171, 'coolant', (SELECT id FROM engines WHERE code = 'M54B25'), 10.6, 11.2, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58760; 2.5i, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 171 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B25'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 171, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M54B25'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_58760; 2.5i, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 171 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B25'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 170, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B25A'), NULL, NULL, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_48820; 2.5si, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 170 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 170, 'coolant', (SELECT id FROM engines WHERE code = 'N52B25A'), 10, 10.57, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_48820; 2.5si, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 170 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 170, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N52B25A'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_48820; 2.5si, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 170 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 171, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B25A'), NULL, NULL, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_48820; 2.5si, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 171 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 171, 'coolant', (SELECT id FROM engines WHERE code = 'N52B25A'), 10, 10.57, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_48820; 2.5si, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 171 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 171, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N52B25A'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_48820; 2.5si, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 171 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 170, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30TU'), 7.5, 7.93, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_58790; 3.0d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 170 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30TU'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 170, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30TU'), 10, 10.57, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58790; 3.0d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 170 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30TU'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 170, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M57D30TU'), 1.6, 1.69, NULL, 'ETL 7045 E', 'HaynesPro typeId t_58790; 3.0d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 170 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30TU'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 171, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30TU'), 7.5, 7.93, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_58790; 3.0d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 171 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30TU'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 171, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30TU'), 10, 10.57, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58790; 3.0d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 171 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30TU'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 171, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M57D30TU'), 1.6, 1.69, NULL, 'ETL 7045 E', 'HaynesPro typeId t_58790; 3.0d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 171 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30TU'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 170, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30T2'), 7.5, 7.93, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_79120; 3.0d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 170 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 170, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30T2'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_79120; 3.0d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 170 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 170, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M57D30T2'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_79120; 3.0d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 170 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 171, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30T2'), 7.5, 7.93, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_79120; 3.0d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 171 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 171, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30T2'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_79120; 3.0d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 171 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 171, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M57D30T2'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_79120; 3.0d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 171 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 170, 'engine_oil', (SELECT id FROM engines WHERE code = 'M54B30'), 6.2, 6.55, '5W-30', 'BMW Longlife-01', 'HaynesPro typeId t_58770; 3.0i, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 170 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B30'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 170, 'coolant', (SELECT id FROM engines WHERE code = 'M54B30'), 10.6, 11.2, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58770; 3.0i, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 170 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B30'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 170, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M54B30'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_58770; 3.0i, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 170 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B30'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 171, 'engine_oil', (SELECT id FROM engines WHERE code = 'M54B30'), 6.2, 6.55, '5W-30', 'BMW Longlife-01', 'HaynesPro typeId t_58770; 3.0i, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 171 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B30'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 171, 'coolant', (SELECT id FROM engines WHERE code = 'M54B30'), 10.6, 11.2, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58770; 3.0i, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 171 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B30'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 171, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M54B30'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_58770; 3.0i, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 171 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B30'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 170, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30T2TOP'), 7.5, 7.93, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_48590; 3.0sd; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 170 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2TOP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 170, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30T2TOP'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_48590; 3.0sd'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 170 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2TOP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 170, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M57D30T2TOP'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_48590; 3.0sd; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 170 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2TOP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 171, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30T2TOP'), 7.5, 7.93, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_48590; 3.0sd; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 171 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2TOP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 171, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30T2TOP'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_48590; 3.0sd'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 171 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2TOP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 171, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M57D30T2TOP'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_48590; 3.0sd; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 171 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2TOP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 170, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B30A'), 6.2, 6.55, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_79130; 3.0si; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 170 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 170, 'coolant', (SELECT id FROM engines WHERE code = 'N52B30A'), 11, 11.62, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_79130; 3.0si'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 170 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 170, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N52B30A'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_79130; 3.0si; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 170 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 171, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B30A'), 6.2, 6.55, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_79130; 3.0si; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 171 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 171, 'coolant', (SELECT id FROM engines WHERE code = 'N52B30A'), 11, 11.62, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_79130; 3.0si'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 171 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 171, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N52B30A'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_79130; 3.0si; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 171 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 171, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20C'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102001281; xDrive 18d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 171 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 171, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20C'), 9.5, 10.04, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001281; xDrive 18d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 171 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 171, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20C'), 1.6, 1.69, NULL, 'BMW ATF 2', 'HaynesPro typeId t_102001281; xDrive 18d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 171 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 170, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_840;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 170 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 171, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_840;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 171 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (170, 171)
  AND e.code IN ('M47D20T2oL', 'N47D20A', 'N46B20B', 'M54B25', 'N52B25A', 'M57D30TU', 'M57D30T2', 'M54B30', 'M57D30T2TOP', 'N52B30A', 'N47D20C')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (170, 171)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (170, 171) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;