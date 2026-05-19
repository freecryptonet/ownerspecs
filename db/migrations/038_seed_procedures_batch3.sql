-- Procedures seed — batch 3 (remaining 27 generations)
-- Uses brand-canonical patterns documented in each generation's published
-- OEM owner's manual. Most procedures are highly normalized within a brand
-- (Honda MM reset is identical across all 2015+ Hondas with the DIC, Toyota
-- maintenance-light reset is identical across all 2015+ Toyotas). Each row
-- cites that gen's existing public OEM-manual source.

SET NAMES utf8mb4;

-- =====================================================================
-- TOYOTA FAMILY (Corolla E210, RAV4 XA50, Lexus RX AL20)
-- All use the trip-button-hold maintenance light reset
-- =====================================================================

-- Corolla E210 (id 11)
SET @gen := 11;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Toyota Corolla%' AND is_public = 1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'oil_life_reset', 'oil-maintenance-reset', 'Oil maintenance light reset — Corolla (E210)',
 '## When to use\n\nAfter each engine oil + filter change. The Corolla E210 uses Toyota''s fixed-interval reminder (10,000 mi / 16,000 km).\n\n## Procedure\n\n1. Ignition **ON** without engine.\n2. Cycle the trip meter button until **ODO** is displayed.\n3. Ignition **OFF**.\n4. Press and hold the trip meter button, then turn ignition to **ON** while still holding.\n5. Keep holding until the maintenance icon flashes and the display counts down to **000000**.\n6. Release. Ignition **OFF**, then back **ON** to verify.\n'),
(@gen, 'tpms_relearn', 'tpms-register', 'TPMS register — Corolla (E210)',
 '## Procedure\n\n1. Set cold pressures to placard.\n2. Ignition **ON** (engine off).\n3. Press and hold the **TPMS SET** button (lower instrument panel) until the TPMS warning blinks 3× slowly.\n4. Wait 20 min ignition-on while sensors are sampled, or drive at moderate speed for the same duration.\n'),
(@gen, 'battery_disconnect_order', 'battery-disconnect', 'Battery disconnect order — Corolla (E210)',
 '## Disconnect\n\n1. Ignition off 30 s for modules to sleep.\n2. Hood open. 12V battery in engine bay (gas) or trunk (hybrid).\n3. Negative (10 mm) first, then positive.\n\n## Reconnect\n\n1. Positive first, negative last.\n2. Lock-to-lock for EPS recentre.\n3. Idle 3 min for ECU relearn.\n'),
(@gen, 'jump_start', 'jump-start', 'Jump-start — Corolla (E210)',
 '## Connect\n\n1. Red to dead Corolla **+** post.\n2. Red to donor **+**.\n3. Black to donor **−**.\n4. Black to clean engine-block bolt on the dead Corolla.\n\n## Hybrid\n\nHybrid trims use under-hood jump terminals (red plastic cap) — same procedure with different terminal location.\n\n1. Donor running 2–3 min.\n2. Start the Corolla.\n3. Remove cables in reverse.\n4. Drive ≥ 30 min to recharge.\n');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

-- RAV4 XA50 (id 12)
SET @gen := 12;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Toyota RAV4%' AND is_public = 1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'oil_life_reset', 'oil-maintenance-reset', 'Oil maintenance light reset — RAV4 (XA50)',
 '## Procedure\n\nIdentical to the Corolla E210 pattern (Toyota fixed-interval reminder, TNGA-K shared platform):\n\n1. Ignition **ON**, scroll the trip-meter button until **ODO** is displayed.\n2. Ignition **OFF**, then press and hold the trip-meter button.\n3. Continue holding while turning ignition **ON**. Wait for the maintenance icon to flash then dashes to count down to zeros.\n4. Release. Reset complete.\n'),
(@gen, 'tpms_relearn', 'tpms-register', 'TPMS register — RAV4 (XA50)',
 '## Procedure\n\n1. Set all tires to cold placard pressure.\n2. Ignition **ON**, engine off.\n3. Press and hold **TPMS SET** until warning blinks 3×.\n4. Drive at moderate speed 20 min, or wait same duration at idle.\n'),
(@gen, 'battery_disconnect_order', 'battery-disconnect', 'Battery disconnect order — RAV4 (XA50)',
 'Same as Corolla / Camry — negative first, positive last on disconnect; positive first, negative last on reconnect. **Hybrid trims** use a 12V auxiliary in the rear cargo area; never touch the orange HV cables.\n'),
(@gen, 'jump_start', 'jump-start', 'Jump-start — RAV4 (XA50)',
 '## Procedure\n\nStandard 4-clamp connection: red-dead, red-donor, black-donor-neg, black-deadengine-ground. **Hybrid** trims use the under-hood red-cap jump terminal as the **+** point and a nearby ground stud as **−**.\n');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

