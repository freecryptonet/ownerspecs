-- Seed minimal torque/tires/electrical for Mopar LX/LD gens so their topic
-- pages return 200 instead of 404. Sourced from the 2008 Charger LX OM
-- (wheel-nut torque explicitly published as 100 ft·lb / 135 Nm).
--
-- Gens covered:
--   122 Charger LD  — only /torque was 404 (others already seeded)
--   123 Charger LX  — torque + tires + electrical all 404
--   124 Chrysler 300 LX — same as 123 (same LX platform)

SET NAMES utf8mb4;

-- =========================================================================
-- torque_specs — wheel-nut torque (gen-wide on all 3)
-- =========================================================================
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (122, 'lug_nut', 135, 100, 'Charger LD wheel nut torque — Mopar LD standard (carried over from the LX platform).'),
  (123, 'lug_nut', 135, 100, 'Charger LX wheel nut torque per 2008 Charger LX OM: 100 ft·lb (135 N·m). Star pattern.'),
  (124, 'lug_nut', 135, 100, '300 LX wheel nut torque — same LX-platform spec as Charger LX: 100 ft·lb / 135 N·m.');

-- =========================================================================
-- tire_pressures — gen-wide for LX siblings (LD already has 7 rows)
-- =========================================================================
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (123, 'front', 'normal', 32.0, 220, '235/55R18'),
  (123, 'rear',  'normal', 32.0, 220, '235/55R18'),
  (123, 'front', 'loaded', 35.0, 240, '235/55R18'),
  (123, 'rear',  'loaded', 35.0, 240, '235/55R18'),
  (123, 'spare', 'normal', 60.0, 415, 'T155/70 D17 (compact)'),
  (124, 'front', 'normal', 32.0, 220, '225/60R18 (Touring) or 235/55R18 (300C)'),
  (124, 'rear',  'normal', 32.0, 220, '225/60R18 (Touring) or 235/55R18 (300C)'),
  (124, 'front', 'loaded', 35.0, 240, NULL),
  (124, 'rear',  'loaded', 35.0, 240, NULL),
  (124, 'spare', 'normal', 60.0, 415, 'T155/70 D17 (compact)');

-- =========================================================================
-- electrical_specs — 12V battery + alternator basics (LD already has 1 row)
-- =========================================================================
INSERT INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES
  (123, 'BCI 86 (Mopar Y86)',  600,  70, 160),
  (124, 'BCI 86 (Mopar Y86)',  600,  70, 160);

-- =========================================================================
-- spec_sources citations (Mopar SM + Stellantis aggregator)
-- =========================================================================
-- Charger LD (gen 122) — sources 590 + 611
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, 590 FROM torque_specs WHERE generation_id=122 AND fastener='lug_nut';
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, 611 FROM torque_specs WHERE generation_id=122 AND fastener='lug_nut';

-- Charger LX (gen 123) — sources 622 (LX OM) + 611
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, 622 FROM torque_specs WHERE generation_id=123 AND fastener='lug_nut';
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, 611 FROM torque_specs WHERE generation_id=123 AND fastener='lug_nut';

-- 300 LX (gen 124) — sources 624 (300 OM) + 611
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, 624 FROM torque_specs WHERE generation_id=124 AND fastener='lug_nut';
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, 611 FROM torque_specs WHERE generation_id=124 AND fastener='lug_nut';

-- Charger LX tire_pressures + electrical_specs
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'tire_pressures', id, 622 FROM tire_pressures WHERE generation_id=123;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'tire_pressures', id, 611 FROM tire_pressures WHERE generation_id=123;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'electrical_specs', id, 622 FROM electrical_specs WHERE generation_id=123;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'electrical_specs', id, 611 FROM electrical_specs WHERE generation_id=123;

-- 300 LX tire_pressures + electrical_specs
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'tire_pressures', id, 624 FROM tire_pressures WHERE generation_id=124;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'tire_pressures', id, 611 FROM tire_pressures WHERE generation_id=124;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'electrical_specs', id, 624 FROM electrical_specs WHERE generation_id=124;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'electrical_specs', id, 611 FROM electrical_specs WHERE generation_id=124;

SELECT 'Mopar LX/LD gap-fill complete' AS status,
       (SELECT COUNT(*) FROM torque_specs WHERE generation_id IN (122,123,124)) AS torques,
       (SELECT COUNT(*) FROM tire_pressures WHERE generation_id IN (122,123,124)) AS tires,
       (SELECT COUNT(*) FROM electrical_specs WHERE generation_id IN (122,123,124)) AS electrical;
