-- mig 282 — multi-gen HaynesPro ingest: BMW X6 (E71, E72)
-- crawl: haynespro-crawl-bmw-x6-e71-2026-05-23.json
-- modelId: d_102000125
-- 8 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — BMW X6 (E71, E72)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_102000125', NOW(), 'Multi-gen ingest, 8 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_102000125' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('M57D30N2', '30dX (M57D30N2) 173kW', 2993, 'petrol', 'NA', NULL),
  ('N57D30A', '30dX (N57D30A) 180kW', 2993, 'diesel', 'NA', NULL),
  ('N54B30A', '35iX (N54B30A) 240kW', 2979, 'petrol', 'turbo', NULL),
  ('N55B30A', '35iX (N55B30A) 225kW', 2979, 'petrol', 'turbo', NULL),
  ('N57D30B', '40dX (N57D30B) 225kW', 2993, 'diesel', 'NA', NULL),
  ('N63B44A', '50iX (N63B44A) 300kW', 4395, 'petrol', 'turbo', NULL),
  ('S63B44A', 'M (S63B44A) 408kW', 4395, 'petrol', 'turbo', NULL),
  ('N57D30C', 'M50dX (N57D30C) 280kW', 2993, 'diesel', 'NA', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 234, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30N2'), 7.3, 7.71, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_106000139; 30dX; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 234 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30N2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 234, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30N2'), 10.4, 10.99, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_106000139; 30dX'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 234 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30N2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 234, 'transmission_at', (SELECT id FROM engines WHERE code = 'M57D30N2'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_106000139; 30dX; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 234 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30N2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 234, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30A'), 6.7, 7.08, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102001233; 30dX; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 234 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 234, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30A'), 10.4, 10.99, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001233; 30dX'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 234 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 234, 'transmission_at', (SELECT id FROM engines WHERE code = 'N57D30A'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_102001233; 30dX; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 234 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 234, 'engine_oil', (SELECT id FROM engines WHERE code = 'N54B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_619021398; 35iX; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 234 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N54B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 234, 'coolant', (SELECT id FROM engines WHERE code = 'N54B30A'), 10.9, 11.52, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619021398; 35iX'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 234 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N54B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 234, 'transmission_at', (SELECT id FROM engines WHERE code = 'N54B30A'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_619021398; 35iX; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 234 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N54B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 234, 'engine_oil', (SELECT id FROM engines WHERE code = 'N55B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_102001368; 35iX; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 234 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 234, 'coolant', (SELECT id FROM engines WHERE code = 'N55B30A'), 10.9, 11.52, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001368; 35iX'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 234 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 234, 'transmission_at', (SELECT id FROM engines WHERE code = 'N55B30A'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_102001368; 35iX; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 234 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N55B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 234, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30B'), 6.7, 7.08, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102001808; 40dX; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 234 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 234, 'coolant', (SELECT id FROM engines WHERE code = 'N57D30B'), 10.4, 10.99, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001808; 40dX'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 234 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 234, 'transmission_at', (SELECT id FROM engines WHERE code = 'N57D30B'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_102001808; 40dX; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 234 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 234, 'engine_oil', (SELECT id FROM engines WHERE code = 'N63B44A'), 8.5, 8.98, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_106000138; 50iX; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 234 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 234, 'coolant', (SELECT id FROM engines WHERE code = 'N63B44A'), 17.2, 18.18, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_106000138; 50iX'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 234 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 234, 'transmission_at', (SELECT id FROM engines WHERE code = 'N63B44A'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_106000138; 50iX; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 234 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 234, 'engine_oil', (SELECT id FROM engines WHERE code = 'S63B44A'), 8.5, 8.98, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_102001244; M; drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 234 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'S63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 234, 'coolant', (SELECT id FROM engines WHERE code = 'S63B44A'), 17, 17.96, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001244; M'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 234 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'S63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 234, 'transmission_at', (SELECT id FROM engines WHERE code = 'S63B44A'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_102001244; M; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 234 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'S63B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 234, 'engine_oil', (SELECT id FROM engines WHERE code = 'N57D30C'), 6.5, 6.87, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_201000015; M50dX; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 234 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30C'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 234, 'transmission_at', (SELECT id FROM engines WHERE code = 'N57D30C'), NULL, NULL, NULL, 'BMW DTF1', 'HaynesPro typeId t_201000015; M50dX; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 234 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N57D30C'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 234, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_102000125;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 234 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (234)
  AND e.code IN ('M57D30N2', 'N57D30A', 'N54B30A', 'N55B30A', 'N57D30B', 'N63B44A', 'S63B44A', 'N57D30C')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (234)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (234) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;