-- 452: BMW M/i engine cleanup (phase 1). Fixes systemic contamination found during the
-- moat-fill grind: BEV motors mislabeled petrol, an i5 motor cross-linked onto i4/i7/iX1,
-- falsely model-specific engine names, and the F90 M5's duplicated (split) engine rows.
-- Phase 2 (documented, NOT done here): the S63 generational split (F10 T0 vs F90 T4 vs M6/M8
-- variants all currently share engine 396) and the S68-coded row (918) wrongly on the S63 F96
-- X6 M — both need new engine rows under the frozen-slug constraint.

-- ---- 1. BEV motors were fuel='petrol' -> electric (unblocks BEV detection) ----
UPDATE engines SET fuel='electric' WHERE id IN (388,397,946,1117,1118);

-- ---- 2. Rename falsely model-specific shared engine rows ----
-- 388/397 are shared across i4 + i5 (388 also i7-era eDrive); drop the false "i5"-only naming.
UPDATE engines SET display_name='eDrive40 (250 kW, 5th-gen eDrive)' WHERE id=388;
UPDATE engines SET display_name='M60/M50 xDrive (442 kW, 5th-gen eDrive)' WHERE id=397;
-- 396 is shared by F10/F90 M5 + M6 + M8 + X6 M F96; it is NOT only the M5. Use the engine-family name.
UPDATE engines SET display_name='S63B44 4.4 V8 TwinPower Turbo' WHERE id=396;

-- ---- 3. Remove the i5 M60 motor (397) cross-linked onto the i7 and i4 ----
-- i7 has its own motors (1117 eDrive50, 1118 xDrive60); the 397 coolant row is contamination.
DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id=5123;
DELETE FROM fluid_specs WHERE id=5123;  -- i7 coolant on 397 (dup of 1117/1118 coolant)
-- i4 already has its eDrive40 coolant on 388; the 397 row is contamination.
DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id=3746;
DELETE FROM fluid_specs WHERE id=3746;  -- i4 coolant on 397

-- ---- 4. iX1: it only references the i5 M60 motor (wrong). Give it its own motor. ----
INSERT IGNORE INTO engines (code, display_name, fuel) VALUES ('iX1-eDU', 'iX1 electric drive (5th-gen eDrive)', 'electric');
UPDATE fluid_specs SET engine_id=(SELECT id FROM engines WHERE code='iX1-eDU')
  WHERE id=5170;  -- iX1 coolant (was on 397/i5 M60)

-- ---- 5. F90 M5 (146): de-duplicate split engine rows (generic 188 + specific 396) onto 396 ----
-- 396 is the F90's engine. Fix its oil capacity (10.0 was wrong; S63B44T4 is 8.5 L w/filter),
-- move the coolant capacity off the generic 188 onto 396, and drop the leftover/duplicate rows.
UPDATE fluid_specs SET capacity_l=8.50, capacity_qt=ROUND(8.50*1.05669,2) WHERE id=2941;  -- 396 engine_oil 10.0 -> 8.5
UPDATE fluid_specs SET engine_id=396 WHERE id=2005;  -- 188 coolant 14.5 -> 396
DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (2004,2942);
DELETE FROM fluid_specs WHERE id IN (2004, 2942);  -- 188 engine_oil dup (8.5) + 396 coolant NULL dup
