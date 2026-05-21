-- Widen notes columns to TEXT.
--
-- Long cross-check matrices and variant lists exceed 255 chars (the old
-- VARCHAR limit). The fluid backfill pass produced richer per-variant
-- notes documenting OM page references + alternate values per trim.

ALTER TABLE fluid_specs   MODIFY notes TEXT;
ALTER TABLE torque_specs  MODIFY notes TEXT;
ALTER TABLE parts         MODIFY notes TEXT;
ALTER TABLE sources       MODIFY notes TEXT;

SELECT 'notes columns widened to TEXT' AS status;
