-- mig 249 — multi-gen HaynesPro ingest: BMW X5 (F15, F85)
-- crawl: haynespro-crawl-bmw-x5-f15-2026-05-23.json
-- modelId: d_301000058
-- 9 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — BMW X5 (F15, F85)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_301000058', NOW(), 'Multi-gen ingest, 9 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_301000058' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('S63B44B', 'M (S63B44B) 423kW', 4395, 'petrol', 'turbo', NULL),
  ('N47D20D', 's, xDrive 25d (N47D20D) 160kW', 1995, 'diesel', 'NA', NULL),
  ('B47D20B', 's, xDrive 25d (B47D20B) 170kW', 1995, 'diesel', 'turbo', NULL),
  ('N20B20A', 'xDrive 28i (N20B20A) 180kW', 1997, 'petrol', 'turbo', NULL),
  ('N57D30A', 'xDrive 30d (N57D30A) 190kW', 2993, 'diesel', 'NA', NULL),
  ('N55B30A', 'xDrive 35i M Performance (N55B30A) 240kW', 2979, 'petrol', 'turbo', NULL),
  ('N57D30B', 'xDrive 40d (N57D30B) 230kW', 2993, 'diesel', 'NA', NULL),
  ('N63B44B', 'xDrive 50i (N63B44B) 330kW', 4395, 'petrol', 'turbo', NULL),
  ('N57D30C', 'xDrive M50d (N57D30C) 280kW', 2993, 'diesel', 'NA', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 168, 'engine_oil', (SELECT id FROM engines WHERE code = 'S63B44B'), 9.5, 10.04, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_313000128; M; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 168 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 168, 'coolant', (SELECT id FROM engines WHERE code = 'S63B44B'), 16.8, 17.75, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_313000128; M'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 168 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 168, 'transmission_at', (SELECT id FROM engines WHERE code = 'S63B44B'), 8.7, 9.19, NULL, 'BMW Synthetik OSP (BMW 83 22 2 365 987)', 'HaynesPro typeId t_313000128; M; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 168 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'S63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 168, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20D'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_302000355; s, xDrive 25d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 168 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 168, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20D'), 12.6, 13.31, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_302000355; s, xDrive 25d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 168 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 168, 'transmission_at', (SELECT id FROM engines WHERE code = 'N47D20D'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_302000355; s, xDrive 25d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 168 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 168, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47D20B'), 5, 5.28, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_318011912; s, xDrive 25d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 168 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 168, 'coolant', (SELECT id FROM engines WHERE code = 'B47D20B'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_318011912; s, xDrive 25d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 168 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 168, 'transmission_at', (SELECT id FROM engines WHERE code = 'B47D20B'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_318011912; s, xDrive 25d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 168 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 168, 'engine_oil', (SELECT id FROM engines WHERE code = 'N20B20A'), 4.75, 5.02, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619022748; xDrive 28i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 168 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 168, 'coolant', (SELECT id FROM engines WHERE code = 'N20B20A'), 11.8, 12.47, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619022748; xDrive 28i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 168 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 168, 'transmission_at', (SELECT id FROM engines WHERE code = 'N20B20A'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_619022748; xDrive 28i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 168 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 168, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_301001210; xDrive 30d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 168 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 168, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30A'), 12.6, 13.31, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_301001210; xDrive 30d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 168 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 168, 'transmission_at', (SELECT id FROM engines WHERE code = 'N57D30A'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_301001210; xDrive 30d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 168 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 168, 'engine_oil', (SELECT id FROM engines WHERE code = 'N55B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_619025301; xDrive 35i M Performance; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 168 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 168, 'coolant', (SELECT id FROM engines WHERE code = 'N55B30A'), 10.3, 10.88, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619025301; xDrive 35i M Performance'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 168 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 168, 'transmission_at', (SELECT id FROM engines WHERE code = 'N55B30A'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_619025301; xDrive 35i M Performance; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 168 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 168, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30B'), 6.5, 6.87, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_302000354; xDrive 40d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 168 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 168, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30B'), 12.6, 13.31, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_302000354; xDrive 40d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 168 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 168, 'transmission_at', (SELECT id FROM engines WHERE code = 'N57D30B'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_302000354; xDrive 40d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 168 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 168, 'engine_oil', (SELECT id FROM engines WHERE code = 'N63B44B'), 9.5, 10.04, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_301001212; xDrive 50i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 168 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 168, 'coolant', (SELECT id FROM engines WHERE code = 'N63B44B'), 14.9, 15.74, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_301001212; xDrive 50i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 168 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 168, 'transmission_at', (SELECT id FROM engines WHERE code = 'N63B44B'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_301001212; xDrive 50i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 168 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 168, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30C'), 6.5, 6.87, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_301001211; xDrive M50d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 168 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 168, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30C'), 15.4, 16.27, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_301001211; xDrive M50d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 168 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 168, 'transmission_at', (SELECT id FROM engines WHERE code = 'N57D30C'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_301001211; xDrive M50d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 168 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30C'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 168, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_301000058; Alt: BMW ATF 3+ (BMW 83 22 2 289 720)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 168 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (168)
  AND e.code IN ('S63B44B', 'N47D20D', 'B47D20B', 'N20B20A', 'N57D30A', 'N55B30A', 'N57D30B', 'N63B44B', 'N57D30C')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (168)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (168) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;