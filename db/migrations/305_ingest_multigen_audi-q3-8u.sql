-- mig 305 — multi-gen HaynesPro ingest: Audi Q3 (8U)
-- crawl: haynespro-crawl-audi-q3-8u-2026-05-23.json
-- modelId: d_200000005
-- 30 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Audi Q3 (8U)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_200000005', NOW(), 'Multi-gen ingest, 30 engines across 2 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_200000005' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('CHPB', '1.4 TFSI (CHPB) 110kW', 1395, 'petrol', 'turbo', NULL),
  ('CZDA', '1.4 TFSI (CZDA) 110kW', 1395, 'petrol', 'turbo', NULL),
  ('CZEA', '1.4 TFSI (CZEA) 110kW', 1395, 'petrol', 'turbo', NULL),
  ('CWLA', '1.4 TFSI (CWLA) 110kW', 1395, 'petrol', 'turbo', NULL),
  ('CZDB', '1.4 TFSI (CZDB) 92kW', 1395, 'petrol', 'turbo', NULL),
  ('CFGC', '2.0 TDI (CFGC) 130kW', 1968, 'diesel', 'turbo', NULL),
  ('CLLB', '2.0 TDI (CLLB) 130kW', 1968, 'diesel', 'turbo', NULL),
  ('CFGB', '2.0 TDI (CFGB) 125kW', 1968, 'diesel', 'turbo', NULL),
  ('CFGD', '2.0 TDI (CFGD) 120kW', 1968, 'diesel', 'turbo', NULL),
  ('CFFB', '2.0 TDI (CFFB) 103kW', 1968, 'diesel', 'turbo', NULL),
  ('CFFA', '2.0 TDI (CFFA) 100kW', 1968, 'diesel', 'turbo', NULL),
  ('CLJA', '2.0 TDI (CLJA) 103kW', 1968, 'diesel', 'turbo', NULL),
  ('CUWA', '2.0 TDI (CUWA) 135kW', 1968, 'diesel', 'turbo', NULL),
  ('CYLA', '2.0 TDI (CYLA) 135kW', 1968, 'diesel', 'turbo', NULL),
  ('CUVC', '2.0 TDI (CUVC) 110kW', 1968, 'diesel', 'turbo', NULL),
  ('CUVB', '2.0 TDI (CUVB) 100kW', 1968, 'diesel', 'turbo', NULL),
  ('CUVD', '2.0 TDI (CUVD) 88kW', 1968, 'diesel', 'turbo', NULL),
  ('DFUA', '2.0 TDI (DFUA) 135kW', 1968, 'diesel', 'turbo', NULL),
  ('DBBA', '2.0 TDI (DBBA) 110kW', 1968, 'diesel', 'turbo', NULL),
  ('DFTA', '2.0 TDI (DFTA) 110kW', 1968, 'diesel', 'turbo', NULL),
  ('DFTB', '2.0 TDI (DFTB) 100kW', 1968, 'diesel', 'turbo', NULL),
  ('DFTC', '2.0 TDI (DFTC) 88kW', 1968, 'diesel', 'turbo', NULL),
  ('CPSA', '2.0 TFSI (CPSA) 155kW', 1984, 'petrol', 'turbo', NULL),
  ('CCZC', '2.0 TFSI (CCZC) 125kW', 1984, 'petrol', 'turbo', NULL),
  ('CCTA', '2.0 TFSI (CCTA) 147kW', 1984, 'petrol', 'turbo', NULL),
  ('CULC', '2.0 TFSI (CULC) 162kW', 1984, 'petrol', 'turbo', NULL),
  ('CULB', '2.0 TFSI (CULB) 132kW', 1984, 'petrol', 'turbo', NULL),
  ('CTSA', 'RSQ3 (2.5 TFSI) (CTSA) 228kW', 2480, 'petrol', 'turbo', NULL),
  ('CZGA', 'RSQ3 (2.5 TFSI) (CZGA) 250kW', 2480, 'petrol', 'turbo', NULL),
  ('CZGB', 'RSQ3 (2.5 TFSI) (CZGB) 270kW', 2480, 'petrol', 'turbo', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'engine_oil', (SELECT id FROM engines WHERE code = 'CHPB'), 4, 4.23, '5W-40', 'VW 502 00', 'HaynesPro typeId t_301000621; 1.4 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CHPB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'coolant', (SELECT id FROM engines WHERE code = 'CHPB'), NULL, NULL, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_301000621; 1.4 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CHPB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CHPB'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_301000621; 1.4 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CHPB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZDA'), 4, 4.23, '5W-40', 'VW 502 00', 'HaynesPro typeId t_318011846; 1.4 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZDA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'coolant', (SELECT id FROM engines WHERE code = 'CZDA'), NULL, NULL, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_318011846; 1.4 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZDA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CZDA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_318011846; 1.4 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CZDA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZEA'), 4, 4.23, '0W-20', 'VW 508 00', 'HaynesPro typeId t_311000036; 1.4 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'coolant', (SELECT id FROM engines WHERE code = 'CZEA'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_311000036; 1.4 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CZEA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_311000036; 1.4 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CZEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'engine_oil', (SELECT id FROM engines WHERE code = 'CWLA'), 4, 4.23, '5W-40', 'VW 502 00', 'HaynesPro typeId t_319005468; 1.4 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CWLA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'coolant', (SELECT id FROM engines WHERE code = 'CWLA'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319005468; 1.4 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CWLA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CWLA'), 6.9, 7.29, NULL, NULL, 'HaynesPro typeId t_319005468; 1.4 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CWLA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZDB'), 4, 4.23, '5W-40', 'VW 502 00', 'HaynesPro typeId t_319001147; 1.4 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZDB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'coolant', (SELECT id FROM engines WHERE code = 'CZDB'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319001147; 1.4 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZDB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CZDB'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_319001147; 1.4 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CZDB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'engine_oil', (SELECT id FROM engines WHERE code = 'CFGC'), 4.3, 4.54, '5W-30', 'VW 507 00', 'HaynesPro typeId t_200000058; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CFGC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'coolant', (SELECT id FROM engines WHERE code = 'CFGC'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_200000058; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CFGC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CFGC'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_200000058; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CFGC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'engine_oil', (SELECT id FROM engines WHERE code = 'CLLB'), 4.3, 4.54, '5W-30', 'VW 507 00', 'HaynesPro typeId t_200000232; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CLLB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'coolant', (SELECT id FROM engines WHERE code = 'CLLB'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_200000232; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CLLB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CLLB'), 5.5, 5.81, NULL, 'SAE 75W-90', 'HaynesPro typeId t_200000232; 2.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CLLB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'engine_oil', (SELECT id FROM engines WHERE code = 'CFGB'), 4.3, 4.54, '5W-30', 'VW 507 00', 'HaynesPro typeId t_619017242; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CFGB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'coolant', (SELECT id FROM engines WHERE code = 'CFGB'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_619017242; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CFGB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CFGB'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_619017242; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CFGB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'engine_oil', (SELECT id FROM engines WHERE code = 'CFGD'), 4.3, 4.54, '5W-30', 'VW 507 00', 'HaynesPro typeId t_201000008; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CFGD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'coolant', (SELECT id FROM engines WHERE code = 'CFGD'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_201000008; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CFGD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CFGD'), 5.5, 5.81, NULL, 'SAE 75W-90', 'HaynesPro typeId t_201000008; 2.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CFGD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'engine_oil', (SELECT id FROM engines WHERE code = 'CFFB'), 4.3, 4.54, '5W-30', 'VW 507 00', 'HaynesPro typeId t_200000123; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CFFB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'coolant', (SELECT id FROM engines WHERE code = 'CFFB'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_200000123; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CFFB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CFFB'), 5.5, 5.81, NULL, 'SAE 75W', 'HaynesPro typeId t_200000123; 2.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CFFB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'engine_oil', (SELECT id FROM engines WHERE code = 'CFFA'), 4.3, 4.54, '5W-30', 'VW 507 00', 'HaynesPro typeId t_200000231; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CFFA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'coolant', (SELECT id FROM engines WHERE code = 'CFFA'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_200000231; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CFFA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CFFA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_200000231; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CFFA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'engine_oil', (SELECT id FROM engines WHERE code = 'CLJA'), 4.3, 4.54, '5W-30', 'VW 507 00', 'HaynesPro typeId t_301000622; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CLJA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'coolant', (SELECT id FROM engines WHERE code = 'CLJA'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_301000622; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CLJA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CLJA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_301000622; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CLJA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'engine_oil', (SELECT id FROM engines WHERE code = 'CUWA'), 4.7, 4.97, '5W-30', 'VW 507 00', 'HaynesPro typeId t_313000036; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CUWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'coolant', (SELECT id FROM engines WHERE code = 'CUWA'), 8.9, 9.4, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_313000036; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CUWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CUWA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_313000036; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CUWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'engine_oil', (SELECT id FROM engines WHERE code = 'CYLA'), 5.5, 5.81, '5W-30', 'VW 507 00', 'HaynesPro typeId t_318011845; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CYLA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'coolant', (SELECT id FROM engines WHERE code = 'CYLA'), 8.9, 9.4, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_318011845; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CYLA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CYLA'), 5.5, 5.81, NULL, 'SAE 75W-90', 'HaynesPro typeId t_318011845; 2.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CYLA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'engine_oil', (SELECT id FROM engines WHERE code = 'CUVC'), 4.7, 4.97, '5W-30', 'VW 507 00', 'HaynesPro typeId t_313000037; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CUVC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'coolant', (SELECT id FROM engines WHERE code = 'CUVC'), 8.9, 9.4, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_313000037; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CUVC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CUVC'), 5.5, 5.81, NULL, 'SAE 75W', 'HaynesPro typeId t_313000037; 2.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CUVC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'engine_oil', (SELECT id FROM engines WHERE code = 'CUVB'), 4.7, 4.97, '5W-30', 'VW 507 00', 'HaynesPro typeId t_319005467; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CUVB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'coolant', (SELECT id FROM engines WHERE code = 'CUVB'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319005467; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CUVB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CUVB'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_319005467; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CUVB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'engine_oil', (SELECT id FROM engines WHERE code = 'CUVD'), 4.7, 4.97, '5W-30', 'VW 507 00', 'HaynesPro typeId t_318011844; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CUVD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'coolant', (SELECT id FROM engines WHERE code = 'CUVD'), NULL, NULL, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_318011844; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CUVD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CUVD'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_318011844; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CUVD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'engine_oil', (SELECT id FROM engines WHERE code = 'DFUA'), 4.7, 4.97, '5W-30', 'VW 507 00', 'HaynesPro typeId t_318012052; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DFUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'coolant', (SELECT id FROM engines WHERE code = 'DFUA'), NULL, NULL, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_318012052; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DFUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DFUA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_318012052; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DFUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'engine_oil', (SELECT id FROM engines WHERE code = 'DBBA'), 5.5, 5.81, '5W-30', 'VW 507 00', 'HaynesPro typeId t_319004617; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DBBA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'coolant', (SELECT id FROM engines WHERE code = 'DBBA'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319004617; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DBBA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DBBA'), 5.5, 5.81, NULL, 'SAE 75W-90', 'HaynesPro typeId t_319004617; 2.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DBBA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'engine_oil', (SELECT id FROM engines WHERE code = 'DFTA'), 4.7, 4.97, '5W-30', 'VW 507 00', 'HaynesPro typeId t_318012051; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DFTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'coolant', (SELECT id FROM engines WHERE code = 'DFTA'), 8.9, 9.4, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_318012051; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DFTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DFTA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_318012051; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DFTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'engine_oil', (SELECT id FROM engines WHERE code = 'DFTB'), 4.7, 4.97, '5W-30', 'VW 507 00', 'HaynesPro typeId t_319004619; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DFTB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'coolant', (SELECT id FROM engines WHERE code = 'DFTB'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319004619; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DFTB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DFTB'), 5.5, 5.81, NULL, 'SAE 75W', 'HaynesPro typeId t_319004619; 2.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DFTB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'engine_oil', (SELECT id FROM engines WHERE code = 'DFTC'), 4.7, 4.97, '5W-30', 'VW 507 00', 'HaynesPro typeId t_319004621; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DFTC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'coolant', (SELECT id FROM engines WHERE code = 'DFTC'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319004621; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DFTC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DFTC'), 5.5, 5.81, NULL, 'SAE 75W', 'HaynesPro typeId t_319004621; 2.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DFTC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'engine_oil', (SELECT id FROM engines WHERE code = 'CPSA'), 4.6, 4.86, '5W-40', 'VW 502 00', 'HaynesPro typeId t_200000060; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CPSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'coolant', (SELECT id FROM engines WHERE code = 'CPSA'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_200000060; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CPSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CPSA'), 5.5, 5.81, NULL, 'SAE 75W-90', 'HaynesPro typeId t_200000060; 2.0 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CPSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'engine_oil', (SELECT id FROM engines WHERE code = 'CCZC'), 4.6, 4.86, '5W-40', 'VW 502 00', 'HaynesPro typeId t_200000059; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CCZC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'coolant', (SELECT id FROM engines WHERE code = 'CCZC'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_200000059; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CCZC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CCZC'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_200000059; 2.0 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CCZC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'engine_oil', (SELECT id FROM engines WHERE code = 'CCTA'), 4.6, 4.86, '5W-40', 'VW 502 00', 'HaynesPro typeId t_619008016; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CCTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'coolant', (SELECT id FROM engines WHERE code = 'CCTA'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_619008016; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CCTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'transmission_at', (SELECT id FROM engines WHERE code = 'CCTA'), 7, 7.4, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619008016; 2.0 TFSI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CCTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'engine_oil', (SELECT id FROM engines WHERE code = 'CULC'), 5.7, 6.02, '0W-30', 'VW 502 00', 'HaynesPro typeId t_311000035; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CULC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'coolant', (SELECT id FROM engines WHERE code = 'CULC'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_311000035; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CULC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CULC'), 5.5, 5.81, NULL, 'SAE 75W-90', 'HaynesPro typeId t_311000035; 2.0 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CULC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'engine_oil', (SELECT id FROM engines WHERE code = 'CULB'), 5.7, 6.02, '0W-30', 'VW 502 00', 'HaynesPro typeId t_313000038; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CULB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'coolant', (SELECT id FROM engines WHERE code = 'CULB'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_313000038; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CULB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CULB'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_313000038; 2.0 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CULB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 279, 'engine_oil', (SELECT id FROM engines WHERE code = 'CTSA'), 6.5, 6.87, '5W-40', 'VW 502 00', 'HaynesPro typeId t_1000059; RSQ3 (2.5 TFSI); drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 279 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CTSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 279, 'coolant', (SELECT id FROM engines WHERE code = 'CTSA'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_1000059; RSQ3 (2.5 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 279 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CTSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 279, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CTSA'), 5.5, 5.81, NULL, 'SAE 75W-90', 'HaynesPro typeId t_1000059; RSQ3 (2.5 TFSI); Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 279 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CTSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 279, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZGA'), 6.8, 7.19, '5W-40', 'VW 502 00', 'HaynesPro typeId t_317000199; RSQ3 (2.5 TFSI); drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 279 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 279, 'coolant', (SELECT id FROM engines WHERE code = 'CZGA'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_317000199; RSQ3 (2.5 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 279 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 279, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CZGA'), 5.5, 5.81, NULL, 'SAE 75W-90', 'HaynesPro typeId t_317000199; RSQ3 (2.5 TFSI); Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 279 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CZGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 279, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZGB'), 6.8, 7.19, '5W-40', 'VW 502 00', 'HaynesPro typeId t_319004593; RSQ3 (2.5 TFSI); drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 279 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZGB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 279, 'coolant', (SELECT id FROM engines WHERE code = 'CZGB'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319004593; RSQ3 (2.5 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 279 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZGB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 279, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CZGB'), 5.5, 5.81, NULL, 'SAE 75W-90', 'HaynesPro typeId t_319004593; RSQ3 (2.5 TFSI); Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 279 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CZGB'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 278, 'brake_fluid', NULL, 1, 1.06, NULL, 'VW 501 14', 'HaynesPro chassis d_200000005; Alt: DOT 4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 278 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 279, 'brake_fluid', NULL, 1, 1.06, NULL, 'VW 501 14', 'HaynesPro chassis d_200000005; Alt: DOT 4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 279 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (278, 279)
  AND e.code IN ('CHPB', 'CZDA', 'CZEA', 'CWLA', 'CZDB', 'CFGC', 'CLLB', 'CFGB', 'CFGD', 'CFFB', 'CFFA', 'CLJA', 'CUWA', 'CYLA', 'CUVC', 'CUVB', 'CUVD', 'DFUA', 'DBBA', 'DFTA', 'DFTB', 'DFTC', 'CPSA', 'CCZC', 'CCTA', 'CULC', 'CULB', 'CTSA', 'CZGA', 'CZGB')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (278, 279)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (278, 279) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;