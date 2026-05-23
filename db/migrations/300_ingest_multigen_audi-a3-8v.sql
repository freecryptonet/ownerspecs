-- mig 300 — multi-gen HaynesPro ingest: Audi A3 III (8V)
-- crawl: haynespro-crawl-audi-a3-8v-2026-05-23.json
-- modelId: d_102000240
-- 59 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Audi A3 III (8V)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_102000240', NOW(), 'Multi-gen ingest, 59 engines across 2 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_102000240' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('CHZD', '1.0 TFSI (CHZD) 85kW', 999, 'petrol', 'turbo', NULL),
  ('CJZA', '1.2 TFSI (CJZA) 77kW', 1197, 'petrol', 'turbo', NULL),
  ('CYVB', '1.2 TFSI (CYVB) 81kW', 1197, 'petrol', 'turbo', NULL),
  ('CPTA', '1.4 TFSI (CPTA) 103kW', 1395, 'petrol', 'turbo', NULL),
  ('CMBA', '1.4 TFSI (CMBA) 90kW', 1395, 'petrol', 'turbo', NULL),
  ('CXSA', '1.4 TFSI (CXSA) 90kW', 1395, 'petrol', 'turbo', NULL),
  ('CXSB', '1.4 TFSI (CXSB) 92kW', 1395, 'petrol', 'turbo', NULL),
  ('CZEA', '1.4 TFSI (CZEA) 110kW', 1395, 'petrol', 'turbo', NULL),
  ('CZCA', '1.4 TFSI (CZCA) 92kW', 1395, 'petrol', 'turbo', NULL),
  ('CZCC', '1.4 TFSI (CZCC) 85kW', 1395, 'petrol', 'turbo', NULL),
  ('CPWA', '1.4 TFSI CNG (CPWA) 81kW', 1395, 'petrol', 'turbo', NULL),
  ('CUKB', '1.4 TFSI e-tron (CUKB) 150kW', 1395, 'hybrid', 'turbo', NULL),
  ('CXUA', '1.4 TFSI e-tron (CXUA) 150kW', 1395, 'hybrid', 'turbo', NULL),
  ('CLHA', '1.6 TDI (CLHA) 77kW', 1598, 'diesel', 'turbo', NULL),
  ('CRKB', '1.6 TDI (CRKB) 81kW', 1598, 'diesel', 'turbo', NULL),
  ('CXXB', '1.6 TDI (CXXB) 81kW', 1598, 'diesel', 'turbo', NULL),
  ('DBKA', '1.6 TDI (DBKA) 81kW', 1598, 'diesel', 'turbo', NULL),
  ('DDYA', '1.6 TDI (DDYA) 85kW', 1598, 'diesel', 'turbo', NULL),
  ('CJSA', '1.8 TFSI (CJSA) 132kW', 1798, 'petrol', 'turbo', NULL),
  ('CJSB', '1.8 TFSI (CJSB) 132kW', 1798, 'petrol', 'turbo', NULL),
  ('CNSB', '1.8 TFSI (CNSB) 125kW', 1798, 'petrol', 'turbo', NULL),
  ('CRBC', '2.0 TDI (CRBC) 110kW', 1968, 'diesel', 'turbo', NULL),
  ('CRLB', '2.0 TDI (CRLB) 110kW', 1968, 'diesel', 'turbo', NULL),
  ('CRFC', '2.0 TDI (CRFC) 105kW', 1968, 'diesel', 'turbo', NULL),
  ('CRFA', '2.0 TDI (CRFA) 81kW', 1968, 'diesel', 'turbo', NULL),
  ('CUNA', '2.0 TDI (CUNA) 135kW', 1968, 'diesel', 'turbo', NULL),
  ('CRBD', '2.0 TDI (CRBD) 100kW', 1968, 'diesel', 'turbo', NULL),
  ('CRUA', '2.0 TDI (CRUA) 110kW', 1968, 'diesel', 'turbo', NULL),
  ('CRLC', '2.0 TDI (CRLC) 100kW', 1968, 'diesel', 'turbo', NULL),
  ('DBGA', '2.0 TDI (DBGA) 110kW', 1968, 'diesel', 'turbo', NULL),
  ('DEJA', '2.0 TDI (DEJA) 110kW', 1968, 'diesel', 'turbo', NULL),
  ('DEJB', '2.0 TDI (DEJB) 80kW', 1968, 'diesel', 'turbo', NULL),
  ('DGCA', '2.0 TDI (DGCA) 135kW', 1968, 'diesel', 'turbo', NULL),
  ('DCYA', '2.0 TDI (DCYA) 110kW', 1968, 'diesel', 'turbo', NULL),
  ('CHHB', '2.0 TFSI (CHHB) 162kW', 1984, 'petrol', 'turbo', NULL),
  ('CNTC', '2.0 TFSI (CNTC) 162kW', 1984, 'petrol', 'turbo', NULL),
  ('DGTE', '30 TDI (DGTE) 85kW', 1598, 'diesel', 'turbo', NULL),
  ('DKRA', '30 TFSI (DKRA) 85kW', 999, 'petrol', 'turbo', NULL),
  ('DKRF', '30 TFSI (DKRF) 85kW', 999, 'petrol', 'turbo', NULL),
  ('DHFA', '30 g-tron (DHFA) 96kW', 1498, 'petrol', 'NA', NULL),
  ('DFGA', '35 TDI (DFGA) 110kW', 1968, 'diesel', 'turbo', NULL),
  ('DADA', '35 TFSI (DADA) 110kW', 1498, 'petrol', 'turbo', NULL),
  ('DPCA', '35 TFSI (DPCA) 110kW', 1498, 'petrol', 'turbo', NULL),
  ('DJGA', '40 TDI (DJGA) 135kW', 1968, 'diesel', 'turbo', NULL),
  ('CZPB', '40 TFSI (CZPB) 140kW', 1984, 'petrol', 'turbo', NULL),
  ('DKZA', '40 TFSI (DKZA) 140kW', 1984, 'petrol', 'turbo', NULL),
  ('DGEA', '40 e-tron (DGEA) 150kW', 1395, 'hybrid', 'NA', NULL),
  ('CZGB', 'RS3 (2.5 TFSI) (CZGB) 270kW', 2480, 'petrol', 'turbo', NULL),
  ('DAZA', 'RS3 (2.5 TFSI) (DAZA) 294kW', 2480, 'petrol', 'turbo', NULL),
  ('DNWA', 'RS3 (2.5 TFSI) (DNWA) 294kW', 2480, 'petrol', 'turbo', NULL),
  ('CJXC', 'S3 (2.0 TFSI) (CJXC) 221kW', 1984, 'petrol', 'turbo', NULL),
  ('CJXB', 'S3 (2.0 TFSI) (CJXB) 206kW', 1984, 'petrol', 'turbo', NULL),
  ('CYFB', 'S3 (2.0 TFSI) (CYFB) 215kW', 1984, 'petrol', 'turbo', NULL),
  ('CJXF', 'S3 (2.0 TFSI) (CJXF) 210kW', 1984, 'petrol', 'turbo', NULL),
  ('CJXG', 'S3 (2.0 TFSI) (CJXG) 228kW', 1984, 'petrol', 'turbo', NULL),
  ('DJHA', 'S3 (2.0 TFSI) (DJHA) 228kW', 1984, 'petrol', 'turbo', NULL),
  ('CJXD', 'S3 (2.0 TFSI) (CJXD) 213kW', 1984, 'petrol', 'turbo', NULL),
  ('DJHB', 'S3 (2.0 TFSI) (DJHB) 213kW', 1984, 'petrol', 'turbo', NULL),
  ('DNUE', 'S3 (2.0 TFSI) (DNUE) 221kW', 1984, 'petrol', 'turbo', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'CHZD'), 4, 4.23, '5W-40', 'VW 502 00', 'HaynesPro typeId t_319001023; 1.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CHZD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'CHZD'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319001023; 1.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CHZD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CHZD'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_319001023; 1.0 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CHZD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'CJZA'), 4, 4.23, '0W-30', 'VW 502 00', 'HaynesPro typeId t_301000004; 1.2 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CJZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'CJZA'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_301000004; 1.2 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CJZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CJZA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_301000004; 1.2 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CJZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'CYVB'), 4, 4.23, '0W-30', 'VW 502 00', 'HaynesPro typeId t_304000025; 1.2 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CYVB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'CYVB'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_304000025; 1.2 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CYVB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CYVB'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_304000025; 1.2 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CYVB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'CPTA'), 4, 4.23, '0W-30', 'VW 502 00', 'HaynesPro typeId t_301000502; 1.4 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CPTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'CPTA'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_301000502; 1.4 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CPTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CPTA'), 1.9, 2.01, NULL, 'SAE 75W', 'HaynesPro typeId t_301000502; 1.4 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CPTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'CMBA'), 4, 4.23, '0W-30', 'VW 502 00', 'HaynesPro typeId t_301000006; 1.4 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CMBA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'CMBA'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_301000006; 1.4 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CMBA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CMBA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_301000006; 1.4 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CMBA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'CXSA'), 4, 4.23, '0W-30', 'VW 502 00', 'HaynesPro typeId t_301000530; 1.4 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CXSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'CXSA'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_301000530; 1.4 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CXSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CXSA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_301000530; 1.4 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CXSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'CXSB'), 4, 4.23, '0W-30', 'VW 502 00', 'HaynesPro typeId t_1000058; 1.4 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CXSB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'CXSB'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_1000058; 1.4 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CXSB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CXSB'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_1000058; 1.4 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CXSB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZEA'), 4, 4.23, '5W-40', 'VW 502 00', 'HaynesPro typeId t_304000026; 1.4 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'CZEA'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_304000026; 1.4 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CZEA'), 2.1, 2.22, NULL, 'SAE 75W', 'HaynesPro typeId t_304000026; 1.4 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CZEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZCA'), 4, 4.23, '0W-30', 'VW 502 00', 'HaynesPro typeId t_304000027; 1.4 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZCA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'CZCA'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_304000027; 1.4 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZCA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CZCA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_304000027; 1.4 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CZCA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZCC'), 4, 4.23, '5W-40', 'VW 502 00', 'HaynesPro typeId t_319000301; 1.4 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZCC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'CZCC'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319000301; 1.4 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZCC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CZCC'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_319000301; 1.4 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CZCC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'CPWA'), 4, 4.23, '5W-40', 'VW 502 00', 'HaynesPro typeId t_302000343; 1.4 TFSI CNG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CPWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'CPWA'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_302000343; 1.4 TFSI CNG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CPWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CPWA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_302000343; 1.4 TFSI CNG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CPWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'CUKB'), 4, 4.23, '5W-40', 'VW 502 00', 'HaynesPro typeId t_303000103; 1.4 TFSI e-tron; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CUKB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'CUKB'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_303000103; 1.4 TFSI e-tron'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CUKB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CUKB'), 8.1, 8.56, NULL, NULL, 'HaynesPro typeId t_303000103; 1.4 TFSI e-tron; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CUKB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'CXUA'), 4, 4.23, '5W-40', 'VW 502 00', 'HaynesPro typeId t_318011833; 1.4 TFSI e-tron; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CXUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'CXUA'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_318011833; 1.4 TFSI e-tron'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CXUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CXUA'), 8.1, 8.56, NULL, NULL, 'HaynesPro typeId t_318011833; 1.4 TFSI e-tron; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CXUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'CLHA'), 4.7, 4.97, '5W-30', 'VW 507 00', 'HaynesPro typeId t_301000005; 1.6 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CLHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'CLHA'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_301000005; 1.6 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CLHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CLHA'), 1.9, 2.01, NULL, 'SAE 75W', 'HaynesPro typeId t_301000005; 1.6 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CLHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'CRKB'), 4.7, 4.97, '5W-30', 'VW 507 00', 'HaynesPro typeId t_301000800; 1.6 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CRKB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'CRKB'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_301000800; 1.6 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CRKB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CRKB'), 1.9, 2.01, NULL, 'SAE 75W', 'HaynesPro typeId t_301000800; 1.6 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CRKB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'CXXB'), 4.7, 4.97, '5W-30', 'VW 507 00', 'HaynesPro typeId t_317000183; 1.6 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CXXB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'CXXB'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_317000183; 1.6 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CXXB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CXXB'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_317000183; 1.6 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CXXB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'DBKA'), 4.7, 4.97, '5W-30', 'VW 507 00', 'HaynesPro typeId t_317000545; 1.6 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DBKA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'DBKA'), 7, 7.4, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_317000545; 1.6 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DBKA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DBKA'), 2.1, 2.22, NULL, 'SAE 75W', 'HaynesPro typeId t_317000545; 1.6 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DBKA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'DDYA'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319004599; 1.6 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DDYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'DDYA'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319004599; 1.6 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DDYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DDYA'), 1.7, 1.8, NULL, 'VW G 055 512 A2', 'HaynesPro typeId t_319004599; 1.6 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DDYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'CJSA'), 5.2, 5.49, '0W-30', 'VW 502 00', 'HaynesPro typeId t_301000002; 1.8 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CJSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'CJSA'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_301000002; 1.8 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CJSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CJSA'), 2.1, 2.22, NULL, 'SAE 75W', 'HaynesPro typeId t_301000002; 1.8 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CJSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'CJSB'), 5.2, 5.49, '0W-30', 'VW 502 00', 'HaynesPro typeId t_301000003; 1.8 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CJSB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'CJSB'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_301000003; 1.8 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CJSB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CJSB'), 5.2, 5.49, NULL, 'SAE 75W-90', 'HaynesPro typeId t_301000003; 1.8 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CJSB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'CNSB'), 4.6, 4.86, '0W-30', 'VW 502 00', 'HaynesPro typeId t_305000529; 1.8 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CNSB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'CNSB'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_305000529; 1.8 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CNSB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CNSB'), 5.2, 5.49, NULL, NULL, 'HaynesPro typeId t_305000529; 1.8 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CNSB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'CRBC'), 4.7, 4.97, '5W-30', 'VW 507 00', 'HaynesPro typeId t_301000007; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CRBC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'CRBC'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_301000007; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CRBC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CRBC'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_301000007; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CRBC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'CRLB'), 4.7, 4.97, '5W-30', 'VW 507 00', 'HaynesPro typeId t_1000057; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CRLB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'CRLB'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_1000057; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CRLB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CRLB'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_1000057; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CRLB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'CRFC'), 4.7, 4.97, '5W-30', 'VW 507 00', 'HaynesPro typeId t_301000008; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CRFC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'CRFC'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_301000008; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CRFC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CRFC'), 5.2, 5.49, NULL, NULL, 'HaynesPro typeId t_301000008; 2.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CRFC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'CRFA'), 4.7, 4.97, '5W-30', 'VW 507 00', 'HaynesPro typeId t_1000056; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CRFA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'CRFA'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_1000056; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CRFA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CRFA'), 1.8, 1.9, NULL, 'SAE 75W', 'HaynesPro typeId t_1000056; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CRFA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'CUNA'), 4.7, 4.97, '5W-30', 'VW 507 00', 'HaynesPro typeId t_301000603; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CUNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'CUNA'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_301000603; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CUNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CUNA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_301000603; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CUNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'CRBD'), 4.7, 4.97, '5W-30', 'VW 507 00', 'HaynesPro typeId t_301000503; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CRBD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'CRBD'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_301000503; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CRBD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CRBD'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_301000503; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CRBD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'CRUA'), 4.7, 4.97, '5W-30', 'VW 507 00', 'HaynesPro typeId t_305000528; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CRUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'CRUA'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_305000528; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CRUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CRUA'), 5.2, 5.49, NULL, NULL, 'HaynesPro typeId t_305000528; 2.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CRUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'CRLC'), 4.7, 4.97, '5W-40', 'VW 502 00', 'HaynesPro typeId t_305000519; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CRLC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'CRLC'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_305000519; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CRLC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CRLC'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_305000519; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CRLC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'DBGA'), 5.5, 5.81, '5W-30', 'VW 507 00', 'HaynesPro typeId t_319005456; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DBGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'DBGA'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319005456; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DBGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DBGA'), 5.2, 5.49, NULL, NULL, 'HaynesPro typeId t_319005456; 2.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DBGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'DEJA'), 5.5, 5.81, '5W-30', 'VW 507 00', 'HaynesPro typeId t_319004600; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DEJA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'DEJA'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319004600; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DEJA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DEJA'), 5.2, 5.49, NULL, NULL, 'HaynesPro typeId t_319004600; 2.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DEJA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'DEJB'), 5.5, 5.81, '5W-30', 'VW 507 00', 'HaynesPro typeId t_319005527; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DEJB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'DEJB'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319005527; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DEJB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DEJB'), 5.2, 5.49, NULL, NULL, 'HaynesPro typeId t_319005527; 2.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DEJB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'DGCA'), 4.7, 4.97, '5W-30', 'VW 507 00', 'HaynesPro typeId t_319004601; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DGCA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'DGCA'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319004601; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DGCA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DGCA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_319004601; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DGCA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'DCYA'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319004598; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DCYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'DCYA'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319004598; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DCYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DCYA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_319004598; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DCYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'CHHB'), 5.7, 6.02, '0W-30', 'VW 502 00', 'HaynesPro typeId t_319004594; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CHHB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'CHHB'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319004594; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CHHB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CHHB'), 5.2, 5.49, NULL, NULL, 'HaynesPro typeId t_319004594; 2.0 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CHHB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'CNTC'), 5.7, 6.02, '0W-30', 'VW 502 00', 'HaynesPro typeId t_318011832; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CNTC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'CNTC'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_318011832; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CNTC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CNTC'), 5.2, 5.49, NULL, 'SAE 75W-90', 'HaynesPro typeId t_318011832; 2.0 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CNTC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'DGTE'), 4.7, 4.97, '5W-30', 'VW 507 00', 'HaynesPro typeId t_619013130; 30 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DGTE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'DGTE'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_619013130; 30 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DGTE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DGTE'), 2.1, 2.22, NULL, 'SAE 75W', 'HaynesPro typeId t_619013130; 30 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DGTE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'DKRA'), 4, 4.23, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619013160; 30 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DKRA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'DKRA'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_619013160; 30 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DKRA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DKRA'), 1.7, 1.8, NULL, 'VW G 055 512 A2', 'HaynesPro typeId t_619013160; 30 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DKRA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'DKRF'), 4, 4.23, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619013131; 30 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DKRF'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'DKRF'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_619013131; 30 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DKRF'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DKRF'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_619013131; 30 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DKRF'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'DHFA'), 4.3, 4.54, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619016903; 30 g-tron; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DHFA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'DHFA'), 9, 9.51, NULL, NULL, 'HaynesPro typeId t_619016903; 30 g-tron'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DHFA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DHFA'), 1.7, 1.8, NULL, 'VW G 055 512 A2', 'HaynesPro typeId t_619016903; 30 g-tron; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DHFA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'DFGA'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619016991; 35 TDI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DFGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'DFGA'), 10, 10.57, NULL, NULL, 'HaynesPro typeId t_619016991; 35 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DFGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DFGA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_619016991; 35 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DFGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'DADA'), 4.3, 4.54, '0W-20', 'VW 508 00', 'HaynesPro typeId t_319005753; 35 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DADA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'DADA'), 9, 9.51, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319005753; 35 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DADA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DADA'), 2.1, 2.22, NULL, 'SAE 75W', 'HaynesPro typeId t_319005753; 35 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DADA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'DPCA'), 4.3, 4.54, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619019455; 35 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DPCA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DPCA'), 2.1, 2.22, NULL, 'SAE 75W', 'HaynesPro typeId t_619019455; 35 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DPCA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'DJGA'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619016904; 40 TDI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DJGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'DJGA'), 10, 10.57, NULL, NULL, 'HaynesPro typeId t_619016904; 40 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DJGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DJGA'), 6.9, 7.29, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619016904; 40 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DJGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZPB'), 5.7, 6.02, '0W-20', 'VW 508 00', 'HaynesPro typeId t_319001024; 40 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZPB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'CZPB'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319001024; 40 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZPB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CZPB'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_319001024; 40 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CZPB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'DKZA'), 5.7, 6.02, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619016992; 40 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DKZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'DKZA'), 10, 10.57, NULL, NULL, 'HaynesPro typeId t_619016992; 40 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DKZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DKZA'), 6.9, 7.29, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619016992; 40 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DKZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'DGEA'), 4, 4.23, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619019453; 40 e-tron; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DGEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'DGEA'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_619019453; 40 e-tron'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DGEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DGEA'), 8.1, 8.56, NULL, NULL, 'HaynesPro typeId t_619019453; 40 e-tron; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DGEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 270, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZGB'), 6.8, 7.19, '5W-30', 'VW 504 00', 'HaynesPro typeId t_317000212; RS3 (2.5 TFSI); drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 270 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZGB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 270, 'coolant', (SELECT id FROM engines WHERE code = 'CZGB'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_317000212; RS3 (2.5 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 270 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZGB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 270, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CZGB'), 5.5, 5.81, NULL, 'SAE 75W-90', 'HaynesPro typeId t_317000212; RS3 (2.5 TFSI); Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 270 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CZGB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 270, 'engine_oil', (SELECT id FROM engines WHERE code = 'DAZA'), 7.1, 7.5, '5W-30', 'VW 504 00', 'HaynesPro typeId t_319004597; RS3 (2.5 TFSI); drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 270 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DAZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 270, 'coolant', (SELECT id FROM engines WHERE code = 'DAZA'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319004597; RS3 (2.5 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 270 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DAZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 270, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DAZA'), 5.5, 5.81, NULL, 'SAE 75W-90', 'HaynesPro typeId t_319004597; RS3 (2.5 TFSI); Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 270 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DAZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 270, 'engine_oil', (SELECT id FROM engines WHERE code = 'DNWA'), 7.1, 7.5, '5W-30', 'VW 504 00', 'HaynesPro typeId t_619016905; RS3 (2.5 TFSI); drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 270 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DNWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 270, 'coolant', (SELECT id FROM engines WHERE code = 'DNWA'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_619016905; RS3 (2.5 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 270 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DNWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 270, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DNWA'), 5.5, 5.81, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619016905; RS3 (2.5 TFSI); Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 270 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DNWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'CJXC'), 5.7, 6.02, '0W-30', 'VW 502 00', 'HaynesPro typeId t_201000089; S3 (2.0 TFSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CJXC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'CJXC'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_201000089; S3 (2.0 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CJXC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CJXC'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_201000089; S3 (2.0 TFSI); Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CJXC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'CJXB'), 5.7, 6.02, '0W-30', 'VW 502 00', 'HaynesPro typeId t_201000088; S3 (2.0 TFSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CJXB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'CJXB'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_201000088; S3 (2.0 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CJXB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CJXB'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_201000088; S3 (2.0 TFSI); Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CJXB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'CYFB'), 5.2, 5.49, '0W-30', 'VW 502 00', 'HaynesPro typeId t_619013163; S3 (2.0 TFSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CYFB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'CYFB'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_619013163; S3 (2.0 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CYFB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CYFB'), 5.2, 5.49, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619013163; S3 (2.0 TFSI); Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CYFB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'CJXF'), 5.7, 6.02, '0W-30', 'VW 502 00', 'HaynesPro typeId t_305000530; S3 (2.0 TFSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CJXF'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'CJXF'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_305000530; S3 (2.0 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CJXF'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CJXF'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_305000530; S3 (2.0 TFSI); Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CJXF'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'CJXG'), 5.7, 6.02, '0W-30', 'VW 502 00', 'HaynesPro typeId t_319004596; S3 (2.0 TFSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CJXG'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'CJXG'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319004596; S3 (2.0 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CJXG'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CJXG'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_319004596; S3 (2.0 TFSI); Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CJXG'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'DJHA'), 5.7, 6.02, '0W-30', 'VW 502 00', 'HaynesPro typeId t_319001143; S3 (2.0 TFSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DJHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'DJHA'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319001143; S3 (2.0 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DJHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DJHA'), 6.9, 7.29, NULL, 'SAE 75W-90', 'HaynesPro typeId t_319001143; S3 (2.0 TFSI); Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DJHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'CJXD'), 5.7, 6.02, '0W-30', 'VW 502 00', 'HaynesPro typeId t_319004595; S3 (2.0 TFSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CJXD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'CJXD'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319004595; S3 (2.0 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CJXD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CJXD'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_319004595; S3 (2.0 TFSI); Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CJXD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'DJHB'), 5.7, 6.02, '0W-30', 'VW 502 00', 'HaynesPro typeId t_319004602; S3 (2.0 TFSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DJHB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'DJHB'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319004602; S3 (2.0 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DJHB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DJHB'), 6.9, 7.29, NULL, 'SAE 75W-90', 'HaynesPro typeId t_319004602; S3 (2.0 TFSI); Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DJHB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'engine_oil', (SELECT id FROM engines WHERE code = 'DNUE'), 5.7, 6.02, '0W-30', 'VW 504 00', 'HaynesPro typeId t_619017004; S3 (2.0 TFSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DNUE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'coolant', (SELECT id FROM engines WHERE code = 'DNUE'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_619017004; S3 (2.0 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DNUE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DNUE'), 6.9, 7.29, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619017004; S3 (2.0 TFSI); Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DNUE'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 269, 'brake_fluid', NULL, 1, 1.06, NULL, 'VW 501 14', 'HaynesPro chassis d_102000240; Alt: DOT 4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 269 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 270, 'brake_fluid', NULL, 1, 1.06, NULL, 'VW 501 14', 'HaynesPro chassis d_102000240; Alt: DOT 4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 270 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (269, 270)
  AND e.code IN ('CHZD', 'CJZA', 'CYVB', 'CPTA', 'CMBA', 'CXSA', 'CXSB', 'CZEA', 'CZCA', 'CZCC', 'CPWA', 'CUKB', 'CXUA', 'CLHA', 'CRKB', 'CXXB', 'DBKA', 'DDYA', 'CJSA', 'CJSB', 'CNSB', 'CRBC', 'CRLB', 'CRFC', 'CRFA', 'CUNA', 'CRBD', 'CRUA', 'CRLC', 'DBGA', 'DEJA', 'DEJB', 'DGCA', 'DCYA', 'CHHB', 'CNTC', 'DGTE', 'DKRA', 'DKRF', 'DHFA', 'DFGA', 'DADA', 'DPCA', 'DJGA', 'CZPB', 'DKZA', 'DGEA', 'CZGB', 'DAZA', 'DNWA', 'CJXC', 'CJXB', 'CYFB', 'CJXF', 'CJXG', 'DJHA', 'CJXD', 'DJHB', 'DNUE')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (269, 270)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (269, 270) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;