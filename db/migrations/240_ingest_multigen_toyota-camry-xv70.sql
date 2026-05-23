-- mig 240 — multi-gen HaynesPro ingest: Toyota Camry (XV70)
-- crawl: haynespro-crawl-toyota-camry-xv70-2026-05-23.json
-- modelId: d_319001688
-- 5 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Toyota Camry (XV70)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319001688', NOW(), 'Multi-gen ingest, 5 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319001688' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('6AR-FSE', '2.0 (6AR-FSE) 110kW', 1998, 'petrol', 'NA', NULL),
  ('A25A-FKS', '2.5 (A25A-FKS) 152kW', 2487, 'hybrid', 'NA', NULL),
  ('2AR-FE', '2.5 (2AR-FE) 130kW', 2494, 'petrol', 'NA', NULL),
  ('A25A-FXS', '2.5 Hybrid (A25A-FXS) 160kW', 2487, 'hybrid', 'NA', NULL),
  ('2GR-FKS', '3.5 (2GR-FKS) 183kW', 3456, 'petrol', 'NA', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 2, 'engine_oil', (SELECT id FROM engines WHERE code = '6AR-FSE'), 4.6, 4.86, '0W-20', 'API SN', 'HaynesPro typeId t_619029738; 2.0; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 2 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '6AR-FSE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 2, 'coolant', (SELECT id FROM engines WHERE code = '6AR-FSE'), 7.2, 7.61, NULL, 'Toyota Super Longlife Coolant', 'HaynesPro typeId t_619029738; 2.0'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 2 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '6AR-FSE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 2, 'transmission_at', (SELECT id FROM engines WHERE code = '6AR-FSE'), NULL, NULL, NULL, 'Toyota ATF WS', 'HaynesPro typeId t_619029738; 2.0; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 2 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '6AR-FSE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 2, 'engine_oil', (SELECT id FROM engines WHERE code = 'A25A-FKS'), 4.5, 4.76, '0W-16', 'API SN', 'HaynesPro typeId t_619020126; 2.5; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 2 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'A25A-FKS'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 2, 'coolant', (SELECT id FROM engines WHERE code = 'A25A-FKS'), 6.9, 7.29, NULL, 'Toyota Super Longlife Coolant', 'HaynesPro typeId t_619020126; 2.5'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 2 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'A25A-FKS'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 2, 'transmission_at', (SELECT id FROM engines WHERE code = 'A25A-FKS'), NULL, NULL, NULL, 'Toyota ATF WS', 'HaynesPro typeId t_619020126; 2.5; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 2 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'A25A-FKS'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 2, 'engine_oil', (SELECT id FROM engines WHERE code = '2AR-FE'), 4.4, 4.65, '0W-20', 'API SN', 'HaynesPro typeId t_619011361; 2.5; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 2 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '2AR-FE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 2, 'coolant', (SELECT id FROM engines WHERE code = '2AR-FE'), 6.6, 6.97, NULL, 'Toyota Super Longlife Coolant', 'HaynesPro typeId t_619011361; 2.5'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 2 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '2AR-FE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 2, 'transmission_at', (SELECT id FROM engines WHERE code = '2AR-FE'), NULL, NULL, NULL, 'Toyota ATF WS', 'HaynesPro typeId t_619011361; 2.5; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 2 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '2AR-FE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 2, 'engine_oil', (SELECT id FROM engines WHERE code = 'A25A-FXS'), 4.5, 4.76, '0W-16', 'API SN', 'HaynesPro typeId t_319007789; 2.5 Hybrid; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 2 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'A25A-FXS'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 2, 'coolant', (SELECT id FROM engines WHERE code = 'A25A-FXS'), NULL, NULL, NULL, 'Toyota Super Longlife Coolant', 'HaynesPro typeId t_319007789; 2.5 Hybrid'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 2 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'A25A-FXS'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 2, 'transmission_cvt', (SELECT id FROM engines WHERE code = 'A25A-FXS'), 3.9, 4.12, NULL, 'Toyota ATF WS', 'HaynesPro typeId t_319007789; 2.5 Hybrid; CVT'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 2 AND fluid_type = 'transmission_cvt' AND engine_id = (SELECT id FROM engines WHERE code = 'A25A-FXS'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 2, 'engine_oil', (SELECT id FROM engines WHERE code = '2GR-FKS'), NULL, NULL, '0W-20', 'API SP', 'HaynesPro typeId t_619029739; 3.5; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 2 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '2GR-FKS'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 2, 'coolant', (SELECT id FROM engines WHERE code = '2GR-FKS'), NULL, NULL, NULL, 'Toyota Super Longlife Coolant', 'HaynesPro typeId t_619029739; 3.5'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 2 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '2GR-FKS'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 2, 'transmission_at', (SELECT id FROM engines WHERE code = '2GR-FKS'), NULL, NULL, NULL, 'Toyota ATF WS', 'HaynesPro typeId t_619029739; 3.5; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 2 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = '2GR-FKS'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 2, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4', 'HaynesPro chassis d_319001688;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 2 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (2)
  AND e.code IN ('6AR-FSE', 'A25A-FKS', '2AR-FE', 'A25A-FXS', '2GR-FKS')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (2)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (2) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;