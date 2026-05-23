-- mig 255 — multi-gen HaynesPro ingest: BMW X5 (E70)
-- crawl: haynespro-crawl-bmw-x5-e70-2026-05-23.json
-- modelId: d_1000001
-- 10 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — BMW X5 (E70)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_1000001', NOW(), 'Multi-gen ingest, 10 engines across 2 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_1000001' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('M57D30T2', '3.0d (M57D30T2) 155kW', 2993, 'petrol', 'NA', NULL),
  ('M57D30T2TOP', '3.0sd (M57D30T2TOP) 210kW', 2993, 'petrol', 'NA', NULL),
  ('N52B30A', '3.0si, xDrive 30i, -LPG (N52B30A) 200kW', 2996, 'petrol', 'NA', NULL),
  ('N62B48B', '4.8i, xDrive 48i, -LPG (N62B48B) 261kW', 4799, 'petrol', 'NA', NULL),
  ('S63B44A', 'M (S63B44A) 408kW', 4395, 'petrol', 'turbo', NULL),
  ('N57D30A', 'xDrive 30d (N57D30A) 180kW', 2993, 'diesel', 'NA', NULL),
  ('N55B30A', 'xDrive 35i (N55B30A) 225kW', 2979, 'petrol', 'turbo', NULL),
  ('N57D30B', 'xDrive 40d (N57D30B) 225kW', 2993, 'diesel', 'NA', NULL),
  ('N63B44A', 'xDrive 50i (N63B44A) 300kW', 4395, 'petrol', 'turbo', NULL),
  ('N57D30C', 'xDrive M50d (N57D30C) 280kW', 2993, 'diesel', 'NA', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 177, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30T2'), 7.3, 7.71, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102002553; 3.0d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 177 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 177, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30T2'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102002553; 3.0d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 177 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 177, 'transmission_at', (SELECT id FROM engines WHERE code = 'M57D30T2'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_102002553; 3.0d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 177 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 178, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30T2'), 7.3, 7.71, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102002553; 3.0d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 178 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 178, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30T2'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102002553; 3.0d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 178 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 178, 'transmission_at', (SELECT id FROM engines WHERE code = 'M57D30T2'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_102002553; 3.0d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 178 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 177, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30T2TOP'), 7.5, 7.93, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_1000005; 3.0sd; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 177 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2TOP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 177, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30T2TOP'), 10.4, 10.99, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_1000005; 3.0sd'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 177 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2TOP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 177, 'transmission_at', (SELECT id FROM engines WHERE code = 'M57D30T2TOP'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_1000005; 3.0sd; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 177 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2TOP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 178, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30T2TOP'), 7.5, 7.93, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_1000005; 3.0sd; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 178 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2TOP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 178, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30T2TOP'), 10.4, 10.99, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_1000005; 3.0sd'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 178 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2TOP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 178, 'transmission_at', (SELECT id FROM engines WHERE code = 'M57D30T2TOP'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_1000005; 3.0sd; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 178 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2TOP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 177, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B30A'), NULL, NULL, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_1000002; 3.0si, xDrive 30i, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 177 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 177, 'coolant', (SELECT id FROM engines WHERE code = 'N52B30A'), 10.5, 11.1, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_1000002; 3.0si, xDrive 30i, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 177 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 177, 'transmission_at', (SELECT id FROM engines WHERE code = 'N52B30A'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_1000002; 3.0si, xDrive 30i, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 177 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 178, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B30A'), NULL, NULL, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_1000002; 3.0si, xDrive 30i, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 178 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 178, 'coolant', (SELECT id FROM engines WHERE code = 'N52B30A'), 10.5, 11.1, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_1000002; 3.0si, xDrive 30i, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 178 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 178, 'transmission_at', (SELECT id FROM engines WHERE code = 'N52B30A'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_1000002; 3.0si, xDrive 30i, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 178 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 177, 'engine_oil', (SELECT id FROM engines WHERE code = 'N62B48B'), 8, 8.45, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_1000003; 4.8i, xDrive 48i, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 177 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B48B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 177, 'coolant', (SELECT id FROM engines WHERE code = 'N62B48B'), 14, 14.79, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_1000003; 4.8i, xDrive 48i, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 177 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B48B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 177, 'transmission_at', (SELECT id FROM engines WHERE code = 'N62B48B'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_1000003; 4.8i, xDrive 48i, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 177 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B48B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 178, 'engine_oil', (SELECT id FROM engines WHERE code = 'N62B48B'), 8, 8.45, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_1000003; 4.8i, xDrive 48i, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 178 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B48B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 178, 'coolant', (SELECT id FROM engines WHERE code = 'N62B48B'), 14, 14.79, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_1000003; 4.8i, xDrive 48i, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 178 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B48B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 178, 'transmission_at', (SELECT id FROM engines WHERE code = 'N62B48B'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_1000003; 4.8i, xDrive 48i, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 178 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B48B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 177, 'engine_oil', (SELECT id FROM engines WHERE code = 'S63B44A'), 8.5, 8.98, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102001245; M; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 177 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 177, 'coolant', (SELECT id FROM engines WHERE code = 'S63B44A'), 17, 17.96, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001245; M'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 177 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 177, 'transmission_at', (SELECT id FROM engines WHERE code = 'S63B44A'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_102001245; M; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 177 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'S63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 178, 'engine_oil', (SELECT id FROM engines WHERE code = 'S63B44A'), 8.5, 8.98, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102001245; M; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 178 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 178, 'coolant', (SELECT id FROM engines WHERE code = 'S63B44A'), 17, 17.96, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001245; M'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 178 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 178, 'transmission_at', (SELECT id FROM engines WHERE code = 'S63B44A'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_102001245; M; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 178 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'S63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 177, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30A'), 6.7, 7.08, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102001374; xDrive 30d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 177 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 177, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30A'), 10.4, 10.99, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001374; xDrive 30d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 177 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 177, 'transmission_at', (SELECT id FROM engines WHERE code = 'N57D30A'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_102001374; xDrive 30d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 177 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 178, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30A'), 6.7, 7.08, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102001374; xDrive 30d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 178 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 178, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30A'), 10.4, 10.99, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001374; xDrive 30d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 178 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 178, 'transmission_at', (SELECT id FROM engines WHERE code = 'N57D30A'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_102001374; xDrive 30d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 178 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 177, 'engine_oil', (SELECT id FROM engines WHERE code = 'N55B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_102001372; xDrive 35i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 177 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 177, 'coolant', (SELECT id FROM engines WHERE code = 'N55B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001372; xDrive 35i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 177 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 177, 'transmission_at', (SELECT id FROM engines WHERE code = 'N55B30A'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_102001372; xDrive 35i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 177 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 178, 'engine_oil', (SELECT id FROM engines WHERE code = 'N55B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_102001372; xDrive 35i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 178 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 178, 'coolant', (SELECT id FROM engines WHERE code = 'N55B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001372; xDrive 35i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 178 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 178, 'transmission_at', (SELECT id FROM engines WHERE code = 'N55B30A'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_102001372; xDrive 35i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 178 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 177, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30B'), 6.7, 7.08, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102001375; xDrive 40d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 177 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 177, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30B'), 10.4, 10.99, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001375; xDrive 40d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 177 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 177, 'transmission_at', (SELECT id FROM engines WHERE code = 'N57D30B'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_102001375; xDrive 40d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 177 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 178, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30B'), 6.7, 7.08, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102001375; xDrive 40d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 178 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 178, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30B'), 10.4, 10.99, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001375; xDrive 40d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 178 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 178, 'transmission_at', (SELECT id FROM engines WHERE code = 'N57D30B'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_102001375; xDrive 40d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 178 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 177, 'engine_oil', (SELECT id FROM engines WHERE code = 'N63B44A'), 8.5, 8.98, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102001373; xDrive 50i; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 177 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 177, 'coolant', (SELECT id FROM engines WHERE code = 'N63B44A'), 17.2, 18.18, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001373; xDrive 50i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 177 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 177, 'transmission_at', (SELECT id FROM engines WHERE code = 'N63B44A'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_102001373; xDrive 50i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 177 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 178, 'engine_oil', (SELECT id FROM engines WHERE code = 'N63B44A'), 8.5, 8.98, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102001373; xDrive 50i; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 178 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 178, 'coolant', (SELECT id FROM engines WHERE code = 'N63B44A'), 17.2, 18.18, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001373; xDrive 50i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 178 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 178, 'transmission_at', (SELECT id FROM engines WHERE code = 'N63B44A'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_102001373; xDrive 50i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 178 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 178, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30C'), 6.5, 6.87, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_201000016; xDrive M50d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 178 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 178, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30C'), 13, 13.74, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_201000016; xDrive M50d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 178 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 178, 'transmission_at', (SELECT id FROM engines WHERE code = 'N57D30C'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_201000016; xDrive M50d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 178 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30C'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 177, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_1000001;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 177 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 178, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_1000001;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 178 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (177, 178)
  AND e.code IN ('M57D30T2', 'M57D30T2TOP', 'N52B30A', 'N62B48B', 'S63B44A', 'N57D30A', 'N55B30A', 'N57D30B', 'N63B44A', 'N57D30C')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (177, 178)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (177, 178) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;