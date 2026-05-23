-- mig 278 — multi-gen HaynesPro ingest: BMW 4 (G22, G23, G24, G26, G82, G83)
-- crawl: haynespro-crawl-bmw-4-g22-2026-05-23.json
-- modelId: d_319008746
-- 9 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — BMW 4 (G22, G23, G24, G26, G82, G83)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319008746', NOW(), 'Multi-gen ingest, 9 engines across 5 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319008746' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('B47D20B', '420d mHev, -xDrive (B47D20B) 140kW', 1995, 'hybrid', 'turbo', NULL),
  ('B46B20B', '420i (B46B20B) 135kW', 1998, 'petrol', 'turbo', NULL),
  ('B48B16A', '420i (B48B16A) 125kW', 1597, 'petrol', 'turbo', NULL),
  ('B48B20A', '420i, xDrive (B48B20A) 135kW', 1998, 'petrol', 'turbo', NULL),
  ('B57D30B', '430d mHev, xDrive (B57D30B) 210kW', 2993, 'hybrid', 'turbo', NULL),
  ('B48B20B', '430i, -xDrive (B48B20B) 190kW', 1998, 'petrol', 'turbo', NULL),
  ('S58B30B', 'M4 (S58B30B) 353kW', 2993, 'petrol', 'turbo', NULL),
  ('S58B30A', 'M4 CS (S58B30A) 405kW', 2993, 'petrol', 'turbo', NULL),
  ('B58B30B', 'M440i mHev, -xDrive (B58B30B) 285kW', 2998, 'hybrid', 'turbo', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 225, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47D20B'), 5.5, 5.81, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_619035293; 420d mHev, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 225 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 225, 'coolant', (SELECT id FROM engines WHERE code = 'B47D20B'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619035293; 420d mHev, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 225 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 225, 'transmission_at', (SELECT id FROM engines WHERE code = 'B47D20B'), 9.28, 9.81, NULL, 'BMW DTF1', 'HaynesPro typeId t_619035293; 420d mHev, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 225 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 226, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47D20B'), 5.5, 5.81, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_619035293; 420d mHev, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 226 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 226, 'coolant', (SELECT id FROM engines WHERE code = 'B47D20B'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619035293; 420d mHev, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 226 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 226, 'transmission_at', (SELECT id FROM engines WHERE code = 'B47D20B'), 9.28, 9.81, NULL, 'BMW DTF1', 'HaynesPro typeId t_619035293; 420d mHev, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 226 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 227, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47D20B'), 5.5, 5.81, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_619035293; 420d mHev, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 227 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 227, 'coolant', (SELECT id FROM engines WHERE code = 'B47D20B'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619035293; 420d mHev, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 227 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 227, 'transmission_at', (SELECT id FROM engines WHERE code = 'B47D20B'), 9.28, 9.81, NULL, 'BMW DTF1', 'HaynesPro typeId t_619035293; 420d mHev, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 227 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 225, 'engine_oil', (SELECT id FROM engines WHERE code = 'B46B20B'), 5.75, 6.08, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619038615; 420i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 225 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 225, 'coolant', (SELECT id FROM engines WHERE code = 'B46B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619038615; 420i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 225 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 225, 'transmission_at', (SELECT id FROM engines WHERE code = 'B46B20B'), 9.28, 9.81, NULL, 'BMW Hypoid Axle Oil G5', 'HaynesPro typeId t_619038615; 420i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 225 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 226, 'engine_oil', (SELECT id FROM engines WHERE code = 'B46B20B'), 5.75, 6.08, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619038615; 420i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 226 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 226, 'coolant', (SELECT id FROM engines WHERE code = 'B46B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619038615; 420i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 226 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 226, 'transmission_at', (SELECT id FROM engines WHERE code = 'B46B20B'), 9.28, 9.81, NULL, 'BMW Hypoid Axle Oil G5', 'HaynesPro typeId t_619038615; 420i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 226 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 227, 'engine_oil', (SELECT id FROM engines WHERE code = 'B46B20B'), 5.75, 6.08, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619038615; 420i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 227 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 227, 'coolant', (SELECT id FROM engines WHERE code = 'B46B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619038615; 420i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 227 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 227, 'transmission_at', (SELECT id FROM engines WHERE code = 'B46B20B'), 9.28, 9.81, NULL, 'BMW Hypoid Axle Oil G5', 'HaynesPro typeId t_619038615; 420i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 227 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B46B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 225, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B16A'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619038616; 420i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 225 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 225, 'coolant', (SELECT id FROM engines WHERE code = 'B48B16A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619038616; 420i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 225 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 225, 'transmission_at', (SELECT id FROM engines WHERE code = 'B48B16A'), 9.28, 9.81, NULL, 'BMW Hypoid Axle Oil G5', 'HaynesPro typeId t_619038616; 420i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 225 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 226, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B16A'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619038616; 420i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 226 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 226, 'coolant', (SELECT id FROM engines WHERE code = 'B48B16A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619038616; 420i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 226 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 226, 'transmission_at', (SELECT id FROM engines WHERE code = 'B48B16A'), 9.28, 9.81, NULL, 'BMW Hypoid Axle Oil G5', 'HaynesPro typeId t_619038616; 420i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 226 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 227, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B16A'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619038616; 420i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 227 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 227, 'coolant', (SELECT id FROM engines WHERE code = 'B48B16A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619038616; 420i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 227 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 227, 'transmission_at', (SELECT id FROM engines WHERE code = 'B48B16A'), 9.28, 9.81, NULL, 'BMW Hypoid Axle Oil G5', 'HaynesPro typeId t_619038616; 420i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 227 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B16A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 225, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B20A'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619035294; 420i, xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 225 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 225, 'coolant', (SELECT id FROM engines WHERE code = 'B48B20A'), 10, 10.57, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619035294; 420i, xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 225 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 225, 'transmission_at', (SELECT id FROM engines WHERE code = 'B48B20A'), 9.28, 9.81, NULL, 'BMW DTF1', 'HaynesPro typeId t_619035294; 420i, xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 225 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 226, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B20A'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619035294; 420i, xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 226 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 226, 'coolant', (SELECT id FROM engines WHERE code = 'B48B20A'), 10, 10.57, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619035294; 420i, xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 226 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 226, 'transmission_at', (SELECT id FROM engines WHERE code = 'B48B20A'), 9.28, 9.81, NULL, 'BMW DTF1', 'HaynesPro typeId t_619035294; 420i, xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 226 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 227, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B20A'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619035294; 420i, xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 227 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 227, 'coolant', (SELECT id FROM engines WHERE code = 'B48B20A'), 10, 10.57, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619035294; 420i, xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 227 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 227, 'transmission_at', (SELECT id FROM engines WHERE code = 'B48B20A'), 9.28, 9.81, NULL, 'BMW DTF1', 'HaynesPro typeId t_619035294; 420i, xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 227 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 225, 'engine_oil', (SELECT id FROM engines WHERE code = 'B57D30B'), 7, 7.4, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_619035295; 430d mHev, xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 225 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 225, 'coolant', (SELECT id FROM engines WHERE code = 'B57D30B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619035295; 430d mHev, xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 225 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 225, 'transmission_at', (SELECT id FROM engines WHERE code = 'B57D30B'), 9.35, 9.88, NULL, 'BMW DTF1', 'HaynesPro typeId t_619035295; 430d mHev, xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 225 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 226, 'engine_oil', (SELECT id FROM engines WHERE code = 'B57D30B'), 7, 7.4, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_619035295; 430d mHev, xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 226 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 226, 'coolant', (SELECT id FROM engines WHERE code = 'B57D30B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619035295; 430d mHev, xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 226 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 226, 'transmission_at', (SELECT id FROM engines WHERE code = 'B57D30B'), 9.35, 9.88, NULL, 'BMW DTF1', 'HaynesPro typeId t_619035295; 430d mHev, xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 226 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 227, 'engine_oil', (SELECT id FROM engines WHERE code = 'B57D30B'), 7, 7.4, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_619035295; 430d mHev, xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 227 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 227, 'coolant', (SELECT id FROM engines WHERE code = 'B57D30B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619035295; 430d mHev, xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 227 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 227, 'transmission_at', (SELECT id FROM engines WHERE code = 'B57D30B'), 9.35, 9.88, NULL, 'BMW DTF1', 'HaynesPro typeId t_619035295; 430d mHev, xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 227 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 225, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B20B'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619035297; 430i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 225 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 225, 'coolant', (SELECT id FROM engines WHERE code = 'B48B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619035297; 430i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 225 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 225, 'transmission_at', (SELECT id FROM engines WHERE code = 'B48B20B'), 9.28, 9.81, NULL, 'BMW DTF1', 'HaynesPro typeId t_619035297; 430i, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 225 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 226, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B20B'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619035297; 430i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 226 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 226, 'coolant', (SELECT id FROM engines WHERE code = 'B48B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619035297; 430i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 226 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 226, 'transmission_at', (SELECT id FROM engines WHERE code = 'B48B20B'), 9.28, 9.81, NULL, 'BMW DTF1', 'HaynesPro typeId t_619035297; 430i, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 226 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 227, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B20B'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619035297; 430i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 227 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 227, 'coolant', (SELECT id FROM engines WHERE code = 'B48B20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619035297; 430i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 227 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 227, 'transmission_at', (SELECT id FROM engines WHERE code = 'B48B20B'), 9.28, 9.81, NULL, 'BMW DTF1', 'HaynesPro typeId t_619035297; 430i, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 227 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 228, 'engine_oil', (SELECT id FROM engines WHERE code = 'S58B30B'), 7, 7.4, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_619037010; M4; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 228 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S58B30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 228, 'coolant', (SELECT id FROM engines WHERE code = 'S58B30B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619037010; M4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 228 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S58B30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 228, 'transmission_mt', (SELECT id FROM engines WHERE code = 'S58B30B'), 1.6, 1.69, NULL, 'SAE 75W-80', 'HaynesPro typeId t_619037010; M4; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 228 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'S58B30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 229, 'engine_oil', (SELECT id FROM engines WHERE code = 'S58B30B'), 7, 7.4, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_619037010; M4; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 229 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S58B30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 229, 'coolant', (SELECT id FROM engines WHERE code = 'S58B30B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619037010; M4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 229 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S58B30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 229, 'transmission_mt', (SELECT id FROM engines WHERE code = 'S58B30B'), 1.6, 1.69, NULL, 'SAE 75W-80', 'HaynesPro typeId t_619037010; M4; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 229 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'S58B30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 228, 'engine_oil', (SELECT id FROM engines WHERE code = 'S58B30A'), 7, 7.4, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_619144892; M4 CS; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 228 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 228, 'coolant', (SELECT id FROM engines WHERE code = 'S58B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619144892; M4 CS'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 228 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 228, 'transmission_at', (SELECT id FROM engines WHERE code = 'S58B30A'), 9.35, 9.88, NULL, 'BMW DTF1', 'HaynesPro typeId t_619144892; M4 CS; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 228 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'S58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 229, 'engine_oil', (SELECT id FROM engines WHERE code = 'S58B30A'), 7, 7.4, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_619144892; M4 CS; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 229 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 229, 'coolant', (SELECT id FROM engines WHERE code = 'S58B30A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619144892; M4 CS'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 229 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 229, 'transmission_at', (SELECT id FROM engines WHERE code = 'S58B30A'), 9.35, 9.88, NULL, 'BMW DTF1', 'HaynesPro typeId t_619144892; M4 CS; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 229 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'S58B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 225, 'engine_oil', (SELECT id FROM engines WHERE code = 'B58B30B'), NULL, NULL, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619036623; M440i mHev, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 225 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 225, 'coolant', (SELECT id FROM engines WHERE code = 'B58B30B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619036623; M440i mHev, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 225 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 225, 'transmission_at', (SELECT id FROM engines WHERE code = 'B58B30B'), 9.28, 9.81, NULL, 'BMW DTF1', 'HaynesPro typeId t_619036623; M440i mHev, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 225 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 226, 'engine_oil', (SELECT id FROM engines WHERE code = 'B58B30B'), NULL, NULL, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619036623; M440i mHev, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 226 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 226, 'coolant', (SELECT id FROM engines WHERE code = 'B58B30B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619036623; M440i mHev, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 226 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 226, 'transmission_at', (SELECT id FROM engines WHERE code = 'B58B30B'), 9.28, 9.81, NULL, 'BMW DTF1', 'HaynesPro typeId t_619036623; M440i mHev, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 226 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 227, 'engine_oil', (SELECT id FROM engines WHERE code = 'B58B30B'), NULL, NULL, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619036623; M440i mHev, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 227 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 227, 'coolant', (SELECT id FROM engines WHERE code = 'B58B30B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619036623; M440i mHev, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 227 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 227, 'transmission_at', (SELECT id FROM engines WHERE code = 'B58B30B'), 9.28, 9.81, NULL, 'BMW DTF1', 'HaynesPro typeId t_619036623; M440i mHev, -xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 227 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B58B30B'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 225, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_319008746; Alt: BMW ATF 3+ (BMW 83 22 2 289 720)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 225 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 226, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_319008746; Alt: BMW ATF 3+ (BMW 83 22 2 289 720)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 226 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 227, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_319008746; Alt: BMW ATF 3+ (BMW 83 22 2 289 720)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 227 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 228, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_319008746; Alt: BMW ATF 3+ (BMW 83 22 2 289 720)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 228 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 229, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_319008746; Alt: BMW ATF 3+ (BMW 83 22 2 289 720)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 229 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (225, 226, 227, 228, 229)
  AND e.code IN ('B47D20B', 'B46B20B', 'B48B16A', 'B48B20A', 'B57D30B', 'B48B20B', 'S58B30B', 'S58B30A', 'B58B30B')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (225, 226, 227, 228, 229)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (225, 226, 227, 228, 229) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;