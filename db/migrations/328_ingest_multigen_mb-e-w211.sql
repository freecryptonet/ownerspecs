-- mig 328 — multi-gen HaynesPro ingest: Mercedes-Benz E (W211, S211)
-- crawl: haynespro-crawl-mb-e-w211-2026-05-23.json
-- modelId: d_3340
-- 28 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Mercedes-Benz E (W211, S211)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_3340', NOW(), 'Multi-gen ingest, 28 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_3340' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('646.951', '200 CDI (646.951) 90kW', 2148, 'petrol', 'NA', NULL),
  ('646.820', '200 CDI (646.820) 100kW', 2148, 'petrol', 'NA', NULL),
  ('646.821', '200 CDI, -T (646.821) 100kW', 2148, 'petrol', 'NA', NULL),
  ('271.941', '200 Kompressor, -T, -LPG (271.941) 120kW', 1796, 'petrol', 'NA', NULL),
  ('271.956', '200 Kompressor, -T, -LPG (271.956) 135kW', 1796, 'petrol', 'NA', NULL),
  ('646.961', '220 CDI, -T (646.961) 110kW', 2148, 'petrol', 'NA', NULL),
  ('272.922', '230, -T, -LPG (272.922) 150kW', 2496, 'petrol', 'NA', NULL),
  ('112.917', '240 4MATIC, -T (112.917) 130kW', 2597, 'petrol', 'NA', NULL),
  ('112.913', '240, -LPG (112.913) 120kW', 2597, 'petrol', 'NA', NULL),
  ('647.961', '270 CDI, -T (647.961) 130kW', 2685, 'petrol', 'NA', NULL),
  ('642.921', '280 CDI 4MATIC, -T (642.921) 140kW', 2987, 'petrol', 'NA', NULL),
  ('642.920', '280 CDI V6, -T (642.920) 140kW', 2987, 'petrol', 'NA', NULL),
  ('648.961', '280 CDI, -T (648.961) 130kW', 3222, 'petrol', 'NA', NULL),
  ('272.943', '280, -T, -LPG (272.943) 170kW', 2996, 'petrol', 'NA', NULL),
  ('272.944', '280/300 4MATIC, -T (272.944) 170kW', 2996, 'petrol', 'NA', NULL),
  ('112.954', '320 4MATIC, -T, -LPG (112.954) 165kW', 3199, 'petrol', 'NA', NULL),
  ('112.949', '320, -T, -LPG (112.949) 165kW', 3199, 'petrol', 'NA', NULL),
  ('272.972', '350 4MATIC, -T, -LPG (272.972) 200kW', 3498, 'petrol', 'NA', NULL),
  ('272.985', '350 CGI, -T (272.985) 215kW', 3498, 'petrol', 'NA', NULL),
  ('272.964', '350, -T, -LPG (272.964) 200kW', 3498, 'petrol', 'NA', NULL),
  ('628.961', '400 CDI (628.961) 191kW', 3996, 'petrol', 'NA', NULL),
  ('629.910', '420 CDI (629.910) 231kW', 3996, 'petrol', 'NA', NULL),
  ('113.969', '500 4MATIC, -T, -LPG (113.969) 225kW', 4966, 'petrol', 'NA', NULL),
  ('113.967', '500, -T, -LPG (113.967) 225kW', 4966, 'petrol', 'NA', NULL),
  ('273.960', '500/550 (273.960) 285kW', 5461, 'petrol', 'NA', NULL),
  ('273.962', '500/550 4MATIC, -T (273.962) 285kW', 5461, 'petrol', 'NA', NULL),
  ('113.990', '55 AMG Kompressor, -T, -LPG (113.990) 350kW', 5439, 'petrol', 'NA', NULL),
  ('156.983', '63 AMG, -T (156.983) 378kW', 6208, 'petrol', 'NA', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'engine_oil', (SELECT id FROM engines WHERE code = '646.951'), 6.5, 6.87, '0W-30', 'MB 229.52', 'HaynesPro typeId t_16620; 200 CDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '646.951'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'coolant', (SELECT id FROM engines WHERE code = '646.951'), 9.75, 10.3, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_16620; 200 CDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '646.951'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'transmission_at', (SELECT id FROM engines WHERE code = '646.951'), NULL, NULL, NULL, 'MB 236.14', 'HaynesPro typeId t_16620; 200 CDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '646.951'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'engine_oil', (SELECT id FROM engines WHERE code = '646.820'), 6.5, 6.87, '0W-30', 'MB 229.52', 'HaynesPro typeId t_17780; 200 CDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '646.820'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'coolant', (SELECT id FROM engines WHERE code = '646.820'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_17780; 200 CDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '646.820'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'transmission_at', (SELECT id FROM engines WHERE code = '646.820'), NULL, NULL, NULL, 'MB 236.14', 'HaynesPro typeId t_17780; 200 CDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '646.820'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'engine_oil', (SELECT id FROM engines WHERE code = '646.821'), 6.5, 6.87, '0W-30', 'MB 229.52', 'HaynesPro typeId t_102000149; 200 CDI, -T; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '646.821'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'coolant', (SELECT id FROM engines WHERE code = '646.821'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102000149; 200 CDI, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '646.821'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'transmission_at', (SELECT id FROM engines WHERE code = '646.821'), 7.5, 7.93, NULL, 'MB 236.14', 'HaynesPro typeId t_102000149; 200 CDI, -T; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '646.821'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'engine_oil', (SELECT id FROM engines WHERE code = '271.941'), 5.5, 5.81, '0W-30', 'MB 229.5', 'HaynesPro typeId t_17340; 200 Kompressor, -T, -LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '271.941'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'coolant', (SELECT id FROM engines WHERE code = '271.941'), 5.6, 5.92, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_17340; 200 Kompressor, -T, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '271.941'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'transmission_at', (SELECT id FROM engines WHERE code = '271.941'), NULL, NULL, NULL, 'MB 236.14', 'HaynesPro typeId t_17340; 200 Kompressor, -T, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '271.941'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'engine_oil', (SELECT id FROM engines WHERE code = '271.956'), 5.5, 5.81, '0W-30', 'MB 229.5', 'HaynesPro typeId t_17830; 200 Kompressor, -T, -LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '271.956'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'coolant', (SELECT id FROM engines WHERE code = '271.956'), 5.6, 5.92, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_17830; 200 Kompressor, -T, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '271.956'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'transmission_at', (SELECT id FROM engines WHERE code = '271.956'), NULL, NULL, NULL, 'MB 236.14', 'HaynesPro typeId t_17830; 200 Kompressor, -T, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '271.956'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'engine_oil', (SELECT id FROM engines WHERE code = '646.961'), 6.5, 6.87, '0W-30', 'MB 229.52', 'HaynesPro typeId t_16710; 220 CDI, -T; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '646.961'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'coolant', (SELECT id FROM engines WHERE code = '646.961'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_16710; 220 CDI, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '646.961'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'transmission_at', (SELECT id FROM engines WHERE code = '646.961'), NULL, NULL, NULL, 'MB 236.14', 'HaynesPro typeId t_16710; 220 CDI, -T; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '646.961'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'engine_oil', (SELECT id FROM engines WHERE code = '272.922'), 8, 8.45, '0W-30', 'MB 229.5', 'HaynesPro typeId t_102000151; 230, -T, -LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '272.922'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'coolant', (SELECT id FROM engines WHERE code = '272.922'), 6.5, 6.87, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102000151; 230, -T, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '272.922'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'transmission_at', (SELECT id FROM engines WHERE code = '272.922'), 9, 9.51, NULL, 'MB 236.15', 'HaynesPro typeId t_102000151; 230, -T, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '272.922'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'engine_oil', (SELECT id FROM engines WHERE code = '112.917'), 8, 8.45, '0W-30', 'MB 229.5', 'HaynesPro typeId t_17770; 240 4MATIC, -T; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '112.917'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'coolant', (SELECT id FROM engines WHERE code = '112.917'), 9.5, 10.04, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_17770; 240 4MATIC, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '112.917'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'transmission_at', (SELECT id FROM engines WHERE code = '112.917'), 9, 9.51, NULL, 'MB 236.14', 'HaynesPro typeId t_17770; 240 4MATIC, -T; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '112.917'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'engine_oil', (SELECT id FROM engines WHERE code = '112.913'), 8, 8.45, '0W-30', 'MB 229.5', 'HaynesPro typeId t_619034856; 240, -LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '112.913'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'coolant', (SELECT id FROM engines WHERE code = '112.913'), 9.5, 10.04, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619034856; 240, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '112.913'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'transmission_at', (SELECT id FROM engines WHERE code = '112.913'), NULL, NULL, NULL, 'MB 236.14', 'HaynesPro typeId t_619034856; 240, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '112.913'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'engine_oil', (SELECT id FROM engines WHERE code = '647.961'), 6.5, 6.87, '0W-30', 'MB 229.52', 'HaynesPro typeId t_16280; 270 CDI, -T; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '647.961'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'coolant', (SELECT id FROM engines WHERE code = '647.961'), 11.25, 11.89, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_16280; 270 CDI, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '647.961'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'transmission_at', (SELECT id FROM engines WHERE code = '647.961'), 7.5, 7.93, NULL, 'MB 236.14', 'HaynesPro typeId t_16280; 270 CDI, -T; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '647.961'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'engine_oil', (SELECT id FROM engines WHERE code = '642.921'), 8.5, 8.98, '0W-30', 'MB 229.52', 'HaynesPro typeId t_17680; 280 CDI 4MATIC, -T; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '642.921'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'coolant', (SELECT id FROM engines WHERE code = '642.921'), 7.5, 7.93, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_17680; 280 CDI 4MATIC, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '642.921'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'transmission_at', (SELECT id FROM engines WHERE code = '642.921'), NULL, NULL, NULL, 'MB 236.14', 'HaynesPro typeId t_17680; 280 CDI 4MATIC, -T; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '642.921'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'engine_oil', (SELECT id FROM engines WHERE code = '642.920'), 8.5, 8.98, '0W-30', 'MB 229.52', 'HaynesPro typeId t_21630; 280 CDI V6, -T; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '642.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'coolant', (SELECT id FROM engines WHERE code = '642.920'), 7.5, 7.93, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_21630; 280 CDI V6, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '642.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'transmission_at', (SELECT id FROM engines WHERE code = '642.920'), 9, 9.51, NULL, 'MB 236.15', 'HaynesPro typeId t_21630; 280 CDI V6, -T; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '642.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'engine_oil', (SELECT id FROM engines WHERE code = '648.961'), 7.3, 7.71, '0W-30', 'MB 229.51', 'HaynesPro typeId t_17970; 280 CDI, -T; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '648.961'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'coolant', (SELECT id FROM engines WHERE code = '648.961'), 12, 12.68, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_17970; 280 CDI, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '648.961'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'transmission_at', (SELECT id FROM engines WHERE code = '648.961'), 7.5, 7.93, NULL, 'MB 236.14', 'HaynesPro typeId t_17970; 280 CDI, -T; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '648.961'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'engine_oil', (SELECT id FROM engines WHERE code = '272.943'), 8, 8.45, '0W-30', 'MB 229.5', 'HaynesPro typeId t_17630; 280, -T, -LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '272.943'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'coolant', (SELECT id FROM engines WHERE code = '272.943'), 6.5, 6.87, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_17630; 280, -T, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '272.943'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'transmission_at', (SELECT id FROM engines WHERE code = '272.943'), 9, 9.51, NULL, 'MB 236.15', 'HaynesPro typeId t_17630; 280, -T, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '272.943'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'engine_oil', (SELECT id FROM engines WHERE code = '272.944'), 8, 8.45, '0W-30', 'MB 229.5', 'HaynesPro typeId t_17950; 280/300 4MATIC, -T; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '272.944'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'coolant', (SELECT id FROM engines WHERE code = '272.944'), 6.5, 6.87, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_17950; 280/300 4MATIC, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '272.944'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'transmission_at', (SELECT id FROM engines WHERE code = '272.944'), NULL, NULL, NULL, 'MB 236.14', 'HaynesPro typeId t_17950; 280/300 4MATIC, -T; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '272.944'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'engine_oil', (SELECT id FROM engines WHERE code = '112.954'), 8, 8.45, '0W-30', 'MB 229.5', 'HaynesPro typeId t_17670; 320 4MATIC, -T, -LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '112.954'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'coolant', (SELECT id FROM engines WHERE code = '112.954'), 9.5, 10.04, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_17670; 320 4MATIC, -T, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '112.954'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'transmission_at', (SELECT id FROM engines WHERE code = '112.954'), 9, 9.51, NULL, 'MB 236.14', 'HaynesPro typeId t_17670; 320 4MATIC, -T, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '112.954'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'engine_oil', (SELECT id FROM engines WHERE code = '112.949'), 8, 8.45, '0W-30', 'MB 229.5', 'HaynesPro typeId t_17500; 320, -T, -LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '112.949'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'coolant', (SELECT id FROM engines WHERE code = '112.949'), 9.5, 10.04, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_17500; 320, -T, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '112.949'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'transmission_at', (SELECT id FROM engines WHERE code = '112.949'), 8, 8.45, NULL, 'MB 236.14', 'HaynesPro typeId t_17500; 320, -T, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '112.949'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'engine_oil', (SELECT id FROM engines WHERE code = '272.972'), 8, 8.45, '0W-30', 'MB 229.5', 'HaynesPro typeId t_21840; 350 4MATIC, -T, -LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '272.972'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'coolant', (SELECT id FROM engines WHERE code = '272.972'), 6.5, 6.87, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_21840; 350 4MATIC, -T, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '272.972'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'transmission_at', (SELECT id FROM engines WHERE code = '272.972'), 9, 9.51, NULL, 'MB 236.14', 'HaynesPro typeId t_21840; 350 4MATIC, -T, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '272.972'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'engine_oil', (SELECT id FROM engines WHERE code = '272.985'), 8, 8.45, '0W-30', 'MB 229.5', 'HaynesPro typeId t_102000152; 350 CGI, -T; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '272.985'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'coolant', (SELECT id FROM engines WHERE code = '272.985'), 6.5, 6.87, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102000152; 350 CGI, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '272.985'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'transmission_at', (SELECT id FROM engines WHERE code = '272.985'), 9, 9.51, NULL, 'MB 236.15', 'HaynesPro typeId t_102000152; 350 CGI, -T; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '272.985'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'engine_oil', (SELECT id FROM engines WHERE code = '272.964'), 8, 8.45, '0W-30', 'MB 229.5', 'HaynesPro typeId t_17870; 350, -T, -LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '272.964'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'coolant', (SELECT id FROM engines WHERE code = '272.964'), 6.5, 6.87, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_17870; 350, -T, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '272.964'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'transmission_at', (SELECT id FROM engines WHERE code = '272.964'), 9, 9.51, NULL, 'MB 236.15', 'HaynesPro typeId t_17870; 350, -T, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '272.964'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'engine_oil', (SELECT id FROM engines WHERE code = '628.961'), 8.5, 8.98, '0W-30', 'MB 229.5', 'HaynesPro typeId t_17270; 400 CDI; drain 32 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '628.961'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'coolant', (SELECT id FROM engines WHERE code = '628.961'), 15.3, 16.17, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_17270; 400 CDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '628.961'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'transmission_at', (SELECT id FROM engines WHERE code = '628.961'), NULL, NULL, NULL, 'MB 236.14', 'HaynesPro typeId t_17270; 400 CDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '628.961'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'engine_oil', (SELECT id FROM engines WHERE code = '629.910'), 10.5, 11.1, '0W-30', 'MB 229.52', 'HaynesPro typeId t_17820; 420 CDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '629.910'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'coolant', (SELECT id FROM engines WHERE code = '629.910'), 8, 8.45, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_17820; 420 CDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '629.910'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'transmission_at', (SELECT id FROM engines WHERE code = '629.910'), 9, 9.51, NULL, 'SAE 75W-85', 'HaynesPro typeId t_17820; 420 CDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '629.910'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'engine_oil', (SELECT id FROM engines WHERE code = '113.969'), 8, 8.45, '0W-30', 'MB 229.5', 'HaynesPro typeId t_17750; 500 4MATIC, -T, -LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '113.969'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'coolant', (SELECT id FROM engines WHERE code = '113.969'), 10.75, 11.36, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_17750; 500 4MATIC, -T, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '113.969'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'transmission_at', (SELECT id FROM engines WHERE code = '113.969'), 9, 9.51, NULL, 'MB 236.14', 'HaynesPro typeId t_17750; 500 4MATIC, -T, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '113.969'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'engine_oil', (SELECT id FROM engines WHERE code = '113.967'), 7.5, 7.93, '0W-30', 'MB 229.5', 'HaynesPro typeId t_17540; 500, -T, -LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '113.967'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'coolant', (SELECT id FROM engines WHERE code = '113.967'), 10.75, 11.36, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_17540; 500, -T, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '113.967'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'transmission_at', (SELECT id FROM engines WHERE code = '113.967'), 9, 9.51, NULL, 'MB 236.14', 'HaynesPro typeId t_17540; 500, -T, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '113.967'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'engine_oil', (SELECT id FROM engines WHERE code = '273.960'), 8.5, 8.98, '0W-30', 'MB 229.5', 'HaynesPro typeId t_17880; 500/550; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '273.960'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'coolant', (SELECT id FROM engines WHERE code = '273.960'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_17880; 500/550'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '273.960'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'transmission_at', (SELECT id FROM engines WHERE code = '273.960'), 9, 9.51, NULL, 'MB 236.15', 'HaynesPro typeId t_17880; 500/550; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '273.960'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'engine_oil', (SELECT id FROM engines WHERE code = '273.962'), 8.5, 8.98, '0W-30', 'MB 229.5', 'HaynesPro typeId t_17940; 500/550 4MATIC, -T; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '273.962'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'coolant', (SELECT id FROM engines WHERE code = '273.962'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_17940; 500/550 4MATIC, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '273.962'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'transmission_at', (SELECT id FROM engines WHERE code = '273.962'), 9, 9.51, NULL, 'MB 236.14', 'HaynesPro typeId t_17940; 500/550 4MATIC, -T; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '273.962'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'engine_oil', (SELECT id FROM engines WHERE code = '113.990'), 8.5, 8.98, '0W-40', 'MB 229.5', 'HaynesPro typeId t_17590; 55 AMG Kompressor, -T, -LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '113.990'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'coolant', (SELECT id FROM engines WHERE code = '113.990'), 13.2, 13.95, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_17590; 55 AMG Kompressor, -T, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '113.990'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'transmission_at', (SELECT id FROM engines WHERE code = '113.990'), 8.7, 9.19, NULL, 'MB 236.14', 'HaynesPro typeId t_17590; 55 AMG Kompressor, -T, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '113.990'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'engine_oil', (SELECT id FROM engines WHERE code = '156.983'), 8.8, 9.3, '0W-40', 'MB 229.51', 'HaynesPro typeId t_17890; 63 AMG, -T; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '156.983'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'coolant', (SELECT id FROM engines WHERE code = '156.983'), 8, 8.45, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_17890; 63 AMG, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '156.983'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'transmission_at', (SELECT id FROM engines WHERE code = '156.983'), 9, 9.51, NULL, 'MB 236.15', 'HaynesPro typeId t_17890; 63 AMG, -T; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '156.983'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 307, 'brake_fluid', NULL, NULL, NULL, NULL, 'DOT 4+', 'HaynesPro chassis d_3340;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 307 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (307)
  AND e.code IN ('646.951', '646.820', '646.821', '271.941', '271.956', '646.961', '272.922', '112.917', '112.913', '647.961', '642.921', '642.920', '648.961', '272.943', '272.944', '112.954', '112.949', '272.972', '272.985', '272.964', '628.961', '629.910', '113.969', '113.967', '273.960', '273.962', '113.990', '156.983')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (307)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (307) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;