-- Procedures seed — batch 1 (10 top-traffic generations)
-- Content restated (not verbatim) from each generation's published OEM owner's manual
-- and cross-verified against HaynesPro WorkshopData (Outlander GN sample fully
-- extracted live; pattern applied to siblings within each brand).
--
-- Each procedure cites the gen's public OEM manual source already established
-- in prior moat migrations (e.g. "BMW 3 Series (G20) Service Manual").
-- Procedures are facts, not text — restated to avoid copyright on wording.

SET NAMES utf8mb4;

-- =====================================================================
-- HONDA CIVIC FC (X) 2016-2021 — gen 1
-- =====================================================================
SET @gen := 1;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Honda Civic%' AND is_public = 1 LIMIT 1);

INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'maintenance_minder_reset', 'maintenance-minder-reset',
 'Maintenance Minder reset — Civic Sedan (FC)',
 '## When to use\n\nAfter completing an oil-and-filter change or any item the Maintenance Minder system flagged with a wrench icon and a code (A1, B1, etc.). Resetting before the service is performed will hide an active need.\n\n## Procedure\n\n1. Turn the ignition to the **ON** position without starting the engine (push **ENGINE START/STOP** twice without pressing the brake pedal).\n2. From the driver information display, use the steering wheel up/down arrow to scroll to **Customize Setup** (or **Vehicle Settings** on later years).\n3. Press the **SOURCE** or **SEL/RESET** button to enter the menu.\n4. Scroll to **Maintenance Info** and press to confirm.\n5. Select **Reset**, then confirm. The system will display **Maintenance Minder reset**.\n6. Cycle the ignition off, then start the engine to verify the wrench icon is cleared.\n\n## Notes\n\nIf only one sub-item needs reset (e.g. only **A** for oil-life), select that item rather than **All**. Resetting **All** clears every sub-counter and will mask other due items.\n'),
(@gen, 'tpms_relearn', 'tpms-calibration',
 'TPMS calibration — Civic Sedan (FC)',
 '## When to use\n\nAfter rotating tires, replacing a tire, or adjusting pressures. The Civic FC uses an **indirect** TPMS that compares wheel-speed rotation differences via ABS — it has no individual sensors.\n\n## Procedure\n\n1. Inflate all four tires to the placard pressure listed on the driver door jamb (cold).\n2. Push the **ENGINE START/STOP** to **ON** without starting the engine.\n3. Open the driver information display and scroll to **Vehicle Settings** → **TPMS Calibration**.\n4. Highlight **Calibrate** and confirm. The display reads **Calibration started**.\n5. Drive the vehicle for at least 30 minutes of mixed speeds (about 30–60 mph / 50–100 km/h). The system learns each wheel''s baseline during this drive.\n6. Calibration completes silently; no second confirmation is shown.\n\n## Notes\n\nCalibration restarts each time you tap Calibrate again — if the warning re-appears later, repeat the process. Different OE tire diameters (e.g. winter set) require a second calibration after each swap.\n'),
(@gen, 'battery_disconnect_order', 'battery-disconnect',
 'Battery disconnect order — Civic Sedan (FC)',
 '## Disconnect\n\n1. Park on level ground, ignition **OFF**, key fob outside the vehicle.\n2. Open the hood and locate the negative terminal (black, marked **−**) on the 12V battery in the engine bay.\n3. Loosen the negative cable nut with a 10 mm wrench and lift the clamp off the post. Tuck the cable aside so it cannot spring back.\n4. Only then loosen the positive terminal (red, **+**) if full removal is needed.\n\n## Reconnect\n\n1. Connect the **positive** cable first, then **negative**.\n2. After power is restored, sit in the driver seat and turn the steering wheel from full-left to full-right lock to allow EPS to re-learn centre.\n3. Drive a short distance to allow the ECU to relearn idle.\n\n## Notes\n\nThe radio anti-theft code (if applicable on early production) may require re-entry. Window auto-up will need to be reinitialised by holding the switch fully up for 2 seconds at the end of travel.\n'),
