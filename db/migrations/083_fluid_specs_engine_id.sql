-- Phase 1 of the engine-scoped fluid_specs refactor.
--
-- Background (2026-05-21): Tim flagged that the gen overview page shows
-- one row per (gen, fluid_type), but the spec actually depends on the
-- engine within the generation. Charger LD example:
--   3.6 Pentastar V6:  5.6 L oil 5W-20 MS-6395
--   5.7 HEMI V8 R/T:   6.6 L oil 5W-20 MS-6395
--   6.4 HEMI 392:      6.5 L oil 0W-40 MS-13340
--   6.2 Hellcat SC:    6.6 L oil 0W-40 MS-13340
-- A single row can't represent that.
--
-- This migration adds the column. Subsequent migrations populate
-- per-engine rows for multi-engine gens. Existing rows stay engine_id
-- NULL initially — interpreted as "applies to all engines in this gen"
-- (correct for single-engine gens, partially correct for
-- multi-engine ones until backfilled).
--
-- Same scoping pattern will likely roll out to torque_specs (spark plug
-- torque differs by engine), parts (oil filter / spark plug PN differs),
-- and possibly service_intervals (severe-duty cycles for diesel vs gas).

SET NAMES utf8mb4;

ALTER TABLE fluid_specs
  ADD COLUMN engine_id INT UNSIGNED NULL AFTER trim_id;

ALTER TABLE fluid_specs
  ADD CONSTRAINT fk_fluid_specs_engine
  FOREIGN KEY (engine_id) REFERENCES engines(id)
  ON DELETE SET NULL ON UPDATE CASCADE;

CREATE INDEX idx_fluid_specs_engine ON fluid_specs(engine_id);

SELECT 'fluid_specs.engine_id added' AS status,
       (SELECT COUNT(*) FROM fluid_specs) AS rows_total,
       (SELECT COUNT(*) FROM fluid_specs WHERE engine_id IS NULL) AS rows_gen_wide;
