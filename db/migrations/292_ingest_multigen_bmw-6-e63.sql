-- mig 292 — multi-gen HaynesPro ingest: BMW 6 (E63, E64)
-- crawl: haynespro-crawl-bmw-6-e63-2026-05-23.json
-- modelId: d_860
-- 7 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — BMW 6 (E63, E64)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_860', NOW(), 'Multi-gen ingest, 7 engines across 4 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_860' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('N52B30B', '630i (N52B30B) 190kW', 2996, 'petrol', 'NA', NULL),
  ('N53B30A', '630i (N53B30A) 200kW', 2996, 'petrol', 'NA', NULL),
  ('N52B30A', '630i, -LPG (N52B30A) 190kW', 2996, 'petrol', 'NA', NULL),
  ('M57D30', '635d (M57D30) 210kW', 2993, 'petrol', 'NA', NULL),
  ('N62B44A', '645i (N62B44A) 245kW', 4398, 'petrol', 'NA', NULL),
  ('N62B48B', '650i, -LPG (N62B48B) 270kW', 4799, 'petrol', 'NA', NULL),
  ('S85B50A', 'M6 (S85B50A) 373kW', 4999, 'petrol', 'NA', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 253, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B30B'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_319007396; 630i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 253 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 253, 'coolant', (SELECT id FROM engines WHERE code = 'N52B30B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319007396; 630i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 253 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 253, 'transmission_at', (SELECT id FROM engines WHERE code = 'N52B30B'), 1.6, 1.69, NULL, 'SAE 75W-80', 'HaynesPro typeId t_319007396; 630i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 253 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 254, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B30B'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_319007396; 630i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 254 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 254, 'coolant', (SELECT id FROM engines WHERE code = 'N52B30B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319007396; 630i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 254 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 254, 'transmission_at', (SELECT id FROM engines WHERE code = 'N52B30B'), 1.6, 1.69, NULL, 'SAE 75W-80', 'HaynesPro typeId t_319007396; 630i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 254 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 253, 'engine_oil', (SELECT id FROM engines WHERE code = 'N53B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_102000390; 630i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 253 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 253, 'coolant', (SELECT id FROM engines WHERE code = 'N53B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102000390; 630i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 253 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 253, 'transmission_at', (SELECT id FROM engines WHERE code = 'N53B30A'), 1.6, 1.69, NULL, 'SAE 75W-80', 'HaynesPro typeId t_102000390; 630i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 253 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 254, 'engine_oil', (SELECT id FROM engines WHERE code = 'N53B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_102000390; 630i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 254 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 254, 'coolant', (SELECT id FROM engines WHERE code = 'N53B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102000390; 630i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 254 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 254, 'transmission_at', (SELECT id FROM engines WHERE code = 'N53B30A'), 1.6, 1.69, NULL, 'SAE 75W-80', 'HaynesPro typeId t_102000390; 630i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 254 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N53B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 253, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_58990; 630i, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 253 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 253, 'coolant', (SELECT id FROM engines WHERE code = 'N52B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58990; 630i, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 253 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 253, 'transmission_at', (SELECT id FROM engines WHERE code = 'N52B30A'), 1.6, 1.69, NULL, 'SAE 75W-80', 'HaynesPro typeId t_58990; 630i, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 253 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 254, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_58990; 630i, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 254 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 254, 'coolant', (SELECT id FROM engines WHERE code = 'N52B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58990; 630i, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 254 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 254, 'transmission_at', (SELECT id FROM engines WHERE code = 'N52B30A'), 1.6, 1.69, NULL, 'SAE 75W-80', 'HaynesPro typeId t_58990; 630i, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 254 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 253, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30'), 7.7, 8.14, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_110000418; 635d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 253 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 253, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_110000418; 635d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 253 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 253, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M57D30'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_110000418; 635d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 253 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 254, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30'), 7.7, 8.14, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_110000418; 635d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 254 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 254, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_110000418; 635d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 254 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 254, 'transmission_mt', (SELECT id FROM engines WHERE code = 'M57D30'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_110000418; 635d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 254 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 253, 'engine_oil', (SELECT id FROM engines WHERE code = 'N62B44A'), 8, 8.45, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_58980; 645i; drain 35 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 253 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 253, 'coolant', (SELECT id FROM engines WHERE code = 'N62B44A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58980; 645i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 253 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 253, 'transmission_at', (SELECT id FROM engines WHERE code = 'N62B44A'), 1.6, 1.69, NULL, 'SAE 75W-80', 'HaynesPro typeId t_58980; 645i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 253 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 254, 'engine_oil', (SELECT id FROM engines WHERE code = 'N62B44A'), 8, 8.45, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_58980; 645i; drain 35 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 254 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 254, 'coolant', (SELECT id FROM engines WHERE code = 'N62B44A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_58980; 645i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 254 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 254, 'transmission_at', (SELECT id FROM engines WHERE code = 'N62B44A'), 1.6, 1.69, NULL, 'SAE 75W-80', 'HaynesPro typeId t_58980; 645i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 254 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 253, 'engine_oil', (SELECT id FROM engines WHERE code = 'N62B48B'), 8, 8.45, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_110000417; 650i, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 253 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B48B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 253, 'coolant', (SELECT id FROM engines WHERE code = 'N62B48B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_110000417; 650i, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 253 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B48B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 253, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N62B48B'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_110000417; 650i, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 253 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B48B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 254, 'engine_oil', (SELECT id FROM engines WHERE code = 'N62B48B'), 8, 8.45, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_110000417; 650i, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 254 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B48B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 254, 'coolant', (SELECT id FROM engines WHERE code = 'N62B48B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_110000417; 650i, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 254 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B48B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 254, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N62B48B'), 1.6, 1.69, NULL, 'MTF LT3', 'HaynesPro typeId t_110000417; 650i, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 254 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B48B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 255, 'engine_oil', (SELECT id FROM engines WHERE code = 'S85B50A'), 9.3, 9.83, '10W-60', NULL, 'HaynesPro typeId t_110000068; M6; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 255 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S85B50A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 255, 'coolant', (SELECT id FROM engines WHERE code = 'S85B50A'), 15, 15.85, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_110000068; M6'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 255 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S85B50A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 256, 'engine_oil', (SELECT id FROM engines WHERE code = 'S85B50A'), 9.3, 9.83, '10W-60', NULL, 'HaynesPro typeId t_110000068; M6; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 256 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S85B50A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 256, 'coolant', (SELECT id FROM engines WHERE code = 'S85B50A'), 15, 15.85, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_110000068; M6'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 256 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S85B50A'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 253, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4', 'HaynesPro chassis d_860;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 253 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 254, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4', 'HaynesPro chassis d_860;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 254 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 255, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4', 'HaynesPro chassis d_860;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 255 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 256, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4', 'HaynesPro chassis d_860;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 256 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (253, 254, 255, 256)
  AND e.code IN ('N52B30B', 'N53B30A', 'N52B30A', 'M57D30', 'N62B44A', 'N62B48B', 'S85B50A')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (253, 254, 255, 256)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (253, 254, 255, 256) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;