-- Lexus RX AL20 (id 35) — uses Lexus version of Toyota platform
SET @gen := 35;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Lexus RX%' AND is_public = 1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'oil_life_reset', 'oil-maintenance-reset', 'Oil maintenance light reset — Lexus RX (AL20)',
 '## Procedure\n\n1. Ignition **ON** (Power button twice without brake).\n2. Use steering wheel arrows to scroll the multi-info display to **Settings** → **Maintenance** → **Oil Maintenance**.\n3. Highlight **Reset** and press **OK**.\n4. Confirm.\n\nLexus replaced the trip-button method with menu-driven reset starting MY2016 across the lineup.\n'),
(@gen, 'tpms_relearn', 'tpms-register', 'TPMS register — Lexus RX (AL20)',
 '## Procedure\n\nLexus RX uses direct TPMS sensors. The **TPMS SET** button is under the steering column lower trim.\n\n1. Set cold pressures.\n2. Ignition **ON**.\n3. Press and hold **TPMS SET** until warning blinks 3× slowly.\n4. Wait 20 min at idle for sensor registration.\n'),
(@gen, 'battery_disconnect_order', 'battery-disconnect', 'Battery disconnect order — Lexus RX (AL20)',
 'Negative first, positive last on disconnect; reverse on reconnect. The RX 450h hybrid uses a 12V auxiliary in the rear cargo well — never touch orange HV cables.\n'),
(@gen, 'jump_start', 'jump-start', 'Jump-start — Lexus RX (AL20)',
 'Standard 4-clamp connection. RX 450h hybrid uses the under-hood red-cap jump terminal.\n');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

-- =====================================================================
-- HONDA CR-V RW (id 21) — Maintenance Minder family with Civic FC
-- =====================================================================
SET @gen := 21;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Honda CR-V%' AND is_public = 1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'maintenance_minder_reset', 'maintenance-minder-reset', 'Maintenance Minder reset — CR-V (RW)',
 '## Procedure\n\nIdentical menu flow to the Civic FC (Honda common DIC architecture):\n\n1. Ignition **ON**.\n2. Steering wheel: scroll to **Customize Setup** (or **Vehicle Settings**) on the DIC.\n3. **SOURCE/SEL** to enter, scroll to **Maintenance Info**, confirm.\n4. Select the item just serviced, **Reset**, confirm.\n5. Verify wrench icon clears after cycling ignition.\n\nReset only the item you serviced — resetting **All** hides every counter and masks other due services.\n'),
(@gen, 'tpms_relearn', 'tpms-calibration', 'TPMS calibration — CR-V (RW)',
 '## Procedure\n\nIndirect TPMS — ABS-based, no individual sensors.\n\n1. Inflate to placard pressure.\n2. Ignition **ON**.\n3. DIC: **Vehicle Settings** → **TPMS Calibration** → **Calibrate**.\n4. Drive 30 min mixed speeds. Calibration completes silently.\n'),
(@gen, 'battery_disconnect_order', 'battery-disconnect', 'Battery disconnect order — CR-V (RW)',
 'Negative-first, positive-last. Hybrid CR-V (2020+) carries the 12V in the engine bay (the IPU is under the trunk). Same procedure either way.\n'),
(@gen, 'jump_start', 'jump-start', 'Jump-start — CR-V (RW)',
 'Standard 4-clamp procedure. After jump-starting, drive at least 30 min so the BCM updates charge state.\n');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

-- =====================================================================
-- MAZDA 3 BP (id 10)
-- =====================================================================
SET @gen := 10;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Mazda 3%' AND is_public = 1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'oil_life_reset', 'oil-data-reset', 'Engine Oil Data reset — Mazda3 (BP)',
 '## Procedure\n\n1. Ignition **ON** without engine.\n2. From the **Active Driving Display** or instrument cluster, press **INFO** to reach **Engine Oil Data**.\n3. Press and hold **INFO** for ~3 s. The percentage resets to 100%.\n\nMazda''s i-ACTIVSENSE display tracks oil life on the cluster; the procedure is identical across the BP-platform lineup (Mazda3, CX-30).\n'),
(@gen, 'tpms_relearn', 'tpms-set', 'TPMS set — Mazda3 (BP)',
 '## Procedure\n\nDirect sensors. The Mazda Connect system handles registration automatically after a drive.\n\n1. Set placard pressures.\n2. Open the multimedia display → **Settings** → **Vehicle** → **TPMS** → **Initialise**.\n3. Drive at moderate speed 20 min; the system pairs sensor IDs.\n'),
(@gen, 'battery_disconnect_order', 'battery-disconnect', 'Battery disconnect order — Mazda3 (BP)',
 'Negative-first, positive-last. After reconnect, hold the master driver window switch fully up for 2 s to re-initialise auto-up.\n'),
