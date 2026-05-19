-- ownerspecs.com · schema v0.2 · dimensions, capacities, chassis text fields
-- Backfills hand-seeded Civic & Camry generations from the original mockup data.

SET NAMES utf8mb4;

-- ===================================================================
-- generations: gen-wide dimensions + capacities + chassis text
-- ===================================================================

ALTER TABLE generations
  ADD COLUMN length_mm        SMALLINT UNSIGNED NULL AFTER layout,
  ADD COLUMN width_mm         SMALLINT UNSIGNED NULL AFTER length_mm,
  ADD COLUMN height_mm        SMALLINT UNSIGNED NULL AFTER width_mm,
  ADD COLUMN wheelbase_mm     SMALLINT UNSIGNED NULL AFTER height_mm,
  ADD COLUMN front_track_mm   SMALLINT UNSIGNED NULL AFTER wheelbase_mm,
  ADD COLUMN rear_track_mm    SMALLINT UNSIGNED NULL AFTER front_track_mm,
  ADD COLUMN fuel_tank_l      DECIMAL(4,1) UNSIGNED NULL AFTER rear_track_mm,
  ADD COLUMN cargo_l          SMALLINT UNSIGNED NULL AFTER fuel_tank_l,
  ADD COLUMN front_suspension VARCHAR(128) NULL AFTER cargo_l,
  ADD COLUMN rear_suspension  VARCHAR(128) NULL AFTER front_suspension,
  ADD COLUMN front_brakes     VARCHAR(96)  NULL AFTER rear_suspension,
  ADD COLUMN rear_brakes      VARCHAR(96)  NULL AFTER front_brakes;

-- ===================================================================
-- trims: trim-specific weights, drivetrain, tires
-- ===================================================================

ALTER TABLE trims
  ADD COLUMN max_weight_kg       SMALLINT UNSIGNED NULL AFTER curb_weight_kg,
  ADD COLUMN trailer_braked_kg   SMALLINT UNSIGNED NULL AFTER max_weight_kg,
  ADD COLUMN trailer_unbraked_kg SMALLINT UNSIGNED NULL AFTER trailer_braked_kg,
  ADD COLUMN drive_wheel         VARCHAR(16) NULL AFTER trailer_unbraked_kg,
  ADD COLUMN tire_size           VARCHAR(48) NULL AFTER drive_wheel,
  ADD COLUMN rim_size            VARCHAR(48) NULL AFTER tire_size;

-- ===================================================================
-- BACKFILL — Civic Sedan (X), 2016-2021. Same numbers as the original mockup
-- (sourced from Honda manual + auto-data).
-- ===================================================================

UPDATE generations
SET
  length_mm = 4630,
  width_mm = 1799,
  height_mm = 1416,
  wheelbase_mm = 2700,
  front_track_mm = 1547,
  rear_track_mm = 1567,
  fuel_tank_l = 47.0,
  cargo_l = 428,
  front_suspension = 'MacPherson strut · stabiliser bar',
  rear_suspension  = 'Multi-link · stabiliser bar',
  front_brakes     = 'Ventilated disc · 282 mm',
  rear_brakes      = 'Solid disc · 260 mm'
WHERE codename = 'FC' OR slug = 'civic-sedan-x-2016-2021';

-- ===================================================================
-- BACKFILL — Camry (XV70), 2018-2024.
-- ===================================================================

UPDATE generations
SET
  length_mm = 4885,
  width_mm = 1840,
  height_mm = 1455,
  wheelbase_mm = 2825,
  front_track_mm = 1599,
  rear_track_mm = 1597,
  fuel_tank_l = 60.0,
  cargo_l = 428,
  front_suspension = 'MacPherson strut · stabiliser bar',
  rear_suspension  = 'Double wishbone · stabiliser bar',
  front_brakes     = 'Ventilated disc · 305 mm',
  rear_brakes      = 'Solid disc · 281 mm'
WHERE codename = 'XV70' OR slug = 'camry-xv70-2018-2024';

-- Verify
SELECT mk.slug AS brand, g.slug AS generation, g.length_mm, g.width_mm, g.height_mm,
       g.wheelbase_mm, g.fuel_tank_l, g.cargo_l,
       LEFT(g.front_suspension, 30) AS front_susp
FROM generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
ORDER BY mk.slug, g.slug;
