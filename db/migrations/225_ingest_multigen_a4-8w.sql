-- mig 225 — multi-gen HaynesPro ingest: Audi A4 (8W)
-- crawl: haynespro-crawl-a4-8w-2026-05-23.json
-- modelId: d_317000026
-- 40 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Audi A4 (8W)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_317000026', NOW(), 'Multi-gen ingest, 40 engines across 4 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_317000026' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('CVNA', '1.4 TFSI (CVNA) 110kW', 1395, 'petrol', 'turbo', NULL),
  ('CVLA', '2.0 G-tron (CVLA) 125kW', 1984, 'petrol', 'NA', NULL),
  ('DESA', '2.0 TDI (DESA) 140kW', 1968, 'diesel', 'turbo', NULL),
  ('DETA', '2.0 TDI (DETA) 140kW', 1968, 'diesel', 'turbo', NULL),
  ('DFVA', '2.0 TDI (DFVA) 140kW', 1968, 'diesel', 'turbo', NULL),
  ('CZHA', '2.0 TDI (CZHA) 110kW', 1968, 'diesel', 'turbo', NULL),
  ('DEUA', '2.0 TDI (DEUA) 110kW', 1968, 'diesel', 'turbo', NULL),
  ('DEUB', '2.0 TDI (DEUB) 100kW', 1968, 'diesel', 'turbo', NULL),
  ('DEUC', '2.0 TDI (DEUC) 90kW', 1968, 'diesel', 'turbo', NULL),
  ('DETB', '2.0 TDI (DETB) 120kW', 1968, 'diesel', 'turbo', NULL),
  ('CYMC', '2.0 TFSI (CYMC) 185kW', 1984, 'petrol', 'turbo', NULL),
  ('CYRB', '2.0 TFSI (CYRB) 185kW', 1984, 'petrol', 'turbo', NULL),
  ('CYRC', '2.0 TFSI (CYRC) 183kW', 1984, 'petrol', 'turbo', NULL),
  ('CVKB', '2.0 TFSI (CVKB) 140kW', 1984, 'petrol', 'turbo', NULL),
  ('DBPA', '2.0 TFSI (DBPA) 140kW', 1984, 'petrol', 'turbo', NULL),
  ('DEMA', '2.0 TFSI MHEV (DEMA) 140kW', 1984, 'hybrid', 'turbo', NULL),
  ('DDWA', '2.0 TFSI MHEV (DDWA) 185kW', 1984, 'hybrid', 'turbo', NULL),
  ('DDWB', '2.0 TFSI MHEV (DDWB) 183kW', 1984, 'hybrid', 'turbo', NULL),
  ('CRTC', '3.0 TDI (CRTC) 200kW', 2967, 'diesel', 'turbo', NULL),
  ('CSWB', '3.0 TDI (CSWB) 160kW', 2967, 'diesel', 'turbo', NULL),
  ('DCPC', '3.0 TDI (DCPC) 210kW', 2967, 'diesel', 'turbo', NULL),
  ('DMGA', '3.0 TDI MHEV (DMGA) 210kW', 2967, 'hybrid', 'turbo', NULL),
  ('DEZB', '30 TDI MHEV (DEZB) 100kW', 1968, 'hybrid', 'turbo', NULL),
  ('DTNB', '30 TDI MHEV (DTNB) 100kW', 1968, 'hybrid', 'turbo', NULL),
  ('DEZE', '35 TDI MHEV (DEZE) 120kW', 1968, 'hybrid', 'turbo', NULL),
  ('DTNA', '35 TDI MHEV (DTNA) 120kW', 1968, 'hybrid', 'turbo', NULL),
  ('CVKC', '35 TFSI (CVKC) 110kW', 1984, 'petrol', 'turbo', NULL),
  ('DLVB', '35 TFSI MHEV (DLVB) 110kW', 1984, 'hybrid', 'turbo', NULL),
  ('DEMB', '35 TFSI MHEV (DEMB) 110kW', 1984, 'hybrid', 'turbo', NULL),
  ('DMSB', '35 TFSI MHEV (DMSB) 110kW', 1984, 'hybrid', 'turbo', NULL),
  ('DTPA', '40 TDI MHEV (DTPA) 150kW', 1968, 'hybrid', 'turbo', NULL),
  ('DKYA', '40 TFSI MHEV (DKYA) 140kW', 1984, 'hybrid', 'turbo', NULL),
  ('DLVA', '40 TFSI MHEV (DLVA) 140kW', 1984, 'hybrid', 'turbo', NULL),
  ('DHDA', '40 TFSI MHEV (DHDA) 140kW', 1984, 'hybrid', 'turbo', NULL),
  ('DRXA', '40 TFSI g-Tron (DRXA) 125kW', 1984, 'petrol', 'turbo', NULL),
  ('DMSA', '40 TFSI, MHEV (DMSA) 150kW', 1984, 'hybrid', 'turbo', NULL),
  ('DCPE', '45 TDI (DCPE) 170kW', 2967, 'diesel', 'turbo', NULL),
  ('DMTA', '45 TFSI MHEV (DMTA) 195kW', 1984, 'hybrid', 'turbo', NULL),
  ('DLHB', '45 TFSI MHEV (DLHB) 185kW', 1984, 'hybrid', 'turbo', NULL),
  ('DKNA', '45 TFSI MHEV (DKNA) 180kW', 1984, 'hybrid', 'turbo', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'engine_oil', (SELECT id FROM engines WHERE code = 'CVNA'), 4.3, 4.54, '0W-20', 'VW 508 00', 'HaynesPro typeId t_318011813; 1.4 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CVNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'coolant', (SELECT id FROM engines WHERE code = 'CVNA'), NULL, NULL, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011813; 1.4 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CVNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CVNA'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011813; 1.4 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CVNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'engine_oil', (SELECT id FROM engines WHERE code = 'CVNA'), 4.3, 4.54, '0W-20', 'VW 508 00', 'HaynesPro typeId t_318011813; 1.4 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CVNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'coolant', (SELECT id FROM engines WHERE code = 'CVNA'), NULL, NULL, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011813; 1.4 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CVNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CVNA'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011813; 1.4 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CVNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'engine_oil', (SELECT id FROM engines WHERE code = 'CVNA'), 4.3, 4.54, '0W-20', 'VW 508 00', 'HaynesPro typeId t_318011813; 1.4 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CVNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'coolant', (SELECT id FROM engines WHERE code = 'CVNA'), NULL, NULL, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011813; 1.4 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CVNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CVNA'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011813; 1.4 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CVNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'engine_oil', (SELECT id FROM engines WHERE code = 'CVNA'), 4.3, 4.54, '0W-20', 'VW 508 00', 'HaynesPro typeId t_318011813; 1.4 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CVNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'coolant', (SELECT id FROM engines WHERE code = 'CVNA'), NULL, NULL, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011813; 1.4 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CVNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CVNA'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011813; 1.4 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CVNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'engine_oil', (SELECT id FROM engines WHERE code = 'CVLA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_319005445; 2.0 G-tron; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CVLA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'coolant', (SELECT id FROM engines WHERE code = 'CVLA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319005445; 2.0 G-tron'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CVLA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CVLA'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_319005445; 2.0 G-tron; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CVLA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'engine_oil', (SELECT id FROM engines WHERE code = 'CVLA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_319005445; 2.0 G-tron; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CVLA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'coolant', (SELECT id FROM engines WHERE code = 'CVLA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319005445; 2.0 G-tron'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CVLA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CVLA'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_319005445; 2.0 G-tron; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CVLA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'engine_oil', (SELECT id FROM engines WHERE code = 'CVLA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_319005445; 2.0 G-tron; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CVLA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'coolant', (SELECT id FROM engines WHERE code = 'CVLA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319005445; 2.0 G-tron'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CVLA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CVLA'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_319005445; 2.0 G-tron; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CVLA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'engine_oil', (SELECT id FROM engines WHERE code = 'CVLA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_319005445; 2.0 G-tron; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CVLA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'coolant', (SELECT id FROM engines WHERE code = 'CVLA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319005445; 2.0 G-tron'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CVLA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CVLA'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_319005445; 2.0 G-tron; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CVLA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'engine_oil', (SELECT id FROM engines WHERE code = 'DESA'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_318011816; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DESA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'coolant', (SELECT id FROM engines WHERE code = 'DESA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011816; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DESA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DESA'), 3.8, 4.02, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011816; 2.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DESA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'engine_oil', (SELECT id FROM engines WHERE code = 'DESA'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_318011816; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DESA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'coolant', (SELECT id FROM engines WHERE code = 'DESA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011816; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DESA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DESA'), 3.8, 4.02, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011816; 2.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DESA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'engine_oil', (SELECT id FROM engines WHERE code = 'DESA'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_318011816; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DESA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'coolant', (SELECT id FROM engines WHERE code = 'DESA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011816; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DESA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DESA'), 3.8, 4.02, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011816; 2.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DESA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'engine_oil', (SELECT id FROM engines WHERE code = 'DESA'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_318011816; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DESA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'coolant', (SELECT id FROM engines WHERE code = 'DESA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011816; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DESA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DESA'), 3.8, 4.02, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011816; 2.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DESA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'engine_oil', (SELECT id FROM engines WHERE code = 'DETA'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_318011817; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DETA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'coolant', (SELECT id FROM engines WHERE code = 'DETA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011817; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DETA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DETA'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011817; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DETA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'engine_oil', (SELECT id FROM engines WHERE code = 'DETA'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_318011817; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DETA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'coolant', (SELECT id FROM engines WHERE code = 'DETA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011817; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DETA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DETA'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011817; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DETA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'engine_oil', (SELECT id FROM engines WHERE code = 'DETA'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_318011817; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DETA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'coolant', (SELECT id FROM engines WHERE code = 'DETA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011817; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DETA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DETA'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011817; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DETA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'engine_oil', (SELECT id FROM engines WHERE code = 'DETA'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_318011817; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DETA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'coolant', (SELECT id FROM engines WHERE code = 'DETA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011817; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DETA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DETA'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011817; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DETA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'engine_oil', (SELECT id FROM engines WHERE code = 'DFVA'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_318011821; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DFVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'coolant', (SELECT id FROM engines WHERE code = 'DFVA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011821; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DFVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DFVA'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011821; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DFVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'engine_oil', (SELECT id FROM engines WHERE code = 'DFVA'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_318011821; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DFVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'coolant', (SELECT id FROM engines WHERE code = 'DFVA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011821; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DFVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DFVA'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011821; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DFVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'engine_oil', (SELECT id FROM engines WHERE code = 'DFVA'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_318011821; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DFVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'coolant', (SELECT id FROM engines WHERE code = 'DFVA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011821; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DFVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DFVA'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011821; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DFVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'engine_oil', (SELECT id FROM engines WHERE code = 'DFVA'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_318011821; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DFVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'coolant', (SELECT id FROM engines WHERE code = 'DFVA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011821; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DFVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DFVA'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011821; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DFVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZHA'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_318011822; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'coolant', (SELECT id FROM engines WHERE code = 'CZHA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011822; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CZHA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011822; 2.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CZHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZHA'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_318011822; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'coolant', (SELECT id FROM engines WHERE code = 'CZHA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011822; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CZHA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011822; 2.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CZHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZHA'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_318011822; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'coolant', (SELECT id FROM engines WHERE code = 'CZHA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011822; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CZHA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011822; 2.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CZHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZHA'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_318011822; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'coolant', (SELECT id FROM engines WHERE code = 'CZHA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011822; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CZHA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011822; 2.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CZHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'engine_oil', (SELECT id FROM engines WHERE code = 'DEUA'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_318011818; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'coolant', (SELECT id FROM engines WHERE code = 'DEUA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011818; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DEUA'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011818; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'engine_oil', (SELECT id FROM engines WHERE code = 'DEUA'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_318011818; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'coolant', (SELECT id FROM engines WHERE code = 'DEUA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011818; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DEUA'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011818; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'engine_oil', (SELECT id FROM engines WHERE code = 'DEUA'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_318011818; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'coolant', (SELECT id FROM engines WHERE code = 'DEUA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011818; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DEUA'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011818; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'engine_oil', (SELECT id FROM engines WHERE code = 'DEUA'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_318011818; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'coolant', (SELECT id FROM engines WHERE code = 'DEUA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011818; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DEUA'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011818; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'engine_oil', (SELECT id FROM engines WHERE code = 'DEUB'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_318011819; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'coolant', (SELECT id FROM engines WHERE code = 'DEUB'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011819; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DEUB'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011819; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'engine_oil', (SELECT id FROM engines WHERE code = 'DEUB'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_318011819; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'coolant', (SELECT id FROM engines WHERE code = 'DEUB'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011819; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DEUB'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011819; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'engine_oil', (SELECT id FROM engines WHERE code = 'DEUC'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_318011820; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'coolant', (SELECT id FROM engines WHERE code = 'DEUC'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011820; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DEUC'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011820; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'engine_oil', (SELECT id FROM engines WHERE code = 'DEUC'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_318011820; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'coolant', (SELECT id FROM engines WHERE code = 'DEUC'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011820; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DEUC'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011820; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'engine_oil', (SELECT id FROM engines WHERE code = 'DEUC'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_318011820; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'coolant', (SELECT id FROM engines WHERE code = 'DEUC'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011820; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DEUC'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011820; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'engine_oil', (SELECT id FROM engines WHERE code = 'DEUC'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_318011820; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'coolant', (SELECT id FROM engines WHERE code = 'DEUC'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011820; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DEUC'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011820; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'engine_oil', (SELECT id FROM engines WHERE code = 'DETB'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319004606; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DETB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'coolant', (SELECT id FROM engines WHERE code = 'DETB'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319004606; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DETB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DETB'), 3.8, 4.02, NULL, 'VW G 055 549 A2', 'HaynesPro typeId t_319004606; 2.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DETB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'engine_oil', (SELECT id FROM engines WHERE code = 'DETB'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319004606; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DETB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'coolant', (SELECT id FROM engines WHERE code = 'DETB'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319004606; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DETB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DETB'), 3.8, 4.02, NULL, 'VW G 055 549 A2', 'HaynesPro typeId t_319004606; 2.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DETB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'engine_oil', (SELECT id FROM engines WHERE code = 'DETB'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319004606; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DETB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'coolant', (SELECT id FROM engines WHERE code = 'DETB'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319004606; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DETB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DETB'), 3.8, 4.02, NULL, 'VW G 055 549 A2', 'HaynesPro typeId t_319004606; 2.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DETB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'engine_oil', (SELECT id FROM engines WHERE code = 'DETB'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319004606; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DETB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'coolant', (SELECT id FROM engines WHERE code = 'DETB'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319004606; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DETB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DETB'), 3.8, 4.02, NULL, 'VW G 055 549 A2', 'HaynesPro typeId t_319004606; 2.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DETB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'engine_oil', (SELECT id FROM engines WHERE code = 'CYMC'), 5.2, 5.49, '0W-30', 'VW 502 00', 'HaynesPro typeId t_318011814; 2.0 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CYMC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'coolant', (SELECT id FROM engines WHERE code = 'CYMC'), NULL, NULL, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011814; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CYMC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CYMC'), 1.8, 1.9, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011814; 2.0 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CYMC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'engine_oil', (SELECT id FROM engines WHERE code = 'CYMC'), 5.2, 5.49, '0W-30', 'VW 502 00', 'HaynesPro typeId t_318011814; 2.0 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CYMC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'coolant', (SELECT id FROM engines WHERE code = 'CYMC'), NULL, NULL, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011814; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CYMC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CYMC'), 1.8, 1.9, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011814; 2.0 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CYMC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'engine_oil', (SELECT id FROM engines WHERE code = 'CYMC'), 5.2, 5.49, '0W-30', 'VW 502 00', 'HaynesPro typeId t_318011814; 2.0 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CYMC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'coolant', (SELECT id FROM engines WHERE code = 'CYMC'), NULL, NULL, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011814; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CYMC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CYMC'), 1.8, 1.9, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011814; 2.0 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CYMC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'engine_oil', (SELECT id FROM engines WHERE code = 'CYMC'), 5.2, 5.49, '0W-30', 'VW 502 00', 'HaynesPro typeId t_318011814; 2.0 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CYMC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'coolant', (SELECT id FROM engines WHERE code = 'CYMC'), NULL, NULL, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011814; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CYMC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CYMC'), 1.8, 1.9, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011814; 2.0 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CYMC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'engine_oil', (SELECT id FROM engines WHERE code = 'CYRB'), 5.2, 5.49, '0W-30', 'VW 502 00', 'HaynesPro typeId t_318011815; 2.0 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CYRB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'coolant', (SELECT id FROM engines WHERE code = 'CYRB'), NULL, NULL, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011815; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CYRB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CYRB'), 1.8, 1.9, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011815; 2.0 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CYRB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'engine_oil', (SELECT id FROM engines WHERE code = 'CYRB'), 5.2, 5.49, '0W-30', 'VW 502 00', 'HaynesPro typeId t_318011815; 2.0 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CYRB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'coolant', (SELECT id FROM engines WHERE code = 'CYRB'), NULL, NULL, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011815; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CYRB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CYRB'), 1.8, 1.9, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011815; 2.0 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CYRB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'engine_oil', (SELECT id FROM engines WHERE code = 'CYRB'), 5.2, 5.49, '0W-30', 'VW 502 00', 'HaynesPro typeId t_318011815; 2.0 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CYRB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'coolant', (SELECT id FROM engines WHERE code = 'CYRB'), NULL, NULL, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011815; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CYRB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CYRB'), 1.8, 1.9, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011815; 2.0 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CYRB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'engine_oil', (SELECT id FROM engines WHERE code = 'CYRB'), 5.2, 5.49, '0W-30', 'VW 502 00', 'HaynesPro typeId t_318011815; 2.0 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CYRB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'coolant', (SELECT id FROM engines WHERE code = 'CYRB'), NULL, NULL, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011815; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CYRB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CYRB'), 1.8, 1.9, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011815; 2.0 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CYRB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'engine_oil', (SELECT id FROM engines WHERE code = 'CYRC'), 5.2, 5.49, '0W-30', 'VW 502 00', 'HaynesPro typeId t_319000200; 2.0 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CYRC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'coolant', (SELECT id FROM engines WHERE code = 'CYRC'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319000200; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CYRC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CYRC'), 3.8, 4.02, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_319000200; 2.0 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CYRC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'engine_oil', (SELECT id FROM engines WHERE code = 'CYRC'), 5.2, 5.49, '0W-30', 'VW 502 00', 'HaynesPro typeId t_319000200; 2.0 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CYRC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'coolant', (SELECT id FROM engines WHERE code = 'CYRC'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319000200; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CYRC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CYRC'), 3.8, 4.02, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_319000200; 2.0 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CYRC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'engine_oil', (SELECT id FROM engines WHERE code = 'CYRC'), 5.2, 5.49, '0W-30', 'VW 502 00', 'HaynesPro typeId t_319000200; 2.0 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CYRC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'coolant', (SELECT id FROM engines WHERE code = 'CYRC'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319000200; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CYRC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CYRC'), 3.8, 4.02, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_319000200; 2.0 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CYRC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'engine_oil', (SELECT id FROM engines WHERE code = 'CYRC'), 5.2, 5.49, '0W-30', 'VW 502 00', 'HaynesPro typeId t_319000200; 2.0 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CYRC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'coolant', (SELECT id FROM engines WHERE code = 'CYRC'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319000200; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CYRC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CYRC'), 3.8, 4.02, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_319000200; 2.0 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CYRC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'engine_oil', (SELECT id FROM engines WHERE code = 'CVKB'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_318011812; 2.0 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CVKB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'coolant', (SELECT id FROM engines WHERE code = 'CVKB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011812; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CVKB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CVKB'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011812; 2.0 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CVKB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'engine_oil', (SELECT id FROM engines WHERE code = 'CVKB'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_318011812; 2.0 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CVKB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'coolant', (SELECT id FROM engines WHERE code = 'CVKB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011812; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CVKB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CVKB'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011812; 2.0 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CVKB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'engine_oil', (SELECT id FROM engines WHERE code = 'CVKB'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_318011812; 2.0 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CVKB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'coolant', (SELECT id FROM engines WHERE code = 'CVKB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011812; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CVKB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CVKB'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011812; 2.0 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CVKB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'engine_oil', (SELECT id FROM engines WHERE code = 'CVKB'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_318011812; 2.0 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CVKB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'coolant', (SELECT id FROM engines WHERE code = 'CVKB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011812; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CVKB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CVKB'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011812; 2.0 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CVKB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'engine_oil', (SELECT id FROM engines WHERE code = 'DBPA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_319005457; 2.0 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DBPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'coolant', (SELECT id FROM engines WHERE code = 'DBPA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319005457; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DBPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DBPA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_319005457; 2.0 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DBPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'engine_oil', (SELECT id FROM engines WHERE code = 'DBPA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_319005457; 2.0 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DBPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'coolant', (SELECT id FROM engines WHERE code = 'DBPA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319005457; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DBPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DBPA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_319005457; 2.0 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DBPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'engine_oil', (SELECT id FROM engines WHERE code = 'DBPA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_319005457; 2.0 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DBPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'coolant', (SELECT id FROM engines WHERE code = 'DBPA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319005457; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DBPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DBPA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_319005457; 2.0 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DBPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'engine_oil', (SELECT id FROM engines WHERE code = 'DBPA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_319005457; 2.0 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DBPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'coolant', (SELECT id FROM engines WHERE code = 'DBPA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319005457; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DBPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DBPA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_319005457; 2.0 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DBPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'engine_oil', (SELECT id FROM engines WHERE code = 'DEMA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619011090; 2.0 TFSI MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DEMA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'coolant', (SELECT id FROM engines WHERE code = 'DEMA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619011090; 2.0 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DEMA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DEMA'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619011090; 2.0 TFSI MHEV; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DEMA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'engine_oil', (SELECT id FROM engines WHERE code = 'DEMA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619011090; 2.0 TFSI MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DEMA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'coolant', (SELECT id FROM engines WHERE code = 'DEMA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619011090; 2.0 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DEMA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DEMA'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619011090; 2.0 TFSI MHEV; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DEMA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'engine_oil', (SELECT id FROM engines WHERE code = 'DEMA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619011090; 2.0 TFSI MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DEMA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'coolant', (SELECT id FROM engines WHERE code = 'DEMA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619011090; 2.0 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DEMA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DEMA'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619011090; 2.0 TFSI MHEV; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DEMA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'engine_oil', (SELECT id FROM engines WHERE code = 'DEMA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619011090; 2.0 TFSI MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DEMA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'coolant', (SELECT id FROM engines WHERE code = 'DEMA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619011090; 2.0 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DEMA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DEMA'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619011090; 2.0 TFSI MHEV; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DEMA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'engine_oil', (SELECT id FROM engines WHERE code = 'DDWA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619011091; 2.0 TFSI MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DDWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'coolant', (SELECT id FROM engines WHERE code = 'DDWA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619011091; 2.0 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DDWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DDWA'), 1.8, 1.9, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619011091; 2.0 TFSI MHEV; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DDWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'engine_oil', (SELECT id FROM engines WHERE code = 'DDWA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619011091; 2.0 TFSI MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DDWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'coolant', (SELECT id FROM engines WHERE code = 'DDWA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619011091; 2.0 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DDWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DDWA'), 1.8, 1.9, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619011091; 2.0 TFSI MHEV; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DDWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'engine_oil', (SELECT id FROM engines WHERE code = 'DDWA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619011091; 2.0 TFSI MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DDWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'coolant', (SELECT id FROM engines WHERE code = 'DDWA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619011091; 2.0 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DDWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DDWA'), 1.8, 1.9, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619011091; 2.0 TFSI MHEV; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DDWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'engine_oil', (SELECT id FROM engines WHERE code = 'DDWA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619011091; 2.0 TFSI MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DDWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'coolant', (SELECT id FROM engines WHERE code = 'DDWA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619011091; 2.0 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DDWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DDWA'), 1.8, 1.9, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619011091; 2.0 TFSI MHEV; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DDWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'engine_oil', (SELECT id FROM engines WHERE code = 'DDWB'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619116168; 2.0 TFSI MHEV; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DDWB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'coolant', (SELECT id FROM engines WHERE code = 'DDWB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619116168; 2.0 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DDWB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DDWB'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619116168; 2.0 TFSI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DDWB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'engine_oil', (SELECT id FROM engines WHERE code = 'DDWB'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619116168; 2.0 TFSI MHEV; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DDWB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'coolant', (SELECT id FROM engines WHERE code = 'DDWB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619116168; 2.0 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DDWB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DDWB'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619116168; 2.0 TFSI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DDWB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'engine_oil', (SELECT id FROM engines WHERE code = 'CRTC'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_318011810; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CRTC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'coolant', (SELECT id FROM engines WHERE code = 'CRTC'), 13, 13.74, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011810; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CRTC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'transmission_at', (SELECT id FROM engines WHERE code = 'CRTC'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_318011810; 3.0 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CRTC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'engine_oil', (SELECT id FROM engines WHERE code = 'CRTC'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_318011810; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CRTC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'coolant', (SELECT id FROM engines WHERE code = 'CRTC'), 13, 13.74, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011810; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CRTC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'transmission_at', (SELECT id FROM engines WHERE code = 'CRTC'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_318011810; 3.0 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CRTC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'engine_oil', (SELECT id FROM engines WHERE code = 'CSWB'), 6.1, 6.45, '0W-20', 'VW 509 00', 'HaynesPro typeId t_318011811; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CSWB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'coolant', (SELECT id FROM engines WHERE code = 'CSWB'), NULL, NULL, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011811; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CSWB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CSWB'), 3.8, 4.02, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011811; 3.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CSWB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'engine_oil', (SELECT id FROM engines WHERE code = 'CSWB'), 6.1, 6.45, '0W-20', 'VW 509 00', 'HaynesPro typeId t_318011811; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CSWB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'coolant', (SELECT id FROM engines WHERE code = 'CSWB'), NULL, NULL, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011811; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CSWB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CSWB'), 3.8, 4.02, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318011811; 3.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CSWB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'engine_oil', (SELECT id FROM engines WHERE code = 'DCPC'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319005458; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DCPC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'coolant', (SELECT id FROM engines WHERE code = 'DCPC'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319005458; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DCPC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'transmission_at', (SELECT id FROM engines WHERE code = 'DCPC'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_319005458; 3.0 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DCPC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'engine_oil', (SELECT id FROM engines WHERE code = 'DCPC'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319005458; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DCPC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'coolant', (SELECT id FROM engines WHERE code = 'DCPC'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319005458; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DCPC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'transmission_at', (SELECT id FROM engines WHERE code = 'DCPC'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_319005458; 3.0 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DCPC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'engine_oil', (SELECT id FROM engines WHERE code = 'DCPC'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319005458; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DCPC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'coolant', (SELECT id FROM engines WHERE code = 'DCPC'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319005458; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DCPC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'transmission_at', (SELECT id FROM engines WHERE code = 'DCPC'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_319005458; 3.0 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DCPC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'engine_oil', (SELECT id FROM engines WHERE code = 'DCPC'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319005458; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DCPC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'coolant', (SELECT id FROM engines WHERE code = 'DCPC'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319005458; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DCPC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'transmission_at', (SELECT id FROM engines WHERE code = 'DCPC'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_319005458; 3.0 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DCPC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'engine_oil', (SELECT id FROM engines WHERE code = 'DMGA'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619035635; 3.0 TDI MHEV; drain 35 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DMGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'coolant', (SELECT id FROM engines WHERE code = 'DMGA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035635; 3.0 TDI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DMGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'transmission_at', (SELECT id FROM engines WHERE code = 'DMGA'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619035635; 3.0 TDI MHEV; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DMGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'engine_oil', (SELECT id FROM engines WHERE code = 'DMGA'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619035635; 3.0 TDI MHEV; drain 35 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DMGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'coolant', (SELECT id FROM engines WHERE code = 'DMGA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035635; 3.0 TDI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DMGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'transmission_at', (SELECT id FROM engines WHERE code = 'DMGA'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619035635; 3.0 TDI MHEV; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DMGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'engine_oil', (SELECT id FROM engines WHERE code = 'DEZB'), 5.5, 5.81, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619008008; 30 TDI MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DEZB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'coolant', (SELECT id FROM engines WHERE code = 'DEZB'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619008008; 30 TDI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DEZB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DEZB'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619008008; 30 TDI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DEZB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'engine_oil', (SELECT id FROM engines WHERE code = 'DEZB'), 5.5, 5.81, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619008008; 30 TDI MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DEZB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'coolant', (SELECT id FROM engines WHERE code = 'DEZB'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619008008; 30 TDI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DEZB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DEZB'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619008008; 30 TDI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DEZB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'engine_oil', (SELECT id FROM engines WHERE code = 'DEZB'), 5.5, 5.81, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619008008; 30 TDI MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DEZB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'coolant', (SELECT id FROM engines WHERE code = 'DEZB'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619008008; 30 TDI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DEZB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DEZB'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619008008; 30 TDI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DEZB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'engine_oil', (SELECT id FROM engines WHERE code = 'DEZB'), 5.5, 5.81, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619008008; 30 TDI MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DEZB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'coolant', (SELECT id FROM engines WHERE code = 'DEZB'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619008008; 30 TDI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DEZB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DEZB'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619008008; 30 TDI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DEZB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'engine_oil', (SELECT id FROM engines WHERE code = 'DTNB'), 5.5, 5.81, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619035639; 30 TDI MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DTNB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'coolant', (SELECT id FROM engines WHERE code = 'DTNB'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035639; 30 TDI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DTNB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DTNB'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619035639; 30 TDI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DTNB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'engine_oil', (SELECT id FROM engines WHERE code = 'DTNB'), 5.5, 5.81, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619035639; 30 TDI MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DTNB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'coolant', (SELECT id FROM engines WHERE code = 'DTNB'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035639; 30 TDI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DTNB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DTNB'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619035639; 30 TDI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DTNB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'engine_oil', (SELECT id FROM engines WHERE code = 'DEZE'), 5.5, 5.81, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619008009; 35 TDI MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DEZE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'coolant', (SELECT id FROM engines WHERE code = 'DEZE'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619008009; 35 TDI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DEZE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DEZE'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619008009; 35 TDI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DEZE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'engine_oil', (SELECT id FROM engines WHERE code = 'DEZE'), 5.5, 5.81, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619008009; 35 TDI MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DEZE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'coolant', (SELECT id FROM engines WHERE code = 'DEZE'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619008009; 35 TDI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DEZE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DEZE'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619008009; 35 TDI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DEZE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'engine_oil', (SELECT id FROM engines WHERE code = 'DEZE'), 5.5, 5.81, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619008009; 35 TDI MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DEZE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'coolant', (SELECT id FROM engines WHERE code = 'DEZE'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619008009; 35 TDI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DEZE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DEZE'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619008009; 35 TDI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DEZE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'engine_oil', (SELECT id FROM engines WHERE code = 'DEZE'), 5.5, 5.81, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619008009; 35 TDI MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DEZE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'coolant', (SELECT id FROM engines WHERE code = 'DEZE'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619008009; 35 TDI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DEZE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DEZE'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619008009; 35 TDI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DEZE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'engine_oil', (SELECT id FROM engines WHERE code = 'DTNA'), 5.5, 5.81, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619035638; 35 TDI MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DTNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'coolant', (SELECT id FROM engines WHERE code = 'DTNA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035638; 35 TDI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DTNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DTNA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619035638; 35 TDI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DTNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'engine_oil', (SELECT id FROM engines WHERE code = 'DTNA'), 5.5, 5.81, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619035638; 35 TDI MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DTNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'coolant', (SELECT id FROM engines WHERE code = 'DTNA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035638; 35 TDI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DTNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DTNA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619035638; 35 TDI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DTNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'engine_oil', (SELECT id FROM engines WHERE code = 'CVKC'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619112171; 35 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CVKC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'coolant', (SELECT id FROM engines WHERE code = 'CVKC'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619112171; 35 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CVKC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CVKC'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619112171; 35 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CVKC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'engine_oil', (SELECT id FROM engines WHERE code = 'CVKC'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619112171; 35 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CVKC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'coolant', (SELECT id FROM engines WHERE code = 'CVKC'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619112171; 35 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CVKC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CVKC'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619112171; 35 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CVKC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'engine_oil', (SELECT id FROM engines WHERE code = 'DLVB'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619016993; 35 TFSI MHEV; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DLVB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'coolant', (SELECT id FROM engines WHERE code = 'DLVB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619016993; 35 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DLVB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DLVB'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619016993; 35 TFSI MHEV; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DLVB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'engine_oil', (SELECT id FROM engines WHERE code = 'DLVB'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619016993; 35 TFSI MHEV; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DLVB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'coolant', (SELECT id FROM engines WHERE code = 'DLVB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619016993; 35 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DLVB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DLVB'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619016993; 35 TFSI MHEV; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DLVB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'engine_oil', (SELECT id FROM engines WHERE code = 'DLVB'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619016993; 35 TFSI MHEV; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DLVB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'coolant', (SELECT id FROM engines WHERE code = 'DLVB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619016993; 35 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DLVB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DLVB'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619016993; 35 TFSI MHEV; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DLVB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'engine_oil', (SELECT id FROM engines WHERE code = 'DLVB'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619016993; 35 TFSI MHEV; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DLVB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'coolant', (SELECT id FROM engines WHERE code = 'DLVB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619016993; 35 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DLVB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DLVB'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619016993; 35 TFSI MHEV; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DLVB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'engine_oil', (SELECT id FROM engines WHERE code = 'DEMB'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619107874; 35 TFSI MHEV; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DEMB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'coolant', (SELECT id FROM engines WHERE code = 'DEMB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619107874; 35 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DEMB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DEMB'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619107874; 35 TFSI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DEMB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'engine_oil', (SELECT id FROM engines WHERE code = 'DEMB'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619107874; 35 TFSI MHEV; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DEMB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'coolant', (SELECT id FROM engines WHERE code = 'DEMB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619107874; 35 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DEMB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DEMB'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619107874; 35 TFSI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DEMB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'engine_oil', (SELECT id FROM engines WHERE code = 'DMSB'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619033864; 35 TFSI MHEV; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DMSB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'coolant', (SELECT id FROM engines WHERE code = 'DMSB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619033864; 35 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DMSB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DMSB'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619033864; 35 TFSI MHEV; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DMSB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'engine_oil', (SELECT id FROM engines WHERE code = 'DMSB'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619033864; 35 TFSI MHEV; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DMSB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'coolant', (SELECT id FROM engines WHERE code = 'DMSB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619033864; 35 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DMSB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DMSB'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619033864; 35 TFSI MHEV; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DMSB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'engine_oil', (SELECT id FROM engines WHERE code = 'DTPA'), 5.5, 5.81, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619035146; 40 TDI MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DTPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'coolant', (SELECT id FROM engines WHERE code = 'DTPA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035146; 40 TDI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DTPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DTPA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619035146; 40 TDI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DTPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'engine_oil', (SELECT id FROM engines WHERE code = 'DTPA'), 5.5, 5.81, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619035146; 40 TDI MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DTPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'coolant', (SELECT id FROM engines WHERE code = 'DTPA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035146; 40 TDI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DTPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DTPA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619035146; 40 TDI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DTPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'engine_oil', (SELECT id FROM engines WHERE code = 'DKYA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619017302; 40 TFSI MHEV; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DKYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'coolant', (SELECT id FROM engines WHERE code = 'DKYA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619017302; 40 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DKYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DKYA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619017302; 40 TFSI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DKYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'engine_oil', (SELECT id FROM engines WHERE code = 'DKYA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619017302; 40 TFSI MHEV; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DKYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'coolant', (SELECT id FROM engines WHERE code = 'DKYA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619017302; 40 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DKYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DKYA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619017302; 40 TFSI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DKYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'engine_oil', (SELECT id FROM engines WHERE code = 'DKYA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619017302; 40 TFSI MHEV; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DKYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'coolant', (SELECT id FROM engines WHERE code = 'DKYA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619017302; 40 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DKYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DKYA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619017302; 40 TFSI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DKYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'engine_oil', (SELECT id FROM engines WHERE code = 'DKYA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619017302; 40 TFSI MHEV; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DKYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'coolant', (SELECT id FROM engines WHERE code = 'DKYA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619017302; 40 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DKYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DKYA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619017302; 40 TFSI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DKYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'engine_oil', (SELECT id FROM engines WHERE code = 'DLVA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619016994; 40 TFSI MHEV; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DLVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'coolant', (SELECT id FROM engines WHERE code = 'DLVA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619016994; 40 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DLVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DLVA'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619016994; 40 TFSI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DLVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'engine_oil', (SELECT id FROM engines WHERE code = 'DLVA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619016994; 40 TFSI MHEV; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DLVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'coolant', (SELECT id FROM engines WHERE code = 'DLVA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619016994; 40 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DLVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DLVA'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619016994; 40 TFSI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DLVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'engine_oil', (SELECT id FROM engines WHERE code = 'DLVA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619016994; 40 TFSI MHEV; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DLVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'coolant', (SELECT id FROM engines WHERE code = 'DLVA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619016994; 40 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DLVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DLVA'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619016994; 40 TFSI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DLVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'engine_oil', (SELECT id FROM engines WHERE code = 'DLVA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619016994; 40 TFSI MHEV; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DLVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'coolant', (SELECT id FROM engines WHERE code = 'DLVA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619016994; 40 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DLVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DLVA'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619016994; 40 TFSI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DLVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'engine_oil', (SELECT id FROM engines WHERE code = 'DHDA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619112312; 40 TFSI MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DHDA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'coolant', (SELECT id FROM engines WHERE code = 'DHDA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619112312; 40 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DHDA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DHDA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619112312; 40 TFSI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DHDA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'engine_oil', (SELECT id FROM engines WHERE code = 'DHDA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619112312; 40 TFSI MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DHDA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'coolant', (SELECT id FROM engines WHERE code = 'DHDA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619112312; 40 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DHDA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DHDA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619112312; 40 TFSI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DHDA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'engine_oil', (SELECT id FROM engines WHERE code = 'DRXA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619035145; 40 TFSI g-Tron; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DRXA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'coolant', (SELECT id FROM engines WHERE code = 'DRXA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035145; 40 TFSI g-Tron'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DRXA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DRXA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619035145; 40 TFSI g-Tron; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DRXA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'engine_oil', (SELECT id FROM engines WHERE code = 'DRXA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619035145; 40 TFSI g-Tron; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DRXA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'coolant', (SELECT id FROM engines WHERE code = 'DRXA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035145; 40 TFSI g-Tron'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DRXA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DRXA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619035145; 40 TFSI g-Tron; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DRXA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'engine_oil', (SELECT id FROM engines WHERE code = 'DMSA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619033863; 40 TFSI, MHEV; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DMSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'coolant', (SELECT id FROM engines WHERE code = 'DMSA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619033863; 40 TFSI, MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DMSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DMSA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619033863; 40 TFSI, MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DMSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'engine_oil', (SELECT id FROM engines WHERE code = 'DMSA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619033863; 40 TFSI, MHEV; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DMSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'coolant', (SELECT id FROM engines WHERE code = 'DMSA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619033863; 40 TFSI, MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DMSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DMSA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619033863; 40 TFSI, MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DMSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'engine_oil', (SELECT id FROM engines WHERE code = 'DCPE'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619016907; 45 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DCPE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'coolant', (SELECT id FROM engines WHERE code = 'DCPE'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619016907; 45 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DCPE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'transmission_at', (SELECT id FROM engines WHERE code = 'DCPE'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619016907; 45 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DCPE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'engine_oil', (SELECT id FROM engines WHERE code = 'DCPE'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619016907; 45 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DCPE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'coolant', (SELECT id FROM engines WHERE code = 'DCPE'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619016907; 45 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DCPE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'transmission_at', (SELECT id FROM engines WHERE code = 'DCPE'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619016907; 45 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DCPE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'engine_oil', (SELECT id FROM engines WHERE code = 'DMTA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619035147; 45 TFSI MHEV; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DMTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'coolant', (SELECT id FROM engines WHERE code = 'DMTA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035147; 45 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DMTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DMTA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619035147; 45 TFSI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DMTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'engine_oil', (SELECT id FROM engines WHERE code = 'DMTA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619035147; 45 TFSI MHEV; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DMTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'coolant', (SELECT id FROM engines WHERE code = 'DMTA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035147; 45 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DMTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DMTA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619035147; 45 TFSI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DMTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'engine_oil', (SELECT id FROM engines WHERE code = 'DMTA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619035147; 45 TFSI MHEV; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DMTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'coolant', (SELECT id FROM engines WHERE code = 'DMTA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035147; 45 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DMTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DMTA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619035147; 45 TFSI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DMTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'engine_oil', (SELECT id FROM engines WHERE code = 'DMTA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619035147; 45 TFSI MHEV; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DMTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'coolant', (SELECT id FROM engines WHERE code = 'DMTA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035147; 45 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DMTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DMTA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619035147; 45 TFSI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DMTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'engine_oil', (SELECT id FROM engines WHERE code = 'DLHB'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619017303; 45 TFSI MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DLHB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'coolant', (SELECT id FROM engines WHERE code = 'DLHB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619017303; 45 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DLHB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DLHB'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619017303; 45 TFSI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DLHB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'engine_oil', (SELECT id FROM engines WHERE code = 'DLHB'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619017303; 45 TFSI MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DLHB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'coolant', (SELECT id FROM engines WHERE code = 'DLHB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619017303; 45 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DLHB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DLHB'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619017303; 45 TFSI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DLHB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'engine_oil', (SELECT id FROM engines WHERE code = 'DLHB'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619017303; 45 TFSI MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DLHB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'coolant', (SELECT id FROM engines WHERE code = 'DLHB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619017303; 45 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DLHB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DLHB'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619017303; 45 TFSI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DLHB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'engine_oil', (SELECT id FROM engines WHERE code = 'DLHB'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619017303; 45 TFSI MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DLHB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'coolant', (SELECT id FROM engines WHERE code = 'DLHB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619017303; 45 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DLHB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DLHB'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619017303; 45 TFSI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DLHB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'engine_oil', (SELECT id FROM engines WHERE code = 'DKNA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619013165; 45 TFSI MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DKNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'coolant', (SELECT id FROM engines WHERE code = 'DKNA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619013165; 45 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DKNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DKNA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619013165; 45 TFSI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DKNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'engine_oil', (SELECT id FROM engines WHERE code = 'DKNA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619013165; 45 TFSI MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DKNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'coolant', (SELECT id FROM engines WHERE code = 'DKNA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619013165; 45 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DKNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DKNA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619013165; 45 TFSI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DKNA'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 24, 'brake_fluid', NULL, 1, 1.06, NULL, 'VW 501 14', 'HaynesPro chassis d_317000026; Alt: DOT 4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 24 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 149, 'brake_fluid', NULL, 1, 1.06, NULL, 'VW 501 14', 'HaynesPro chassis d_317000026; Alt: DOT 4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 149 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 150, 'brake_fluid', NULL, 1, 1.06, NULL, 'VW 501 14', 'HaynesPro chassis d_317000026; Alt: DOT 4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 150 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 151, 'brake_fluid', NULL, 1, 1.06, NULL, 'VW 501 14', 'HaynesPro chassis d_317000026; Alt: DOT 4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 151 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (24, 149, 150, 151)
  AND e.code IN ('CVNA', 'CVLA', 'DESA', 'DETA', 'DFVA', 'CZHA', 'DEUA', 'DEUB', 'DEUC', 'DETB', 'CYMC', 'CYRB', 'CYRC', 'CVKB', 'DBPA', 'DEMA', 'DDWA', 'DDWB', 'CRTC', 'CSWB', 'DCPC', 'DMGA', 'DEZB', 'DTNB', 'DEZE', 'DTNA', 'CVKC', 'DLVB', 'DEMB', 'DMSB', 'DTPA', 'DKYA', 'DLVA', 'DHDA', 'DRXA', 'DMSA', 'DCPE', 'DMTA', 'DLHB', 'DKNA')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (24, 149, 150, 151)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (24, 149, 150, 151) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;