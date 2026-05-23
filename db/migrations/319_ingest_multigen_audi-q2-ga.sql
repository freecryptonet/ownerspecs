-- mig 319 — multi-gen HaynesPro ingest: Audi Q2 (GA)
-- crawl: haynespro-crawl-audi-q2-ga-2026-05-23.json
-- modelId: d_319000521
-- 24 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Audi Q2 (GA)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319000521', NOW(), 'Multi-gen ingest, 24 engines across 2 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319000521' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('DDYA', '30 TDI (DDYA) 85kW', 1598, 'diesel', 'turbo', NULL),
  ('DGTE', '30 TDI (DGTE) 85kW', 1598, 'diesel', 'turbo', NULL),
  ('DTRB', '30 TDI (DTRB) 85kW', 1968, 'diesel', 'turbo', NULL),
  ('DTRD', '30 TDI (DTRD) 85kW', 1968, 'diesel', 'turbo', NULL),
  ('DXRC', '30 TDI (DXRC) 85kW', 1968, 'diesel', 'turbo', NULL),
  ('CHZJ', '30 TFSI (CHZJ) 85kW', 999, 'petrol', 'turbo', NULL),
  ('DKRA', '30 TFSI (DKRA) 85kW', 999, 'petrol', 'turbo', NULL),
  ('DKRF', '30 TFSI (DKRF) 85kW', 999, 'petrol', 'turbo', NULL),
  ('DLAA', '30 TFSI (DLAA) 81kW', 999, 'petrol', 'turbo', NULL),
  ('DUSA', '30 TFSI (DUSA) 85kW', 999, 'petrol', 'turbo', NULL),
  ('DFGA', '35 TDI (DFGA) 110kW', 1968, 'diesel', 'turbo', NULL),
  ('CRFC', '35 TDI (CRFC) 105kW', 1968, 'diesel', 'turbo', NULL),
  ('DTTC', '35 TDI (DTTC) 110kW', 1968, 'diesel', 'turbo', NULL),
  ('DXRB', '35 TDI (DXRB) 110kW', 1968, 'diesel', 'turbo', NULL),
  ('CZEA', '35 TFSI (CZEA) 110kW', 1395, 'petrol', 'turbo', NULL),
  ('DADA', '35 TFSI (DADA) 110kW', 1498, 'petrol', 'turbo', NULL),
  ('DPCA', '35 TFSI (DPCA) 110kW', 1498, 'petrol', 'turbo', NULL),
  ('DXDB', '35 TFSI (DXDB) 110kW', 1498, 'petrol', 'turbo', NULL),
  ('DFHA', '40 TDI (DFHA) 140kW', 1968, 'diesel', 'turbo', NULL),
  ('CZPB', '40 TFSI (CZPB) 140kW', 1984, 'petrol', 'turbo', NULL),
  ('DKZA', '40 TFSI (DKZA) 140kW', 1984, 'petrol', 'turbo', NULL),
  ('DNNA', '40 TFSI (DNNA) 140kW', 1984, 'petrol', 'turbo', NULL),
  ('DNUE', '50 TFSI (DNUE) 221kW', 1984, 'petrol', 'turbo', NULL),
  ('DNFC', 'SQ2 (DNFC) 221kW', 1984, 'petrol', 'NA', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'engine_oil', (SELECT id FROM engines WHERE code = 'DDYA'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319002488; 30 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DDYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'coolant', (SELECT id FROM engines WHERE code = 'DDYA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319002488; 30 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DDYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DDYA'), 2.1, 2.22, NULL, 'SAE 75W', 'HaynesPro typeId t_319002488; 30 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DDYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'engine_oil', (SELECT id FROM engines WHERE code = 'DGTE'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619013174; 30 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DGTE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'coolant', (SELECT id FROM engines WHERE code = 'DGTE'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619013174; 30 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DGTE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DGTE'), 2.1, 2.22, NULL, 'SAE 75W', 'HaynesPro typeId t_619013174; 30 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DGTE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'engine_oil', (SELECT id FROM engines WHERE code = 'DTRB'), 5.5, 5.81, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619037228; 30 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DTRB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'coolant', (SELECT id FROM engines WHERE code = 'DTRB'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619037228; 30 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DTRB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DTRB'), 1.7, 1.8, NULL, 'VW G 055 512 A2', 'HaynesPro typeId t_619037228; 30 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DTRB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'engine_oil', (SELECT id FROM engines WHERE code = 'DTRD'), 5.5, 5.81, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619037230; 30 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DTRD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'coolant', (SELECT id FROM engines WHERE code = 'DTRD'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619037230; 30 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DTRD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DTRD'), 1.5, 1.59, NULL, 'SAE 75W', 'HaynesPro typeId t_619037230; 30 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DTRD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'engine_oil', (SELECT id FROM engines WHERE code = 'DXRC'), 5.1, 5.39, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619140861; 30 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DXRC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'coolant', (SELECT id FROM engines WHERE code = 'DXRC'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619140861; 30 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DXRC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DXRC'), 1.5, 1.59, NULL, 'SAE 75W', 'HaynesPro typeId t_619140861; 30 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DXRC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'engine_oil', (SELECT id FROM engines WHERE code = 'CHZJ'), 4, 4.23, '0W-30', 'VW 502 00', 'HaynesPro typeId t_319002486; 30 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CHZJ'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'coolant', (SELECT id FROM engines WHERE code = 'CHZJ'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319002486; 30 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CHZJ'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CHZJ'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_319002486; 30 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CHZJ'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'engine_oil', (SELECT id FROM engines WHERE code = 'DKRA'), 4, 4.23, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619017241; 30 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DKRA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'coolant', (SELECT id FROM engines WHERE code = 'DKRA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619017241; 30 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DKRA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DKRA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_619017241; 30 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DKRA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'engine_oil', (SELECT id FROM engines WHERE code = 'DKRF'), 4, 4.23, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619013175; 30 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DKRF'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'coolant', (SELECT id FROM engines WHERE code = 'DKRF'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619013175; 30 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DKRF'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DKRF'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_619013175; 30 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DKRF'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'engine_oil', (SELECT id FROM engines WHERE code = 'DLAA'), 4, 4.23, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619035857; 30 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DLAA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'coolant', (SELECT id FROM engines WHERE code = 'DLAA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035857; 30 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DLAA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DLAA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_619035857; 30 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DLAA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'engine_oil', (SELECT id FROM engines WHERE code = 'DUSA'), NULL, NULL, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619139571; 30 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DUSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'coolant', (SELECT id FROM engines WHERE code = 'DUSA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619139571; 30 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DUSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DUSA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_619139571; 30 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DUSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'engine_oil', (SELECT id FROM engines WHERE code = 'DFGA'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319002489; 35 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DFGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'coolant', (SELECT id FROM engines WHERE code = 'DFGA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319002489; 35 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DFGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DFGA'), 6, 6.34, NULL, 'SAE 75W-90', 'HaynesPro typeId t_319002489; 35 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DFGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'engine_oil', (SELECT id FROM engines WHERE code = 'CRFC'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319002487; 35 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CRFC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'coolant', (SELECT id FROM engines WHERE code = 'CRFC'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319002487; 35 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CRFC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CRFC'), 5.2, 5.49, NULL, 'SAE 75W-90', 'HaynesPro typeId t_319002487; 35 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CRFC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'engine_oil', (SELECT id FROM engines WHERE code = 'DTTC'), 5.1, 5.39, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619035992; 35 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DTTC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'coolant', (SELECT id FROM engines WHERE code = 'DTTC'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035992; 35 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DTTC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DTTC'), 6.9, 7.29, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619035992; 35 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DTTC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'engine_oil', (SELECT id FROM engines WHERE code = 'DXRB'), 5.1, 5.39, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619139626; 35 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DXRB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'coolant', (SELECT id FROM engines WHERE code = 'DXRB'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619139626; 35 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DXRB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DXRB'), 6.9, 7.29, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619139626; 35 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DXRB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZEA'), 4, 4.23, '5W-40', 'VW 502 00', 'HaynesPro typeId t_319001149; 35 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'coolant', (SELECT id FROM engines WHERE code = 'CZEA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319001149; 35 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CZEA'), 2.1, 2.22, NULL, 'SAE 75W', 'HaynesPro typeId t_319001149; 35 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CZEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'engine_oil', (SELECT id FROM engines WHERE code = 'DADA'), 4.3, 4.54, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619016997; 35 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DADA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'coolant', (SELECT id FROM engines WHERE code = 'DADA'), 9, 9.51, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619016997; 35 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DADA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DADA'), 1.7, 1.8, NULL, 'VW G 055 512 A2', 'HaynesPro typeId t_619016997; 35 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DADA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'engine_oil', (SELECT id FROM engines WHERE code = 'DPCA'), 4.3, 4.54, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619023884; 35 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DPCA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'coolant', (SELECT id FROM engines WHERE code = 'DPCA'), 9, 9.51, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619023884; 35 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DPCA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DPCA'), 2.1, 2.22, NULL, 'SAE 75W', 'HaynesPro typeId t_619023884; 35 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DPCA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'engine_oil', (SELECT id FROM engines WHERE code = 'DXDB'), 4.3, 4.54, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619111335; 35 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DXDB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'coolant', (SELECT id FROM engines WHERE code = 'DXDB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619111335; 35 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DXDB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DXDB'), 1.5, 1.59, NULL, 'SAE 75W', 'HaynesPro typeId t_619111335; 35 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DXDB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'engine_oil', (SELECT id FROM engines WHERE code = 'DFHA'), 4.7, 4.97, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319002490; 40 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DFHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'coolant', (SELECT id FROM engines WHERE code = 'DFHA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319002490; 40 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DFHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DFHA'), 6, 6.34, NULL, 'SAE 75W-90', 'HaynesPro typeId t_319002490; 40 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DFHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZPB'), 5.7, 6.02, '0W-20', 'VW 508 00', 'HaynesPro typeId t_319005466; 40 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZPB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'coolant', (SELECT id FROM engines WHERE code = 'CZPB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319005466; 40 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZPB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CZPB'), 6.9, 7.29, NULL, 'SAE 75W-90', 'HaynesPro typeId t_319005466; 40 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CZPB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'engine_oil', (SELECT id FROM engines WHERE code = 'DKZA'), 5.7, 6.02, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619016998; 40 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DKZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'coolant', (SELECT id FROM engines WHERE code = 'DKZA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619016998; 40 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DKZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DKZA'), 6.9, 7.29, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619016998; 40 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DKZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'engine_oil', (SELECT id FROM engines WHERE code = 'DNNA'), 5.7, 6.02, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619035991; 40 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DNNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'coolant', (SELECT id FROM engines WHERE code = 'DNNA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035991; 40 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DNNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DNNA'), 6.9, 7.29, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619035991; 40 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DNNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'engine_oil', (SELECT id FROM engines WHERE code = 'DNUE'), 5.7, 6.02, '0W-30', 'VW 504 00', 'HaynesPro typeId t_619017240; 50 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DNUE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'coolant', (SELECT id FROM engines WHERE code = 'DNUE'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619017240; 50 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DNUE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DNUE'), 6.9, 7.29, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619017240; 50 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DNUE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 296, 'engine_oil', (SELECT id FROM engines WHERE code = 'DNFC'), 5.7, 6.02, '0W-30', 'VW 504 00', 'HaynesPro typeId t_619035858; SQ2; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 296 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DNFC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 296, 'coolant', (SELECT id FROM engines WHERE code = 'DNFC'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035858; SQ2'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 296 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DNFC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 296, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DNFC'), 6.9, 7.29, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619035858; SQ2; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 296 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DNFC'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 295, 'brake_fluid', NULL, 1, 1.06, NULL, 'VW 501 14', 'HaynesPro chassis d_319000521; Alt: DOT 4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 295 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 296, 'brake_fluid', NULL, 1, 1.06, NULL, 'VW 501 14', 'HaynesPro chassis d_319000521; Alt: DOT 4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 296 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (295, 296)
  AND e.code IN ('DDYA', 'DGTE', 'DTRB', 'DTRD', 'DXRC', 'CHZJ', 'DKRA', 'DKRF', 'DLAA', 'DUSA', 'DFGA', 'CRFC', 'DTTC', 'DXRB', 'CZEA', 'DADA', 'DPCA', 'DXDB', 'DFHA', 'CZPB', 'DKZA', 'DNNA', 'DNUE', 'DNFC')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (295, 296)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (295, 296) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;