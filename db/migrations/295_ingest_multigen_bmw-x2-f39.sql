-- mig 295 — multi-gen HaynesPro ingest: BMW X2 (F39)
-- crawl: haynespro-crawl-bmw-x2-f39-2026-05-23.json
-- modelId: d_319001659
-- 10 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — BMW X2 (F39)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319001659', NOW(), 'Multi-gen ingest, 10 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319001659' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('B48A20E', 'M35i (B48A20E) 225kW', 1998, 'petrol', 'turbo', NULL),
  ('B47C20B', 's, xDrive 18d (B47C20B) 110kW', 1995, 'diesel', 'turbo', NULL),
  ('B48A20A', 's, xDrive 20i (B48A20A) 141kW', 1998, 'petrol', 'turbo', NULL),
  ('B37C15A', 'sDrive 16d (B37C15A) 85kW', 1496, 'petrol', 'NA', NULL),
  ('B38A15A', 'sDrive 18i (B38A15A) 103kW', 1499, 'petrol', 'NA', NULL),
  ('B38A15F', 'sDrive 18i (B38A15F) 100kW', 1499, 'petrol', 'NA', NULL),
  ('B48A20F', 'sDrive 20i (B48A20F) 131kW', 1998, 'petrol', 'turbo', NULL),
  ('B46A20B', 'xDrive 20i (B46A20B) 141kW', 1998, 'petrol', 'turbo', NULL),
  ('B47C20B (B47C20T0)', 'xDrive 25d (B47C20B (B47C20T0)) 170kW', 1995, 'diesel', 'turbo', NULL),
  ('B47C20B (B47C20T1)', 'xDrive 25d (B47C20B (B47C20T1)) 170kW', 1995, 'diesel', 'turbo', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 264, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48A20E'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619017667; M35i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 264 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48A20E'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 264, 'coolant', (SELECT id FROM engines WHERE code = 'B48A20E'), 10.8, 11.41, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619017667; M35i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 264 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48A20E'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 264, 'transmission_at', (SELECT id FROM engines WHERE code = 'B48A20E'), 7, 7.4, NULL, 'BMW Synthetik OSP (BMW 83 22 2 365 987)', 'HaynesPro typeId t_619017667; M35i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 264 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B48A20E'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 264, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47C20B'), 5, 5.28, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_619008915; s, xDrive 18d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 264 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47C20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 264, 'coolant', (SELECT id FROM engines WHERE code = 'B47C20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619008915; s, xDrive 18d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 264 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47C20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 264, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B47C20B'), 7, 7.4, NULL, 'BMW MTF3', 'HaynesPro typeId t_619008915; s, xDrive 18d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 264 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B47C20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 264, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48A20A'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_319007838; s, xDrive 20i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 264 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48A20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 264, 'coolant', (SELECT id FROM engines WHERE code = 'B48A20A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_319007838; s, xDrive 20i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 264 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48A20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 264, 'transmission_dct', (SELECT id FROM engines WHERE code = 'B48A20A'), 4.5, 4.76, NULL, 'BMW ATF7', 'HaynesPro typeId t_319007838; s, xDrive 20i; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 264 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'B48A20A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 264, 'engine_oil', (SELECT id FROM engines WHERE code = 'B37C15A'), 4.8, 5.07, '0W-30', 'BMW Longlife-12 FE', 'HaynesPro typeId t_619019700; sDrive 16d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 264 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B37C15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 264, 'coolant', (SELECT id FROM engines WHERE code = 'B37C15A'), 6, 6.34, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619019700; sDrive 16d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 264 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B37C15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 264, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B37C15A'), 4.5, 4.76, NULL, 'BMW MTF2', 'HaynesPro typeId t_619019700; sDrive 16d; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 264 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B37C15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 264, 'engine_oil', (SELECT id FROM engines WHERE code = 'B38A15A'), 4.5, 4.76, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619008917; sDrive 18i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 264 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B38A15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 264, 'coolant', (SELECT id FROM engines WHERE code = 'B38A15A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619008917; sDrive 18i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 264 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B38A15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 264, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B38A15A'), 4.5, 4.76, NULL, NULL, 'HaynesPro typeId t_619008917; sDrive 18i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 264 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B38A15A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 264, 'engine_oil', (SELECT id FROM engines WHERE code = 'B38A15F'), 4.5, 4.76, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619037007; sDrive 18i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 264 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B38A15F'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 264, 'coolant', (SELECT id FROM engines WHERE code = 'B38A15F'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619037007; sDrive 18i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 264 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B38A15F'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 264, 'transmission_mt', (SELECT id FROM engines WHERE code = 'B38A15F'), 4.5, 4.76, NULL, NULL, 'HaynesPro typeId t_619037007; sDrive 18i; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 264 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'B38A15F'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 264, 'engine_oil', (SELECT id FROM engines WHERE code = 'B48A20F'), 5.3, 5.6, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619035817; sDrive 20i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 264 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B48A20F'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 264, 'coolant', (SELECT id FROM engines WHERE code = 'B48A20F'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619035817; sDrive 20i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 264 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B48A20F'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 264, 'transmission_dct', (SELECT id FROM engines WHERE code = 'B48A20F'), 4.5, 4.76, NULL, NULL, 'HaynesPro typeId t_619035817; sDrive 20i; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 264 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'B48A20F'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 264, 'engine_oil', (SELECT id FROM engines WHERE code = 'B46A20B'), 5.25, 5.55, '0W-20', 'BMW Longlife-17 FE+', 'HaynesPro typeId t_619139960; xDrive 20i; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 264 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B46A20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 264, 'coolant', (SELECT id FROM engines WHERE code = 'B46A20B'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619139960; xDrive 20i'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 264 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B46A20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 264, 'transmission_at', (SELECT id FROM engines WHERE code = 'B46A20B'), 7, 7.4, NULL, 'BMW ATF7', 'HaynesPro typeId t_619139960; xDrive 20i; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 264 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B46A20B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 264, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47C20B (B47C20T0)'), 5, 5.28, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_619008916; xDrive 25d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 264 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47C20B (B47C20T0)'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 264, 'coolant', (SELECT id FROM engines WHERE code = 'B47C20B (B47C20T0)'), 7.4, 7.82, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619008916; xDrive 25d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 264 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47C20B (B47C20T0)'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 264, 'transmission_at', (SELECT id FROM engines WHERE code = 'B47C20B (B47C20T0)'), NULL, NULL, NULL, 'BMW Synthetik OSP (BMW 83 22 2 365 987)', 'HaynesPro typeId t_619008916; xDrive 25d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 264 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B47C20B (B47C20T0)'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 264, 'engine_oil', (SELECT id FROM engines WHERE code = 'B47C20B (B47C20T1)'), 5.5, 5.81, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_619043047; xDrive 25d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 264 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'B47C20B (B47C20T1)'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 264, 'coolant', (SELECT id FROM engines WHERE code = 'B47C20B (B47C20T1)'), 7.4, 7.82, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_619043047; xDrive 25d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 264 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'B47C20B (B47C20T1)'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 264, 'transmission_at', (SELECT id FROM engines WHERE code = 'B47C20B (B47C20T1)'), 7, 7.4, NULL, 'BMW Synthetik OSP (BMW 83 22 2 365 987)', 'HaynesPro typeId t_619043047; xDrive 25d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 264 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'B47C20B (B47C20T1)'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 264, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_319001659;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 264 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (264)
  AND e.code IN ('B48A20E', 'B47C20B', 'B48A20A', 'B37C15A', 'B38A15A', 'B38A15F', 'B48A20F', 'B46A20B', 'B47C20B (B47C20T0)', 'B47C20B (B47C20T1)')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (264)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (264) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;