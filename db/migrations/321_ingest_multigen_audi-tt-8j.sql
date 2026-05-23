-- mig 321 — multi-gen HaynesPro ingest: Audi TT (8J)
-- crawl: haynespro-crawl-audi-tt-8j-2026-05-23.json
-- modelId: d_102000006
-- 15 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Audi TT (8J)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_102000006', NOW(), 'Multi-gen ingest, 15 engines across 2 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_102000006' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('CDAA', '1.8 TFSI (CDAA) 118kW', 1798, 'petrol', 'turbo', NULL),
  ('CBBB', '2.0 TDI (CBBB) 125kW', 1968, 'diesel', 'turbo', NULL),
  ('CFGB', '2.0 TDI (CFGB) 125kW', 1968, 'diesel', 'turbo', NULL),
  ('BWA', '2.0 TFSI (BWA) 147kW', 1984, 'petrol', 'turbo', NULL),
  ('BPY', '2.0 TFSI (BPY) 147kW', 1984, 'petrol', 'turbo', NULL),
  ('CDLB', '2.0 TFSI (CDLB) 200kW', 1984, 'petrol', 'turbo', NULL),
  ('CDLA', '2.0 TFSI (CDLA) 195kW', 1984, 'petrol', 'turbo', NULL),
  ('CCTA', '2.0 TFSI (CCTA) 149kW', 1984, 'petrol', 'turbo', NULL),
  ('CCZA', '2.0 TFSI (CCZA) 147kW', 1984, 'petrol', 'turbo', NULL),
  ('CDMA', '2.0 TFSI (CDMA) 195kW', 1984, 'petrol', 'turbo', NULL),
  ('CESA', '2.0 TFSI (CESA) 155kW', 1984, 'petrol', 'turbo', NULL),
  ('CETA', '2.0 TFSI (CETA) 155kW', 1984, 'petrol', 'turbo', NULL),
  ('BUB', '3.2 VR6 (BUB) 184kW', 3189, 'petrol', 'NA', NULL),
  ('CEPA', 'RS (2.5 TFSI) (CEPA) 250kW', 2480, 'petrol', 'turbo', NULL),
  ('CEPB', 'RS (2.5 TFSI) (CEPB) 265kW', 2498, 'petrol', 'turbo', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 298, 'engine_oil', (SELECT id FROM engines WHERE code = 'CDAA'), 4.6, 4.86, '5W-30', 'VW 501 01', 'HaynesPro typeId t_105000205; 1.8 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 298 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CDAA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 298, 'coolant', (SELECT id FROM engines WHERE code = 'CDAA'), 8.1, 8.56, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_105000205; 1.8 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 298 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CDAA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 298, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CDAA'), 1.9, 2.01, NULL, 'SAE 75W', 'HaynesPro typeId t_105000205; 1.8 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 298 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CDAA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 298, 'engine_oil', (SELECT id FROM engines WHERE code = 'CBBB'), 4, 4.23, '5W-30', 'VW 507 00', 'HaynesPro typeId t_105000203; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 298 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CBBB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 298, 'coolant', (SELECT id FROM engines WHERE code = 'CBBB'), 8.7, 9.19, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_105000203; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 298 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CBBB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 298, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CBBB'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_105000203; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 298 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CBBB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 298, 'engine_oil', (SELECT id FROM engines WHERE code = 'CFGB'), 4, 4.23, '5W-30', 'VW 507 00', 'HaynesPro typeId t_102001962; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 298 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CFGB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 298, 'coolant', (SELECT id FROM engines WHERE code = 'CFGB'), 8.7, 9.19, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102001962; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 298 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CFGB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 298, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CFGB'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_102001962; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 298 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CFGB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 298, 'engine_oil', (SELECT id FROM engines WHERE code = 'BWA'), 4.5, 4.76, '5W-30', 'VW 501 01', 'HaynesPro typeId t_102000163; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 298 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 298, 'coolant', (SELECT id FROM engines WHERE code = 'BWA'), 9, 9.51, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102000163; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 298 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 298, 'transmission_mt', (SELECT id FROM engines WHERE code = 'BWA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_102000163; 2.0 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 298 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'BWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 298, 'engine_oil', (SELECT id FROM engines WHERE code = 'BPY'), 4.5, 4.76, '5W-30', 'VW 501 01', 'HaynesPro typeId t_300000127; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 298 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BPY'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 298, 'coolant', (SELECT id FROM engines WHERE code = 'BPY'), 9, 9.51, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_300000127; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 298 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BPY'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 298, 'transmission_dct', (SELECT id FROM engines WHERE code = 'BPY'), 5.2, 5.49, NULL, NULL, 'HaynesPro typeId t_300000127; 2.0 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 298 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'BPY'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 298, 'engine_oil', (SELECT id FROM engines WHERE code = 'CDLB'), 4.5, 4.76, '5W-30', 'VW 502 00', 'HaynesPro typeId t_105000202; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 298 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CDLB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 298, 'coolant', (SELECT id FROM engines WHERE code = 'CDLB'), 9, 9.51, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_105000202; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 298 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CDLB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 298, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CDLB'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_105000202; 2.0 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 298 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CDLB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 298, 'engine_oil', (SELECT id FROM engines WHERE code = 'CDLA'), 4.5, 4.76, '5W-30', 'VW 502 00', 'HaynesPro typeId t_102001126; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 298 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CDLA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 298, 'coolant', (SELECT id FROM engines WHERE code = 'CDLA'), 9, 9.51, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102001126; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 298 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CDLA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 298, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CDLA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_102001126; 2.0 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 298 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CDLA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 298, 'engine_oil', (SELECT id FROM engines WHERE code = 'CCTA'), 4.6, 4.86, '5W-30', 'VW 501 01', 'HaynesPro typeId t_619017176; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 298 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CCTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 298, 'coolant', (SELECT id FROM engines WHERE code = 'CCTA'), 10, 10.57, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_619017176; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 298 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CCTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 298, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CCTA'), 5.5, 5.81, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619017176; 2.0 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 298 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CCTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 298, 'engine_oil', (SELECT id FROM engines WHERE code = 'CCZA'), 4.6, 4.86, '5W-30', 'VW 501 01', 'HaynesPro typeId t_105000204; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 298 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CCZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 298, 'coolant', (SELECT id FROM engines WHERE code = 'CCZA'), 9, 9.51, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_105000204; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 298 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CCZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 298, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CCZA'), 5.5, 5.81, NULL, 'SAE 75W-90', 'HaynesPro typeId t_105000204; 2.0 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 298 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CCZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 298, 'engine_oil', (SELECT id FROM engines WHERE code = 'CDMA'), 4.5, 4.76, '5W-40', 'VW 502 00', 'HaynesPro typeId t_102002300; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 298 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CDMA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 298, 'coolant', (SELECT id FROM engines WHERE code = 'CDMA'), NULL, NULL, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102002300; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 298 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CDMA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 298, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CDMA'), 5.5, 5.81, NULL, 'SAE 75W-90', 'HaynesPro typeId t_102002300; 2.0 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 298 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CDMA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 298, 'engine_oil', (SELECT id FROM engines WHERE code = 'CESA'), 4.6, 4.86, '5W-40', 'VW 501 01', 'HaynesPro typeId t_102001806; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 298 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CESA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 298, 'coolant', (SELECT id FROM engines WHERE code = 'CESA'), 9, 9.51, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102001806; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 298 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CESA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 298, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CESA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_102001806; 2.0 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 298 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CESA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 298, 'engine_oil', (SELECT id FROM engines WHERE code = 'CETA'), 4.6, 4.86, '5W-40', 'VW 501 01', 'HaynesPro typeId t_102002301; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 298 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CETA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 298, 'coolant', (SELECT id FROM engines WHERE code = 'CETA'), NULL, NULL, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102002301; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 298 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CETA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 298, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CETA'), 5.2, 5.49, NULL, 'SAE 75W-90', 'HaynesPro typeId t_102002301; 2.0 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 298 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CETA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 298, 'engine_oil', (SELECT id FROM engines WHERE code = 'BUB'), 5.5, 5.81, '5W-30', 'VW 501 01', 'HaynesPro typeId t_102000164; 3.2 VR6; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 298 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BUB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 298, 'coolant', (SELECT id FROM engines WHERE code = 'BUB'), 12.7, 13.42, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102000164; 3.2 VR6'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 298 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BUB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 298, 'transmission_mt', (SELECT id FROM engines WHERE code = 'BUB'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_102000164; 3.2 VR6; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 298 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'BUB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 299, 'engine_oil', (SELECT id FROM engines WHERE code = 'CEPA'), 6.5, 6.87, '5W-30', 'VW 502 00', 'HaynesPro typeId t_102001127; RS (2.5 TFSI); drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 299 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CEPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 299, 'coolant', (SELECT id FROM engines WHERE code = 'CEPA'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102001127; RS (2.5 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 299 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CEPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 299, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CEPA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_102001127; RS (2.5 TFSI); Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 299 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CEPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 299, 'engine_oil', (SELECT id FROM engines WHERE code = 'CEPB'), 5.7, 6.02, '5W-30', 'VW 502 00', 'HaynesPro typeId t_300000134; RS (2.5 TFSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 299 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CEPB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 299, 'coolant', (SELECT id FROM engines WHERE code = 'CEPB'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_300000134; RS (2.5 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 299 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CEPB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 299, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CEPB'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_300000134; RS (2.5 TFSI); Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 299 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CEPB'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 298, 'brake_fluid', NULL, 1, 1.06, NULL, 'VW 501 14', 'HaynesPro chassis d_102000006; Alt: DOT 4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 298 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 299, 'brake_fluid', NULL, 1, 1.06, NULL, 'VW 501 14', 'HaynesPro chassis d_102000006; Alt: DOT 4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 299 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (298, 299)
  AND e.code IN ('CDAA', 'CBBB', 'CFGB', 'BWA', 'BPY', 'CDLB', 'CDLA', 'CCTA', 'CCZA', 'CDMA', 'CESA', 'CETA', 'BUB', 'CEPA', 'CEPB')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (298, 299)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (298, 299) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;