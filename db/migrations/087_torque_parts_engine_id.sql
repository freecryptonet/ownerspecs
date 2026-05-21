-- Phase 2 of the engine-scoping refactor: torque_specs + parts.
--
-- Background (2026-05-21, see STRUCTURE.md):
-- After splitting fluid_specs by engine in migrations 083-086, the same
-- problem exists for torque_specs (spark plug torque, oil drain torque,
-- head bolt torque all differ per engine) and parts (oil filter PN,
-- spark plug PN, air filter PN all differ per engine).
--
-- Examples that already break for Charger LD:
--   spark_plug torque  3.6 V6 = 13 N·m / 5.7 HEMI = 18 N·m / 6.4 = 18 N·m / 6.2 SC = 18 N·m
--   oil_drain torque   3.6 V6 = 27 N·m / HEMI all = 34 N·m
--   spark_plug PN      3.6 V6 = NGK ILZKAR7B11 / HEMI all = NGK LTR8IX-11
--   oil_filter PN      3.6 V6 = MO-090 / HEMI all = MO-899
--
-- Existing rows stay engine_id NULL until a per-gen pass backfills them.
-- Interpretation of NULL: "applies to all engines in this gen" (true for
-- single-engine gens; provisional for multi-engine gens awaiting backfill).

SET NAMES utf8mb4;

-- torque_specs
ALTER TABLE torque_specs
  ADD COLUMN engine_id INT UNSIGNED NULL AFTER trim_id;

ALTER TABLE torque_specs
  ADD CONSTRAINT fk_torque_specs_engine
  FOREIGN KEY (engine_id) REFERENCES engines(id)
  ON DELETE SET NULL ON UPDATE CASCADE;

CREATE INDEX idx_torque_specs_engine ON torque_specs(engine_id);

-- parts
ALTER TABLE parts
  ADD COLUMN engine_id INT UNSIGNED NULL AFTER trim_id;

ALTER TABLE parts
  ADD CONSTRAINT fk_parts_engine
  FOREIGN KEY (engine_id) REFERENCES engines(id)
  ON DELETE SET NULL ON UPDATE CASCADE;

CREATE INDEX idx_parts_engine ON parts(engine_id);

-- Verification: report how many existing rows are now provisionally NULL.
SELECT 'torque_specs.engine_id added' AS status,
       (SELECT COUNT(*) FROM torque_specs) AS rows_total,
       (SELECT COUNT(*) FROM torque_specs WHERE engine_id IS NULL) AS rows_gen_wide
UNION ALL
SELECT 'parts.engine_id added',
       (SELECT COUNT(*) FROM parts),
       (SELECT COUNT(*) FROM parts WHERE engine_id IS NULL);
