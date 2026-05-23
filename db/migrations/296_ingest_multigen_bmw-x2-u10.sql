-- mig 296 — multi-gen HaynesPro ingest: BMW X2 (U10)
-- crawl: haynespro-crawl-bmw-x2-u10-2026-05-23.json
-- modelId: d_319021717
-- 4 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — BMW X2 (U10)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319021717', NOW(), 'Multi-gen ingest, 4 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319021717' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('B47C20B', '-s, xDrive20d (B47C20B) 120kW', 1995, 'diesel', 'turbo', NULL),
  ('B48A20H', 'M35i xDrive (B48A20H) 221kW', 1998, 'petrol', 'turbo', NULL),
  ('B38A15P', 'sDrive16i (B38A15P) 90kW', 1499, 'petrol', 'NA', NULL),
  ('B48A20P', 'sDrive25i (B48A20P) 150kW', 1998, 'petrol', 'turbo', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 265, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47C20B'), 6.5, 6.87, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619139574; -s, xDrive20d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 265 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47C20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 265, 'coolant', (SELECT id FROM engines WHERE code = 'B47C20B'), 7.6, 8.03, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619139574; -s, xDrive20d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 265 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47C20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 265, 'transmission_dct', (SELECT id FROM engines WHERE code = 'B47C20B'), NULL, NULL, NULL, 'BMW Hypoid Axle Oil G6', 'HaynesPro typeId t_619139574; -s, xDrive20d; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 265 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'B47C20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 265, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48A20H'), 5.3, 5.6, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619135934; M35i xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 265 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48A20H'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 265, 'coolant', (SELECT id FROM engines WHERE code = 'B48A20H'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619135934; M35i xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 265 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48A20H'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 265, 'transmission_dct', (SELECT id FROM engines WHERE code = 'B48A20H'), NULL, NULL, NULL, 'BMW Hypoid Axle Oil G6', 'HaynesPro typeId t_619135934; M35i xDrive; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 265 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'B48A20H'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 265, 'engine_oil', (SELECT id FROM engines WHERE code = 'B38A15P'), 4.5, 4.76, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619139735; sDrive16i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 265 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B38A15P'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 265, 'coolant', (SELECT id FROM engines WHERE code = 'B38A15P'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619139735; sDrive16i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 265 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B38A15P'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 265, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48A20P'), 5.3, 5.6, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619139737; sDrive25i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 265 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48A20P'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 265, 'coolant', (SELECT id FROM engines WHERE code = 'B48A20P'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619139737; sDrive25i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 265 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48A20P'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 265, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_319021717;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 265 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (265)
  AND e.code IN ('B47C20B', 'B48A20H', 'B38A15P', 'B48A20P')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (265)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (265) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;