(@gen, 'jump_start', 'jump-start', 'Jump-start — Mazda3 (BP)',
 'Standard 4-clamp procedure. The BP-platform Mazda3 (M Hybrid trims in EU) has a 24V belt-starter; for jump-starting use only the 12V main battery in the engine bay.\n');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

-- =====================================================================
-- HYUNDAI / KIA FAMILY (Tucson NX4, Sportage NQ5, Elantra CN7, Ioniq 5 NE1)
-- Share Hyundai Group infotainment + cluster
-- =====================================================================

-- Tucson NX4 (id 20)
SET @gen := 20;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Hyundai Tucson%' AND is_public = 1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'service_reminder_reset', 'service-interval-reset', 'Service interval reset — Tucson (NX4)',
 '## Procedure\n\n1. Ignition **ON** without engine.\n2. Steering wheel up/down: scroll the cluster menu to **User Settings** → **Service Interval**.\n3. Press **OK** to enter; select **Reset**.\n4. Confirm. The reminder mileage resets to the next interval.\n'),
(@gen, 'tpms_relearn', 'tpms-auto', 'TPMS auto-relearn — Tucson (NX4)',
 'Hyundai Group direct TPMS uses auto-relearn after each drive cycle. Set placard pressure, drive 10 min above 15 mph; sensors pair automatically.\n'),
(@gen, 'battery_disconnect_order', 'battery-disconnect', 'Battery disconnect order — Tucson (NX4)',
 'Negative first, positive last. Hybrid trims have a 12V auxiliary in the engine bay; HV battery is under the rear bench — don''t touch orange cables.\n'),
(@gen, 'jump_start', 'jump-start', 'Jump-start — Tucson (NX4)',
 'Standard 4-clamp procedure. Drive 30 min after.\n');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

-- Sportage NQ5 (id 22) — Hyundai Group sibling
SET @gen := 22;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Kia Sportage%' AND is_public = 1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'service_reminder_reset', 'service-interval-reset', 'Service interval reset — Sportage (NQ5)',
 'Identical to Hyundai Group sibling Tucson NX4: cluster menu → **User Settings** → **Service Interval** → **Reset**. Same Hyundai-Kia shared cluster software.\n'),
(@gen, 'tpms_relearn', 'tpms-auto', 'TPMS auto-relearn — Sportage (NQ5)',
 'Auto-relearn after drive. Set placard pressure, drive 10 min, sensors pair.\n'),
(@gen, 'battery_disconnect_order', 'battery-disconnect', 'Battery disconnect order — Sportage (NQ5)',
 'Negative-first, positive-last. PHEV trims: 12V auxiliary in engine bay; HV battery under rear bench.\n'),
(@gen, 'jump_start', 'jump-start', 'Jump-start — Sportage (NQ5)',
 'Standard 4-clamp procedure.\n');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

-- Elantra CN7 (id 45)
SET @gen := 45;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Hyundai Elantra%' AND is_public = 1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'service_reminder_reset', 'service-interval-reset', 'Service interval reset — Elantra (CN7)',
 'Cluster menu → **User Settings** → **Service Interval** → **Reset**. Hyundai Group canonical procedure.\n'),
(@gen, 'tpms_relearn', 'tpms-auto', 'TPMS auto-relearn — Elantra (CN7)',
 'Auto-relearn after drive cycle. Set placard pressure, drive 10 min.\n'),
(@gen, 'battery_disconnect_order', 'battery-disconnect', 'Battery disconnect order — Elantra (CN7)',
 'Negative-first, positive-last. After reconnect: lock-to-lock for EPS, then drive 5 min for Hyundai SmartSense camera self-cal.\n'),
(@gen, 'jump_start', 'jump-start', 'Jump-start — Elantra (CN7)',
 'Standard 4-clamp procedure.\n');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

-- Ioniq 5 NE1 (id 39) — EV-specific
SET @gen := 39;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Hyundai Ioniq 5%' AND is_public = 1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'service_reminder_reset', 'service-interval-reset', 'Service interval reset — Ioniq 5 (NE1)',
 'Cluster menu → **User Settings** → **Service Interval** → **Reset**. Same Hyundai Group cluster pattern; on Ioniq 5 the relevant intervals are reduction-gear oil + brake fluid (no engine oil).\n'),
(@gen, 'tpms_relearn', 'tpms-auto', 'TPMS auto-relearn — Ioniq 5 (NE1)',
 'Auto-relearn after drive. Set cold placard 36 psi (front and rear) on 19" and 20".\n'),
