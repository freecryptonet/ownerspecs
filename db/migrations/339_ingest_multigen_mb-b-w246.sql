-- mig 339 — multi-gen HaynesPro ingest: Mercedes-Benz B (W242, W246)
-- crawl: haynespro-crawl-mb-b-w246-2026-05-23.json
-- modelId: d_102000248
-- 6 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Mercedes-Benz B (W242, W246)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_102000248', NOW(), 'Multi-gen ingest, 6 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_102000248' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('270.910', '160 (270.910) 75kW', 1595, 'petrol', 'NA', NULL),
  ('607.951 (K9K)', '160 CDI (607.951 (K9K)) 66kW', 1461, 'petrol', 'NA', NULL),
  ('651.901', '180 CDI (651.901) 80kW', 1796, 'petrol', 'NA', NULL),
  ('651.930', '200 CDI, -4MATIC (651.930) 100kW', 2143, 'petrol', 'NA', NULL),
  ('270.920', '200 NGT (270.920) 115kW', 1991, 'petrol', 'NA', NULL),
  ('780.990', '250 e (780.990) 65kW', 0, 'petrol', 'NA', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 317, 'engine_oil', (SELECT id FROM engines WHERE code = '270.910'), 5.8, 6.13, '0W-30', 'MB 229.6', 'HaynesPro typeId t_318011939; 160; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 317 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '270.910'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 317, 'coolant', (SELECT id FROM engines WHERE code = '270.910'), NULL, NULL, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_318011939; 160'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 317 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '270.910'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 317, 'transmission_mt', (SELECT id FROM engines WHERE code = '270.910'), 2.2, 2.32, NULL, 'SAE 75W-75', 'HaynesPro typeId t_318011939; 160; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 317 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '270.910'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 317, 'engine_oil', (SELECT id FROM engines WHERE code = '607.951 (K9K)'), 4.5, 4.76, '0W-30', 'MB 229.52', 'HaynesPro typeId t_305000644; 160 CDI; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 317 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '607.951 (K9K)'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 317, 'coolant', (SELECT id FROM engines WHERE code = '607.951 (K9K)'), NULL, NULL, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_305000644; 160 CDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 317 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '607.951 (K9K)'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 317, 'transmission_mt', (SELECT id FROM engines WHERE code = '607.951 (K9K)'), 2.2, 2.32, NULL, 'SAE 75W-75', 'HaynesPro typeId t_305000644; 160 CDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 317 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '607.951 (K9K)'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 317, 'engine_oil', (SELECT id FROM engines WHERE code = '651.901'), NULL, NULL, '0W-30', 'MB 229.52', 'HaynesPro typeId t_200000010; 180 CDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 317 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '651.901'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 317, 'coolant', (SELECT id FROM engines WHERE code = '651.901'), 9.5, 10.04, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_200000010; 180 CDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 317 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '651.901'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 317, 'transmission_mt', (SELECT id FROM engines WHERE code = '651.901'), 2.2, 2.32, NULL, 'SAE 75W-75', 'HaynesPro typeId t_200000010; 180 CDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 317 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '651.901'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 317, 'engine_oil', (SELECT id FROM engines WHERE code = '651.930'), 7, 7.4, '0W-30', 'MB 229.52', 'HaynesPro typeId t_311000114; 200 CDI, -4MATIC; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 317 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '651.930'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 317, 'coolant', (SELECT id FROM engines WHERE code = '651.930'), 9.5, 10.04, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_311000114; 200 CDI, -4MATIC'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 317 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '651.930'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 317, 'transmission_dct', (SELECT id FROM engines WHERE code = '651.930'), 5.3, 5.6, NULL, 'MB 236.21', 'HaynesPro typeId t_311000114; 200 CDI, -4MATIC; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 317 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = '651.930'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 317, 'engine_oil', (SELECT id FROM engines WHERE code = '270.920'), 5.6, 5.92, '0W-30', 'MB 229.6', 'HaynesPro typeId t_302000366; 200 NGT; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 317 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '270.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 317, 'coolant', (SELECT id FROM engines WHERE code = '270.920'), 7, 7.4, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_302000366; 200 NGT'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 317 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '270.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 317, 'transmission_mt', (SELECT id FROM engines WHERE code = '270.920'), 2.2, 2.32, NULL, 'SAE 75W-75', 'HaynesPro typeId t_302000366; 200 NGT; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 317 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '270.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 317, 'coolant', (SELECT id FROM engines WHERE code = '780.990'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_313000133; 250 e'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 317 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '780.990'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 317, 'brake_fluid', NULL, 0.5, 0.53, NULL, 'MB 331.0', 'HaynesPro chassis d_102000248; Alt: DOT 4 LV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 317 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (317)
  AND e.code IN ('270.910', '607.951 (K9K)', '651.901', '651.930', '270.920', '780.990')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (317)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (317) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;