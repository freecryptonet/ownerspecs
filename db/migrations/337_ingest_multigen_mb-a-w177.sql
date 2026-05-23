-- mig 337 — multi-gen HaynesPro ingest: Mercedes-Benz A (W177)
-- crawl: haynespro-crawl-mb-a-w177-2026-05-23.json
-- modelId: d_319001679
-- 7 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Mercedes-Benz A (W177)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319001679', NOW(), 'Multi-gen ingest, 7 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319001679' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('282.914', '160 (282.914) 80kW', 1332, 'petrol', 'NA', NULL),
  ('608.915', '160d (608.915) 70kW', 1461, 'petrol', 'NA', NULL),
  ('282.814', '180 (282.814) 100kW', 1332, 'petrol', 'NA', NULL),
  ('608.915 (K9K)', '180d (608.915 (K9K)) 85kW', 1461, 'petrol', 'NA', NULL),
  ('654.920', '180d (654.920) 85kW', 1950, 'petrol', 'NA', NULL),
  ('260.920', '220 4MATIC (260.920) 140kW', 1991, 'petrol', 'NA', NULL),
  ('139.980', '45 AMG 4-MATIC+ (139.980) 285kW', 1991, 'petrol', 'NA', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 315, 'engine_oil', (SELECT id FROM engines WHERE code = '282.914'), 5.1, 5.39, '0W-20', 'MB 229.72', 'HaynesPro typeId t_619013358; 160; drain 50 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 315 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '282.914'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 315, 'coolant', (SELECT id FROM engines WHERE code = '282.914'), 6.8, 7.19, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_619013358; 160'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 315 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '282.914'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 315, 'transmission_dct', (SELECT id FROM engines WHERE code = '282.914'), 4.5, 4.76, NULL, 'MB 239.22', 'HaynesPro typeId t_619013358; 160; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 315 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = '282.914'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 315, 'coolant', (SELECT id FROM engines WHERE code = '608.915'), 12.1, 12.79, NULL, NULL, 'HaynesPro typeId t_619024271; 160d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 315 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '608.915'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 315, 'transmission_mt', (SELECT id FROM engines WHERE code = '608.915'), 1.8, 1.9, NULL, 'SAE 75W-80', 'HaynesPro typeId t_619024271; 160d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 315 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '608.915'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 315, 'engine_oil', (SELECT id FROM engines WHERE code = '282.814'), 5.1, 5.39, '0W-20', 'MB 229.81', 'HaynesPro typeId t_619112842; 180; drain 60 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 315 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '282.814'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 315, 'coolant', (SELECT id FROM engines WHERE code = '282.814'), 6.8, 7.19, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_619112842; 180'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 315 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '282.814'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 315, 'transmission_mt', (SELECT id FROM engines WHERE code = '282.814'), 1.8, 1.9, NULL, 'SAE 75W', 'HaynesPro typeId t_619112842; 180; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 315 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '282.814'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 315, 'engine_oil', (SELECT id FROM engines WHERE code = '608.915 (K9K)'), 5.5, 5.81, '0W-20', 'MB 229.71', 'HaynesPro typeId t_619008054; 180d; drain 20 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 315 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '608.915 (K9K)'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 315, 'coolant', (SELECT id FROM engines WHERE code = '608.915 (K9K)'), 12.1, 12.79, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_619008054; 180d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 315 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '608.915 (K9K)'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 315, 'transmission_dct', (SELECT id FROM engines WHERE code = '608.915 (K9K)'), 4, 4.23, NULL, 'MB 239.21', 'HaynesPro typeId t_619008054; 180d; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 315 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = '608.915 (K9K)'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 315, 'engine_oil', (SELECT id FROM engines WHERE code = '654.920'), 6.8, 7.19, '0W-20', 'MB 229.72', 'HaynesPro typeId t_619035692; 180d; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 315 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '654.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 315, 'coolant', (SELECT id FROM engines WHERE code = '654.920'), 10, 10.57, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_619035692; 180d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 315 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '654.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 315, 'transmission_dct', (SELECT id FROM engines WHERE code = '654.920'), 5.5, 5.81, NULL, 'MB 236.22', 'HaynesPro typeId t_619035692; 180d; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 315 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = '654.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 315, 'engine_oil', (SELECT id FROM engines WHERE code = '260.920'), 5, 5.28, '0W-20', 'MB 229.72', 'HaynesPro typeId t_619013360; 220 4MATIC; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 315 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '260.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 315, 'coolant', (SELECT id FROM engines WHERE code = '260.920'), NULL, NULL, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_619013360; 220 4MATIC'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 315 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '260.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 315, 'transmission_dct', (SELECT id FROM engines WHERE code = '260.920'), 5, 5.28, NULL, 'MB 236.21', 'HaynesPro typeId t_619013360; 220 4MATIC; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 315 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = '260.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 315, 'engine_oil', (SELECT id FROM engines WHERE code = '139.980'), 5.8, 6.13, '0W-20', 'MB 229.71', 'HaynesPro typeId t_619024272; 45 AMG 4-MATIC+; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 315 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '139.980'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 315, 'transmission_dct', (SELECT id FROM engines WHERE code = '139.980'), 5.5, 5.81, NULL, 'MB 236.22', 'HaynesPro typeId t_619024272; 45 AMG 4-MATIC+; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 315 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = '139.980'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 315, 'brake_fluid', NULL, 0.5, 0.53, NULL, 'MB 331.0', 'HaynesPro chassis d_319001679; Alt: DOT 4 LV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 315 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (315)
  AND e.code IN ('282.914', '608.915', '282.814', '608.915 (K9K)', '654.920', '260.920', '139.980')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (315)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (315) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;