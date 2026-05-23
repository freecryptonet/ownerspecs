-- mig 304 — multi-gen HaynesPro ingest: Audi A5 (FU)
-- crawl: haynespro-crawl-audi-a5-fu-2026-05-23.json
-- modelId: d_319022568
-- 2 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Audi A5 (FU)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319022568', NOW(), 'Multi-gen ingest, 2 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319022568' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('DWZB', '2.0 TFSI (DWZB) 150kW', 1984, 'petrol', 'turbo', NULL),
  ('DWZA', '2.0 TFSI (DWZA) 110kW', 1984, 'petrol', 'turbo', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 277, 'engine_oil', (SELECT id FROM engines WHERE code = 'DWZB'), NULL, NULL, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619141866; 2.0 TFSI; drain 20 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 277 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DWZB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 277, 'coolant', (SELECT id FROM engines WHERE code = 'DWZB'), 15, 15.85, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619141866; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 277 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DWZB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 277, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DWZB'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619141866; 2.0 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 277 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DWZB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 277, 'engine_oil', (SELECT id FROM engines WHERE code = 'DWZA'), NULL, NULL, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619141865; 2.0 TFSI; drain 20 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 277 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DWZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 277, 'coolant', (SELECT id FROM engines WHERE code = 'DWZA'), 15, 15.85, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619141865; 2.0 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 277 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DWZA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 277, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DWZA'), 4.35, 4.6, NULL, 'VW G 052 549 A2', 'HaynesPro typeId t_619141865; 2.0 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 277 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DWZA'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 277, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4', 'HaynesPro chassis d_319022568;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 277 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (277)
  AND e.code IN ('DWZB', 'DWZA')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (277)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (277) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;