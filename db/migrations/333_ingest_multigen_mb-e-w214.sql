-- mig 333 — multi-gen HaynesPro ingest: Mercedes-Benz E (W214)
-- crawl: haynespro-crawl-mb-e-w214-2026-05-23.json
-- modelId: d_319018555
-- 5 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Mercedes-Benz E (W214)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319018555', NOW(), 'Multi-gen ingest, 5 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319018555' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('254.915', '180 (254.915) 125kW', 1496, 'petrol', 'NA', NULL),
  ('254.920', '200 (254.920) 150kW', 1999, 'petrol', 'NA', NULL),
  ('654.820', '220 d (654.820) 145kW', 1993, 'petrol', 'NA', NULL),
  ('256.830', '450 4MATIC (256.830) 280kW', 2999, 'petrol', 'NA', NULL),
  ('656.830', '450 d (656.830) 270kW', 2989, 'petrol', 'NA', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 312, 'engine_oil', (SELECT id FROM engines WHERE code = '254.915'), 6, 6.34, '0W-20', 'MB 229.72', 'HaynesPro typeId t_619135024; 180; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 312 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '254.915'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 312, 'coolant', (SELECT id FROM engines WHERE code = '254.915'), 14, 14.79, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_619135024; 180'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 312 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '254.915'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 312, 'transmission_at', (SELECT id FROM engines WHERE code = '254.915'), NULL, NULL, NULL, 'SAE 75W-85', 'HaynesPro typeId t_619135024; 180; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 312 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '254.915'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 312, 'engine_oil', (SELECT id FROM engines WHERE code = '254.920'), 6, 6.34, '0W-20', 'MB 229.72', 'HaynesPro typeId t_619132378; 200; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 312 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '254.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 312, 'coolant', (SELECT id FROM engines WHERE code = '254.920'), 14, 14.79, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_619132378; 200'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 312 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '254.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 312, 'transmission_at', (SELECT id FROM engines WHERE code = '254.920'), 10, 10.57, NULL, 'MB 236.17', 'HaynesPro typeId t_619132378; 200; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 312 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '254.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 312, 'engine_oil', (SELECT id FROM engines WHERE code = '654.820'), 6, 6.34, '0W-20', 'MB 229.72', 'HaynesPro typeId t_619132379; 220 d; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 312 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '654.820'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 312, 'coolant', (SELECT id FROM engines WHERE code = '654.820'), 15, 15.85, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_619132379; 220 d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 312 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '654.820'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 312, 'transmission_at', (SELECT id FROM engines WHERE code = '654.820'), 10, 10.57, NULL, 'MB 236.17', 'HaynesPro typeId t_619132379; 220 d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 312 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '654.820'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 312, 'engine_oil', (SELECT id FROM engines WHERE code = '256.830'), 8, 8.45, '0W-20', 'MB 229.72', 'HaynesPro typeId t_619135959; 450 4MATIC; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 312 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '256.830'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 312, 'coolant', (SELECT id FROM engines WHERE code = '256.830'), 18, 19.02, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_619135959; 450 4MATIC'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 312 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '256.830'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 312, 'transmission_at', (SELECT id FROM engines WHERE code = '256.830'), NULL, NULL, NULL, 'MB 236.17', 'HaynesPro typeId t_619135959; 450 4MATIC; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 312 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '256.830'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 312, 'engine_oil', (SELECT id FROM engines WHERE code = '656.830'), 8.5, 8.98, '0W-30', 'MB 229.61', 'HaynesPro typeId t_619133900; 450 d; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 312 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '656.830'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 312, 'coolant', (SELECT id FROM engines WHERE code = '656.830'), 17, 17.96, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_619133900; 450 d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 312 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '656.830'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 312, 'transmission_at', (SELECT id FROM engines WHERE code = '656.830'), NULL, NULL, NULL, 'MB 236.17', 'HaynesPro typeId t_619133900; 450 d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 312 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '656.830'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 312, 'brake_fluid', NULL, 0.8, 0.85, NULL, 'MB 331.0', 'HaynesPro chassis d_319018555; Alt: DOT 4 LV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 312 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (312)
  AND e.code IN ('254.915', '254.920', '654.820', '256.830', '656.830')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (312)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (312) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;