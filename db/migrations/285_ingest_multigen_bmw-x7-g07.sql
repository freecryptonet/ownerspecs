-- mig 285 — multi-gen HaynesPro ingest: BMW X7 (G07)
-- crawl: haynespro-crawl-bmw-x7-g07-2026-05-23.json
-- modelId: d_319003513
-- 7 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — BMW X7 (G07)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319003513', NOW(), 'Multi-gen ingest, 7 engines across 2 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319003513' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('B57D30C', 'M50d (B57D30C) 294kW', 2993, 'diesel', 'turbo', NULL),
  ('N63B44D', 'M50i (N63B44D) 390kW', 4395, 'petrol', 'turbo', NULL),
  ('S68B44A', 'M60i xDrive mHev (S68B44A) 390kW', 4395, 'hybrid', 'NA', NULL),
  ('B57D30A', 'xDrive 30d (B57D30A) 195kW', 2993, 'diesel', 'turbo', NULL),
  ('B57D30B', 'xDrive 40d mHev (B57D30B) 250kW', 2993, 'hybrid', 'turbo', NULL),
  ('B58B30C', 'xDrive 40i (B58B30C) 250kW', 2998, 'petrol', 'turbo', NULL),
  ('B58B30P', 'xDrive 40i (B58B30P) 280kW', 2998, 'petrol', 'turbo', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 241, 'engine_oil', (SELECT id FROM engines WHERE code = 'B57D30C'), 6.5, 6.87, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_619015485; M50d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 241 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 241, 'coolant', (SELECT id FROM engines WHERE code = 'B57D30C'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619015485; M50d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 241 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 241, 'transmission_at', (SELECT id FROM engines WHERE code = 'B57D30C'), 9.35, 9.88, NULL, 'BMW DTF1', 'HaynesPro typeId t_619015485; M50d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 241 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 241, 'engine_oil', (SELECT id FROM engines WHERE code = 'N63B44D'), 10.5, 11.1, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_619022913; M50i; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 241 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 241, 'coolant', (SELECT id FROM engines WHERE code = 'N63B44D'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619022913; M50i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 241 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 241, 'transmission_at', (SELECT id FROM engines WHERE code = 'N63B44D'), 9.35, 9.88, NULL, 'BMW DTF1', 'HaynesPro typeId t_619022913; M50i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 241 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 242, 'engine_oil', (SELECT id FROM engines WHERE code = 'N63B44D'), 10.5, 11.1, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_619022913; M50i; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 242 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 242, 'coolant', (SELECT id FROM engines WHERE code = 'N63B44D'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619022913; M50i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 242 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 242, 'transmission_at', (SELECT id FROM engines WHERE code = 'N63B44D'), 9.35, 9.88, NULL, 'BMW DTF1', 'HaynesPro typeId t_619022913; M50i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 242 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 241, 'engine_oil', (SELECT id FROM engines WHERE code = 'S68B44A'), 10.8, 11.41, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_619109871; M60i xDrive mHev; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 241 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S68B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 241, 'coolant', (SELECT id FROM engines WHERE code = 'S68B44A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619109871; M60i xDrive mHev'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 241 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S68B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 241, 'transmission_at', (SELECT id FROM engines WHERE code = 'S68B44A'), 8, 8.45, NULL, 'BMW DTF1', 'HaynesPro typeId t_619109871; M60i xDrive mHev; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 241 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'S68B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 242, 'engine_oil', (SELECT id FROM engines WHERE code = 'S68B44A'), 10.8, 11.41, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_619109871; M60i xDrive mHev; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 242 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S68B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 242, 'coolant', (SELECT id FROM engines WHERE code = 'S68B44A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619109871; M60i xDrive mHev'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 242 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S68B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 242, 'transmission_at', (SELECT id FROM engines WHERE code = 'S68B44A'), 8, 8.45, NULL, 'BMW DTF1', 'HaynesPro typeId t_619109871; M60i xDrive mHev; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 242 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'S68B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 241, 'engine_oil', (SELECT id FROM engines WHERE code = 'B57D30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_619015487; xDrive 30d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 241 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 241, 'coolant', (SELECT id FROM engines WHERE code = 'B57D30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619015487; xDrive 30d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 241 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 241, 'transmission_at', (SELECT id FROM engines WHERE code = 'B57D30A'), 9.35, 9.88, NULL, 'BMW DTF1', 'HaynesPro typeId t_619015487; xDrive 30d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 241 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 242, 'engine_oil', (SELECT id FROM engines WHERE code = 'B57D30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_619015487; xDrive 30d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 242 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 242, 'coolant', (SELECT id FROM engines WHERE code = 'B57D30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619015487; xDrive 30d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 242 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 242, 'transmission_at', (SELECT id FROM engines WHERE code = 'B57D30A'), 9.35, 9.88, NULL, 'BMW DTF1', 'HaynesPro typeId t_619015487; xDrive 30d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 242 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 241, 'engine_oil', (SELECT id FROM engines WHERE code = 'B57D30B'), 7, 7.4, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_619035804; xDrive 40d mHev; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 241 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 241, 'coolant', (SELECT id FROM engines WHERE code = 'B57D30B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619035804; xDrive 40d mHev'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 241 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 241, 'transmission_at', (SELECT id FROM engines WHERE code = 'B57D30B'), 9.35, 9.88, NULL, 'BMW DTF1', 'HaynesPro typeId t_619035804; xDrive 40d mHev; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 241 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 242, 'engine_oil', (SELECT id FROM engines WHERE code = 'B57D30B'), 7, 7.4, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_619035804; xDrive 40d mHev; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 242 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 242, 'coolant', (SELECT id FROM engines WHERE code = 'B57D30B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619035804; xDrive 40d mHev'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 242 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 242, 'transmission_at', (SELECT id FROM engines WHERE code = 'B57D30B'), 9.35, 9.88, NULL, 'BMW DTF1', 'HaynesPro typeId t_619035804; xDrive 40d mHev; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 242 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 241, 'engine_oil', (SELECT id FROM engines WHERE code = 'B58B30C'), 6.5, 6.87, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619015486; xDrive 40i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 241 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 241, 'coolant', (SELECT id FROM engines WHERE code = 'B58B30C'), 12.6, 13.31, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619015486; xDrive 40i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 241 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 241, 'transmission_at', (SELECT id FROM engines WHERE code = 'B58B30C'), 9.28, 9.81, NULL, 'BMW DTF1', 'HaynesPro typeId t_619015486; xDrive 40i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 241 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 242, 'engine_oil', (SELECT id FROM engines WHERE code = 'B58B30C'), 6.5, 6.87, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619015486; xDrive 40i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 242 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 242, 'coolant', (SELECT id FROM engines WHERE code = 'B58B30C'), 12.6, 13.31, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619015486; xDrive 40i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 242 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 242, 'transmission_at', (SELECT id FROM engines WHERE code = 'B58B30C'), 9.28, 9.81, NULL, 'BMW DTF1', 'HaynesPro typeId t_619015486; xDrive 40i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 242 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 241, 'engine_oil', (SELECT id FROM engines WHERE code = 'B58B30P'), 6.8, 7.19, '0W-12', 'BMW Longlife-22 FE++', 'HaynesPro typeId t_619109870; xDrive 40i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 241 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30P'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 241, 'coolant', (SELECT id FROM engines WHERE code = 'B58B30P'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619109870; xDrive 40i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 241 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30P'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 241, 'transmission_at', (SELECT id FROM engines WHERE code = 'B58B30P'), 8, 8.45, NULL, 'BMW ATF 8', 'HaynesPro typeId t_619109870; xDrive 40i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 241 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30P'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 242, 'engine_oil', (SELECT id FROM engines WHERE code = 'B58B30P'), 6.8, 7.19, '0W-12', 'BMW Longlife-22 FE++', 'HaynesPro typeId t_619109870; xDrive 40i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 242 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30P'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 242, 'coolant', (SELECT id FROM engines WHERE code = 'B58B30P'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619109870; xDrive 40i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 242 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30P'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 242, 'transmission_at', (SELECT id FROM engines WHERE code = 'B58B30P'), 8, 8.45, NULL, 'BMW ATF 8', 'HaynesPro typeId t_619109870; xDrive 40i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 242 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30P'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 241, 'brake_fluid', NULL, 2, 2.11, NULL, 'DOT 4 LV', 'HaynesPro chassis d_319003513; Alt: BMW ATF 3+ (BMW 83 22 2 289 720)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 241 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 242, 'brake_fluid', NULL, 2, 2.11, NULL, 'DOT 4 LV', 'HaynesPro chassis d_319003513; Alt: BMW ATF 3+ (BMW 83 22 2 289 720)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 242 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (241, 242)
  AND e.code IN ('B57D30C', 'N63B44D', 'S68B44A', 'B57D30A', 'B57D30B', 'B58B30C', 'B58B30P')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (241, 242)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (241, 242) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;