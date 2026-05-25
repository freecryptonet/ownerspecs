-- 453: BMW S63 generational split (engine cleanup phase 2).
-- HaynesPro labels the whole S63 4.4 V8 family generically "S63B44B"; the real BMW variants
-- (verified across multiple technical sources) are:
--   S63B44O0 - E70 X5M / E71 X6M 2010-2013 (not in catalogue)
--   S63B44T0 - F10 M5 2011-2017, F06/F12/F13 M6 2012-2018   <- NEW row here
--   S63B44T2 - F85 X5M / F86 X6M 2015-2019                  <- already engine 2044 (mig 439)
--   S63B44T4 - F90 M5, F9x M8, F95 X5M / F96 X6M 2018+       <- engine 396 (re-coded here)
-- Engine 396 was one shared row across all of them (post mig-452 named generically). Split the
-- F1x cars onto a proper T0 row, and re-code 396 as the T4 (slug stays frozen at s63b44b).
-- Also: engine 918 "S68B44A" is correct for real S68 cars (760i, X6/X7 M60i) but was wrongly
-- attached to the S63-powered F96 X6 M Competition — remove that contamination.

-- ---- 1. Re-code 396 as the T4 variant (slug s63b44b stays frozen; URL unchanged) ----
UPDATE engines SET code='S63B44T4', display_name='S63B44T4 4.4 V8 M TwinPower Turbo' WHERE id=396;

-- ---- 2. Create the T0 variant (F10 M5 / F1x M6) ----
INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, valvetrain, cylinders)
VALUES ('S63B44T0', 'S63B44T0 4.4 V8 M TwinPower Turbo', 4395, 'gasoline', 'twin-turbo', 'DOHC', 8);
SET @t0 = (SELECT id FROM engines WHERE code='S63B44T0');

-- ---- 3. Move the F1x M5/M6 fluids off the T4 row onto the T0 row ----
UPDATE fluid_specs SET engine_id=@t0
  WHERE engine_id=396 AND generation_id IN (176, 260, 261, 262);  -- F10 M5, M6 F13/F12/F06

-- ---- 4. Remove the S68 (918) contamination from the S63 F96 X6 M (239/240) ----
-- The Competition variant was on the wrong S68 row; its engine is the same S63B44T4 (396) as the
-- base, which already carries the gen's engine fluids. Drop the mislabelled Competition rows.
DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (5751,5752,5753,5754,5755,5756);
DELETE FROM fluid_specs WHERE id IN (5751,5752,5753,5754,5755,5756);
