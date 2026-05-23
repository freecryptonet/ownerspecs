-- mig 222 — multi-gen HaynesPro ingest: VW Golf VIII (CD, CG)
-- crawl: haynespro-crawl-vw-golf-viii-cd-2026-05-23.json
-- modelId: d_319007235
-- 28 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — VW Golf VIII (CD, CG)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319007235', NOW(), 'Multi-gen ingest, 28 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319007235' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('DLAB', '1.0 TSI (DLAB) 66kW', 999, 'petrol', 'turbo', NULL),
  ('DLAA', '1.0 eTSI (DLAA) 81kW', 999, 'hybrid', 'turbo', NULL),
  ('DJKA', '1.4 TSI (DJKA) 110kW', 1395, 'petrol', 'turbo', NULL),
  ('DHFA', '1.5 TGI (DHFA) 96kW', 1498, 'petrol', 'turbo', NULL),
  ('DPCA', '1.5 TSI (DPCA) 110kW', 1498, 'petrol', 'turbo', NULL),
  ('DPBA', '1.5 TSI (DPBA) 96kW', 1498, 'petrol', 'turbo', NULL),
  ('DFYA', '1.5 eTSI (DFYA) 110kW', 1498, 'hybrid', 'turbo', NULL),
  ('CWVA', '1.6 MPI (CWVA) 81kW', 1598, 'petrol', 'NA', NULL),
  ('DWYA', '1.6 MPI (DWYA) 81kW', 1598, 'petrol', 'NA', NULL),
  ('DTSA', '2.0 TDI (DTSA) 110kW', 1968, 'diesel', 'turbo', NULL),
  ('DTSB', '2.0 TDI (DTSB) 110kW', 1968, 'diesel', 'turbo', NULL),
  ('DTRB', '2.0 TDI (DTRB) 85kW', 1968, 'diesel', 'turbo', NULL),
  ('DTRD', '2.0 TDI (DTRD) 85kW', 1968, 'diesel', 'turbo', NULL),
  ('DTTA', '2.0 TDI (DTTA) 110kW', 1968, 'diesel', 'turbo', NULL),
  ('DTTC', '2.0 TDI (DTTC) 110kW', 1968, 'diesel', 'turbo', NULL),
  ('DTUA', '2.0 TDI, -GTD (DTUA) 147kW', 1968, 'diesel', 'turbo', NULL),
  ('DSRB', '2.0 TDi BlueMotion (DSRB) 110kW', 1968, 'diesel', 'turbo', NULL),
  ('DSUD', '2.0 TDi BlueMotion (DSUD) 85kW', 1968, 'diesel', 'turbo', NULL),
  ('DNNA', '2.0 TSI (DNNA) 140kW', 1984, 'petrol', 'turbo', NULL),
  ('DGEA', 'GTE (1.4 eHybrid) (DGEA) 180kW', 1395, 'petrol', 'NA', NULL),
  ('DLBA', 'GTI (2.0 TSI) (DLBA) 180kW', 1984, 'petrol', 'turbo', NULL),
  ('DNPA', 'GTI (2.0 TSI) (DNPA) 180kW', 1984, 'petrol', 'turbo', NULL),
  ('DRNA', 'GTI (2.0 TSI) (DRNA) 180kW', 1984, 'petrol', 'turbo', NULL),
  ('DNFC', 'GTI Clubsport (2.0 TSI) (DNFC) 221kW', 1984, 'petrol', 'turbo', NULL),
  ('DNFF', 'R (2.0 TSI) (DNFF) 245kW', 1984, 'petrol', 'turbo', NULL),
  ('DNFG', 'R (2.0 TSI) (DNFG) 235kW', 1984, 'petrol', 'turbo', NULL),
  ('DSFE', 'R (2.0 TSI) (DSFE) 235kW', 1984, 'petrol', 'turbo', NULL),
  ('DSFF', 'R (2.0 TSI) (DSFF) 235kW', 1984, 'petrol', 'turbo', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'engine_oil', (SELECT id FROM engines WHERE code = 'DLAB'), 4, 4.23, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619028745; 1.0 TSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DLAB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'coolant', (SELECT id FROM engines WHERE code = 'DLAB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619028745; 1.0 TSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DLAB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'engine_oil', (SELECT id FROM engines WHERE code = 'DLAA'), 4, 4.23, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619028746; 1.0 eTSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DLAA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'coolant', (SELECT id FROM engines WHERE code = 'DLAA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619028746; 1.0 eTSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DLAA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'engine_oil', (SELECT id FROM engines WHERE code = 'DJKA'), NULL, NULL, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619035921; 1.4 TSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DJKA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'coolant', (SELECT id FROM engines WHERE code = 'DJKA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035921; 1.4 TSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DJKA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'engine_oil', (SELECT id FROM engines WHERE code = 'DHFA'), 4.3, 4.54, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619035261; 1.5 TGI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DHFA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'coolant', (SELECT id FROM engines WHERE code = 'DHFA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035261; 1.5 TGI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DHFA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'engine_oil', (SELECT id FROM engines WHERE code = 'DPCA'), 4.3, 4.54, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619028741; 1.5 TSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DPCA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'coolant', (SELECT id FROM engines WHERE code = 'DPCA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619028741; 1.5 TSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DPCA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'engine_oil', (SELECT id FROM engines WHERE code = 'DPBA'), 4.3, 4.54, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619028742; 1.5 TSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DPBA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'coolant', (SELECT id FROM engines WHERE code = 'DPBA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619028742; 1.5 TSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DPBA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'engine_oil', (SELECT id FROM engines WHERE code = 'DFYA'), 4.3, 4.54, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619028743; 1.5 eTSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DFYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'coolant', (SELECT id FROM engines WHERE code = 'DFYA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619028743; 1.5 eTSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DFYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'engine_oil', (SELECT id FROM engines WHERE code = 'CWVA'), 4, 4.23, '5W-40', 'VW 502 00', 'HaynesPro typeId t_619035340; 1.6 MPI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CWVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'coolant', (SELECT id FROM engines WHERE code = 'CWVA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035340; 1.6 MPI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CWVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'engine_oil', (SELECT id FROM engines WHERE code = 'DWYA'), 4, 4.23, '5W-40', 'VW 502 00', 'HaynesPro typeId t_619035933; 1.6 MPI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DWYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'coolant', (SELECT id FROM engines WHERE code = 'DWYA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035933; 1.6 MPI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DWYA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'engine_oil', (SELECT id FROM engines WHERE code = 'DTSA'), 5.1, 5.39, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619035930; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DTSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'coolant', (SELECT id FROM engines WHERE code = 'DTSA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035930; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DTSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'engine_oil', (SELECT id FROM engines WHERE code = 'DTSB'), 5.1, 5.39, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619035264; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DTSB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'coolant', (SELECT id FROM engines WHERE code = 'DTSB'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035264; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DTSB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'engine_oil', (SELECT id FROM engines WHERE code = 'DTRB'), 5.5, 5.81, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619035929; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DTRB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'coolant', (SELECT id FROM engines WHERE code = 'DTRB'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035929; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DTRB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'engine_oil', (SELECT id FROM engines WHERE code = 'DTRD'), NULL, NULL, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619035262; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DTRD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'coolant', (SELECT id FROM engines WHERE code = 'DTRD'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035262; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DTRD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'engine_oil', (SELECT id FROM engines WHERE code = 'DTTA'), 5.1, 5.39, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619035931; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DTTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'coolant', (SELECT id FROM engines WHERE code = 'DTTA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035931; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DTTA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'engine_oil', (SELECT id FROM engines WHERE code = 'DTTC'), 5.1, 5.39, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619035932; 2.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DTTC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'coolant', (SELECT id FROM engines WHERE code = 'DTTC'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035932; 2.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DTTC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'engine_oil', (SELECT id FROM engines WHERE code = 'DTUA'), 5.5, 5.81, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619035826; 2.0 TDI, -GTD; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DTUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'coolant', (SELECT id FROM engines WHERE code = 'DTUA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035826; 2.0 TDI, -GTD'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DTUA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'engine_oil', (SELECT id FROM engines WHERE code = 'DSRB'), 5.5, 5.81, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619028739; 2.0 TDi BlueMotion; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DSRB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'coolant', (SELECT id FROM engines WHERE code = 'DSRB'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619028739; 2.0 TDi BlueMotion'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DSRB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'engine_oil', (SELECT id FROM engines WHERE code = 'DSUD'), 5.5, 5.81, '0W-20', 'VW 509 00', 'HaynesPro typeId t_619028740; 2.0 TDi BlueMotion; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DSUD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'coolant', (SELECT id FROM engines WHERE code = 'DSUD'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619028740; 2.0 TDi BlueMotion'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DSUD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'engine_oil', (SELECT id FROM engines WHERE code = 'DNNA'), 5.7, 6.02, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619035925; 2.0 TSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DNNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'coolant', (SELECT id FROM engines WHERE code = 'DNNA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035925; 2.0 TSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DNNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'engine_oil', (SELECT id FROM engines WHERE code = 'DGEA'), 4, 4.23, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619028744; GTE (1.4 eHybrid); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DGEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'coolant', (SELECT id FROM engines WHERE code = 'DGEA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619028744; GTE (1.4 eHybrid)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DGEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'engine_oil', (SELECT id FROM engines WHERE code = 'DLBA'), 5.7, 6.02, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619035922; GTI (2.0 TSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DLBA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'coolant', (SELECT id FROM engines WHERE code = 'DLBA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035922; GTI (2.0 TSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DLBA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'engine_oil', (SELECT id FROM engines WHERE code = 'DNPA'), 5.7, 6.02, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619035260; GTI (2.0 TSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DNPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'coolant', (SELECT id FROM engines WHERE code = 'DNPA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035260; GTI (2.0 TSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DNPA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'engine_oil', (SELECT id FROM engines WHERE code = 'DRNA'), 5.7, 6.02, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619035926; GTI (2.0 TSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DRNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'coolant', (SELECT id FROM engines WHERE code = 'DRNA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035926; GTI (2.0 TSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DRNA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'engine_oil', (SELECT id FROM engines WHERE code = 'DNFC'), 5.7, 6.02, '0W-30', 'VW 504 00', 'HaynesPro typeId t_619035923; GTI Clubsport (2.0 TSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DNFC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'coolant', (SELECT id FROM engines WHERE code = 'DNFC'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035923; GTI Clubsport (2.0 TSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DNFC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'engine_oil', (SELECT id FROM engines WHERE code = 'DNFF'), 5.7, 6.02, '0W-30', 'VW 504 00', 'HaynesPro typeId t_619108537; R (2.0 TSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DNFF'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'coolant', (SELECT id FROM engines WHERE code = 'DNFF'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619108537; R (2.0 TSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DNFF'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'engine_oil', (SELECT id FROM engines WHERE code = 'DNFG'), 5.7, 6.02, '0W-30', 'VW 504 00', 'HaynesPro typeId t_619035924; R (2.0 TSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DNFG'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'coolant', (SELECT id FROM engines WHERE code = 'DNFG'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035924; R (2.0 TSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DNFG'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'engine_oil', (SELECT id FROM engines WHERE code = 'DSFE'), 5.7, 6.02, '0W-30', 'VW 504 00', 'HaynesPro typeId t_619035927; R (2.0 TSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DSFE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'coolant', (SELECT id FROM engines WHERE code = 'DSFE'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035927; R (2.0 TSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DSFE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'engine_oil', (SELECT id FROM engines WHERE code = 'DSFF'), 5.7, 6.02, '0W-30', 'VW 504 00', 'HaynesPro typeId t_619035928; R (2.0 TSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DSFF'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 18, 'coolant', (SELECT id FROM engines WHERE code = 'DSFF'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035928; R (2.0 TSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 18 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DSFF'));

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (18)
  AND e.code IN ('DLAB', 'DLAA', 'DJKA', 'DHFA', 'DPCA', 'DPBA', 'DFYA', 'CWVA', 'DWYA', 'DTSA', 'DTSB', 'DTRB', 'DTRD', 'DTTA', 'DTTC', 'DTUA', 'DSRB', 'DSUD', 'DNNA', 'DGEA', 'DLBA', 'DNPA', 'DRNA', 'DNFC', 'DNFF', 'DNFG', 'DSFE', 'DSFF')
  AND fs.fluid_type IN ('engine_oil', 'coolant');

SELECT g.slug, COUNT(*) AS fluid_rows
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (18) AND fs.fluid_type IN ('engine_oil','coolant')
GROUP BY g.slug ORDER BY g.slug;