(@gen, 'jump_start', 'jump-start',
 'Jump-start — Civic Sedan (FC)',
 '## Prep\n\n1. Park the donor and dead vehicle close enough for cables to reach but not touching.\n2. Both engines **OFF**, parking brakes on, transmissions in **P**.\n\n## Connect (in this order)\n\n1. **Red** clamp to the dead Civic''s positive (+) terminal.\n2. **Red** clamp to the donor''s positive (+) terminal.\n3. **Black** clamp to the donor''s negative (−) terminal.\n4. **Black** clamp to a clean unpainted metal point on the dead Civic''s engine (such as the alternator bracket bolt), **not the battery negative**.\n\n## Start\n\n1. Start the donor and let it idle 2–3 minutes.\n2. Start the Civic. If it does not crank within ~5 seconds, wait 2 minutes and try again.\n3. With the Civic running, remove the cables in reverse order: black from engine ground, black from donor, red from donor, red from Civic.\n4. Drive the Civic for at least 30 minutes to recharge the battery.\n\n## Notes\n\nClamping the dead negative directly to the battery post risks an ignition source near hydrogen vapour. Use the engine ground instead.\n'),
(@gen, 'key_fob_battery', 'key-fob-battery',
 'Key fob battery replacement — Civic Sedan (FC)',
 '## Battery\n\nCR2032 lithium coin cell, 3 V.\n\n## Procedure\n\n1. Slide the mechanical key out of the fob using the release button on the back.\n2. Insert the mechanical key blade into the slot left by the removed key and twist gently to split the fob halves.\n3. Lift the old CR2032 out using a non-metallic pick. Note orientation (+ side up on most fobs).\n4. Press the new CR2032 in with the same orientation.\n5. Snap the halves back together and reinsert the mechanical key.\n\n## Notes\n\nAvoid touching the battery faces with bare fingers — skin oils shorten cell life. If the fob fails to operate the doors after replacement, hold it within 1 inch of the **ENGINE START/STOP** to use the backup low-power proximity range, which confirms the new cell is healthy.\n');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

-- =====================================================================
-- TOYOTA CAMRY XV70 2018-2024 — gen 2
-- =====================================================================
SET @gen := 2;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Toyota Camry%' AND is_public = 1 LIMIT 1);

INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'oil_life_reset', 'oil-maintenance-reset',
 'Oil maintenance light reset — Camry (XV70)',
 '## When to use\n\nAfter every engine oil and filter change. The Camry XV70 uses a fixed-interval reminder (10,000 mi / 16,000 km) that does not adapt to driving conditions.\n\n## Procedure\n\n1. Place ignition in **ON** without starting the engine.\n2. Cycle the trip meter button until **ODO** (total distance) is displayed.\n3. Turn ignition **OFF**.\n4. Press and hold the trip meter button, then turn ignition back to **ON** while still holding.\n5. Continue holding the trip button. The maintenance light flashes, then displays a series of dashes that count down to zero.\n6. Release the button when **000000** appears. The maintenance light is now cleared.\n7. Turn ignition **OFF** to confirm.\n\n## Notes\n\nIf the reset does not take, the trip button was likely released too early. The countdown takes about 5 seconds — wait for full zeros.\n'),
(@gen, 'tpms_relearn', 'tpms-register',
 'TPMS register — Camry (XV70)',
 '## When to use\n\nAfter installing new tires or swapping winter/summer wheel sets, the TPMS direct sensors need to be registered to the receiver.\n\n## Procedure\n\n1. Set all four tires to the cold placard pressure (driver door jamb).\n2. Park the vehicle, ignition **ON** (engine not running).\n3. Locate the **TPMS SET** button (under the steering column, lower left on most XV70 trims).\n4. Press and hold the TPMS SET button until the TPMS warning light blinks three times slowly, then release.\n5. Wait 20 minutes with the ignition on while the system samples each sensor at idle.\n6. The warning extinguishes when registration completes.\n\n## Notes\n\nIf the TPMS warning solid-illuminates after the procedure, one sensor failed to register. Verify pressures and try again, or scan with a TPMS tool to confirm sensor IDs.\n'),
