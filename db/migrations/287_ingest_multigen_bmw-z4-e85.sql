-- mig 287 — multi-gen HaynesPro ingest: BMW Z4 (E85, E86)
-- crawl: haynespro-crawl-bmw-z4-e85-2026-05-23.json
-- modelId: d_890
-- 7 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — BMW Z4 (E85, E86)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_890', NOW(), 'Multi-gen ingest, 7 engines across 2 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_890' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('N46B20B', '2.0i (N46B20B) 110kW', 1995, 'petrol', 'NA', NULL),
  ('M54B22', '2.2i (M54B22) 125kW', 2171, 'petrol', 'NA', NULL),
  ('M54B25', '2.5i (M54B25) 141kW', 2494, 'petrol', 'NA', NULL),
  ('N52B25A', '2.5i (N52B25A) 130kW', 2497, 'petrol', 'NA', NULL),
  ('M54B30', '3.0i (M54B30) 170kW', 2979, 'petrol', 'NA', NULL),
  ('N52B30A', '3.0si, -LPG (N52B30A) 195kW', 2996, 'petrol', 'NA', NULL),
  ('S54B32', 'M (S54B32) 252kW', 3246, 'petrol', 'NA', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 243, 'engine_oil', (SELECT id FROM engines WHERE code = 'N46B20B'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_78370; 2.0i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 243 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 243, 'coolant', (SELECT id FROM engines WHERE code = 'N46B20B'), 9, 9.51, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78370; 2.0i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 243 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 243, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N46B20B'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_78370; 2.0i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 243 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 244, 'engine_oil', (SELECT id FROM engines WHERE code = 'N46B20B'), 4.25, 4.49, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_78370; 2.0i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 244 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 244, 'coolant', (SELECT id FROM engines WHERE code = 'N46B20B'), 9, 9.51, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_78370; 2.0i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 244 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 244, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N46B20B'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_78370; 2.0i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 244 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 243, 'engine_oil', (SELECT id FROM engines WHERE code = 'M54B22'), 6.5, 6.87, '5W-30', 'BMW Longlife-01', 'HaynesPro typeId t_59080; 2.2i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 243 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B22'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 243, 'coolant', (SELECT id FROM engines WHERE code = 'M54B22'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_59080; 2.2i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 243 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B22'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 243, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M54B22'), 1.1, 1.16, NULL, 'ESSO LT 71141', 'HaynesPro typeId t_59080; 2.2i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 243 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B22'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 244, 'engine_oil', (SELECT id FROM engines WHERE code = 'M54B22'), 6.5, 6.87, '5W-30', 'BMW Longlife-01', 'HaynesPro typeId t_59080; 2.2i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 244 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B22'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 244, 'coolant', (SELECT id FROM engines WHERE code = 'M54B22'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_59080; 2.2i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 244 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B22'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 244, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M54B22'), 1.1, 1.16, NULL, 'ESSO LT 71141', 'HaynesPro typeId t_59080; 2.2i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 244 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B22'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 243, 'engine_oil', (SELECT id FROM engines WHERE code = 'M54B25'), 6.5, 6.87, '5W-30', 'BMW Longlife-01', 'HaynesPro typeId t_59090; 2.5i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 243 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B25'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 243, 'coolant', (SELECT id FROM engines WHERE code = 'M54B25'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_59090; 2.5i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 243 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B25'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 243, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M54B25'), 1.1, 1.16, NULL, 'ESSO LT 71141', 'HaynesPro typeId t_59090; 2.5i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 243 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B25'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 244, 'engine_oil', (SELECT id FROM engines WHERE code = 'M54B25'), 6.5, 6.87, '5W-30', 'BMW Longlife-01', 'HaynesPro typeId t_59090; 2.5i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 244 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B25'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 244, 'coolant', (SELECT id FROM engines WHERE code = 'M54B25'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_59090; 2.5i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 244 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B25'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 244, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M54B25'), 1.1, 1.16, NULL, 'ESSO LT 71141', 'HaynesPro typeId t_59090; 2.5i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 244 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B25'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 243, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B25A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_79170; 2.5i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 243 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 243, 'coolant', (SELECT id FROM engines WHERE code = 'N52B25A'), 8.5, 8.98, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_79170; 2.5i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 243 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 243, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N52B25A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_79170; 2.5i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 243 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 244, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B25A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_79170; 2.5i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 244 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 244, 'coolant', (SELECT id FROM engines WHERE code = 'N52B25A'), 8.5, 8.98, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_79170; 2.5i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 244 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 244, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N52B25A'), 1.3, 1.37, NULL, 'BMW ATF 2', 'HaynesPro typeId t_79170; 2.5i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 244 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B25A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 243, 'engine_oil', (SELECT id FROM engines WHERE code = 'M54B30'), 6.5, 6.87, '5W-30', 'BMW Longlife-01', 'HaynesPro typeId t_59100; 3.0i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 243 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B30'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 243, 'coolant', (SELECT id FROM engines WHERE code = 'M54B30'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_59100; 3.0i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 243 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B30'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 243, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M54B30'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_59100; 3.0i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 243 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B30'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 244, 'engine_oil', (SELECT id FROM engines WHERE code = 'M54B30'), 6.5, 6.87, '5W-30', 'BMW Longlife-01', 'HaynesPro typeId t_59100; 3.0i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 244 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B30'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 244, 'coolant', (SELECT id FROM engines WHERE code = 'M54B30'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_59100; 3.0i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 244 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B30'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 244, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M54B30'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_59100; 3.0i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 244 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B30'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 243, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_79190; 3.0si, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 243 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 243, 'coolant', (SELECT id FROM engines WHERE code = 'N52B30A'), 8.5, 8.98, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_79190; 3.0si, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 243 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 243, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N52B30A'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_79190; 3.0si, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 243 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 244, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_79190; 3.0si, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 244 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 244, 'coolant', (SELECT id FROM engines WHERE code = 'N52B30A'), 8.5, 8.98, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_79190; 3.0si, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 244 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 244, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N52B30A'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_79190; 3.0si, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 244 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 243, 'engine_oil', (SELECT id FROM engines WHERE code = 'S54B32'), 5.5, 5.81, '10W-60', NULL, 'HaynesPro typeId t_79200; M; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 243 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S54B32'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 243, 'coolant', (SELECT id FROM engines WHERE code = 'S54B32'), 10.7, 11.31, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_79200; M'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 243 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S54B32'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 243, 'transmission_mt', (SELECT id FROM engines WHERE code = 'S54B32'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_79200; M; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 243 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'S54B32'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 244, 'engine_oil', (SELECT id FROM engines WHERE code = 'S54B32'), 5.5, 5.81, '10W-60', NULL, 'HaynesPro typeId t_79200; M; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 244 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S54B32'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 244, 'coolant', (SELECT id FROM engines WHERE code = 'S54B32'), 10.7, 11.31, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_79200; M'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 244 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S54B32'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 244, 'transmission_mt', (SELECT id FROM engines WHERE code = 'S54B32'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_79200; M; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 244 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'S54B32'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 243, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_890;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 243 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 244, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_890;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 244 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (243, 244)
  AND e.code IN ('N46B20B', 'M54B22', 'M54B25', 'N52B25A', 'M54B30', 'N52B30A', 'S54B32')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (243, 244)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (243, 244) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;