-- mig 327 — multi-gen HaynesPro ingest: Mercedes-Benz C (W206)
-- crawl: haynespro-crawl-mb-c-w206-2026-05-23.json
-- modelId: d_319008822
-- 5 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Mercedes-Benz C (W206)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319008822', NOW(), 'Multi-gen ingest, 5 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319008822' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('254.915', '180 EQ Boost (254.915) 125kW', 1496, 'petrol', 'NA', NULL),
  ('654.820', '200 d EQ Boost (654.820) 120kW', 1993, 'petrol', 'NA', NULL),
  ('254.920', '300 EQ Boost, -4MATIC (254.920) 190kW', 1999, 'petrol', 'NA', NULL),
  ('254.820', '400 e 4MATIC (254.820) 280kW', 1999, 'petrol', 'NA', NULL),
  ('139.580', '43 AMG 4MATIC+ (139.580) 310kW', 1991, 'petrol', 'NA', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 305, 'engine_oil', (SELECT id FROM engines WHERE code = '254.915'), 6, 6.34, '0W-20', 'MB 229.72', 'HaynesPro typeId t_619035594; 180 EQ Boost; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 305 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '254.915'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 305, 'coolant', (SELECT id FROM engines WHERE code = '254.915'), NULL, NULL, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_619035594; 180 EQ Boost'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 305 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '254.915'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 305, 'transmission_at', (SELECT id FROM engines WHERE code = '254.915'), NULL, NULL, NULL, 'SAE 75W-85', 'HaynesPro typeId t_619035594; 180 EQ Boost; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 305 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '254.915'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 305, 'engine_oil', (SELECT id FROM engines WHERE code = '654.820'), 6, 6.34, '0W-20', 'MB 229.72', 'HaynesPro typeId t_619041486; 200 d EQ Boost; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 305 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '654.820'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 305, 'coolant', (SELECT id FROM engines WHERE code = '654.820'), NULL, NULL, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_619041486; 200 d EQ Boost'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 305 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '654.820'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 305, 'transmission_at', (SELECT id FROM engines WHERE code = '654.820'), NULL, NULL, NULL, 'MB 236.17', 'HaynesPro typeId t_619041486; 200 d EQ Boost; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 305 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '654.820'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 305, 'engine_oil', (SELECT id FROM engines WHERE code = '254.920'), 6, 6.34, '0W-20', 'MB 229.72', 'HaynesPro typeId t_619035596; 300 EQ Boost, -4MATIC; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 305 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '254.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 305, 'coolant', (SELECT id FROM engines WHERE code = '254.920'), NULL, NULL, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_619035596; 300 EQ Boost, -4MATIC'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 305 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '254.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 305, 'transmission_at', (SELECT id FROM engines WHERE code = '254.920'), 10, 10.57, NULL, 'MB 236.17', 'HaynesPro typeId t_619035596; 300 EQ Boost, -4MATIC; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 305 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '254.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 305, 'engine_oil', (SELECT id FROM engines WHERE code = '254.820'), 6, 6.34, '0W-40', 'MB 229.52', 'HaynesPro typeId t_619112433; 400 e 4MATIC; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 305 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '254.820'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 305, 'coolant', (SELECT id FROM engines WHERE code = '254.820'), NULL, NULL, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_619112433; 400 e 4MATIC'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 305 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '254.820'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 305, 'transmission_at', (SELECT id FROM engines WHERE code = '254.820'), 10, 10.57, NULL, 'MB 236.15', 'HaynesPro typeId t_619112433; 400 e 4MATIC; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 305 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '254.820'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 305, 'engine_oil', (SELECT id FROM engines WHERE code = '139.580'), 6, 6.34, '0W-20', 'MB 229.71', 'HaynesPro typeId t_619108760; 43 AMG 4MATIC+; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 305 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '139.580'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 305, 'coolant', (SELECT id FROM engines WHERE code = '139.580'), NULL, NULL, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_619108760; 43 AMG 4MATIC+'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 305 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '139.580'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 305, 'transmission_at', (SELECT id FROM engines WHERE code = '139.580'), 10, 10.57, NULL, 'MB 236.17', 'HaynesPro typeId t_619108760; 43 AMG 4MATIC+; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 305 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '139.580'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 305, 'brake_fluid', NULL, 0.8, 0.85, NULL, 'MB 331.0', 'HaynesPro chassis d_319008822; Alt: DOT 4 LV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 305 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (305)
  AND e.code IN ('254.915', '654.820', '254.920', '254.820', '139.580')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (305)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (305) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;