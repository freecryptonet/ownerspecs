-- mig 306 — multi-gen HaynesPro ingest: Audi Q3 (G2, F3)
-- crawl: haynespro-crawl-audi-q3-f3-2026-05-23.json
-- modelId: d_319003511
-- 21 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Audi Q3 (G2, F3)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319003511', NOW(), 'Multi-gen ingest, 21 engines across 2 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319003511' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('DFGA', '35 TDI (DFGA) 110kW', 1968, 'diesel', 'turbo', NULL),
  ('DTSA', '35 TDI (DTSA) 110kW', 1968, 'diesel', 'turbo', NULL),
  ('DTSB', '35 TDI (DTSB) 110kW', 1968, 'diesel', 'turbo', NULL),
  ('DXPA', '35 TDI (DXPA) 110kW', 1968, 'diesel', 'turbo', NULL),
  ('CZDA', '35 TFSI (CZDA) 110kW', 1395, 'petrol', 'turbo', NULL),
  ('DADA', '35 TFSI (DADA) 110kW', 1498, 'petrol', 'turbo', NULL),
  ('DFYA', '35 TFSI (DFYA) 110kW', 1498, 'petrol', 'turbo', NULL),
  ('DPCA', '35 TFSI (DPCA) 110kW', 1498, 'petrol', 'turbo', NULL),
  ('DXDB', '35 TFSI (DXDB) 110kW', 1498, 'petrol', 'turbo', NULL),
  ('DFHA', '40 TDI (DFHA) 140kW', 1968, 'diesel', 'turbo', NULL),
  ('DTUA', '40 TDI (DTUA) 147kW', 1968, 'diesel', 'turbo', NULL),
  ('DXNB', '40 TDI (DXNB) 142kW', 1968, 'diesel', 'turbo', NULL),
  ('DKTC', '40 TFSI (DKTC) 140kW', 1984, 'petrol', 'turbo', NULL),
  ('CZPA', '40 TFSI (CZPA) 132kW', 1984, 'petrol', 'turbo', NULL),
  ('DNNA', '40 TFSI (DNNA) 140kW', 1984, 'petrol', 'turbo', NULL),
  ('DHHA', '45 TFSI (DHHA) 170kW', 1984, 'petrol', 'turbo', NULL),
  ('DKTA', '45 TFSI (DKTA) 169kW', 1984, 'petrol', 'turbo', NULL),
  ('DNPA', '45 TFSI (DNPA) 180kW', 1984, 'petrol', 'turbo', NULL),
  ('DGEA', '45 TFSI e (DGEA) 180kW', 1395, 'hybrid', 'turbo', NULL),
  ('DAZA', 'RSQ3 (2.5 TFSI) (DAZA) 294kW', 2480, 'petrol', 'turbo', NULL),
  ('DNWA', 'RSQ3 (2.5 TFSI) (DNWA) 294kW', 2480, 'petrol', 'turbo', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'engine_oil', (SELECT id FROM engines WHERE code = 'DFGA'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619017001; 35 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DFGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'coolant', (SELECT id FROM engines WHERE code = 'DFGA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619017001; 35 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DFGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DFGA'), 1.5, 1.59, NULL, 'SAE 75W', 'HaynesPro typeId t_619017001; 35 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DFGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'engine_oil', (SELECT id FROM engines WHERE code = 'DTSA'), 5.5, 5.81, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619035995; 35 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DTSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'coolant', (SELECT id FROM engines WHERE code = 'DTSA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035995; 35 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DTSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DTSA'), 1.5, 1.59, NULL, 'SAE 75W', 'HaynesPro typeId t_619035995; 35 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DTSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'engine_oil', (SELECT id FROM engines WHERE code = 'DTSB'), 5.5, 5.81, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619035771; 35 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DTSB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'coolant', (SELECT id FROM engines WHERE code = 'DTSB'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035771; 35 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DTSB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DTSB'), 1.5, 1.59, NULL, 'SAE 75W', 'HaynesPro typeId t_619035771; 35 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DTSB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'engine_oil', (SELECT id FROM engines WHERE code = 'DXPA'), 5.5, 5.81, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619139630; 35 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DXPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'coolant', (SELECT id FROM engines WHERE code = 'DXPA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619139630; 35 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DXPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DXPA'), 6.9, 7.29, NULL, NULL, 'HaynesPro typeId t_619139630; 35 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DXPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZDA'), 4, 4.23, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619017248; 35 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZDA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'coolant', (SELECT id FROM engines WHERE code = 'CZDA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619017248; 35 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZDA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CZDA'), 1.5, 1.59, NULL, 'SAE 75W', 'HaynesPro typeId t_619017248; 35 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CZDA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'engine_oil', (SELECT id FROM engines WHERE code = 'DADA'), 4.3, 4.54, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619016999; 35 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DADA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'coolant', (SELECT id FROM engines WHERE code = 'DADA'), 9, 9.51, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619016999; 35 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DADA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DADA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_619016999; 35 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DADA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'coolant', (SELECT id FROM engines WHERE code = 'DFYA'), 9, 9.51, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619028757; 35 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DFYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DFYA'), 1.5, 1.59, NULL, 'SAE 75W', 'HaynesPro typeId t_619028757; 35 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DFYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'engine_oil', (SELECT id FROM engines WHERE code = 'DPCA'), 4.3, 4.54, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619024251; 35 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DPCA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'coolant', (SELECT id FROM engines WHERE code = 'DPCA'), 9, 9.51, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619024251; 35 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DPCA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DPCA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_619024251; 35 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DPCA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'engine_oil', (SELECT id FROM engines WHERE code = 'DXDB'), 4.3, 4.54, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619112026; 35 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DXDB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'coolant', (SELECT id FROM engines WHERE code = 'DXDB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619112026; 35 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DXDB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DXDB'), 1.5, 1.59, NULL, 'SAE 75W', 'HaynesPro typeId t_619112026; 35 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DXDB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'engine_oil', (SELECT id FROM engines WHERE code = 'DFHA'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619017249; 40 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DFHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'coolant', (SELECT id FROM engines WHERE code = 'DFHA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619017249; 40 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DFHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DFHA'), 5.5, 5.81, NULL, 'SAE 75W', 'HaynesPro typeId t_619017249; 40 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DFHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'engine_oil', (SELECT id FROM engines WHERE code = 'DTUA'), 5.5, 5.81, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619035868; 40 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DTUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'coolant', (SELECT id FROM engines WHERE code = 'DTUA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035868; 40 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DTUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DTUA'), 1.5, 1.59, NULL, 'SAE 75W', 'HaynesPro typeId t_619035868; 40 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DTUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'engine_oil', (SELECT id FROM engines WHERE code = 'DXNB'), 5.5, 5.81, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619139628; 40 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DXNB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'coolant', (SELECT id FROM engines WHERE code = 'DXNB'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619139628; 40 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DXNB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DXNB'), 6.9, 7.29, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619139628; 40 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DXNB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'engine_oil', (SELECT id FROM engines WHERE code = 'DKTC'), 5.7, 6.02, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619017003; 40 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DKTC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'coolant', (SELECT id FROM engines WHERE code = 'DKTC'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619017003; 40 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DKTC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DKTC'), 5.5, 5.81, NULL, 'SAE 75W', 'HaynesPro typeId t_619017003; 40 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DKTC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZPA'), NULL, NULL, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619036403; 40 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'coolant', (SELECT id FROM engines WHERE code = 'CZPA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619036403; 40 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CZPA'), 5.5, 5.81, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619036403; 40 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CZPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'engine_oil', (SELECT id FROM engines WHERE code = 'DNNA'), 5.7, 6.02, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619035993; 40 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DNNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'coolant', (SELECT id FROM engines WHERE code = 'DNNA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035993; 40 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DNNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DNNA'), 1.5, 1.59, NULL, 'SAE 75W', 'HaynesPro typeId t_619035993; 40 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DNNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'engine_oil', (SELECT id FROM engines WHERE code = 'DHHA'), 5.7, 6.02, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619017250; 45 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DHHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DHHA'), 1.5, 1.59, NULL, 'SAE 75W', 'HaynesPro typeId t_619017250; 45 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DHHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'engine_oil', (SELECT id FROM engines WHERE code = 'DKTA'), 5.7, 6.02, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619017251; 45 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DKTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'coolant', (SELECT id FROM engines WHERE code = 'DKTA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619017251; 45 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DKTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DKTA'), 5.5, 5.81, NULL, 'SAE 75W', 'HaynesPro typeId t_619017251; 45 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DKTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'engine_oil', (SELECT id FROM engines WHERE code = 'DNPA'), 5.7, 6.02, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619035994; 45 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DNPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'coolant', (SELECT id FROM engines WHERE code = 'DNPA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035994; 45 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DNPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DNPA'), 1.5, 1.59, NULL, 'SAE 75W', 'HaynesPro typeId t_619035994; 45 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DNPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'engine_oil', (SELECT id FROM engines WHERE code = 'DGEA'), 4, 4.23, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619035859; 45 TFSI e; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DGEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'coolant', (SELECT id FROM engines WHERE code = 'DGEA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035859; 45 TFSI e'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DGEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DGEA'), 8.1, 8.56, NULL, 'SAE 75W', 'HaynesPro typeId t_619035859; 45 TFSI e; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DGEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 281, 'engine_oil', (SELECT id FROM engines WHERE code = 'DAZA'), 7.1, 7.5, '0W-30', 'VW 504 00', 'HaynesPro typeId t_619033128; RSQ3 (2.5 TFSI); drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 281 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DAZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 281, 'coolant', (SELECT id FROM engines WHERE code = 'DAZA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619033128; RSQ3 (2.5 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 281 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DAZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 281, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DAZA'), 5.5, 5.81, NULL, 'SAE 75W', 'HaynesPro typeId t_619033128; RSQ3 (2.5 TFSI); Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 281 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DAZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 281, 'engine_oil', (SELECT id FROM engines WHERE code = 'DNWA'), 7.1, 7.5, '0W-30', 'VW 504 00', 'HaynesPro typeId t_619028756; RSQ3 (2.5 TFSI); drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 281 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DNWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 281, 'coolant', (SELECT id FROM engines WHERE code = 'DNWA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619028756; RSQ3 (2.5 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 281 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DNWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 281, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DNWA'), 5.5, 5.81, NULL, 'SAE 75W', 'HaynesPro typeId t_619028756; RSQ3 (2.5 TFSI); Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 281 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DNWA'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 280, 'brake_fluid', NULL, 1, 1.06, NULL, 'VW 501 14', 'HaynesPro chassis d_319003511; Alt: DOT 4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 280 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 281, 'brake_fluid', NULL, 1, 1.06, NULL, 'VW 501 14', 'HaynesPro chassis d_319003511; Alt: DOT 4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 281 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (280, 281)
  AND e.code IN ('DFGA', 'DTSA', 'DTSB', 'DXPA', 'CZDA', 'DADA', 'DFYA', 'DPCA', 'DXDB', 'DFHA', 'DTUA', 'DXNB', 'DKTC', 'CZPA', 'DNNA', 'DHHA', 'DKTA', 'DNPA', 'DGEA', 'DAZA', 'DNWA')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (280, 281)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (280, 281) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;