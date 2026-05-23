-- mig 302 — multi-gen HaynesPro ingest: Audi A5 (8T, 8F)
-- crawl: haynespro-crawl-audi-a5-8t-2026-05-23.json
-- modelId: d_110000005
-- 54 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Audi A5 (8T, 8F)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_110000005', NOW(), 'Multi-gen ingest, 54 engines across 2 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_110000005' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('CABD', '1.8 TFSI (CABD) 125kW', 1798, 'petrol', 'turbo', NULL),
  ('CDHB', '1.8 TFSI (CDHB) 118kW', 1798, 'petrol', 'turbo', NULL),
  ('CJEB', '1.8 TFSI (CJEB) 125kW', 1798, 'petrol', 'turbo', NULL),
  ('CJEE', '1.8 TFSI (CJEE) 130kW', 1798, 'petrol', 'turbo', NULL),
  ('CJED', '1.8 TFSI (CJED) 106kW', 1798, 'petrol', 'turbo', NULL),
  ('CAHA', '2.0 TDI (CAHA) 125kW', 1968, 'diesel', 'turbo', NULL),
  ('CAHB', '2.0 TDI (CAHB) 120kW', 1968, 'diesel', 'turbo', NULL),
  ('CAGA', '2.0 TDI (CAGA) 105kW', 1968, 'diesel', 'turbo', NULL),
  ('CMEA', '2.0 TDI (CMEA) 105kW', 1968, 'diesel', 'turbo', NULL),
  ('CAGB', '2.0 TDI (CAGB) 100kW', 1968, 'diesel', 'turbo', NULL),
  ('CGLC', '2.0 TDI (CGLC) 130kW', 1968, 'diesel', 'turbo', NULL),
  ('CGLD', '2.0 TDI (CGLD) 120kW', 1968, 'diesel', 'turbo', NULL),
  ('CJCA', '2.0 TDI (CJCA) 105kW', 1968, 'diesel', 'turbo', NULL),
  ('CMFA', '2.0 TDI (CMFA) 105kW', 1968, 'diesel', 'turbo', NULL),
  ('CJCB', '2.0 TDI (CJCB) 100kW', 1968, 'diesel', 'turbo', NULL),
  ('CNHC', '2.0 TDI (CNHC) 120kW', 1968, 'diesel', 'turbo', NULL),
  ('CNHA', '2.0 TDI (CNHA) 140kW', 1968, 'diesel', 'turbo', NULL),
  ('CJCD', '2.0 TDI (CJCD) 110kW', 1968, 'diesel', 'turbo', NULL),
  ('CMFB', '2.0 TDI (CMFB) 110kW', 1968, 'diesel', 'turbo', NULL),
  ('CSUA', '2.0 TDI (CSUA) 110kW', 1968, 'diesel', 'turbo', NULL),
  ('CSUB', '2.0 TDI (CSUB) 100kW', 1968, 'diesel', 'turbo', NULL),
  ('CAEB', '2.0 TFSI (CAEB) 155kW', 1984, 'petrol', 'turbo', NULL),
  ('CDNC', '2.0 TFSI (CDNC) 155kW', 1984, 'petrol', 'turbo', NULL),
  ('CDNB', '2.0 TFSI (CDNB) 132kW', 1984, 'petrol', 'turbo', NULL),
  ('CPMA', '2.0 TFSI (CPMA) 155kW', 1984, 'petrol', 'turbo', NULL),
  ('CNCD', '2.0 TFSI (CNCD) 165kW', 1984, 'petrol', 'turbo', NULL),
  ('CAED', '2.0 TFSI (CAED) 162kW', 1984, 'petrol', 'turbo', NULL),
  ('CPMB', '2.0 TFSI (CPMB) 162kW', 1984, 'petrol', 'turbo', NULL),
  ('CNCE', '2.0 TFSI (CNCE) 169kW', 1984, 'petrol', 'turbo', NULL),
  ('CAMA', '2.7 TDI (CAMA) 140kW', 2698, 'diesel', 'turbo', NULL),
  ('CAMB', '2.7 TDI (CAMB) 120kW', 2698, 'diesel', 'turbo', NULL),
  ('CGKA', '2.7 TDI (CGKA) 140kW', 2698, 'diesel', 'turbo', NULL),
  ('CGKB', '2.7 TDI (CGKB) 120kW', 2698, 'diesel', 'turbo', NULL),
  ('CAPA', '3.0 TDI (CAPA) 176kW', 2967, 'diesel', 'turbo', NULL),
  ('CCWA', '3.0 TDI (CCWA) 176kW', 2967, 'diesel', 'turbo', NULL),
  ('CCWB', '3.0 TDI (CCWB) 155kW', 2967, 'diesel', 'turbo', NULL),
  ('CDUC', '3.0 TDI (CDUC) 180kW', 2967, 'diesel', 'turbo', NULL),
  ('CKVB', '3.0 TDI (CKVB) 180kW', 2967, 'diesel', 'turbo', NULL),
  ('CLAB', '3.0 TDI (CLAB) 150kW', 2967, 'diesel', 'turbo', NULL),
  ('CKVC', '3.0 TDI (CKVC) 180kW', 2967, 'diesel', 'turbo', NULL),
  ('CKVD', '3.0 TDI (CKVD) 160kW', 2967, 'diesel', 'turbo', NULL),
  ('CHMB', '3.0 TFSI (CHMB) 200kW', 2995, 'petrol', 'turbo', NULL),
  ('CMUA', '3.0 TFSI (CMUA) 200kW', 2995, 'petrol', 'turbo', NULL),
  ('CRED', '3.0 TFSI (CRED) 200kW', 2995, 'petrol', 'turbo', NULL),
  ('CALA', '3.2 V6 FSi (CALA) 195kW', 3197, 'petrol', 'NA', NULL),
  ('CFSA', 'RS5 (4.2 V8 FSI) (CFSA) 331kW', 4163, 'petrol', 'NA', NULL),
  ('CCBA', 'S5 (3.0 TFSI) (CCBA) 245kW', 2995, 'petrol', 'turbo', NULL),
  ('CAKA', 'S5 (3.0 TFSI) (CAKA) 245kW', 2995, 'petrol', 'turbo', NULL),
  ('CGWC', 'S5 (3.0 TFSI) (CGWC) 245kW', 2995, 'petrol', 'turbo', NULL),
  ('CGXC', 'S5 (3.0 TFSI) (CGXC) 245kW', 2995, 'petrol', 'turbo', NULL),
  ('CTUB', 'S5 (3.0 TFSI) (CTUB) 245kW', 2995, 'petrol', 'turbo', NULL),
  ('CREC', 'S5 (3.0 TFSI) (CREC) 245kW', 2995, 'petrol', 'turbo', NULL),
  ('CTDA', 'S5 (3.0 TFSI) (CTDA) 245kW', 2995, 'petrol', 'turbo', NULL),
  ('CAUA', 'S5 (4.2 V8 FSI) (CAUA) 260kW', 4163, 'petrol', 'NA', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CABD'), 4.6, 4.86, '5W-40', 'VW 502 00', 'HaynesPro typeId t_102000377; 1.8 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CABD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CABD'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102000377; 1.8 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CABD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CABD'), 4, 4.23, NULL, 'SAE 75W-80', 'HaynesPro typeId t_102000377; 1.8 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CABD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CDHB'), 4.6, 4.86, '5W-40', 'VW 502 00', 'HaynesPro typeId t_102001167; 1.8 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CDHB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CDHB'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102001167; 1.8 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CDHB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CDHB'), 4, 4.23, NULL, 'SAE 75W-80', 'HaynesPro typeId t_102001167; 1.8 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CDHB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CJEB'), 4.6, 4.86, '5W-40', 'VW 502 00', 'HaynesPro typeId t_200000064; 1.8 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CJEB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CJEB'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_200000064; 1.8 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CJEB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CJEB'), 4, 4.23, NULL, 'SAE 75W-80', 'HaynesPro typeId t_200000064; 1.8 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CJEB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CJEE'), 4.6, 4.86, '5W-40', 'VW 502 00', 'HaynesPro typeId t_317000191; 1.8 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CJEE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CJEE'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_317000191; 1.8 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CJEE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CJEE'), 4, 4.23, NULL, 'SAE 75W-80', 'HaynesPro typeId t_317000191; 1.8 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CJEE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CJED'), 4.6, 4.86, '5W-40', 'VW 502 00', 'HaynesPro typeId t_311000031; 1.8 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CJED'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CJED'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_311000031; 1.8 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CJED'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_cvt', (SELECT id FROM engines WHERE code = 'CJED'), 8, 8.45, NULL, 'VW G 052 516 A', 'HaynesPro typeId t_311000031; 1.8 TFSI; CVT'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_cvt' AND engine_id = (SELECT id FROM engines WHERE code = 'CJED'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CAHA'), 5, 5.28, '5W-30', 'VW 507 00', 'HaynesPro typeId t_102001129; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CAHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CAHA'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102001129; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CAHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CAHA'), 4, 4.23, NULL, 'SAE 75W-80', 'HaynesPro typeId t_102001129; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CAHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CAHB'), 5, 5.28, '5W-30', 'VW 507 00', 'HaynesPro typeId t_102001130; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CAHB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CAHB'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102001130; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CAHB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CAHB'), 4, 4.23, NULL, 'SAE 75W-80', 'HaynesPro typeId t_102001130; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CAHB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CAGA'), 5, 5.28, '5W-30', 'VW 507 00', 'HaynesPro typeId t_102001128; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CAGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CAGA'), 7.5, 7.93, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102001128; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CAGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CAGA'), 4, 4.23, NULL, 'SAE 75W-80', 'HaynesPro typeId t_102001128; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CAGA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CMEA'), 5, 5.28, '5W-30', 'VW 507 00', 'HaynesPro typeId t_102002282; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CMEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CMEA'), NULL, NULL, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102002282; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CMEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_cvt', (SELECT id FROM engines WHERE code = 'CMEA'), 8, 8.45, NULL, 'VW G 052 516 A', 'HaynesPro typeId t_102002282; 2.0 TDI; CVT'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_cvt' AND engine_id = (SELECT id FROM engines WHERE code = 'CMEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CAGB'), 5, 5.28, '5W-30', 'VW 507 00', 'HaynesPro typeId t_102002281; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CAGB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CAGB'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102002281; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CAGB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CAGB'), 4, 4.23, NULL, 'SAE 75W-80', 'HaynesPro typeId t_102002281; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CAGB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CGLC'), 5, 5.28, '5W-30', 'VW 507 00', 'HaynesPro typeId t_200000062; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CGLC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CGLC'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_200000062; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CGLC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CGLC'), 4, 4.23, NULL, 'SAE 75W-80', 'HaynesPro typeId t_200000062; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CGLC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CGLD'), 5, 5.28, '5W-30', 'VW 507 00', 'HaynesPro typeId t_200000212; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CGLD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CGLD'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_200000212; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CGLD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CGLD'), 4, 4.23, NULL, 'SAE 75W-80', 'HaynesPro typeId t_200000212; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CGLD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CJCA'), 5, 5.28, '5W-30', 'VW 507 00', 'HaynesPro typeId t_200000214; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CJCA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CJCA'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_200000214; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CJCA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CJCA'), 4, 4.23, NULL, 'SAE 75W-80', 'HaynesPro typeId t_200000214; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CJCA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CMFA'), 5, 5.28, '5W-30', 'VW 507 00', 'HaynesPro typeId t_200000218; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CMFA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CMFA'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_200000218; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CMFA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_cvt', (SELECT id FROM engines WHERE code = 'CMFA'), 8, 8.45, NULL, 'VW G 052 516 A', 'HaynesPro typeId t_200000218; 2.0 TDI; CVT'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_cvt' AND engine_id = (SELECT id FROM engines WHERE code = 'CMFA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CJCB'), 5, 5.28, '5W-30', 'VW 507 00', 'HaynesPro typeId t_200000215; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CJCB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CJCB'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_200000215; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CJCB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CJCB'), 4, 4.23, NULL, 'SAE 75W-80', 'HaynesPro typeId t_200000215; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CJCB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CNHC'), 4.7, 4.97, '5W-30', 'VW 507 00', 'HaynesPro typeId t_304000018; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CNHC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CNHC'), NULL, NULL, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_304000018; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CNHC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CNHC'), 4, 4.23, NULL, 'SAE 75W-80', 'HaynesPro typeId t_304000018; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CNHC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CNHA'), 4.7, 4.97, '5W-30', 'VW 507 00', 'HaynesPro typeId t_301000615; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CNHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CNHA'), 8.1, 8.56, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_301000615; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CNHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CNHA'), 4, 4.23, NULL, 'SAE 75W-80', 'HaynesPro typeId t_301000615; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CNHA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CJCD'), 5, 5.28, '5W-30', 'VW 507 00', 'HaynesPro typeId t_301000533; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CJCD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CJCD'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_301000533; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CJCD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CJCD'), 4, 4.23, NULL, 'SAE 75W-80', 'HaynesPro typeId t_301000533; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CJCD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CMFB'), 5, 5.28, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319005459; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CMFB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CMFB'), 8, 8.45, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319005459; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CMFB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_cvt', (SELECT id FROM engines WHERE code = 'CMFB'), 8, 8.45, NULL, 'VW G 052 516 A', 'HaynesPro typeId t_319005459; 2.0 TDI; CVT'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_cvt' AND engine_id = (SELECT id FROM engines WHERE code = 'CMFB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CSUA'), 4.7, 4.97, '5W-30', 'VW 507 00', 'HaynesPro typeId t_304000019; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CSUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CSUA'), NULL, NULL, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_304000019; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CSUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CSUA'), 4, 4.23, NULL, 'SAE 75W-80', 'HaynesPro typeId t_304000019; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CSUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CSUB'), 4.7, 4.97, '5W-30', 'VW 507 00', 'HaynesPro typeId t_304000020; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CSUB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CSUB'), NULL, NULL, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_304000020; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CSUB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CSUB'), 4, 4.23, NULL, 'SAE 75W-80', 'HaynesPro typeId t_304000020; 2.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CSUB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CAEB'), 4.6, 4.86, '5W-40', 'VW 502 00', 'HaynesPro typeId t_102002284; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CAEB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CAEB'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102002284; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CAEB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CAEB'), 4.5, 4.76, NULL, 'SAE 75W-80', 'HaynesPro typeId t_102002284; 2.0 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CAEB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CDNC'), 4.6, 4.86, '5W-40', 'VW 502 00', 'HaynesPro typeId t_102001134; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CDNC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CDNC'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102001134; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CDNC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CDNC'), 4, 4.23, NULL, 'SAE 75W-80', 'HaynesPro typeId t_102001134; 2.0 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CDNC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CDNB'), 4.6, 4.86, '5W-40', 'VW 502 00', 'HaynesPro typeId t_102001135; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CDNB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CDNB'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102001135; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CDNB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CDNB'), 4, 4.23, NULL, 'SAE 75W-80', 'HaynesPro typeId t_102001135; 2.0 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CDNB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CPMA'), 4.6, 4.86, '5W-40', 'VW 502 00', 'HaynesPro typeId t_200000219; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CPMA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CPMA'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_200000219; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CPMA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_at', (SELECT id FROM engines WHERE code = 'CPMA'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_200000219; 2.0 TFSI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CPMA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CNCD'), 4.6, 4.86, '5W-40', 'VW 502 00', 'HaynesPro typeId t_301000534; 2.0 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CNCD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CNCD'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_301000534; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CNCD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CNCD'), 4, 4.23, NULL, 'SAE 75W-80', 'HaynesPro typeId t_301000534; 2.0 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CNCD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CAED'), 4.6, 4.86, '5W-40', 'VW 502 00', 'HaynesPro typeId t_301000606; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CAED'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CAED'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_301000606; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CAED'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CAED'), 4.5, 4.76, NULL, 'SAE 75W-80', 'HaynesPro typeId t_301000606; 2.0 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CAED'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CPMB'), 4.6, 4.86, '5W-40', 'VW 502 00', 'HaynesPro typeId t_301000617; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CPMB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CPMB'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_301000617; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CPMB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_at', (SELECT id FROM engines WHERE code = 'CPMB'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_301000617; 2.0 TFSI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CPMB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CNCE'), 4.6, 4.86, '5W-40', 'VW 502 00', 'HaynesPro typeId t_318011829; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CNCE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CNCE'), 10, 10.57, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_318011829; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CNCE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CNCE'), 4, 4.23, NULL, 'SAE 75W-80', 'HaynesPro typeId t_318011829; 2.0 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CNCE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CAMA'), 6.9, 7.29, '5W-30', 'VW 507 00', 'HaynesPro typeId t_110000135; 2.7 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CAMA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CAMA'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_110000135; 2.7 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CAMA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_cvt', (SELECT id FROM engines WHERE code = 'CAMA'), 8, 8.45, NULL, 'VW G 052 516 A', 'HaynesPro typeId t_110000135; 2.7 TDI; CVT'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_cvt' AND engine_id = (SELECT id FROM engines WHERE code = 'CAMA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CAMB'), 6.9, 7.29, '5W-30', 'VW 507 00', 'HaynesPro typeId t_102001132; 2.7 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CAMB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CAMB'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102001132; 2.7 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CAMB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_cvt', (SELECT id FROM engines WHERE code = 'CAMB'), 8, 8.45, NULL, 'VW G 052 516 A', 'HaynesPro typeId t_102001132; 2.7 TDI; CVT'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_cvt' AND engine_id = (SELECT id FROM engines WHERE code = 'CAMB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CGKA'), 6.9, 7.29, '5W-30', 'VW 507 00', 'HaynesPro typeId t_102001133; 2.7 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CGKA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CGKA'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102001133; 2.7 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CGKA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CGKA'), 3.5, 3.7, NULL, 'SAE 75W-90', 'HaynesPro typeId t_102001133; 2.7 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CGKA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CGKB'), 6.9, 7.29, '5W-30', 'VW 507 00', 'HaynesPro typeId t_102001140; 2.7 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CGKB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CGKB'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102001140; 2.7 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CGKB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_cvt', (SELECT id FROM engines WHERE code = 'CGKB'), 8, 8.45, NULL, 'VW G 052 516 A', 'HaynesPro typeId t_102001140; 2.7 TDI; CVT'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_cvt' AND engine_id = (SELECT id FROM engines WHERE code = 'CGKB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CAPA'), 6.9, 7.29, '5W-30', 'VW 507 00', 'HaynesPro typeId t_110000133; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CAPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CAPA'), 9, 9.51, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_110000133; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CAPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CAPA'), 3.8, 4.02, NULL, 'SAE 75W-90', 'HaynesPro typeId t_110000133; 3.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CAPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CCWA'), 6.9, 7.29, '5W-30', 'VW 507 00', 'HaynesPro typeId t_102001136; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CCWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CCWA'), 9, 9.51, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102001136; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CCWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CCWA'), 3.8, 4.02, NULL, 'SAE 75W-90', 'HaynesPro typeId t_102001136; 3.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CCWA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CCWB'), 6.9, 7.29, '5W-30', 'VW 507 00', 'HaynesPro typeId t_102001141; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CCWB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CCWB'), 9, 9.51, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102001141; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CCWB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_at', (SELECT id FROM engines WHERE code = 'CCWB'), 10.4, 10.99, NULL, 'SAE 75W-90', 'HaynesPro typeId t_102001141; 3.0 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CCWB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CDUC'), 6.4, 6.76, '5W-30', 'VW 507 00', 'HaynesPro typeId t_200000061; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CDUC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CDUC'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_200000061; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CDUC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CDUC'), 3.8, 4.02, NULL, 'SAE 75W-90', 'HaynesPro typeId t_200000061; 3.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CDUC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CKVB'), 6.4, 6.76, '5W-30', 'VW 507 00', 'HaynesPro typeId t_200000216; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CKVB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CKVB'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_200000216; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CKVB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CKVB'), 4.35, 4.6, NULL, 'SAE 75W-80', 'HaynesPro typeId t_200000216; 3.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CKVB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CLAB'), 6.4, 6.76, '5W-30', 'VW 507 00', 'HaynesPro typeId t_200000065; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CLAB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CLAB'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_200000065; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CLAB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CLAB'), 4, 4.23, NULL, 'SAE 75W-80', 'HaynesPro typeId t_200000065; 3.0 TDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CLAB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CKVC'), 6.4, 6.76, '5W-30', 'VW 507 00', 'HaynesPro typeId t_301000609; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CKVC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CKVC'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_301000609; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CKVC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CKVC'), 4.35, 4.6, NULL, 'SAE 75W-80', 'HaynesPro typeId t_301000609; 3.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CKVC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CKVD'), 6.4, 6.76, '0W-30', 'VW 507 00', 'HaynesPro typeId t_318011830; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CKVD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CKVD'), NULL, NULL, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_318011830; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CKVD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CKVD'), 4.35, 4.6, NULL, 'SAE 75W-80', 'HaynesPro typeId t_318011830; 3.0 TDI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CKVD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CHMB'), 6.8, 7.19, '5W-40', 'VW 502 00', 'HaynesPro typeId t_319005528; 3.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CHMB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CHMB'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_319005528; 3.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CHMB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CHMB'), 4.35, 4.6, NULL, 'SAE 75W-80', 'HaynesPro typeId t_319005528; 3.0 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CHMB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CMUA'), 6.8, 7.19, '5W-30', 'VW 504 00', 'HaynesPro typeId t_200000220; 3.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CMUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CMUA'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_200000220; 3.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CMUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CMUA'), 4.35, 4.6, NULL, 'SAE 75W-80', 'HaynesPro typeId t_200000220; 3.0 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CMUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CRED'), 6.8, 7.19, '5W-40', 'VW 502 00', 'HaynesPro typeId t_304000021; 3.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CRED'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CRED'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_304000021; 3.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CRED'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CRED'), 4.35, 4.6, NULL, 'SAE 75W-80', 'HaynesPro typeId t_304000021; 3.0 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CRED'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CALA'), 6.2, 6.55, '5W-40', 'VW 502 00', 'HaynesPro typeId t_110000140; 3.2 V6 FSi; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CALA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CALA'), NULL, NULL, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_110000140; 3.2 V6 FSi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CALA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CALA'), 4.5, 4.76, NULL, 'SAE 75W-80', 'HaynesPro typeId t_110000140; 3.2 V6 FSi; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CALA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 274, 'engine_oil', (SELECT id FROM engines WHERE code = 'CFSA'), 9.7, 10.25, '5W-40', 'VW 502 00', 'HaynesPro typeId t_102002237; RS5 (4.2 V8 FSI); drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 274 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CFSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 274, 'coolant', (SELECT id FROM engines WHERE code = 'CFSA'), 15, 15.85, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102002237; RS5 (4.2 V8 FSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 274 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CFSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 274, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CFSA'), 4.35, 4.6, NULL, 'VW G 052 513 A2', 'HaynesPro typeId t_102002237; RS5 (4.2 V8 FSI); Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 274 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CFSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CCBA'), 6.2, 6.55, '5W-40', 'VW 502 00', 'HaynesPro typeId t_102002283; S5 (3.0 TFSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CCBA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CCBA'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102002283; S5 (3.0 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CCBA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CCBA'), 4.35, 4.6, NULL, 'VW G 052 513 A2', 'HaynesPro typeId t_102002283; S5 (3.0 TFSI); Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CCBA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CAKA'), 6.2, 6.55, '5W-40', 'VW 502 00', 'HaynesPro typeId t_102001131; S5 (3.0 TFSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CAKA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CAKA'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_102001131; S5 (3.0 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CAKA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CAKA'), 4.35, 4.6, NULL, 'VW G 052 513 A2', 'HaynesPro typeId t_102001131; S5 (3.0 TFSI); Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CAKA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CGWC'), 6.8, 7.19, '5W-40', 'VW 502 00', 'HaynesPro typeId t_200000063; S5 (3.0 TFSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CGWC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CGWC'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_200000063; S5 (3.0 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CGWC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CGWC'), 4.35, 4.6, NULL, 'VW G 052 513 A2', 'HaynesPro typeId t_200000063; S5 (3.0 TFSI); Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CGWC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CGXC'), 6.8, 7.19, '5W-40', 'VW 502 00', 'HaynesPro typeId t_200000221; S5 (3.0 TFSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CGXC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CGXC'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_200000221; S5 (3.0 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CGXC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CGXC'), 3.8, 4.02, NULL, 'SAE 75W-90', 'HaynesPro typeId t_200000221; S5 (3.0 TFSI); Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CGXC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CTUB'), 6.8, 7.19, '5W-40', 'VW 502 00', 'HaynesPro typeId t_201000086; S5 (3.0 TFSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CTUB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CTUB'), 15, 15.85, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_201000086; S5 (3.0 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CTUB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CTUB'), 3.8, 4.02, NULL, 'SAE 75W-90', 'HaynesPro typeId t_201000086; S5 (3.0 TFSI); Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CTUB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CREC'), 6.8, 7.19, '0W-30', 'VW 502 00', 'HaynesPro typeId t_311000034; S5 (3.0 TFSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CREC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CREC'), 15, 15.85, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_311000034; S5 (3.0 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CREC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CREC'), 4.35, 4.6, NULL, 'SAE 75W-80', 'HaynesPro typeId t_311000034; S5 (3.0 TFSI); Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CREC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CTDA'), 6.8, 7.19, '0W-30', 'VW 502 00', 'HaynesPro typeId t_318011828; S5 (3.0 TFSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CTDA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CTDA'), 12, 12.68, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_318011828; S5 (3.0 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CTDA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CTDA'), 4.35, 4.6, NULL, 'SAE 75W-80', 'HaynesPro typeId t_318011828; S5 (3.0 TFSI); Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CTDA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'engine_oil', (SELECT id FROM engines WHERE code = 'CAUA'), 8.8, 9.3, '5W-40', 'VW 502 00', 'HaynesPro typeId t_110000136; S5 (4.2 V8 FSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CAUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'coolant', (SELECT id FROM engines WHERE code = 'CAUA'), 14.5, 15.32, NULL, 'TL-VW 774J (G13)', 'HaynesPro typeId t_110000136; S5 (4.2 V8 FSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CAUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'transmission_mt', (SELECT id FROM engines WHERE code = 'CAUA'), 3.8, 4.02, NULL, 'SAE 75W-90', 'HaynesPro typeId t_110000136; S5 (4.2 V8 FSI); Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'CAUA'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 273, 'brake_fluid', NULL, 1, 1.06, NULL, 'VW 501 14', 'HaynesPro chassis d_110000005; Alt: DOT 4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 273 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 274, 'brake_fluid', NULL, 1, 1.06, NULL, 'VW 501 14', 'HaynesPro chassis d_110000005; Alt: DOT 4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 274 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (273, 274)
  AND e.code IN ('CABD', 'CDHB', 'CJEB', 'CJEE', 'CJED', 'CAHA', 'CAHB', 'CAGA', 'CMEA', 'CAGB', 'CGLC', 'CGLD', 'CJCA', 'CMFA', 'CJCB', 'CNHC', 'CNHA', 'CJCD', 'CMFB', 'CSUA', 'CSUB', 'CAEB', 'CDNC', 'CDNB', 'CPMA', 'CNCD', 'CAED', 'CPMB', 'CNCE', 'CAMA', 'CAMB', 'CGKA', 'CGKB', 'CAPA', 'CCWA', 'CCWB', 'CDUC', 'CKVB', 'CLAB', 'CKVC', 'CKVD', 'CHMB', 'CMUA', 'CRED', 'CALA', 'CFSA', 'CCBA', 'CAKA', 'CGWC', 'CGXC', 'CTUB', 'CREC', 'CTDA', 'CAUA')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (273, 274)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (273, 274) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;