-- mig 331 — multi-gen HaynesPro ingest: Mercedes-Benz E (W213)
-- crawl: haynespro-crawl-mb-e-w213-2026-05-23.json
-- modelId: d_319000496
-- 14 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Mercedes-Benz E (W213)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319000496', NOW(), 'Multi-gen ingest, 14 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319000496' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('274.910', '180 (274.910) 114kW', 1595, 'petrol', 'NA', NULL),
  ('264.915', '180 (264.915) 115kW', 1497, 'petrol', 'NA', NULL),
  ('264.920', '200 EQ Boost, -4MATIC (264.920) 145kW', 1991, 'petrol', 'NA', NULL),
  ('654.920', '200 d (654.920) 110kW', 1950, 'petrol', 'NA', NULL),
  ('654.916', '200 d, -T (654.916) 118kW', 1597, 'petrol', 'NA', NULL),
  ('274.920', '200, -4MATIC, -T (274.920) 135kW', 1991, 'petrol', 'NA', NULL),
  ('654.820', '220 d, -4MATIC (654.820) 147kW', 1993, 'petrol', 'NA', NULL),
  ('642.873', '350 d 4MATIC (642.873) 190kW', 2987, 'petrol', 'NA', NULL),
  ('656.929', '350 d, -4MATIC (656.929) 210kW', 2925, 'petrol', 'NA', NULL),
  ('642.855', '350 d,-4MATIC, -T (642.855) 190kW', 2987, 'petrol', 'NA', NULL),
  ('276.853', '400 4MATIC (276.853) 245kW', 3498, 'petrol', 'NA', NULL),
  ('276.823', '400 4MATIC, -T (276.823) 245kW', 2996, 'petrol', 'NA', NULL),
  ('256.930', '450 4MATIC (256.930) 270kW', 2999, 'petrol', 'NA', NULL),
  ('177.980', '63 AMG (177.980) 420kW', 3982, 'petrol', 'NA', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'engine_oil', (SELECT id FROM engines WHERE code = '274.910'), 7, 7.4, '0W-30', 'MB 229.6', 'HaynesPro typeId t_319005612; 180; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '274.910'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'coolant', (SELECT id FROM engines WHERE code = '274.910'), NULL, NULL, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_319005612; 180'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '274.910'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'transmission_at', (SELECT id FROM engines WHERE code = '274.910'), NULL, NULL, NULL, 'MB 236.17', 'HaynesPro typeId t_319005612; 180; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '274.910'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'coolant', (SELECT id FROM engines WHERE code = '264.915'), 11, 11.62, NULL, NULL, 'HaynesPro typeId t_619022965; 180'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '264.915'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'transmission_at', (SELECT id FROM engines WHERE code = '264.915'), NULL, NULL, NULL, 'MB 236.17', 'HaynesPro typeId t_619022965; 180; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '264.915'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'engine_oil', (SELECT id FROM engines WHERE code = '264.920'), NULL, NULL, '0W-20', 'MB 229.72', 'HaynesPro typeId t_619022967; 200 EQ Boost, -4MATIC; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '264.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'coolant', (SELECT id FROM engines WHERE code = '264.920'), 11, 11.62, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_619022967; 200 EQ Boost, -4MATIC'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '264.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'transmission_at', (SELECT id FROM engines WHERE code = '264.920'), NULL, NULL, NULL, 'MB 236.17', 'HaynesPro typeId t_619022967; 200 EQ Boost, -4MATIC; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '264.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'engine_oil', (SELECT id FROM engines WHERE code = '654.920'), NULL, NULL, '0W-20', 'MB 229.72', 'HaynesPro typeId t_319001056; 200 d; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '654.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'coolant', (SELECT id FROM engines WHERE code = '654.920'), 12.5, 13.21, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_319001056; 200 d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '654.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'transmission_at', (SELECT id FROM engines WHERE code = '654.920'), NULL, NULL, NULL, 'MB 236.17', 'HaynesPro typeId t_319001056; 200 d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '654.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'engine_oil', (SELECT id FROM engines WHERE code = '654.916'), NULL, NULL, '0W-20', 'MB 229.72', 'HaynesPro typeId t_619017799; 200 d, -T; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '654.916'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'coolant', (SELECT id FROM engines WHERE code = '654.916'), 11, 11.62, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_619017799; 200 d, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '654.916'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'transmission_at', (SELECT id FROM engines WHERE code = '654.916'), NULL, NULL, NULL, 'MB 236.17', 'HaynesPro typeId t_619017799; 200 d, -T; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '654.916'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'engine_oil', (SELECT id FROM engines WHERE code = '274.920'), 7, 7.4, '0W-30', 'MB 229.6', 'HaynesPro typeId t_319000917; 200, -4MATIC, -T; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '274.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'coolant', (SELECT id FROM engines WHERE code = '274.920'), NULL, NULL, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_319000917; 200, -4MATIC, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '274.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'transmission_mt', (SELECT id FROM engines WHERE code = '274.920'), 1.2, 1.27, NULL, 'MB 236.24', 'HaynesPro typeId t_319000917; 200, -4MATIC, -T; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '274.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'engine_oil', (SELECT id FROM engines WHERE code = '654.820'), NULL, NULL, '0W-20', 'MB 229.72', 'HaynesPro typeId t_619108761; 220 d, -4MATIC; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '654.820'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'coolant', (SELECT id FROM engines WHERE code = '654.820'), 11, 11.62, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_619108761; 220 d, -4MATIC'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '654.820'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'transmission_at', (SELECT id FROM engines WHERE code = '654.820'), NULL, NULL, NULL, 'MB 236.17', 'HaynesPro typeId t_619108761; 220 d, -4MATIC; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '654.820'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'engine_oil', (SELECT id FROM engines WHERE code = '642.873'), 8, 8.45, '0W-30', 'MB 229.52', 'HaynesPro typeId t_319005616; 350 d 4MATIC; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '642.873'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'coolant', (SELECT id FROM engines WHERE code = '642.873'), NULL, NULL, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_319005616; 350 d 4MATIC'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '642.873'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'transmission_at', (SELECT id FROM engines WHERE code = '642.873'), 10, 10.57, NULL, 'MB 236.17', 'HaynesPro typeId t_319005616; 350 d 4MATIC; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '642.873'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'engine_oil', (SELECT id FROM engines WHERE code = '656.929'), NULL, NULL, '0W-30', 'MB 229.61', 'HaynesPro typeId t_619013383; 350 d, -4MATIC; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '656.929'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'coolant', (SELECT id FROM engines WHERE code = '656.929'), 13, 13.74, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_619013383; 350 d, -4MATIC'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '656.929'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'transmission_at', (SELECT id FROM engines WHERE code = '656.929'), NULL, NULL, NULL, 'MB 236.17', 'HaynesPro typeId t_619013383; 350 d, -4MATIC; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '656.929'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'engine_oil', (SELECT id FROM engines WHERE code = '642.855'), 9, 9.51, '0W-30', 'MB 229.52', 'HaynesPro typeId t_319000918; 350 d,-4MATIC, -T; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '642.855'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'coolant', (SELECT id FROM engines WHERE code = '642.855'), NULL, NULL, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_319000918; 350 d,-4MATIC, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '642.855'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'transmission_at', (SELECT id FROM engines WHERE code = '642.855'), NULL, NULL, NULL, 'MB 236.17', 'HaynesPro typeId t_319000918; 350 d,-4MATIC, -T; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '642.855'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'engine_oil', (SELECT id FROM engines WHERE code = '276.853'), 6.5, 6.87, '0W-30', 'MB 229.6', 'HaynesPro typeId t_319001065; 400 4MATIC; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '276.853'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'coolant', (SELECT id FROM engines WHERE code = '276.853'), NULL, NULL, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_319001065; 400 4MATIC'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '276.853'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'transmission_at', (SELECT id FROM engines WHERE code = '276.853'), 10, 10.57, NULL, 'MB 236.17', 'HaynesPro typeId t_319001065; 400 4MATIC; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '276.853'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'engine_oil', (SELECT id FROM engines WHERE code = '276.823'), 6.5, 6.87, '0W-30', 'MB 229.6', 'HaynesPro typeId t_619021551; 400 4MATIC, -T; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '276.823'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'coolant', (SELECT id FROM engines WHERE code = '276.823'), NULL, NULL, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_619021551; 400 4MATIC, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '276.823'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'transmission_at', (SELECT id FROM engines WHERE code = '276.823'), 10, 10.57, NULL, 'MB 236.15', 'HaynesPro typeId t_619021551; 400 4MATIC, -T; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '276.823'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'engine_oil', (SELECT id FROM engines WHERE code = '256.930'), 8.5, 8.98, '0W-20', 'MB 229.72', 'HaynesPro typeId t_619035949; 450 4MATIC; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '256.930'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'coolant', (SELECT id FROM engines WHERE code = '256.930'), NULL, NULL, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_619035949; 450 4MATIC'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '256.930'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'transmission_at', (SELECT id FROM engines WHERE code = '256.930'), 10, 10.57, NULL, 'MB 236.15', 'HaynesPro typeId t_619035949; 450 4MATIC; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '256.930'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'engine_oil', (SELECT id FROM engines WHERE code = '177.980'), 9, 9.51, '0W-40', 'MB 229.51', 'HaynesPro typeId t_319005611; 63 AMG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '177.980'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'coolant', (SELECT id FROM engines WHERE code = '177.980'), NULL, NULL, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_319005611; 63 AMG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '177.980'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'transmission_at', (SELECT id FROM engines WHERE code = '177.980'), 10, 10.57, NULL, 'MB 236.17', 'HaynesPro typeId t_319005611; 63 AMG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '177.980'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 310, 'brake_fluid', NULL, 1, 1.06, NULL, 'MB 331.0', 'HaynesPro chassis d_319000496;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 310 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (310)
  AND e.code IN ('274.910', '264.915', '264.920', '654.920', '654.916', '274.920', '654.820', '642.873', '656.929', '642.855', '276.853', '276.823', '256.930', '177.980')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (310)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (310) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;