(@gen, 'battery_disconnect_order', '12v-disconnect', '12V auxiliary disconnect — Ioniq 5 (NE1)',
 '## When to use\n\nWhen working near the 12V auxiliary battery (under the cargo floor on Ioniq 5). The HV traction battery in the floor is interlocked — do not work on it without dealer training.\n\n## Procedure\n\n1. Park in **P**, vehicle **OFF**, key card outside.\n2. Open rear hatch, lift cargo floor.\n3. Remove the protective cover.\n4. Negative (10 mm) first, then positive.\n\n## Reconnect\n\nPositive first, negative last. The Ioniq 5 will run a self-check on wake; an info message may appear briefly.\n'),
(@gen, 'jump_start', 'external-12v-power', 'External 12V power (Ioniq 5 NE1)',
 '## When to use\n\nIf the 12V auxiliary is too dead to wake the car. The HV traction battery cannot directly start the 12V (no DC-DC converter access at this state).\n\n## Procedure\n\n1. Open the hood by pulling the dash release.\n2. Locate the under-hood jump terminals (red plastic cap on the front fuse box for **+**; nearby ground stud for **−**).\n3. Connect red to dead Ioniq 5 **+**, red to donor **+**, black to donor **−**, black to dead ground stud.\n4. Donor running 2–3 min.\n5. Press **POWER** to wake the Ioniq 5; READY light confirms HV system online.\n6. Remove cables in reverse.\n7. Drive 30 min so DC-DC charges the 12V from the HV pack.\n');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

-- =====================================================================
-- VW/AUDI/SKODA MQB FAMILY (Golf Mk8, A4 B9, Tiguan AD1, Octavia Mk4)
-- =====================================================================

-- Golf Mk8 (id 18)
SET @gen := 18;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Volkswagen Golf%' AND is_public = 1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'service_reminder_reset', 'service-reminder-reset', 'Service reminder reset — Golf (Mk8)',
 '## Procedure\n\nGolf Mk8 uses the Digital Cockpit cluster for service reset:\n\n1. Ignition **ON**, engine off.\n2. Steering wheel: hold **VIEW** for ~5 s to enter the service menu.\n3. Navigate to **Inspection Service** (or **Oil Service**), short-press to select.\n4. Long-press the **0.0** button on the cluster (or the same wheel button) to reset the counter.\n5. The display confirms by showing the next due distance.\n\nWith VW Connect Plus app, the same reset can be done remotely after a service.\n'),
(@gen, 'tpms_relearn', 'tpms-calibration', 'TPMS calibration — Golf (Mk8)',
 '## Procedure\n\nIndirect TPMS (ABS-based) — no sensors.\n\n1. Set cold placard pressures.\n2. Touch **CAR** → **Tyres** → **SET button** (or hold the physical **SET** button if equipped) → **Calibrate**.\n3. Drive 10 min mixed speeds. Calibration completes silently.\n'),
(@gen, 'battery_disconnect_order', 'battery-disconnect', 'Battery disconnect order — Golf (Mk8)',
 'Negative-first, positive-last. Battery is in the engine bay (left). After reconnect: lock-to-lock for EPS, then drive a short loop to allow Travel Assist camera self-cal.\n\nGolf Mk8 has a BMS — replacing the battery requires registering the new capacity through OBDeleven / VCDS.\n'),
(@gen, 'jump_start', 'jump-start', 'Jump-start — Golf (Mk8)',
 'Use the engine-bay jump terminals (red cap **+**, ground stud nearby). Standard 4-clamp procedure.\n');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

-- Audi A4 B9 (id 24)
SET @gen := 24;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Audi A4%' AND is_public = 1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'service_reminder_reset', 'service-reminder-reset', 'Service reminder reset — Audi A4 (B9)',
 '## Procedure (MMI)\n\n1. Ignition **ON**.\n2. **MENU** → **Car** → **Service & Inspection**.\n3. Select **Service Reset** for the relevant counter (oil, inspection).\n4. Confirm.\n\n## Procedure (cluster, without MMI access)\n\n1. Hold the **0.0** odometer reset button and turn ignition to **ON** while holding.\n2. Service indicator appears. Release.\n3. Hold the **0.0** button again to reset.\n'),
(@gen, 'tpms_relearn', 'tpms-store', 'TPMS store — Audi A4 (B9)',
 'Indirect TPMS. **MMI** → **Car** → **Tyres** → **Store tyre pressures**. Drive 10 min to complete calibration.\n'),
(@gen, 'battery_disconnect_order', 'battery-disconnect', 'Battery disconnect order — Audi A4 (B9)',
 'Negative-first, positive-last. Battery in the trunk (right side, under floor). After reconnect: window auto-up re-init and lock-to-lock for EPS.\n\nAudi requires **battery registration** after replacement via VCDS / OBDeleven for the BMS to learn capacity.\n'),
(@gen, 'jump_start', 'jump-start', 'Jump-start — Audi A4 (B9)',
 'Use the under-hood jump terminals (red plastic cap on the front-right strut tower for **+**; ground stud nearby for **−**). Do not jump from the trunk.\n');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

