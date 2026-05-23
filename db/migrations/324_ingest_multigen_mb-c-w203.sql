-- mig 324 — multi-gen HaynesPro ingest: Mercedes-Benz C (W203, S203)
-- crawl: haynespro-crawl-mb-c-w203-2026-05-23.json
-- modelId: d_3610
-- 25 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Mercedes-Benz C (W203, S203)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_3610', NOW(), 'Multi-gen ingest, 25 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_3610' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('271.921', '160 Kompressor Coupe, -LPG (271.921) 90kW', 1796, 'petrol', 'NA', NULL),
  ('271.946', '180 Kompressor, -T, -Coupe, LPG (271.946) 105kW', 1796, 'petrol', 'NA', NULL),
  ('111.951', '180, -T, -Coupe, -LPG (111.951) 95kW', 1998, 'petrol', 'NA', NULL),
  ('646.962', '200 CDI, -T (646.962) 75kW', 2148, 'petrol', 'NA', NULL),
  ('611.962', '200 CDI, -T (611.962) 85kW', 2148, 'petrol', 'NA', NULL),
  ('646.963', '200 CDI, -T, -Coupe (646.963) 90kW', 2148, 'petrol', 'NA', NULL),
  ('271.942', '200 CGI Kompressor, -T, -Coupe (271.942) 125kW', 1796, 'petrol', 'NA', NULL),
  ('271.940', '200 Kompressor, -T, -Coupe, -LPG (271.940) 120kW', 1796, 'petrol', 'NA', NULL),
  ('111.955', '200 Kompressor, -T, -Coupe, LPG (111.955) 120kW', 1998, 'petrol', 'NA', NULL),
  ('111.981', '230 Kompressor Coupe, -LPG (111.981) 145kW', 2295, 'petrol', 'NA', NULL),
  ('271.948', '230 Kompressor, -T, -Coupe, -LPG (271.948) 141kW', 1796, 'petrol', 'NA', NULL),
  ('272.920', '230, -T, -Coupe, -LPG (272.920) 150kW', 2497, 'petrol', 'NA', NULL),
  ('112.916', '240 4MATIC, -T (112.916) 125kW', 2597, 'petrol', 'NA', NULL),
  ('112.912', '240, -T, LPG (112.912) 125kW', 2597, 'petrol', 'NA', NULL),
  ('612.962', '270 CDI, -T (612.962) 125kW', 2685, 'petrol', 'NA', NULL),
  ('272.941', '280 4MATIC, T, -LPG (272.941) 170kW', 2997, 'petrol', 'NA', NULL),
  ('272.940', '280, -T, -LPG (272.940) 170kW', 2997, 'petrol', 'NA', NULL),
  ('612.990', '30 CDI AMG, -T, -Coupe (612.990) 170kW', 2950, 'petrol', 'NA', NULL),
  ('112.961', '32 AMG Kompressor, -T (112.961) 260kW', 3199, 'petrol', 'NA', NULL),
  ('112.953', '320 4MATIC, -T (112.953) 160kW', 3199, 'petrol', 'NA', NULL),
  ('642.910', '320 CDI, -T (642.910) 165kW', 2987, 'petrol', 'NA', NULL),
  ('112.946', '320, -T, -Coupe, -LPG (112.946) 160kW', 3199, 'petrol', 'NA', NULL),
  ('272.970', '350 4MATIC, -T, -LPG (272.970) 200kW', 3498, 'petrol', 'NA', NULL),
  ('272.960', '350, -T, -Coupe (272.960) 200kW', 3498, 'petrol', 'NA', NULL),
  ('113.988', '55 AMG, -T, -LPG (113.988) 270kW', 5439, 'petrol', 'NA', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'engine_oil', (SELECT id FROM engines WHERE code = '271.921'), 5.5, 5.81, '0W-30', 'MB 229.5', 'HaynesPro typeId t_65980; 160 Kompressor Coupe, -LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '271.921'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'coolant', (SELECT id FROM engines WHERE code = '271.921'), 5.6, 5.92, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_65980; 160 Kompressor Coupe, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '271.921'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'transmission_at', (SELECT id FROM engines WHERE code = '271.921'), NULL, NULL, NULL, 'MB 236.14', 'HaynesPro typeId t_65980; 160 Kompressor Coupe, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '271.921'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'engine_oil', (SELECT id FROM engines WHERE code = '271.946'), 5.5, 5.81, '0W-30', 'MB 229.5', 'HaynesPro typeId t_65860; 180 Kompressor, -T, -Coupe, LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '271.946'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'coolant', (SELECT id FROM engines WHERE code = '271.946'), 5.6, 5.92, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_65860; 180 Kompressor, -T, -Coupe, LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '271.946'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'transmission_at', (SELECT id FROM engines WHERE code = '271.946'), NULL, NULL, NULL, 'MB 236.14', 'HaynesPro typeId t_65860; 180 Kompressor, -T, -Coupe, LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '271.946'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'engine_oil', (SELECT id FROM engines WHERE code = '111.951'), 7, 7.4, '0W-30', 'MB 229.5', 'HaynesPro typeId t_65820; 180, -T, -Coupe, -LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '111.951'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'coolant', (SELECT id FROM engines WHERE code = '111.951'), 8.5, 8.98, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_65820; 180, -T, -Coupe, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '111.951'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'transmission_at', (SELECT id FROM engines WHERE code = '111.951'), NULL, NULL, NULL, 'MB 236.14', 'HaynesPro typeId t_65820; 180, -T, -Coupe, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '111.951'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'engine_oil', (SELECT id FROM engines WHERE code = '646.962'), 6.5, 6.87, '0W-30', 'MB 229.52', 'HaynesPro typeId t_105000208; 200 CDI, -T; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '646.962'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'coolant', (SELECT id FROM engines WHERE code = '646.962'), 6, 6.34, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_105000208; 200 CDI, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '646.962'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'transmission_at', (SELECT id FROM engines WHERE code = '646.962'), NULL, NULL, NULL, 'MB 236.14', 'HaynesPro typeId t_105000208; 200 CDI, -T; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '646.962'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'engine_oil', (SELECT id FROM engines WHERE code = '611.962'), 6.5, 6.87, '0W-30', 'MB 229.52', 'HaynesPro typeId t_65700; 200 CDI, -T; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '611.962'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'coolant', (SELECT id FROM engines WHERE code = '611.962'), 11.9, 12.57, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_65700; 200 CDI, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '611.962'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'transmission_at', (SELECT id FROM engines WHERE code = '611.962'), NULL, NULL, NULL, 'MB 236.14', 'HaynesPro typeId t_65700; 200 CDI, -T; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '611.962'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'engine_oil', (SELECT id FROM engines WHERE code = '646.963'), 6.5, 6.87, '0W-30', 'MB 229.52', 'HaynesPro typeId t_65770; 200 CDI, -T, -Coupe; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '646.963'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'coolant', (SELECT id FROM engines WHERE code = '646.963'), 6, 6.34, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_65770; 200 CDI, -T, -Coupe'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '646.963'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'transmission_mt', (SELECT id FROM engines WHERE code = '646.963'), 1.2, 1.27, NULL, 'SAE 75W-75', 'HaynesPro typeId t_65770; 200 CDI, -T, -Coupe; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '646.963'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'engine_oil', (SELECT id FROM engines WHERE code = '271.942'), 5.5, 5.81, '0W-30', 'MB 229.5', 'HaynesPro typeId t_65840; 200 CGI Kompressor, -T, -Coupe; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '271.942'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'coolant', (SELECT id FROM engines WHERE code = '271.942'), 5.6, 5.92, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_65840; 200 CGI Kompressor, -T, -Coupe'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '271.942'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'transmission_at', (SELECT id FROM engines WHERE code = '271.942'), NULL, NULL, NULL, 'MB 236.14', 'HaynesPro typeId t_65840; 200 CGI Kompressor, -T, -Coupe; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '271.942'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'engine_oil', (SELECT id FROM engines WHERE code = '271.940'), 5.5, 5.81, '0W-30', 'MB 229.5', 'HaynesPro typeId t_65830; 200 Kompressor, -T, -Coupe, -LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '271.940'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'coolant', (SELECT id FROM engines WHERE code = '271.940'), 5.6, 5.92, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_65830; 200 Kompressor, -T, -Coupe, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '271.940'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'transmission_at', (SELECT id FROM engines WHERE code = '271.940'), NULL, NULL, NULL, 'MB 236.14', 'HaynesPro typeId t_65830; 200 Kompressor, -T, -Coupe, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '271.940'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'engine_oil', (SELECT id FROM engines WHERE code = '111.955'), 7, 7.4, '0W-30', 'MB 229.5', 'HaynesPro typeId t_65850; 200 Kompressor, -T, -Coupe, LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '111.955'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'coolant', (SELECT id FROM engines WHERE code = '111.955'), 8.5, 8.98, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_65850; 200 Kompressor, -T, -Coupe, LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '111.955'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'transmission_at', (SELECT id FROM engines WHERE code = '111.955'), NULL, NULL, NULL, 'MB 236.14', 'HaynesPro typeId t_65850; 200 Kompressor, -T, -Coupe, LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '111.955'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'engine_oil', (SELECT id FROM engines WHERE code = '111.981'), 7, 7.4, '0W-30', 'MB 229.3', 'HaynesPro typeId t_65950; 230 Kompressor Coupe, -LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '111.981'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'coolant', (SELECT id FROM engines WHERE code = '111.981'), 8.5, 8.98, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_65950; 230 Kompressor Coupe, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '111.981'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'transmission_at', (SELECT id FROM engines WHERE code = '111.981'), NULL, NULL, NULL, 'MB 236.14', 'HaynesPro typeId t_65950; 230 Kompressor Coupe, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '111.981'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'engine_oil', (SELECT id FROM engines WHERE code = '271.948'), 5.5, 5.81, '0W-30', 'MB 229.5', 'HaynesPro typeId t_65930; 230 Kompressor, -T, -Coupe, -LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '271.948'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'coolant', (SELECT id FROM engines WHERE code = '271.948'), 5.6, 5.92, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_65930; 230 Kompressor, -T, -Coupe, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '271.948'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'transmission_at', (SELECT id FROM engines WHERE code = '271.948'), NULL, NULL, NULL, 'MB 236.14', 'HaynesPro typeId t_65930; 230 Kompressor, -T, -Coupe, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '271.948'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'engine_oil', (SELECT id FROM engines WHERE code = '272.920'), 8, 8.45, '0W-30', 'MB 229.5', 'HaynesPro typeId t_65790; 230, -T, -Coupe, -LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '272.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'coolant', (SELECT id FROM engines WHERE code = '272.920'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_65790; 230, -T, -Coupe, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '272.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'transmission_at', (SELECT id FROM engines WHERE code = '272.920'), 9, 9.51, NULL, 'MB 236.15', 'HaynesPro typeId t_65790; 230, -T, -Coupe, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '272.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'engine_oil', (SELECT id FROM engines WHERE code = '112.916'), 7.5, 7.93, '0W-30', 'MB 229.3', 'HaynesPro typeId t_65900; 240 4MATIC, -T; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '112.916'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'coolant', (SELECT id FROM engines WHERE code = '112.916'), 10, 10.57, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_65900; 240 4MATIC, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '112.916'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'transmission_at', (SELECT id FROM engines WHERE code = '112.916'), 9, 9.51, NULL, 'MB 236.14', 'HaynesPro typeId t_65900; 240 4MATIC, -T; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '112.916'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'engine_oil', (SELECT id FROM engines WHERE code = '112.912'), 8, 8.45, '0W-30', 'MB 229.5', 'HaynesPro typeId t_65870; 240, -T, LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '112.912'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'coolant', (SELECT id FROM engines WHERE code = '112.912'), 10.5, 11.1, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_65870; 240, -T, LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '112.912'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'transmission_at', (SELECT id FROM engines WHERE code = '112.912'), NULL, NULL, NULL, 'MB 236.14', 'HaynesPro typeId t_65870; 240, -T, LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '112.912'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'engine_oil', (SELECT id FROM engines WHERE code = '612.962'), 6.5, 6.87, '0W-30', 'MB 229.52', 'HaynesPro typeId t_65750; 270 CDI, -T; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '612.962'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'coolant', (SELECT id FROM engines WHERE code = '612.962'), 12.4, 13.1, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_65750; 270 CDI, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '612.962'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'transmission_at', (SELECT id FROM engines WHERE code = '612.962'), 7.5, 7.93, NULL, 'MB 236.14', 'HaynesPro typeId t_65750; 270 CDI, -T; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '612.962'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'engine_oil', (SELECT id FROM engines WHERE code = '272.941'), 8, 8.45, '0W-30', 'MB 229.5', 'HaynesPro typeId t_65990; 280 4MATIC, T, -LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '272.941'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'coolant', (SELECT id FROM engines WHERE code = '272.941'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_65990; 280 4MATIC, T, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '272.941'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'transmission_at', (SELECT id FROM engines WHERE code = '272.941'), 9.7, 10.25, NULL, 'MB 236.15', 'HaynesPro typeId t_65990; 280 4MATIC, T, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '272.941'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'engine_oil', (SELECT id FROM engines WHERE code = '272.940'), 8, 8.45, '0W-30', 'MB 229.5', 'HaynesPro typeId t_65800; 280, -T, -LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '272.940'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'coolant', (SELECT id FROM engines WHERE code = '272.940'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_65800; 280, -T, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '272.940'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'transmission_at', (SELECT id FROM engines WHERE code = '272.940'), 9, 9.51, NULL, 'MB 236.15', 'HaynesPro typeId t_65800; 280, -T, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '272.940'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'engine_oil', (SELECT id FROM engines WHERE code = '612.990'), 6.5, 6.87, '0W-30', 'MB 229.52', 'HaynesPro typeId t_65760; 30 CDI AMG, -T, -Coupe; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '612.990'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'coolant', (SELECT id FROM engines WHERE code = '612.990'), 13, 13.74, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_65760; 30 CDI AMG, -T, -Coupe'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '612.990'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'transmission_at', (SELECT id FROM engines WHERE code = '612.990'), NULL, NULL, NULL, 'MB 236.14', 'HaynesPro typeId t_65760; 30 CDI AMG, -T, -Coupe; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '612.990'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'engine_oil', (SELECT id FROM engines WHERE code = '112.961'), 8, 8.45, '0W-30', 'MB 229.5', 'HaynesPro typeId t_65890; 32 AMG Kompressor, -T; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '112.961'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'coolant', (SELECT id FROM engines WHERE code = '112.961'), 14, 14.79, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_65890; 32 AMG Kompressor, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '112.961'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'transmission_at', (SELECT id FROM engines WHERE code = '112.961'), NULL, NULL, NULL, 'MB 236.14', 'HaynesPro typeId t_65890; 32 AMG Kompressor, -T; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '112.961'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'engine_oil', (SELECT id FROM engines WHERE code = '112.953'), 7.5, 7.93, '0W-30', 'MB 229.3', 'HaynesPro typeId t_65910; 320 4MATIC, -T; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '112.953'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'coolant', (SELECT id FROM engines WHERE code = '112.953'), 10, 10.57, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_65910; 320 4MATIC, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '112.953'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'transmission_at', (SELECT id FROM engines WHERE code = '112.953'), 9, 9.51, NULL, 'MB 236.14', 'HaynesPro typeId t_65910; 320 4MATIC, -T; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '112.953'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'engine_oil', (SELECT id FROM engines WHERE code = '642.910'), 8.5, 8.98, '0W-30', 'MB 229.52', 'HaynesPro typeId t_102000133; 320 CDI, -T; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '642.910'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'coolant', (SELECT id FROM engines WHERE code = '642.910'), 7.5, 7.93, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102000133; 320 CDI, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '642.910'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'transmission_at', (SELECT id FROM engines WHERE code = '642.910'), 9, 9.51, NULL, 'MB 236.15', 'HaynesPro typeId t_102000133; 320 CDI, -T; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '642.910'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'engine_oil', (SELECT id FROM engines WHERE code = '112.946'), 8, 8.45, '0W-30', 'MB 229.5', 'HaynesPro typeId t_65880; 320, -T, -Coupe, -LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '112.946'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'coolant', (SELECT id FROM engines WHERE code = '112.946'), 10.5, 11.1, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_65880; 320, -T, -Coupe, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '112.946'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'transmission_at', (SELECT id FROM engines WHERE code = '112.946'), 8, 8.45, NULL, 'MB 236.14', 'HaynesPro typeId t_65880; 320, -T, -Coupe, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '112.946'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'engine_oil', (SELECT id FROM engines WHERE code = '272.970'), 8, 8.45, '0W-30', 'MB 229.5', 'HaynesPro typeId t_65970; 350 4MATIC, -T, -LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '272.970'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'coolant', (SELECT id FROM engines WHERE code = '272.970'), 7.5, 7.93, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_65970; 350 4MATIC, -T, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '272.970'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'transmission_at', (SELECT id FROM engines WHERE code = '272.970'), 9, 9.51, NULL, 'MB 236.14', 'HaynesPro typeId t_65970; 350 4MATIC, -T, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '272.970'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'engine_oil', (SELECT id FROM engines WHERE code = '272.960'), 8, 8.45, '0W-30', 'MB 229.5', 'HaynesPro typeId t_65810; 350, -T, -Coupe; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '272.960'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'coolant', (SELECT id FROM engines WHERE code = '272.960'), 7.5, 7.93, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_65810; 350, -T, -Coupe'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '272.960'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'transmission_mt', (SELECT id FROM engines WHERE code = '272.960'), 1.5, 1.59, NULL, 'SAE 75W-80', 'HaynesPro typeId t_65810; 350, -T, -Coupe; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '272.960'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'engine_oil', (SELECT id FROM engines WHERE code = '113.988'), 8.5, 8.98, '0W-40', 'MB 229.5', 'HaynesPro typeId t_66000; 55 AMG, -T, -LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '113.988'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'coolant', (SELECT id FROM engines WHERE code = '113.988'), 11.5, 12.15, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_66000; 55 AMG, -T, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '113.988'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'transmission_at', (SELECT id FROM engines WHERE code = '113.988'), NULL, NULL, NULL, 'MB 236.14', 'HaynesPro typeId t_66000; 55 AMG, -T, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '113.988'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 302, 'brake_fluid', NULL, NULL, NULL, NULL, 'DOT 4+', 'HaynesPro chassis d_3610;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 302 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (302)
  AND e.code IN ('271.921', '271.946', '111.951', '646.962', '611.962', '646.963', '271.942', '271.940', '111.955', '111.981', '271.948', '272.920', '112.916', '112.912', '612.962', '272.941', '272.940', '612.990', '112.961', '112.953', '642.910', '112.946', '272.970', '272.960', '113.988')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (302)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (302) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;