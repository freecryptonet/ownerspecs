-- mig 313 — multi-gen HaynesPro ingest: Audi A8 (4N)
-- crawl: haynespro-crawl-audi-a8-4n-2026-05-23.json
-- modelId: d_319001497
-- 10 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Audi A8 (4N)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319001497', NOW(), 'Multi-gen ingest, 10 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319001497' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('CVMD', '45 TDI (CVMD) 183kW', 2967, 'diesel', 'turbo', NULL),
  ('DDVC', '50 TDI (DDVC) 210kW', 2967, 'diesel', 'turbo', NULL),
  ('DMGK', '50 TDI MHEV (DMGK) 210kW', 2967, 'hybrid', 'turbo', NULL),
  ('CZSA', '50 TFSI (CZSA) 210kW', 2995, 'petrol', 'turbo', NULL),
  ('CZSE', '55 TFSI (CZSE) 250kW', 2995, 'petrol', 'turbo', NULL),
  ('CXYA', '60 FSi (CXYA) 338kW', 3996, 'petrol', 'NA', NULL),
  ('CVXB', '60 TDI (CVXB) 320kW', 3956, 'diesel', 'turbo', NULL),
  ('DWPA', '60 TFSI MHEV (DWPA) 338kW', 3996, 'hybrid', 'turbo', NULL),
  ('CWWB', 'S8 (4.0 V8 TFSI) MHEV (CWWB) 420kW', 3996, 'hybrid', 'turbo', NULL),
  ('DWKA', 'S8 (4.0 V8 TFSI) MHEV (DWKA) 420kW', 3996, 'hybrid', 'turbo', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 289, 'engine_oil', (SELECT id FROM engines WHERE code = 'CVMD'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619008017; 45 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 289 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CVMD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 289, 'coolant', (SELECT id FROM engines WHERE code = 'CVMD'), 15, 15.85, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619008017; 45 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 289 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CVMD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 289, 'transmission_at', (SELECT id FROM engines WHERE code = 'CVMD'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619008017; 45 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 289 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CVMD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 289, 'engine_oil', (SELECT id FROM engines WHERE code = 'DDVC'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619008021; 50 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 289 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DDVC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 289, 'coolant', (SELECT id FROM engines WHERE code = 'DDVC'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619008021; 50 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 289 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DDVC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 289, 'transmission_at', (SELECT id FROM engines WHERE code = 'DDVC'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619008021; 50 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 289 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DDVC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 289, 'engine_oil', (SELECT id FROM engines WHERE code = 'DMGK'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619035000; 50 TDI MHEV; drain 35 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 289 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DMGK'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 289, 'coolant', (SELECT id FROM engines WHERE code = 'DMGK'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035000; 50 TDI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 289 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DMGK'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 289, 'transmission_at', (SELECT id FROM engines WHERE code = 'DMGK'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619035000; 50 TDI MHEV; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 289 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DMGK'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 289, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZSA'), 7.6, 8.03, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619008022; 50 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 289 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 289, 'coolant', (SELECT id FROM engines WHERE code = 'CZSA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619008022; 50 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 289 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 289, 'transmission_at', (SELECT id FROM engines WHERE code = 'CZSA'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619008022; 50 TFSI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 289 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CZSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 289, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZSE'), 7.6, 8.03, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619008020; 55 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 289 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZSE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 289, 'coolant', (SELECT id FROM engines WHERE code = 'CZSE'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619008020; 55 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 289 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZSE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 289, 'transmission_at', (SELECT id FROM engines WHERE code = 'CZSE'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619008020; 55 TFSI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 289 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CZSE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 289, 'engine_oil', (SELECT id FROM engines WHERE code = 'CXYA'), 9.5, 10.04, '0W-30', 'VW 504 00', 'HaynesPro typeId t_619008019; 60 FSi; drain 9 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 289 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CXYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 289, 'coolant', (SELECT id FROM engines WHERE code = 'CXYA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619008019; 60 FSi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 289 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CXYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 289, 'transmission_at', (SELECT id FROM engines WHERE code = 'CXYA'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619008019; 60 FSi; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 289 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CXYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 289, 'engine_oil', (SELECT id FROM engines WHERE code = 'CVXB'), 8.8, 9.3, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619008018; 60 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 289 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CVXB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 289, 'coolant', (SELECT id FROM engines WHERE code = 'CVXB'), 15, 15.85, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619008018; 60 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 289 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CVXB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 289, 'transmission_at', (SELECT id FROM engines WHERE code = 'CVXB'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_619008018; 60 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 289 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CVXB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 289, 'engine_oil', (SELECT id FROM engines WHERE code = 'DWPA'), 9.5, 10.04, '0W-40', 'VW 511 00', 'HaynesPro typeId t_619117203; 60 TFSI MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 289 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DWPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 289, 'coolant', (SELECT id FROM engines WHERE code = 'DWPA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619117203; 60 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 289 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DWPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 289, 'transmission_at', (SELECT id FROM engines WHERE code = 'DWPA'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619117203; 60 TFSI MHEV; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 289 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DWPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 289, 'engine_oil', (SELECT id FROM engines WHERE code = 'CWWB'), 9.5, 10.04, '0W-30', 'VW 504 00', 'HaynesPro typeId t_619017222; S8 (4.0 V8 TFSI) MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 289 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CWWB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 289, 'coolant', (SELECT id FROM engines WHERE code = 'CWWB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619017222; S8 (4.0 V8 TFSI) MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 289 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CWWB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 289, 'transmission_at', (SELECT id FROM engines WHERE code = 'CWWB'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_619017222; S8 (4.0 V8 TFSI) MHEV; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 289 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CWWB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 289, 'engine_oil', (SELECT id FROM engines WHERE code = 'DWKA'), 9.5, 10.04, '0W-40', 'VW 511 00', 'HaynesPro typeId t_619117202; S8 (4.0 V8 TFSI) MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 289 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DWKA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 289, 'coolant', (SELECT id FROM engines WHERE code = 'DWKA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619117202; S8 (4.0 V8 TFSI) MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 289 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DWKA'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 289, 'brake_fluid', NULL, 1, 1.06, NULL, 'VW 501 14', 'HaynesPro chassis d_319001497; Alt: DOT 4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 289 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (289)
  AND e.code IN ('CVMD', 'DDVC', 'DMGK', 'CZSA', 'CZSE', 'CXYA', 'CVXB', 'DWPA', 'CWWB', 'DWKA')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (289)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (289) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;