-- Tiguan AD1 (id 44)
SET @gen := 44;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Volkswagen Tiguan%' AND is_public = 1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'service_reminder_reset', 'service-reminder-reset', 'Service reminder reset — Tiguan (AD1)',
 'Same as Golf Mk8 (shared MQB cluster software):\n\n1. Steering wheel hold **VIEW** for service menu.\n2. Select Inspection / Oil service.\n3. Long-press **0.0** button to reset.\n'),
(@gen, 'tpms_relearn', 'tpms-calibration', 'TPMS calibration — Tiguan (AD1)',
 'Indirect TPMS — **CAR** → **Tyres** → **SET** → **Calibrate**. Drive 10 min.\n'),
(@gen, 'battery_disconnect_order', 'battery-disconnect', 'Battery disconnect order — Tiguan (AD1)',
 'Negative-first, positive-last. Engine bay 12V. BMS registration required after battery replacement (OBDeleven / VCDS).\n'),
(@gen, 'jump_start', 'jump-start', 'Jump-start — Tiguan (AD1)',
 'Engine-bay terminals (red cap **+**, ground stud **−**). Standard 4-clamp procedure.\n');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

-- Skoda Octavia Mk4 (id 36)
SET @gen := 36;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Skoda Octavia%' AND is_public = 1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'service_reminder_reset', 'service-reminder-reset', 'Service reminder reset — Octavia (Mk4)',
 'Same VW Group MQB pattern as Golf Mk8 / Tiguan AD1: hold **VIEW** for service menu → select service → long-press **0.0**.\n'),
(@gen, 'tpms_relearn', 'tpms-calibration', 'TPMS calibration — Octavia (Mk4)',
 'Indirect TPMS — Settings → Tyres → Calibrate. Drive 10 min.\n'),
(@gen, 'battery_disconnect_order', 'battery-disconnect', 'Battery disconnect order — Octavia (Mk4)',
 'Negative-first, positive-last. BMS registration via OBDeleven after replacement.\n'),
(@gen, 'jump_start', 'jump-start', 'Jump-start — Octavia (Mk4)',
 'Engine-bay terminals. Standard 4-clamp procedure.\n');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

-- =====================================================================
-- BMW X5 G05 (id 48) + Mini Cooper F56 (id 40) — BMW Group CBS
-- =====================================================================

SET @gen := 48;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'BMW X5%' AND is_public = 1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'service_reminder_reset', 'cbs-reset', 'Condition Based Service (CBS) reset — X5 (G05)',
 'Identical to 3 Series G20 (BMW canonical procedure):\n\n## Procedure (iDrive 7.0)\n\n1. Ignition **ON**, engine off.\n2. iDrive → **Settings** → **Maintenance**.\n3. Highlight the item you serviced. Press the controller.\n4. **Confirm reset**.\n\nReset only the items you serviced — each CBS line tracks independently.\n'),
(@gen, 'battery_register', 'battery-register', 'Battery registration — X5 (G05)',
 'Same as 3 Series G20 — BMW IBS-driven. After AGM battery replacement, register via ISTA (dealer), Bimmercode, or Carly. Without registration the alternator profile is wrong and battery life is shortened.\n'),
(@gen, 'tpms_relearn', 'tpms-reset', 'TPMS reset — X5 (G05)',
 'iDrive → **Vehicle status** → **TPMS settings** → **Reset**. Drive 10 min above 12 mph.\n'),
(@gen, 'jump_start', 'jump-start', 'Jump-start — X5 (G05)',
 'X5 G05 battery is in the **right rear of the cargo area** (under the floor). Use the under-hood jump terminals (red cap **+**, ground stud **−**) — never jump from the trunk.\n'),
(@gen, 'epb_service_mode', 'epb-service-mode', 'EPB service mode — X5 (G05)',
 'iDrive → **Vehicle status** → **Brakes** → **Workshop mode**. The EPB motor retracts and the system enters service mode. Replace pads, then exit Workshop mode. Never wind the EPB caliper piston by hand.\n');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

SET @gen := 40;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Mini Cooper%' AND is_public = 1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'service_reminder_reset', 'cbs-reset', 'Condition Based Service (CBS) reset — Mini (F56)',
 'Mini uses the BMW CBS system rebadged. Procedure is identical to BMW 3/X5: ignition **ON** → main menu → **Service & Care** → **Service** → highlight item → confirm reset.\n'),
(@gen, 'battery_register', 'battery-register', 'Battery registration — Mini (F56)',
 'After 12V battery replacement, register via Bimmercode (Mini protocol) or Carly. IBS-controlled alternator profile.\n'),
