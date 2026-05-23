-- mig 271 — multi-gen HaynesPro ingest: BMW X1 (F48)
-- crawl: haynespro-crawl-bmw-x1-f48-2026-05-23.json
-- modelId: d_318000006
-- 7 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — BMW X1 (F48)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_318000006', NOW(), 'Multi-gen ingest, 7 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_318000006' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('B47C20A', 's, -xDrive 18d (B47C20A) 110kW', 1995, 'diesel', 'turbo', NULL),
  ('B47C20B', 's, -xDrive 18d (B47C20B) 110kW', 1995, 'diesel', 'turbo', NULL),
  ('B48A20A', 's, -xDrive 20i (B48A20A) 141kW', 1998, 'petrol', 'turbo', NULL),
  ('B37C15A', 'sDrive 16d (B37C15A) 85kW', 1496, 'petrol', 'NA', NULL),
  ('B38A15A', 'sDrive 18i (B38A15A) 100kW', 1499, 'petrol', 'NA', NULL),
  ('B38A15F', 'sDrive 18i (B38A15F) 100kW', 1499, 'petrol', 'NA', NULL),
  ('B48A20B', 'xDrive 25i (B48A20B) 170kW', 1998, 'petrol', 'turbo', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 208, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47C20A'), 5, 5.28, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_318000009; s, -xDrive 18d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 208 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47C20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 208, 'coolant', (SELECT id FROM engines WHERE code = 'B47C20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_318000009; s, -xDrive 18d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 208 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47C20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 208, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B47C20A'), NULL, NULL, NULL, 'BMW MTF2', 'HaynesPro typeId t_318000009; s, -xDrive 18d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 208 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B47C20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 208, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47C20B'), 5.5, 5.81, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_619008104; s, -xDrive 18d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 208 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47C20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 208, 'coolant', (SELECT id FROM engines WHERE code = 'B47C20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619008104; s, -xDrive 18d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 208 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47C20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 208, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B47C20B'), NULL, NULL, NULL, 'BMW MTF2', 'HaynesPro typeId t_619008104; s, -xDrive 18d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 208 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B47C20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 208, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48A20A'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_318000011; s, -xDrive 20i; drain 20 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 208 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48A20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 208, 'coolant', (SELECT id FROM engines WHERE code = 'B48A20A'), 6.8, 7.19, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_318000011; s, -xDrive 20i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 208 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48A20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 208, 'transmission_dct', (SELECT id FROM engines WHERE code = 'B48A20A'), 4.5, 4.76, NULL, 'BMW ATF6', 'HaynesPro typeId t_318000011; s, -xDrive 20i; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 208 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'B48A20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 208, 'engine_oil', (SELECT id FROM engines WHERE code = 'B37C15A'), 4.4, 4.65, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_318012063; sDrive 16d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 208 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B37C15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 208, 'coolant', (SELECT id FROM engines WHERE code = 'B37C15A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_318012063; sDrive 16d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 208 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B37C15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 208, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B37C15A'), NULL, NULL, NULL, 'BMW MTF2', 'HaynesPro typeId t_318012063; sDrive 16d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 208 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B37C15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 208, 'engine_oil', (SELECT id FROM engines WHERE code = 'B38A15A'), 4.25, 4.49, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_318011908; sDrive 18i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 208 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B38A15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 208, 'coolant', (SELECT id FROM engines WHERE code = 'B38A15A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_318011908; sDrive 18i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 208 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B38A15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 208, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B38A15A'), 5.5, 5.81, NULL, 'BMW ATF6', 'HaynesPro typeId t_318011908; sDrive 18i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 208 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B38A15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 208, 'engine_oil', (SELECT id FROM engines WHERE code = 'B38A15F'), 4.5, 4.76, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619035815; sDrive 18i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 208 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B38A15F'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 208, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48A20B'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_318000012; xDrive 25i; drain 20 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 208 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48A20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 208, 'coolant', (SELECT id FROM engines WHERE code = 'B48A20B'), 6.8, 7.19, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_318000012; xDrive 25i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 208 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48A20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 208, 'transmission_at', (SELECT id FROM engines WHERE code = 'B48A20B'), NULL, NULL, NULL, 'BMW Synthetik OSP (BMW 83 22 2 365 987)', 'HaynesPro typeId t_318000012; xDrive 25i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 208 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B48A20B'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 208, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_318000006;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 208 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (208)
  AND e.code IN ('B47C20A', 'B47C20B', 'B48A20A', 'B37C15A', 'B38A15A', 'B38A15F', 'B48A20B')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (208)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (208) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;