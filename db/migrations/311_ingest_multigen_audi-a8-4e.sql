-- mig 311 — multi-gen HaynesPro ingest: Audi A8 (4E)
-- crawl: haynespro-crawl-audi-a8-4e-2026-05-23.json
-- modelId: d_440
-- 15 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Audi A8 (4E)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_440', NOW(), 'Multi-gen ingest, 15 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_440' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('BDX', '2.8 FSi (BDX) 154kW', 2773, 'petrol', 'NA', NULL),
  ('ASN', '3.0 V6 (ASN) 162kW', 2976, 'petrol', 'NA', NULL),
  ('BBJ', '3.0 V6 (BBJ) 160kW', 2976, 'petrol', 'NA', NULL),
  ('ASB', '3.0 V6 TDI (ASB) 171kW', 2967, 'diesel', 'turbo', NULL),
  ('BNG', '3.0 V6 TDI (BNG) 155kW', 2967, 'diesel', 'turbo', NULL),
  ('BPK', '3.2 FSI (BPK) 191kW', 3123, 'petrol', 'NA', NULL),
  ('BFL', '3.7 V8 (BFL) 206kW', 3697, 'petrol', 'NA', NULL),
  ('ASE', '4.0 V8 TDI (ASE) 202kW', 3936, 'diesel', 'turbo', NULL),
  ('BFM', '4.2 V8 (BFM) 246kW', 4172, 'petrol', 'NA', NULL),
  ('BVJ', '4.2 V8 (BVJ) 257kW', 4163, 'petrol', 'NA', NULL),
  ('BGK', '4.2 V8 (BGK) 246kW', 4172, 'petrol', 'NA', NULL),
  ('BMC', '4.2 V8 TDI (BMC) 213kW', 4134, 'diesel', 'turbo', NULL),
  ('BVN', '4.2 V8 TDI (BVN) 240kW', 4134, 'diesel', 'turbo', NULL),
  ('BHT', '6.0 W12 (BHT) 331kW', 5998, 'petrol', 'NA', NULL),
  ('BSM', 'S8 (5.2 V10 FSi) (BSM) 331kW', 5204, 'petrol', 'NA', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'engine_oil', (SELECT id FROM engines WHERE code = 'BDX'), 6.2, 6.55, '5W-30', 'VW 502 00', 'HaynesPro typeId t_110000037; 2.8 FSi; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BDX'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'coolant', (SELECT id FROM engines WHERE code = 'BDX'), 12, 12.68, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_110000037; 2.8 FSi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BDX'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'transmission_cvt', (SELECT id FROM engines WHERE code = 'BDX'), 7.5, 7.93, NULL, 'SAE 75W-85', 'HaynesPro typeId t_110000037; 2.8 FSi; CVT'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'transmission_cvt' AND engine_id = (SELECT id FROM engines WHERE code = 'BDX'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'engine_oil', (SELECT id FROM engines WHERE code = 'ASN'), 6.3, 6.66, '5W-30', 'VW 501 01', 'HaynesPro typeId t_72730; 3.0 V6; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'ASN'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'coolant', (SELECT id FROM engines WHERE code = 'ASN'), 12.6, 13.31, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_72730; 3.0 V6'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'ASN'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'transmission_cvt', (SELECT id FROM engines WHERE code = 'ASN'), 7.5, 7.93, NULL, 'SAE 75W-85', 'HaynesPro typeId t_72730; 3.0 V6; CVT'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'transmission_cvt' AND engine_id = (SELECT id FROM engines WHERE code = 'ASN'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'engine_oil', (SELECT id FROM engines WHERE code = 'BBJ'), 6.3, 6.66, '5W-30', 'VW 501 01', 'HaynesPro typeId t_72750; 3.0 V6; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BBJ'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'coolant', (SELECT id FROM engines WHERE code = 'BBJ'), 14.5, 15.32, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_72750; 3.0 V6'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BBJ'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'transmission_cvt', (SELECT id FROM engines WHERE code = 'BBJ'), 7.5, 7.93, NULL, 'SAE 75W-85', 'HaynesPro typeId t_72750; 3.0 V6; CVT'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'transmission_cvt' AND engine_id = (SELECT id FROM engines WHERE code = 'BBJ'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'engine_oil', (SELECT id FROM engines WHERE code = 'ASB'), 8.2, 8.66, '5W-30', 'VW 505 00', 'HaynesPro typeId t_72770; 3.0 V6 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'ASB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'coolant', (SELECT id FROM engines WHERE code = 'ASB'), 15.8, 16.7, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_72770; 3.0 V6 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'ASB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'transmission_at', (SELECT id FROM engines WHERE code = 'ASB'), 9.8, 10.36, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_72770; 3.0 V6 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'ASB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'engine_oil', (SELECT id FROM engines WHERE code = 'BNG'), 8.2, 8.66, '5W-30', 'VW 505 00', 'HaynesPro typeId t_72790; 3.0 V6 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BNG'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'coolant', (SELECT id FROM engines WHERE code = 'BNG'), 13.5, 14.27, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_72790; 3.0 V6 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BNG'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'transmission_at', (SELECT id FROM engines WHERE code = 'BNG'), 9.8, 10.36, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_72790; 3.0 V6 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'BNG'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'engine_oil', (SELECT id FROM engines WHERE code = 'BPK'), 6.5, 6.87, '5W-30', 'VW 501 01', 'HaynesPro typeId t_110000033; 3.2 FSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BPK'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'coolant', (SELECT id FROM engines WHERE code = 'BPK'), 12, 12.68, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_110000033; 3.2 FSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BPK'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'transmission_cvt', (SELECT id FROM engines WHERE code = 'BPK'), 7.5, 7.93, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_110000033; 3.2 FSI; CVT'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'transmission_cvt' AND engine_id = (SELECT id FROM engines WHERE code = 'BPK'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'engine_oil', (SELECT id FROM engines WHERE code = 'BFL'), 7.5, 7.93, '5W-30', 'VW 501 01', 'HaynesPro typeId t_72720; 3.7 V8; drain 50 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BFL'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'coolant', (SELECT id FROM engines WHERE code = 'BFL'), 11.5, 12.15, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_72720; 3.7 V8'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BFL'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'transmission_at', (SELECT id FROM engines WHERE code = 'BFL'), 10.4, 10.99, NULL, 'VW G 055 005 A2', 'HaynesPro typeId t_72720; 3.7 V8; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'BFL'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'engine_oil', (SELECT id FROM engines WHERE code = 'ASE'), 9.5, 10.04, '5W-30', 'VW 505 00', 'HaynesPro typeId t_72780; 4.0 V8 TDI; drain 50 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'ASE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'coolant', (SELECT id FROM engines WHERE code = 'ASE'), 15.9, 16.8, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_72780; 4.0 V8 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'ASE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'transmission_at', (SELECT id FROM engines WHERE code = 'ASE'), 10.4, 10.99, NULL, 'VW G 055 005 A2', 'HaynesPro typeId t_72780; 4.0 V8 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'ASE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'engine_oil', (SELECT id FROM engines WHERE code = 'BFM'), 7.5, 7.93, '5W-30', 'VW 501 01', 'HaynesPro typeId t_72590; 4.2 V8; drain 50 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BFM'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'coolant', (SELECT id FROM engines WHERE code = 'BFM'), 11.5, 12.15, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_72590; 4.2 V8'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BFM'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'transmission_at', (SELECT id FROM engines WHERE code = 'BFM'), 10.4, 10.99, NULL, 'VW G 055 005 A2', 'HaynesPro typeId t_72590; 4.2 V8; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'BFM'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'engine_oil', (SELECT id FROM engines WHERE code = 'BVJ'), 8.5, 8.98, '5W-30', 'VW 501 01', 'HaynesPro typeId t_110000035; 4.2 V8; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BVJ'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'coolant', (SELECT id FROM engines WHERE code = 'BVJ'), 12.8, 13.53, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_110000035; 4.2 V8'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BVJ'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'transmission_at', (SELECT id FROM engines WHERE code = 'BVJ'), 9.8, 10.36, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_110000035; 4.2 V8; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'BVJ'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'engine_oil', (SELECT id FROM engines WHERE code = 'BGK'), 7.5, 7.93, '5W-30', 'VW 501 01', 'HaynesPro typeId t_619017215; 4.2 V8; drain 50 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BGK'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'coolant', (SELECT id FROM engines WHERE code = 'BGK'), 11.5, 12.15, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_619017215; 4.2 V8'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BGK'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'transmission_at', (SELECT id FROM engines WHERE code = 'BGK'), 10.4, 10.99, NULL, 'VW G 055 005 A2', 'HaynesPro typeId t_619017215; 4.2 V8; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'BGK'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'engine_oil', (SELECT id FROM engines WHERE code = 'BMC'), 9.5, 10.04, '5W-30', 'VW 507 00', 'HaynesPro typeId t_72830; 4.2 V8 TDI; drain 50 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BMC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'coolant', (SELECT id FROM engines WHERE code = 'BMC'), 17, 17.96, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_72830; 4.2 V8 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BMC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'transmission_at', (SELECT id FROM engines WHERE code = 'BMC'), 10.4, 10.99, NULL, 'VW G 055 005 A2', 'HaynesPro typeId t_72830; 4.2 V8 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'BMC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'engine_oil', (SELECT id FROM engines WHERE code = 'BVN'), NULL, NULL, '5W-30', 'VW 507 00', 'HaynesPro typeId t_110000034; 4.2 V8 TDI; drain 50 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BVN'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'coolant', (SELECT id FROM engines WHERE code = 'BVN'), 14.9, 15.74, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_110000034; 4.2 V8 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BVN'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'transmission_at', (SELECT id FROM engines WHERE code = 'BVN'), 10.4, 10.99, NULL, 'VW G 055 005 A2', 'HaynesPro typeId t_110000034; 4.2 V8 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'BVN'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'engine_oil', (SELECT id FROM engines WHERE code = 'BHT'), 12.5, 13.21, '5W-30', 'VW 502 00', 'HaynesPro typeId t_72760; 6.0 W12; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BHT'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'coolant', (SELECT id FROM engines WHERE code = 'BHT'), 17.9, 18.91, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_72760; 6.0 W12'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BHT'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'transmission_at', (SELECT id FROM engines WHERE code = 'BHT'), 10.4, 10.99, NULL, 'VW G 055 005 A2', 'HaynesPro typeId t_72760; 6.0 W12; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'BHT'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'engine_oil', (SELECT id FROM engines WHERE code = 'BSM'), 10, 10.57, '0W-30', 'VW 502 00', 'HaynesPro typeId t_110000036; S8 (5.2 V10 FSi); drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BSM'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'coolant', (SELECT id FROM engines WHERE code = 'BSM'), 15.6, 16.48, NULL, 'TL-VW 774G (G12++)', 'HaynesPro typeId t_110000036; S8 (5.2 V10 FSi)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BSM'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'transmission_at', (SELECT id FROM engines WHERE code = 'BSM'), 10.4, 10.99, NULL, 'VW G 055 005 A2', 'HaynesPro typeId t_110000036; S8 (5.2 V10 FSi); Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'BSM'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 287, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4', 'HaynesPro chassis d_440;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 287 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (287)
  AND e.code IN ('BDX', 'ASN', 'BBJ', 'ASB', 'BNG', 'BPK', 'BFL', 'ASE', 'BFM', 'BVJ', 'BGK', 'BMC', 'BVN', 'BHT', 'BSM')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (287)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (287) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;