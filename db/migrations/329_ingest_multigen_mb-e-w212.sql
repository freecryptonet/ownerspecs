-- mig 329 — multi-gen HaynesPro ingest: Mercedes-Benz E (W212)
-- crawl: haynespro-crawl-mb-e-w212-2026-05-23.json
-- modelId: d_102000087
-- 23 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Mercedes-Benz E (W212)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_102000087', NOW(), 'Multi-gen ingest, 23 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_102000087' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('274.910', '180 (274.910) 115kW', 1595, 'petrol', 'NA', NULL),
  ('651.924', '200 BlueTEC (651.924) 100kW', 2143, 'diesel', 'NA', NULL),
  ('651.925', '200 CDI BlueEFF, BlueTEC, -T (651.925) 100kW', 2143, 'diesel', 'NA', NULL),
  ('271.860', '200 CGI BlueEFF, -T, -L (271.860) 135kW', 1796, 'petrol', 'NA', NULL),
  ('274.920', '200 CGi, -LPG (274.920) 135kW', 1991, 'petrol', 'NA', NULL),
  ('271.958', '200 NGT BlueEFF (271.958) 120kW', 1796, 'petrol', 'NA', NULL),
  ('272.923', '250 BlueEFF (272.923) 150kW', 2496, 'petrol', 'NA', NULL),
  ('272.980', '300 BlueEFF (272.980) 185kW', 3498, 'petrol', 'NA', NULL),
  ('276.952', '300 BlueEFF, -4MATIC, -T (276.952) 185kW', 3498, 'petrol', 'NA', NULL),
  ('272.952', '300 BlueEFF, -T (272.952) 170kW', 2996, 'petrol', 'NA', NULL),
  ('642.852', '300 BlueTEC, -T (642.852) 170kW', 2987, 'diesel', 'NA', NULL),
  ('642.850', '300 CDI BlueEFF (642.850) 170kW', 2987, 'petrol', 'NA', NULL),
  ('272.977', '350 4MATIC, -T, -LPG (272.977) 200kW', 3498, 'petrol', 'NA', NULL),
  ('642.858', '350 BlueTEC 4MATIC, -T (642.858) 185kW', 2987, 'diesel', 'NA', NULL),
  ('642.856', '350 CDI 4MATIC, -T (642.856) 170kW', 2987, 'petrol', 'NA', NULL),
  ('272.983', '350 CGI BlueEFF, -T, -LPG (272.983) 215kW', 3498, 'petrol', 'NA', NULL),
  ('276.820', '400, -4MATIC, -T (276.820) 245kW', 2996, 'petrol', 'NA', NULL),
  ('276.850', '400, -4MATIC, -T (276.850) 245kW', 3498, 'petrol', 'NA', NULL),
  ('273.970', '500/550 4MATIC (273.970) 285kW', 5461, 'petrol', 'NA', NULL),
  ('278.922', '500/550, -4MATIC, -T (278.922) 300kW', 4663, 'petrol', 'NA', NULL),
  ('273.971', '500/550, -T (273.971) 285kW', 5461, 'petrol', 'NA', NULL),
  ('156.985', '63 AMG (156.985) 410kW', 6208, 'petrol', 'NA', NULL),
  ('157.981', '63 AMG, -T (157.981) 410kW', 5461, 'petrol', 'NA', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'engine_oil', (SELECT id FROM engines WHERE code = '274.910'), 6.1, 6.45, '0W-30', 'MB 229.6', 'HaynesPro typeId t_619029403; 180; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '274.910'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'coolant', (SELECT id FROM engines WHERE code = '274.910'), 8.5, 8.98, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_619029403; 180'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '274.910'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'transmission_at', (SELECT id FROM engines WHERE code = '274.910'), 9, 9.51, NULL, 'MB 236.15', 'HaynesPro typeId t_619029403; 180; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '274.910'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'engine_oil', (SELECT id FROM engines WHERE code = '651.924'), 6.5, 6.87, '0W-30', 'MB 229.52', 'HaynesPro typeId t_311000126; 200 BlueTEC; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '651.924'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'coolant', (SELECT id FROM engines WHERE code = '651.924'), 10, 10.57, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_311000126; 200 BlueTEC'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '651.924'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'transmission_mt', (SELECT id FROM engines WHERE code = '651.924'), 1.5, 1.59, NULL, 'SAE 75W-80', 'HaynesPro typeId t_311000126; 200 BlueTEC; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '651.924'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'engine_oil', (SELECT id FROM engines WHERE code = '651.925'), 6.5, 6.87, '0W-30', 'MB 229.52', 'HaynesPro typeId t_102001560; 200 CDI BlueEFF, BlueTEC, -T; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '651.925'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'coolant', (SELECT id FROM engines WHERE code = '651.925'), 10, 10.57, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_102001560; 200 CDI BlueEFF, BlueTEC, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '651.925'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'transmission_mt', (SELECT id FROM engines WHERE code = '651.925'), 1.5, 1.59, NULL, 'SAE 75W-80', 'HaynesPro typeId t_102001560; 200 CDI BlueEFF, BlueTEC, -T; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '651.925'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'engine_oil', (SELECT id FROM engines WHERE code = '271.860'), 5.5, 5.81, '0W-30', 'MB 229.5', 'HaynesPro typeId t_102001562; 200 CGI BlueEFF, -T, -L; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '271.860'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'coolant', (SELECT id FROM engines WHERE code = '271.860'), 7.5, 7.93, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_102001562; 200 CGI BlueEFF, -T, -L'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '271.860'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'transmission_mt', (SELECT id FROM engines WHERE code = '271.860'), 1.2, 1.27, NULL, 'SAE 75W-75', 'HaynesPro typeId t_102001562; 200 CGI BlueEFF, -T, -L; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '271.860'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'engine_oil', (SELECT id FROM engines WHERE code = '274.920'), 6.3, 6.66, '0W-30', 'MB 229.6', 'HaynesPro typeId t_301000584; 200 CGi, -LPG; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '274.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'coolant', (SELECT id FROM engines WHERE code = '274.920'), 8.5, 8.98, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_301000584; 200 CGi, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '274.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'transmission_mt', (SELECT id FROM engines WHERE code = '274.920'), 1.2, 1.27, NULL, 'SAE 75W-75', 'HaynesPro typeId t_301000584; 200 CGi, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '274.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'engine_oil', (SELECT id FROM engines WHERE code = '271.958'), 5.5, 5.81, '0W-30', 'MB 229.5', 'HaynesPro typeId t_102002279; 200 NGT BlueEFF; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '271.958'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'coolant', (SELECT id FROM engines WHERE code = '271.958'), 5.6, 5.92, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_102002279; 200 NGT BlueEFF'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '271.958'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'transmission_at', (SELECT id FROM engines WHERE code = '271.958'), NULL, NULL, NULL, 'MB 236.14', 'HaynesPro typeId t_102002279; 200 NGT BlueEFF; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '271.958'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'engine_oil', (SELECT id FROM engines WHERE code = '272.923'), 8, 8.45, '0W-30', 'MB 229.5', 'HaynesPro typeId t_200000025; 250 BlueEFF; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '272.923'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'coolant', (SELECT id FROM engines WHERE code = '272.923'), NULL, NULL, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_200000025; 250 BlueEFF'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '272.923'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'transmission_mt', (SELECT id FROM engines WHERE code = '272.923'), 1.2, 1.27, NULL, 'SAE 75W-80', 'HaynesPro typeId t_200000025; 250 BlueEFF; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '272.923'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'engine_oil', (SELECT id FROM engines WHERE code = '272.980'), 8, 8.45, '0W-30', 'MB 229.5', 'HaynesPro typeId t_200000026; 300 BlueEFF; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '272.980'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'coolant', (SELECT id FROM engines WHERE code = '272.980'), 7, 7.4, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_200000026; 300 BlueEFF'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '272.980'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'transmission_at', (SELECT id FROM engines WHERE code = '272.980'), 9, 9.51, NULL, 'MB 236.15', 'HaynesPro typeId t_200000026; 300 BlueEFF; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '272.980'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'engine_oil', (SELECT id FROM engines WHERE code = '276.952'), 6.5, 6.87, '0W-30', 'MB 229.6', 'HaynesPro typeId t_200000029; 300 BlueEFF, -4MATIC, -T; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '276.952'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'coolant', (SELECT id FROM engines WHERE code = '276.952'), 9.6, 10.14, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_200000029; 300 BlueEFF, -4MATIC, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '276.952'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'transmission_at', (SELECT id FROM engines WHERE code = '276.952'), 9, 9.51, NULL, 'MB 236.15', 'HaynesPro typeId t_200000029; 300 BlueEFF, -4MATIC, -T; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '276.952'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'engine_oil', (SELECT id FROM engines WHERE code = '272.952'), 8, 8.45, '0W-30', 'MB 229.5', 'HaynesPro typeId t_200000028; 300 BlueEFF, -T; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '272.952'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'coolant', (SELECT id FROM engines WHERE code = '272.952'), 7, 7.4, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_200000028; 300 BlueEFF, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '272.952'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'transmission_mt', (SELECT id FROM engines WHERE code = '272.952'), 1.5, 1.59, NULL, 'SAE 75W-80', 'HaynesPro typeId t_200000028; 300 BlueEFF, -T; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '272.952'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'engine_oil', (SELECT id FROM engines WHERE code = '642.852'), 8, 8.45, '0W-30', 'MB 229.52', 'HaynesPro typeId t_301000596; 300 BlueTEC, -T; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '642.852'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'coolant', (SELECT id FROM engines WHERE code = '642.852'), 10.8, 11.41, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_301000596; 300 BlueTEC, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '642.852'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'transmission_mt', (SELECT id FROM engines WHERE code = '642.852'), 1.8, 1.9, NULL, 'SAE 75W-75', 'HaynesPro typeId t_301000596; 300 BlueTEC, -T; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '642.852'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'engine_oil', (SELECT id FROM engines WHERE code = '642.850'), 8, 8.45, '0W-30', 'MB 229.52', 'HaynesPro typeId t_301000598; 300 CDI BlueEFF; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '642.850'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'coolant', (SELECT id FROM engines WHERE code = '642.850'), 10.8, 11.41, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_301000598; 300 CDI BlueEFF'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '642.850'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'transmission_at', (SELECT id FROM engines WHERE code = '642.850'), 9, 9.51, NULL, 'MB 236.15', 'HaynesPro typeId t_301000598; 300 CDI BlueEFF; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '642.850'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'engine_oil', (SELECT id FROM engines WHERE code = '272.977'), 8, 8.45, '0W-30', 'MB 229.5', 'HaynesPro typeId t_102001571; 350 4MATIC, -T, -LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '272.977'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'coolant', (SELECT id FROM engines WHERE code = '272.977'), 7, 7.4, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_102001571; 350 4MATIC, -T, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '272.977'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'transmission_at', (SELECT id FROM engines WHERE code = '272.977'), 9.7, 10.25, NULL, 'MB 236.15', 'HaynesPro typeId t_102001571; 350 4MATIC, -T, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '272.977'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'engine_oil', (SELECT id FROM engines WHERE code = '642.858'), 8, 8.45, '0W-30', 'MB 229.52', 'HaynesPro typeId t_301000595; 350 BlueTEC 4MATIC, -T; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '642.858'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'coolant', (SELECT id FROM engines WHERE code = '642.858'), 10.8, 11.41, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_301000595; 350 BlueTEC 4MATIC, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '642.858'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'transmission_at', (SELECT id FROM engines WHERE code = '642.858'), 9.7, 10.25, NULL, 'MB 236.15', 'HaynesPro typeId t_301000595; 350 BlueTEC 4MATIC, -T; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '642.858'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'engine_oil', (SELECT id FROM engines WHERE code = '642.856'), 8, 8.45, '0W-30', 'MB 229.52', 'HaynesPro typeId t_102001566; 350 CDI 4MATIC, -T; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '642.856'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'coolant', (SELECT id FROM engines WHERE code = '642.856'), 10.8, 11.41, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_102001566; 350 CDI 4MATIC, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '642.856'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'transmission_mt', (SELECT id FROM engines WHERE code = '642.856'), 1.8, 1.9, NULL, 'SAE 75W-75', 'HaynesPro typeId t_102001566; 350 CDI 4MATIC, -T; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '642.856'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'engine_oil', (SELECT id FROM engines WHERE code = '272.983'), 8, 8.45, '0W-30', 'MB 229.5', 'HaynesPro typeId t_102001555; 350 CGI BlueEFF, -T, -LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '272.983'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'coolant', (SELECT id FROM engines WHERE code = '272.983'), 7, 7.4, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_102001555; 350 CGI BlueEFF, -T, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '272.983'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'transmission_at', (SELECT id FROM engines WHERE code = '272.983'), 9, 9.51, NULL, 'MB 236.15', 'HaynesPro typeId t_102001555; 350 CGI BlueEFF, -T, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '272.983'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'engine_oil', (SELECT id FROM engines WHERE code = '276.820'), 6.5, 6.87, '0W-30', 'MB 229.6', 'HaynesPro typeId t_301000844; 400, -4MATIC, -T; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '276.820'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'coolant', (SELECT id FROM engines WHERE code = '276.820'), NULL, NULL, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_301000844; 400, -4MATIC, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '276.820'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'transmission_at', (SELECT id FROM engines WHERE code = '276.820'), 9, 9.51, NULL, 'MB 236.15', 'HaynesPro typeId t_301000844; 400, -4MATIC, -T; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '276.820'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'engine_oil', (SELECT id FROM engines WHERE code = '276.850'), 6.5, 6.87, '0W-30', 'MB 229.6', 'HaynesPro typeId t_305000655; 400, -4MATIC, -T; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '276.850'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'coolant', (SELECT id FROM engines WHERE code = '276.850'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_305000655; 400, -4MATIC, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '276.850'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'transmission_at', (SELECT id FROM engines WHERE code = '276.850'), 9, 9.51, NULL, 'MB 236.15', 'HaynesPro typeId t_305000655; 400, -4MATIC, -T; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '276.850'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'engine_oil', (SELECT id FROM engines WHERE code = '273.970'), 8.5, 8.98, '0W-30', 'MB 229.5', 'HaynesPro typeId t_102001570; 500/550 4MATIC; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '273.970'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'coolant', (SELECT id FROM engines WHERE code = '273.970'), 7, 7.4, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_102001570; 500/550 4MATIC'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '273.970'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'transmission_at', (SELECT id FROM engines WHERE code = '273.970'), 9.7, 10.25, NULL, 'MB 236.14', 'HaynesPro typeId t_102001570; 500/550 4MATIC; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '273.970'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'engine_oil', (SELECT id FROM engines WHERE code = '278.922'), 8, 8.45, '0W-30', 'MB 229.5', 'HaynesPro typeId t_300000225; 500/550, -4MATIC, -T; drain 20 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '278.922'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'coolant', (SELECT id FROM engines WHERE code = '278.922'), NULL, NULL, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_300000225; 500/550, -4MATIC, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '278.922'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'transmission_at', (SELECT id FROM engines WHERE code = '278.922'), 9, 9.51, NULL, 'MB 236.14', 'HaynesPro typeId t_300000225; 500/550, -4MATIC, -T; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '278.922'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'engine_oil', (SELECT id FROM engines WHERE code = '273.971'), 8.5, 8.98, '0W-30', 'MB 229.5', 'HaynesPro typeId t_102001569; 500/550, -T; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '273.971'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'coolant', (SELECT id FROM engines WHERE code = '273.971'), 7, 7.4, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_102001569; 500/550, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '273.971'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'transmission_at', (SELECT id FROM engines WHERE code = '273.971'), 9, 9.51, NULL, 'MB 236.15', 'HaynesPro typeId t_102001569; 500/550, -T; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '273.971'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'engine_oil', (SELECT id FROM engines WHERE code = '156.985'), 8.8, 9.3, '0W-40', 'MB 229.51', 'HaynesPro typeId t_305000652; 63 AMG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '156.985'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'coolant', (SELECT id FROM engines WHERE code = '156.985'), 10, 10.57, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_305000652; 63 AMG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '156.985'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'transmission_at', (SELECT id FROM engines WHERE code = '156.985'), 7.1, 7.5, NULL, 'MB 236.15', 'HaynesPro typeId t_305000652; 63 AMG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '156.985'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'engine_oil', (SELECT id FROM engines WHERE code = '157.981'), 8.5, 8.98, '0W-40', 'MB 229.5', 'HaynesPro typeId t_301000379; 63 AMG, -T; drain 20 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '157.981'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'coolant', (SELECT id FROM engines WHERE code = '157.981'), NULL, NULL, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_301000379; 63 AMG, -T'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '157.981'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'transmission_at', (SELECT id FROM engines WHERE code = '157.981'), 7.1, 7.5, NULL, 'MB 236.15', 'HaynesPro typeId t_301000379; 63 AMG, -T; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '157.981'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 308, 'brake_fluid', NULL, 0.6, 0.63, NULL, 'MB 331.0', 'HaynesPro chassis d_102000087;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 308 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (308)
  AND e.code IN ('274.910', '651.924', '651.925', '271.860', '274.920', '271.958', '272.923', '272.980', '276.952', '272.952', '642.852', '642.850', '272.977', '642.858', '642.856', '272.983', '276.820', '276.850', '273.970', '278.922', '273.971', '156.985', '157.981')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (308)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (308) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;