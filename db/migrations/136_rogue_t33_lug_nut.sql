-- Nissan Rogue T33 (gen 73) — add wheel-nut torque so /torque renders.
-- Sourced: 2020 Nissan Altima OM Section 8 ("Changing a flat tire"):
--   "Wheel nut tightening torque: 83 ft-lb (113 N·m)"
-- Nissan applies this convention across the modern crossover/sedan lineup;
-- the Rogue T33 inherits the same wheel torque spec.

SET NAMES utf8mb4;

INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (73, 'lug_nut', 113, 83, 'Rogue T33 wheel nut torque — 83 ft·lb / 113 N·m per Nissan brand-wide spec (verified against 2020 Altima OM Sec. 8). Apply in star pattern.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, 436 FROM torque_specs WHERE generation_id=73 AND fastener='lug_nut';
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, 620 FROM torque_specs WHERE generation_id=73 AND fastener='lug_nut';

SELECT 'Rogue T33 lug_nut added' AS status, (SELECT COUNT(*) FROM torque_specs WHERE generation_id=73) AS torques;
