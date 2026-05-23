-- mig 325 — multi-gen HaynesPro ingest: Mercedes-Benz C (W204)
-- crawl: haynespro-crawl-mb-c-w204-2026-05-23.json
-- modelId: d_3600
-- 25 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Mercedes-Benz C (W204)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_3600', NOW(), 'Multi-gen ingest, 25 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_3600' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('274.910', '180 BlueEFF, -LPG (274.910) 115kW', 1595, 'petrol', 'NA', NULL),
  ('651.913', '180 CDI BlueEFF, -T (651.913) 88kW', 2143, 'petrol', 'NA', NULL),
  ('271.820', '180 CGi, -T, -Coupe, -LPG (271.820) 115kW', 1796, 'petrol', 'NA', NULL),
  ('271.910', '180 Kompressor BlueEFF, -T, -LPG (271.910) 115kW', 1597, 'petrol', 'NA', NULL),
  ('271.952', '180 Kompressor, -T, -LPG (271.952) 115kW', 1796, 'petrol', 'NA', NULL),
  ('646.812', '200 CDI BlueEFF (646.812) 100kW', 2148, 'petrol', 'NA', NULL),
  ('646.811', '200 CDI, -T (646.811) 100kW', 2148, 'petrol', 'NA', NULL),
  ('271.860', '200 CGi, -T (271.860) 135kW', 1796, 'petrol', 'NA', NULL),
  ('271.950', '200 Kompressor, -T, -LPG (271.950) 135kW', 1796, 'petrol', 'NA', NULL),
  ('651.912', '220 CDI 4MATIC (651.912) 125kW', 2143, 'petrol', 'NA', NULL),
  ('651.911', '220 CDI BlueEFF, -T, -Coupe (651.911) 125kW', 2143, 'petrol', 'NA', NULL),
  ('272.921', '230, -T, -LPG (272.921) 150kW', 2496, 'petrol', 'NA', NULL),
  ('272.911', '230, 250 4MATIC (272.911) 150kW', 2496, 'petrol', 'NA', NULL),
  ('272.948', '280 4MATIC (272.948) 170kW', 2996, 'petrol', 'NA', NULL),
  ('272.947', '280, -T, -LPG (272.947) 170kW', 2996, 'petrol', 'NA', NULL),
  ('642.832', '300 CDI 4MATIC, -T (642.832) 170kW', 2987, 'petrol', 'NA', NULL),
  ('276.957', '300, -4MATIC (276.957) 185kW', 3498, 'petrol', 'NA', NULL),
  ('642.961', '320 CDI 4MATIC, -T (642.961) 165kW', 2987, 'petrol', 'NA', NULL),
  ('642.960', '320 CDI, -T (642.960) 165kW', 2987, 'petrol', 'NA', NULL),
  ('272.971', '350 4MATIC (272.971) 200kW', 3498, 'petrol', 'NA', NULL),
  ('642.830', '350 CDI, -T (642.830) 170kW', 2987, 'petrol', 'NA', NULL),
  ('642.834', '350 CDI, -T (642.834) 195kW', 2987, 'petrol', 'NA', NULL),
  ('272.982', '350 CGI, -T (272.982) 215kW', 3498, 'petrol', 'NA', NULL),
  ('272.961', '350, -T, -LPG (272.961) 200kW', 3498, 'petrol', 'NA', NULL),
  ('156.985', '63 AMG "Black Series" (156.985) 380kW', 6208, 'petrol', 'NA', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'engine_oil', (SELECT id FROM engines WHERE code = '274.910'), 6.1, 6.45, '0W-30', 'MB 229.6', 'HaynesPro typeId t_301000028; 180 BlueEFF, -LPG; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '274.910'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'coolant', (SELECT id FROM engines WHERE code = '274.910'), 8.5, 8.98, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_301000028; 180 BlueEFF, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '274.910'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'transmission_mt', (SELECT id FROM engines WHERE code = '274.910'), 1.2, 1.27, NULL, 'SAE 75W-75', 'HaynesPro typeId t_301000028; 180 BlueEFF, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '274.910'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'engine_oil', (SELECT id FROM engines WHERE code = '651.913'), 6.5, 6.87, '0W-30', 'MB 229.31', 'HaynesPro typeId t_102001464; 180 CDI BlueEFF, -T; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '651.913'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'coolant', (SELECT id FROM engines WHERE code = '651.913'), 10, 10.57, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_102001464; 180 CDI BlueEFF, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '651.913'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'transmission_mt', (SELECT id FROM engines WHERE code = '651.913'), 1.5, 1.59, NULL, 'SAE 75W-80', 'HaynesPro typeId t_102001464; 180 CDI BlueEFF, -T; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '651.913'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'engine_oil', (SELECT id FROM engines WHERE code = '271.820'), 5.5, 5.81, '0W-30', 'MB 229.5', 'HaynesPro typeId t_102001486; 180 CGi, -T, -Coupe, -LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '271.820'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'coolant', (SELECT id FROM engines WHERE code = '271.820'), 7.5, 7.93, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_102001486; 180 CGi, -T, -Coupe, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '271.820'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'transmission_mt', (SELECT id FROM engines WHERE code = '271.820'), 1.2, 1.27, NULL, 'SAE 75W-75', 'HaynesPro typeId t_102001486; 180 CGi, -T, -Coupe, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '271.820'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'engine_oil', (SELECT id FROM engines WHERE code = '271.910'), 5.5, 5.81, '0W-30', 'MB 229.5', 'HaynesPro typeId t_102000140; 180 Kompressor BlueEFF, -T, -LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '271.910'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'coolant', (SELECT id FROM engines WHERE code = '271.910'), 5.6, 5.92, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_102000140; 180 Kompressor BlueEFF, -T, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '271.910'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'transmission_mt', (SELECT id FROM engines WHERE code = '271.910'), 1.2, 1.27, NULL, 'SAE 75W-75', 'HaynesPro typeId t_102000140; 180 Kompressor BlueEFF, -T, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '271.910'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'engine_oil', (SELECT id FROM engines WHERE code = '271.952'), 5.5, 5.81, '0W-30', 'MB 229.5', 'HaynesPro typeId t_110000143; 180 Kompressor, -T, -LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '271.952'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'coolant', (SELECT id FROM engines WHERE code = '271.952'), 5.6, 5.92, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_110000143; 180 Kompressor, -T, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '271.952'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'transmission_mt', (SELECT id FROM engines WHERE code = '271.952'), 1.2, 1.27, NULL, 'SAE 75W-75', 'HaynesPro typeId t_110000143; 180 Kompressor, -T, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '271.952'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'coolant', (SELECT id FROM engines WHERE code = '646.812'), 6, 6.34, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_102000139; 200 CDI BlueEFF'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '646.812'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'transmission_mt', (SELECT id FROM engines WHERE code = '646.812'), 1.2, 1.27, NULL, 'SAE 75W-75', 'HaynesPro typeId t_102000139; 200 CDI BlueEFF; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '646.812'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'engine_oil', (SELECT id FROM engines WHERE code = '646.811'), 6.5, 6.87, '0W-30', 'MB 229.52', 'HaynesPro typeId t_110000144; 200 CDI, -T; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '646.811'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'coolant', (SELECT id FROM engines WHERE code = '646.811'), 6, 6.34, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_110000144; 200 CDI, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '646.811'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'transmission_mt', (SELECT id FROM engines WHERE code = '646.811'), 1.2, 1.27, NULL, 'SAE 75W-80', 'HaynesPro typeId t_110000144; 200 CDI, -T; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '646.811'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'engine_oil', (SELECT id FROM engines WHERE code = '271.860'), 5.5, 5.81, '0W-30', 'MB 229.5', 'HaynesPro typeId t_102001484; 200 CGi, -T; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '271.860'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'coolant', (SELECT id FROM engines WHERE code = '271.860'), 7.5, 7.93, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_102001484; 200 CGi, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '271.860'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'transmission_mt', (SELECT id FROM engines WHERE code = '271.860'), 1.5, 1.59, NULL, 'SAE 75W-80', 'HaynesPro typeId t_102001484; 200 CGi, -T; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '271.860'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'engine_oil', (SELECT id FROM engines WHERE code = '271.950'), 5.5, 5.81, '0W-30', 'MB 229.5', 'HaynesPro typeId t_63660; 200 Kompressor, -T, -LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '271.950'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'coolant', (SELECT id FROM engines WHERE code = '271.950'), 5.6, 5.92, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_63660; 200 Kompressor, -T, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '271.950'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'transmission_mt', (SELECT id FROM engines WHERE code = '271.950'), 1.2, 1.27, NULL, 'SAE 75W-75', 'HaynesPro typeId t_63660; 200 Kompressor, -T, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '271.950'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'engine_oil', (SELECT id FROM engines WHERE code = '651.912'), 6.5, 6.87, '0W-30', 'MB 229.31', 'HaynesPro typeId t_302000004; 220 CDI 4MATIC; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '651.912'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'coolant', (SELECT id FROM engines WHERE code = '651.912'), 10, 10.57, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_302000004; 220 CDI 4MATIC'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '651.912'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'transmission_mt', (SELECT id FROM engines WHERE code = '651.912'), 1.5, 1.59, NULL, 'SAE 75W-80', 'HaynesPro typeId t_302000004; 220 CDI 4MATIC; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '651.912'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'engine_oil', (SELECT id FROM engines WHERE code = '651.911'), 6.5, 6.87, '0W-30', 'MB 229.31', 'HaynesPro typeId t_102001478; 220 CDI BlueEFF, -T, -Coupe; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '651.911'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'coolant', (SELECT id FROM engines WHERE code = '651.911'), 10, 10.57, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_102001478; 220 CDI BlueEFF, -T, -Coupe'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '651.911'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'transmission_mt', (SELECT id FROM engines WHERE code = '651.911'), 1.5, 1.59, NULL, 'SAE 75W-80', 'HaynesPro typeId t_102001478; 220 CDI BlueEFF, -T, -Coupe; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '651.911'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'engine_oil', (SELECT id FROM engines WHERE code = '272.921'), 8, 8.45, '0W-30', 'MB 229.5', 'HaynesPro typeId t_63720; 230, -T, -LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '272.921'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'coolant', (SELECT id FROM engines WHERE code = '272.921'), 5, 5.28, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_63720; 230, -T, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '272.921'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'transmission_mt', (SELECT id FROM engines WHERE code = '272.921'), 1.2, 1.27, NULL, 'SAE 75W-75', 'HaynesPro typeId t_63720; 230, -T, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '272.921'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'engine_oil', (SELECT id FROM engines WHERE code = '272.911'), 7, 7.4, '0W-30', 'MB 229.5', 'HaynesPro typeId t_102000144; 230, 250 4MATIC; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '272.911'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'coolant', (SELECT id FROM engines WHERE code = '272.911'), 5, 5.28, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_102000144; 230, 250 4MATIC'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '272.911'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'transmission_mt', (SELECT id FROM engines WHERE code = '272.911'), 1.2, 1.27, NULL, 'SAE 75W-75', 'HaynesPro typeId t_102000144; 230, 250 4MATIC; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '272.911'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'engine_oil', (SELECT id FROM engines WHERE code = '272.948'), 7, 7.4, '0W-30', 'MB 229.5', 'HaynesPro typeId t_102000141; 280 4MATIC; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '272.948'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'coolant', (SELECT id FROM engines WHERE code = '272.948'), 5, 5.28, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_102000141; 280 4MATIC'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '272.948'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'transmission_at', (SELECT id FROM engines WHERE code = '272.948'), 9.7, 10.25, NULL, 'MB 236.15', 'HaynesPro typeId t_102000141; 280 4MATIC; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '272.948'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'engine_oil', (SELECT id FROM engines WHERE code = '272.947'), 8, 8.45, '0W-30', 'MB 229.5', 'HaynesPro typeId t_63750; 280, -T, -LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '272.947'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'coolant', (SELECT id FROM engines WHERE code = '272.947'), 5, 5.28, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_63750; 280, -T, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '272.947'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'transmission_mt', (SELECT id FROM engines WHERE code = '272.947'), 1.5, 1.59, NULL, 'SAE 75W-80', 'HaynesPro typeId t_63750; 280, -T, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '272.947'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'engine_oil', (SELECT id FROM engines WHERE code = '642.832'), 8, 8.45, '0W-30', 'MB 229.52', 'HaynesPro typeId t_319000287; 300 CDI 4MATIC, -T; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '642.832'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'coolant', (SELECT id FROM engines WHERE code = '642.832'), 12, 12.68, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_319000287; 300 CDI 4MATIC, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '642.832'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'transmission_at', (SELECT id FROM engines WHERE code = '642.832'), 9.7, 10.25, NULL, 'MB 236.15', 'HaynesPro typeId t_319000287; 300 CDI 4MATIC, -T; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '642.832'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'engine_oil', (SELECT id FROM engines WHERE code = '276.957'), 6.5, 6.87, '0W-30', 'MB 229.6', 'HaynesPro typeId t_200000016; 300, -4MATIC; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '276.957'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'coolant', (SELECT id FROM engines WHERE code = '276.957'), 9, 9.51, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_200000016; 300, -4MATIC'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '276.957'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'transmission_at', (SELECT id FROM engines WHERE code = '276.957'), 9, 9.51, NULL, 'MB 236.15', 'HaynesPro typeId t_200000016; 300, -4MATIC; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '276.957'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'engine_oil', (SELECT id FROM engines WHERE code = '642.961'), 8, 8.45, '0W-30', 'MB 229.52', 'HaynesPro typeId t_102000143; 320 CDI 4MATIC, -T; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '642.961'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'coolant', (SELECT id FROM engines WHERE code = '642.961'), 12, 12.68, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_102000143; 320 CDI 4MATIC, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '642.961'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'transmission_at', (SELECT id FROM engines WHERE code = '642.961'), 9.7, 10.25, NULL, 'MB 236.15', 'HaynesPro typeId t_102000143; 320 CDI 4MATIC, -T; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '642.961'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'engine_oil', (SELECT id FROM engines WHERE code = '642.960'), 8, 8.45, '0W-30', 'MB 229.52', 'HaynesPro typeId t_63780; 320 CDI, -T; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '642.960'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'coolant', (SELECT id FROM engines WHERE code = '642.960'), 12, 12.68, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_63780; 320 CDI, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '642.960'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'transmission_mt', (SELECT id FROM engines WHERE code = '642.960'), 1.8, 1.9, NULL, 'SAE 75W-75', 'HaynesPro typeId t_63780; 320 CDI, -T; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '642.960'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'engine_oil', (SELECT id FROM engines WHERE code = '272.971'), 7, 7.4, '0W-30', 'MB 229.5', 'HaynesPro typeId t_102000142; 350 4MATIC; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '272.971'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'coolant', (SELECT id FROM engines WHERE code = '272.971'), 5, 5.28, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_102000142; 350 4MATIC'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '272.971'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'transmission_at', (SELECT id FROM engines WHERE code = '272.971'), 9.7, 10.25, NULL, 'MB 236.15', 'HaynesPro typeId t_102000142; 350 4MATIC; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '272.971'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'engine_oil', (SELECT id FROM engines WHERE code = '642.830'), 8, 8.45, '0W-30', 'MB 229.52', 'HaynesPro typeId t_102001483; 350 CDI, -T; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '642.830'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'coolant', (SELECT id FROM engines WHERE code = '642.830'), 12, 12.68, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_102001483; 350 CDI, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '642.830'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'transmission_mt', (SELECT id FROM engines WHERE code = '642.830'), 1.8, 1.9, NULL, 'SAE 75W-75', 'HaynesPro typeId t_102001483; 350 CDI, -T; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '642.830'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'engine_oil', (SELECT id FROM engines WHERE code = '642.834'), 8, 8.45, '0W-30', 'MB 229.52', 'HaynesPro typeId t_200000014; 350 CDI, -T; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '642.834'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'coolant', (SELECT id FROM engines WHERE code = '642.834'), 12, 12.68, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_200000014; 350 CDI, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '642.834'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'transmission_mt', (SELECT id FROM engines WHERE code = '642.834'), 1.8, 1.9, NULL, 'SAE 75W-75', 'HaynesPro typeId t_200000014; 350 CDI, -T; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '642.834'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'engine_oil', (SELECT id FROM engines WHERE code = '272.982'), 8, 8.45, '0W-30', 'MB 229.5', 'HaynesPro typeId t_102000170; 350 CGI, -T; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '272.982'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'coolant', (SELECT id FROM engines WHERE code = '272.982'), 5, 5.28, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_102000170; 350 CGI, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '272.982'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'transmission_at', (SELECT id FROM engines WHERE code = '272.982'), 9, 9.51, NULL, 'MB 236.15', 'HaynesPro typeId t_102000170; 350 CGI, -T; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '272.982'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'engine_oil', (SELECT id FROM engines WHERE code = '272.961'), 8, 8.45, '0W-30', 'MB 229.5', 'HaynesPro typeId t_63790; 350, -T, -LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '272.961'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'coolant', (SELECT id FROM engines WHERE code = '272.961'), 5, 5.28, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_63790; 350, -T, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '272.961'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'transmission_at', (SELECT id FROM engines WHERE code = '272.961'), 9, 9.51, NULL, 'MB 236.15', 'HaynesPro typeId t_63790; 350, -T, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '272.961'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'engine_oil', (SELECT id FROM engines WHERE code = '156.985'), 8.5, 8.98, '0W-40', 'MB 229.51', 'HaynesPro typeId t_301000195; 63 AMG "Black Series"; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '156.985'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'coolant', (SELECT id FROM engines WHERE code = '156.985'), 10.7, 11.31, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_301000195; 63 AMG "Black Series"'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '156.985'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'transmission_at', (SELECT id FROM engines WHERE code = '156.985'), 9, 9.51, NULL, 'MB 236.15', 'HaynesPro typeId t_301000195; 63 AMG "Black Series"; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '156.985'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 303, 'brake_fluid', NULL, 0.5, 0.53, NULL, 'DOT 4+', 'HaynesPro chassis d_3600;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 303 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (303)
  AND e.code IN ('274.910', '651.913', '271.820', '271.910', '271.952', '646.812', '646.811', '271.860', '271.950', '651.912', '651.911', '272.921', '272.911', '272.948', '272.947', '642.832', '276.957', '642.961', '642.960', '272.971', '642.830', '642.834', '272.982', '272.961', '156.985')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (303)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (303) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;