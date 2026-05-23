-- mig 233 — multi-gen HaynesPro ingest: VW Tiguan II (AD, AX, BT, BW, BJ)
-- crawl: haynespro-crawl-vw-tiguan-ii-ad-2026-05-23.json
-- modelId: d_317000050
-- 40 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — VW Tiguan II (AD, AX, BT, BW, BJ)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_317000050', NOW(), 'Multi-gen ingest, 40 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_317000050' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('CZEA', '1.4 TSI (CZEA) 110kW', 1395, 'petrol', 'turbo', NULL),
  ('CZCA', '1.4 TSI (CZCA) 92kW', 1395, 'petrol', 'turbo', NULL),
  ('CZDA', '1.4 TSI (CZDA) 110kW', 1395, 'petrol', 'turbo', NULL),
  ('DJVA', '1.4 TSI (DJVA) 110kW', 1395, 'petrol', 'turbo', NULL),
  ('CZDB', '1.4 TSI (CZDB) 92kW', 1395, 'petrol', 'turbo', NULL),
  ('DADA', '1.5 TSI (DADA) 110kW', 1498, 'petrol', 'turbo', NULL),
  ('DACA', '1.5 TSI (DACA) 96kW', 1498, 'petrol', 'turbo', NULL),
  ('DACB', '1.5 TSI (DACB) 96kW', 1498, 'petrol', 'turbo', NULL),
  ('DPCA', '1.5 TSI (DPCA) 110kW', 1498, 'petrol', 'turbo', NULL),
  ('DPBE', '1.5 TSI (DPBE) 96kW', 1498, 'petrol', 'turbo', NULL),
  ('DXDB', '1.5 TSI (DXDB) 110kW', 1498, 'petrol', 'turbo', NULL),
  ('DGDB', '1.6 TDI (DGDB) 85kW', 1598, 'diesel', 'turbo', NULL),
  ('DFHA', '2.0 TDI (DFHA) 140kW', 1968, 'diesel', 'turbo', NULL),
  ('DFGA', '2.0 TDI (DFGA) 110kW', 1968, 'diesel', 'turbo', NULL),
  ('DFGC', '2.0 TDI (DFGC) 85kW', 1968, 'diesel', 'turbo', NULL),
  ('CRGB', '2.0 TDI (CRGB) 130kW', 1968, 'diesel', 'turbo', NULL),
  ('DBGA', '2.0 TDI (DBGA) 110kW', 1968, 'diesel', 'turbo', NULL),
  ('DBGC', '2.0 TDI (DBGC) 110kW', 1968, 'diesel', 'turbo', NULL),
  ('CRFD', '2.0 TDI (CRFD) 105kW', 1968, 'diesel', 'turbo', NULL),
  ('CYKC', '2.0 TDI (CYKC) 81kW', 1968, 'diesel', 'turbo', NULL),
  ('DTUA', '2.0 TDI (DTUA) 147kW', 1968, 'diesel', 'turbo', NULL),
  ('DTSA', '2.0 TDI (DTSA) 110kW', 1968, 'diesel', 'turbo', NULL),
  ('DTSB', '2.0 TDI (DTSB) 110kW', 1968, 'diesel', 'turbo', NULL),
  ('DTRC', '2.0 TDI (DTRC) 90kW', 1968, 'diesel', 'turbo', NULL),
  ('CUAA', '2.0 TDI Bi-Turbo (CUAA) 176kW', 1968, 'diesel', 'turbo', NULL),
  ('CZPA', '2.0 TFSI (CZPA) 132kW', 1984, 'petrol', 'turbo', NULL),
  ('CHHB', '2.0 TSI (CHHB) 162kW', 1984, 'petrol', 'turbo', NULL),
  ('DGUA', '2.0 TSI (DGUA) 137kW', 1984, 'petrol', 'turbo', NULL),
  ('DGVA', '2.0 TSI (DGVA) 132kW', 1984, 'petrol', 'turbo', NULL),
  ('CXDA', '2.0 TSI (CXDA) 162kW', 1984, 'petrol', 'turbo', NULL),
  ('DKTA', '2.0 TSI (DKTA) 169kW', 1984, 'petrol', 'turbo', NULL),
  ('DNJA', '2.0 TSI (DNJA) 162kW', 1984, 'petrol', 'turbo', NULL),
  ('DKZA', '2.0 TSI (DKZA) 140kW', 1984, 'petrol', 'turbo', NULL),
  ('DNLA', '2.0 TSI (DNLA) 140kW', 1984, 'petrol', 'turbo', NULL),
  ('DNPA', '2.0 TSI (DNPA) 180kW', 1984, 'petrol', 'turbo', NULL),
  ('DNNA', '2.0 TSI (DNNA) 140kW', 1984, 'petrol', 'turbo', NULL),
  ('DTEA', '2.0 TSI (DTEA) 137kW', 1984, 'petrol', 'turbo', NULL),
  ('DNFG', 'R (2.0 TSI) (DNFG) 235kW', 1984, 'petrol', 'turbo', NULL),
  ('DSFE', 'R (2.0 TSI) (DSFE) 235kW', 1984, 'petrol', 'turbo', NULL),
  ('DGEA', 'eHybrid (1.4 TSI PHEV) (DGEA) 180kW', 1395, 'petrol', 'turbo', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZEA'), 4, 4.23, '5W-40', 'VW 502 00', 'HaynesPro typeId t_319000775; 1.4 TSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'coolant', (SELECT id FROM engines WHERE code = 'CZEA'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319000775; 1.4 TSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CZEA'), 5.2, 5.49, NULL, 'SAE 75W', 'HaynesPro typeId t_319000775; 1.4 TSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CZEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZCA'), 4, 4.23, '5W-40', 'VW 502 00', 'HaynesPro typeId t_319000774; 1.4 TSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZCA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'coolant', (SELECT id FROM engines WHERE code = 'CZCA'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319000774; 1.4 TSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZCA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CZCA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_319000774; 1.4 TSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CZCA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZDA'), 4, 4.23, '5W-40', 'VW 502 00', 'HaynesPro typeId t_319004813; 1.4 TSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZDA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'coolant', (SELECT id FROM engines WHERE code = 'CZDA'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319004813; 1.4 TSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZDA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CZDA'), 5.2, 5.49, NULL, 'SAE 75W-90', 'HaynesPro typeId t_319004813; 1.4 TSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CZDA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'engine_oil', (SELECT id FROM engines WHERE code = 'DJVA'), 4, 4.23, '0W-30', 'VW 504 00', 'HaynesPro typeId t_319007332; 1.4 TSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DJVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'coolant', (SELECT id FROM engines WHERE code = 'DJVA'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319007332; 1.4 TSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DJVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DJVA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_319007332; 1.4 TSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DJVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZDB'), 4, 4.23, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619042816; 1.4 TSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZDB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'coolant', (SELECT id FROM engines WHERE code = 'CZDB'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_619042816; 1.4 TSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZDB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CZDB'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_619042816; 1.4 TSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CZDB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'engine_oil', (SELECT id FROM engines WHERE code = 'DADA'), 4.3, 4.54, '0W-30', 'VW 504 00', 'HaynesPro typeId t_619010041; 1.5 TSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DADA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'coolant', (SELECT id FROM engines WHERE code = 'DADA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619010041; 1.5 TSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DADA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DADA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_619010041; 1.5 TSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DADA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'engine_oil', (SELECT id FROM engines WHERE code = 'DACA'), 4.3, 4.54, '5W-30', 'VW 504 00', 'HaynesPro typeId t_619012701; 1.5 TSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DACA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'coolant', (SELECT id FROM engines WHERE code = 'DACA'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_619012701; 1.5 TSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DACA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DACA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_619012701; 1.5 TSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DACA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'engine_oil', (SELECT id FROM engines WHERE code = 'DACB'), 4.3, 4.54, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619012702; 1.5 TSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DACB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'coolant', (SELECT id FROM engines WHERE code = 'DACB'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_619012702; 1.5 TSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DACB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DACB'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_619012702; 1.5 TSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DACB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'engine_oil', (SELECT id FROM engines WHERE code = 'DPCA'), 4.3, 4.54, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619014595; 1.5 TSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DPCA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'coolant', (SELECT id FROM engines WHERE code = 'DPCA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619014595; 1.5 TSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DPCA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DPCA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_619014595; 1.5 TSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DPCA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'engine_oil', (SELECT id FROM engines WHERE code = 'DPBE'), 4.3, 4.54, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619014594; 1.5 TSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DPBE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'coolant', (SELECT id FROM engines WHERE code = 'DPBE'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619014594; 1.5 TSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DPBE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DPBE'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_619014594; 1.5 TSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DPBE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'engine_oil', (SELECT id FROM engines WHERE code = 'DXDB'), NULL, NULL, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619111448; 1.5 TSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DXDB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'coolant', (SELECT id FROM engines WHERE code = 'DXDB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619111448; 1.5 TSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DXDB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DXDB'), 1.5, 1.59, NULL, 'SAE 75W', 'HaynesPro typeId t_619111448; 1.5 TSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DXDB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'engine_oil', (SELECT id FROM engines WHERE code = 'DGDB'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319004817; 1.6 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DGDB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'coolant', (SELECT id FROM engines WHERE code = 'DGDB'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319004817; 1.6 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DGDB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DGDB'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_319004817; 1.6 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DGDB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'engine_oil', (SELECT id FROM engines WHERE code = 'DFHA'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319004816; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DFHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'coolant', (SELECT id FROM engines WHERE code = 'DFHA'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319004816; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DFHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DFHA'), 5.5, 5.81, NULL, 'SAE 75W-90', 'HaynesPro typeId t_319004816; 2.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DFHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'engine_oil', (SELECT id FROM engines WHERE code = 'DFGA'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319000777; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DFGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'coolant', (SELECT id FROM engines WHERE code = 'DFGA'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319000777; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DFGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DFGA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_319000777; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DFGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'engine_oil', (SELECT id FROM engines WHERE code = 'DFGC'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319001033; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DFGC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'coolant', (SELECT id FROM engines WHERE code = 'DFGC'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319001033; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DFGC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DFGC'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_319001033; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DFGC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'engine_oil', (SELECT id FROM engines WHERE code = 'CRGB'), 4.7, 4.97, '5W-30', 'VW 505 01', 'HaynesPro typeId t_319008049; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CRGB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'coolant', (SELECT id FROM engines WHERE code = 'CRGB'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319008049; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CRGB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CRGB'), 5.5, 5.81, NULL, 'SAE 75W-90', 'HaynesPro typeId t_319008049; 2.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CRGB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'engine_oil', (SELECT id FROM engines WHERE code = 'DBGA'), 5.5, 5.81, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319004814; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DBGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'coolant', (SELECT id FROM engines WHERE code = 'DBGA'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319004814; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DBGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DBGA'), 5.5, 5.81, NULL, 'SAE 75W-90', 'HaynesPro typeId t_319004814; 2.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DBGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'engine_oil', (SELECT id FROM engines WHERE code = 'DBGC'), 5.5, 5.81, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319004815; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DBGC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'coolant', (SELECT id FROM engines WHERE code = 'DBGC'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319004815; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DBGC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DBGC'), 5.5, 5.81, NULL, 'SAE 75W-90', 'HaynesPro typeId t_319004815; 2.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DBGC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'engine_oil', (SELECT id FROM engines WHERE code = 'CRFD'), 4.7, 4.97, '5W-30', 'VW 505 01', 'HaynesPro typeId t_619012341; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CRFD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'coolant', (SELECT id FROM engines WHERE code = 'CRFD'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_619012341; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CRFD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CRFD'), 5.5, 5.81, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619012341; 2.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CRFD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'engine_oil', (SELECT id FROM engines WHERE code = 'CYKC'), 5.5, 5.81, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319004812; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CYKC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'coolant', (SELECT id FROM engines WHERE code = 'CYKC'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319004812; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CYKC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CYKC'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_319004812; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CYKC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'engine_oil', (SELECT id FROM engines WHERE code = 'DTUA'), 5.5, 5.81, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619035902; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DTUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'coolant', (SELECT id FROM engines WHERE code = 'DTUA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035902; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DTUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DTUA'), 7.2, 7.61, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619035902; 2.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DTUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'engine_oil', (SELECT id FROM engines WHERE code = 'DTSA'), 5.5, 5.81, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619033125; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DTSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'coolant', (SELECT id FROM engines WHERE code = 'DTSA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619033125; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DTSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DTSA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_619033125; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DTSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'engine_oil', (SELECT id FROM engines WHERE code = 'DTSB'), 5.1, 5.39, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619033126; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DTSB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'coolant', (SELECT id FROM engines WHERE code = 'DTSB'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619033126; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DTSB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DTSB'), 7.2, 7.61, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619033126; 2.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DTSB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'engine_oil', (SELECT id FROM engines WHERE code = 'DTRC'), 5.1, 5.39, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619035905; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DTRC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'coolant', (SELECT id FROM engines WHERE code = 'DTRC'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035905; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DTRC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DTRC'), 1.5, 1.59, NULL, 'SAE 75W', 'HaynesPro typeId t_619035905; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DTRC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'engine_oil', (SELECT id FROM engines WHERE code = 'CUAA'), 4.9, 5.18, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319002442; 2.0 TDI Bi-Turbo; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CUAA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'coolant', (SELECT id FROM engines WHERE code = 'CUAA'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319002442; 2.0 TDI Bi-Turbo'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CUAA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CUAA'), 5.5, 5.81, NULL, 'SAE 75W-90', 'HaynesPro typeId t_319002442; 2.0 TDI Bi-Turbo; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CUAA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZPA'), 5.7, 6.02, '5W-40', 'VW 502 00', 'HaynesPro typeId t_319000776; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'coolant', (SELECT id FROM engines WHERE code = 'CZPA'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319000776; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CZPA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_319000776; 2.0 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CZPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'engine_oil', (SELECT id FROM engines WHERE code = 'CHHB'), 5.7, 6.02, '5W-40', 'VW 502 00', 'HaynesPro typeId t_319002443; 2.0 TSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CHHB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'coolant', (SELECT id FROM engines WHERE code = 'CHHB'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319002443; 2.0 TSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CHHB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CHHB'), 5.5, 5.81, NULL, 'SAE 75W-90', 'HaynesPro typeId t_319002443; 2.0 TSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CHHB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'engine_oil', (SELECT id FROM engines WHERE code = 'DGUA'), 5.7, 6.02, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619019254; 2.0 TSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DGUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'coolant', (SELECT id FROM engines WHERE code = 'DGUA'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_619019254; 2.0 TSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DGUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'transmission_at', (SELECT id FROM engines WHERE code = 'DGUA'), NULL, NULL, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619019254; 2.0 TSI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DGUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'engine_oil', (SELECT id FROM engines WHERE code = 'DGVA'), 5.7, 6.02, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619008056; 2.0 TSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DGVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'coolant', (SELECT id FROM engines WHERE code = 'DGVA'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_619008056; 2.0 TSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DGVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DGVA'), 5.5, 5.81, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619008056; 2.0 TSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DGVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'engine_oil', (SELECT id FROM engines WHERE code = 'CXDA'), 5.7, 6.02, '5W-40', 'VW 502 00', 'HaynesPro typeId t_319007874; 2.0 TSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CXDA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'coolant', (SELECT id FROM engines WHERE code = 'CXDA'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319007874; 2.0 TSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CXDA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CXDA'), 5.5, 5.81, NULL, 'SAE 75W-90', 'HaynesPro typeId t_319007874; 2.0 TSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CXDA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'engine_oil', (SELECT id FROM engines WHERE code = 'DKTA'), 5.7, 6.02, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619009875; 2.0 TSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DKTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'coolant', (SELECT id FROM engines WHERE code = 'DKTA'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_619009875; 2.0 TSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DKTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DKTA'), 5.5, 5.81, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619009875; 2.0 TSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DKTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'engine_oil', (SELECT id FROM engines WHERE code = 'DNJA'), 5.7, 6.02, '5W-30', 'VW 504 00', 'HaynesPro typeId t_619012703; 2.0 TSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DNJA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'coolant', (SELECT id FROM engines WHERE code = 'DNJA'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_619012703; 2.0 TSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DNJA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DNJA'), 5.5, 5.81, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619012703; 2.0 TSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DNJA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'engine_oil', (SELECT id FROM engines WHERE code = 'DKZA'), 5.7, 6.02, '0W-30', 'VW 504 00', 'HaynesPro typeId t_619009876; 2.0 TSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DKZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'coolant', (SELECT id FROM engines WHERE code = 'DKZA'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_619009876; 2.0 TSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DKZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DKZA'), 6, 6.34, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619009876; 2.0 TSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DKZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'engine_oil', (SELECT id FROM engines WHERE code = 'DNLA'), 5.7, 6.02, '0W-30', 'VW 504 00', 'HaynesPro typeId t_619016962; 2.0 TSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DNLA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'coolant', (SELECT id FROM engines WHERE code = 'DNLA'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_619016962; 2.0 TSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DNLA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DNLA'), 7.2, 7.61, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619016962; 2.0 TSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DNLA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'engine_oil', (SELECT id FROM engines WHERE code = 'DNPA'), 5.7, 6.02, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619035903; 2.0 TSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DNPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'coolant', (SELECT id FROM engines WHERE code = 'DNPA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035903; 2.0 TSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DNPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DNPA'), 7.2, 7.61, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619035903; 2.0 TSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DNPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'engine_oil', (SELECT id FROM engines WHERE code = 'DNNA'), 5.7, 6.02, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619038109; 2.0 TSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DNNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'coolant', (SELECT id FROM engines WHERE code = 'DNNA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619038109; 2.0 TSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DNNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DNNA'), 6, 6.34, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619038109; 2.0 TSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DNNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'engine_oil', (SELECT id FROM engines WHERE code = 'DTEA'), 5.7, 6.02, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619035901; 2.0 TSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DTEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'coolant', (SELECT id FROM engines WHERE code = 'DTEA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035901; 2.0 TSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DTEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'transmission_at', (SELECT id FROM engines WHERE code = 'DTEA'), NULL, NULL, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619035901; 2.0 TSI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DTEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'engine_oil', (SELECT id FROM engines WHERE code = 'DNFG'), 5.7, 6.02, '0W-30', 'VW 504 00', 'HaynesPro typeId t_619035900; R (2.0 TSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DNFG'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'coolant', (SELECT id FROM engines WHERE code = 'DNFG'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035900; R (2.0 TSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DNFG'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DNFG'), 5.5, 5.81, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619035900; R (2.0 TSI); Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DNFG'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'engine_oil', (SELECT id FROM engines WHERE code = 'DSFE'), 5.7, 6.02, '0W-30', 'VW 504 00', 'HaynesPro typeId t_619112890; R (2.0 TSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DSFE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'coolant', (SELECT id FROM engines WHERE code = 'DSFE'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619112890; R (2.0 TSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DSFE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DSFE'), 5.5, 5.81, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619112890; R (2.0 TSI); Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DSFE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'engine_oil', (SELECT id FROM engines WHERE code = 'DGEA'), 4, 4.23, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619035904; eHybrid (1.4 TSI PHEV); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DGEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'coolant', (SELECT id FROM engines WHERE code = 'DGEA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035904; eHybrid (1.4 TSI PHEV)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DGEA'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 44, 'brake_fluid', NULL, 1, 1.06, NULL, 'VW 501 14', 'HaynesPro chassis d_317000050; Alt: DOT 4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 44 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (44)
  AND e.code IN ('CZEA', 'CZCA', 'CZDA', 'DJVA', 'CZDB', 'DADA', 'DACA', 'DACB', 'DPCA', 'DPBE', 'DXDB', 'DGDB', 'DFHA', 'DFGA', 'DFGC', 'CRGB', 'DBGA', 'DBGC', 'CRFD', 'CYKC', 'DTUA', 'DTSA', 'DTSB', 'DTRC', 'CUAA', 'CZPA', 'CHHB', 'DGUA', 'DGVA', 'CXDA', 'DKTA', 'DNJA', 'DKZA', 'DNLA', 'DNPA', 'DNNA', 'DTEA', 'DNFG', 'DSFE', 'DGEA')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (44)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (44) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;