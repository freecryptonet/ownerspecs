-- mig 265 — multi-gen HaynesPro ingest: BMW 7 (E65, E66, E67, E68)
-- crawl: haynespro-crawl-bmw-7-e65-2026-05-23.json
-- modelId: d_800
-- 12 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — BMW 7 (E65, E66, E67, E68)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_800', NOW(), 'Multi-gen ingest, 12 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_800' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('M57D30TU', '730d (M57D30TU) 160kW', 2993, 'petrol', 'NA', NULL),
  ('M57D30T2', '730d, Ld (M57D30T2) 170kW', 2993, 'petrol', 'NA', NULL),
  ('M54B30', '730i, Li (M54B30) 170kW', 2979, 'petrol', 'NA', NULL),
  ('N52B30A', '730i, Li, -LPG (N52B30A) 190kW', 2996, 'petrol', 'NA', NULL),
  ('N62B36A', '735i, Li, -LPG (N62B36A) 200kW', 3600, 'petrol', 'NA', NULL),
  ('M67D39', '740d (M67D39) 190kW', 3901, 'petrol', 'NA', NULL),
  ('N62B40A', '740i, Li (N62B40A) 225kW', 4000, 'petrol', 'NA', NULL),
  ('M67D44', '745d (M67D44) 242kW', 4423, 'petrol', 'NA', NULL),
  ('N62B44A', '745i, Li, -LPG (N62B44A) 245kW', 4398, 'petrol', 'NA', NULL),
  ('N62B48B', '750i, Li, -LPG (N62B48B) 270kW', 4799, 'petrol', 'NA', NULL),
  ('N73H60', '760LH Hydrogen (N73H60) 191kW', 5972, 'petrol', 'NA', NULL),
  ('N73B60A', '760i, Li (N73B60A) 320kW', 5972, 'petrol', 'NA', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 201, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30TU'), 8.25, 8.72, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_55000; 730d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 201 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30TU'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 201, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30TU'), 10, 10.57, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_55000; 730d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 201 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30TU'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 201, 'transmission_at', (SELECT id FROM engines WHERE code = 'M57D30TU'), NULL, NULL, NULL, 'SAE 75W-90', 'HaynesPro typeId t_55000; 730d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 201 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30TU'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 201, 'engine_oil', (SELECT id FROM engines WHERE code = 'M57D30T2'), 7.5, 7.93, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_55060; 730d, Ld; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 201 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 201, 'coolant', (SELECT id FROM engines WHERE code = 'M57D30T2'), 10, 10.57, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_55060; 730d, Ld'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 201 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 201, 'transmission_at', (SELECT id FROM engines WHERE code = 'M57D30T2'), NULL, NULL, NULL, 'SAE 75W-90', 'HaynesPro typeId t_55060; 730d, Ld; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 201 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'M57D30T2'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 201, 'engine_oil', (SELECT id FROM engines WHERE code = 'M54B30'), 6.5, 6.87, '5W-30', 'BMW Longlife-01', 'HaynesPro typeId t_55010; 730i, Li; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 201 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B30'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 201, 'coolant', (SELECT id FROM engines WHERE code = 'M54B30'), 10.5, 11.1, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_55010; 730i, Li'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 201 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B30'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 201, 'transmission_at', (SELECT id FROM engines WHERE code = 'M54B30'), NULL, NULL, NULL, 'SAE 75W-90', 'HaynesPro typeId t_55010; 730i, Li; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 201 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'M54B30'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 201, 'engine_oil', (SELECT id FROM engines WHERE code = 'N52B30A'), 6.5, 6.87, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_79070; 730i, Li, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 201 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 201, 'coolant', (SELECT id FROM engines WHERE code = 'N52B30A'), 12, 12.68, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_79070; 730i, Li, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 201 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 201, 'transmission_at', (SELECT id FROM engines WHERE code = 'N52B30A'), NULL, NULL, NULL, 'SAE 75W-90', 'HaynesPro typeId t_79070; 730i, Li, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 201 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N52B30A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 201, 'engine_oil', (SELECT id FROM engines WHERE code = 'N62B36A'), 8, 8.45, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_54940; 735i, Li, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 201 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B36A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 201, 'coolant', (SELECT id FROM engines WHERE code = 'N62B36A'), 14.5, 15.32, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_54940; 735i, Li, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 201 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B36A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 201, 'transmission_at', (SELECT id FROM engines WHERE code = 'N62B36A'), NULL, NULL, NULL, 'SAE 75W-90', 'HaynesPro typeId t_54940; 735i, Li, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 201 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B36A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 201, 'engine_oil', (SELECT id FROM engines WHERE code = 'M67D39'), 9.5, 10.04, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_55020; 740d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 201 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M67D39'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 201, 'coolant', (SELECT id FROM engines WHERE code = 'M67D39'), 16.4, 17.33, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_55020; 740d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 201 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M67D39'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 201, 'transmission_at', (SELECT id FROM engines WHERE code = 'M67D39'), NULL, NULL, NULL, 'SAE 75W-90', 'HaynesPro typeId t_55020; 740d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 201 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'M67D39'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 201, 'engine_oil', (SELECT id FROM engines WHERE code = 'N62B40A'), 8, 8.45, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_59250; 740i, Li; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 201 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B40A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 201, 'coolant', (SELECT id FROM engines WHERE code = 'N62B40A'), 14.5, 15.32, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_59250; 740i, Li'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 201 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B40A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 201, 'transmission_at', (SELECT id FROM engines WHERE code = 'N62B40A'), NULL, NULL, NULL, 'SAE 75W-90', 'HaynesPro typeId t_59250; 740i, Li; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 201 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B40A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 201, 'engine_oil', (SELECT id FROM engines WHERE code = 'M67D44'), 9.5, 10.04, '0W-30', 'BMW Longlife-19 FE', 'HaynesPro typeId t_110000416; 745d; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 201 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'M67D44'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 201, 'coolant', (SELECT id FROM engines WHERE code = 'M67D44'), 16.5, 17.44, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_110000416; 745d'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 201 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'M67D44'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 201, 'transmission_at', (SELECT id FROM engines WHERE code = 'M67D44'), NULL, NULL, NULL, 'SAE 75W-90', 'HaynesPro typeId t_110000416; 745d; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 201 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'M67D44'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 201, 'engine_oil', (SELECT id FROM engines WHERE code = 'N62B44A'), 8, 8.45, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_54970; 745i, Li, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 201 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 201, 'coolant', (SELECT id FROM engines WHERE code = 'N62B44A'), 14, 14.79, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_54970; 745i, Li, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 201 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 201, 'transmission_at', (SELECT id FROM engines WHERE code = 'N62B44A'), NULL, NULL, NULL, 'SAE 75W-90', 'HaynesPro typeId t_54970; 745i, Li, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 201 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B44A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 201, 'engine_oil', (SELECT id FROM engines WHERE code = 'N62B48B'), 8, 8.45, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_79080; 750i, Li, -LPG; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 201 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B48B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 201, 'coolant', (SELECT id FROM engines WHERE code = 'N62B48B'), 14.5, 15.32, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_79080; 750i, Li, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 201 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B48B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 201, 'transmission_at', (SELECT id FROM engines WHERE code = 'N62B48B'), NULL, NULL, NULL, 'SAE 75W-90', 'HaynesPro typeId t_79080; 750i, Li, -LPG; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 201 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N62B48B'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 201, 'engine_oil', (SELECT id FROM engines WHERE code = 'N73H60'), 8.5, 8.98, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_102001361; 760LH Hydrogen; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 201 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N73H60'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 201, 'coolant', (SELECT id FROM engines WHERE code = 'N73H60'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001361; 760LH Hydrogen'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 201 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N73H60'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 201, 'transmission_at', (SELECT id FROM engines WHERE code = 'N73H60'), NULL, NULL, NULL, 'SAE 75W-90', 'HaynesPro typeId t_102001361; 760LH Hydrogen; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 201 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N73H60'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 201, 'engine_oil', (SELECT id FROM engines WHERE code = 'N73B60A'), 8.5, 8.98, '0W-30', 'BMW Longlife-01 FE', 'HaynesPro typeId t_106000136; 760i, Li; drain 25 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 201 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'N73B60A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 201, 'coolant', (SELECT id FROM engines WHERE code = 'N73B60A'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_106000136; 760i, Li'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 201 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'N73B60A'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 201, 'transmission_at', (SELECT id FROM engines WHERE code = 'N73B60A'), NULL, NULL, NULL, 'SAE 75W-90', 'HaynesPro typeId t_106000136; 760i, Li; Automatic transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 201 AND fluid_type = 'transmission_at' AND engine_id = (SELECT id FROM engines WHERE code = 'N73B60A'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 201, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_800;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 201 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (201)
  AND e.code IN ('M57D30TU', 'M57D30T2', 'M54B30', 'N52B30A', 'N62B36A', 'M67D39', 'N62B40A', 'M67D44', 'N62B44A', 'N62B48B', 'N73H60', 'N73B60A')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (201)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (201) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;