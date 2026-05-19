-- Procedures for the 6 latest gens (RAV4 XA40, CR-V RS, CX-5 KF, Telluride ON,
-- X3 G01, GLC X253). Uses brand-canonical patterns from each gen's OEM OM.
-- Honda CR-V RS / Toyota RAV4 XA40 reuse same canonical procedures we've
-- already documented across their sibling gens.

SET NAMES utf8mb4;

-- Toyota RAV4 XA40 (id 56)
SET @gen := 56;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Toyota RAV4 (XA40)%' AND is_public = 1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'oil_life_reset', 'oil-maintenance-reset', 'Oil maintenance light reset — RAV4 (XA40)',
 'Identical Toyota fixed-interval procedure used on Camry XV70 / RAV4 XA50 / Highlander XU70:\n\n1. Ignition **ON**, scroll trip-meter to **ODO**.\n2. Ignition **OFF**.\n3. Hold trip meter button while turning ignition **ON**.\n4. Continue holding until dashes count down to **000000**.\n5. Release.\n'),
(@gen, 'tpms_relearn', 'tpms-register', 'TPMS register — RAV4 (XA40)',
 'Press and hold the **TPMS SET** button until the warning blinks 3× slowly. Wait 20 min at idle for sensors to register.\n'),
(@gen, 'battery_disconnect_order', 'battery-disconnect', 'Battery disconnect order — RAV4 (XA40)',
 'Negative-first, positive-last. After reconnect: lock-to-lock for EPS, then idle 3 min.\n'),
(@gen, 'jump_start', 'jump-start', 'Jump-start — RAV4 (XA40)',
 'Standard 4-clamp procedure. Hybrid trims (2016+ facelift): use the under-hood red-cap jump terminal for **+**.\n');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

-- Honda CR-V RS (id 57)
SET @gen := 57;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Honda CR-V (RS)%' AND is_public = 1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'maintenance_minder_reset', 'maintenance-minder-reset', 'Maintenance Minder reset — CR-V (RS)',
 'Honda common DIC pattern (same as CR-V RW / Civic FC / Accord CV):\n\n1. Ignition **ON**.\n2. Steering wheel: scroll to **Settings** → **Vehicle** → **Maintenance Info**.\n3. Select serviced item → **Reset** → confirm.\n4. Cycle ignition to verify wrench icon clears.\n'),
(@gen, 'tpms_relearn', 'tpms-calibration', 'TPMS calibration — CR-V (RS)',
 'Indirect TPMS. Set placard pressures, then DIC → **Settings** → **Vehicle** → **TPMS Calibration** → **Calibrate**. Drive 30 min mixed speeds.\n'),
(@gen, 'battery_disconnect_order', 'battery-disconnect', 'Battery disconnect order — CR-V (RS)',
 'Negative-first, positive-last. e:HEV hybrid: 12V in engine bay; HV IPU under trunk floor (never touch orange cables).\n'),
(@gen, 'jump_start', 'jump-start', 'Jump-start — CR-V (RS)',
 'Standard 4-clamp procedure. After jump-start drive 30 min for the BCM to update charge state.\n');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

-- Mazda CX-5 KF (id 58)
SET @gen := 58;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Mazda CX-5 II (KF)%' AND is_public = 1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'oil_life_reset', 'oil-data-reset', 'Engine Oil Data reset — CX-5 (KF)',
 'Same Mazda i-ACTIVSENSE pattern as Mazda3 BP:\n\n1. Ignition **ON** without engine.\n2. Press **INFO** to reach **Engine Oil Data**.\n3. Hold **INFO** for ~3 s. Resets to 100%.\n'),
(@gen, 'tpms_relearn', 'tpms-set', 'TPMS set — CX-5 (KF)',
 'Direct sensors auto-registered after a drive. Mazda Connect → **Settings** → **Vehicle** → **TPMS** → **Initialise**. Drive 20 min.\n'),
(@gen, 'battery_disconnect_order', 'battery-disconnect', 'Battery disconnect order — CX-5 (KF)',
 'Negative-first, positive-last. After reconnect: hold the driver master window fully up for 2 s to re-init auto-up.\n'),
