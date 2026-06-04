-- 569: Citroën C4 III (gen 525) core moat. EMP2 — PureTech 1.2 turbo (3.5 L,
-- 5W-30 B71 2297, incl. 48V mild-hybrid 1.2) + BlueHDi 1.5 DV5 (4.0 L, 5W-30).
-- e-C4 BEV trims have no ICE engine; their EV moat is deferred (see EV data model).
-- Source 1729. Fuses + maintenance deferred.

SET @src := 1729;
DELETE FROM fluid_specs WHERE generation_id = 525 AND viscosity IS NULL AND spec_standard IS NULL;

-- engine_oil per family: EB2 1.2 turbo (2214,2219,2235,2236) 3.5 L; DV5 1.5 (2216,2217) 4.0 L
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, viscosity, spec_standard, capacity_l, notes) VALUES
  (525, 2214, 'engine_oil', 'SAE 5W-30', 'STELLANTIS FPW9.55535/03 (PSA B71 2297)', 3.50, 'PureTech 1.2 turbo; sump incl. filter'),
  (525, 2219, 'engine_oil', 'SAE 5W-30', 'STELLANTIS FPW9.55535/03 (PSA B71 2297)', 3.50, 'PureTech 1.2 turbo; sump incl. filter'),
  (525, 2235, 'engine_oil', 'SAE 5W-30', 'STELLANTIS FPW9.55535/03 (PSA B71 2297)', 3.50, 'PureTech 1.2 turbo; sump incl. filter'),
  (525, 2236, 'engine_oil', 'SAE 5W-30', 'STELLANTIS FPW9.55535/03 (PSA B71 2297)', 3.50, 'PureTech 1.2 48V mild hybrid; sump incl. filter'),
  (525, 2216, 'engine_oil', 'SAE 5W-30', 'STELLANTIS FPW9.55535/03 (PSA B71 2297)', 4.00, 'BlueHDi 1.5 DV5; sump incl. filter; drain 34 N·m'),
  (525, 2217, 'engine_oil', 'SAE 5W-30', 'STELLANTIS FPW9.55535/03 (PSA B71 2297)', 4.00, 'BlueHDi 1.5 DV5; sump incl. filter; drain 34 N·m');

INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, spec_standard, notes)
  SELECT 525, e.id, 'coolant', 'PSA B71 5110', 'OAT long-life coolant'
  FROM engines e WHERE e.id IN (2214,2219,2235,2236,2216,2217);

INSERT INTO fluid_specs (generation_id, fluid_type, viscosity, spec_standard, capacity_l, notes) VALUES
  (525, 'brake', NULL, 'DOT 4 LV', 1.00, 'Brake/clutch system total'),
  (525, 'transmission_mt', 'SAE 75W', 'PSA B71 2316', NULL, '6-speed manual'),
  (525, 'transmission_at', NULL, NULL, NULL, '8-speed automatic (EAT8)');
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, spec_standard, notes)
  SELECT 525, e.id, 'def_fluid', 'ISO 22241 (AUS 32 / AdBlue)', 'SCR diesel exhaust fluid'
  FROM engines e WHERE e.id IN (2216,2217);

INSERT INTO torque_specs (generation_id, engine_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (525, NULL, 'Wheel bolts', 115, 85, 'Alloy wheels; 130 N·m on steel wheels. Do not use power tools for final tightening'),
  (525, 2214, 'Engine oil drain plug', 42, 31, 'Steel sump (20 N·m alu)'),
  (525, 2216, 'Engine oil drain plug', 34, 25, NULL);

INSERT INTO electrical_specs (generation_id, battery_group, ah) VALUES (525, 'AGM', 60);

INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (525, 'front', 'normal', 30.5, 210, '215/65 R16'),
  (525, 'front', 'full',   36.3, 250, '215/65 R16'),
  (525, 'rear',  'normal', 30.5, 210, '215/65 R16'),
  (525, 'rear',  'full',   39.2, 270, '215/65 R16');

INSERT INTO brake_specs (generation_id, axle, brake_type, disc_diameter_mm, disc_thickness_mm, disc_min_thickness_mm, pad_min_mm, notes) VALUES
  (525, 'front', 'disc_vented', 302.0, 26.0, 24.0, 2.0, 'Ventilated front discs'),
  (525, 'rear',  'disc_solid',  249.0,  9.0,  7.0, 2.0, 'Disc rear brakes');

INSERT INTO alignment_specs (generation_id, axle, camber, caster, toe, thrust_angle, notes) VALUES
  (525, 'front', '-0°38'' ± 0°30''', '5°30'' ± 0°30''', '0°12'' ± 0°08''', NULL, 'Geometry not adjustable.'),
  (525, 'rear',  '-1°46'' ± 0°30''', NULL, '0°46'' ± 0°08''', '0°00'' ± 0°30''', NULL);

INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id = 525;
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src FROM torque_specs WHERE generation_id = 525;
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id = 525;
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id = 525;
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'brake_specs', id, @src FROM brake_specs WHERE generation_id = 525;
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'alignment_specs', id, @src FROM alignment_specs WHERE generation_id = 525;