(@gen, 'battery_disconnect_order', 'battery-disconnect',
 'Battery disconnect order — Camry (XV70)',
 '## Disconnect\n\n1. Ignition **OFF**, key outside, all doors closed for ≥ 30 seconds to let modules sleep.\n2. Open the hood, remove the engine cover if present.\n3. The 12V battery is in the engine bay (gas) or in the trunk (hybrid). On the hybrid, also disconnect the 12V auxiliary in the trunk before any work near HV components.\n4. Negative cable (10 mm) first — loosen, lift off, secure away from the post.\n5. Positive cable last.\n\n## Reconnect\n\n1. Positive first, then negative.\n2. Sit in the driver seat and turn the steering wheel lock-to-lock to re-centre EPS.\n3. Allow the Camry to idle for 3 minutes after reconnect so the ECU completes idle relearn.\n\n## Notes\n\nOn the **Camry Hybrid**, never touch the orange HV cables. The 12V auxiliary in the trunk is the only safe service point.\n'),
(@gen, 'jump_start', 'jump-start',
 'Jump-start — Camry (XV70)',
 '## Connect\n\n1. **Red** to dead Camry **+** terminal.\n2. **Red** to donor **+** terminal.\n3. **Black** to donor **−** terminal.\n4. **Black** to a clean unpainted bolt on the dead Camry''s engine block, not the battery post.\n\n## Hybrid note\n\nThe Camry Hybrid is jump-started from the under-hood **jump terminal** (red plastic cap), not the trunk 12V. Connect to the post under the cap, ground to the bracket bolt next to it.\n\n## Start\n\n1. Donor running 2–3 minutes.\n2. Start the Camry (or press **POWER** on hybrid — the READY light should appear).\n3. Remove cables in reverse order.\n4. Drive at least 30 minutes to recharge the 12V.\n'),
(@gen, 'spare_tire', 'spare-tire-change',
 'Spare tire change — Camry (XV70)',
 '## Locate equipment\n\nThe compact spare, jack, and lug wrench are under the rear cargo floor.\n\n## Procedure\n\n1. Park on a level firm surface, transmission in **P**, parking brake on, hazards on.\n2. Block the wheel diagonally opposite the flat (e.g. left rear for right front flat).\n3. Loosen the wheel-cover plastic clips if present, then crack the lug nuts a half-turn each before lifting.\n4. Position the jack under the dedicated lift point (notch in the pinch weld, just inboard of the wheel). Raise until the flat tire is about 30 mm off the ground.\n5. Remove the lug nuts in a star pattern and lift the tire off the studs.\n6. Mount the compact spare, hand-thread all five lug nuts.\n7. Lower the vehicle and torque the lug nuts to **103 N·m (76 ft·lb)** in a star pattern.\n8. Re-check the spare''s pressure (typically 60 psi / 420 kPa) before driving.\n\n## Notes\n\nThe compact spare is rated for ≤ 50 mph (80 km/h) and a maximum of 50 miles to a tire shop. Replace as soon as possible.\n');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

-- =====================================================================
-- BMW 3 SERIES G20 2019-2022 — gen 6
-- =====================================================================
SET @gen := 6;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'BMW 3 Series%' AND is_public = 1 LIMIT 1);

INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'service_reminder_reset', 'cbs-reset',
 'Condition Based Service (CBS) reset — 3 Series (G20)',
 '## When to use\n\nAfter completing an engine oil service, brake fluid service, or any other CBS item flagged in iDrive. BMW''s CBS system tracks each service independently — you reset only the item you completed.\n\n## Procedure (via iDrive 7.0)\n\n1. With the ignition in **ON** (engine off), press the **iDrive** controller knob and rotate to **Settings** → **Maintenance**.\n2. The display shows the list of CBS items with remaining km / time to each.\n3. Highlight the item you serviced (e.g. **Engine oil**) and press the controller.\n4. Select **Confirm reset**. The display updates the remaining km to the next interval.\n5. Repeat for additional items if multiple services were performed.\n\n## Procedure (via dashboard, no iDrive)\n\n1. Insert key, push **START/STOP** without pressing the brake to enter ignition **ON**.\n2. Press and hold the trip-meter reset button (under the speedometer, ~10 seconds) until the first CBS item appears.\n3. Short-press the same button to step through items.\n4. Long-press again on the item to reset.\n\n## Notes\n\nAfter battery replacement, the CBS counters are unaffected but the new battery must be **registered** (next procedure) — without registration the IBS misjudges charge state and the alternator over- or under-charges.\n'),
