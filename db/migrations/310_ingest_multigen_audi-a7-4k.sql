-- mig 310 — multi-gen HaynesPro ingest: Audi A7 (4K)
-- crawl: haynespro-crawl-audi-a7-4k-2026-05-23.json
-- modelId: d_319001691
-- 25 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Audi A7 (4K)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319001691', NOW(), 'Multi-gen ingest, 25 engines across 2 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319001691' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('DFBA', '40 TDI (DFBA) 150kW', 1968, 'diesel', 'turbo', NULL),
  ('DTPA', '40 TDI (DTPA) 150kW', 1968, 'diesel', 'turbo', NULL),
  ('DTPB', '40 TDI (DTPB) 120kW', 1968, 'diesel', 'turbo', NULL),
  ('DMTC', '40 TFSI (DMTC) 150kW', 1984, 'petrol', 'turbo', NULL),
  ('DLHC', '40 TFSI (DLHC) 140kW', 1984, 'petrol', 'turbo', NULL),
  ('DDVF', '45 TDI (DDVF) 155kW', 2967, 'diesel', 'turbo', NULL),
  ('DDVE', '45 TDI (DDVE) 170kW', 2967, 'diesel', 'turbo', NULL),
  ('CVMD', '45 TDI (CVMD) 183kW', 2967, 'diesel', 'turbo', NULL),
  ('DMGH', '45 TDI (DMGH) 180kW', 2967, 'diesel', 'turbo', NULL),
  ('DKNA', '45 TFSI (DKNA) 180kW', 1984, 'petrol', 'turbo', NULL),
  ('DLHA', '45 TFSI (DLHA) 180kW', 1984, 'petrol', 'turbo', NULL),
  ('DMTA', '45 TFSI (DMTA) 195kW', 1984, 'petrol', 'turbo', NULL),
  ('DPAA', '45 TFSI (DPAA) 195kW', 1984, 'petrol', 'turbo', NULL),
  ('DDVB', '50 TDI (DDVB) 210kW', 2967, 'diesel', 'turbo', NULL),
  ('DMGA', '50 TDI (DMGA) 210kW', 2967, 'diesel', 'turbo', NULL),
  ('DLGA', '50 TFSI e (DLGA) 220kW', 1984, 'hybrid', 'turbo', NULL),
  ('DRYA', '50 TFSI e (DRYA) 230kW', 1984, 'hybrid', 'turbo', NULL),
  ('DLZA', '55 TFSI (DLZA) 250kW', 2995, 'petrol', 'turbo', NULL),
  ('DJPB', 'RS7 (4.0 V8 TFSI) (DJPB) 441kW', 3996, 'petrol', 'turbo', NULL),
  ('DYGA', 'RS7 (4.0 V8) (DYGA) 463kW', 3996, 'petrol', 'NA', NULL),
  ('DYGB', 'RS7 (4.0 V8) (DYGB) 441kW', 3996, 'petrol', 'NA', NULL),
  ('DWLA', 'RS7 (4.0 V8) (DWLA) 441kW', 3996, 'petrol', 'NA', NULL),
  ('DKMB', 'S7 (2.9 TFSI) (DKMB) 331kW', 2894, 'petrol', 'turbo', NULL),
  ('DEWA', 'S7 (3.0 TDI) (DEWA) 257kW', 2967, 'diesel', 'turbo', NULL),
  ('DMKD', 'S7 (3.0 TDI) (DMKD) 253kW', 2967, 'diesel', 'turbo', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'engine_oil', (SELECT id FROM engines WHERE code = 'DFBA'), 5.5, 5.81, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619013173; 40 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DFBA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'coolant', (SELECT id FROM engines WHERE code = 'DFBA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619013173; 40 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DFBA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DFBA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619013173; 40 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DFBA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'engine_oil', (SELECT id FROM engines WHERE code = 'DTPA'), 5.5, 5.81, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619035888; 40 TDI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DTPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'coolant', (SELECT id FROM engines WHERE code = 'DTPA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035888; 40 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DTPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DTPA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619035888; 40 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DTPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'engine_oil', (SELECT id FROM engines WHERE code = 'DTPB'), 5.5, 5.81, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619039542; 40 TDI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DTPB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'coolant', (SELECT id FROM engines WHERE code = 'DTPB'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619039542; 40 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DTPB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DTPB'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619039542; 40 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DTPB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'engine_oil', (SELECT id FROM engines WHERE code = 'DMTC'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619035886; 40 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DMTC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'coolant', (SELECT id FROM engines WHERE code = 'DMTC'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035886; 40 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DMTC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DMTC'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619035886; 40 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DMTC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'engine_oil', (SELECT id FROM engines WHERE code = 'DLHC'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619035881; 40 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DLHC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'coolant', (SELECT id FROM engines WHERE code = 'DLHC'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035881; 40 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DLHC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DLHC'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619035881; 40 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DLHC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'engine_oil', (SELECT id FROM engines WHERE code = 'DDVF'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619017312; 45 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DDVF'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'coolant', (SELECT id FROM engines WHERE code = 'DDVF'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619017312; 45 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DDVF'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'transmission_at', (SELECT id FROM engines WHERE code = 'DDVF'), 8.6, 9.09, NULL, 'VW G 060 190 A2', 'HaynesPro typeId t_619017312; 45 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DDVF'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'engine_oil', (SELECT id FROM engines WHERE code = 'DDVE'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319007828; 45 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DDVE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'coolant', (SELECT id FROM engines WHERE code = 'DDVE'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319007828; 45 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DDVE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'transmission_at', (SELECT id FROM engines WHERE code = 'DDVE'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_319007828; 45 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DDVE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'engine_oil', (SELECT id FROM engines WHERE code = 'CVMD'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619117201; 45 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CVMD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'coolant', (SELECT id FROM engines WHERE code = 'CVMD'), 15, 15.85, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619117201; 45 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CVMD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'transmission_at', (SELECT id FROM engines WHERE code = 'CVMD'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619117201; 45 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CVMD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'engine_oil', (SELECT id FROM engines WHERE code = 'DMGH'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619035882; 45 TDI; drain 35 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DMGH'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'coolant', (SELECT id FROM engines WHERE code = 'DMGH'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035882; 45 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DMGH'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DMGH'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619035882; 45 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DMGH'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'engine_oil', (SELECT id FROM engines WHERE code = 'DKNA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_319007831; 45 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DKNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'coolant', (SELECT id FROM engines WHERE code = 'DKNA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319007831; 45 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DKNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DKNA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_319007831; 45 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DKNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'engine_oil', (SELECT id FROM engines WHERE code = 'DLHA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_319007833; 45 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DLHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'coolant', (SELECT id FROM engines WHERE code = 'DLHA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319007833; 45 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DLHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DLHA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_319007833; 45 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DLHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'engine_oil', (SELECT id FROM engines WHERE code = 'DMTA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619035885; 45 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DMTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'coolant', (SELECT id FROM engines WHERE code = 'DMTA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035885; 45 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DMTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DMTA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619035885; 45 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DMTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'engine_oil', (SELECT id FROM engines WHERE code = 'DPAA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619035879; 45 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DPAA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'coolant', (SELECT id FROM engines WHERE code = 'DPAA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035879; 45 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DPAA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DPAA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619035879; 45 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DPAA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'engine_oil', (SELECT id FROM engines WHERE code = 'DDVB'), NULL, NULL, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319007802; 50 TDI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DDVB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'coolant', (SELECT id FROM engines WHERE code = 'DDVB'), NULL, NULL, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319007802; 50 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DDVB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'transmission_at', (SELECT id FROM engines WHERE code = 'DDVB'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_319007802; 50 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DDVB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'engine_oil', (SELECT id FROM engines WHERE code = 'DMGA'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619035883; 50 TDI; drain 35 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DMGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'coolant', (SELECT id FROM engines WHERE code = 'DMGA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035883; 50 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DMGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'transmission_at', (SELECT id FROM engines WHERE code = 'DMGA'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619035883; 50 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DMGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'engine_oil', (SELECT id FROM engines WHERE code = 'DLGA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619028751; 50 TFSI e; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DLGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'coolant', (SELECT id FROM engines WHERE code = 'DLGA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619028751; 50 TFSI e'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DLGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DLGA'), 6.4, 6.76, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619028751; 50 TFSI e; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DLGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'engine_oil', (SELECT id FROM engines WHERE code = 'DRYA'), 5.2, 5.49, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619035884; 50 TFSI e; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DRYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'coolant', (SELECT id FROM engines WHERE code = 'DRYA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035884; 50 TFSI e'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DRYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DRYA'), 6.4, 6.76, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619035884; 50 TFSI e; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DRYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'engine_oil', (SELECT id FROM engines WHERE code = 'DLZA'), 7.6, 8.03, '0W-20', 'VW 508 00', 'HaynesPro typeId t_319007827; 55 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DLZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'coolant', (SELECT id FROM engines WHERE code = 'DLZA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319007827; 55 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DLZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DLZA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_319007827; 55 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DLZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 286, 'engine_oil', (SELECT id FROM engines WHERE code = 'DJPB'), 9.5, 10.04, '0W-40', 'VW 511 00', 'HaynesPro typeId t_619028752; RS7 (4.0 V8 TFSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 286 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DJPB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 286, 'coolant', (SELECT id FROM engines WHERE code = 'DJPB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619028752; RS7 (4.0 V8 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 286 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DJPB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 286, 'transmission_at', (SELECT id FROM engines WHERE code = 'DJPB'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_619028752; RS7 (4.0 V8 TFSI); Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 286 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DJPB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 286, 'engine_oil', (SELECT id FROM engines WHERE code = 'DYGA'), 9.5, 10.04, '0W-40', 'VW 511 00', 'HaynesPro typeId t_619115636; RS7 (4.0 V8); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 286 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DYGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 286, 'engine_oil', (SELECT id FROM engines WHERE code = 'DYGB'), 9.5, 10.04, '0W-40', 'VW 511 00', 'HaynesPro typeId t_619115635; RS7 (4.0 V8); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 286 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DYGB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 286, 'engine_oil', (SELECT id FROM engines WHERE code = 'DWLA'), 9.5, 10.04, '0W-40', 'VW 511 00', 'HaynesPro typeId t_619116170; RS7 (4.0 V8); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 286 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DWLA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 286, 'coolant', (SELECT id FROM engines WHERE code = 'DWLA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619116170; RS7 (4.0 V8)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 286 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DWLA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 286, 'transmission_at', (SELECT id FROM engines WHERE code = 'DWLA'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_619116170; RS7 (4.0 V8); Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 286 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DWLA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'engine_oil', (SELECT id FROM engines WHERE code = 'DKMB'), 7.6, 8.03, '0W-30', 'VW 504 00', 'HaynesPro typeId t_319007830; S7 (2.9 TFSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DKMB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'coolant', (SELECT id FROM engines WHERE code = 'DKMB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319007830; S7 (2.9 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DKMB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'transmission_at', (SELECT id FROM engines WHERE code = 'DKMB'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_319007830; S7 (2.9 TFSI); Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DKMB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'engine_oil', (SELECT id FROM engines WHERE code = 'DEWA'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319007829; S7 (3.0 TDI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DEWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'coolant', (SELECT id FROM engines WHERE code = 'DEWA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319007829; S7 (3.0 TDI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DEWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'transmission_at', (SELECT id FROM engines WHERE code = 'DEWA'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_319007829; S7 (3.0 TDI); Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DEWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'engine_oil', (SELECT id FROM engines WHERE code = 'DMKD'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619035880; S7 (3.0 TDI); drain 35 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DMKD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'coolant', (SELECT id FROM engines WHERE code = 'DMKD'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035880; S7 (3.0 TDI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DMKD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'transmission_at', (SELECT id FROM engines WHERE code = 'DMKD'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619035880; S7 (3.0 TDI); Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DMKD'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 285, 'brake_fluid', NULL, 1, 1.06, NULL, 'VW 501 14', 'HaynesPro chassis d_319001691; Alt: DOT 4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 285 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 286, 'brake_fluid', NULL, 1, 1.06, NULL, 'VW 501 14', 'HaynesPro chassis d_319001691; Alt: DOT 4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 286 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (285, 286)
  AND e.code IN ('DFBA', 'DTPA', 'DTPB', 'DMTC', 'DLHC', 'DDVF', 'DDVE', 'CVMD', 'DMGH', 'DKNA', 'DLHA', 'DMTA', 'DPAA', 'DDVB', 'DMGA', 'DLGA', 'DRYA', 'DLZA', 'DJPB', 'DYGA', 'DYGB', 'DWLA', 'DKMB', 'DEWA', 'DMKD')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (285, 286)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (285, 286) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;