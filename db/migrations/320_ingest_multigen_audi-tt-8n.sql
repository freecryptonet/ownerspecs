-- mig 320 — multi-gen HaynesPro ingest: Audi TT (8N)
-- crawl: haynespro-crawl-audi-tt-8n-2026-05-23.json
-- modelId: d_420
-- 16 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Audi TT (8N)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_420', NOW(), 'Multi-gen ingest, 16 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_420' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('BEA', '1.8 20V Turbo (BEA) 165kW', 1781, 'petrol', 'turbo', NULL),
  ('APX', '1.8 20V Turbo (APX) 165kW', 1781, 'petrol', 'turbo', NULL),
  ('AJQ', '1.8 20V Turbo (AJQ) 132kW', 1781, 'petrol', 'turbo', NULL),
  ('APP', '1.8 20V Turbo (APP) 132kW', 1781, 'petrol', 'turbo', NULL),
  ('ATC', '1.8 20V Turbo (ATC) 132kW', 1781, 'petrol', 'turbo', NULL),
  ('AMU', '1.8 20V Turbo (AMU) 165kW', 1781, 'petrol', 'turbo', NULL),
  ('BAM', '1.8 20V Turbo (BAM) 165kW', 1781, 'petrol', 'turbo', NULL),
  ('ARY', '1.8 20V Turbo (ARY) 132kW', 1781, 'petrol', 'turbo', NULL),
  ('AUQ', '1.8 20V Turbo (AUQ) 132kW', 1781, 'petrol', 'turbo', NULL),
  ('AWP', '1.8 20V Turbo (AWP) 132kW', 1781, 'petrol', 'turbo', NULL),
  ('AUM', '1.8 20V Turbo (AUM) 110kW', 1781, 'petrol', 'turbo', NULL),
  ('BFV', '1.8 20V Turbo (BFV) 176kW', 1781, 'petrol', 'turbo', NULL),
  ('BVR', '1.8 20V Turbo (BVR) 140kW', 1781, 'petrol', 'turbo', NULL),
  ('BVP', '1.8 20V Turbo (BVP) 120kW', 1781, 'petrol', 'turbo', NULL),
  ('BHE', '3.2 V6 (BHE) 184kW', 3189, 'petrol', 'NA', NULL),
  ('BPF', '3.2 V6 (BPF) 184kW', 3189, 'petrol', 'NA', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'engine_oil', (SELECT id FROM engines WHERE code = 'BEA'), 4.6, 4.86, '5W-30', 'VW 502 00', 'HaynesPro typeId t_619017174; 1.8 20V Turbo; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'coolant', (SELECT id FROM engines WHERE code = 'BEA'), 7, 7.4, NULL, '(De-ionised water with 40% anti-freeze)', 'HaynesPro typeId t_619017174; 1.8 20V Turbo'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'transmission_mt', (SELECT id FROM engines WHERE code = 'BEA'), 2.6, 2.75, NULL, 'SAE 75W', 'HaynesPro typeId t_619017174; 1.8 20V Turbo; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'BEA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'engine_oil', (SELECT id FROM engines WHERE code = 'APX'), 4.6, 4.86, '5W-30', 'VW 502 00', 'HaynesPro typeId t_63040; 1.8 20V Turbo; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'APX'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'coolant', (SELECT id FROM engines WHERE code = 'APX'), 7, 7.4, NULL, '(De-ionised water with 40% anti-freeze)', 'HaynesPro typeId t_63040; 1.8 20V Turbo'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'APX'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'transmission_mt', (SELECT id FROM engines WHERE code = 'APX'), 2.6, 2.75, NULL, 'SAE 75W', 'HaynesPro typeId t_63040; 1.8 20V Turbo; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'APX'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'engine_oil', (SELECT id FROM engines WHERE code = 'AJQ'), 4.5, 4.76, '5W-30', 'VW 502 00', 'HaynesPro typeId t_45790; 1.8 20V Turbo; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'AJQ'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'coolant', (SELECT id FROM engines WHERE code = 'AJQ'), 7, 7.4, NULL, '(De-ionised water with 40% anti-freeze)', 'HaynesPro typeId t_45790; 1.8 20V Turbo'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'AJQ'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'transmission_mt', (SELECT id FROM engines WHERE code = 'AJQ'), 2, 2.11, NULL, 'SAE 75W', 'HaynesPro typeId t_45790; 1.8 20V Turbo; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'AJQ'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'engine_oil', (SELECT id FROM engines WHERE code = 'APP'), 4.6, 4.86, '5W-30', 'VW 502 00', 'HaynesPro typeId t_50610; 1.8 20V Turbo; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'APP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'coolant', (SELECT id FROM engines WHERE code = 'APP'), 7, 7.4, NULL, '(De-ionised water with 40% anti-freeze)', 'HaynesPro typeId t_50610; 1.8 20V Turbo'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'APP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'transmission_mt', (SELECT id FROM engines WHERE code = 'APP'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_50610; 1.8 20V Turbo; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'APP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'engine_oil', (SELECT id FROM engines WHERE code = 'ATC'), 4.5, 4.76, '5W-30', 'VW 502 00', 'HaynesPro typeId t_45760; 1.8 20V Turbo; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'ATC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'coolant', (SELECT id FROM engines WHERE code = 'ATC'), 7, 7.4, NULL, '(De-ionised water with 40% anti-freeze)', 'HaynesPro typeId t_45760; 1.8 20V Turbo'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'ATC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'transmission_mt', (SELECT id FROM engines WHERE code = 'ATC'), 2, 2.11, NULL, 'SAE 75W', 'HaynesPro typeId t_45760; 1.8 20V Turbo; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'ATC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'engine_oil', (SELECT id FROM engines WHERE code = 'AMU'), 4.5, 4.76, '5W-30', 'VW 502 00', 'HaynesPro typeId t_63050; 1.8 20V Turbo; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'AMU'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'coolant', (SELECT id FROM engines WHERE code = 'AMU'), 7, 7.4, NULL, '(De-ionised water with 40% anti-freeze)', 'HaynesPro typeId t_63050; 1.8 20V Turbo'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'AMU'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'transmission_mt', (SELECT id FROM engines WHERE code = 'AMU'), 2.6, 2.75, NULL, 'SAE 75W', 'HaynesPro typeId t_63050; 1.8 20V Turbo; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'AMU'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'engine_oil', (SELECT id FROM engines WHERE code = 'BAM'), 4.6, 4.86, '5W-30', 'VW 502 00', 'HaynesPro typeId t_50380; 1.8 20V Turbo; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BAM'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'coolant', (SELECT id FROM engines WHERE code = 'BAM'), 7, 7.4, NULL, '(De-ionised water with 40% anti-freeze)', 'HaynesPro typeId t_50380; 1.8 20V Turbo'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BAM'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'transmission_mt', (SELECT id FROM engines WHERE code = 'BAM'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_50380; 1.8 20V Turbo; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'BAM'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'engine_oil', (SELECT id FROM engines WHERE code = 'ARY'), 4.6, 4.86, '5W-30', 'VW 502 00', 'HaynesPro typeId t_50400; 1.8 20V Turbo; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'ARY'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'coolant', (SELECT id FROM engines WHERE code = 'ARY'), 7, 7.4, NULL, '(De-ionised water with 40% anti-freeze)', 'HaynesPro typeId t_50400; 1.8 20V Turbo'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'ARY'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'transmission_mt', (SELECT id FROM engines WHERE code = 'ARY'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_50400; 1.8 20V Turbo; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'ARY'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'engine_oil', (SELECT id FROM engines WHERE code = 'AUQ'), 4.6, 4.86, '5W-30', 'VW 502 00', 'HaynesPro typeId t_50410; 1.8 20V Turbo; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'AUQ'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'coolant', (SELECT id FROM engines WHERE code = 'AUQ'), 7, 7.4, NULL, '(De-ionised water with 40% anti-freeze)', 'HaynesPro typeId t_50410; 1.8 20V Turbo'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'AUQ'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'transmission_mt', (SELECT id FROM engines WHERE code = 'AUQ'), 2, 2.11, NULL, 'SAE 75W', 'HaynesPro typeId t_50410; 1.8 20V Turbo; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'AUQ'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'engine_oil', (SELECT id FROM engines WHERE code = 'AWP'), 4.5, 4.76, '5W-30', 'VW 502 00', 'HaynesPro typeId t_63060; 1.8 20V Turbo; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'AWP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'coolant', (SELECT id FROM engines WHERE code = 'AWP'), 7, 7.4, NULL, '(De-ionised water with 40% anti-freeze)', 'HaynesPro typeId t_63060; 1.8 20V Turbo'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'AWP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'transmission_mt', (SELECT id FROM engines WHERE code = 'AWP'), 2, 2.11, NULL, 'SAE 75W', 'HaynesPro typeId t_63060; 1.8 20V Turbo; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'AWP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'engine_oil', (SELECT id FROM engines WHERE code = 'AUM'), 4.6, 4.86, '5W-30', 'VW 502 00', 'HaynesPro typeId t_50730; 1.8 20V Turbo; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'AUM'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'coolant', (SELECT id FROM engines WHERE code = 'AUM'), 7, 7.4, NULL, '(De-ionised water with 40% anti-freeze)', 'HaynesPro typeId t_50730; 1.8 20V Turbo'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'AUM'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'transmission_mt', (SELECT id FROM engines WHERE code = 'AUM'), 2, 2.11, NULL, 'SAE 75W', 'HaynesPro typeId t_50730; 1.8 20V Turbo; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'AUM'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'engine_oil', (SELECT id FROM engines WHERE code = 'BFV'), 4.6, 4.86, '0W-30', 'VW 502 00', 'HaynesPro typeId t_49370; 1.8 20V Turbo; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BFV'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'coolant', (SELECT id FROM engines WHERE code = 'BFV'), 7, 7.4, NULL, '(De-ionised water with 40% anti-freeze)', 'HaynesPro typeId t_49370; 1.8 20V Turbo'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BFV'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'transmission_mt', (SELECT id FROM engines WHERE code = 'BFV'), 2.6, 2.75, NULL, 'SAE 75W', 'HaynesPro typeId t_49370; 1.8 20V Turbo; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'BFV'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'engine_oil', (SELECT id FROM engines WHERE code = 'BVR'), 4.6, 4.86, '0W-30', 'VW 502 00', 'HaynesPro typeId t_50440; 1.8 20V Turbo; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BVR'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'coolant', (SELECT id FROM engines WHERE code = 'BVR'), 7, 7.4, NULL, '(De-ionised water with 40% anti-freeze)', 'HaynesPro typeId t_50440; 1.8 20V Turbo'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BVR'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'transmission_mt', (SELECT id FROM engines WHERE code = 'BVR'), 2, 2.11, NULL, 'SAE 75W', 'HaynesPro typeId t_50440; 1.8 20V Turbo; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'BVR'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'engine_oil', (SELECT id FROM engines WHERE code = 'BVP'), 4.6, 4.86, '0W-30', 'VW 502 00', 'HaynesPro typeId t_50680; 1.8 20V Turbo; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BVP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'coolant', (SELECT id FROM engines WHERE code = 'BVP'), 7, 7.4, NULL, '(De-ionised water with 40% anti-freeze)', 'HaynesPro typeId t_50680; 1.8 20V Turbo'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BVP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'transmission_mt', (SELECT id FROM engines WHERE code = 'BVP'), 2, 2.11, NULL, 'SAE 75W', 'HaynesPro typeId t_50680; 1.8 20V Turbo; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'BVP'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'engine_oil', (SELECT id FROM engines WHERE code = 'BHE'), 5.5, 5.81, '5W-30', 'VW 502 00', 'HaynesPro typeId t_50720; 3.2 V6; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BHE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'coolant', (SELECT id FROM engines WHERE code = 'BHE'), 7, 7.4, NULL, '(De-ionised water with 40% anti-freeze)', 'HaynesPro typeId t_50720; 3.2 V6'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BHE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'transmission_dct', (SELECT id FROM engines WHERE code = 'BHE'), 5.2, 5.49, NULL, 'SAE 75W', 'HaynesPro typeId t_50720; 3.2 V6; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'BHE'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'engine_oil', (SELECT id FROM engines WHERE code = 'BPF'), 5.5, 5.81, '5W-30', 'VW 502 00', 'HaynesPro typeId t_63080; 3.2 V6; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'BPF'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'coolant', (SELECT id FROM engines WHERE code = 'BPF'), 7, 7.4, NULL, '(De-ionised water with 40% anti-freeze)', 'HaynesPro typeId t_63080; 3.2 V6'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'BPF'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'transmission_dct', (SELECT id FROM engines WHERE code = 'BPF'), 5.5, 5.81, NULL, 'SAE 75W', 'HaynesPro typeId t_63080; 3.2 V6; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'BPF'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 297, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4', 'HaynesPro chassis d_420;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 297 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (297)
  AND e.code IN ('BEA', 'APX', 'AJQ', 'APP', 'ATC', 'AMU', 'BAM', 'ARY', 'AUQ', 'AWP', 'AUM', 'BFV', 'BVR', 'BVP', 'BHE', 'BPF')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (297)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (297) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;