-- mig 309 — multi-gen HaynesPro ingest: Audi A7 (4G)
-- crawl: haynespro-crawl-audi-a7-4g-2026-05-23.json
-- modelId: d_102000177
-- 40 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Audi A7 (4G)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_102000177', NOW(), 'Multi-gen ingest, 40 engines across 2 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_102000177' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('CYGA', '1.8 TFSI (CYGA) 140kW', 1798, 'petrol', 'turbo', NULL),
  ('CYNB', '2.0 TFSI (CYNB) 185kW', 1984, 'petrol', 'turbo', NULL),
  ('CYPA', '2.0 TFSI (CYPA) 185kW', 1984, 'petrol', 'turbo', NULL),
  ('CYPB', '2.0 TFSI (CYPB) 183kW', 1984, 'petrol', 'turbo', NULL),
  ('CNYA', '2.8 FSI (CNYA) 150kW', 2773, 'petrol', 'NA', NULL),
  ('CHVA', '2.8 FSi (CHVA) 150kW', 2773, 'petrol', 'NA', NULL),
  ('CVPA', '2.8 FSi (CVPA) 162kW', 2773, 'petrol', 'NA', NULL),
  ('CDUC', '3.0 TDI (CDUC) 180kW', 2967, 'diesel', 'turbo', NULL),
  ('CLAA', '3.0 TDI (CLAA) 150kW', 2967, 'diesel', 'turbo', NULL),
  ('CLAB', '3.0 TDI (CLAB) 150kW', 2967, 'diesel', 'turbo', NULL),
  ('CGQB', '3.0 TDI (CGQB) 230kW', 2967, 'diesel', 'turbo', NULL),
  ('CDUD', '3.0 TDI (CDUD) 180kW', 2967, 'diesel', 'turbo', NULL),
  ('CKVB', '3.0 TDI (CKVB) 180kW', 2967, 'diesel', 'turbo', NULL),
  ('CKVC', '3.0 TDI (CKVC) 180kW', 2967, 'diesel', 'turbo', NULL),
  ('CPNB', '3.0 TDI (CPNB) 180kW', 2967, 'diesel', 'turbo', NULL),
  ('CVUB', '3.0 TDI (CVUB) 240kW', 2967, 'diesel', 'turbo', NULL),
  ('CVUA', '3.0 TDI (CVUA) 235kW', 2967, 'diesel', 'turbo', NULL),
  ('CRTD', '3.0 TDI (CRTD) 200kW', 2967, 'diesel', 'turbo', NULL),
  ('CRTE', '3.0 TDI (CRTE) 160kW', 2967, 'diesel', 'turbo', NULL),
  ('CTCC', '3.0 TDI (CTCC) 160kW', 2967, 'diesel', 'turbo', NULL),
  ('CRTF', '3.0 TDI (CRTF) 155kW', 2967, 'diesel', 'turbo', NULL),
  ('CTCB', '3.0 TDI (CTCB) 155kW', 2967, 'diesel', 'turbo', NULL),
  ('CZVA', '3.0 TDI (CZVA) 160kW', 2967, 'diesel', 'turbo', NULL),
  ('CZVB', '3.0 TDI (CZVB) 160kW', 2967, 'diesel', 'turbo', NULL),
  ('CZVC', '3.0 TDI (CZVC) 155kW', 2967, 'diesel', 'turbo', NULL),
  ('CZVD', '3.0 TDI (CZVD) 155kW', 2967, 'diesel', 'turbo', NULL),
  ('CZVE', '3.0 TDI (CZVE) 140kW', 2967, 'diesel', 'turbo', NULL),
  ('CZVF', '3.0 TDI (CZVF) 140kW', 2967, 'diesel', 'turbo', NULL),
  ('CHMA', '3.0 TFSI (CHMA) 220kW', 2995, 'petrol', 'turbo', NULL),
  ('CGXB', '3.0 TFSI (CGXB) 228kW', 2995, 'petrol', 'turbo', NULL),
  ('CGWB', '3.0 TFSI (CGWB) 220kW', 2995, 'petrol', 'turbo', NULL),
  ('CGWD', '3.0 TFSI (CGWD) 228kW', 2995, 'petrol', 'turbo', NULL),
  ('CTUA', '3.0 TFSI (CTUA) 228kW', 2995, 'petrol', 'turbo', NULL),
  ('CREH', '3.0 TFSI (CREH) 250kW', 2995, 'petrol', 'turbo', NULL),
  ('CREC', '3.0 TFSI (CREC) 244kW', 2995, 'petrol', 'turbo', NULL),
  ('CRDB', 'RS7 (4.0 V8 TFSI) (CRDB) 412kW', 3993, 'petrol', 'turbo', NULL),
  ('CWUB', 'RS7 (4.0 V8 TFSI) (CWUB) 412kW', 3993, 'petrol', 'turbo', NULL),
  ('CWUC', 'RS7 (4.0 V8 TFSI) (CWUC) 445kW', 3993, 'petrol', 'turbo', NULL),
  ('CEUC', 'S7 (4.0 V8 TFSI) (CEUC) 309kW', 3993, 'petrol', 'turbo', NULL),
  ('CTGE', 'S7 (4.0 V8 TFSI) (CTGE) 331kW', 3993, 'petrol', 'turbo', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'engine_oil', (SELECT id FROM engines WHERE code = 'CYGA'), 4.6, 4.86, '0W-30', 'VW 502 00', 'HaynesPro typeId t_317000559; 1.8 TFSI; drain 31 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CYGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'coolant', (SELECT id FROM engines WHERE code = 'CYGA'), NULL, NULL, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_317000559; 1.8 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CYGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CYGA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_317000559; 1.8 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CYGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'engine_oil', (SELECT id FROM engines WHERE code = 'CYNB'), 4.6, 4.86, '0W-30', 'VW 502 00', 'HaynesPro typeId t_318011851; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CYNB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'coolant', (SELECT id FROM engines WHERE code = 'CYNB'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_318011851; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CYNB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'transmission_at', (SELECT id FROM engines WHERE code = 'CYNB'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_318011851; 2.0 TFSI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CYNB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'engine_oil', (SELECT id FROM engines WHERE code = 'CYPA'), 4.6, 4.86, '0W-30', 'VW 502 00', 'HaynesPro typeId t_311000038; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CYPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'coolant', (SELECT id FROM engines WHERE code = 'CYPA'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_311000038; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CYPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CYPA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_311000038; 2.0 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CYPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'engine_oil', (SELECT id FROM engines WHERE code = 'CYPB'), 4.6, 4.86, '0W-30', 'VW 502 00', 'HaynesPro typeId t_318011839; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CYPB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'coolant', (SELECT id FROM engines WHERE code = 'CYPB'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_318011839; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CYPB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CYPB'), 4.35, 4.6, NULL, 'SAE 75W-80', 'HaynesPro typeId t_318011839; 2.0 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CYPB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'engine_oil', (SELECT id FROM engines WHERE code = 'CNYA'), 6.8, 7.19, '5W-40', 'VW 502 00', 'HaynesPro typeId t_619017310; 2.8 FSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CNYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'coolant', (SELECT id FROM engines WHERE code = 'CNYA'), NULL, NULL, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_619017310; 2.8 FSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CNYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CNYA'), 4.35, 4.6, NULL, 'VW G 052 513 A2', 'HaynesPro typeId t_619017310; 2.8 FSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CNYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'engine_oil', (SELECT id FROM engines WHERE code = 'CHVA'), 6.8, 7.19, '5W-40', 'VW 502 00', 'HaynesPro typeId t_106000245; 2.8 FSi; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CHVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'coolant', (SELECT id FROM engines WHERE code = 'CHVA'), 11.5, 12.15, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_106000245; 2.8 FSi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CHVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CHVA'), 4.35, 4.6, NULL, 'VW G 052 513 A2', 'HaynesPro typeId t_106000245; 2.8 FSi; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CHVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'engine_oil', (SELECT id FROM engines WHERE code = 'CVPA'), 6.8, 7.19, '5W-40', 'VW 502 00', 'HaynesPro typeId t_319005465; 2.8 FSi; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CVPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'coolant', (SELECT id FROM engines WHERE code = 'CVPA'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319005465; 2.8 FSi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CVPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CVPA'), 4.35, 4.6, NULL, 'SAE 75W-80', 'HaynesPro typeId t_319005465; 2.8 FSi; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CVPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'engine_oil', (SELECT id FROM engines WHERE code = 'CDUC'), 6.4, 6.76, '5W-30', 'VW 507 00', 'HaynesPro typeId t_106000240; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CDUC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'coolant', (SELECT id FROM engines WHERE code = 'CDUC'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_106000240; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CDUC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CDUC'), 4.35, 4.6, NULL, 'VW G 052 513 A2', 'HaynesPro typeId t_106000240; 3.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CDUC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'engine_oil', (SELECT id FROM engines WHERE code = 'CLAA'), 6.4, 6.76, '5W-30', 'VW 507 00', 'HaynesPro typeId t_106000246; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CLAA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'coolant', (SELECT id FROM engines WHERE code = 'CLAA'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_106000246; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CLAA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CLAA'), 4.35, 4.6, NULL, 'VW G 052 513 A2', 'HaynesPro typeId t_106000246; 3.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CLAA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'engine_oil', (SELECT id FROM engines WHERE code = 'CLAB'), 6.4, 6.76, '5W-30', 'VW 507 00', 'HaynesPro typeId t_106000247; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CLAB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'coolant', (SELECT id FROM engines WHERE code = 'CLAB'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_106000247; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CLAB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'transmission_cvt', (SELECT id FROM engines WHERE code = 'CLAB'), 8, 8.45, NULL, 'VW G 052 516 A', 'HaynesPro typeId t_106000247; 3.0 TDI; CVT'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'transmission_cvt' AND engine_id = (SELECT id FROM engines WHERE code = 'CLAB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'engine_oil', (SELECT id FROM engines WHERE code = 'CGQB'), 6.4, 6.76, '5W-30', 'VW 507 00', 'HaynesPro typeId t_106000242; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CGQB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'coolant', (SELECT id FROM engines WHERE code = 'CGQB'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_106000242; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CGQB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'transmission_at', (SELECT id FROM engines WHERE code = 'CGQB'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_106000242; 3.0 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CGQB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'engine_oil', (SELECT id FROM engines WHERE code = 'CDUD'), 6.4, 6.76, '5W-30', 'VW 507 00', 'HaynesPro typeId t_200000226; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CDUD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'coolant', (SELECT id FROM engines WHERE code = 'CDUD'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_200000226; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CDUD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CDUD'), 4.35, 4.6, NULL, 'SAE 75W-80', 'HaynesPro typeId t_200000226; 3.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CDUD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'engine_oil', (SELECT id FROM engines WHERE code = 'CKVB'), 6.4, 6.76, '5W-30', 'VW 507 00', 'HaynesPro typeId t_102002285; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CKVB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'coolant', (SELECT id FROM engines WHERE code = 'CKVB'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102002285; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CKVB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CKVB'), 4.35, 4.6, NULL, 'SAE 75W-80', 'HaynesPro typeId t_102002285; 3.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CKVB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'engine_oil', (SELECT id FROM engines WHERE code = 'CKVC'), 6.4, 6.76, '5W-30', 'VW 507 00', 'HaynesPro typeId t_301000608; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CKVC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'coolant', (SELECT id FROM engines WHERE code = 'CKVC'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_301000608; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CKVC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CKVC'), 4.35, 4.6, NULL, 'SAE 75W-80', 'HaynesPro typeId t_301000608; 3.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CKVC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'engine_oil', (SELECT id FROM engines WHERE code = 'CPNB'), 6.4, 6.76, '5W-30', 'VW 507 00', 'HaynesPro typeId t_201000090; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CPNB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'coolant', (SELECT id FROM engines WHERE code = 'CPNB'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_201000090; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CPNB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'transmission_at', (SELECT id FROM engines WHERE code = 'CPNB'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_201000090; 3.0 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CPNB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'engine_oil', (SELECT id FROM engines WHERE code = 'CVUB'), 6.4, 6.76, '5W-30', 'VW 507 00', 'HaynesPro typeId t_317000203; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CVUB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'coolant', (SELECT id FROM engines WHERE code = 'CVUB'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_317000203; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CVUB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'transmission_at', (SELECT id FROM engines WHERE code = 'CVUB'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_317000203; 3.0 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CVUB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'engine_oil', (SELECT id FROM engines WHERE code = 'CVUA'), 6.4, 6.76, '5W-30', 'VW 507 00', 'HaynesPro typeId t_305000535; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CVUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'coolant', (SELECT id FROM engines WHERE code = 'CVUA'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_305000535; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CVUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'transmission_at', (SELECT id FROM engines WHERE code = 'CVUA'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_305000535; 3.0 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CVUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'engine_oil', (SELECT id FROM engines WHERE code = 'CRTD'), 6.1, 6.45, '5W-30', 'VW 507 00', 'HaynesPro typeId t_305000532; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CRTD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'coolant', (SELECT id FROM engines WHERE code = 'CRTD'), 11.5, 12.15, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_305000532; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CRTD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CRTD'), 4.35, 4.6, NULL, 'SAE 75W-80', 'HaynesPro typeId t_305000532; 3.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CRTD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'engine_oil', (SELECT id FROM engines WHERE code = 'CRTE'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_305000531; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CRTE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'coolant', (SELECT id FROM engines WHERE code = 'CRTE'), NULL, NULL, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_305000531; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CRTE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CRTE'), 4.35, 4.6, NULL, 'SAE 75W-80', 'HaynesPro typeId t_305000531; 3.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CRTE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'engine_oil', (SELECT id FROM engines WHERE code = 'CTCC'), 6.4, 6.76, '0W-30', 'VW 507 00', 'HaynesPro typeId t_305000533; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CTCC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'coolant', (SELECT id FROM engines WHERE code = 'CTCC'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_305000533; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CTCC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CTCC'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_305000533; 3.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CTCC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'engine_oil', (SELECT id FROM engines WHERE code = 'CRTF'), 6.1, 6.45, '5W-30', 'VW 507 00', 'HaynesPro typeId t_305000537; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CRTF'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'coolant', (SELECT id FROM engines WHERE code = 'CRTF'), NULL, NULL, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_305000537; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CRTF'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CRTF'), 4.35, 4.6, NULL, 'SAE 75W-80', 'HaynesPro typeId t_305000537; 3.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CRTF'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'engine_oil', (SELECT id FROM engines WHERE code = 'CTCB'), 6.4, 6.76, '5W-30', 'VW 507 00', 'HaynesPro typeId t_305000538; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CTCB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'coolant', (SELECT id FROM engines WHERE code = 'CTCB'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_305000538; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CTCB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CTCB'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_305000538; 3.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CTCB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZVA'), 6.1, 6.45, '0W-20', 'VW 509 00', 'HaynesPro typeId t_318012056; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'coolant', (SELECT id FROM engines WHERE code = 'CZVA'), NULL, NULL, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_318012056; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CZVA'), 4.35, 4.6, NULL, 'SAE 75W-80', 'HaynesPro typeId t_318012056; 3.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CZVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZVB'), 6.1, 6.45, '0W-20', 'VW 509 00', 'HaynesPro typeId t_318012055; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZVB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'coolant', (SELECT id FROM engines WHERE code = 'CZVB'), NULL, NULL, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_318012055; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZVB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CZVB'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_318012055; 3.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CZVB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZVC'), 6.1, 6.45, '5W-30', 'VW 507 00', 'HaynesPro typeId t_319004613; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZVC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'coolant', (SELECT id FROM engines WHERE code = 'CZVC'), NULL, NULL, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319004613; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZVC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CZVC'), 4.35, 4.6, NULL, 'SAE 75W-80', 'HaynesPro typeId t_319004613; 3.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CZVC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZVD'), 6.1, 6.45, '5W-30', 'VW 507 00', 'HaynesPro typeId t_319000300; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZVD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'coolant', (SELECT id FROM engines WHERE code = 'CZVD'), NULL, NULL, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319000300; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZVD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CZVD'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_319000300; 3.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CZVD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZVE'), 6.1, 6.45, '5W-30', 'VW 507 00', 'HaynesPro typeId t_319000299; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZVE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'coolant', (SELECT id FROM engines WHERE code = 'CZVE'), NULL, NULL, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319000299; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZVE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CZVE'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_319000299; 3.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CZVE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZVF'), 6.1, 6.45, '5W-30', 'VW 507 00', 'HaynesPro typeId t_319000298; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZVF'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'coolant', (SELECT id FROM engines WHERE code = 'CZVF'), NULL, NULL, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319000298; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZVF'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CZVF'), 4.35, 4.6, NULL, 'SAE 75W-80', 'HaynesPro typeId t_319000298; 3.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CZVF'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'engine_oil', (SELECT id FROM engines WHERE code = 'CHMA'), 6.8, 7.19, '0W-40', 'VW 511 00', 'HaynesPro typeId t_619017309; 3.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CHMA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'coolant', (SELECT id FROM engines WHERE code = 'CHMA'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_619017309; 3.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CHMA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CHMA'), 4.35, 4.6, NULL, 'SAE 75W-80', 'HaynesPro typeId t_619017309; 3.0 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CHMA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'engine_oil', (SELECT id FROM engines WHERE code = 'CGXB'), 6.8, 7.19, '5W-40', 'VW 502 00', 'HaynesPro typeId t_106000244; 3.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CGXB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'coolant', (SELECT id FROM engines WHERE code = 'CGXB'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_106000244; 3.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CGXB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'transmission_at', (SELECT id FROM engines WHERE code = 'CGXB'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_106000244; 3.0 TFSI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CGXB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'engine_oil', (SELECT id FROM engines WHERE code = 'CGWB'), 6.8, 7.19, '5W-40', 'VW 502 00', 'HaynesPro typeId t_106000243; 3.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CGWB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'coolant', (SELECT id FROM engines WHERE code = 'CGWB'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_106000243; 3.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CGWB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CGWB'), 4.35, 4.6, NULL, 'VW G 052 513 A2', 'HaynesPro typeId t_106000243; 3.0 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CGWB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'engine_oil', (SELECT id FROM engines WHERE code = 'CGWD'), 6.8, 7.19, '5W-40', 'VW 502 00', 'HaynesPro typeId t_200000227; 3.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CGWD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'coolant', (SELECT id FROM engines WHERE code = 'CGWD'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_200000227; 3.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CGWD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CGWD'), 4.35, 4.6, NULL, 'SAE 75W-80', 'HaynesPro typeId t_200000227; 3.0 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CGWD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'engine_oil', (SELECT id FROM engines WHERE code = 'CTUA'), 6.8, 7.19, '5W-40', 'VW 502 00', 'HaynesPro typeId t_200000228; 3.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CTUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'coolant', (SELECT id FROM engines WHERE code = 'CTUA'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_200000228; 3.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CTUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'transmission_at', (SELECT id FROM engines WHERE code = 'CTUA'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_200000228; 3.0 TFSI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CTUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'engine_oil', (SELECT id FROM engines WHERE code = 'CREH'), NULL, NULL, '5W-40', 'VW 502 00', 'HaynesPro typeId t_619019481; 3.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CREH'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'coolant', (SELECT id FROM engines WHERE code = 'CREH'), 15, 15.85, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_619019481; 3.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CREH'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'transmission_at', (SELECT id FROM engines WHERE code = 'CREH'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_619019481; 3.0 TFSI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CREH'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'engine_oil', (SELECT id FROM engines WHERE code = 'CREC'), 6.8, 7.19, '5W-40', 'VW 502 00', 'HaynesPro typeId t_305000534; 3.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CREC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'coolant', (SELECT id FROM engines WHERE code = 'CREC'), 11.5, 12.15, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_305000534; 3.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CREC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CREC'), 4.35, 4.6, NULL, 'SAE 75W-80', 'HaynesPro typeId t_305000534; 3.0 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CREC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 284, 'engine_oil', (SELECT id FROM engines WHERE code = 'CRDB'), 8.7, 9.19, '5W-40', 'VW 502 00', 'HaynesPro typeId t_301000537; RS7 (4.0 V8 TFSI); drain 20 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 284 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CRDB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 284, 'coolant', (SELECT id FROM engines WHERE code = 'CRDB'), 15, 15.85, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_301000537; RS7 (4.0 V8 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 284 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CRDB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 284, 'transmission_at', (SELECT id FROM engines WHERE code = 'CRDB'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_301000537; RS7 (4.0 V8 TFSI); Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 284 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CRDB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 284, 'engine_oil', (SELECT id FROM engines WHERE code = 'CWUB'), 8.7, 9.19, '0W-30', 'VW 502 00', 'HaynesPro typeId t_317000210; RS7 (4.0 V8 TFSI); drain 20 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 284 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CWUB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 284, 'coolant', (SELECT id FROM engines WHERE code = 'CWUB'), 15, 15.85, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_317000210; RS7 (4.0 V8 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 284 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CWUB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 284, 'transmission_at', (SELECT id FROM engines WHERE code = 'CWUB'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_317000210; RS7 (4.0 V8 TFSI); Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 284 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CWUB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 284, 'engine_oil', (SELECT id FROM engines WHERE code = 'CWUC'), 8.7, 9.19, '0W-30', 'VW 502 00', 'HaynesPro typeId t_319000297; RS7 (4.0 V8 TFSI); drain 20 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 284 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CWUC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 284, 'coolant', (SELECT id FROM engines WHERE code = 'CWUC'), 15, 15.85, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319000297; RS7 (4.0 V8 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 284 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CWUC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 284, 'transmission_at', (SELECT id FROM engines WHERE code = 'CWUC'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_319000297; RS7 (4.0 V8 TFSI); Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 284 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CWUC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'engine_oil', (SELECT id FROM engines WHERE code = 'CEUC'), 8.3, 8.77, '5W-40', 'VW 502 00', 'HaynesPro typeId t_106000241; S7 (4.0 V8 TFSI); drain 20 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CEUC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'coolant', (SELECT id FROM engines WHERE code = 'CEUC'), 15, 15.85, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_106000241; S7 (4.0 V8 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CEUC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CEUC'), 4.35, 4.6, NULL, 'SAE 75W-80', 'HaynesPro typeId t_106000241; S7 (4.0 V8 TFSI); Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CEUC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'engine_oil', (SELECT id FROM engines WHERE code = 'CTGE'), 8.3, 8.77, '5W-40', 'VW 502 00', 'HaynesPro typeId t_305000536; S7 (4.0 V8 TFSI); drain 20 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CTGE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'coolant', (SELECT id FROM engines WHERE code = 'CTGE'), 15, 15.85, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_305000536; S7 (4.0 V8 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CTGE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CTGE'), 4.35, 4.6, NULL, 'SAE 75W-80', 'HaynesPro typeId t_305000536; S7 (4.0 V8 TFSI); Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CTGE'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 283, 'brake_fluid', NULL, 1, 1.06, NULL, 'VW 501 14', 'HaynesPro chassis d_102000177; Alt: DOT 4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 283 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 284, 'brake_fluid', NULL, 1, 1.06, NULL, 'VW 501 14', 'HaynesPro chassis d_102000177; Alt: DOT 4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 284 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (283, 284)
  AND e.code IN ('CYGA', 'CYNB', 'CYPA', 'CYPB', 'CNYA', 'CHVA', 'CVPA', 'CDUC', 'CLAA', 'CLAB', 'CGQB', 'CDUD', 'CKVB', 'CKVC', 'CPNB', 'CVUB', 'CVUA', 'CRTD', 'CRTE', 'CTCC', 'CRTF', 'CTCB', 'CZVA', 'CZVB', 'CZVC', 'CZVD', 'CZVE', 'CZVF', 'CHMA', 'CGXB', 'CGWB', 'CGWD', 'CTUA', 'CREH', 'CREC', 'CRDB', 'CWUB', 'CWUC', 'CEUC', 'CTGE')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (283, 284)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (283, 284) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;