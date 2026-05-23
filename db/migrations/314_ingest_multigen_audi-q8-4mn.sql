-- mig 314 — multi-gen HaynesPro ingest: Audi Q8 (4MN)
-- crawl: haynespro-crawl-audi-q8-4mn-2026-05-23.json
-- modelId: d_319002009
-- 12 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Audi Q8 (4MN)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319002009', NOW(), 'Multi-gen ingest, 12 engines across 2 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319002009' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('CVMD', '45 TDI (CVMD) 183kW', 2967, 'diesel', 'turbo', NULL),
  ('DHXC', '45 TDI (DHXC) 170kW', 2967, 'diesel', 'turbo', NULL),
  ('DPXB', '45 TDI (DPXB) 170kW', 2967, 'diesel', 'turbo', NULL),
  ('DHXA', '50 TDI (DHXA) 210kW', 2967, 'diesel', 'turbo', NULL),
  ('DPXA', '50 TDI (DPXA) 210kW', 2967, 'diesel', 'turbo', NULL),
  ('DCBD', '55 TFSI (DCBD) 250kW', 2995, 'petrol', 'turbo', NULL),
  ('DCBE', '55 TFSI e (DCBE) 280kW', 2995, 'hybrid', 'turbo', NULL),
  ('CZAA', '60 TDI (CZAA) 310kW', 3956, 'diesel', 'turbo', NULL),
  ('DHUB', 'RSQ8 (4.0 TFSI) (DHUB) 441kW', 3996, 'petrol', 'turbo', NULL),
  ('DHVA', 'SQ8 (4.0 TDI) (DHVA) 320kW', 3956, 'diesel', 'turbo', NULL),
  ('DCUE', 'SQ8 (4.0 TFSI) (DCUE) 373kW', 3996, 'petrol', 'turbo', NULL),
  ('DWRB', 'SQ8 (4.0 TFSI) (DWRB) 373kW', 3996, 'petrol', 'turbo', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 290, 'engine_oil', (SELECT id FROM engines WHERE code = 'CVMD'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619007999; 45 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 290 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CVMD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 290, 'coolant', (SELECT id FROM engines WHERE code = 'CVMD'), 15, 15.85, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619007999; 45 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 290 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CVMD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 290, 'transmission_at', (SELECT id FROM engines WHERE code = 'CVMD'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619007999; 45 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 290 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CVMD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 290, 'engine_oil', (SELECT id FROM engines WHERE code = 'DHXC'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619008005; 45 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 290 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DHXC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 290, 'coolant', (SELECT id FROM engines WHERE code = 'DHXC'), 13, 13.74, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619008005; 45 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 290 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DHXC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 290, 'transmission_at', (SELECT id FROM engines WHERE code = 'DHXC'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619008005; 45 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 290 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DHXC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 290, 'engine_oil', (SELECT id FROM engines WHERE code = 'DPXB'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619035005; 45 TDI; drain 35 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 290 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DPXB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 290, 'coolant', (SELECT id FROM engines WHERE code = 'DPXB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035005; 45 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 290 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DPXB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 290, 'transmission_at', (SELECT id FROM engines WHERE code = 'DPXB'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619035005; 45 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 290 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DPXB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 290, 'engine_oil', (SELECT id FROM engines WHERE code = 'DHXA'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619008003; 50 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 290 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DHXA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 290, 'coolant', (SELECT id FROM engines WHERE code = 'DHXA'), 13, 13.74, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619008003; 50 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 290 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DHXA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 290, 'transmission_at', (SELECT id FROM engines WHERE code = 'DHXA'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619008003; 50 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 290 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DHXA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 290, 'engine_oil', (SELECT id FROM engines WHERE code = 'DPXA'), 6.1, 6.45, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619035004; 50 TDI; drain 35 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 290 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DPXA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 290, 'coolant', (SELECT id FROM engines WHERE code = 'DPXA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035004; 50 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 290 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DPXA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 290, 'transmission_at', (SELECT id FROM engines WHERE code = 'DPXA'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619035004; 50 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 290 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DPXA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 290, 'engine_oil', (SELECT id FROM engines WHERE code = 'DCBD'), 7.6, 8.03, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619016911; 55 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 290 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DCBD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 290, 'coolant', (SELECT id FROM engines WHERE code = 'DCBD'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619016911; 55 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 290 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DCBD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 290, 'transmission_at', (SELECT id FROM engines WHERE code = 'DCBD'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619016911; 55 TFSI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 290 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DCBD'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 290, 'engine_oil', (SELECT id FROM engines WHERE code = 'DCBE'), 7.2, 7.61, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619035007; 55 TFSI e; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 290 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DCBE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 290, 'coolant', (SELECT id FROM engines WHERE code = 'DCBE'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035007; 55 TFSI e'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 290 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DCBE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 290, 'transmission_at', (SELECT id FROM engines WHERE code = 'DCBE'), 8.6, 9.09, NULL, 'SAE 75W-90', 'HaynesPro typeId t_619035007; 55 TFSI e; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 290 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DCBE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 290, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZAA'), 8.8, 9.3, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619008000; 60 TDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 290 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZAA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 290, 'coolant', (SELECT id FROM engines WHERE code = 'CZAA'), 15, 15.85, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619008000; 60 TDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 290 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZAA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 290, 'transmission_at', (SELECT id FROM engines WHERE code = 'CZAA'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_619008000; 60 TDI; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 290 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'CZAA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 291, 'engine_oil', (SELECT id FROM engines WHERE code = 'DHUB'), 9.5, 10.04, '0W-40', 'VW 511 00', 'HaynesPro typeId t_619028764; RSQ8 (4.0 TFSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 291 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DHUB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 291, 'coolant', (SELECT id FROM engines WHERE code = 'DHUB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619028764; RSQ8 (4.0 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 291 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DHUB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 291, 'transmission_at', (SELECT id FROM engines WHERE code = 'DHUB'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_619028764; RSQ8 (4.0 TFSI); Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 291 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DHUB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 290, 'engine_oil', (SELECT id FROM engines WHERE code = 'DHVA'), 8.8, 9.3, '0W-30', 'VW 507 00', 'HaynesPro typeId t_619008002; SQ8 (4.0 TDI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 290 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DHVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 290, 'coolant', (SELECT id FROM engines WHERE code = 'DHVA'), 15, 15.85, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619008002; SQ8 (4.0 TDI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 290 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DHVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 290, 'transmission_at', (SELECT id FROM engines WHERE code = 'DHVA'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_619008002; SQ8 (4.0 TDI); Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 290 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DHVA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 290, 'engine_oil', (SELECT id FROM engines WHERE code = 'DCUE'), 9.5, 10.04, '0W-40', 'VW 511 00', 'HaynesPro typeId t_619032894; SQ8 (4.0 TFSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 290 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DCUE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 290, 'coolant', (SELECT id FROM engines WHERE code = 'DCUE'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619032894; SQ8 (4.0 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 290 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DCUE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 290, 'transmission_at', (SELECT id FROM engines WHERE code = 'DCUE'), 8.6, 9.09, NULL, 'VW G 060 162 A2', 'HaynesPro typeId t_619032894; SQ8 (4.0 TFSI); Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 290 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'DCUE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 290, 'engine_oil', (SELECT id FROM engines WHERE code = 'DWRB'), 9.5, 10.04, '0W-40', 'VW 511 00', 'HaynesPro typeId t_619112172; SQ8 (4.0 TFSI); drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 290 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DWRB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 290, 'coolant', (SELECT id FROM engines WHERE code = 'DWRB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619112172; SQ8 (4.0 TFSI)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 290 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DWRB'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 290, 'brake_fluid', NULL, 1, 1.06, NULL, 'VW 501 14', 'HaynesPro chassis d_319002009; Alt: DOT 4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 290 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 291, 'brake_fluid', NULL, 1, 1.06, NULL, 'VW 501 14', 'HaynesPro chassis d_319002009; Alt: DOT 4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 291 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (290, 291)
  AND e.code IN ('CVMD', 'DHXC', 'DPXB', 'DHXA', 'DPXA', 'DCBD', 'DCBE', 'CZAA', 'DHUB', 'DHVA', 'DCUE', 'DWRB')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (290, 291)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (290, 291) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;