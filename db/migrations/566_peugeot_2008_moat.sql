-- 566: Peugeot 2008 II (gen 522) core moat. PSA CMP SUV — PureTech 1.2 EB2 petrol
-- + 1.5 BlueHDi DV5 diesel (same engine families as 208/Corsa). Reuses gen source
-- 1691. Fuses + maintenance deferred.
-- Data-quality fix: engine 2218 (HNK EB2ADTD) is a petrol PureTech wrongly flagged
-- diesel by the scraper (attached to a BlueHDi trim) — correct its fuel.

SET @src := 1691;
UPDATE engines SET fuel = 'petrol' WHERE id = 2218 AND code = 'HNK EB2ADTD';

DELETE FROM fluid_specs WHERE generation_id = 522 AND viscosity IS NULL AND spec_standard IS NULL;

-- engine_oil: petrol 1.2 turbo (3.5 L) → 2213/2214/2218/2219 ; diesel 1.5 (4.0 L) → 2216/2217
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, viscosity, spec_standard, capacity_l, notes) VALUES
  (522, 2213, 'engine_oil', 'SAE 5W-30', 'STELLANTIS FPW9.55535/03 (PSA B71 2297)', 3.50, 'Sump incl. filter'),
  (522, 2214, 'engine_oil', 'SAE 5W-30', 'STELLANTIS FPW9.55535/03 (PSA B71 2297)', 3.50, 'Sump incl. filter'),
  (522, 2218, 'engine_oil', 'SAE 5W-30', 'STELLANTIS FPW9.55535/03 (PSA B71 2297)', 3.50, 'Sump incl. filter'),
  (522, 2219, 'engine_oil', 'SAE 5W-30', 'STELLANTIS FPW9.55535/03 (PSA B71 2297)', 3.50, 'Sump incl. filter'),
  (522, 2216, 'engine_oil', 'SAE 5W-30', 'STELLANTIS FPW9.55535/03 (PSA B71 2297)', 4.00, 'Sump incl. filter; drain plug 34 N·m'),
  (522, 2217, 'engine_oil', 'SAE 5W-30', 'STELLANTIS FPW9.55535/03 (PSA B71 2297)', 4.00, 'Sump incl. filter; drain plug 34 N·m');

-- coolant (engine-scoped, shared OAT spec)
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, spec_standard, notes) VALUES
  (522, 2213, 'coolant', 'PSA B71 5110', 'OAT long-life coolant'),
  (522, 2214, 'coolant', 'PSA B71 5110', 'OAT long-life coolant'),
  (522, 2218, 'coolant', 'PSA B71 5110', 'OAT long-life coolant'),
  (522, 2219, 'coolant', 'PSA B71 5110', 'OAT long-life coolant'),
  (522, 2216, 'coolant', 'PSA B71 5110', 'OAT long-life coolant'),
  (522, 2217, 'coolant', 'PSA B71 5110', 'OAT long-life coolant');

-- gen-wide
INSERT INTO fluid_specs (generation_id, fluid_type, viscosity, spec_standard, capacity_l, notes) VALUES
  (522, 'brake', NULL, 'DOT 4 LV', 1.00, 'Brake/clutch system total'),
  (522, 'transmission_at', NULL, NULL, NULL, '8-speed automatic (EAT8)');
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, spec_standard, notes) VALUES
  (522, 2216, 'def_fluid', 'ISO 22241 (AUS 32 / AdBlue)', 'SCR diesel exhaust fluid'),
  (522, 2217, 'def_fluid', 'ISO 22241 (AUS 32 / AdBlue)', 'SCR diesel exhaust fluid');

-- torques
INSERT INTO torque_specs (generation_id, engine_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (522, NULL, 'Wheel bolts', 100, 74, 'Alloy wheels; 115 N·m on steel wheels. Do not use power tools for final tightening'),
  (522, NULL, 'Oil filter housing', 16, 12, NULL),
  (522, 2213, 'Spark plugs', 22, 16, NULL),
  (522, 2214, 'Spark plugs', 22, 16, NULL),
  (522, 2219, 'Spark plugs', 22, 16, NULL),
  (522, 2216, 'Engine oil drain plug', 34, 25, NULL),
  (522, 2214, 'Cylinder head bolts (Stage 1)', 10, 7, 'Then Stage 2: 30 N·m (bolts 1-10) + 20 N·m (bolt 11); Stage 3: 230° angle. Renew bolts.');

INSERT INTO electrical_specs (generation_id, battery_group, ah) VALUES (522, 'AGM', 60);

-- tyres (215/65 R16 + 215/60 R17; range 2.2 normal → 2.7 full bar)
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (522, 'front', 'normal', 31.9, 220, '215/65 R16'),
  (522, 'front', 'full',   39.2, 270, '215/65 R16'),
  (522, 'rear',  'normal', 31.9, 220, '215/65 R16'),
  (522, 'rear',  'full',   39.2, 270, '215/65 R16'),
  (522, 'front', 'normal', 31.9, 220, '215/60 R17'),
  (522, 'front', 'full',   39.2, 270, '215/60 R17'),
  (522, 'rear',  'normal', 31.9, 220, '215/60 R17'),
  (522, 'rear',  'full',   39.2, 270, '215/60 R17');

-- brakes (all-disc SUV)
INSERT INTO brake_specs (generation_id, axle, brake_type, disc_diameter_mm, disc_thickness_mm, disc_min_thickness_mm, pad_min_mm, notes) VALUES
  (522, 'front', 'disc_vented', 283.0, 26.0, 24.0, 2.0, 'Base brake package'),
  (522, 'front', 'disc_vented', 302.0, 26.0, 24.0, 2.0, 'Larger brake package'),
  (522, 'rear',  'disc_solid',  249.0,  9.0,  7.0, 2.0, 'Base rear discs'),
  (522, 'rear',  'disc_solid',  268.0, 12.0, 10.0, 2.0, 'Larger rear discs');

-- alignment
INSERT INTO alignment_specs (generation_id, axle, camber, caster, toe, thrust_angle, notes) VALUES
  (522, 'front', '-0°33'' ± 0°30''', '5°24'' ± 0°30''', '0°12'' ± 0°08''', NULL, 'Geometry not adjustable.'),
  (522, 'rear',  '-1°44'' ± 0°30''', NULL, '0°44'' ± 0°08''', '0°00'' ± 0°30''', NULL);

-- citations
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id = 522;
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src FROM torque_specs WHERE generation_id = 522;
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id = 522;
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id = 522;
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'brake_specs', id, @src FROM brake_specs WHERE generation_id = 522;
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'alignment_specs', id, @src FROM alignment_specs WHERE generation_id = 522;
