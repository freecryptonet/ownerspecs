-- mig 272 — multi-gen HaynesPro ingest: BMW X1 (U11)
-- crawl: haynespro-crawl-bmw-x1-u11-2026-05-23.json
-- modelId: d_319017768
-- 5 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — BMW X1 (U11)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319017768', NOW(), 'Multi-gen ingest, 5 engines across 2 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319017768' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('B48A20H', 'M35I xDrive (B48A20H) 221kW', 1998, 'petrol', 'turbo', NULL),
  ('XE2', 'iX1 eDrive 20 (XE2) 150kW', 0, 'petrol', 'NA', NULL),
  ('B47C20B', 's-, xDrive 20d (B47C20B) 120kW', 1995, 'diesel', 'turbo', NULL),
  ('B48A20P', 's-, xDrive 20i (B48A20P) 150kW', 1998, 'petrol', 'turbo', NULL),
  ('B38A15P', 'sDrive 16i (B38A15P) 90kW', 1499, 'petrol', 'NA', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 209, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48A20H'), 5.3, 5.6, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619135635; M35I xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 209 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48A20H'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 209, 'coolant', (SELECT id FROM engines WHERE code = 'B48A20H'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619135635; M35I xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 209 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48A20H'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 209, 'transmission_dct', (SELECT id FROM engines WHERE code = 'B48A20H'), NULL, NULL, NULL, 'BMW Hypoid Axle Oil G6', 'HaynesPro typeId t_619135635; M35I xDrive; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 209 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'B48A20H'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 210, 'coolant', (SELECT id FROM engines WHERE code = 'XE2'), 30.8, 32.55, NULL, NULL, 'HaynesPro typeId t_619135239; iX1 eDrive 20'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 210 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'XE2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 209, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47C20B'), 6.5, 6.87, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_619112443; s-, xDrive 20d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 209 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47C20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 209, 'coolant', (SELECT id FROM engines WHERE code = 'B47C20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619112443; s-, xDrive 20d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 209 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47C20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 209, 'transmission_dct', (SELECT id FROM engines WHERE code = 'B47C20B'), NULL, NULL, NULL, 'BMW Hypoid Axle Oil G6', 'HaynesPro typeId t_619112443; s-, xDrive 20d; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 209 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'B47C20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 209, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48A20P'), 5.3, 5.6, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619112442; s-, xDrive 20i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 209 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48A20P'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 209, 'coolant', (SELECT id FROM engines WHERE code = 'B48A20P'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619112442; s-, xDrive 20i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 209 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48A20P'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 209, 'engine_oil', (SELECT id FROM engines WHERE code = 'B38A15P'), 4.5, 4.76, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619116928; sDrive 16i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 209 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B38A15P'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 209, 'coolant', (SELECT id FROM engines WHERE code = 'B38A15P'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619116928; sDrive 16i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 209 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B38A15P'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 209, 'transmission_dct', (SELECT id FROM engines WHERE code = 'B38A15P'), NULL, NULL, NULL, 'BMW Hypoid Axle Oil G3', 'HaynesPro typeId t_619116928; sDrive 16i; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 209 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'B38A15P'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 209, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_319017768;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 209 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 210, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_319017768;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 210 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (209, 210)
  AND e.code IN ('B48A20H', 'XE2', 'B47C20B', 'B48A20P', 'B38A15P')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (209, 210)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (209, 210) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;