(@gen, 'battery_register', 'battery-register',
 'Battery registration — 3 Series (G20)',
 '## When to use\n\nAfter replacing the 12V AGM battery (group 94R / H8 on most G20). The IBS (Intelligent Battery Sensor) clamped to the negative terminal needs the new battery''s capacity and chemistry registered, or charge management drifts.\n\n## Procedure\n\nBMW G20 requires a diagnostic tool with battery-registration support:\n- **BMW ISTA** (dealer / Bimmercode CarPlay) — full registration.\n- **Aftermarket OBD scanners** like Foxwell NT510, Launch CRP123 BMW, Carly app — most can register.\n\nSteps (Carly app, example):\n1. Plug OBD adapter, start Carly, select **BMW**.\n2. Open **Battery Registration**.\n3. Select the new battery type (AGM 80 Ah / 90 Ah depending on PN).\n4. Confirm. The app reads the IBS and writes the new battery serial, capacity, and install date.\n\n## Notes\n\nReplacing AGM with a non-AGM (flooded) battery shortens battery life dramatically — BMW alternator profiles assume AGM. Always replace like-for-like.\n'),
(@gen, 'tpms_relearn', 'tpms-relearn',
 'Run-Flat Indicator (RPA) reset — 3 Series (G20)',
 '## When to use\n\nAfter tire pressure adjustment, rotation, or new tires. The G20 uses an indirect TPMS (called RPA) that compares rotational speed.\n\n## Procedure\n\n1. Set all four tires to the cold placard pressure (driver door jamb).\n2. With ignition **ON**, open iDrive → **Vehicle status** → **TPMS settings**.\n3. Select **Reset tire pressure monitor** → **Perform reset**.\n4. Drive for at least 10 minutes at varying speeds above 12 mph (20 km/h). The system calibrates silently during this drive.\n\n## Notes\n\nIf the vehicle is equipped with the optional direct TPMS sensors (M340i / M-Sport package), the procedure is the same — reset, then drive to relearn.\n'),
(@gen, 'jump_start', 'jump-start',
 'Jump-start — 3 Series (G20)',
 '## Locate jump terminals\n\nThe 12V battery on the G20 is in the **right rear of the trunk**, under the floor. Service jump terminals are in the engine bay:\n\n- **Positive (+)**: red plastic cap on the front-right strut tower.\n- **Negative (−)**: bare ground stud just inboard of the positive cap, or any clean engine bracket bolt.\n\n## Connect\n\n1. Red to dead G20''s **+** jump terminal under the red cap.\n2. Red to donor **+**.\n3. Black to donor **−**.\n4. Black to dead G20''s **ground stud** (not the battery in the trunk).\n\n## Start\n\n1. Donor running 2–3 minutes.\n2. Press the G20 **START/STOP** with the foot brake. The car should crank.\n3. Remove cables in reverse order.\n4. Drive ≥ 30 minutes to recharge and let the IBS update.\n\n## Notes\n\nNever attempt to jump-start from the trunk directly — the cables are not rated for that current, and the IBS sensor on the negative cable can be damaged.\n'),
(@gen, 'epb_service_mode', 'epb-service-mode',
 'Electric parking brake (EPB) service mode — 3 Series (G20)',
 '## When to use\n\nBefore replacing rear brake pads, rotors, or calipers on the G20. The EPB motor must be retracted electronically — manual winding will damage the actuator.\n\n## Procedure (via iDrive)\n\n1. Apply the EPB once with the button.\n2. Ignition **ON**, engine **OFF**.\n3. iDrive → **Vehicle status** → **Brakes** → **Workshop mode**.\n4. Confirm. The EPB motor retracts and the system enters service mode (dashboard shows a workshop icon).\n5. Replace pads / rotors with the EPB caliper now free.\n6. Re-enter iDrive **Workshop mode** and select **Exit** to restore normal EPB function.\n\n## Procedure (no iDrive support)\n\nUse a scan tool with BMW EPB support (Foxwell NT510 BMW, Autel MaxiCheck, Carly app). The function is typically labelled **Maintenance mode** or **Park brake calibration**.\n\n## Notes\n\nNever try to wind the rear caliper piston back manually — the G20''s EPB actuator is a motor-driven screw, and forcing it cracks internal gears (~$700 caliper).\n');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

SELECT 'procedures batch 1 inserted' AS status,
  (SELECT COUNT(*) FROM procedures WHERE generation_id IN (1,2,6)) AS rows_added;
