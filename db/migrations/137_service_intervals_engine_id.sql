-- Add engine_id to service_intervals so trim pages can filter the schedule
-- by the trim's engine. NULL engine_id = "applies to every engine in the gen"
-- (e.g. tire rotation, brake fluid flush, cabin air filter).
--
-- For engine-specific rows whose service name already encodes the engine
-- (e.g. spark_plugs on a HEMI vs a V6), this migration populates engine_id.
-- Where one service interval applies to multiple specific engines, we
-- duplicate the row, one per engine_id.

SET NAMES utf8mb4;

-- =========================================================================
-- Schema change
-- =========================================================================
ALTER TABLE service_intervals
  ADD COLUMN engine_id INT UNSIGNED NULL AFTER trim_id,
  ADD CONSTRAINT fk_service_intervals_engine FOREIGN KEY (engine_id) REFERENCES engines(id),
  ADD KEY ix_service_intervals_engine (engine_id);

-- =========================================================================
-- Charger LX (gen 123) — engine IDs: 212 (2.7), 213 (3.5), 166 (5.7), 214 (6.1 SRT8)
-- =========================================================================
UPDATE service_intervals SET engine_id = 166 WHERE generation_id = 123 AND service = 'spark_plugs';
UPDATE service_intervals SET engine_id = 213 WHERE generation_id = 123 AND service = 'timing_belt';
UPDATE service_intervals SET engine_id = 212 WHERE generation_id = 123 AND service = 'accessory_drive_belt';

-- spark_plugs_v6_srt applies to three engines (2.7, 3.5, 6.1 SRT8) — duplicate
-- so each gets its own engine-scoped row, then drop the original.
INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes)
  SELECT generation_id, 212 AS engine_id, 'spark_plugs', miles_normal, miles_severe, km_normal, km_severe, months,
         CONCAT('2.7L EER V6. ', COALESCE(notes,''))
    FROM service_intervals WHERE generation_id = 123 AND service = 'spark_plugs_v6_srt';
INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes)
  SELECT generation_id, 213 AS engine_id, 'spark_plugs', miles_normal, miles_severe, km_normal, km_severe, months,
         CONCAT('3.5L EGG V6. ', COALESCE(notes,''))
    FROM service_intervals WHERE generation_id = 123 AND service = 'spark_plugs_v6_srt';
INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes)
  SELECT generation_id, 214 AS engine_id, 'spark_plugs', miles_normal, miles_severe, km_normal, km_severe, months,
         CONCAT('6.1L 392 HEMI SRT8 V8. ', COALESCE(notes,''))
    FROM service_intervals WHERE generation_id = 123 AND service = 'spark_plugs_v6_srt';
-- Carry over citations from the original row to the new rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'service_intervals', si_new.id, ss.source_id
    FROM service_intervals si_new
    JOIN service_intervals si_old ON si_old.generation_id = 123 AND si_old.service = 'spark_plugs_v6_srt'
    JOIN spec_sources ss ON ss.spec_table='service_intervals' AND ss.spec_id = si_old.id
   WHERE si_new.generation_id = 123 AND si_new.service = 'spark_plugs' AND si_new.engine_id IN (212, 213, 214);
DELETE FROM spec_sources WHERE spec_table='service_intervals' AND spec_id IN (SELECT id FROM (SELECT id FROM service_intervals WHERE generation_id=123 AND service='spark_plugs_v6_srt') AS x);
DELETE FROM service_intervals WHERE generation_id = 123 AND service = 'spark_plugs_v6_srt';

-- =========================================================================
-- Chrysler 300 LX (gen 124) — same engines as Charger LX
-- =========================================================================
UPDATE service_intervals SET engine_id = 166 WHERE generation_id = 124 AND service = 'spark_plugs_hemi';
-- Rename hemi-specific row to canonical 'spark_plugs' name
UPDATE service_intervals SET service = 'spark_plugs' WHERE generation_id = 124 AND service = 'spark_plugs_hemi';

UPDATE service_intervals SET engine_id = 213 WHERE generation_id = 124 AND service = 'timing_belt';
UPDATE service_intervals SET engine_id = 212 WHERE generation_id = 124 AND service = 'accessory_drive_belt';

INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes)
  SELECT generation_id, 212, 'spark_plugs', miles_normal, miles_severe, km_normal, km_severe, months,
         CONCAT('2.7L EER V6. ', COALESCE(notes,''))
    FROM service_intervals WHERE generation_id = 124 AND service = 'spark_plugs_v6_srt';
INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes)
  SELECT generation_id, 213, 'spark_plugs', miles_normal, miles_severe, km_normal, km_severe, months,
         CONCAT('3.5L EGG V6. ', COALESCE(notes,''))
    FROM service_intervals WHERE generation_id = 124 AND service = 'spark_plugs_v6_srt';
INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes)
  SELECT generation_id, 214, 'spark_plugs', miles_normal, miles_severe, km_normal, km_severe, months,
         CONCAT('6.1L 392 HEMI SRT8 V8. ', COALESCE(notes,''))
    FROM service_intervals WHERE generation_id = 124 AND service = 'spark_plugs_v6_srt';
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'service_intervals', si_new.id, ss.source_id
    FROM service_intervals si_new
    JOIN service_intervals si_old ON si_old.generation_id = 124 AND si_old.service = 'spark_plugs_v6_srt'
    JOIN spec_sources ss ON ss.spec_table='service_intervals' AND ss.spec_id = si_old.id
   WHERE si_new.generation_id = 124 AND si_new.service = 'spark_plugs' AND si_new.engine_id IN (212, 213, 214);
DELETE FROM spec_sources WHERE spec_table='service_intervals' AND spec_id IN (SELECT id FROM (SELECT id FROM service_intervals WHERE generation_id=124 AND service='spark_plugs_v6_srt') AS x);
DELETE FROM service_intervals WHERE generation_id = 124 AND service = 'spark_plugs_v6_srt';

-- =========================================================================
-- Charger LD (gen 122) — engines per its trims: only 5.7 HEMI (eid 166)
-- has a distinct spark plug interval (every 30k mi); the other engines
-- share the gen-wide oil-change-coupled schedule. Mark spark_plugs as
-- engine-scoped to 166.
-- =========================================================================
UPDATE service_intervals SET engine_id = 166 WHERE generation_id = 122 AND service = 'spark_plugs';

-- =========================================================================
-- Verification
-- =========================================================================
SELECT 'service_intervals engine_id added' AS status,
       (SELECT COUNT(*) FROM service_intervals WHERE engine_id IS NOT NULL) AS engine_scoped_rows,
       (SELECT COUNT(*) FROM service_intervals WHERE engine_id IS NULL) AS gen_wide_rows,
       (SELECT COUNT(*) FROM service_intervals) AS total;
