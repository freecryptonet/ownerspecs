-- mig 234 — multi-gen HaynesPro ingest: Honda Civic X (FK, FC)
-- crawl: haynespro-crawl-honda-civic-x-fk-2026-05-23.json
-- modelId: d_319001478
-- 10 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Honda Civic X (FK, FC)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319001478', NOW(), 'Multi-gen ingest, 10 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319001478' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('P10A4', '1.0 12V (P10A4) 93kW', 988, 'petrol', 'NA', NULL),
  ('P10A2', '1.0 12V VTEC (P10A2) 95kW', 988, 'petrol', 'NA', NULL),
  ('L15B7', '1.5 16V VTEC Turbo (L15B7) 131kW', 1498, 'petrol', 'turbo', NULL),
  ('L15BA', '1.5 16V VTEC Turbo (L15BA) 134kW', 1498, 'petrol', 'turbo', NULL),
  ('L15BB', '1.5 16V VTEC Turbo (L15BB) 134kW', 1498, 'petrol', 'turbo', NULL),
  ('R16B2', '1.6 16V (R16B2) 92kW', 1597, 'petrol', 'NA', NULL),
  ('N16A1', '1.6 16V i-CDTi (N16A1) 88kW', 1597, 'petrol', 'NA', NULL),
  ('R18Z1', '1.8 16V i-VTEC (R18Z1) 104kW', 1799, 'petrol', 'NA', NULL),
  ('K20C2', '2.0 16V i-VTEC (K20C2) 116kW', 1996, 'petrol', 'NA', NULL),
  ('K20C1', 'Type R (2.0 16V) (K20C1) 235kW', 1996, 'petrol', 'NA', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 1, 'engine_oil', (SELECT id FROM engines WHERE code = 'P10A4'), 3.8, 4.02, '0W-20', 'Honda Engine Oil Type 2.0', 'HaynesPro typeId t_619029127; 1.0 12V; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 1 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'P10A4'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 1, 'coolant', (SELECT id FROM engines WHERE code = 'P10A4'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619029127; 1.0 12V'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 1 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'P10A4'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 1, 'transmission_mt', (SELECT id FROM engines WHERE code = 'P10A4'), 1.9, 2.01, NULL, 'SAE 75W-80', 'HaynesPro typeId t_619029127; 1.0 12V; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 1 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'P10A4'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 1, 'engine_oil', (SELECT id FROM engines WHERE code = 'P10A2'), 3.8, 4.02, '0W-20', 'Honda Engine Oil Type 2.0', 'HaynesPro typeId t_319005570; 1.0 12V VTEC; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 1 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'P10A2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 1, 'coolant', (SELECT id FROM engines WHERE code = 'P10A2'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319005570; 1.0 12V VTEC'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 1 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'P10A2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 1, 'engine_oil', (SELECT id FROM engines WHERE code = 'L15B7'), 3.5, 3.7, '0W-20', 'Honda HFE-20', 'HaynesPro typeId t_319005573; 1.5 16V VTEC Turbo; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 1 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'L15B7'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 1, 'coolant', (SELECT id FROM engines WHERE code = 'L15B7'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319005573; 1.5 16V VTEC Turbo'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 1 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'L15B7'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 1, 'transmission_mt', (SELECT id FROM engines WHERE code = 'L15B7'), 1.9, 2.01, NULL, 'SAE 75W-80', 'HaynesPro typeId t_319005573; 1.5 16V VTEC Turbo; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 1 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'L15B7'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 1, 'engine_oil', (SELECT id FROM engines WHERE code = 'L15BA'), 3.5, 3.7, '0W-20', 'Honda Engine Oil Type 2.0', 'HaynesPro typeId t_319005569; 1.5 16V VTEC Turbo; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 1 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'L15BA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 1, 'coolant', (SELECT id FROM engines WHERE code = 'L15BA'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319005569; 1.5 16V VTEC Turbo'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 1 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'L15BA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 1, 'transmission_mt', (SELECT id FROM engines WHERE code = 'L15BA'), 1.9, 2.01, NULL, 'SAE 75W-80', 'HaynesPro typeId t_319005569; 1.5 16V VTEC Turbo; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 1 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'L15BA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 1, 'engine_oil', (SELECT id FROM engines WHERE code = 'L15BB'), 3.5, 3.7, '0W-20', 'Honda HFE-20', 'HaynesPro typeId t_319005572; 1.5 16V VTEC Turbo; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 1 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'L15BB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 1, 'coolant', (SELECT id FROM engines WHERE code = 'L15BB'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319005572; 1.5 16V VTEC Turbo'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 1 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'L15BB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 1, 'transmission_mt', (SELECT id FROM engines WHERE code = 'L15BB'), 1.9, 2.01, NULL, 'SAE 75W-80', 'HaynesPro typeId t_319005572; 1.5 16V VTEC Turbo; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 1 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'L15BB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 1, 'engine_oil', (SELECT id FROM engines WHERE code = 'R16B2'), 3.7, 3.91, '0W-20', 'Honda HFE-20', 'HaynesPro typeId t_619029123; 1.6 16V; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 1 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'R16B2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 1, 'coolant', (SELECT id FROM engines WHERE code = 'R16B2'), NULL, NULL, NULL, '(Note: Do not dilute the coolant!)', 'HaynesPro typeId t_619029123; 1.6 16V'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 1 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'R16B2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 1, 'engine_oil', (SELECT id FROM engines WHERE code = 'N16A1'), 4.5, 4.76, '0W-30', 'Honda Diesel Oil #1.0', 'HaynesPro typeId t_319007847; 1.6 16V i-CDTi; drain 45 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 1 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N16A1'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 1, 'coolant', (SELECT id FROM engines WHERE code = 'N16A1'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319007847; 1.6 16V i-CDTi'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 1 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N16A1'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 1, 'transmission_mt', (SELECT id FROM engines WHERE code = 'N16A1'), 1.9, 2.01, NULL, 'SAE 75W-80', 'HaynesPro typeId t_319007847; 1.6 16V i-CDTi; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 1 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'N16A1'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 1, 'engine_oil', (SELECT id FROM engines WHERE code = 'R18Z1'), 3.7, 3.91, '0W-20', 'Honda Engine Oil Type 2.0', 'HaynesPro typeId t_619022465; 1.8 16V i-VTEC; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 1 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'R18Z1'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 1, 'coolant', (SELECT id FROM engines WHERE code = 'R18Z1'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619022465; 1.8 16V i-VTEC'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 1 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'R18Z1'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 1, 'engine_oil', (SELECT id FROM engines WHERE code = 'K20C2'), 4.2, 4.44, '0W-20', 'Honda Engine Oil Type 2.0', 'HaynesPro typeId t_619015430; 2.0 16V i-VTEC; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 1 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'K20C2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 1, 'coolant', (SELECT id FROM engines WHERE code = 'K20C2'), 5.3, 5.6, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619015430; 2.0 16V i-VTEC'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 1 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'K20C2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 1, 'transmission_mt', (SELECT id FROM engines WHERE code = 'K20C2'), 1.9, 2.01, NULL, 'SAE 75W-80', 'HaynesPro typeId t_619015430; 2.0 16V i-VTEC; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 1 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'K20C2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 1, 'engine_oil', (SELECT id FROM engines WHERE code = 'K20C1'), 5.4, 5.71, '0W-20', 'Honda Engine Oil Type 2.0', 'HaynesPro typeId t_319007334; Type R (2.0 16V); drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 1 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'K20C1'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 1, 'coolant', (SELECT id FROM engines WHERE code = 'K20C1'), 4.7, 4.97, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319007334; Type R (2.0 16V)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 1 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'K20C1'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 1, 'transmission_mt', (SELECT id FROM engines WHERE code = 'K20C1'), 2.2, 2.32, NULL, 'SAE 75W-80', 'HaynesPro typeId t_319007334; Type R (2.0 16V); Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 1 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'K20C1'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 1, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4', 'HaynesPro chassis d_319001478;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 1 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (1)
  AND e.code IN ('P10A4', 'P10A2', 'L15B7', 'L15BA', 'L15BB', 'R16B2', 'N16A1', 'R18Z1', 'K20C2', 'K20C1')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (1)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (1) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;