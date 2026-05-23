-- mig 232 — multi-gen HaynesPro ingest: Audi Q5 (FY)
-- crawl: haynespro-crawl-q5-fy-2026-05-23.json
-- modelId: d_319001449
-- 18 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Audi Q5 (FY)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319001449', NOW(), 'Multi-gen ingest, 18 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319001449' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('DEUB', '30 TDI (DEUB) 100kW', 1968, 'diesel', 'turbo', NULL),
  ('DEZB', '30 TDI (DEZB) 100kW', 1968, 'diesel', 'turbo', NULL),
  ('DETB', '35 TDI (DETB) 120kW', 1968, 'diesel', 'turbo', NULL),
  ('DEUA', '35 TDI (DEUA) 110kW', 1968, 'diesel', 'turbo', NULL),
  ('DEZE', '35 TDI (DEZE) 120kW', 1968, 'diesel', 'turbo', NULL),
  ('DESA', '40 TDI (DESA) 140kW', 1968, 'diesel', 'turbo', NULL),
  ('DETA', '40 TDI (DETA) 140kW', 1968, 'diesel', 'turbo', NULL),
  ('DFBA', '40 TDI (DFBA) 150kW', 1968, 'diesel', 'turbo', NULL),
  ('CVMD', '45 TDI (CVMD) 183kW', 2967, 'diesel', 'turbo', NULL),
  ('DCPE', '45 TDI (DCPE) 170kW', 2967, 'diesel', 'turbo', NULL),
  ('DAXB', '45 TFSI (DAXB) 185kW', 1984, 'petrol', 'turbo', NULL),
  ('DAYB', '45 TFSI (DAYB) 185kW', 1984, 'petrol', 'turbo', NULL),
  ('DAXC', '45 TFSI (DAXC) 183kW', 1984, 'petrol', 'turbo', NULL),
  ('DNTA', '45 TFSI (DNTA) 180kW', 1984, 'petrol', 'turbo', NULL),
  ('DCPC', '50 TDI (DCPC) 210kW', 2967, 'diesel', 'turbo', NULL),
  ('DLGA', '50 TFSI e (DLGA) 220kW', 1984, 'hybrid', 'turbo', NULL),
  ('CWGD', '55 TFSI (CWGD) 260kW', 2995, 'petrol', 'turbo', NULL),
  ('DEWB', 'SQ5 (3.0 TDI) MHEV (DEWB) 255kW', 2967, 'hybrid', 'turbo', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'engine_oil', (SELECT id FROM engines WHERE code = 'DEUB'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319005453; 30 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'coolant', (SELECT id FROM engines WHERE code = 'DEUB'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319005453; 30 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DEUB'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_319005453; 30 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'engine_oil', (SELECT id FROM engines WHERE code = 'DEZB'), 5.5, 5.81, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619017262; 30 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DEZB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'coolant', (SELECT id FROM engines WHERE code = 'DEZB'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619017262; 30 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DEZB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DEZB'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619017262; 30 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DEZB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'engine_oil', (SELECT id FROM engines WHERE code = 'DETB'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319005451; 35 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DETB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'coolant', (SELECT id FROM engines WHERE code = 'DETB'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319005451; 35 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DETB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DETB'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_319005451; 35 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DETB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'engine_oil', (SELECT id FROM engines WHERE code = 'DEUA'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319005452; 35 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'coolant', (SELECT id FROM engines WHERE code = 'DEUA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319005452; 35 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DEUA'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_319005452; 35 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'engine_oil', (SELECT id FROM engines WHERE code = 'DEZE'), 5.5, 5.81, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619029454; 35 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DEZE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'coolant', (SELECT id FROM engines WHERE code = 'DEZE'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619029454; 35 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DEZE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DEZE'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619029454; 35 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DEZE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'engine_oil', (SELECT id FROM engines WHERE code = 'DESA'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319005449; 40 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DESA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'coolant', (SELECT id FROM engines WHERE code = 'DESA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319005449; 40 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DESA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DESA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_319005449; 40 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DESA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'engine_oil', (SELECT id FROM engines WHERE code = 'DETA'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319005450; 40 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DETA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'coolant', (SELECT id FROM engines WHERE code = 'DETA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319005450; 40 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DETA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DETA'), 1.8, 1.9, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_319005450; 40 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DETA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'engine_oil', (SELECT id FROM engines WHERE code = 'DFBA'), 5.5, 5.81, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619017263; 40 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DFBA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'coolant', (SELECT id FROM engines WHERE code = 'DFBA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619017263; 40 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DFBA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DFBA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619017263; 40 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DFBA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'engine_oil', (SELECT id FROM engines WHERE code = 'CVMD'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619017258; 45 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CVMD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'coolant', (SELECT id FROM engines WHERE code = 'CVMD'), 15, 15.85, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619017258; 45 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CVMD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'transmission_at', (SELECT id FROM engines WHERE code = 'CVMD'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619017258; 45 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CVMD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'engine_oil', (SELECT id FROM engines WHERE code = 'DCPE'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619017259; 45 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DCPE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'coolant', (SELECT id FROM engines WHERE code = 'DCPE'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619017259; 45 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DCPE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'transmission_at', (SELECT id FROM engines WHERE code = 'DCPE'), 8.6, 9.09, NULL, 'SAE 75W-85', 'HaynesPro typeId t_619017259; 45 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DCPE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'engine_oil', (SELECT id FROM engines WHERE code = 'DAXB'), 5.2, 5.49, '0W-30', 'VW 504 00', 'HaynesPro typeId t_319005448; 45 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DAXB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'coolant', (SELECT id FROM engines WHERE code = 'DAXB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319005448; 45 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DAXB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DAXB'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_319005448; 45 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DAXB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'engine_oil', (SELECT id FROM engines WHERE code = 'DAYB'), 5.2, 5.49, '0W-30', 'VW 502 00', 'HaynesPro typeId t_319005530; 45 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DAYB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'coolant', (SELECT id FROM engines WHERE code = 'DAYB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319005530; 45 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DAYB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DAYB'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_319005530; 45 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DAYB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'engine_oil', (SELECT id FROM engines WHERE code = 'DAXC'), 5.2, 5.49, '0W-30', 'VW 502 00', 'HaynesPro typeId t_319005529; 45 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DAXC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'coolant', (SELECT id FROM engines WHERE code = 'DAXC'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319005529; 45 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DAXC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DAXC'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_319005529; 45 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DAXC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'engine_oil', (SELECT id FROM engines WHERE code = 'DNTA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619016909; 45 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DNTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'coolant', (SELECT id FROM engines WHERE code = 'DNTA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619016909; 45 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DNTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DNTA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619016909; 45 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DNTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'engine_oil', (SELECT id FROM engines WHERE code = 'DCPC'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619007998; 50 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DCPC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'coolant', (SELECT id FROM engines WHERE code = 'DCPC'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619007998; 50 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DCPC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'transmission_at', (SELECT id FROM engines WHERE code = 'DCPC'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619007998; 50 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DCPC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'engine_oil', (SELECT id FROM engines WHERE code = 'DLGA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619017265; 50 TFSI e; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DLGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'coolant', (SELECT id FROM engines WHERE code = 'DLGA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619017265; 50 TFSI e'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DLGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DLGA'), 6.4, 6.76, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619017265; 50 TFSI e; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DLGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'engine_oil', (SELECT id FROM engines WHERE code = 'CWGD'), 7.25, 7.66, '0W-20', 'VW 508 00', 'HaynesPro typeId t_319005447; 55 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CWGD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'coolant', (SELECT id FROM engines WHERE code = 'CWGD'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319005447; 55 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CWGD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'transmission_at', (SELECT id FROM engines WHERE code = 'CWGD'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_319005447; 55 TFSI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CWGD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'engine_oil', (SELECT id FROM engines WHERE code = 'DEWB'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619017260; SQ5 (3.0 TDI) MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DEWB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'coolant', (SELECT id FROM engines WHERE code = 'DEWB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619017260; SQ5 (3.0 TDI) MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DEWB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'transmission_at', (SELECT id FROM engines WHERE code = 'DEWB'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619017260; SQ5 (3.0 TDI) MHEV; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DEWB'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 82, 'brake_fluid', NULL, 1, 1.06, NULL, 'VW 501 14', 'HaynesPro chassis d_319001449; Alt: DOT 4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 82 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (82)
  AND e.code IN ('DEUB', 'DEZB', 'DETB', 'DEUA', 'DEZE', 'DESA', 'DETA', 'DFBA', 'CVMD', 'DCPE', 'DAXB', 'DAYB', 'DAXC', 'DNTA', 'DCPC', 'DLGA', 'CWGD', 'DEWB')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (82)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (82) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;