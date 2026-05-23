-- mig 221 — multi-gen HaynesPro ingest: Audi Q7 (4MB, 4MG)
-- crawl: haynespro-crawl-q7-4mb-2026-05-23.json
-- modelId: d_312000002
-- 18 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Audi Q7 (4MB, 4MG)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_312000002', NOW(), 'Multi-gen ingest, 18 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_312000002' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('CYMC', '2.0 TFSI (CYMC) 185kW', 1984, 'petrol', 'turbo', NULL),
  ('CVJA', '2.0 TFSI e-tron (CVJA) 185kW', 1984, 'hybrid', 'turbo', NULL),
  ('CYRB', '2.0 TFSI/45 TFSI (CYRB) 185kW', 1984, 'petrol', 'turbo', NULL),
  ('CUEA', '3.0 TDI (CUEA) 190kW', 2967, 'diesel', 'turbo', NULL),
  ('CRTE', '3.0 TDI (CRTE) 160kW', 2967, 'diesel', 'turbo', NULL),
  ('CZZA', '3.0 TDI (CZZA) 160kW', 2967, 'diesel', 'turbo', NULL),
  ('CZZB', '3.0 TDI (CZZB) 155kW', 2967, 'diesel', 'turbo', NULL),
  ('CVZA', '3.0 TDI e-tron (CVZA) 275kW', 2967, 'hybrid', 'turbo', NULL),
  ('CVMD', '3.0 TDI/45 TDI (CVMD) 183kW', 2967, 'diesel', 'turbo', NULL),
  ('CRTC', '3.0 TDI/50 TDI (CRTC) 200kW', 2967, 'diesel', 'turbo', NULL),
  ('CREC', '3.0 TFSI (CREC) 245kW', 2995, 'petrol', 'turbo', NULL),
  ('DHXC', '45 TDI (DHXC) 170kW', 2967, 'diesel', 'turbo', NULL),
  ('DHXA', '50 TDI (DHXA) 210kW', 2967, 'diesel', 'turbo', NULL),
  ('DCBD', '55 TFSI (DCBD) 250kW', 2995, 'petrol', 'turbo', NULL),
  ('DCBE', '55 TFSI e (DCBE) 280kW', 2995, 'hybrid', 'turbo', NULL),
  ('CZAC', 'SQ7 (4.0 TDI) (CZAC) 320kW', 3956, 'diesel', 'turbo', NULL),
  ('CZAA', 'SQ7 (4.0 TDI) (CZAA) 310kW', 3956, 'diesel', 'turbo', NULL),
  ('DHVA', 'SQ7 (4.0 V8 TDI) (DHVA) 320kW', 3956, 'diesel', 'turbo', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 90, 'engine_oil', (SELECT id FROM engines WHERE code = 'CYMC'), 5.2, 5.49, '5W-40', 'VW 502 00', 'HaynesPro typeId t_619017270; 2.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 90 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CYMC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 90, 'coolant', (SELECT id FROM engines WHERE code = 'CYMC'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619017270; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 90 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CYMC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 90, 'engine_oil', (SELECT id FROM engines WHERE code = 'CVJA'), 5.2, 5.49, '5W-40', 'VW 502 00', 'HaynesPro typeId t_619017269; 2.0 TFSI e-tron; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 90 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CVJA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 90, 'coolant', (SELECT id FROM engines WHERE code = 'CVJA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619017269; 2.0 TFSI e-tron'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 90 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CVJA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 90, 'engine_oil', (SELECT id FROM engines WHERE code = 'CYRB'), 5.2, 5.49, '0W-30', 'VW 502 00', 'HaynesPro typeId t_317000406; 2.0 TFSI/45 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 90 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CYRB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 90, 'coolant', (SELECT id FROM engines WHERE code = 'CYRB'), NULL, NULL, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_317000406; 2.0 TFSI/45 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 90 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CYRB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 90, 'engine_oil', (SELECT id FROM engines WHERE code = 'CUEA'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_317000402; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 90 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CUEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 90, 'coolant', (SELECT id FROM engines WHERE code = 'CUEA'), 13, 13.74, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_317000402; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 90 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CUEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 90, 'engine_oil', (SELECT id FROM engines WHERE code = 'CRTE'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319000290; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 90 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CRTE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 90, 'coolant', (SELECT id FROM engines WHERE code = 'CRTE'), 13, 13.74, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319000290; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 90 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CRTE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 90, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZZA'), 6.1, 6.45, '0W-20', 'VW 509 00', 'HaynesPro typeId t_317000405; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 90 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 90, 'coolant', (SELECT id FROM engines WHERE code = 'CZZA'), 13, 13.74, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_317000405; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 90 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 90, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZZB'), 6.1, 6.45, '0W-20', 'VW 509 00', 'HaynesPro typeId t_318011840; 3.0 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 90 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZZB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 90, 'coolant', (SELECT id FROM engines WHERE code = 'CZZB'), 13, 13.74, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_318011840; 3.0 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 90 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZZB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 90, 'engine_oil', (SELECT id FROM engines WHERE code = 'CVZA'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_317000404; 3.0 TDI e-tron; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 90 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CVZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 90, 'coolant', (SELECT id FROM engines WHERE code = 'CVZA'), 15, 15.85, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_317000404; 3.0 TDI e-tron'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 90 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CVZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 90, 'engine_oil', (SELECT id FROM engines WHERE code = 'CVMD'), 6.1, 6.45, '5W-30', 'VW 507 00', 'HaynesPro typeId t_317000403; 3.0 TDI/45 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 90 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CVMD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 90, 'coolant', (SELECT id FROM engines WHERE code = 'CVMD'), 13, 13.74, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_317000403; 3.0 TDI/45 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 90 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CVMD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 90, 'engine_oil', (SELECT id FROM engines WHERE code = 'CRTC'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_317000185; 3.0 TDI/50 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 90 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CRTC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 90, 'coolant', (SELECT id FROM engines WHERE code = 'CRTC'), 13, 13.74, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_317000185; 3.0 TDI/50 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 90 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CRTC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 90, 'engine_oil', (SELECT id FROM engines WHERE code = 'CREC'), 6.8, 7.19, '5W-40', 'VW 502 00', 'HaynesPro typeId t_317000184; 3.0 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 90 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CREC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 90, 'coolant', (SELECT id FROM engines WHERE code = 'CREC'), NULL, NULL, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_317000184; 3.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 90 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CREC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 90, 'engine_oil', (SELECT id FROM engines WHERE code = 'DHXC'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619013176; 45 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 90 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DHXC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 90, 'coolant', (SELECT id FROM engines WHERE code = 'DHXC'), 15, 15.85, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619013176; 45 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 90 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DHXC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 90, 'engine_oil', (SELECT id FROM engines WHERE code = 'DHXA'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619013177; 50 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 90 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DHXA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 90, 'coolant', (SELECT id FROM engines WHERE code = 'DHXA'), 15, 15.85, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619013177; 50 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 90 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DHXA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 90, 'engine_oil', (SELECT id FROM engines WHERE code = 'DCBD'), 7.6, 8.03, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619017271; 55 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 90 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DCBD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 90, 'coolant', (SELECT id FROM engines WHERE code = 'DCBD'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619017271; 55 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 90 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DCBD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 90, 'engine_oil', (SELECT id FROM engines WHERE code = 'DCBE'), 7.2, 7.61, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619028759; 55 TFSI e; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 90 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DCBE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 90, 'coolant', (SELECT id FROM engines WHERE code = 'DCBE'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619028759; 55 TFSI e'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 90 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DCBE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 90, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZAC'), 9.1, 9.62, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319001150; SQ7 (4.0 TDI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 90 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZAC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 90, 'coolant', (SELECT id FROM engines WHERE code = 'CZAC'), 15, 15.85, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319001150; SQ7 (4.0 TDI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 90 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZAC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 90, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZAA'), 9.1, 9.62, '0W-30', 'VW 507 00', 'HaynesPro typeId t_319004623; SQ7 (4.0 TDI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 90 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZAA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 90, 'coolant', (SELECT id FROM engines WHERE code = 'CZAA'), 15, 15.85, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_319004623; SQ7 (4.0 TDI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 90 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZAA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 90, 'engine_oil', (SELECT id FROM engines WHERE code = 'DHVA'), 8.8, 9.3, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619017272; SQ7 (4.0 V8 TDI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 90 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DHVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 90, 'coolant', (SELECT id FROM engines WHERE code = 'DHVA'), 15, 15.85, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619017272; SQ7 (4.0 V8 TDI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 90 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DHVA'));

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (90)
  AND e.code IN ('CYMC', 'CVJA', 'CYRB', 'CUEA', 'CRTE', 'CZZA', 'CZZB', 'CVZA', 'CVMD', 'CRTC', 'CREC', 'DHXC', 'DHXA', 'DCBD', 'DCBE', 'CZAC', 'CZAA', 'DHVA')
  AND fs.fluid_type IN ('engine_oil', 'coolant');

SELECT g.slug, COUNT(*) AS fluid_rows
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (90) AND fs.fluid_type IN ('engine_oil','coolant')
GROUP BY g.slug ORDER BY g.slug;