-- Trim-level dimensions per herstructureringsplan Fase 1.3.
--
-- Some dimensions vary across trims within a generation: an M-package option
-- changes width, an xDrive variant raises ride height, sport bumpers extend
-- length, larger wheels change ground clearance / turning circle. Until now
-- we stored only one set of values per generation, which means the gen-page
-- showed "Length 4624 mm" when actually trims range 4624–4633 mm.
--
-- These columns are nullable; the gen-page falls back to its own length_mm
-- when no trim overrides exist. When 2+ trims have values that differ, the
-- gen-page renders a range and links to the trim page for the exact value.
--
-- All values reuse generations.* unit conventions (mm, kg). Cd is a
-- dimensionless drag coefficient; turning circle is curb-to-curb in metres.

SET NAMES utf8mb4;

ALTER TABLE trims
  ADD COLUMN length_mm           SMALLINT UNSIGNED NULL AFTER rim_size,
  ADD COLUMN width_mm            SMALLINT UNSIGNED NULL AFTER length_mm,
  ADD COLUMN height_mm           SMALLINT UNSIGNED NULL AFTER width_mm,
  ADD COLUMN wheelbase_mm        SMALLINT UNSIGNED NULL AFTER height_mm,
  ADD COLUMN front_track_mm      SMALLINT UNSIGNED NULL AFTER wheelbase_mm,
  ADD COLUMN rear_track_mm       SMALLINT UNSIGNED NULL AFTER front_track_mm,
  ADD COLUMN ground_clearance_mm SMALLINT UNSIGNED NULL AFTER rear_track_mm,
  ADD COLUMN drag_coefficient    DECIMAL(4,3)      NULL AFTER ground_clearance_mm,
  ADD COLUMN turning_circle_m    DECIMAL(4,2)      NULL AFTER drag_coefficient;
