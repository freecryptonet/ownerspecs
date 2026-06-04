-- 568: Citroën C3 III (gen 524) core moat. PSA PF1/CMP supermini — PureTech 1.2
-- (NA EB2F 3.25 L / turbo EB2DT 3.5 L, 5W-30 B71 2297), BlueHDi 1.5 DV5 (4.0 L,
-- 5W-30) + 1.6 DV6 (3.75 L, 0W-30 B71 2312). Source 1716. Fuses + maintenance deferred.

SET @src := 1716;
DELETE FROM fluid_specs WHERE generation_id = 524 AND viscosity IS NULL AND spec_standard IS NULL;

-- engine_oil per family
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, viscosity, spec_standard, capacity_l, notes) VALUES
  (524, 2229, 'engine_oil', 'SAE 5W-30', 'STELLANTIS FPW9.55535/03 (PSA B71 2297)', 3.50, 'PureTech 1.2 turbo; sump incl. filter'),
  (524, 2230, 'engine_oil', 'SAE 5W-30', 'STELLANTIS FPW9.55535/03 (PSA B71 2297)', 3.50, 'PureTech 1.2 turbo; sump incl. filter'),
  (524, 2231, 'engine_oil', 'SAE 5W-30', 'STELLANTIS FPW9.55535/03 (PSA B71 2297)', 3.25, 'PureTech 1.2 NA; sump incl. filter; drain 42 N·m'),
  (524, 2232, 'engine_oil', 'SAE 5W-30', 'STELLANTIS FPW9.55535/03 (PSA B71 2297)', 3.25, 'PureTech 1.2 NA; sump incl. filter; drain 42 N·m'),
  (524, 2233, 'engine_oil', 'SAE 5W-30', 'STELLANTIS FPW9.55535/03 (PSA B71 2297)', 3.25, 'PureTech 1.2 NA; sump incl. filter; drain 42 N·m'),
  (524, 2234, 'engine_oil', 'SAE 5W-30', 'STELLANTIS FPW9.55535/03 (PSA B71 2297)', 3.25, 'PureTech 1.2 NA; sump incl. filter; drain 42 N·m'),
  (524, 2212, 'engine_oil', 'SAE 5W-30', 'STELLANTIS FPW9.55535/03 (PSA B71 2297)', 4.00, 'BlueHDi 1.5 DV5; sump incl. filter; drain 34 N·m'),
  (524, 2226, 'engine_oil', 'SAE 0W-30', 'STELLANTIS FPW9.55535/02 (PSA B71 2312)', 3.75, 'BlueHDi 1.6 DV6; sump incl. filter; drain 34 N·m'),
  (524, 2228, 'engine_oil', 'SAE 0W-30', 'STELLANTIS FPW9.55535/02 (PSA B71 2312)', 3.75, 'BlueHDi 1.6 DV6; sump incl. filter; drain 34 N·m');

INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, spec_standard, notes)
  SELECT 524, e.id, 'coolant', 'PSA B71 5110', 'OAT long-life coolant'
  FROM engines e WHERE e.id IN (2229,2230,2231,2232,2233,2234,2212,2226,2228);

INSERT INTO fluid_specs (generation_id, fluid_type, viscosity, spec_standard, capacity_l, notes) VALUES
  (524, 'brake', NULL, 'DOT 4 LV', 1.00, 'Brake/clutch system total'),
  (524, 'transmission_mt', 'SAE 75W', 'PSA B71 2316', NULL, '5-speed manual (MA)');
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, spec_standard, notes)
  SELECT 524, e.id, 'def_fluid', 'ISO 22241 (AUS 32 / AdBlue)', 'SCR diesel exhaust fluid'
  FROM engines e WHERE e.id IN (2212,2226,2228);

INSERT INTO torque_specs (generation_id, engine_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (524, NULL, 'Wheel bolts', 100, 74, 'Alloy / aesthetic steel wheels; 110 N·m on plain steel wheels. Do not use power tools for final tightening'),
  (524, 2231, 'Engine oil drain plug', 42, 31, 'Steel sump (20 N·m alu)'),
  (524, 2229, 'Engine oil drain plug', 42, 31, 'Steel sump (20 N·m alu)'),
  (524, 2212, 'Engine oil drain plug', 34, 25, NULL),
  (524, 2226, 'Engine oil drain plug', 34, 25, NULL);

INSERT INTO electrical_specs (generation_id, battery_group, ah) VALUES (524, 'AGM', 60);

INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (524, 'front', 'normal', 30.5, 210, '185/65 R15'),
  (524, 'front', 'full',   34.8, 240, '185/65 R15'),
  (524, 'rear',  'normal', 30.5, 210, '185/65 R15'),
  (524, 'rear',  'full',   34.8, 240, '185/65 R15');

INSERT INTO brake_specs (generation_id, axle, brake_type, disc_diameter_mm, disc_thickness_mm, disc_min_thickness_mm, pad_min_mm, drum_diameter_mm, drum_max_mm, notes) VALUES
  (524, 'front', 'disc_vented', 266.0, 22.0, 20.0, 2.0, NULL, NULL, 'Ventilated front discs'),
  (524, 'rear',  'disc_solid',  249.0,  9.0,  7.0, 2.0, NULL, NULL, 'Disc rear brakes'),
  (524, 'rear',  'drum',        NULL,  NULL, NULL, NULL, 203.0, 204.4, '8-inch drum rear brakes'),
  (524, 'rear',  'drum',        NULL,  NULL, NULL, NULL, 228.6, 229.8, '9-inch drum rear brakes');

INSERT INTO alignment_specs (generation_id, axle, camber, caster, toe, thrust_angle, notes) VALUES
  (524, 'front', '-0°42'' ± 0°30''', '4°18'' ± 0°30''', '0°12'' ± 0°08''', NULL, 'Geometry not adjustable.'),
  (524, 'rear',  '-1°41'' ± 0°30''', NULL, '0°40'' ± 0°08''', '0°00'' ± 0°30''', NULL);

INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id = 524;
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src FROM torque_specs WHERE generation_id = 524;
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id = 524;
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id = 524;
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'brake_specs', id, @src FROM brake_specs WHERE generation_id = 524;
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'alignment_specs', id, @src FROM alignment_specs WHERE generation_id = 524;
