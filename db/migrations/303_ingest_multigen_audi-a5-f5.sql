-- mig 303 — multi-gen HaynesPro ingest: Audi A5 (F5)
-- crawl: haynespro-crawl-audi-a5-f5-2026-05-23.json
-- modelId: d_319000522
-- 40 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Audi A5 (F5)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319000522', NOW(), 'Multi-gen ingest, 40 engines across 2 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319000522' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('CVNA', '1.4 TFSI (CVNA) 110kW', 1395, 'petrol', 'turbo', NULL),
  ('DESA', '2.0 TDI (DESA) 140kW', 1968, 'diesel', 'turbo', NULL),
  ('DETA', '2.0 TDI (DETA) 140kW', 1968, 'diesel', 'turbo', NULL),
  ('DEUA', '2.0 TDI (DEUA) 110kW', 1968, 'diesel', 'turbo', NULL),
  ('DEUB', '2.0 TDI (DEUB) 100kW', 1968, 'diesel', 'turbo', NULL),
  ('DTPA', '2.0 TDI MHEV (DTPA) 150kW', 1968, 'hybrid', 'turbo', NULL),
  ('CYMC', '2.0 TFSI (CYMC) 185kW', 1984, 'petrol', 'turbo', NULL),
  ('CYRB', '2.0 TFSI (CYRB) 185kW', 1984, 'petrol', 'turbo', NULL),
  ('CYRC', '2.0 TFSI (CYRC) 183kW', 1984, 'petrol', 'turbo', NULL),
  ('CVKB', '2.0 TFSI (CVKB) 140kW', 1984, 'petrol', 'turbo', NULL),
  ('CVLA', '2.0 TFSI g-tron (CVLA) 125kW', 1984, 'petrol', 'turbo', NULL),
  ('DDWA', '2.0 TFSI, MHEV (DDWA) 185kW', 1984, 'hybrid', 'turbo', NULL),
  ('DCPC', '3.0 TDI (DCPC) 210kW', 2967, 'diesel', 'turbo', NULL),
  ('CRTC', '3.0 TDI (CRTC) 200kW', 2967, 'diesel', 'turbo', NULL),
  ('CSWB', '3.0 TDI (CSWB) 160kW', 2967, 'diesel', 'turbo', NULL),
  ('DEZB', '30 TDI MHEV (DEZB) 100kW', 1968, 'hybrid', 'turbo', NULL),
  ('DTNB', '30 TDI MHEV (DTNB) 100kW', 1968, 'hybrid', 'turbo', NULL),
  ('DTNA', '35 TDI MHEV (DTNA) 120kW', 1968, 'hybrid', 'turbo', NULL),
  ('DEZE', '35 TDI, MHEV (DEZE) 120kW', 1968, 'hybrid', 'turbo', NULL),
  ('DEMB', '35 TFSI (DEMB) 110kW', 1984, 'petrol', 'turbo', NULL),
  ('CVKC', '35 TFSI (CVKC) 110kW', 1984, 'petrol', 'turbo', NULL),
  ('DLVB', '35 TFSI MHEV (DLVB) 110kW', 1984, 'hybrid', 'turbo', NULL),
  ('DMSB', '35 TFSI MHEV (DMSB) 110kW', 1984, 'hybrid', 'turbo', NULL),
  ('DEMA', '40 TFSI MHEV (DEMA) 140kW', 1984, 'hybrid', 'turbo', NULL),
  ('DHDA', '40 TFSI MHEV (DHDA) 140kW', 1984, 'hybrid', 'turbo', NULL),
  ('DLVA', '40 TFSI MHEV (DLVA) 140kW', 1984, 'hybrid', 'turbo', NULL),
  ('DKYA', '40 TFSI, MHEV (DKYA) 140kW', 1984, 'hybrid', 'turbo', NULL),
  ('DMSA', '40 TFSI, MHEV (DMSA) 150kW', 1984, 'hybrid', 'turbo', NULL),
  ('DRXA', '40 g-tron (DRXA) 125kW', 1984, 'petrol', 'NA', NULL),
  ('DCPE', '45 TDI (DCPE) 170kW', 2967, 'diesel', 'turbo', NULL),
  ('DKNA', '45 TFSI MHEV (DKNA) 180kW', 1984, 'hybrid', 'turbo', NULL),
  ('DMTA', '45 TFSI MHEV (DMTA) 195kW', 1984, 'hybrid', 'turbo', NULL),
  ('DPAA', '45 TFSI MHEV (DPAA) 195kW', 1984, 'hybrid', 'turbo', NULL),
  ('DDWB', '45 TFSI MHEV (DDWB) 183kW', 1984, 'hybrid', 'turbo', NULL),
  ('DLHB', '45 TFSI, MHEV (DLHB) 185kW', 1984, 'hybrid', 'turbo', NULL),
  ('DMGA', '50 TDI (DMGA) 210kW', 2967, 'diesel', 'turbo', NULL),
  ('DECA', 'RS5 (2.9 TFSI) (DECA) 331kW', 2894, 'petrol', 'turbo', NULL),
  ('DEWB', 'S5 (3.0 TDI) MHEV (DEWB) 255kW', 2967, 'hybrid', 'turbo', NULL),
  ('DMKC', 'S5 (3.0 TDI) MHEV (DMKC) 251kW', 2967, 'hybrid', 'turbo', NULL),
  ('CWGD', 'S5 (3.0 TFSI) (CWGD) 260kW', 2995, 'petrol', 'turbo', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'engine_oil', (SELECT id FROM engines WHERE code = 'CVNA'), 4.3, 4.54, '0W-30', 'VW 502 00', 'HaynesPro typeId t_319004608; 1.4 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CVNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'coolant', (SELECT id FROM engines WHERE code = 'CVNA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319004608; 1.4 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CVNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CVNA'), 3.8, 4.02, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_319004608; 1.4 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CVNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'engine_oil', (SELECT id FROM engines WHERE code = 'DESA'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319005443; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DESA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'coolant', (SELECT id FROM engines WHERE code = 'DESA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319005443; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DESA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DESA'), 3.8, 4.02, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_319005443; 2.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DESA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'engine_oil', (SELECT id FROM engines WHERE code = 'DETA'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319004590; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DETA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'coolant', (SELECT id FROM engines WHERE code = 'DETA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319004590; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DETA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DETA'), 1.8, 1.9, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_319004590; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DETA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'engine_oil', (SELECT id FROM engines WHERE code = 'DEUA'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319005464; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'coolant', (SELECT id FROM engines WHERE code = 'DEUA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319005464; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DEUA'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_319005464; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'engine_oil', (SELECT id FROM engines WHERE code = 'DEUB'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319007391; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'coolant', (SELECT id FROM engines WHERE code = 'DEUB'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319007391; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DEUB'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_319007391; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DEUB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'coolant', (SELECT id FROM engines WHERE code = 'DTPA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035148; 2.0 TDI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DTPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DTPA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619035148; 2.0 TDI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DTPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'engine_oil', (SELECT id FROM engines WHERE code = 'CYMC'), 5.2, 5.49, '0W-30', 'VW 502 00', 'HaynesPro typeId t_319004610; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CYMC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'coolant', (SELECT id FROM engines WHERE code = 'CYMC'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319004610; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CYMC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CYMC'), 3.8, 4.02, NULL, 'VW G 055 549 A2', 'HaynesPro typeId t_319004610; 2.0 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CYMC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'engine_oil', (SELECT id FROM engines WHERE code = 'CYRB'), 5.2, 5.49, '0W-30', 'VW 504 00', 'HaynesPro typeId t_319001161; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CYRB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'coolant', (SELECT id FROM engines WHERE code = 'CYRB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319001161; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CYRB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CYRB'), 1.8, 1.9, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_319001161; 2.0 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CYRB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'engine_oil', (SELECT id FROM engines WHERE code = 'CYRC'), 5.2, 5.49, '0W-30', 'VW 502 00', 'HaynesPro typeId t_319005461; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CYRC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'coolant', (SELECT id FROM engines WHERE code = 'CYRC'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319005461; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CYRC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CYRC'), 3.8, 4.02, NULL, 'VW G 055 549 A2', 'HaynesPro typeId t_319005461; 2.0 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CYRC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'engine_oil', (SELECT id FROM engines WHERE code = 'CVKB'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_319004589; 2.0 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CVKB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'coolant', (SELECT id FROM engines WHERE code = 'CVKB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319004589; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CVKB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CVKB'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_319004589; 2.0 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CVKB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'engine_oil', (SELECT id FROM engines WHERE code = 'CVLA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_319005460; 2.0 TFSI g-tron; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CVLA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'coolant', (SELECT id FROM engines WHERE code = 'CVLA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319005460; 2.0 TFSI g-tron'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CVLA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CVLA'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_319005460; 2.0 TFSI g-tron; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CVLA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'engine_oil', (SELECT id FROM engines WHERE code = 'DDWA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_319005754; 2.0 TFSI, MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DDWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'coolant', (SELECT id FROM engines WHERE code = 'DDWA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319005754; 2.0 TFSI, MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DDWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DDWA'), 1.8, 1.9, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_319005754; 2.0 TFSI, MHEV; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DDWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'engine_oil', (SELECT id FROM engines WHERE code = 'DCPC'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319004611; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DCPC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'coolant', (SELECT id FROM engines WHERE code = 'DCPC'), 13, 13.74, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319004611; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DCPC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'transmission_at', (SELECT id FROM engines WHERE code = 'DCPC'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_319004611; 3.0 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DCPC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'engine_oil', (SELECT id FROM engines WHERE code = 'CRTC'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319004607; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CRTC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'coolant', (SELECT id FROM engines WHERE code = 'CRTC'), 13, 13.74, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319004607; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CRTC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'transmission_at', (SELECT id FROM engines WHERE code = 'CRTC'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_319004607; 3.0 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CRTC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'engine_oil', (SELECT id FROM engines WHERE code = 'CSWB'), 6.1, 6.45, '0W-20', 'VW 509 00', 'HaynesPro typeId t_319004591; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CSWB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'coolant', (SELECT id FROM engines WHERE code = 'CSWB'), 13, 13.74, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319004591; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CSWB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CSWB'), 3.8, 4.02, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_319004591; 3.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CSWB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'coolant', (SELECT id FROM engines WHERE code = 'DEZB'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619031057; 30 TDI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DEZB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DEZB'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619031057; 30 TDI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DEZB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'engine_oil', (SELECT id FROM engines WHERE code = 'DTNB'), 5.5, 5.81, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619035644; 30 TDI MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DTNB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'coolant', (SELECT id FROM engines WHERE code = 'DTNB'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035644; 30 TDI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DTNB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DTNB'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619035644; 30 TDI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DTNB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'engine_oil', (SELECT id FROM engines WHERE code = 'DTNA'), 5.5, 5.81, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619035643; 35 TDI MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DTNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'coolant', (SELECT id FROM engines WHERE code = 'DTNA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035643; 35 TDI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DTNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DTNA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619035643; 35 TDI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DTNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'engine_oil', (SELECT id FROM engines WHERE code = 'DEZE'), 5.5, 5.81, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619008015; 35 TDI, MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DEZE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'coolant', (SELECT id FROM engines WHERE code = 'DEZE'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619008015; 35 TDI, MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DEZE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DEZE'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619008015; 35 TDI, MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DEZE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'engine_oil', (SELECT id FROM engines WHERE code = 'DEMB'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619043726; 35 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DEMB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'coolant', (SELECT id FROM engines WHERE code = 'DEMB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619043726; 35 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DEMB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DEMB'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619043726; 35 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DEMB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'engine_oil', (SELECT id FROM engines WHERE code = 'CVKC'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619043725; 35 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CVKC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'coolant', (SELECT id FROM engines WHERE code = 'CVKC'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619043725; 35 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CVKC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CVKC'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619043725; 35 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CVKC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'engine_oil', (SELECT id FROM engines WHERE code = 'DLVB'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619008013; 35 TFSI MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DLVB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'coolant', (SELECT id FROM engines WHERE code = 'DLVB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619008013; 35 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DLVB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DLVB'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619008013; 35 TFSI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DLVB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'coolant', (SELECT id FROM engines WHERE code = 'DMSB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035641; 35 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DMSB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DMSB'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619035641; 35 TFSI MHEV; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DMSB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'engine_oil', (SELECT id FROM engines WHERE code = 'DEMA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619008010; 40 TFSI MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DEMA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'coolant', (SELECT id FROM engines WHERE code = 'DEMA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619008010; 40 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DEMA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DEMA'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619008010; 40 TFSI MHEV; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DEMA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'engine_oil', (SELECT id FROM engines WHERE code = 'DHDA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619008011; 40 TFSI MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DHDA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'coolant', (SELECT id FROM engines WHERE code = 'DHDA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619008011; 40 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DHDA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DHDA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619008011; 40 TFSI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DHDA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'engine_oil', (SELECT id FROM engines WHERE code = 'DLVA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619008012; 40 TFSI MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DLVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'coolant', (SELECT id FROM engines WHERE code = 'DLVA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619008012; 40 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DLVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DLVA'), 2.5, 2.64, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619008012; 40 TFSI MHEV; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DLVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'coolant', (SELECT id FROM engines WHERE code = 'DKYA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619017304; 40 TFSI, MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DKYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DKYA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619017304; 40 TFSI, MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DKYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'coolant', (SELECT id FROM engines WHERE code = 'DMSA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619029267; 40 TFSI, MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DMSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DMSA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619029267; 40 TFSI, MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DMSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'coolant', (SELECT id FROM engines WHERE code = 'DRXA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619029270; 40 g-tron'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DRXA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DRXA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619029270; 40 g-tron; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DRXA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'engine_oil', (SELECT id FROM engines WHERE code = 'DCPE'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619019690; 45 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DCPE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'coolant', (SELECT id FROM engines WHERE code = 'DCPE'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619019690; 45 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DCPE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'transmission_at', (SELECT id FROM engines WHERE code = 'DCPE'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619019690; 45 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DCPE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'engine_oil', (SELECT id FROM engines WHERE code = 'DKNA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619008014; 45 TFSI MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DKNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'coolant', (SELECT id FROM engines WHERE code = 'DKNA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619008014; 45 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DKNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DKNA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619008014; 45 TFSI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DKNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'coolant', (SELECT id FROM engines WHERE code = 'DMTA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619029268; 45 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DMTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DMTA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619029268; 45 TFSI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DMTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'coolant', (SELECT id FROM engines WHERE code = 'DPAA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619029269; 45 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DPAA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DPAA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619029269; 45 TFSI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DPAA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'coolant', (SELECT id FROM engines WHERE code = 'DDWB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619029265; 45 TFSI MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DDWB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DDWB'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619029265; 45 TFSI MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DDWB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'engine_oil', (SELECT id FROM engines WHERE code = 'DLHB'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619017305; 45 TFSI, MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DLHB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'coolant', (SELECT id FROM engines WHERE code = 'DLHB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619017305; 45 TFSI, MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DLHB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DLHB'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619017305; 45 TFSI, MHEV; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DLHB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'engine_oil', (SELECT id FROM engines WHERE code = 'DMGA'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619029266; 50 TDI; drain 35 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DMGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'coolant', (SELECT id FROM engines WHERE code = 'DMGA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619029266; 50 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DMGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'transmission_at', (SELECT id FROM engines WHERE code = 'DMGA'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619029266; 50 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DMGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 276, 'engine_oil', (SELECT id FROM engines WHERE code = 'DECA'), 7.6, 8.03, '0W-30', 'VW 504 00', 'HaynesPro typeId t_319005462; RS5 (2.9 TFSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 276 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DECA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 276, 'coolant', (SELECT id FROM engines WHERE code = 'DECA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319005462; RS5 (2.9 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 276 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DECA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 276, 'transmission_at', (SELECT id FROM engines WHERE code = 'DECA'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_319005462; RS5 (2.9 TFSI); Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 276 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DECA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'engine_oil', (SELECT id FROM engines WHERE code = 'DEWB'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619024245; S5 (3.0 TDI) MHEV; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DEWB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'coolant', (SELECT id FROM engines WHERE code = 'DEWB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619024245; S5 (3.0 TDI) MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DEWB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'transmission_at', (SELECT id FROM engines WHERE code = 'DEWB'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619024245; S5 (3.0 TDI) MHEV; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DEWB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'engine_oil', (SELECT id FROM engines WHERE code = 'DMKC'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619035642; S5 (3.0 TDI) MHEV; drain 35 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DMKC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'coolant', (SELECT id FROM engines WHERE code = 'DMKC'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035642; S5 (3.0 TDI) MHEV'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DMKC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'transmission_at', (SELECT id FROM engines WHERE code = 'DMKC'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619035642; S5 (3.0 TDI) MHEV; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DMKC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'engine_oil', (SELECT id FROM engines WHERE code = 'CWGD'), 7.5, 7.93, '0W-20', 'VW 508 00', 'HaynesPro typeId t_319004588; S5 (3.0 TFSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CWGD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'coolant', (SELECT id FROM engines WHERE code = 'CWGD'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319004588; S5 (3.0 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CWGD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'transmission_at', (SELECT id FROM engines WHERE code = 'CWGD'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_319004588; S5 (3.0 TFSI); Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CWGD'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 275, 'brake_fluid', NULL, 1, 1.06, NULL, 'VW 501 14', 'HaynesPro chassis d_319000522; Alt: DOT 4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 275 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 276, 'brake_fluid', NULL, 1, 1.06, NULL, 'VW 501 14', 'HaynesPro chassis d_319000522; Alt: DOT 4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 276 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (275, 276)
  AND e.code IN ('CVNA', 'DESA', 'DETA', 'DEUA', 'DEUB', 'DTPA', 'CYMC', 'CYRB', 'CYRC', 'CVKB', 'CVLA', 'DDWA', 'DCPC', 'CRTC', 'CSWB', 'DEZB', 'DTNB', 'DTNA', 'DEZE', 'DEMB', 'CVKC', 'DLVB', 'DMSB', 'DEMA', 'DHDA', 'DLVA', 'DKYA', 'DMSA', 'DRXA', 'DCPE', 'DKNA', 'DMTA', 'DPAA', 'DDWB', 'DLHB', 'DMGA', 'DECA', 'DEWB', 'DMKC', 'CWGD')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (275, 276)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (275, 276) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;