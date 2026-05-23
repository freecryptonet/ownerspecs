-- mig 284 — multi-gen HaynesPro ingest: BMW X6 (F96, G06)
-- crawl: haynespro-crawl-bmw-x6-g06-2026-05-23.json
-- modelId: d_319004646
-- 9 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — BMW X6 (F96, G06)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319004646', NOW(), 'Multi-gen ingest, 9 engines across 4 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319004646' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('S63B44B', 'M (S63B44B) 441kW', 4395, 'petrol', 'turbo', NULL),
  ('S68B44A', 'M Competition (S68B44A) 460kW', 4395, 'petrol', 'NA', NULL),
  ('B57D30C', 'M50d (B57D30C) 294kW', 2993, 'diesel', 'turbo', NULL),
  ('N63B44D', 'M50i (N63B44D) 390kW', 4395, 'petrol', 'turbo', NULL),
  ('B57D30A', 'xDrive 30d (B57D30A) 195kW', 2993, 'diesel', 'turbo', NULL),
  ('B57D30B', 'xDrive 30d M Sport (B57D30B) 219kW', 2993, 'diesel', 'turbo', NULL),
  ('B48B20B', 'xDrive 30i (B48B20B) 195kW', 1998, 'petrol', 'turbo', NULL),
  ('B58B30C', 'xDrive 40i (B58B30C) 250kW', 2998, 'petrol', 'turbo', NULL),
  ('B58B30P', 'xDrive 40i M Sport (B58B30P) 280kW', 2998, 'petrol', 'turbo', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 237, 'engine_oil', (SELECT id FROM engines WHERE code = 'S63B44B'), 10, 10.57, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_619024325; M; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 237 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 237, 'coolant', (SELECT id FROM engines WHERE code = 'S63B44B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619024325; M'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 237 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 237, 'transmission_at', (SELECT id FROM engines WHERE code = 'S63B44B'), 9.35, 9.88, NULL, 'BMW DTF1', 'HaynesPro typeId t_619024325; M; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 237 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'S63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 238, 'engine_oil', (SELECT id FROM engines WHERE code = 'S63B44B'), 10, 10.57, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_619024325; M; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 238 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 238, 'coolant', (SELECT id FROM engines WHERE code = 'S63B44B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619024325; M'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 238 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 238, 'transmission_at', (SELECT id FROM engines WHERE code = 'S63B44B'), 9.35, 9.88, NULL, 'BMW DTF1', 'HaynesPro typeId t_619024325; M; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 238 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'S63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 239, 'engine_oil', (SELECT id FROM engines WHERE code = 'S63B44B'), 10, 10.57, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_619024325; M; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 239 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 239, 'coolant', (SELECT id FROM engines WHERE code = 'S63B44B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619024325; M'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 239 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 239, 'transmission_at', (SELECT id FROM engines WHERE code = 'S63B44B'), 9.35, 9.88, NULL, 'BMW DTF1', 'HaynesPro typeId t_619024325; M; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 239 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'S63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 240, 'engine_oil', (SELECT id FROM engines WHERE code = 'S63B44B'), 10, 10.57, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_619024325; M; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 240 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 240, 'coolant', (SELECT id FROM engines WHERE code = 'S63B44B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619024325; M'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 240 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 240, 'transmission_at', (SELECT id FROM engines WHERE code = 'S63B44B'), 9.35, 9.88, NULL, 'BMW DTF1', 'HaynesPro typeId t_619024325; M; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 240 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'S63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 239, 'engine_oil', (SELECT id FROM engines WHERE code = 'S68B44A'), 10.8, 11.41, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_619116827; M Competition; drain 6 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 239 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S68B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 239, 'coolant', (SELECT id FROM engines WHERE code = 'S68B44A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619116827; M Competition'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 239 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S68B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 239, 'transmission_at', (SELECT id FROM engines WHERE code = 'S68B44A'), 8, 8.45, NULL, 'BMW DTF1', 'HaynesPro typeId t_619116827; M Competition; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 239 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'S68B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 240, 'engine_oil', (SELECT id FROM engines WHERE code = 'S68B44A'), 10.8, 11.41, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_619116827; M Competition; drain 6 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 240 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S68B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 240, 'coolant', (SELECT id FROM engines WHERE code = 'S68B44A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619116827; M Competition'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 240 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S68B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 240, 'transmission_at', (SELECT id FROM engines WHERE code = 'S68B44A'), 8, 8.45, NULL, 'BMW DTF1', 'HaynesPro typeId t_619116827; M Competition; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 240 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'S68B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 237, 'engine_oil', (SELECT id FROM engines WHERE code = 'S68B44A'), 10.8, 11.41, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_619116827; M Competition; drain 6 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 237 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S68B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 237, 'coolant', (SELECT id FROM engines WHERE code = 'S68B44A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619116827; M Competition'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 237 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S68B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 237, 'transmission_at', (SELECT id FROM engines WHERE code = 'S68B44A'), 8, 8.45, NULL, 'BMW DTF1', 'HaynesPro typeId t_619116827; M Competition; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 237 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'S68B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 238, 'engine_oil', (SELECT id FROM engines WHERE code = 'S68B44A'), 10.8, 11.41, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_619116827; M Competition; drain 6 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 238 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S68B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 238, 'coolant', (SELECT id FROM engines WHERE code = 'S68B44A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619116827; M Competition'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 238 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S68B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 238, 'transmission_at', (SELECT id FROM engines WHERE code = 'S68B44A'), 8, 8.45, NULL, 'BMW DTF1', 'HaynesPro typeId t_619116827; M Competition; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 238 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'S68B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 237, 'engine_oil', (SELECT id FROM engines WHERE code = 'B57D30C'), 6.5, 6.87, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_619022909; M50d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 237 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 237, 'coolant', (SELECT id FROM engines WHERE code = 'B57D30C'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619022909; M50d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 237 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 237, 'transmission_at', (SELECT id FROM engines WHERE code = 'B57D30C'), 9.35, 9.88, NULL, 'BMW DTF1', 'HaynesPro typeId t_619022909; M50d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 237 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 237, 'engine_oil', (SELECT id FROM engines WHERE code = 'N63B44D'), 10.5, 11.1, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_619022910; M50i; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 237 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 237, 'coolant', (SELECT id FROM engines WHERE code = 'N63B44D'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619022910; M50i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 237 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 237, 'transmission_at', (SELECT id FROM engines WHERE code = 'N63B44D'), 9.35, 9.88, NULL, 'BMW DTF1', 'HaynesPro typeId t_619022910; M50i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 237 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 238, 'engine_oil', (SELECT id FROM engines WHERE code = 'N63B44D'), 10.5, 11.1, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_619022910; M50i; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 238 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 238, 'coolant', (SELECT id FROM engines WHERE code = 'N63B44D'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619022910; M50i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 238 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 238, 'transmission_at', (SELECT id FROM engines WHERE code = 'N63B44D'), 9.35, 9.88, NULL, 'BMW DTF1', 'HaynesPro typeId t_619022910; M50i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 238 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 237, 'engine_oil', (SELECT id FROM engines WHERE code = 'B57D30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_619022908; xDrive 30d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 237 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 237, 'coolant', (SELECT id FROM engines WHERE code = 'B57D30A'), 10, 10.57, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619022908; xDrive 30d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 237 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 237, 'transmission_at', (SELECT id FROM engines WHERE code = 'B57D30A'), 9.35, 9.88, NULL, 'BMW DTF1', 'HaynesPro typeId t_619022908; xDrive 30d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 237 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 237, 'engine_oil', (SELECT id FROM engines WHERE code = 'B57D30B'), 8.3, 8.77, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_619144959; xDrive 30d M Sport; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 237 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 237, 'coolant', (SELECT id FROM engines WHERE code = 'B57D30B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619144959; xDrive 30d M Sport'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 237 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 237, 'transmission_at', (SELECT id FROM engines WHERE code = 'B57D30B'), 8, 8.45, NULL, 'BMW DTF1', 'HaynesPro typeId t_619144959; xDrive 30d M Sport; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 237 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 238, 'engine_oil', (SELECT id FROM engines WHERE code = 'B57D30B'), 8.3, 8.77, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_619144959; xDrive 30d M Sport; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 238 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 238, 'coolant', (SELECT id FROM engines WHERE code = 'B57D30B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619144959; xDrive 30d M Sport'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 238 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 238, 'transmission_at', (SELECT id FROM engines WHERE code = 'B57D30B'), 8, 8.45, NULL, 'BMW DTF1', 'HaynesPro typeId t_619144959; xDrive 30d M Sport; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 238 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 237, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B20B'), 5.8, 6.13, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619116933; xDrive 30i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 237 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 237, 'coolant', (SELECT id FROM engines WHERE code = 'B48B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619116933; xDrive 30i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 237 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 237, 'transmission_at', (SELECT id FROM engines WHERE code = 'B48B20B'), 9.28, 9.81, NULL, 'BMW DTF1', 'HaynesPro typeId t_619116933; xDrive 30i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 237 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 238, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B20B'), 5.8, 6.13, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619116933; xDrive 30i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 238 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 238, 'coolant', (SELECT id FROM engines WHERE code = 'B48B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619116933; xDrive 30i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 238 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 238, 'transmission_at', (SELECT id FROM engines WHERE code = 'B48B20B'), 9.28, 9.81, NULL, 'BMW DTF1', 'HaynesPro typeId t_619116933; xDrive 30i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 238 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 237, 'engine_oil', (SELECT id FROM engines WHERE code = 'B58B30C'), 6.5, 6.87, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619024327; xDrive 40i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 237 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 237, 'coolant', (SELECT id FROM engines WHERE code = 'B58B30C'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619024327; xDrive 40i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 237 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 237, 'transmission_at', (SELECT id FROM engines WHERE code = 'B58B30C'), 9.28, 9.81, NULL, 'BMW DTF1', 'HaynesPro typeId t_619024327; xDrive 40i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 237 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 237, 'engine_oil', (SELECT id FROM engines WHERE code = 'B58B30P'), 6.75, 7.13, '0W-12', 'BMW Longlife-22 FE++', 'HaynesPro typeId t_619116367; xDrive 40i M Sport; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 237 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30P'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 237, 'coolant', (SELECT id FROM engines WHERE code = 'B58B30P'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619116367; xDrive 40i M Sport'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 237 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30P'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 237, 'transmission_at', (SELECT id FROM engines WHERE code = 'B58B30P'), 8, 8.45, NULL, 'BMW ATF 8', 'HaynesPro typeId t_619116367; xDrive 40i M Sport; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 237 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30P'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 238, 'engine_oil', (SELECT id FROM engines WHERE code = 'B58B30P'), 6.75, 7.13, '0W-12', 'BMW Longlife-22 FE++', 'HaynesPro typeId t_619116367; xDrive 40i M Sport; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 238 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30P'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 238, 'coolant', (SELECT id FROM engines WHERE code = 'B58B30P'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619116367; xDrive 40i M Sport'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 238 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30P'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 238, 'transmission_at', (SELECT id FROM engines WHERE code = 'B58B30P'), 8, 8.45, NULL, 'BMW ATF 8', 'HaynesPro typeId t_619116367; xDrive 40i M Sport; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 238 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30P'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 237, 'brake_fluid', NULL, 2, 2.11, NULL, 'DOT 4 LV', 'HaynesPro chassis d_319004646; Alt: BMW ATF 3+ (BMW 83 22 2 289 720)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 237 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 238, 'brake_fluid', NULL, 2, 2.11, NULL, 'DOT 4 LV', 'HaynesPro chassis d_319004646; Alt: BMW ATF 3+ (BMW 83 22 2 289 720)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 238 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 239, 'brake_fluid', NULL, 2, 2.11, NULL, 'DOT 4 LV', 'HaynesPro chassis d_319004646; Alt: BMW ATF 3+ (BMW 83 22 2 289 720)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 239 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 240, 'brake_fluid', NULL, 2, 2.11, NULL, 'DOT 4 LV', 'HaynesPro chassis d_319004646; Alt: BMW ATF 3+ (BMW 83 22 2 289 720)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 240 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (237, 238, 239, 240)
  AND e.code IN ('S63B44B', 'S68B44A', 'B57D30C', 'N63B44D', 'B57D30A', 'B57D30B', 'B48B20B', 'B58B30C', 'B58B30P')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (237, 238, 239, 240)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (237, 238, 239, 240) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;