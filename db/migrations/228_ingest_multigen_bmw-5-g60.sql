-- mig 228 — multi-gen HaynesPro ingest: BMW 5 (G60, G61, G90)
-- crawl: haynespro-crawl-bmw-5-g60-2026-05-23.json
-- modelId: d_319018562
-- 6 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — BMW 5 (G60, G61, G90)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319018562', NOW(), 'Multi-gen ingest, 6 engines across 4 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319018562' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('B47D20B', '520d (B47D20B) 120kW', 1995, 'diesel', 'turbo', NULL),
  ('B48B20P', '520i (B48B20P) 153kW', 1998, 'petrol', 'turbo', NULL),
  ('B48B16P', '520i (B48B16P) 153kW', 1597, 'petrol', 'turbo', NULL),
  ('B48B20V', '530e, -xDrive (B48B20V) 220kW', 1998, 'petrol', 'turbo', NULL),
  ('XE2', 'i5 M60 xDrive (XE2) 442kW', 0, 'electric', 'NA', NULL),
  ('HA0', 'i5 eDrive40 (HA0) 250kW', 0, 'electric', 'NA', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 128, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47D20B'), 6.5, 6.87, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619139577; 520d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 128 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 128, 'coolant', (SELECT id FROM engines WHERE code = 'B47D20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619139577; 520d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 128 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 128, 'transmission_at', (SELECT id FROM engines WHERE code = 'B47D20B'), 8, 8.45, NULL, 'BMW Hypoid Axle Oil G5', 'HaynesPro typeId t_619139577; 520d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 128 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 134, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47D20B'), 6.5, 6.87, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619139577; 520d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 134 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 134, 'coolant', (SELECT id FROM engines WHERE code = 'B47D20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619139577; 520d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 134 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 134, 'transmission_at', (SELECT id FROM engines WHERE code = 'B47D20B'), 8, 8.45, NULL, 'BMW Hypoid Axle Oil G5', 'HaynesPro typeId t_619139577; 520d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 134 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B47D20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 128, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B20P'), 5.3, 5.6, '0W-12', 'BMW Longlife-22 FE++', 'HaynesPro typeId t_619116379; 520i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 128 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20P'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 128, 'coolant', (SELECT id FROM engines WHERE code = 'B48B20P'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619116379; 520i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 128 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20P'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 134, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B20P'), 5.3, 5.6, '0W-12', 'BMW Longlife-22 FE++', 'HaynesPro typeId t_619116379; 520i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 134 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20P'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 134, 'coolant', (SELECT id FROM engines WHERE code = 'B48B20P'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619116379; 520i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 134 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20P'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 128, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B16P'), 5.3, 5.6, '0W-12', 'BMW Longlife-22 FE++', 'HaynesPro typeId t_619143507; 520i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 128 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B16P'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 128, 'coolant', (SELECT id FROM engines WHERE code = 'B48B16P'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619143507; 520i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 128 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B16P'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 128, 'transmission_at', (SELECT id FROM engines WHERE code = 'B48B16P'), 8, 8.45, NULL, 'BMW Hypoid Axle Oil G5', 'HaynesPro typeId t_619143507; 520i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 128 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B16P'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 134, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B16P'), 5.3, 5.6, '0W-12', 'BMW Longlife-22 FE++', 'HaynesPro typeId t_619143507; 520i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 134 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B16P'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 134, 'coolant', (SELECT id FROM engines WHERE code = 'B48B16P'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619143507; 520i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 134 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B16P'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 134, 'transmission_at', (SELECT id FROM engines WHERE code = 'B48B16P'), 8, 8.45, NULL, 'BMW Hypoid Axle Oil G5', 'HaynesPro typeId t_619143507; 520i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 134 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B16P'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 128, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B20V'), 5.3, 5.6, '0W-12', 'BMW Longlife-22 FE++', 'HaynesPro typeId t_619116381; 530e, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 128 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20V'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 128, 'coolant', (SELECT id FROM engines WHERE code = 'B48B20V'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619116381; 530e, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 128 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20V'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 134, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48B20V'), 5.3, 5.6, '0W-12', 'BMW Longlife-22 FE++', 'HaynesPro typeId t_619116381; 530e, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 134 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20V'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 134, 'coolant', (SELECT id FROM engines WHERE code = 'B48B20V'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619116381; 530e, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 134 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48B20V'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 129, 'coolant', (SELECT id FROM engines WHERE code = 'XE2'), 17.2, 18.18, NULL, NULL, 'HaynesPro typeId t_619116378; i5 M60 xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 129 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'XE2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 135, 'coolant', (SELECT id FROM engines WHERE code = 'XE2'), 17.2, 18.18, NULL, NULL, 'HaynesPro typeId t_619116378; i5 M60 xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 135 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'XE2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 129, 'coolant', (SELECT id FROM engines WHERE code = 'HA0'), 17.2, 18.18, NULL, NULL, 'HaynesPro typeId t_619116377; i5 eDrive40'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 129 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'HA0'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 135, 'coolant', (SELECT id FROM engines WHERE code = 'HA0'), 17.2, 18.18, NULL, NULL, 'HaynesPro typeId t_619116377; i5 eDrive40'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 135 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'HA0'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 128, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_319018562;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 128 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 134, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_319018562;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 134 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 129, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_319018562;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 129 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 135, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_319018562;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 135 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (128, 134, 129, 135)
  AND e.code IN ('B47D20B', 'B48B20P', 'B48B16P', 'B48B20V', 'XE2', 'HA0')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (128, 134, 129, 135)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (128, 134, 129, 135) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;