(@gen, 'jump_start', 'jump-start', 'Jump-start — CX-5 (KF)',
 'Standard 4-clamp procedure. M Hybrid trims (EU): 24V starter-belt remains; only jump from the 12V main battery.\n');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

-- Kia Telluride ON (id 59)
SET @gen := 59;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Kia Telluride%' AND is_public = 1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'service_reminder_reset', 'service-interval-reset', 'Service interval reset — Telluride (ON)',
 'Kia/Hyundai Group cluster: **User Settings** → **Service Interval** → **Reset**. Same procedure as Sportage NQ5 / Tucson NX4.\n'),
(@gen, 'tpms_relearn', 'tpms-auto', 'TPMS auto-relearn — Telluride (ON)',
 'Auto-relearn after drive. Set placard pressure (35 psi front/rear on 18" and 20"), drive 10 min above 15 mph.\n'),
(@gen, 'battery_disconnect_order', 'battery-disconnect', 'Battery disconnect order — Telluride (ON)',
 'Negative-first, positive-last. Tow-prep package has heavier H6 AGM — same procedure.\n'),
(@gen, 'jump_start', 'jump-start', 'Jump-start — Telluride (ON)',
 'Standard 4-clamp procedure. Donor capacity matters more on 3-row SUVs — use 600+ CCA donor.\n');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

-- BMW X3 G01 (id 60)
SET @gen := 60;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'BMW X3%' AND is_public = 1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'service_reminder_reset', 'cbs-reset', 'Condition Based Service (CBS) reset — X3 (G01)',
 'Same BMW iDrive procedure as 3 Series G20 / X5 G05:\n\n1. iDrive → **Settings** → **Maintenance**.\n2. Highlight serviced item.\n3. **Confirm reset**.\n'),
(@gen, 'battery_register', 'battery-register', 'Battery registration — X3 (G01)',
 'Required after AGM battery replacement. Use ISTA (dealer), Bimmercode, or Carly. Without registration, alternator charge profile is wrong.\n'),
(@gen, 'tpms_relearn', 'tpms-reset', 'TPMS reset — X3 (G01)',
 'iDrive → **Vehicle status** → **TPMS** → **Reset**. Drive 10 min above 12 mph.\n'),
(@gen, 'jump_start', 'jump-start', 'Jump-start — X3 (G01)',
 '12V in cargo area under floor. Use the under-hood jump terminals (red cap **+**, ground stud **−**). Never jump from cargo area direct.\n'),
(@gen, 'epb_service_mode', 'epb-service-mode', 'EPB service mode — X3 (G01)',
 'iDrive → **Vehicle status** → **Brakes** → **Workshop mode** before rear pad replacement. Never hand-wind the EPB caliper piston.\n');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

-- Mercedes GLC X253 (id 61)
SET @gen := 61;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Mercedes-Benz GLC%' AND is_public = 1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'service_reminder_reset', 'service-a-b-reset', 'Service A/B reset — GLC (X253)',
 'Same MB pattern as C-Class W206:\n\n## MBUX / COMAND method\n\n1. Ignition **ON**.\n2. **Vehicle** → **Service** → **Service A** (or B).\n3. Confirm **Reset**.\n\n## Cluster method\n\nHold steering wheel **OK** for service menu, scroll to **Service**, hold **OK** again to reset.\n'),
(@gen, 'tpms_relearn', 'tpms-restart', 'TPMS restart — GLC (X253)',
 'MBUX → **Vehicle** → **Tyre Pressure** → **Restart**. Drive 10 min.\n'),
(@gen, 'battery_disconnect_order', 'battery-disconnect', 'Battery disconnect order — GLC (X253)',
 'Main 12V in engine bay; auxiliary 12V in trunk on some trims. Negative-first on both. Battery registration requires Mercedes XENTRY/Diagnosis after replacement.\n'),
(@gen, 'jump_start', 'jump-start', 'Jump-start — GLC (X253)',
 'Under-hood jump terminals (red cap **+**, ground stud **−**). Do not jump from the trunk auxiliary.\n');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

SELECT 'procedures batch 4 complete' AS status, (SELECT COUNT(*) FROM procedures) AS total_procedures;