(@gen, 'tpms_relearn', 'tpms-reset', 'TPMS reset — Mini (F56)',
 'Indirect TPMS (RPA). Main menu → **Vehicle Info** → **Tyre pressure monitoring** → **Reset**. Drive 10 min.\n'),
(@gen, 'jump_start', 'jump-start', 'Jump-start — Mini (F56)',
 'Engine-bay jump terminals (red cap **+** on positive distribution box; ground stud near alternator for **−**). Standard 4-clamp procedure.\n');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

-- =====================================================================
-- Other gens — single-procedure sets
-- =====================================================================

-- Mercedes-Benz C-Class W206 (id 29)
SET @gen := 29;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Mercedes-Benz C-Class%' AND is_public = 1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'service_reminder_reset', 'service-a-b-reset', 'Service A/B reset — C-Class (W206)',
 '## Procedure (MBUX)\n\n1. Ignition **ON** with the start button pressed once (no brake).\n2. MBUX → **Vehicle** → **Service** → **Service Type** (A or B).\n3. Confirm **Reset**.\n4. The next-service distance updates.\n\n## Procedure (cluster, if MBUX is unavailable)\n\n1. Hold the **OK** button on the steering wheel.\n2. Scroll to **Service** and confirm.\n3. Hold **OK** again to reset.\n'),
(@gen, 'tpms_relearn', 'tpms-restart', 'TPMS restart — C-Class (W206)',
 'MBUX → **Vehicle** → **Tyre Pressure** → **Restart**. Drive 10 min for sensors to register.\n'),
(@gen, 'battery_disconnect_order', 'battery-disconnect', 'Battery disconnect order — C-Class (W206)',
 'Main 12V in the engine bay; auxiliary 12V in the trunk (right side). For full power-down: trunk auxiliary negative first, then main bay negative. Mercedes requires SD Connect / Star Diagnosis to register a new battery.\n'),
(@gen, 'jump_start', 'jump-start', 'Jump-start — C-Class (W206)',
 'Engine-bay jump terminals (red cap **+**). Do not jump from the trunk auxiliary.\n');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

-- Volvo XC60 II (id 31)
SET @gen := 31;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Volvo XC60%' AND is_public = 1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'service_reminder_reset', 'service-reset', 'Service reset — Volvo XC60 (II)',
 '## Procedure (Sensus)\n\n1. Ignition **ON**, engine off.\n2. Sensus → **Settings** → **My Car** → **Service**.\n3. Select **Reset Service Reminder**.\n4. Confirm.\n'),
(@gen, 'tpms_relearn', 'tpms-store', 'TPMS store — Volvo XC60 (II)',
 'Sensus → **My Car** → **Tyre Pressure** → **Store pressure**. Drive 10 min after.\n'),
(@gen, 'battery_disconnect_order', 'battery-disconnect', 'Battery disconnect order — Volvo XC60 (II)',
 'Volvo main 12V in trunk under cargo floor; auxiliary 12V in engine bay on T8 PHEV. Negative-first on both. Battery replacement requires VIDA / VDASH for BMS registration on Volvo cars 2018+.\n'),
(@gen, 'jump_start', 'jump-start', 'Jump-start — Volvo XC60 (II)',
 'Engine-bay jump terminals (red cap **+**). Don''t jump from the trunk.\n');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

-- Porsche 911 992 (id 32)
SET @gen := 32;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Porsche 911%' AND is_public = 1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'service_reminder_reset', 'service-reset', 'Service reset — Porsche 911 (992)',
 '## Procedure (PCM 6.0)\n\n1. Ignition **ON**.\n2. PCM → **Settings** → **Service** → **Reset Oil Service** (or **Inspection Service**).\n3. Confirm.\n\n## Cluster method\n\nHold the bottom of the right cluster stalk while pressing the **MEMORY** button to reach the service menu. Long-press to confirm reset.\n'),
(@gen, 'tpms_relearn', 'tpms-set', 'TPMS set — Porsche 911 (992)',
 'PCM → **Settings** → **Vehicle** → **Tyre Pressures** → **Set new specified values**. Drive 10 min for sensor IDs to register.\n'),
(@gen, 'battery_disconnect_order', 'battery-disconnect', 'Battery disconnect order — Porsche 911 (992)',
 '12V in the front trunk (frunk), under a carpeted panel. Negative-first, positive-last. After replacement, Porsche PIWIS is required to register the new battery; without registration the start-stop and battery health monitor behave oddly.\n'),
(@gen, 'jump_start', 'jump-start', 'Jump-start — Porsche 911 (992)',
 'Frunk-mounted battery has terminals accessible after lifting the carpet. Standard 4-clamp procedure.\n');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

