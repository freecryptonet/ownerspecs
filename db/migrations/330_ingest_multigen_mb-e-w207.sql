-- mig 330 — multi-gen HaynesPro ingest: Mercedes-Benz E Coupe/Cabrio (W207)
-- crawl: haynespro-crawl-mb-e-w207-2026-05-23.json
-- modelId: d_102000173
-- 15 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Mercedes-Benz E Coupe/Cabrio (W207)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_102000173', NOW(), 'Multi-gen ingest, 15 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_102000173' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('274.920', '200 CGi BlueEFF (274.920) 135kW', 1991, 'petrol', 'NA', NULL),
  ('271.860', '200 CGi, -LPG (271.860) 135kW', 1796, 'petrol', 'NA', NULL),
  ('651.911', '220 BlueTEC (651.911) 125kW', 2143, 'diesel', 'NA', NULL),
  ('276.957', '300 BlueEFF (276.957) 185kW', 3498, 'petrol', 'NA', NULL),
  ('276.820', '320 (276.820) 200kW', 2996, 'petrol', 'NA', NULL),
  ('272.961', '350 (272.961) 200kW', 3498, 'petrol', 'NA', NULL),
  ('272.988', '350 (272.988) 200kW', 3498, 'petrol', 'NA', NULL),
  ('642.838', '350 BlueTEC (642.838) 185kW', 2987, 'diesel', 'NA', NULL),
  ('642.836', '350 CDI (642.836) 170kW', 2987, 'petrol', 'NA', NULL),
  ('276.953', '350 CGI BlueEFF (276.953) 170kW', 2996, 'petrol', 'NA', NULL),
  ('272.982', '350 CGi (272.982) 215kW', 3498, 'petrol', 'NA', NULL),
  ('272.984', '350 CGi (272.984) 215kW', 3498, 'petrol', 'NA', NULL),
  ('276.850', '400 BlueEFF (276.850) 245kW', 3498, 'petrol', 'NA', NULL),
  ('273.966', '500/550 (273.966) 285kW', 5461, 'petrol', 'NA', NULL),
  ('278.922', '500/550 (278.922) 300kW', 4663, 'petrol', 'NA', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'engine_oil', (SELECT id FROM engines WHERE code = '274.920'), 6.3, 6.66, '0W-30', 'MB 229.6', 'HaynesPro typeId t_301000581; 200 CGi BlueEFF; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '274.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'coolant', (SELECT id FROM engines WHERE code = '274.920'), 8, 8.45, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_301000581; 200 CGi BlueEFF'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '274.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'transmission_mt', (SELECT id FROM engines WHERE code = '274.920'), 1.2, 1.27, NULL, 'SAE 75W-75', 'HaynesPro typeId t_301000581; 200 CGi BlueEFF; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '274.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'engine_oil', (SELECT id FROM engines WHERE code = '271.860'), 5.5, 5.81, '0W-30', 'MB 229.5', 'HaynesPro typeId t_102001670; 200 CGi, -LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '271.860'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'coolant', (SELECT id FROM engines WHERE code = '271.860'), 7.5, 7.93, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001670; 200 CGi, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '271.860'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'transmission_mt', (SELECT id FROM engines WHERE code = '271.860'), 1.5, 1.59, NULL, 'SAE 75W-80', 'HaynesPro typeId t_102001670; 200 CGi, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '271.860'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'engine_oil', (SELECT id FROM engines WHERE code = '651.911'), 6.5, 6.87, '0W-30', 'MB 229.52', 'HaynesPro typeId t_311000124; 220 BlueTEC; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '651.911'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'coolant', (SELECT id FROM engines WHERE code = '651.911'), 10, 10.57, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_311000124; 220 BlueTEC'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '651.911'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'transmission_mt', (SELECT id FROM engines WHERE code = '651.911'), 1.5, 1.59, NULL, 'SAE 75W-80', 'HaynesPro typeId t_311000124; 220 BlueTEC; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '651.911'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'engine_oil', (SELECT id FROM engines WHERE code = '276.957'), 6.5, 6.87, '0W-30', 'MB 229.6', 'HaynesPro typeId t_200000021; 300 BlueEFF; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '276.957'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'coolant', (SELECT id FROM engines WHERE code = '276.957'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_200000021; 300 BlueEFF'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '276.957'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'transmission_at', (SELECT id FROM engines WHERE code = '276.957'), 9, 9.51, NULL, 'MB 236.15', 'HaynesPro typeId t_200000021; 300 BlueEFF; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '276.957'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'engine_oil', (SELECT id FROM engines WHERE code = '276.820'), 6.5, 6.87, '0W-30', 'MB 229.6', 'HaynesPro typeId t_305000657; 320; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '276.820'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'coolant', (SELECT id FROM engines WHERE code = '276.820'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_305000657; 320'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '276.820'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'transmission_at', (SELECT id FROM engines WHERE code = '276.820'), 9, 9.51, NULL, 'MB 236.15', 'HaynesPro typeId t_305000657; 320; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '276.820'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'engine_oil', (SELECT id FROM engines WHERE code = '272.961'), 8, 8.45, '0W-30', 'MB 229.5', 'HaynesPro typeId t_102001675; 350; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '272.961'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'coolant', (SELECT id FROM engines WHERE code = '272.961'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001675; 350'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '272.961'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'transmission_at', (SELECT id FROM engines WHERE code = '272.961'), 9, 9.51, NULL, 'MB 236.15', 'HaynesPro typeId t_102001675; 350; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '272.961'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'engine_oil', (SELECT id FROM engines WHERE code = '272.988'), 8, 8.45, '0W-30', 'MB 229.5', 'HaynesPro typeId t_102001674; 350; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '272.988'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'coolant', (SELECT id FROM engines WHERE code = '272.988'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001674; 350'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '272.988'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'transmission_at', (SELECT id FROM engines WHERE code = '272.988'), 9, 9.51, NULL, 'MB 236.15', 'HaynesPro typeId t_102001674; 350; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '272.988'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'engine_oil', (SELECT id FROM engines WHERE code = '642.838'), 8, 8.45, '0W-30', 'MB 229.52', 'HaynesPro typeId t_301000579; 350 BlueTEC; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '642.838'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'coolant', (SELECT id FROM engines WHERE code = '642.838'), 10.8, 11.41, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_301000579; 350 BlueTEC'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '642.838'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'transmission_at', (SELECT id FROM engines WHERE code = '642.838'), NULL, NULL, NULL, 'MB 236.15', 'HaynesPro typeId t_301000579; 350 BlueTEC; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '642.838'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'engine_oil', (SELECT id FROM engines WHERE code = '642.836'), 8, 8.45, '0W-30', 'MB 229.52', 'HaynesPro typeId t_102001669; 350 CDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '642.836'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'coolant', (SELECT id FROM engines WHERE code = '642.836'), 10.8, 11.41, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001669; 350 CDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '642.836'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'transmission_at', (SELECT id FROM engines WHERE code = '642.836'), 9, 9.51, NULL, 'MB 236.15', 'HaynesPro typeId t_102001669; 350 CDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '642.836'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'engine_oil', (SELECT id FROM engines WHERE code = '276.953'), 6.5, 6.87, '0W-30', 'MB 229.6', 'HaynesPro typeId t_200000022; 350 CGI BlueEFF; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '276.953'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'coolant', (SELECT id FROM engines WHERE code = '276.953'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_200000022; 350 CGI BlueEFF'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '276.953'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'transmission_at', (SELECT id FROM engines WHERE code = '276.953'), 9, 9.51, NULL, 'MB 236.15', 'HaynesPro typeId t_200000022; 350 CGI BlueEFF; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '276.953'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'engine_oil', (SELECT id FROM engines WHERE code = '272.982'), 8, 8.45, '0W-30', 'MB 229.5', 'HaynesPro typeId t_102001676; 350 CGi; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '272.982'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'coolant', (SELECT id FROM engines WHERE code = '272.982'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001676; 350 CGi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '272.982'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'transmission_at', (SELECT id FROM engines WHERE code = '272.982'), 9, 9.51, NULL, 'MB 236.15', 'HaynesPro typeId t_102001676; 350 CGi; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '272.982'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'engine_oil', (SELECT id FROM engines WHERE code = '272.984'), 8, 8.45, '0W-30', 'MB 229.5', 'HaynesPro typeId t_102001672; 350 CGi; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '272.984'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'coolant', (SELECT id FROM engines WHERE code = '272.984'), 8, 8.45, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001672; 350 CGi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '272.984'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'transmission_at', (SELECT id FROM engines WHERE code = '272.984'), 9, 9.51, NULL, 'MB 236.15', 'HaynesPro typeId t_102001672; 350 CGi; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '272.984'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'engine_oil', (SELECT id FROM engines WHERE code = '276.850'), 6.5, 6.87, '0W-30', 'MB 229.6', 'HaynesPro typeId t_305000656; 400 BlueEFF; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '276.850'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'coolant', (SELECT id FROM engines WHERE code = '276.850'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_305000656; 400 BlueEFF'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '276.850'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'transmission_at', (SELECT id FROM engines WHERE code = '276.850'), 9, 9.51, NULL, 'MB 236.15', 'HaynesPro typeId t_305000656; 400 BlueEFF; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '276.850'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'engine_oil', (SELECT id FROM engines WHERE code = '273.966'), 8.5, 8.98, '0W-30', 'MB 229.5', 'HaynesPro typeId t_102001673; 500/550; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '273.966'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'coolant', (SELECT id FROM engines WHERE code = '273.966'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001673; 500/550'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '273.966'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'transmission_at', (SELECT id FROM engines WHERE code = '273.966'), 9, 9.51, NULL, 'MB 236.15', 'HaynesPro typeId t_102001673; 500/550; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '273.966'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'engine_oil', (SELECT id FROM engines WHERE code = '278.922'), 8, 8.45, '0W-30', 'MB 229.5', 'HaynesPro typeId t_200000023; 500/550; drain 20 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '278.922'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'coolant', (SELECT id FROM engines WHERE code = '278.922'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_200000023; 500/550'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '278.922'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'transmission_at', (SELECT id FROM engines WHERE code = '278.922'), 9, 9.51, NULL, 'SAE 75W-85', 'HaynesPro typeId t_200000023; 500/550; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '278.922'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 309, 'brake_fluid', NULL, 0.5, 0.53, NULL, 'DOT 4+', 'HaynesPro chassis d_102000173;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 309 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (309)
  AND e.code IN ('274.920', '271.860', '651.911', '276.957', '276.820', '272.961', '272.988', '642.838', '642.836', '276.953', '272.982', '272.984', '276.850', '273.966', '278.922')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (309)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (309) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;