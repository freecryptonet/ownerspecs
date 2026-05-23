-- mig 270 — multi-gen HaynesPro ingest: BMW X1 (E84)
-- crawl: haynespro-crawl-bmw-x1-e84-2026-05-23.json
-- modelId: d_102000120
-- 6 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — BMW X1 (E84)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_102000120', NOW(), 'Multi-gen ingest, 6 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_102000120' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('N47D20C', 's, xDrive 18d (N47D20C) 105kW', 1995, 'diesel', 'NA', NULL),
  ('N20B20A', 's, xDrive 20i (N20B20A) 135kW', 1997, 'petrol', 'turbo', NULL),
  ('N47D20D', 's, xDrive 25d (N47D20D) 160kW', 1995, 'diesel', 'NA', NULL),
  ('N20B16A', 'sDrive 16i (N20B16A) 105kW', 1592, 'petrol', 'turbo', NULL),
  ('N46B20B', 'sDrive 18i (N46B20B) 110kW', 1995, 'petrol', 'NA', NULL),
  ('N52B30A', 'xDrive 25i (N52B30A) 160kW', 2996, 'petrol', 'NA', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 207, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20C'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102001273; s, xDrive 18d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 207 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 207, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20C'), 8.5, 8.98, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001273; s, xDrive 18d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 207 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 207, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20C'), 1.3, 1.37, NULL, 'MTF LT3', 'HaynesPro typeId t_102001273; s, xDrive 18d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 207 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 207, 'engine_oil', (SELECT id FROM engines WHERE code = 'N20B20A'), NULL, NULL, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_102002550; s, xDrive 20i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 207 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 207, 'coolant', (SELECT id FROM engines WHERE code = 'N20B20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102002550; s, xDrive 20i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 207 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 207, 'transmission_at', (SELECT id FROM engines WHERE code = 'N20B20A'), 1.2, 1.27, NULL, 'SAE 75W-80', 'HaynesPro typeId t_102002550; s, xDrive 20i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 207 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 207, 'engine_oil', (SELECT id FROM engines WHERE code = 'N47D20D'), 5.2, 5.49, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_201000012; s, xDrive 25d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 207 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 207, 'coolant', (SELECT id FROM engines WHERE code = 'N47D20D'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_201000012; s, xDrive 25d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 207 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 207, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N47D20D'), 1.2, 1.27, NULL, 'BMW ATF 2', 'HaynesPro typeId t_201000012; s, xDrive 25d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 207 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N47D20D'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 207, 'engine_oil', (SELECT id FROM engines WHERE code = 'N20B16A'), 5, 5.28, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_305000583; sDrive 16i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 207 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 207, 'coolant', (SELECT id FROM engines WHERE code = 'N20B16A'), 8.5, 8.98, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_305000583; sDrive 16i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 207 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 207, 'transmission_at', (SELECT id FROM engines WHERE code = 'N20B16A'), 1.3, 1.37, NULL, 'MTF LT3', 'HaynesPro typeId t_305000583; sDrive 16i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 207 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N20B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 207, 'engine_oil', (SELECT id FROM engines WHERE code = 'N46B20B'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_102001371; sDrive 18i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 207 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 207, 'coolant', (SELECT id FROM engines WHERE code = 'N46B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001371; sDrive 18i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 207 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 207, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N46B20B'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_102001371; sDrive 18i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 207 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 207, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_102001370; xDrive 25i; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 207 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 207, 'coolant', (SELECT id FROM engines WHERE code = 'N52B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001370; xDrive 25i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 207 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 207, 'transmission_at', (SELECT id FROM engines WHERE code = 'N52B30A'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_102001370; xDrive 25i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 207 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 207, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_102000120;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 207 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (207)
  AND e.code IN ('N47D20C', 'N20B20A', 'N47D20D', 'N20B16A', 'N46B20B', 'N52B30A')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (207)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (207) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;