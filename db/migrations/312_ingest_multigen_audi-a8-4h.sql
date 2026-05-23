-- mig 312 — multi-gen HaynesPro ingest: Audi A8 (4H)
-- crawl: haynespro-crawl-audi-a8-4h-2026-05-23.json
-- modelId: d_102000172
-- 30 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Audi A8 (4H)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_102000172', NOW(), 'Multi-gen ingest, 30 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_102000172' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('CHJA', '2.0 TFSI Hybrid (CHJA) 180kW', 1984, 'petrol', 'turbo', NULL),
  ('CDTA', '3.0 TDI (CDTA) 184kW', 2967, 'diesel', 'turbo', NULL),
  ('CDTB', '3.0 TDI (CDTB) 155kW', 2967, 'diesel', 'turbo', NULL),
  ('CLAB', '3.0 TDI (CLAB) 150kW', 2967, 'diesel', 'turbo', NULL),
  ('CMHA', '3.0 TDI (CMHA) 184kW', 2967, 'diesel', 'turbo', NULL),
  ('CPNA', '3.0 TDI (CPNA) 176kW', 2967, 'diesel', 'turbo', NULL),
  ('CTBA', '3.0 TDI (CTBA) 190kW', 2967, 'diesel', 'turbo', NULL),
  ('CDTC', '3.0 TDI (CDTC) 183kW', 2967, 'diesel', 'turbo', NULL),
  ('CPNB', '3.0 TDI (CPNB) 176kW', 2967, 'diesel', 'turbo', NULL),
  ('CTBB', '3.0 TDI (CTBB) 155kW', 2967, 'diesel', 'turbo', NULL),
  ('CTBD', '3.0 TDI (CTBD) 193kW', 2967, 'diesel', 'turbo', NULL),
  ('CGXC', '3.0 TFSI (CGXC) 245kW', 2995, 'petrol', 'turbo', NULL),
  ('CMDA', '3.0 TFSI (CMDA) 245kW', 2995, 'petrol', 'turbo', NULL),
  ('CGWA', '3.0 TFSI (CGWA) 213kW', 2995, 'petrol', 'turbo', NULL),
  ('CTUB', '3.0 TFSI (CTUB) 245kW', 2995, 'petrol', 'turbo', NULL),
  ('CGWD', '3.0 TFSI (CGWD) 228kW', 2995, 'petrol', 'turbo', NULL),
  ('CREC', '3.0 TFSI (CREC) 244kW', 2995, 'petrol', 'turbo', NULL),
  ('CTDA', '3.0 TFSI (CTDA) 244kW', 2995, 'petrol', 'turbo', NULL),
  ('CREA', '3.0 TFSI (CREA) 228kW', 2995, 'petrol', 'turbo', NULL),
  ('CREG', '3.0 TFSI (CREG) 213kW', 2995, 'petrol', 'turbo', NULL),
  ('CEUA', '4.0 TFSI (CEUA) 309kW', 3999, 'petrol', 'turbo', NULL),
  ('CTGA', '4.0 TFSI (CTGA) 320kW', 3993, 'petrol', 'turbo', NULL),
  ('CDRA', '4.2 FSi (CDRA) 273kW', 4163, 'petrol', 'NA', NULL),
  ('CDSB', '4.2 TDI (CDSB) 258kW', 4134, 'diesel', 'turbo', NULL),
  ('CTEC', '4.2 TDI (CTEC) 283kW', 4134, 'diesel', 'turbo', NULL),
  ('CEJA', '6.3 W12 (CEJA) 368kW', 6299, 'petrol', 'NA', NULL),
  ('CTNA', '6.3 W12 (CTNA) 368kW', 6299, 'petrol', 'NA', NULL),
  ('CGTA', 'S8 (4.0 TFSI) (CGTA) 382kW', 3999, 'petrol', 'turbo', NULL),
  ('CTFA', 'S8 (4.0 TFSI) (CTFA) 382kW', 3993, 'petrol', 'turbo', NULL),
  ('DDTA', 'S8 (4.0 TFSI) (DDTA) 445kW', 3993, 'petrol', 'turbo', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'engine_oil', (SELECT id FROM engines WHERE code = 'CHJA'), 4.6, 4.86, '5W-40', 'VW 502 00', 'HaynesPro typeId t_300000285; 2.0 TFSI Hybrid; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CHJA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'coolant', (SELECT id FROM engines WHERE code = 'CHJA'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_300000285; 2.0 TFSI Hybrid'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CHJA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'transmission_at', (SELECT id FROM engines WHERE code = 'CHJA'), 4, 4.23, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_300000285; 2.0 TFSI Hybrid; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CHJA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'engine_oil', (SELECT id FROM engines WHERE code = 'CDTA'), 6.4, 6.76, '5W-30', 'VW 507 00', 'HaynesPro typeId t_102001653; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CDTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'coolant', (SELECT id FROM engines WHERE code = 'CDTA'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102001653; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CDTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'transmission_at', (SELECT id FROM engines WHERE code = 'CDTA'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_102001653; 3.0 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CDTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'engine_oil', (SELECT id FROM engines WHERE code = 'CDTB'), 6.4, 6.76, '5W-30', 'VW 507 00', 'HaynesPro typeId t_300000286; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CDTB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'coolant', (SELECT id FROM engines WHERE code = 'CDTB'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_300000286; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CDTB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'transmission_at', (SELECT id FROM engines WHERE code = 'CDTB'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_300000286; 3.0 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CDTB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'engine_oil', (SELECT id FROM engines WHERE code = 'CLAB'), 6.4, 6.76, '5W-30', 'VW 507 00', 'HaynesPro typeId t_300000280; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CLAB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'coolant', (SELECT id FROM engines WHERE code = 'CLAB'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_300000280; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CLAB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'transmission_at', (SELECT id FROM engines WHERE code = 'CLAB'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_300000280; 3.0 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CLAB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'engine_oil', (SELECT id FROM engines WHERE code = 'CMHA'), 6.4, 6.76, '5W-30', 'VW 507 00', 'HaynesPro typeId t_300000287; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CMHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'coolant', (SELECT id FROM engines WHERE code = 'CMHA'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_300000287; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CMHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'transmission_at', (SELECT id FROM engines WHERE code = 'CMHA'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_300000287; 3.0 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CMHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'engine_oil', (SELECT id FROM engines WHERE code = 'CPNA'), 6.4, 6.76, '5W-30', 'VW 507 00', 'HaynesPro typeId t_619017220; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CPNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'coolant', (SELECT id FROM engines WHERE code = 'CPNA'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_619017220; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CPNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'transmission_at', (SELECT id FROM engines WHERE code = 'CPNA'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_619017220; 3.0 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CPNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'engine_oil', (SELECT id FROM engines WHERE code = 'CTBA'), 6.4, 6.76, '5W-30', 'VW 507 00', 'HaynesPro typeId t_301001169; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CTBA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'coolant', (SELECT id FROM engines WHERE code = 'CTBA'), NULL, NULL, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_301001169; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CTBA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'transmission_at', (SELECT id FROM engines WHERE code = 'CTBA'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_301001169; 3.0 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CTBA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'engine_oil', (SELECT id FROM engines WHERE code = 'CDTC'), 6.4, 6.76, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319000201; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CDTC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'coolant', (SELECT id FROM engines WHERE code = 'CDTC'), NULL, NULL, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319000201; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CDTC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'transmission_at', (SELECT id FROM engines WHERE code = 'CDTC'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_319000201; 3.0 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CDTC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'engine_oil', (SELECT id FROM engines WHERE code = 'CPNB'), 6.4, 6.76, '5W-30', 'VW 507 00', 'HaynesPro typeId t_619017221; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CPNB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'coolant', (SELECT id FROM engines WHERE code = 'CPNB'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_619017221; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CPNB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'transmission_at', (SELECT id FROM engines WHERE code = 'CPNB'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_619017221; 3.0 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CPNB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'engine_oil', (SELECT id FROM engines WHERE code = 'CTBB'), 6.4, 6.76, '5W-30', 'VW 507 00', 'HaynesPro typeId t_318011850; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CTBB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'coolant', (SELECT id FROM engines WHERE code = 'CTBB'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_318011850; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CTBB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'transmission_at', (SELECT id FROM engines WHERE code = 'CTBB'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_318011850; 3.0 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CTBB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'engine_oil', (SELECT id FROM engines WHERE code = 'CTBD'), 6.4, 6.76, '5W-30', 'VW 507 00', 'HaynesPro typeId t_317000560; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CTBD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'coolant', (SELECT id FROM engines WHERE code = 'CTBD'), NULL, NULL, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_317000560; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CTBD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'transmission_at', (SELECT id FROM engines WHERE code = 'CTBD'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_317000560; 3.0 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CTBD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'engine_oil', (SELECT id FROM engines WHERE code = 'CGXC'), 6.8, 7.19, '5W-40', 'VW 502 00', 'HaynesPro typeId t_300000281; 3.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CGXC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'coolant', (SELECT id FROM engines WHERE code = 'CGXC'), 15, 15.85, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_300000281; 3.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CGXC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'transmission_at', (SELECT id FROM engines WHERE code = 'CGXC'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_300000281; 3.0 TFSI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CGXC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'engine_oil', (SELECT id FROM engines WHERE code = 'CMDA'), 6.8, 7.19, '5W-40', 'VW 502 00', 'HaynesPro typeId t_102001656; 3.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CMDA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'coolant', (SELECT id FROM engines WHERE code = 'CMDA'), 14.5, 15.32, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102001656; 3.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CMDA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'transmission_at', (SELECT id FROM engines WHERE code = 'CMDA'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_102001656; 3.0 TFSI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CMDA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'engine_oil', (SELECT id FROM engines WHERE code = 'CGWA'), 6.8, 7.19, '5W-40', 'VW 502 00', 'HaynesPro typeId t_102001655; 3.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CGWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'coolant', (SELECT id FROM engines WHERE code = 'CGWA'), 14.5, 15.32, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102001655; 3.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CGWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'transmission_at', (SELECT id FROM engines WHERE code = 'CGWA'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_102001655; 3.0 TFSI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CGWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'engine_oil', (SELECT id FROM engines WHERE code = 'CTUB'), 6.8, 7.19, '5W-40', 'VW 502 00', 'HaynesPro typeId t_300000282; 3.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CTUB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'coolant', (SELECT id FROM engines WHERE code = 'CTUB'), 15, 15.85, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_300000282; 3.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CTUB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'transmission_at', (SELECT id FROM engines WHERE code = 'CTUB'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_300000282; 3.0 TFSI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CTUB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'engine_oil', (SELECT id FROM engines WHERE code = 'CGWD'), 6.8, 7.19, '5W-40', 'VW 502 00', 'HaynesPro typeId t_102002574; 3.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CGWD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'coolant', (SELECT id FROM engines WHERE code = 'CGWD'), 15, 15.85, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102002574; 3.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CGWD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'transmission_at', (SELECT id FROM engines WHERE code = 'CGWD'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_102002574; 3.0 TFSI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CGWD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'engine_oil', (SELECT id FROM engines WHERE code = 'CREC'), 6.8, 7.19, '5W-40', 'VW 502 00', 'HaynesPro typeId t_305000522; 3.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CREC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'coolant', (SELECT id FROM engines WHERE code = 'CREC'), NULL, NULL, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_305000522; 3.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CREC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'transmission_at', (SELECT id FROM engines WHERE code = 'CREC'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_305000522; 3.0 TFSI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CREC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'engine_oil', (SELECT id FROM engines WHERE code = 'CTDA'), 6.8, 7.19, '5W-40', 'VW 502 00', 'HaynesPro typeId t_305000521; 3.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CTDA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'coolant', (SELECT id FROM engines WHERE code = 'CTDA'), NULL, NULL, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_305000521; 3.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CTDA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'transmission_at', (SELECT id FROM engines WHERE code = 'CTDA'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_305000521; 3.0 TFSI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CTDA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'engine_oil', (SELECT id FROM engines WHERE code = 'CREA'), 6.8, 7.19, '5W-40', 'VW 502 00', 'HaynesPro typeId t_302000344; 3.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CREA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'coolant', (SELECT id FROM engines WHERE code = 'CREA'), NULL, NULL, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_302000344; 3.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CREA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'transmission_at', (SELECT id FROM engines WHERE code = 'CREA'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_302000344; 3.0 TFSI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CREA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'engine_oil', (SELECT id FROM engines WHERE code = 'CREG'), 6.8, 7.19, '5W-40', 'VW 502 00', 'HaynesPro typeId t_305000523; 3.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CREG'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'coolant', (SELECT id FROM engines WHERE code = 'CREG'), NULL, NULL, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_305000523; 3.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CREG'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'transmission_at', (SELECT id FROM engines WHERE code = 'CREG'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_305000523; 3.0 TFSI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CREG'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'engine_oil', (SELECT id FROM engines WHERE code = 'CEUA'), 8.5, 8.98, '5W-40', 'VW 502 00', 'HaynesPro typeId t_300000283; 4.0 TFSI; drain 20 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CEUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'coolant', (SELECT id FROM engines WHERE code = 'CEUA'), 15, 15.85, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_300000283; 4.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CEUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'transmission_at', (SELECT id FROM engines WHERE code = 'CEUA'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_300000283; 4.0 TFSI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CEUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'engine_oil', (SELECT id FROM engines WHERE code = 'CTGA'), 8.5, 8.98, '5W-40', 'VW 502 00', 'HaynesPro typeId t_301001171; 4.0 TFSI; drain 20 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CTGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'coolant', (SELECT id FROM engines WHERE code = 'CTGA'), NULL, NULL, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_301001171; 4.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CTGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'transmission_at', (SELECT id FROM engines WHERE code = 'CTGA'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_301001171; 4.0 TFSI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CTGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'engine_oil', (SELECT id FROM engines WHERE code = 'CDRA'), 7.7, 8.14, '5W-40', 'VW 502 00', 'HaynesPro typeId t_102001651; 4.2 FSi; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CDRA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'coolant', (SELECT id FROM engines WHERE code = 'CDRA'), 15, 15.85, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102001651; 4.2 FSi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CDRA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'transmission_at', (SELECT id FROM engines WHERE code = 'CDRA'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_102001651; 4.2 FSi; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CDRA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'engine_oil', (SELECT id FROM engines WHERE code = 'CDSB'), 9.5, 10.04, '5W-30', 'VW 507 00', 'HaynesPro typeId t_102001652; 4.2 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CDSB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'coolant', (SELECT id FROM engines WHERE code = 'CDSB'), NULL, NULL, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102001652; 4.2 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CDSB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'transmission_at', (SELECT id FROM engines WHERE code = 'CDSB'), 10.1, 10.67, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_102001652; 4.2 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CDSB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'engine_oil', (SELECT id FROM engines WHERE code = 'CTEC'), 9.5, 10.04, '5W-30', 'VW 507 00', 'HaynesPro typeId t_301001170; 4.2 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CTEC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'coolant', (SELECT id FROM engines WHERE code = 'CTEC'), NULL, NULL, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_301001170; 4.2 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CTEC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'transmission_at', (SELECT id FROM engines WHERE code = 'CTEC'), 10.1, 10.67, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_301001170; 4.2 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CTEC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'engine_oil', (SELECT id FROM engines WHERE code = 'CEJA'), 11.2, 11.83, '5W-40', 'VW 502 00', 'HaynesPro typeId t_102001654; 6.3 W12; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CEJA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'coolant', (SELECT id FROM engines WHERE code = 'CEJA'), 14.5, 15.32, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102001654; 6.3 W12'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CEJA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'transmission_at', (SELECT id FROM engines WHERE code = 'CEJA'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_102001654; 6.3 W12; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CEJA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'engine_oil', (SELECT id FROM engines WHERE code = 'CTNA'), 11.2, 11.83, '5W-40', 'VW 502 00', 'HaynesPro typeId t_305000520; 6.3 W12; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CTNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'coolant', (SELECT id FROM engines WHERE code = 'CTNA'), NULL, NULL, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_305000520; 6.3 W12'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CTNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'transmission_at', (SELECT id FROM engines WHERE code = 'CTNA'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_305000520; 6.3 W12; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CTNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'engine_oil', (SELECT id FROM engines WHERE code = 'CGTA'), 8.5, 8.98, '5W-40', 'VW 502 00', 'HaynesPro typeId t_300000284; S8 (4.0 TFSI); drain 20 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CGTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'coolant', (SELECT id FROM engines WHERE code = 'CGTA'), 15, 15.85, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_300000284; S8 (4.0 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CGTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'transmission_at', (SELECT id FROM engines WHERE code = 'CGTA'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_300000284; S8 (4.0 TFSI); Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CGTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'engine_oil', (SELECT id FROM engines WHERE code = 'CTFA'), 8.7, 9.19, '5W-40', 'VW 502 00', 'HaynesPro typeId t_302000345; S8 (4.0 TFSI); drain 20 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CTFA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'coolant', (SELECT id FROM engines WHERE code = 'CTFA'), NULL, NULL, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_302000345; S8 (4.0 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CTFA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'transmission_at', (SELECT id FROM engines WHERE code = 'CTFA'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_302000345; S8 (4.0 TFSI); Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CTFA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'engine_oil', (SELECT id FROM engines WHERE code = 'DDTA'), 8.5, 8.98, '5W-40', 'VW 502 00', 'HaynesPro typeId t_318012057; S8 (4.0 TFSI); drain 20 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DDTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'coolant', (SELECT id FROM engines WHERE code = 'DDTA'), NULL, NULL, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_318012057; S8 (4.0 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DDTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'transmission_at', (SELECT id FROM engines WHERE code = 'DDTA'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_318012057; S8 (4.0 TFSI); Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DDTA'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 288, 'brake_fluid', NULL, 1, 1.06, NULL, 'VW 501 14', 'HaynesPro chassis d_102000172; Alt: DOT 4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 288 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (288)
  AND e.code IN ('CHJA', 'CDTA', 'CDTB', 'CLAB', 'CMHA', 'CPNA', 'CTBA', 'CDTC', 'CPNB', 'CTBB', 'CTBD', 'CGXC', 'CMDA', 'CGWA', 'CTUB', 'CGWD', 'CREC', 'CTDA', 'CREA', 'CREG', 'CEUA', 'CTGA', 'CDRA', 'CDSB', 'CTEC', 'CEJA', 'CTNA', 'CGTA', 'CTFA', 'DDTA')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (288)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (288) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;