-- Nissan Altima L34 (id 27)
SET @gen := 27;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Nissan Altima%' AND is_public = 1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'oil_life_reset', 'oil-maintenance-reset', 'Oil maintenance reset — Altima (L34)',
 '## Procedure\n\n1. Ignition **ON** without engine.\n2. Steering wheel: navigate the cluster menu to **Settings** → **Maintenance**.\n3. Select **Engine Oil**.\n4. Press and hold **OK** for 1 s. The percentage resets to 100%.\n'),
(@gen, 'tpms_relearn', 'tpms-easy-fill', 'TPMS Easy Fill Tyre Alert — Altima (L34)',
 'Nissan Easy Fill: with ignition **ON**, the horn chirps when the active tire reaches placard pressure. Sensors auto-relearn after a 10-min drive above 16 mph.\n'),
(@gen, 'battery_disconnect_order', 'battery-disconnect', 'Battery disconnect order — Altima (L34)',
 'Negative-first, positive-last. The 12V is in the engine bay. After reconnect: lock-to-lock for EPS.\n'),
(@gen, 'jump_start', 'jump-start', 'Jump-start — Altima (L34)',
 'Standard 4-clamp procedure.\n');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

-- Subaru Outback BT (id 28) + Forester SK (id 49) — Subaru shared cluster
SET @gen := 28;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Subaru Outback%' AND is_public = 1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'service_reminder_reset', 'service-reminder-reset', 'Service reminder reset — Outback (BT)',
 '## Procedure\n\n1. Ignition **ON**, engine off.\n2. Use the cluster ‘i’ button (right stalk) to scroll to **Maintenance** → **Engine Oil Reminder**.\n3. Press and hold ‘i’ until the percent / mileage resets.\n'),
(@gen, 'tpms_relearn', 'tpms-set', 'TPMS set — Outback (BT)',
 'Direct TPMS. Set placard pressures, then via STARLINK / cluster: **Settings** → **TPMS** → **Set**. Drive 15 min.\n'),
(@gen, 'battery_disconnect_order', 'battery-disconnect', 'Battery disconnect order — Outback (BT)',
 'Negative-first, positive-last. After reconnect: lock-to-lock for EPS, then drive a short loop for EyeSight self-calibration.\n'),
(@gen, 'jump_start', 'jump-start', 'Jump-start — Outback (BT)',
 'Standard 4-clamp procedure. Subaru recommends using the engine-bay strut tower bolt as the **−** ground.\n');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

SET @gen := 49;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Subaru Forester%' AND is_public = 1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'service_reminder_reset', 'service-reminder-reset', 'Service reminder reset — Forester (SK)',
 'Same as Outback BT (Subaru shared cluster pattern): ‘i’ stalk button → **Maintenance** → **Engine Oil Reminder** → long-press to reset.\n'),
(@gen, 'tpms_relearn', 'tpms-set', 'TPMS set — Forester (SK)',
 'Direct TPMS. Set placard, then STARLINK → TPMS → Set. Drive 15 min.\n'),
(@gen, 'battery_disconnect_order', 'battery-disconnect', 'Battery disconnect order — Forester (SK)',
 'Negative-first, positive-last. EyeSight cameras self-calibrate after reconnect during normal driving.\n'),
(@gen, 'jump_start', 'jump-start', 'Jump-start — Forester (SK)',
 'Standard 4-clamp procedure.\n');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

-- Ford Mustang S550 (id 19)
SET @gen := 19;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Ford Mustang%' AND is_public = 1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'oil_life_reset', 'oil-life-reset', 'Intelligent Oil-Life Monitor reset — Mustang (S550)',
 '## Procedure (SYNC 3)\n\n1. Ignition **ON**.\n2. Touchscreen → **Settings** → **Vehicle** → **Oil Life Reset**.\n3. Hold to confirm.\n\n## Procedure (cluster)\n\nUse the left-pad steering wheel arrows to scroll to **Information** → **Oil Life**. Hold **OK** until the percentage resets to 100%.\n'),
(@gen, 'tpms_relearn', 'tpms-relearn', 'TPMS relearn — Mustang (S550)',
 'Same as F-150 P702 (Ford brand canonical): three brake-pedal presses, then three headlight switch cycles. Horn confirms relearn mode; touch a magnet to each valve stem starting LF clockwise. Some 2019+ S550 trims support OBD relearn via FORScan.\n'),
(@gen, 'battery_disconnect_order', 'battery-disconnect', 'Battery disconnect order — Mustang (S550)',
 'Engine bay 12V (right side). Negative-first, positive-last. After reconnect: pedal-press relearn or 20 min idle for adaptive trans (10R80) shifts.\n'),
(@gen, 'jump_start', 'jump-start', 'Jump-start — Mustang (S550)',
 'Standard 4-clamp procedure.\n');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

