-- mig 340 — multi-gen HaynesPro ingest: Mercedes-Benz B (W247)
-- crawl: haynespro-crawl-mb-b-w247-2026-05-23.json
-- modelId: d_319002954
-- 5 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Mercedes-Benz B (W247)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319002954', NOW(), 'Multi-gen ingest, 5 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319002954' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('282.914', '160 (282.914) 80kW', 1332, 'petrol', 'NA', NULL),
  ('608.915 (K9K)', '160 d (608.915 (K9K)) 70kW', 1461, 'petrol', 'NA', NULL),
  ('282.814', '180 (282.814) 100kW', 1332, 'petrol', 'NA', NULL),
  ('654.920', '180 d (654.920) 85kW', 1950, 'petrol', 'NA', NULL),
  ('260.920', '220 4MATIC (260.920) 140kW', 1991, 'petrol', 'NA', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 318, 'coolant', (SELECT id FROM engines WHERE code = '282.914'), 6.8, 7.19, NULL, NULL, 'HaynesPro typeId t_619020913; 160'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 318 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '282.914'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 318, 'transmission_mt', (SELECT id FROM engines WHERE code = '282.914'), 1.8, 1.9, NULL, 'SAE 75W-85', 'HaynesPro typeId t_619020913; 160; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 318 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '282.914'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 318, 'coolant', (SELECT id FROM engines WHERE code = '608.915 (K9K)'), 12.1, 12.79, NULL, NULL, 'HaynesPro typeId t_619020914; 160 d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 318 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '608.915 (K9K)'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 318, 'transmission_mt', (SELECT id FROM engines WHERE code = '608.915 (K9K)'), 1.8, 1.9, NULL, 'SAE 75W-80', 'HaynesPro typeId t_619020914; 160 d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 318 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '608.915 (K9K)'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 318, 'engine_oil', (SELECT id FROM engines WHERE code = '282.814'), 5.1, 5.39, '0W-20', 'MB 229.81', 'HaynesPro typeId t_619112846; 180; drain 60 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 318 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '282.814'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 318, 'coolant', (SELECT id FROM engines WHERE code = '282.814'), 6.8, 7.19, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_619112846; 180'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 318 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '282.814'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 318, 'transmission_dct', (SELECT id FROM engines WHERE code = '282.814'), 4.5, 4.76, NULL, 'MB 239.22', 'HaynesPro typeId t_619112846; 180; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 318 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = '282.814'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 318, 'engine_oil', (SELECT id FROM engines WHERE code = '654.920'), 6.5, 6.87, '0W-20', 'MB 229.72', 'HaynesPro typeId t_619035953; 180 d; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 318 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '654.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 318, 'coolant', (SELECT id FROM engines WHERE code = '654.920'), 13.3, 14.05, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_619035953; 180 d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 318 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '654.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 318, 'transmission_mt', (SELECT id FROM engines WHERE code = '654.920'), 1.8, 1.9, NULL, 'SAE 75W-80', 'HaynesPro typeId t_619035953; 180 d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 318 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '654.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 318, 'engine_oil', (SELECT id FROM engines WHERE code = '260.920'), 5, 5.28, '0W-20', 'MB 229.72', 'HaynesPro typeId t_619017791; 220 4MATIC; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 318 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '260.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 318, 'coolant', (SELECT id FROM engines WHERE code = '260.920'), NULL, NULL, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_619017791; 220 4MATIC'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 318 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '260.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 318, 'transmission_dct', (SELECT id FROM engines WHERE code = '260.920'), 5, 5.28, NULL, 'MB 236.21', 'HaynesPro typeId t_619017791; 220 4MATIC; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 318 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = '260.920'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 318, 'brake_fluid', NULL, 0.5, 0.53, NULL, 'MB 331.0', 'HaynesPro chassis d_319002954; Alt: DOT 4 LV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 318 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (318)
  AND e.code IN ('282.914', '608.915 (K9K)', '282.814', '654.920', '260.920')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (318)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (318) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;