-- mig 301 — multi-gen HaynesPro ingest: Audi A3 IV (8Y)
-- crawl: haynespro-crawl-audi-a3-8y-2026-05-23.json
-- modelId: d_319007427
-- 30 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Audi A3 IV (8Y)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319007427', NOW(), 'Multi-gen ingest, 30 engines across 2 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319007427' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('DSUD', '30 TDI (DSUD) 85kW', 1968, 'diesel', 'turbo', NULL),
  ('DTRB', '30 TDI (DTRB) 85kW', 1968, 'diesel', 'turbo', NULL),
  ('DTRD', '30 TDI (DTRD) 85kW', 1968, 'diesel', 'turbo', NULL),
  ('DXRC', '30 TDI (DXRC) 85kW', 1968, 'diesel', 'turbo', NULL),
  ('DXDE', '30 TFSI (DXDE) 85kW', 1498, 'petrol', 'turbo', NULL),
  ('DLAA', '30 eTFSI (DLAA) 81kW', 999, 'petrol', 'turbo', NULL),
  ('DHFA', '30 g-tron (DHFA) 96kW', 1498, 'petrol', 'NA', NULL),
  ('DTSA', '35 TDI (DTSA) 110kW', 1968, 'diesel', 'turbo', NULL),
  ('DTSB', '35 TDI (DTSB) 110kW', 1968, 'diesel', 'turbo', NULL),
  ('DSRB', '35 TDI (DSRB) 110kW', 1968, 'diesel', 'turbo', NULL),
  ('DXPA', '35 TDI (DXPA) 110kW', 1968, 'diesel', 'turbo', NULL),
  ('DPCA', '35 TFSI (DPCA) 110kW', 1498, 'petrol', 'turbo', NULL),
  ('DJKA', '35 TFSI (DJKA) 110kW', 1395, 'petrol', 'turbo', NULL),
  ('DXDB', '35 TFSI (DXDB) 110kW', 1498, 'petrol', 'turbo', NULL),
  ('DFYA', '35 eTFSI (DFYA) 110kW', 1498, 'petrol', 'turbo', NULL),
  ('DTUA', '40 TDI (DTUA) 147kW', 1968, 'diesel', 'turbo', NULL),
  ('CZPB', '40 TFSI (CZPB) 140kW', 1984, 'petrol', 'turbo', NULL),
  ('DNNA', '40 TFSI (DNNA) 140kW', 1984, 'petrol', 'turbo', NULL),
  ('DNNE', '40 TFSI (DNNE) 150kW', 1984, 'petrol', 'turbo', NULL),
  ('DGEA', '40 TFSI e (DGEA) 150kW', 1395, 'hybrid', 'turbo', NULL),
  ('DUCB', '40 TFSI e (DUCB) 150kW', 1498, 'hybrid', 'turbo', NULL),
  ('DNVB', '40 eTFSI (DNVB) 150kW', 1984, 'petrol', 'turbo', NULL),
  ('DUCA', '45 TFSI e (DUCA) 200kW', 1498, 'hybrid', 'turbo', NULL),
  ('DXHB', 'RS3 (2.5 TFSI) (DXHB) 294kW', 2480, 'petrol', 'turbo', NULL),
  ('DNWD', 'RS3 (2.5 TFSI) (DNWD) 299kW', 2480, 'petrol', 'turbo', NULL),
  ('DNWC', 'RS3 (2.5 TFSI) (DNWC) 294kW', 2480, 'petrol', 'turbo', NULL),
  ('DXHA', 'RS3 (2.5 TFSI) (DXHA) 299kW', 2480, 'petrol', 'turbo', NULL),
  ('DNFB', 'S3 (2.0 TFSI) (DNFB) 228kW', 1984, 'petrol', 'turbo', NULL),
  ('DUPA', 'S3 (2.0 TFSI) (DUPA) 213kW', 1984, 'petrol', 'turbo', NULL),
  ('DNFF', 'S3 (2.0 TFSI) (DNFF) 245kW', 1984, 'petrol', 'turbo', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'engine_oil', (SELECT id FROM engines WHERE code = 'DSUD'), 5.5, 5.81, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619031055; 30 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DSUD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'coolant', (SELECT id FROM engines WHERE code = 'DSUD'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619031055; 30 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DSUD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DSUD'), 1.5, 1.59, NULL, 'SAE 75W', 'HaynesPro typeId t_619031055; 30 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DSUD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'engine_oil', (SELECT id FROM engines WHERE code = 'DTRB'), 5.5, 5.81, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619032454; 30 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DTRB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'coolant', (SELECT id FROM engines WHERE code = 'DTRB'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619032454; 30 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DTRB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DTRB'), 1.7, 1.8, NULL, 'VW G 055 512 A2', 'HaynesPro typeId t_619032454; 30 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DTRB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'engine_oil', (SELECT id FROM engines WHERE code = 'DTRD'), 5.5, 5.81, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619032455; 30 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DTRD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'coolant', (SELECT id FROM engines WHERE code = 'DTRD'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619032455; 30 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DTRD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DTRD'), 1.5, 1.59, NULL, 'SAE 75W', 'HaynesPro typeId t_619032455; 30 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DTRD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'engine_oil', (SELECT id FROM engines WHERE code = 'DXRC'), 5.5, 5.81, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619139052; 30 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DXRC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'coolant', (SELECT id FROM engines WHERE code = 'DXRC'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619139052; 30 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DXRC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DXRC'), 1.5, 1.59, NULL, 'SAE 75W', 'HaynesPro typeId t_619139052; 30 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DXRC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'engine_oil', (SELECT id FROM engines WHERE code = 'DXDE'), 4.3, 4.54, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619151003; 30 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DXDE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'coolant', (SELECT id FROM engines WHERE code = 'DXDE'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619151003; 30 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DXDE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DXDE'), 1.5, 1.59, NULL, 'SAE 75W', 'HaynesPro typeId t_619151003; 30 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DXDE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'engine_oil', (SELECT id FROM engines WHERE code = 'DLAA'), 4, 4.23, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619032449; 30 eTFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DLAA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'coolant', (SELECT id FROM engines WHERE code = 'DLAA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619032449; 30 eTFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DLAA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DLAA'), 1.7, 1.8, NULL, 'VW G 055 512 A2', 'HaynesPro typeId t_619032449; 30 eTFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DLAA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'engine_oil', (SELECT id FROM engines WHERE code = 'DHFA'), 4.3, 4.54, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619032447; 30 g-tron; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DHFA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'coolant', (SELECT id FROM engines WHERE code = 'DHFA'), 9, 9.51, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619032447; 30 g-tron'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DHFA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DHFA'), 1.7, 1.8, NULL, 'VW G 055 512 A2', 'HaynesPro typeId t_619032447; 30 g-tron; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DHFA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'engine_oil', (SELECT id FROM engines WHERE code = 'DTSA'), 5.5, 5.81, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619032456; 35 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DTSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'coolant', (SELECT id FROM engines WHERE code = 'DTSA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619032456; 35 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DTSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DTSA'), 1.5, 1.59, NULL, 'SAE 75W', 'HaynesPro typeId t_619032456; 35 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DTSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'engine_oil', (SELECT id FROM engines WHERE code = 'DTSB'), 5.5, 5.81, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619032457; 35 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DTSB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'coolant', (SELECT id FROM engines WHERE code = 'DTSB'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619032457; 35 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DTSB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DTSB'), 6.9, 7.29, NULL, NULL, 'HaynesPro typeId t_619032457; 35 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DTSB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'engine_oil', (SELECT id FROM engines WHERE code = 'DSRB'), 5.5, 5.81, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619031056; 35 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DSRB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'coolant', (SELECT id FROM engines WHERE code = 'DSRB'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619031056; 35 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DSRB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DSRB'), 6.9, 7.29, NULL, NULL, 'HaynesPro typeId t_619031056; 35 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DSRB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'engine_oil', (SELECT id FROM engines WHERE code = 'DXPA'), 5.5, 5.81, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619139051; 35 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DXPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'coolant', (SELECT id FROM engines WHERE code = 'DXPA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619139051; 35 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DXPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DXPA'), 6.9, 7.29, NULL, NULL, 'HaynesPro typeId t_619139051; 35 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DXPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'engine_oil', (SELECT id FROM engines WHERE code = 'DPCA'), 4.3, 4.54, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619031054; 35 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DPCA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'coolant', (SELECT id FROM engines WHERE code = 'DPCA'), 9, 9.51, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619031054; 35 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DPCA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DPCA'), 1.5, 1.59, NULL, 'SAE 75W', 'HaynesPro typeId t_619031054; 35 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DPCA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'engine_oil', (SELECT id FROM engines WHERE code = 'DJKA'), 4, 4.23, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619032448; 35 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DJKA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'coolant', (SELECT id FROM engines WHERE code = 'DJKA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619032448; 35 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DJKA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'transmission_at', (SELECT id FROM engines WHERE code = 'DJKA'), 6.3, 6.66, NULL, 'VW G 053 001 A2', 'HaynesPro typeId t_619032448; 35 TFSI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DJKA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'engine_oil', (SELECT id FROM engines WHERE code = 'DXDB'), 4.3, 4.54, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619151004; 35 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DXDB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'coolant', (SELECT id FROM engines WHERE code = 'DXDB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619151004; 35 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DXDB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DXDB'), 1.5, 1.59, NULL, 'SAE 75W', 'HaynesPro typeId t_619151004; 35 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DXDB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'engine_oil', (SELECT id FROM engines WHERE code = 'DFYA'), 4.3, 4.54, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619032445; 35 eTFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DFYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'coolant', (SELECT id FROM engines WHERE code = 'DFYA'), 9, 9.51, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619032445; 35 eTFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DFYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DFYA'), 1.7, 1.8, NULL, 'VW G 055 512 A2', 'HaynesPro typeId t_619032445; 35 eTFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DFYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'engine_oil', (SELECT id FROM engines WHERE code = 'DTUA'), 5.5, 5.81, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619032458; 40 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DTUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'coolant', (SELECT id FROM engines WHERE code = 'DTUA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619032458; 40 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DTUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DTUA'), 6.9, 7.29, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619032458; 40 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DTUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZPB'), 5.7, 6.02, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619035627; 40 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZPB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'coolant', (SELECT id FROM engines WHERE code = 'CZPB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035627; 40 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZPB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CZPB'), 6.9, 7.29, NULL, NULL, 'HaynesPro typeId t_619035627; 40 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CZPB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'engine_oil', (SELECT id FROM engines WHERE code = 'DNNA'), 5.7, 6.02, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619032451; 40 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DNNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'coolant', (SELECT id FROM engines WHERE code = 'DNNA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619032451; 40 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DNNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DNNA'), 6.9, 7.29, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619032451; 40 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DNNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'engine_oil', (SELECT id FROM engines WHERE code = 'DNNE'), NULL, NULL, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619150402; 40 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DNNE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'coolant', (SELECT id FROM engines WHERE code = 'DNNE'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619150402; 40 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DNNE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DNNE'), 7.4, 7.82, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619150402; 40 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DNNE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'engine_oil', (SELECT id FROM engines WHERE code = 'DGEA'), 4, 4.23, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619032446; 40 TFSI e; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DGEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'coolant', (SELECT id FROM engines WHERE code = 'DGEA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619032446; 40 TFSI e'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DGEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DGEA'), 8.1, 8.56, NULL, NULL, 'HaynesPro typeId t_619032446; 40 TFSI e; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DGEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'engine_oil', (SELECT id FROM engines WHERE code = 'DUCB'), 4.3, 4.54, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619143492; 40 TFSI e; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DUCB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'coolant', (SELECT id FROM engines WHERE code = 'DUCB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619143492; 40 TFSI e'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DUCB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DUCB'), 8.1, 8.56, NULL, NULL, 'HaynesPro typeId t_619143492; 40 TFSI e; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DUCB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'engine_oil', (SELECT id FROM engines WHERE code = 'DNVB'), 5.7, 6.02, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619032452; 40 eTFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DNVB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'coolant', (SELECT id FROM engines WHERE code = 'DNVB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619032452; 40 eTFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DNVB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DNVB'), 6.9, 7.29, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619032452; 40 eTFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DNVB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'engine_oil', (SELECT id FROM engines WHERE code = 'DUCA'), 4.3, 4.54, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619143493; 45 TFSI e; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DUCA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'coolant', (SELECT id FROM engines WHERE code = 'DUCA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619143493; 45 TFSI e'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DUCA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DUCA'), 8.1, 8.56, NULL, NULL, 'HaynesPro typeId t_619143493; 45 TFSI e; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DUCA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 272, 'engine_oil', (SELECT id FROM engines WHERE code = 'DXHB'), 7.1, 7.5, '0W-30', 'VW 504 00', 'HaynesPro typeId t_619112170; RS3 (2.5 TFSI); drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 272 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DXHB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 272, 'coolant', (SELECT id FROM engines WHERE code = 'DXHB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619112170; RS3 (2.5 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 272 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DXHB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 272, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DXHB'), 5.5, 5.81, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619112170; RS3 (2.5 TFSI); Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 272 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DXHB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 272, 'engine_oil', (SELECT id FROM engines WHERE code = 'DNWD'), 7.1, 7.5, '0W-30', 'VW 504 00', 'HaynesPro typeId t_619116092; RS3 (2.5 TFSI); drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 272 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DNWD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 272, 'coolant', (SELECT id FROM engines WHERE code = 'DNWD'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619116092; RS3 (2.5 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 272 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DNWD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 272, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DNWD'), 5.5, 5.81, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619116092; RS3 (2.5 TFSI); Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 272 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DNWD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 272, 'engine_oil', (SELECT id FROM engines WHERE code = 'DNWC'), 7.1, 7.5, '0W-30', 'VW 504 00', 'HaynesPro typeId t_619041512; RS3 (2.5 TFSI); drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 272 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DNWC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 272, 'coolant', (SELECT id FROM engines WHERE code = 'DNWC'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619041512; RS3 (2.5 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 272 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DNWC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 272, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DNWC'), 5.5, 5.81, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619041512; RS3 (2.5 TFSI); Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 272 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DNWC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 272, 'engine_oil', (SELECT id FROM engines WHERE code = 'DXHA'), 7.1, 7.5, '0W-30', 'VW 504 00', 'HaynesPro typeId t_619109551; RS3 (2.5 TFSI); drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 272 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DXHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 272, 'coolant', (SELECT id FROM engines WHERE code = 'DXHA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619109551; RS3 (2.5 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 272 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DXHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 272, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DXHA'), 5.5, 5.81, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619109551; RS3 (2.5 TFSI); Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 272 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DXHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'engine_oil', (SELECT id FROM engines WHERE code = 'DNFB'), 5.7, 6.02, '0W-30', 'VW 504 00', 'HaynesPro typeId t_619032450; S3 (2.0 TFSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DNFB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'coolant', (SELECT id FROM engines WHERE code = 'DNFB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619032450; S3 (2.0 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DNFB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DNFB'), 6.9, 7.29, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619032450; S3 (2.0 TFSI); Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DNFB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'engine_oil', (SELECT id FROM engines WHERE code = 'DUPA'), 5.7, 6.02, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619032459; S3 (2.0 TFSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DUPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'coolant', (SELECT id FROM engines WHERE code = 'DUPA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619032459; S3 (2.0 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DUPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DUPA'), 6.9, 7.29, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619032459; S3 (2.0 TFSI); Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DUPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'engine_oil', (SELECT id FROM engines WHERE code = 'DNFF'), 5.7, 6.02, '0W-30', 'VW 504 00', 'HaynesPro typeId t_619140859; S3 (2.0 TFSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DNFF'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'coolant', (SELECT id FROM engines WHERE code = 'DNFF'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619140859; S3 (2.0 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DNFF'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DNFF'), 6.9, 7.29, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619140859; S3 (2.0 TFSI); Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DNFF'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 271, 'brake_fluid', NULL, 1, 1.06, NULL, 'VW 501 14', 'HaynesPro chassis d_319007427; Alt: DOT 4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 271 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 272, 'brake_fluid', NULL, 1, 1.06, NULL, 'VW 501 14', 'HaynesPro chassis d_319007427; Alt: DOT 4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 272 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (271, 272)
  AND e.code IN ('DSUD', 'DTRB', 'DTRD', 'DXRC', 'DXDE', 'DLAA', 'DHFA', 'DTSA', 'DTSB', 'DSRB', 'DXPA', 'DPCA', 'DJKA', 'DXDB', 'DFYA', 'DTUA', 'CZPB', 'DNNA', 'DNNE', 'DGEA', 'DUCB', 'DNVB', 'DUCA', 'DXHB', 'DNWD', 'DNWC', 'DXHA', 'DNFB', 'DUPA', 'DNFF')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (271, 272)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (271, 272) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;