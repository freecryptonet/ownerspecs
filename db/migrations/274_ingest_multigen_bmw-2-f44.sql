-- mig 274 — multi-gen HaynesPro ingest: BMW 2 Gran Coupe (F44)
-- crawl: haynespro-crawl-bmw-2-f44-2026-05-23.json
-- modelId: d_319004912
-- 7 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — BMW 2 Gran Coupe (F44)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319004912', NOW(), 'Multi-gen ingest, 7 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319004912' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('B37C15A', '216d (B37C15A) 85kW', 1496, 'petrol', 'NA', NULL),
  ('B38A15A', '216i (B38A15A) 80kW', 1499, 'petrol', 'NA', NULL),
  ('B47C20B', '218d (B47C20B) 110kW', 1995, 'diesel', 'turbo', NULL),
  ('B38A15F', '218i (B38A15F) 100kW', 1499, 'petrol', 'NA', NULL),
  ('B46A20B', '220i (B46A20B) 141kW', 1998, 'petrol', 'turbo', NULL),
  ('B48A20A', '220i, -xDrive (B48A20A) 131kW', 1998, 'petrol', 'turbo', NULL),
  ('B48A20E', 'M235i xDrive (B48A20E) 225kW', 1998, 'petrol', 'turbo', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 214, 'engine_oil', (SELECT id FROM engines WHERE code = 'B37C15A'), 4.8, 5.07, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_619032571; 216d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 214 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B37C15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 214, 'coolant', (SELECT id FROM engines WHERE code = 'B37C15A'), 6, 6.34, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619032571; 216d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 214 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B37C15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 214, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B37C15A'), 4.5, 4.76, NULL, NULL, 'HaynesPro typeId t_619032571; 216d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 214 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B37C15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 214, 'engine_oil', (SELECT id FROM engines WHERE code = 'B38A15A'), 4.5, 4.76, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619034561; 216i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 214 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B38A15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 214, 'coolant', (SELECT id FROM engines WHERE code = 'B38A15A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619034561; 216i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 214 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B38A15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 214, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B38A15A'), 4.5, 4.76, NULL, NULL, 'HaynesPro typeId t_619034561; 216i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 214 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B38A15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 214, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47C20B'), 5.5, 5.81, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_619033865; 218d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 214 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47C20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 214, 'coolant', (SELECT id FROM engines WHERE code = 'B47C20B'), 7, 7.4, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619033865; 218d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 214 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47C20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 214, 'transmission_at', (SELECT id FROM engines WHERE code = 'B47C20B'), 7, 7.4, NULL, 'BMW MTF3', 'HaynesPro typeId t_619033865; 218d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 214 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B47C20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 214, 'engine_oil', (SELECT id FROM engines WHERE code = 'B38A15F'), 4.5, 4.76, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619036774; 218i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 214 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B38A15F'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 214, 'coolant', (SELECT id FROM engines WHERE code = 'B38A15F'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619036774; 218i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 214 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B38A15F'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 214, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B38A15F'), 4.5, 4.76, NULL, NULL, 'HaynesPro typeId t_619036774; 218i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 214 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B38A15F'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 214, 'engine_oil', (SELECT id FROM engines WHERE code = 'B46A20B'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619037827; 220i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 214 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B46A20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 214, 'coolant', (SELECT id FROM engines WHERE code = 'B46A20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619037827; 220i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 214 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B46A20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 214, 'transmission_at', (SELECT id FROM engines WHERE code = 'B46A20B'), 7, 7.4, NULL, NULL, 'HaynesPro typeId t_619037827; 220i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 214 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B46A20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 214, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48A20A'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619035796; 220i, -xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 214 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48A20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 214, 'coolant', (SELECT id FROM engines WHERE code = 'B48A20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619035796; 220i, -xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 214 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48A20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 214, 'transmission_dct', (SELECT id FROM engines WHERE code = 'B48A20A'), 4.5, 4.76, NULL, 'BMW ATF7', 'HaynesPro typeId t_619035796; 220i, -xDrive; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 214 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'B48A20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 214, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48A20E'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619024313; M235i xDrive; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 214 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48A20E'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 214, 'coolant', (SELECT id FROM engines WHERE code = 'B48A20E'), 10.8, 11.41, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619024313; M235i xDrive'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 214 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48A20E'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 214, 'transmission_at', (SELECT id FROM engines WHERE code = 'B48A20E'), 7, 7.4, NULL, 'BMW Hypoid Axle Oil G3', 'HaynesPro typeId t_619024313; M235i xDrive; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 214 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B48A20E'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 214, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_319004912;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 214 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (214)
  AND e.code IN ('B37C15A', 'B38A15A', 'B47C20B', 'B38A15F', 'B46A20B', 'B48A20A', 'B48A20E')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (214)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (214) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;