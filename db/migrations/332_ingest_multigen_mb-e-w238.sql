-- mig 332 — multi-gen HaynesPro ingest: Mercedes-Benz E Coupe/Cabrio (W238)
-- crawl: haynespro-crawl-mb-e-w238-2026-05-23.json
-- modelId: d_319001437
-- 8 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Mercedes-Benz E Coupe/Cabrio (W238)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319001437', NOW(), 'Multi-gen ingest, 8 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319001437' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('264.920', '200 EQ Boost, -4MATIC (264.920) 145kW', 1991, 'petrol', 'NA', NULL),
  ('274.920', '200, -4MATIC (274.920) 135kW', 1991, 'petrol', 'NA', NULL),
  ('654.920', '220 d (654.920) 120kW', 1950, 'petrol', 'NA', NULL),
  ('654.820', '300 d 4MATIC (654.820) 194kW', 1992, 'petrol', 'NA', NULL),
  ('656.929', '350 d (656.929) 210kW', 2925, 'petrol', 'NA', NULL),
  ('642.873', '350 d 4MATIC (642.873) 190kW', 2987, 'petrol', 'NA', NULL),
  ('276.823', '400 4MATIC (276.823) 245kW', 2996, 'petrol', 'NA', NULL),
  ('256.930', '450, -4MATIC (256.930) 274kW', 2999, 'petrol', 'NA', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 311, 'engine_oil', (SELECT id FROM engines WHERE code = '264.920'), NULL, NULL, '0W-20', 'MB 229.72', 'HaynesPro typeId t_619022968; 200 EQ Boost, -4MATIC; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 311 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '264.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 311, 'coolant', (SELECT id FROM engines WHERE code = '264.920'), 9, 9.51, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_619022968; 200 EQ Boost, -4MATIC'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 311 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '264.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 311, 'transmission_at', (SELECT id FROM engines WHERE code = '264.920'), NULL, NULL, NULL, 'MB 236.17', 'HaynesPro typeId t_619022968; 200 EQ Boost, -4MATIC; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 311 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '264.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 311, 'engine_oil', (SELECT id FROM engines WHERE code = '274.920'), NULL, NULL, '0W-30', 'MB 229.6', 'HaynesPro typeId t_319005593; 200, -4MATIC; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 311 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '274.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 311, 'coolant', (SELECT id FROM engines WHERE code = '274.920'), NULL, NULL, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_319005593; 200, -4MATIC'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 311 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '274.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 311, 'transmission_mt', (SELECT id FROM engines WHERE code = '274.920'), 10, 10.57, NULL, 'MB 236.24', 'HaynesPro typeId t_319005593; 200, -4MATIC; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 311 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '274.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 311, 'engine_oil', (SELECT id FROM engines WHERE code = '654.920'), NULL, NULL, '0W-20', 'MB 229.72', 'HaynesPro typeId t_319005595; 220 d; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 311 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '654.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 311, 'coolant', (SELECT id FROM engines WHERE code = '654.920'), 12.5, 13.21, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_319005595; 220 d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 311 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '654.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 311, 'transmission_mt', (SELECT id FROM engines WHERE code = '654.920'), NULL, NULL, NULL, 'MB 236.24', 'HaynesPro typeId t_319005595; 220 d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 311 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '654.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 311, 'engine_oil', (SELECT id FROM engines WHERE code = '654.820'), NULL, NULL, '0W-20', 'MB 229.72', 'HaynesPro typeId t_619036874; 300 d 4MATIC; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 311 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '654.820'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 311, 'coolant', (SELECT id FROM engines WHERE code = '654.820'), 12.5, 13.21, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_619036874; 300 d 4MATIC'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 311 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '654.820'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 311, 'transmission_at', (SELECT id FROM engines WHERE code = '654.820'), 10, 10.57, NULL, 'MB 236.17', 'HaynesPro typeId t_619036874; 300 d 4MATIC; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 311 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '654.820'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 311, 'coolant', (SELECT id FROM engines WHERE code = '656.929'), 13, 13.74, NULL, NULL, 'HaynesPro typeId t_619017803; 350 d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 311 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '656.929'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 311, 'transmission_at', (SELECT id FROM engines WHERE code = '656.929'), NULL, NULL, NULL, 'MB 236.17', 'HaynesPro typeId t_619017803; 350 d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 311 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '656.929'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 311, 'engine_oil', (SELECT id FROM engines WHERE code = '642.873'), 8, 8.45, '0W-30', 'MB 229.52', 'HaynesPro typeId t_319007892; 350 d 4MATIC; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 311 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '642.873'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 311, 'coolant', (SELECT id FROM engines WHERE code = '642.873'), NULL, NULL, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_319007892; 350 d 4MATIC'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 311 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '642.873'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 311, 'transmission_at', (SELECT id FROM engines WHERE code = '642.873'), 10, 10.57, NULL, 'MB 236.17', 'HaynesPro typeId t_319007892; 350 d 4MATIC; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 311 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '642.873'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 311, 'engine_oil', (SELECT id FROM engines WHERE code = '276.823'), 6.5, 6.87, '0W-30', 'MB 229.6', 'HaynesPro typeId t_319005596; 400 4MATIC; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 311 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '276.823'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 311, 'coolant', (SELECT id FROM engines WHERE code = '276.823'), NULL, NULL, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_319005596; 400 4MATIC'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 311 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '276.823'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 311, 'transmission_at', (SELECT id FROM engines WHERE code = '276.823'), 10, 10.57, NULL, 'MB 236.15', 'HaynesPro typeId t_319005596; 400 4MATIC; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 311 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '276.823'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 311, 'engine_oil', (SELECT id FROM engines WHERE code = '256.930'), NULL, NULL, '0W-20', 'MB 229.72', 'HaynesPro typeId t_619035273; 450, -4MATIC; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 311 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '256.930'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 311, 'coolant', (SELECT id FROM engines WHERE code = '256.930'), NULL, NULL, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_619035273; 450, -4MATIC'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 311 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '256.930'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 311, 'transmission_at', (SELECT id FROM engines WHERE code = '256.930'), 10, 10.57, NULL, 'MB 236.17', 'HaynesPro typeId t_619035273; 450, -4MATIC; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 311 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '256.930'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 311, 'brake_fluid', NULL, 0.5, 0.53, NULL, 'MB 331.0', 'HaynesPro chassis d_319001437; Alt: DOT 4 LV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 311 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (311)
  AND e.code IN ('264.920', '274.920', '654.920', '654.820', '656.929', '642.873', '276.823', '256.930')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (311)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (311) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;