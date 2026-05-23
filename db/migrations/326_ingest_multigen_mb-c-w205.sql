-- mig 326 — multi-gen HaynesPro ingest: Mercedes-Benz C (W205)
-- crawl: haynespro-crawl-mb-c-w205-2026-05-23.json
-- modelId: d_301000084
-- 10 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Mercedes-Benz C (W205)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_301000084', NOW(), 'Multi-gen ingest, 10 engines across 2 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_301000084' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('274.910', '160 (274.910) 95kW', 1595, 'petrol', 'NA', NULL),
  ('264.915', '160 (264.915) 95kW', 1497, 'petrol', 'NA', NULL),
  ('626.951 (R9M)', '180 BlueTEC (626.951 (R9M)) 85kW', 1598, 'diesel', 'NA', NULL),
  ('654.916', '180 d (654.916) 90kW', 1597, 'petrol', 'NA', NULL),
  ('264.920', '200 (264.920) 150kW', 1991, 'petrol', 'NA', NULL),
  ('651.921', '200 BlueTEC (651.921) 100kW', 2143, 'diesel', 'NA', NULL),
  ('654.920', '200 d (654.920) 110kW', 1950, 'petrol', 'NA', NULL),
  ('274.920', '200, -4MATIC (274.920) 135kW', 1991, 'petrol', 'NA', NULL),
  ('276.823', '400 4MATIC (276.823) 245kW', 2996, 'petrol', 'NA', NULL),
  ('177.980', '63 AMG (177.980) 350kW', 3982, 'petrol', 'NA', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 304, 'engine_oil', (SELECT id FROM engines WHERE code = '274.910'), 7, 7.4, '0W-30', 'MB 229.6', 'HaynesPro typeId t_317000546; 160; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 304 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '274.910'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 304, 'coolant', (SELECT id FROM engines WHERE code = '274.910'), NULL, NULL, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_317000546; 160'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 304 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '274.910'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 304, 'transmission_mt', (SELECT id FROM engines WHERE code = '274.910'), 1.2, 1.27, NULL, 'MB 236.24', 'HaynesPro typeId t_317000546; 160; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 304 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '274.910'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 304, 'coolant', (SELECT id FROM engines WHERE code = '264.915'), 8.6, 9.09, NULL, NULL, 'HaynesPro typeId t_619024275; 160'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 304 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '264.915'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 304, 'transmission_at', (SELECT id FROM engines WHERE code = '264.915'), NULL, NULL, NULL, 'MB 236.17', 'HaynesPro typeId t_619024275; 160; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 304 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '264.915'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 304, 'engine_oil', (SELECT id FROM engines WHERE code = '626.951 (R9M)'), 6.5, 6.87, '0W-30', 'MB 229.52', 'HaynesPro typeId t_305000666; 180 BlueTEC; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 304 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '626.951 (R9M)'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 304, 'coolant', (SELECT id FROM engines WHERE code = '626.951 (R9M)'), 10.3, 10.88, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_305000666; 180 BlueTEC'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 304 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '626.951 (R9M)'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 304, 'transmission_mt', (SELECT id FROM engines WHERE code = '626.951 (R9M)'), 1.2, 1.27, NULL, 'MB 236.24', 'HaynesPro typeId t_305000666; 180 BlueTEC; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 304 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '626.951 (R9M)'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 304, 'engine_oil', (SELECT id FROM engines WHERE code = '654.916'), NULL, NULL, '0W-20', 'MB 229.72', 'HaynesPro typeId t_619009794; 180 d; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 304 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '654.916'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 304, 'coolant', (SELECT id FROM engines WHERE code = '654.916'), 10, 10.57, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_619009794; 180 d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 304 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '654.916'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 304, 'transmission_at', (SELECT id FROM engines WHERE code = '654.916'), 1.2, 1.27, NULL, 'MB 236.17', 'HaynesPro typeId t_619009794; 180 d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 304 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '654.916'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 304, 'engine_oil', (SELECT id FROM engines WHERE code = '264.920'), NULL, NULL, '0W-20', 'MB 229.72', 'HaynesPro typeId t_619029926; 200; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 304 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '264.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 304, 'coolant', (SELECT id FROM engines WHERE code = '264.920'), NULL, NULL, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_619029926; 200'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 304 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '264.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 304, 'transmission_at', (SELECT id FROM engines WHERE code = '264.920'), NULL, NULL, NULL, 'MB 236.17', 'HaynesPro typeId t_619029926; 200; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 304 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '264.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 304, 'engine_oil', (SELECT id FROM engines WHERE code = '651.921'), 6, 6.34, '0W-30', 'MB 229.52', 'HaynesPro typeId t_319000539; 200 BlueTEC; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 304 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '651.921'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 304, 'coolant', (SELECT id FROM engines WHERE code = '651.921'), NULL, NULL, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_319000539; 200 BlueTEC'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 304 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '651.921'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 304, 'transmission_at', (SELECT id FROM engines WHERE code = '651.921'), 9, 9.51, NULL, 'MB 236.17', 'HaynesPro typeId t_319000539; 200 BlueTEC; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 304 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '651.921'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 304, 'coolant', (SELECT id FROM engines WHERE code = '654.920'), 10, 10.57, NULL, NULL, 'HaynesPro typeId t_619009803; 200 d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 304 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '654.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 304, 'transmission_at', (SELECT id FROM engines WHERE code = '654.920'), NULL, NULL, NULL, 'MB 236.17', 'HaynesPro typeId t_619009803; 200 d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 304 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '654.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 304, 'engine_oil', (SELECT id FROM engines WHERE code = '274.920'), 7, 7.4, '0W-30', 'MB 229.6', 'HaynesPro typeId t_303000006; 200, -4MATIC; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 304 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '274.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 304, 'coolant', (SELECT id FROM engines WHERE code = '274.920'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_303000006; 200, -4MATIC'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 304 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '274.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 304, 'transmission_mt', (SELECT id FROM engines WHERE code = '274.920'), 1.2, 1.27, NULL, 'MB 236.24', 'HaynesPro typeId t_303000006; 200, -4MATIC; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 304 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '274.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 304, 'engine_oil', (SELECT id FROM engines WHERE code = '276.823'), 6.5, 6.87, '0W-30', 'MB 229.6', 'HaynesPro typeId t_313000127; 400 4MATIC; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 304 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '276.823'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 304, 'coolant', (SELECT id FROM engines WHERE code = '276.823'), NULL, NULL, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_313000127; 400 4MATIC'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 304 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '276.823'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 304, 'transmission_at', (SELECT id FROM engines WHERE code = '276.823'), 9.7, 10.25, NULL, 'MB 236.15', 'HaynesPro typeId t_313000127; 400 4MATIC; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 304 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '276.823'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 306, 'engine_oil', (SELECT id FROM engines WHERE code = '177.980'), 9, 9.51, '0W-40', 'MB 229.51', 'HaynesPro typeId t_318000003; 63 AMG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 306 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '177.980'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 306, 'coolant', (SELECT id FROM engines WHERE code = '177.980'), NULL, NULL, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_318000003; 63 AMG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 306 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '177.980'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 306, 'transmission_at', (SELECT id FROM engines WHERE code = '177.980'), 7.1, 7.5, NULL, 'MB 236.15', 'HaynesPro typeId t_318000003; 63 AMG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 306 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '177.980'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 304, 'brake_fluid', NULL, 0.5, 0.53, NULL, 'MB 331.0', 'HaynesPro chassis d_301000084; Alt: DOT 4 LV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 304 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 306, 'brake_fluid', NULL, 0.5, 0.53, NULL, 'MB 331.0', 'HaynesPro chassis d_301000084; Alt: DOT 4 LV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 306 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (304, 306)
  AND e.code IN ('274.910', '264.915', '626.951 (R9M)', '654.916', '264.920', '651.921', '654.920', '274.920', '276.823', '177.980')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (304, 306)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (304, 306) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;