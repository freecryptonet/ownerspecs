-- mig 299 — multi-gen HaynesPro ingest: Audi A3 II (8P)
-- crawl: haynespro-crawl-audi-a3-8p-2026-05-23.json
-- modelId: d_480
-- 57 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Audi A3 II (8P)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_480', NOW(), 'Multi-gen ingest, 57 engines across 2 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_480' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('CBZB', '1.2 TFSI (CBZB) 77kW', 1197, 'petrol', 'turbo', NULL),
  ('CAXC', '1.4 TFSI (CAXC) 92kW', 1390, 'petrol', 'turbo', NULL),
  ('CMSA', '1.4 TFSI (CMSA) 92kW', 1390, 'petrol', 'turbo', NULL),
  ('BGU', '1.6 8V (BGU) 75kW', 1595, 'petrol', 'NA', NULL),
  ('BSE', '1.6 8V (BSE) 75kW', 1595, 'petrol', 'NA', NULL),
  ('BSF', '1.6 8V (BSF) 75kW', 1595, 'petrol', 'NA', NULL),
  ('CCSA', '1.6 8V (CCSA) 75kW', 1595, 'petrol', 'NA', NULL),
  ('CMXA', '1.6 8V E-Power (CMXA) 75kW', 1595, 'petrol', 'NA', NULL),
  ('BAG', '1.6 FSi 16V (BAG) 85kW', 1598, 'petrol', 'NA', NULL),
  ('BLF', '1.6 FSi 16V (BLF) 85kW', 1598, 'petrol', 'NA', NULL),
  ('BLP', '1.6 FSi 16V (BLP) 85kW', 1598, 'petrol', 'NA', NULL),
  ('CAYC', '1.6 TDI (CAYC) 77kW', 1598, 'diesel', 'turbo', NULL),
  ('CAYB', '1.6 TDI (CAYB) 66kW', 1598, 'diesel', 'turbo', NULL),
  ('BYT', '1.8 TFSI (BYT) 118kW', 1798, 'petrol', 'turbo', NULL),
  ('BZB', '1.8 TFSI (BZB) 118kW', 1798, 'petrol', 'turbo', NULL),
  ('CDAA', '1.8 TFSI (CDAA) 118kW', 1798, 'petrol', 'turbo', NULL),
  ('BKC', '1.9 TDI 8V (BKC) 77kW', 1896, 'diesel', 'turbo', NULL),
  ('BXE', '1.9 TDI 8V (BXE) 77kW', 1896, 'diesel', 'turbo', NULL),
  ('BLS', '1.9 TDI 8V DPF (BLS) 77kW', 1896, 'diesel', 'turbo', NULL),
  ('AXW', '2.0 FSi 16V (AXW) 110kW', 1984, 'petrol', 'NA', NULL),
  ('BHD', '2.0 FSi 16V (BHD) 110kW', 1984, 'petrol', 'NA', NULL),
  ('BMB', '2.0 FSi 16V (BMB) 110kW', 1984, 'petrol', 'NA', NULL),
  ('BLR', '2.0 FSi 16V (BLR) 110kW', 1984, 'petrol', 'NA', NULL),
  ('BLX', '2.0 FSi 16V (BLX) 110kW', 1984, 'petrol', 'NA', NULL),
  ('BLY', '2.0 FSi 16V (BLY) 110kW', 1984, 'petrol', 'NA', NULL),
  ('BVY', '2.0 FSi 16V (BVY) 110kW', 1984, 'petrol', 'NA', NULL),
  ('BVZ', '2.0 FSi 16V (BVZ) 110kW', 1984, 'petrol', 'NA', NULL),
  ('CBAB', '2.0 TDI (CBAB) 103kW', 1968, 'diesel', 'turbo', NULL),
  ('CBAA', '2.0 TDI (CBAA) 100kW', 1968, 'diesel', 'turbo', NULL),
  ('CBBB', '2.0 TDI (CBBB) 125kW', 1968, 'diesel', 'turbo', NULL),
  ('CFGB', '2.0 TDI (CFGB) 125kW', 1968, 'diesel', 'turbo', NULL),
  ('CBEA', '2.0 TDI (CBEA) 103kW', 1968, 'diesel', 'turbo', NULL),
  ('CFFB', '2.0 TDI (CFFB) 103kW', 1968, 'diesel', 'turbo', NULL),
  ('CLJA', '2.0 TDI (CLJA) 103kW', 1968, 'diesel', 'turbo', NULL),
  ('CFFA', '2.0 TDI (CFFA) 100kW', 1968, 'diesel', 'turbo', NULL),
  ('BKD', '2.0 TDI 16V (BKD) 103kW', 1968, 'diesel', 'turbo', NULL),
  ('AZV', '2.0 TDI 16V (AZV) 100kW', 1968, 'diesel', 'turbo', NULL),
  ('BMN', '2.0 TDI 16V DPF (BMN) 125kW', 1968, 'diesel', 'turbo', NULL),
  ('BUY', '2.0 TDI 16V DPF (BUY) 120kW', 1968, 'diesel', 'turbo', NULL),
  ('BMM', '2.0 TDI 8V DPF (BMM) 103kW', 1968, 'diesel', 'turbo', NULL),
  ('AXX', '2.0 TFSI (AXX) 147kW', 1984, 'petrol', 'turbo', NULL),
  ('BPY', '2.0 TFSI (BPY) 147kW', 1984, 'petrol', 'turbo', NULL),
  ('BWA', '2.0 TFSI (BWA) 147kW', 1984, 'petrol', 'turbo', NULL),
  ('CAWB', '2.0 TFSI (CAWB) 147kW', 1984, 'petrol', 'turbo', NULL),
  ('CBFA', '2.0 TFSI (CBFA) 147kW', 1984, 'petrol', 'turbo', NULL),
  ('CCTA', '2.0 TFSI (CCTA) 147kW', 1984, 'petrol', 'turbo', NULL),
  ('CCZA', '2.0 TFSI (CCZA) 147kW', 1984, 'petrol', 'turbo', NULL),
  ('BDB', '3.2 VR6 (BDB) 184kW', 3189, 'petrol', 'NA', NULL),
  ('BMJ', '3.2 VR6 (BMJ) 184kW', 3189, 'petrol', 'NA', NULL),
  ('BUB', '3.2 VR6 (BUB) 184kW', 3189, 'petrol', 'NA', NULL),
  ('CBRA', '3.2 VR6 (CBRA) 184kW', 3189, 'petrol', 'NA', NULL),
  ('CEPA', 'RS3 (2.5 TFSI) (CEPA) 250kW', 2480, 'petrol', 'turbo', NULL),
  ('CEPB', 'RS3 (2.5 TFSI) (CEPB) 265kW', 2480, 'petrol', 'turbo', NULL),
  ('BHZ', 'S3 (2.0 TFSI) (BHZ) 195kW', 1984, 'petrol', 'turbo', NULL),
  ('BZC', 'S3 (2.0 TFSI) (BZC) 188kW', 1984, 'petrol', 'turbo', NULL),
  ('CDLA', 'S3 (2.0 TFSI) (CDLA) 195kW', 1984, 'petrol', 'turbo', NULL),
  ('CDLC', 'S3 (2.0 TFSI) (CDLC) 188kW', 1984, 'petrol', 'turbo', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'CBZB'), 3.7, 3.91, '5W-40', 'VW 502 00', 'HaynesPro typeId t_102000694; 1.2 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CBZB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'CBZB'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102000694; 1.2 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CBZB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CBZB'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_102000694; 1.2 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CBZB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'CAXC'), 3.6, 3.8, '5W-30', 'VW 502 00', 'HaynesPro typeId t_102000376; 1.4 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CAXC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'CAXC'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102000376; 1.4 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CAXC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CAXC'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_102000376; 1.4 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CAXC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'CMSA'), 3.6, 3.8, '5W-30', 'VW 502 00', 'HaynesPro typeId t_304000010; 1.4 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CMSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'CMSA'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_304000010; 1.4 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CMSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CMSA'), 1.9, 2.01, NULL, 'VW G 055 512 A2', 'HaynesPro typeId t_304000010; 1.4 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CMSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'BGU'), 4.6, 4.86, '5W-30', 'VW 502 00', 'HaynesPro typeId t_58170; 1.6 8V; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BGU'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'BGU'), 8, 8.45, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_58170; 1.6 8V'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BGU'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'BGU'), 2, 2.11, NULL, 'VW G 060 726 A2', 'HaynesPro typeId t_58170; 1.6 8V; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'BGU'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'BSE'), 4.6, 4.86, '5W-30', 'VW 502 00', 'HaynesPro typeId t_105000010; 1.6 8V; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BSE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'BSE'), 8, 8.45, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_105000010; 1.6 8V'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BSE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'BSE'), 2, 2.11, NULL, 'VW G 060 726 A2', 'HaynesPro typeId t_105000010; 1.6 8V; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'BSE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'BSF'), 4.6, 4.86, '5W-30', 'VW 502 00', 'HaynesPro typeId t_105000011; 1.6 8V; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BSF'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'BSF'), 8, 8.45, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_105000011; 1.6 8V'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BSF'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'BSF'), 2, 2.11, NULL, 'VW G 060 726 A2', 'HaynesPro typeId t_105000011; 1.6 8V; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'BSF'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'CCSA'), 4.6, 4.86, '5W-30', 'VW 502 00', 'HaynesPro typeId t_102000688; 1.6 8V; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CCSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'CCSA'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102000688; 1.6 8V'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CCSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CCSA'), 2, 2.11, NULL, 'VW G 060 726 A2', 'HaynesPro typeId t_102000688; 1.6 8V; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CCSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'CMXA'), 4.6, 4.86, '0W-30', 'VW 502 00', 'HaynesPro typeId t_102001150; 1.6 8V E-Power; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CMXA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'CMXA'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102001150; 1.6 8V E-Power'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CMXA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CMXA'), 2, 2.11, NULL, 'VW G 060 726 A2', 'HaynesPro typeId t_102001150; 1.6 8V E-Power; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CMXA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'BAG'), 3.6, 3.8, '5W-30', 'VW 502 00', 'HaynesPro typeId t_58240; 1.6 FSi 16V; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BAG'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'BAG'), 8, 8.45, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_58240; 1.6 FSi 16V'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BAG'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'BAG'), 2.1, 2.22, NULL, 'VW G 060 726 A2', 'HaynesPro typeId t_58240; 1.6 FSi 16V; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'BAG'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'BLF'), 3.6, 3.8, '5W-30', 'VW 502 00', 'HaynesPro typeId t_105000009; 1.6 FSi 16V; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BLF'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'BLF'), 8, 8.45, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_105000009; 1.6 FSi 16V'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BLF'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'BLF'), 2.1, 2.22, NULL, 'VW G 060 726 A2', 'HaynesPro typeId t_105000009; 1.6 FSi 16V; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'BLF'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'BLP'), 3.6, 3.8, '5W-30', 'VW 502 00', 'HaynesPro typeId t_58370; 1.6 FSi 16V; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BLP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'BLP'), 8, 8.45, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_58370; 1.6 FSi 16V'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BLP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'BLP'), 2.1, 2.22, NULL, 'VW G 060 726 A2', 'HaynesPro typeId t_58370; 1.6 FSi 16V; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'BLP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'CAYC'), 4.3, 4.54, '5W-30', 'VW 507 00', 'HaynesPro typeId t_102000691; 1.6 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CAYC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'CAYC'), 6, 6.34, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102000691; 1.6 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CAYC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CAYC'), 1.8, 1.9, NULL, 'SAE 75W', 'HaynesPro typeId t_102000691; 1.6 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CAYC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'CAYB'), 4.3, 4.54, '5W-30', 'VW 507 00', 'HaynesPro typeId t_102000689; 1.6 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CAYB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'CAYB'), 6, 6.34, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102000689; 1.6 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CAYB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CAYB'), 1.8, 1.9, NULL, 'SAE 75W', 'HaynesPro typeId t_102000689; 1.6 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CAYB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'BYT'), 4.6, 4.86, '5W-30', 'VW 502 00', 'HaynesPro typeId t_105000012; 1.8 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BYT'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'BYT'), 8, 8.45, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_105000012; 1.8 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BYT'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'BYT'), 1.9, 2.01, NULL, 'SAE 75W', 'HaynesPro typeId t_105000012; 1.8 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'BYT'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'BZB'), 4.6, 4.86, '5W-30', 'VW 501 01', 'HaynesPro typeId t_110000050; 1.8 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BZB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'BZB'), 10, 10.57, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_110000050; 1.8 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BZB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_dct', (SELECT id FROM engines WHERE code = 'BZB'), 5.2, 5.49, NULL, 'SAE 75W', 'HaynesPro typeId t_110000050; 1.8 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'BZB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'CDAA'), 4.6, 4.86, '5W-30', 'VW 501 01', 'HaynesPro typeId t_102001151; 1.8 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CDAA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'CDAA'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102001151; 1.8 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CDAA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CDAA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_102001151; 1.8 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CDAA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'BKC'), 3.8, 4.02, '5W-30', 'VW 505 01', 'HaynesPro typeId t_58300; 1.9 TDI 8V; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BKC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'BKC'), 8, 8.45, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_58300; 1.9 TDI 8V'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BKC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'BKC'), 1.7, 1.8, NULL, 'VW G 060 726 A2', 'HaynesPro typeId t_58300; 1.9 TDI 8V; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'BKC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'BXE'), 3.8, 4.02, '5W-30', 'VW 505 01', 'HaynesPro typeId t_105000002; 1.9 TDI 8V; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BXE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'BXE'), 8, 8.45, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_105000002; 1.9 TDI 8V'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BXE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'BXE'), 1.8, 1.9, NULL, 'SAE 75W', 'HaynesPro typeId t_105000002; 1.9 TDI 8V; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'BXE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'BLS'), 4.3, 4.54, '5W-30', 'VW 507 00', 'HaynesPro typeId t_105000003; 1.9 TDI 8V DPF; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BLS'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'BLS'), 8, 8.45, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_105000003; 1.9 TDI 8V DPF'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BLS'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'BLS'), 1.8, 1.9, NULL, 'SAE 75W', 'HaynesPro typeId t_105000003; 1.9 TDI 8V DPF; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'BLS'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'AXW'), 4.6, 4.86, '5W-30', 'VW 502 00', 'HaynesPro typeId t_58070; 2.0 FSi 16V; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'AXW'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'AXW'), 7.5, 7.93, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_58070; 2.0 FSi 16V'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'AXW'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'AXW'), 1.9, 2.01, NULL, 'SAE 75W', 'HaynesPro typeId t_58070; 2.0 FSi 16V; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'AXW'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'BHD'), 4.6, 4.86, '5W-30', 'VW 502 00', 'HaynesPro typeId t_58280; 2.0 FSi 16V; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BHD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'BHD'), 7.5, 7.93, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_58280; 2.0 FSi 16V'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BHD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'BHD'), 1.9, 2.01, NULL, 'SAE 75W', 'HaynesPro typeId t_58280; 2.0 FSi 16V; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'BHD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'BMB'), 4.6, 4.86, '5W-30', 'VW 502 00', 'HaynesPro typeId t_58340; 2.0 FSi 16V; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BMB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'BMB'), 7.5, 7.93, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_58340; 2.0 FSi 16V'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BMB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'BMB'), 1.9, 2.01, NULL, 'SAE 75W', 'HaynesPro typeId t_58340; 2.0 FSi 16V; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'BMB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'BLR'), 4.6, 4.86, '5W-30', 'VW 502 00', 'HaynesPro typeId t_58390; 2.0 FSi 16V; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BLR'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'BLR'), 8.1, 8.56, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_58390; 2.0 FSi 16V'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BLR'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'BLR'), 1.9, 2.01, NULL, 'SAE 75W', 'HaynesPro typeId t_58390; 2.0 FSi 16V; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'BLR'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'BLX'), 4.6, 4.86, '5W-30', 'VW 502 00', 'HaynesPro typeId t_58380; 2.0 FSi 16V; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BLX'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'BLX'), 7.5, 7.93, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_58380; 2.0 FSi 16V'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BLX'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'BLX'), 1.9, 2.01, NULL, 'SAE 75W', 'HaynesPro typeId t_58380; 2.0 FSi 16V; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'BLX'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'BLY'), 4.6, 4.86, '5W-30', 'VW 502 00', 'HaynesPro typeId t_102000529; 2.0 FSi 16V; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BLY'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'BLY'), 7.6, 8.03, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_102000529; 2.0 FSi 16V'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BLY'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'BLY'), 1.9, 2.01, NULL, 'SAE 75W', 'HaynesPro typeId t_102000529; 2.0 FSi 16V; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'BLY'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'BVY'), 4.6, 4.86, '5W-30', 'VW 502 00', 'HaynesPro typeId t_105000013; 2.0 FSi 16V; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BVY'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'BVY'), 8.1, 8.56, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_105000013; 2.0 FSi 16V'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BVY'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'BVY'), 1.9, 2.01, NULL, 'SAE 75W', 'HaynesPro typeId t_105000013; 2.0 FSi 16V; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'BVY'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'BVZ'), 4.6, 4.86, '5W-30', 'VW 502 00', 'HaynesPro typeId t_105000014; 2.0 FSi 16V; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BVZ'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'BVZ'), 8.1, 8.56, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_105000014; 2.0 FSi 16V'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BVZ'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'BVZ'), 1.9, 2.01, NULL, 'SAE 75W', 'HaynesPro typeId t_105000014; 2.0 FSi 16V; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'BVZ'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'CBAB'), 4, 4.23, '5W-30', 'VW 507 00', 'HaynesPro typeId t_102000692; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CBAB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'CBAB'), 8.7, 9.19, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102000692; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CBAB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CBAB'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_102000692; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CBAB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'CBAA'), 4, 4.23, '5W-30', 'VW 507 00', 'HaynesPro typeId t_102001142; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CBAA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'CBAA'), 8.7, 9.19, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102001142; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CBAA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CBAA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_102001142; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CBAA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'CBBB'), 4, 4.23, '5W-30', 'VW 507 00', 'HaynesPro typeId t_102000693; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CBBB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'CBBB'), 8.7, 9.19, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102000693; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CBBB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CBBB'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_102000693; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CBBB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'CFGB'), 4, 4.23, '5W-30', 'VW 507 00', 'HaynesPro typeId t_102001147; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CFGB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'CFGB'), 8.7, 9.19, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102001147; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CFGB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CFGB'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_102001147; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CFGB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'CBEA'), 4, 4.23, '5W-30', 'VW 507 00', 'HaynesPro typeId t_304000011; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CBEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'CBEA'), 8.7, 9.19, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_304000011; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CBEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CBEA'), 5.2, 5.49, NULL, NULL, 'HaynesPro typeId t_304000011; 2.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CBEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'CFFB'), 4, 4.23, '5W-30', 'VW 507 00', 'HaynesPro typeId t_102001146; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CFFB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'CFFB'), 8.7, 9.19, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102001146; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CFFB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CFFB'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_102001146; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CFFB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'CLJA'), 4, 4.23, '5W-30', 'VW 507 00', 'HaynesPro typeId t_102001148; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CLJA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'CLJA'), 8.7, 9.19, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102001148; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CLJA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CLJA'), 5.2, 5.49, NULL, 'SAE 75W-90', 'HaynesPro typeId t_102001148; 2.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CLJA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'CFFA'), 4, 4.23, '5W-30', 'VW 507 00', 'HaynesPro typeId t_102001145; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CFFA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'CFFA'), 8.7, 9.19, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102001145; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CFFA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CFFA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_102001145; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CFFA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'BKD'), 3.8, 4.02, '5W-30', 'VW 505 01', 'HaynesPro typeId t_58320; 2.0 TDI 16V; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BKD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'BKD'), 8.6, 9.09, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_58320; 2.0 TDI 16V'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BKD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'BKD'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_58320; 2.0 TDI 16V; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'BKD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'AZV'), 3.8, 4.02, '5W-30', 'VW 505 01', 'HaynesPro typeId t_58200; 2.0 TDI 16V; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'AZV'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'AZV'), 8, 8.45, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_58200; 2.0 TDI 16V'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'AZV'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'AZV'), 1.7, 1.8, NULL, 'VW G 060 726 A2', 'HaynesPro typeId t_58200; 2.0 TDI 16V; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'AZV'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'BMN'), 3.8, 4.02, '5W-30', 'VW 507 00', 'HaynesPro typeId t_105000007; 2.0 TDI 16V DPF; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BMN'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'BMN'), 8.7, 9.19, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_105000007; 2.0 TDI 16V DPF'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BMN'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'BMN'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_105000007; 2.0 TDI 16V DPF; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'BMN'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'BUY'), 4.3, 4.54, '5W-30', 'VW 507 00', 'HaynesPro typeId t_105000008; 2.0 TDI 16V DPF; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BUY'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'BUY'), 8, 8.45, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_105000008; 2.0 TDI 16V DPF'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BUY'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'BUY'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_105000008; 2.0 TDI 16V DPF; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'BUY'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'BMM'), 3.8, 4.02, '5W-30', 'VW 507 00', 'HaynesPro typeId t_58410; 2.0 TDI 8V DPF; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BMM'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'BMM'), 8.7, 9.19, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_58410; 2.0 TDI 8V DPF'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BMM'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'BMM'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_58410; 2.0 TDI 8V DPF; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'BMM'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'AXX'), 4.5, 4.76, '5W-30', 'VW 501 01', 'HaynesPro typeId t_58350; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'AXX'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'AXX'), 8, 8.45, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_58350; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'AXX'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'AXX'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_58350; 2.0 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'AXX'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'BPY'), 4.5, 4.76, '5W-30', 'VW 501 01', 'HaynesPro typeId t_58430; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BPY'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'BPY'), 8, 8.45, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_58430; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BPY'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'BPY'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_58430; 2.0 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'BPY'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'BWA'), 4.5, 4.76, '5W-30', 'VW 501 01', 'HaynesPro typeId t_58420; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'BWA'), 8, 8.45, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_58420; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'BWA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_58420; 2.0 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'BWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'CAWB'), 4.6, 4.86, '5W-30', 'VW 501 01', 'HaynesPro typeId t_110000157; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CAWB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'CAWB'), 10, 10.57, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_110000157; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CAWB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CAWB'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_110000157; 2.0 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CAWB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'CBFA'), 4.6, 4.86, '5W-30', 'VW 501 01', 'HaynesPro typeId t_304000008; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CBFA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'CBFA'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_304000008; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CBFA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CBFA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_304000008; 2.0 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CBFA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'CCTA'), 4.6, 4.86, '5W-30', 'VW 502 00', 'HaynesPro typeId t_304000009; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CCTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'CCTA'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_304000009; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CCTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CCTA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_304000009; 2.0 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CCTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'CCZA'), 4.6, 4.86, '5W-30', 'VW 501 01', 'HaynesPro typeId t_102000690; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CCZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'CCZA'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102000690; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CCZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CCZA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_102000690; 2.0 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CCZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'BDB'), 5.5, 5.81, '5W-30', 'VW 501 01', 'HaynesPro typeId t_58260; 3.2 VR6; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BDB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'BDB'), 12.3, 13, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_58260; 3.2 VR6'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BDB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'BDB'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_58260; 3.2 VR6; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'BDB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'BMJ'), 5.5, 5.81, '5W-30', 'VW 501 01', 'HaynesPro typeId t_58400; 3.2 VR6; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BMJ'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'BMJ'), 12.3, 13, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_58400; 3.2 VR6'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BMJ'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'BMJ'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_58400; 3.2 VR6; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'BMJ'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'BUB'), 5.5, 5.81, '5W-30', 'VW 501 01', 'HaynesPro typeId t_105000001; 3.2 VR6; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BUB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'BUB'), 12.3, 13, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_105000001; 3.2 VR6'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BUB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'BUB'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_105000001; 3.2 VR6; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'BUB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'CBRA'), 5.5, 5.81, '5W-30', 'VW 504 00', 'HaynesPro typeId t_304000012; 3.2 VR6; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CBRA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'CBRA'), 12.3, 13, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_304000012; 3.2 VR6'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CBRA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CBRA'), 5.5, 5.81, NULL, 'SAE 75W-90', 'HaynesPro typeId t_304000012; 3.2 VR6; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CBRA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 268, 'engine_oil', (SELECT id FROM engines WHERE code = 'CEPA'), 6.5, 6.87, '5W-40', 'VW 502 00', 'HaynesPro typeId t_200000195; RS3 (2.5 TFSI); drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 268 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CEPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 268, 'coolant', (SELECT id FROM engines WHERE code = 'CEPA'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_200000195; RS3 (2.5 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 268 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CEPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 268, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CEPA'), 5.5, 5.81, NULL, 'SAE 75W-90', 'HaynesPro typeId t_200000195; RS3 (2.5 TFSI); Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 268 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CEPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 268, 'engine_oil', (SELECT id FROM engines WHERE code = 'CEPB'), 6.5, 6.87, '5W-40', 'VW 502 00', 'HaynesPro typeId t_200000196; RS3 (2.5 TFSI); drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 268 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CEPB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 268, 'coolant', (SELECT id FROM engines WHERE code = 'CEPB'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_200000196; RS3 (2.5 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 268 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CEPB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 268, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CEPB'), 5.5, 5.81, NULL, 'SAE 75W-90', 'HaynesPro typeId t_200000196; RS3 (2.5 TFSI); Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 268 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CEPB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'BHZ'), 4.5, 4.76, '5W-30', 'VW 502 00', 'HaynesPro typeId t_105000015; S3 (2.0 TFSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BHZ'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'BHZ'), 8.6, 9.09, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_105000015; S3 (2.0 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BHZ'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'BHZ'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_105000015; S3 (2.0 TFSI); Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'BHZ'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'BZC'), 4.5, 4.76, '5W-30', 'VW 502 00', 'HaynesPro typeId t_102000530; S3 (2.0 TFSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BZC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'BZC'), 8, 8.45, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_102000530; S3 (2.0 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BZC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'BZC'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_102000530; S3 (2.0 TFSI); Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'BZC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'CDLA'), 4.5, 4.76, '5W-30', 'VW 502 00', 'HaynesPro typeId t_102001143; S3 (2.0 TFSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CDLA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'CDLA'), 8.6, 9.09, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102001143; S3 (2.0 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CDLA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CDLA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_102001143; S3 (2.0 TFSI); Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CDLA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'engine_oil', (SELECT id FROM engines WHERE code = 'CDLC'), 4.5, 4.76, '5W-30', 'VW 502 00', 'HaynesPro typeId t_102001144; S3 (2.0 TFSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CDLC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'coolant', (SELECT id FROM engines WHERE code = 'CDLC'), 8.6, 9.09, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102001144; S3 (2.0 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CDLC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CDLC'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_102001144; S3 (2.0 TFSI); Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CDLC'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 267, 'brake_fluid', NULL, 1, 1.06, NULL, 'VW 501 14', 'HaynesPro chassis d_480; Alt: DOT 4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 267 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 268, 'brake_fluid', NULL, 1, 1.06, NULL, 'VW 501 14', 'HaynesPro chassis d_480; Alt: DOT 4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 268 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (267, 268)
  AND e.code IN ('CBZB', 'CAXC', 'CMSA', 'BGU', 'BSE', 'BSF', 'CCSA', 'CMXA', 'BAG', 'BLF', 'BLP', 'CAYC', 'CAYB', 'BYT', 'BZB', 'CDAA', 'BKC', 'BXE', 'BLS', 'AXW', 'BHD', 'BMB', 'BLR', 'BLX', 'BLY', 'BVY', 'BVZ', 'CBAB', 'CBAA', 'CBBB', 'CFGB', 'CBEA', 'CFFB', 'CLJA', 'CFFA', 'BKD', 'AZV', 'BMN', 'BUY', 'BMM', 'AXX', 'BPY', 'BWA', 'CAWB', 'CBFA', 'CCTA', 'CCZA', 'BDB', 'BMJ', 'BUB', 'CBRA', 'CEPA', 'CEPB', 'BHZ', 'BZC', 'CDLA', 'CDLC')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (267, 268)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (267, 268) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;