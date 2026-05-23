-- mig 322 — multi-gen HaynesPro ingest: Audi TT (FV/8S)
-- crawl: haynespro-crawl-audi-tt-fv-2026-05-23.json
-- modelId: d_303000002
-- 17 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Audi TT (FV/8S)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_303000002', NOW(), 'Multi-gen ingest, 17 engines across 2 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_303000002' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('CJSA', '1.8 TFSI (CJSA) 132kW', 1798, 'petrol', 'turbo', NULL),
  ('CJSB', '1.8 TFSI (CJSB) 132kW', 1798, 'petrol', 'turbo', NULL),
  ('CUNA', '2.0 TDI (CUNA) 135kW', 1968, 'diesel', 'turbo', NULL),
  ('CHHC', '2.0 TFSI (CHHC) 169kW', 1984, 'petrol', 'turbo', NULL),
  ('DLRA', '2.0 TFSI (DLRA) 215kW', 1984, 'petrol', 'turbo', NULL),
  ('DHHA', '2.0 TFSI (DHHA) 170kW', 1984, 'petrol', 'turbo', NULL),
  ('DKZB', '40 TFSI (DKZB) 145kW', 1984, 'petrol', 'turbo', NULL),
  ('DNNB', '40 TFSI (DNNB) 145kW', 1984, 'petrol', 'turbo', NULL),
  ('DKTB', '45 TFSI (DKTB) 180kW', 1984, 'petrol', 'turbo', NULL),
  ('DNPA', '45 TFSI (DNPA) 180kW', 1984, 'petrol', 'turbo', NULL),
  ('DAZA', 'RS (2.5 TFSI) (DAZA) 294kW', 2480, 'petrol', 'turbo', NULL),
  ('DNWA', 'RS (2.5 TFSI) (DNWA) 294kW', 2480, 'petrol', 'turbo', NULL),
  ('CJXG', 'S (2.0 TFSI) (CJXG) 228kW', 1984, 'petrol', 'turbo', NULL),
  ('CYFB', 'S (2.0 TFSI) (CYFB) 215kW', 1984, 'petrol', 'turbo', NULL),
  ('CJXF', 'S (2.0 TFSI) (CJXF) 210kW', 1984, 'petrol', 'turbo', NULL),
  ('DNUF', 'S (2.0 TFSI) (DNUF) 225kW', 1984, 'petrol', 'turbo', NULL),
  ('DNFD', 'S (2.0 TFSI) (DNFD) 235kW', 1984, 'petrol', 'turbo', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'engine_oil', (SELECT id FROM engines WHERE code = 'CJSA'), 5.7, 6.02, '0W-30', 'VW 502 00', 'HaynesPro typeId t_318011847; 1.8 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CJSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'coolant', (SELECT id FROM engines WHERE code = 'CJSA'), NULL, NULL, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011847; 1.8 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CJSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CJSA'), 2.1, 2.22, NULL, 'SAE 75W', 'HaynesPro typeId t_318011847; 1.8 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CJSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'engine_oil', (SELECT id FROM engines WHERE code = 'CJSB'), 5.7, 6.02, '0W-30', 'VW 502 00', 'HaynesPro typeId t_319004612; 1.8 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CJSB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'coolant', (SELECT id FROM engines WHERE code = 'CJSB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319004612; 1.8 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CJSB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CJSB'), 5.2, 5.49, NULL, 'SAE 75W', 'HaynesPro typeId t_319004612; 1.8 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CJSB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'engine_oil', (SELECT id FROM engines WHERE code = 'CUNA'), 4.7, 4.97, '5W-30', 'VW 507 00', 'HaynesPro typeId t_310000057; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CUNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'coolant', (SELECT id FROM engines WHERE code = 'CUNA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_310000057; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CUNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CUNA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_310000057; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CUNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'engine_oil', (SELECT id FROM engines WHERE code = 'CHHC'), 5.7, 6.02, '5W-40', 'VW 502 00', 'HaynesPro typeId t_310000055; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CHHC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'coolant', (SELECT id FROM engines WHERE code = 'CHHC'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_310000055; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CHHC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CHHC'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_310000055; 2.0 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CHHC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'engine_oil', (SELECT id FROM engines WHERE code = 'DLRA'), 5.7, 6.02, '0W-30', 'VW 504 00', 'HaynesPro typeId t_619017277; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DLRA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'coolant', (SELECT id FROM engines WHERE code = 'DLRA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619017277; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DLRA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DLRA'), 6.9, 7.29, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619017277; 2.0 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DLRA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'engine_oil', (SELECT id FROM engines WHERE code = 'DHHA'), 5.7, 6.02, '0W-30', 'VW 504 00', 'HaynesPro typeId t_619017275; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DHHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'coolant', (SELECT id FROM engines WHERE code = 'DHHA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619017275; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DHHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DHHA'), 6.9, 7.29, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619017275; 2.0 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DHHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'engine_oil', (SELECT id FROM engines WHERE code = 'DKZB'), 5.7, 6.02, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619017007; 40 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DKZB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'coolant', (SELECT id FROM engines WHERE code = 'DKZB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619017007; 40 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DKZB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DKZB'), 6.9, 7.29, NULL, NULL, 'HaynesPro typeId t_619017007; 40 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DKZB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'engine_oil', (SELECT id FROM engines WHERE code = 'DNNB'), 5.7, 6.02, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619039543; 40 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DNNB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'coolant', (SELECT id FROM engines WHERE code = 'DNNB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619039543; 40 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DNNB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DNNB'), 6.9, 7.29, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619039543; 40 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DNNB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'engine_oil', (SELECT id FROM engines WHERE code = 'DKTB'), 5.7, 6.02, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619017276; 45 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DKTB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'coolant', (SELECT id FROM engines WHERE code = 'DKTB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619017276; 45 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DKTB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DKTB'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_619017276; 45 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DKTB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'engine_oil', (SELECT id FROM engines WHERE code = 'DNPA'), 5.7, 6.02, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619035998; 45 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DNPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'coolant', (SELECT id FROM engines WHERE code = 'DNPA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035998; 45 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DNPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DNPA'), 6.9, 7.29, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619035998; 45 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DNPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 301, 'engine_oil', (SELECT id FROM engines WHERE code = 'DAZA'), 7.1, 7.5, '0W-30', 'VW 504 00', 'HaynesPro typeId t_319004592; RS (2.5 TFSI); drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 301 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DAZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 301, 'coolant', (SELECT id FROM engines WHERE code = 'DAZA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319004592; RS (2.5 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 301 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DAZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 301, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DAZA'), 5.5, 5.81, NULL, 'SAE 75W-90', 'HaynesPro typeId t_319004592; RS (2.5 TFSI); Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 301 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DAZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 301, 'engine_oil', (SELECT id FROM engines WHERE code = 'DNWA'), 7.1, 7.5, '0W-30', 'VW 504 00', 'HaynesPro typeId t_619016912; RS (2.5 TFSI); drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 301 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DNWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 301, 'coolant', (SELECT id FROM engines WHERE code = 'DNWA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619016912; RS (2.5 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 301 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DNWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 301, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DNWA'), 5.5, 5.81, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619016912; RS (2.5 TFSI); Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 301 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DNWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'engine_oil', (SELECT id FROM engines WHERE code = 'CJXG'), 5.7, 6.02, '5W-40', 'VW 502 00', 'HaynesPro typeId t_310000056; S (2.0 TFSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CJXG'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'coolant', (SELECT id FROM engines WHERE code = 'CJXG'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_310000056; S (2.0 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CJXG'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CJXG'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_310000056; S (2.0 TFSI); Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CJXG'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'engine_oil', (SELECT id FROM engines WHERE code = 'CYFB'), 5.7, 6.02, '0W-30', 'VW 502 00', 'HaynesPro typeId t_318011849; S (2.0 TFSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CYFB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'coolant', (SELECT id FROM engines WHERE code = 'CYFB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011849; S (2.0 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CYFB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CYFB'), 5.2, 5.49, NULL, 'SAE 75W-90', 'HaynesPro typeId t_318011849; S (2.0 TFSI); Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CYFB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'engine_oil', (SELECT id FROM engines WHERE code = 'CJXF'), 5.7, 6.02, '0W-30', 'VW 502 00', 'HaynesPro typeId t_318011848; S (2.0 TFSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CJXF'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'coolant', (SELECT id FROM engines WHERE code = 'CJXF'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011848; S (2.0 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CJXF'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CJXF'), 5.2, 5.49, NULL, 'SAE 75W-90', 'HaynesPro typeId t_318011848; S (2.0 TFSI); Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CJXF'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'engine_oil', (SELECT id FROM engines WHERE code = 'DNUF'), 5.7, 6.02, '0W-30', 'VW 504 00', 'HaynesPro typeId t_619017278; S (2.0 TFSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DNUF'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'coolant', (SELECT id FROM engines WHERE code = 'DNUF'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619017278; S (2.0 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DNUF'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DNUF'), 6.9, 7.29, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619017278; S (2.0 TFSI); Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DNUF'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'engine_oil', (SELECT id FROM engines WHERE code = 'DNFD'), 5.7, 6.02, '0W-30', 'VW 504 00', 'HaynesPro typeId t_619035997; S (2.0 TFSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DNFD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'coolant', (SELECT id FROM engines WHERE code = 'DNFD'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035997; S (2.0 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DNFD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DNFD'), 6.9, 7.29, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619035997; S (2.0 TFSI); Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DNFD'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 300, 'brake_fluid', NULL, 1, 1.06, NULL, 'VW 501 14', 'HaynesPro chassis d_303000002; Alt: DOT 4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 300 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 301, 'brake_fluid', NULL, 1, 1.06, NULL, 'VW 501 14', 'HaynesPro chassis d_303000002; Alt: DOT 4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 301 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (300, 301)
  AND e.code IN ('CJSA', 'CJSB', 'CUNA', 'CHHC', 'DLRA', 'DHHA', 'DKZB', 'DNNB', 'DKTB', 'DNPA', 'DAZA', 'DNWA', 'CJXG', 'CYFB', 'CJXF', 'DNUF', 'DNFD')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (300, 301)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (300, 301) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;