-- 560: First brake_specs + alignment_specs data — Opel Astra K (gen 519) and
-- Audi Q2 GA (gen 354). Brakes & wheel-geometry are chassis-level (shared across
-- the gen's engines), so rows are gen-wide (no engine_id/trim_id). Restated from
-- workshop adjustment data; vendor-neutral sources (Astra K=1681, Q2=817), both
-- is_public=1 / public_link=0. Degrees-minutes alignment values kept verbatim as
-- the manufacturer publishes them.

SET @astra := 1681;
SET @q2 := 817;

-- ───────────────────────── Opel Astra K (gen 519) ─────────────────────────
INSERT INTO brake_specs
  (generation_id, axle, brake_type, disc_diameter_mm, disc_thickness_mm, disc_min_thickness_mm, pad_min_mm, notes)
VALUES
  (519, 'front', 'disc_vented', 276.0, 26.0, 23.0, 1.5, 'Base brake package (276 mm front); new pad 13.0 mm'),
  (519, 'front', 'disc_vented', 300.0, 26.0, 23.0, 1.5, '16-inch wheel package (300 mm front); new pad 13.0 mm'),
  (519, 'rear',  'disc_solid',  264.0, 10.0,  8.0, 1.5, 'Base brake package (264 mm rear); new pad 10.0 mm'),
  (519, 'rear',  'disc_solid',  288.0, 12.0, 10.0, 1.5, '16-inch wheel package (288 mm rear); new pad 10.0 mm');

INSERT INTO alignment_specs
  (generation_id, axle, camber, caster, toe, thrust_angle, notes)
VALUES
  (519, 'front', NULL, NULL, '1°30'' (toe-out on turns, 20°)', NULL, 'Static front toe-in, camber and caster not published in the workshop adjustment data.'),
  (519, 'rear',  '-1°18'' ± 0°30''', NULL, '0°06'' ± 0°24''', '0°00'' ± 0°18''', NULL);

-- ───────────────────────── Audi Q2 GA (gen 354) ───────────────────────────
INSERT INTO brake_specs
  (generation_id, axle, brake_type, disc_diameter_mm, disc_thickness_mm, disc_min_thickness_mm, pad_min_mm, notes)
VALUES
  (354, 'front', 'disc_vented', 312.0, 25.0, 22.0, 10.0, 'Equipment code 1ZB / 1ZA / 1ZK / 1ZU; pad minimum incl. backplate'),
  (354, 'rear',  'disc_solid',  272.0, 10.0,  8.0,  9.0, 'Equipment code 2EJ / 1KE / 2EL / 2EC / 1KR; pad minimum incl. backplate');

INSERT INTO alignment_specs
  (generation_id, axle, camber, caster, toe, thrust_angle, notes)
VALUES
  (354, 'front', '-0°21'' ± 0°30''', '7°11'' ± 0°30''', '0°10'' ± 0°10''', NULL, 'Standard suspension; toe-out on turns (20°) 1°10'' ± 0°20''.'),
  (354, 'rear',  '-1°00'' ± 0°10''', NULL, '0°16'' ± 0°12''', '0°20''', 'Standard suspension.');

-- ───────────────────────── citations (polymorphic) ────────────────────────
INSERT INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'brake_specs', id, @astra FROM brake_specs WHERE generation_id = 519;
INSERT INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'alignment_specs', id, @astra FROM alignment_specs WHERE generation_id = 519;
INSERT INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'brake_specs', id, @q2 FROM brake_specs WHERE generation_id = 354;
INSERT INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'alignment_specs', id, @q2 FROM alignment_specs WHERE generation_id = 354;