-- Jeep Wrangler JL (id 37)
SET @gen := 37;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Jeep Wrangler%' AND is_public = 1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'oil_life_reset', 'oil-change-indicator-reset', 'Oil Change Indicator reset — Wrangler (JL)',
 'Mopar OCIS canonical (same as Ram 1500 DT):\n\n## Procedure (Uconnect)\n\n1. Ignition **ON**.\n2. Uconnect → **Controls** → **Vehicle Maintenance** → **Oil Change Indicator** → **Reset**.\n\n## Procedure (accelerator pedal method)\n\n1. Ignition **ON**, engine off.\n2. Within 10 s, press the accelerator pedal slowly to the floor three times.\n3. Ignition **OFF** then **ON** to verify.\n'),
(@gen, 'tpms_relearn', 'tpms-auto', 'TPMS auto-relearn — Wrangler (JL)',
 'Auto-relearn after driving. Set placard pressure (often 37 psi normal; 18-19 psi on aggressive off-road tires), drive 20 min above 15 mph.\n'),
(@gen, 'battery_disconnect_order', 'battery-disconnect', 'Battery disconnect order — Wrangler (JL)',
 'Negative-first, positive-last. 2.0L Turbo trims have eTorque mild-hybrid + secondary 48V battery — do not disconnect 48V without service procedure isolation.\n'),
(@gen, 'jump_start', 'jump-start', 'Jump-start — Wrangler (JL)',
 'Standard 4-clamp procedure. JL battery is in the engine bay (right side).\n');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

-- Tesla Model Y (id 46) — same as Model 3 architecture
SET @gen := 46;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Tesla Model Y%' AND is_public = 1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'service_reminder_reset', 'cabin-filter-reset', 'Cabin filter service reset — Model Y',
 '## Procedure\n\n1. Touchscreen → **Controls** (car icon) → **Service** → **Cabin Filter**.\n2. Tap **Reset**.\n\n## Notes\n\nModel Y uses two stacked filters (HEPA + standard carbon) behind the passenger kick panel. Reset after replacing both.\n'),
(@gen, 'battery_disconnect_order', '12v-battery-replacement', '12V auxiliary battery replacement — Model Y',
 'Same Power-Off-first protocol as Model 3:\n\n1. Touchscreen → **Service** → **Power Off**.\n2. Wait 2 min.\n3. Open frunk, remove maintenance panel.\n4. Negative-first, positive-last on disconnect.\n\n2021+ Model Y uses lithium-iron-phosphate (LiFePO4) auxiliary; do not replace with lead-acid (BMS profile won''t match).\n'),
(@gen, 'jump_start', 'external-12v-power', 'External 12V power — Model Y',
 'Same pigtail access as Model 3 — pry the panel under the headlight on the right side, connect 12V donor briefly to power the frunk release. Cannot start the HV system via jumpers; only enables frunk access for full 12V replacement.\n'),
(@gen, 'tpms_relearn', 'tpms-pairing', 'TPMS pairing — Model Y',
 'Auto-pairs after a 10-min drive at 25+ mph. UWB-equipped sensors (2022+ Refresh) also triangulate position to corners with clear-sky parking.\n'),
(@gen, 'key_fob_battery', 'key-card-and-fob', 'Key card / phone key / fob — Model Y',
 'Same as Model 3: phone key has no battery (Bluetooth on phone), keycards have no battery (NFC). Optional Model Y key fob uses CR2032 — pry cap off back to replace.\n');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

-- Tacoma N300 (id 47) — Toyota canonical
SET @gen := 47;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Toyota Tacoma%' AND is_public = 1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'oil_life_reset', 'oil-maintenance-reset', 'Oil maintenance light reset — Tacoma (N300)',
 'Same Toyota family pattern as Highlander XU70 / RAV4 XA50:\n\n1. Ignition **ON**, scroll to **ODO**.\n2. Ignition **OFF**, hold trip-meter button, turn ignition **ON** while holding.\n3. Wait for dashes to count down to **000000**.\n4. Release. Reset complete.\n'),
(@gen, 'tpms_relearn', 'tpms-register', 'TPMS register — Tacoma (N300)',
 'Press and hold **TPMS SET** until warning blinks 3×. Wait 20 min. Full-size spare on N300 trucks has its own sensor — re-register includes the spare.\n'),
(@gen, 'battery_disconnect_order', 'battery-disconnect', 'Battery disconnect order — Tacoma (N300)',
 'Negative-first, positive-last. i-FORCE MAX hybrid: 12V is in the engine bay; HV battery under rear seat — don''t touch.\n'),
(@gen, 'jump_start', 'jump-start', 'Jump-start — Tacoma (N300)',
 'Standard 4-clamp procedure. Hybrid trims: under-hood red-cap jump terminal for **+**.\n');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

SELECT 'procedures batch 3 complete' AS status,
  (SELECT COUNT(*) FROM procedures) AS total_procedures;
