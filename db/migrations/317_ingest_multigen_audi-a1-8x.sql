-- mig 317 — multi-gen HaynesPro ingest: Audi A1 (8X)
-- crawl: haynespro-crawl-audi-a1-8x-2026-05-23.json
-- modelId: d_102000157
-- 22 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Audi A1 (8X)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_102000157', NOW(), 'Multi-gen ingest, 22 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_102000157' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('CHZB', '1.0 TFSI (CHZB) 70kW', 999, 'petrol', 'turbo', NULL),
  ('CHZE', '1.0 TFSI (CHZE) 60kW', 999, 'petrol', 'turbo', NULL),
  ('DKLD', '1.0 TFSI (DKLD) 70kW', 999, 'petrol', 'turbo', NULL),
  ('CBZA', '1.2 TFSI (CBZA) 63kW', 1197, 'petrol', 'turbo', NULL),
  ('CUSB', '1.4 TDI (CUSB) 66kW', 1422, 'diesel', 'turbo', NULL),
  ('CAVG', '1.4 TFSI (CAVG) 136kW', 1390, 'petrol', 'turbo', NULL),
  ('CAXA', '1.4 TFSI (CAXA) 90kW', 1390, 'petrol', 'turbo', NULL),
  ('CNVA', '1.4 TFSI (CNVA) 90kW', 1390, 'petrol', 'turbo', NULL),
  ('CPTA', '1.4 TFSI (CPTA) 103kW', 1395, 'petrol', 'turbo', NULL),
  ('CTHG', '1.4 TFSI (CTHG) 136kW', 1395, 'petrol', 'turbo', NULL),
  ('CZEA', '1.4 TFSI (CZEA) 110kW', 1395, 'petrol', 'turbo', NULL),
  ('CZCA', '1.4 TFSI (CZCA) 92kW', 1395, 'petrol', 'turbo', NULL),
  ('CZDB', '1.4 TFSI (CZDB) 92kW', 1395, 'petrol', 'turbo', NULL),
  ('CZDD', '1.4 TFSI (CZDD) 92kW', 1395, 'petrol', 'turbo', NULL),
  ('CAYC', '1.6 TDI (CAYC) 77kW', 1598, 'diesel', 'turbo', NULL),
  ('CAYB', '1.6 TDI (CAYB) 66kW', 1598, 'diesel', 'turbo', NULL),
  ('CXMA', '1.6 TDI (CXMA) 85kW', 1598, 'diesel', 'turbo', NULL),
  ('DAJB', '1.8 TFSI (DAJB) 141kW', 1798, 'petrol', 'turbo', NULL),
  ('CFHD', '2.0 TDI (CFHD) 105kW', 1968, 'diesel', 'turbo', NULL),
  ('CFHB', '2.0 TDI (CFHB) 100kW', 1968, 'diesel', 'turbo', NULL),
  ('CDLH', '2.0 TFSI (CDLH) 188kW', 1984, 'petrol', 'turbo', NULL),
  ('CWZA', 'S1 (2.0 TFSI) (CWZA) 170kW', 1984, 'petrol', 'turbo', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'engine_oil', (SELECT id FROM engines WHERE code = 'CHZB'), 4, 4.23, '5W-40', 'VW 502 00', 'HaynesPro typeId t_313000034; 1.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CHZB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'coolant', (SELECT id FROM engines WHERE code = 'CHZB'), 7.5, 7.93, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_313000034; 1.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CHZB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CHZB'), 1.9, 2.01, NULL, 'VW G 055 512 A2', 'HaynesPro typeId t_313000034; 1.0 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CHZB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'engine_oil', (SELECT id FROM engines WHERE code = 'CHZE'), 4, 4.23, '5W-40', 'VW 502 00', 'HaynesPro typeId t_319001022; 1.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CHZE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'coolant', (SELECT id FROM engines WHERE code = 'CHZE'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319001022; 1.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CHZE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CHZE'), 2.1, 2.22, NULL, 'SAE 75W', 'HaynesPro typeId t_319001022; 1.0 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CHZE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'engine_oil', (SELECT id FROM engines WHERE code = 'DKLD'), 4, 4.23, '0W-30', 'VW 504 00', 'HaynesPro typeId t_619008007; 1.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DKLD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'coolant', (SELECT id FROM engines WHERE code = 'DKLD'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_619008007; 1.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DKLD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DKLD'), 2.1, 2.22, NULL, 'SAE 75W', 'HaynesPro typeId t_619008007; 1.0 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DKLD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'engine_oil', (SELECT id FROM engines WHERE code = 'CBZA'), 3.6, 3.8, '5W-40', 'VW 502 00', 'HaynesPro typeId t_106000238; 1.2 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CBZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'coolant', (SELECT id FROM engines WHERE code = 'CBZA'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_106000238; 1.2 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CBZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CBZA'), 2, 2.11, NULL, 'SAE 75W', 'HaynesPro typeId t_106000238; 1.2 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CBZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'engine_oil', (SELECT id FROM engines WHERE code = 'CUSB'), 3.7, 3.91, '5W-30', 'VW 507 00', 'HaynesPro typeId t_313000032; 1.4 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CUSB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'coolant', (SELECT id FROM engines WHERE code = 'CUSB'), NULL, NULL, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_313000032; 1.4 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CUSB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CUSB'), 1.8, 1.9, NULL, 'SAE 75W', 'HaynesPro typeId t_313000032; 1.4 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CUSB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'engine_oil', (SELECT id FROM engines WHERE code = 'CAVG'), 3.6, 3.8, '5W-40', 'VW 502 00', 'HaynesPro typeId t_106000234; 1.4 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CAVG'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'coolant', (SELECT id FROM engines WHERE code = 'CAVG'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_106000234; 1.4 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CAVG'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CAVG'), 1.9, 2.01, NULL, 'VW G 055 512 A2', 'HaynesPro typeId t_106000234; 1.4 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CAVG'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'engine_oil', (SELECT id FROM engines WHERE code = 'CAXA'), 3.6, 3.8, '5W-40', 'VW 502 00', 'HaynesPro typeId t_106000235; 1.4 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CAXA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'coolant', (SELECT id FROM engines WHERE code = 'CAXA'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_106000235; 1.4 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CAXA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CAXA'), 1.9, 2.01, NULL, 'SAE 75W', 'HaynesPro typeId t_106000235; 1.4 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CAXA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'engine_oil', (SELECT id FROM engines WHERE code = 'CNVA'), 3.6, 3.8, '5W-40', 'VW 502 00', 'HaynesPro typeId t_319005454; 1.4 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CNVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'coolant', (SELECT id FROM engines WHERE code = 'CNVA'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319005454; 1.4 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CNVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CNVA'), 1.9, 2.01, NULL, 'VW G 055 512 A2', 'HaynesPro typeId t_319005454; 1.4 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CNVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'engine_oil', (SELECT id FROM engines WHERE code = 'CPTA'), 4, 4.23, '5W-40', 'VW 502 00', 'HaynesPro typeId t_200000193; 1.4 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CPTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'coolant', (SELECT id FROM engines WHERE code = 'CPTA'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_200000193; 1.4 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CPTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CPTA'), 2.15, 2.27, NULL, 'SAE 75W', 'HaynesPro typeId t_200000193; 1.4 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CPTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'engine_oil', (SELECT id FROM engines WHERE code = 'CTHG'), 3.6, 3.8, '5W-40', 'VW 502 00', 'HaynesPro typeId t_200000194; 1.4 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CTHG'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'coolant', (SELECT id FROM engines WHERE code = 'CTHG'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_200000194; 1.4 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CTHG'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CTHG'), 1.9, 2.01, NULL, 'VW G 055 512 A2', 'HaynesPro typeId t_200000194; 1.4 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CTHG'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZEA'), 4, 4.23, '5W-30', 'VW 504 00', 'HaynesPro typeId t_313000027; 1.4 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'coolant', (SELECT id FROM engines WHERE code = 'CZEA'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_313000027; 1.4 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CZEA'), 2.15, 2.27, NULL, 'SAE 75W', 'HaynesPro typeId t_313000027; 1.4 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CZEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZCA'), 4, 4.23, '5W-40', 'VW 502 00', 'HaynesPro typeId t_313000028; 1.4 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZCA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'coolant', (SELECT id FROM engines WHERE code = 'CZCA'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_313000028; 1.4 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZCA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CZCA'), 1.9, 2.01, NULL, 'SAE 75W', 'HaynesPro typeId t_313000028; 1.4 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CZCA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZDB'), 4, 4.23, '5W-40', 'VW 502 00', 'HaynesPro typeId t_319001040; 1.4 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZDB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'coolant', (SELECT id FROM engines WHERE code = 'CZDB'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319001040; 1.4 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZDB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CZDB'), 1.9, 2.01, NULL, 'VW G 055 512 A2', 'HaynesPro typeId t_319001040; 1.4 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CZDB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZDD'), 4, 4.23, '5W-40', 'VW 502 00', 'HaynesPro typeId t_319007798; 1.4 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZDD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'coolant', (SELECT id FROM engines WHERE code = 'CZDD'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319007798; 1.4 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZDD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CZDD'), 1.9, 2.01, NULL, 'SAE 75W', 'HaynesPro typeId t_319007798; 1.4 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CZDD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'engine_oil', (SELECT id FROM engines WHERE code = 'CAYC'), 4.3, 4.54, '5W-30', 'VW 507 00', 'HaynesPro typeId t_106000237; 1.6 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CAYC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'coolant', (SELECT id FROM engines WHERE code = 'CAYC'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_106000237; 1.6 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CAYC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CAYC'), 1.8, 1.9, NULL, 'SAE 75W', 'HaynesPro typeId t_106000237; 1.6 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CAYC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'engine_oil', (SELECT id FROM engines WHERE code = 'CAYB'), 4.3, 4.54, '5W-30', 'VW 507 00', 'HaynesPro typeId t_106000236; 1.6 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CAYB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'coolant', (SELECT id FROM engines WHERE code = 'CAYB'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_106000236; 1.6 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CAYB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CAYB'), 1.8, 1.9, NULL, 'SAE 75W', 'HaynesPro typeId t_106000236; 1.6 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CAYB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'engine_oil', (SELECT id FROM engines WHERE code = 'CXMA'), 4.9, 5.18, '5W-30', 'VW 507 00', 'HaynesPro typeId t_313000029; 1.6 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CXMA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CXMA'), 1.8, 1.9, NULL, 'SAE 75W', 'HaynesPro typeId t_313000029; 1.6 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CXMA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'engine_oil', (SELECT id FROM engines WHERE code = 'DAJB'), 5.2, 5.49, '5W-40', 'VW 502 00', 'HaynesPro typeId t_317000180; 1.8 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DAJB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'coolant', (SELECT id FROM engines WHERE code = 'DAJB'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_317000180; 1.8 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DAJB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DAJB'), 1.9, 2.01, NULL, 'VW G 055 512 A2', 'HaynesPro typeId t_317000180; 1.8 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DAJB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'engine_oil', (SELECT id FROM engines WHERE code = 'CFHD'), 4.3, 4.54, '5W-30', 'VW 507 00', 'HaynesPro typeId t_106000239; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CFHD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'coolant', (SELECT id FROM engines WHERE code = 'CFHD'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_106000239; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CFHD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CFHD'), 2.15, 2.27, NULL, 'SAE 75W', 'HaynesPro typeId t_106000239; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CFHD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'engine_oil', (SELECT id FROM engines WHERE code = 'CFHB'), 4.3, 4.54, '5W-30', 'VW 507 00', 'HaynesPro typeId t_102001990; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CFHB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'coolant', (SELECT id FROM engines WHERE code = 'CFHB'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102001990; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CFHB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CFHB'), 2.15, 2.27, NULL, 'SAE 75W', 'HaynesPro typeId t_102001990; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CFHB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'engine_oil', (SELECT id FROM engines WHERE code = 'CDLH'), 4.5, 4.76, '5W-40', 'VW 502 00', 'HaynesPro typeId t_201000007; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CDLH'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'coolant', (SELECT id FROM engines WHERE code = 'CDLH'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_201000007; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CDLH'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CDLH'), 2.15, 2.27, NULL, 'SAE 75W', 'HaynesPro typeId t_201000007; 2.0 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CDLH'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'engine_oil', (SELECT id FROM engines WHERE code = 'CWZA'), 5.8, 6.13, '5W-40', 'VW 502 00', 'HaynesPro typeId t_302000342; S1 (2.0 TFSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CWZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'coolant', (SELECT id FROM engines WHERE code = 'CWZA'), NULL, NULL, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_302000342; S1 (2.0 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CWZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CWZA'), 2.15, 2.27, NULL, 'SAE 75W', 'HaynesPro typeId t_302000342; S1 (2.0 TFSI); Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CWZA'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 293, 'brake_fluid', NULL, 1, 1.06, NULL, 'VW 501 14', 'HaynesPro chassis d_102000157; Alt: DOT 4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 293 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (293)
  AND e.code IN ('CHZB', 'CHZE', 'DKLD', 'CBZA', 'CUSB', 'CAVG', 'CAXA', 'CNVA', 'CPTA', 'CTHG', 'CZEA', 'CZCA', 'CZDB', 'CZDD', 'CAYC', 'CAYB', 'CXMA', 'DAJB', 'CFHD', 'CFHB', 'CDLH', 'CWZA')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (293)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (293) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;