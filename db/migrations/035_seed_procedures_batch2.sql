-- Procedures seed — batch 2 (7 more generations: Highlander, Accord, F-150,
-- Silverado, Ram, Tesla, Outlander). Same restated-from-OEM-OM approach as 034.
-- Outlander GN procedures specifically cross-verified against the HaynesPro
-- WorkshopData Outlander GN (typeId t_619037936) Service indicator reset and
-- Steering angle sensor: initialisation entries during the 2026-05-19 session.

SET NAMES utf8mb4;

-- =====================================================================
-- TOYOTA HIGHLANDER XU70 2020-2025 — gen 41
-- =====================================================================
SET @gen := 41;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Toyota Highlander%' AND is_public = 1 LIMIT 1);

INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'oil_life_reset', 'oil-maintenance-reset',
 'Oil maintenance light reset — Highlander (XU70)',
 '## When to use\n\nAfter each engine oil and filter change. The Highlander XU70 (TNGA-K) uses Toyota''s fixed-interval reminder (10,000 mi / 16,000 km), same logic as the Camry XV70.\n\n## Procedure\n\n1. Place ignition in **ON** without starting the engine.\n2. Cycle the trip meter button (steering wheel **OK** + **<** combination on newer dashboards) until **ODO** is displayed.\n3. Turn ignition **OFF**.\n4. Press and hold the trip meter button, then turn ignition to **ON** again while holding.\n5. Continue holding until the maintenance icon flashes, then displays a series of dashes counting down to **000000**.\n6. Release the button when zeros appear.\n7. Turn ignition **OFF**. The maintenance reminder is cleared.\n\n## Hybrid note\n\nOn Highlander Hybrid, the procedure is identical — press **POWER** twice without the brake pedal to reach ignition **ON**. Do not enter READY mode.\n'),
(@gen, 'tpms_relearn', 'tpms-register',
 'TPMS register — Highlander (XU70)',
 '## When to use\n\nAfter installing new tires, swapping wheel sets, or sensor replacement.\n\n## Procedure\n\n1. Set all four tires (and the spare on AWD) to the cold placard pressure (driver door jamb, typically 35 psi / 240 kPa on 18"–20" wheels).\n2. Park with ignition **ON**, engine off.\n3. Locate the **TPMS SET** button (under the steering column on the lower instrument panel).\n4. Press and hold until the TPMS warning lamp blinks three times slowly.\n5. Release and wait up to 20 minutes for the system to register each sensor at idle, or drive at moderate speed for a similar time.\n\n## Notes\n\nThe Highlander spare-tire sensor is included on AWD trims with the conventional spare. Compact-spare models do not have a fifth sensor — the kit is included for tire repair only.\n'),
(@gen, 'battery_disconnect_order', 'battery-disconnect',
 'Battery disconnect order — Highlander (XU70)',
 '## Disconnect (gasoline)\n\n1. Ignition **OFF**, key outside the cabin, doors closed 30 seconds for modules to sleep.\n2. Open the hood, remove the cosmetic engine cover if present.\n3. Loosen the **negative** terminal nut (10 mm), lift the clamp off the post, secure aside.\n4. Loosen the **positive** terminal (red cap).\n\n## Disconnect (hybrid)\n\nThe 12V auxiliary battery is in the rear cargo area under the floor on Highlander Hybrid. Use the same negative-first order. Never touch the orange HV cables.\n\n## Reconnect\n\n1. Positive first, negative last.\n2. Sit in the driver seat, turn the steering wheel lock-to-lock to re-centre EPS.\n3. Idle for 3 minutes to let the ECU complete idle relearn.\n4. Reset any window auto-up by holding the switch full-up for 2 seconds at the top of travel.\n'),
(@gen, 'jump_start', 'jump-start',
 'Jump-start — Highlander (XU70)',
 '## Gasoline\n\nConnect in standard order:\n1. Red to dead Highlander **+**.\n2. Red to donor **+**.\n3. Black to donor **−**.\n4. Black to clean unpainted bolt on the dead Highlander''s engine block.\n\n## Hybrid\n\nThe rear 12V is small and not accessible. Use the **under-hood jump terminal** (red plastic cap on the fuse box) for **+**, and the negative ground stud nearby for **−**. The procedure is identical except for terminal location.\n\n## Start\n\n1. Donor running 2–3 minutes.\n2. Hybrid: press **POWER** with the brake; READY light confirms HV startup. Gas: turn ignition.\n3. Remove cables in reverse order.\n4. Drive ≥ 30 minutes; on hybrid, this also charges the high-voltage battery by extension.\n'),
(@gen, 'key_fob_battery', 'key-fob-battery',
 'Key fob battery — Highlander (XU70)',
 '## Battery\n\nCR2032 lithium coin cell, 3 V.\n\n## Procedure\n\n1. Slide the mechanical key out of the fob.\n2. Use the slot to twist the fob halves apart.\n3. Lift the old CR2032 out (+ side up).\n4. Insert the new cell same orientation.\n5. Snap the halves back together; reinsert the mechanical key.\n\nIf the fob is unresponsive after replacement, the new cell may be partially discharged from storage. Try a fresh CR2032 from a sealed pack.\n'),
(@gen, 'spare_tire', 'spare-tire-change',
 'Spare tire change — Highlander (XU70)',
 '## Locate\n\nThe compact spare (T155/70 D18) and tool kit are under the rear cargo floor. AWD trims with the full-size spare have the same location.\n\n## Procedure\n\n1. Level firm surface, **P**, parking brake on, hazards on.\n2. Block the wheel diagonally opposite the flat.\n3. Crack the lug nuts a half-turn before lifting.\n4. Jack at the dedicated lift point (notch in the pinch weld inboard of the wheel).\n5. Remove lugs in a star pattern, swap tire, hand-thread lugs.\n6. Lower vehicle, torque lugs to **103 N·m (76 ft·lb)** in a star pattern.\n7. Re-check spare pressure (typically 60 psi / 420 kPa).\n\n## Notes\n\nCompact spare is rated for ≤ 50 mph (80 km/h) and ≤ 50 miles total distance to a tire shop. The AWD electronic coupling is designed for matched diameters — extended use of a smaller-diameter compact spare can stress the coupling.\n');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

-- =====================================================================
-- HONDA ACCORD CV 2023-present — gen 42
-- =====================================================================
SET @gen := 42;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Honda Accord%' AND is_public = 1 LIMIT 1);

INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'maintenance_minder_reset', 'maintenance-minder-reset',
 'Maintenance Minder reset — Accord (CV)',
 '## When to use\n\nAfter completing any item the Maintenance Minder flagged (A1, B1, etc.). The Accord CV uses the same MM logic as the Civic FC but the UI is on a larger 10.2" digital cluster.\n\n## Procedure\n\n1. Push the **ENGINE START/STOP** twice without the brake to enter ignition **ON**.\n2. On the digital cluster, use the steering wheel right-pad arrows to scroll to the **Settings** menu.\n3. Select **Vehicle** → **Maintenance Info**.\n4. Choose the item(s) just serviced (Engine oil, Tire rotation, etc.) and select **Reset**.\n5. Confirm. The MM display will show **Maintenance reset complete**.\n6. Cycle the ignition off, then on; verify no wrench icon.\n\n## Hybrid note\n\nOn Accord Hybrid (e:HEV), enter ignition without engaging READY (no brake). The MM tracks separate counters for the engine-oil sub-system; the ICE only runs intermittently on hybrid, so the elapsed-time counter often triggers before mileage.\n'),
(@gen, 'tpms_relearn', 'tpms-calibration',
 'TPMS calibration — Accord (CV)',
 '## When to use\n\nAfter rotating tires, replacing a tire, or adjusting pressures. The Accord CV uses indirect TPMS (ABS-based) — no individual sensors.\n\n## Procedure\n\n1. Inflate to placard pressure (driver door jamb, 32 psi / 220 kPa on 17"; 33 psi / 230 kPa on 19").\n2. Ignition **ON**, engine off.\n3. Cluster → **Settings** → **Vehicle** → **TPMS Calibration** → **Calibrate**.\n4. Drive for 30+ minutes mixed speeds. Calibration completes silently.\n\n## Notes\n\nCalibration must be redone after any season-tire swap if rolling diameters differ. The system tolerates ~3% diameter variance; bigger differences will throw false low-pressure warnings.\n'),
(@gen, 'battery_disconnect_order', 'battery-disconnect',
 'Battery disconnect order — Accord (CV)',
 '## Disconnect\n\n1. **Engine OFF**, key outside, doors closed 30 seconds for modules to sleep.\n2. Hood open. The 12V battery is in the engine bay (gasoline) or driver-side engine bay (hybrid; the high-voltage IPU is under the trunk floor on hybrid — do not touch HV).\n3. Negative (10 mm) first, then positive (red cap).\n\n## Reconnect\n\n1. Positive first, negative last.\n2. Steering lock-to-lock to re-centre EPS.\n3. Allow Honda Sensing to recalibrate over the first 5 minutes of driving (the system runs its own forward-camera self-check).\n\n## Notes\n\nAfter battery disconnect on hybrid Accord, the e:HEV system may need a single drive cycle of 5 minutes before all hybrid functions are fully available (regen, EV mode availability).\n'),
(@gen, 'jump_start', 'jump-start',
 'Jump-start — Accord (CV)',
 '## Connect\n\n1. Red to dead Accord **+**.\n2. Red to donor **+**.\n3. Black to donor **−**.\n4. Black to a clean unpainted bolt on the dead Accord''s engine block (alternator bracket or engine lifting eye are good ground points).\n\n## Hybrid\n\nThe **e:HEV Accord** uses the same 12V battery in the engine bay as the gasoline model. The HV traction battery is separate (IPU under trunk) and **cannot** be jump-started.\n\n## Start\n\n1. Donor running 2–3 minutes.\n2. Accord: press **POWER** with brake (hybrid: READY light confirms; gasoline: engine cranks).\n3. Remove cables in reverse order.\n4. Drive ≥ 30 minutes.\n'),
(@gen, 'key_fob_battery', 'key-fob-battery',
 'Key fob battery — Accord (CV)',
 '## Battery\n\nCR2032 lithium coin cell, 3 V.\n\n## Procedure\n\n1. Slide the emergency key out using the release latch.\n2. Insert the emergency key blade into the slot and twist gently to split the fob.\n3. Replace the CR2032 (+ side up).\n4. Snap the halves back together.\n\n## Notes\n\nUnlike Civic FC, the Accord CV fob uses an integrated NFC chip for backup unlock — hold the fob to the **handle pad** (not the START button) when the battery dies. The NFC range is shorter than active RF (about 1 inch).\n');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

-- =====================================================================
-- FORD F-150 P702 2021-2025 — gen 26
-- =====================================================================
SET @gen := 26;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Ford F-150%' AND is_public = 1 LIMIT 1);

INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'oil_life_reset', 'oil-life-reset',
 'Intelligent Oil-Life Monitor reset — F-150 (P702)',
 '## When to use\n\nAfter each engine oil and filter change. The F-150 P702 uses Ford''s Intelligent Oil-Life Monitor (IOLM) which adapts to driving conditions and may show service due anywhere from 5,000 to 10,000 miles.\n\n## Procedure (touchscreen — SYNC 4 / SYNC 4A)\n\n1. Push the **START/STOP** twice without the brake to enter ignition **ON**.\n2. Tap **Settings** → **Vehicle** → **Oil Life**.\n3. Confirm **Reset Oil Life to 100%**.\n4. The screen confirms the reset.\n\n## Procedure (instrument cluster)\n\n1. Cycle ignition to **ON**.\n2. Steering wheel left-pad: scroll to **Information** → **Vehicle Health** → **Oil Life**.\n3. Press and hold **OK** for 3 seconds. The percentage resets to 100%.\n\n## PowerBoost hybrid note\n\nThe 3.5L PowerBoost hybrid follows the same procedure. The hybrid system''s start-stop cycles will not affect oil-life calculation — IOLM measures elapsed engine running time, not key cycles.\n'),
(@gen, 'tpms_relearn', 'tpms-relearn',
 'TPMS relearn — F-150 (P702)',
 '## When to use\n\nAfter tire rotation, sensor replacement, or seasonal wheel swap. The F-150 has direct TPMS sensors at each wheel.\n\n## Procedure\n\n1. Set all tires (including spare on payload-package trims) to placard pressure.\n2. Ignition **ON** (don''t start the engine).\n3. Press the **brake pedal** while pressing **brake** twice — Ford''s sequence is: press and release brake pedal once. Within 5 seconds press it again. Repeat for a total of three presses.\n4. Cycle the **headlight switch** from **OFF → PARK → HEAD → PARK → HEAD → PARK → HEAD** (three times to HEAD).\n5. The horn sounds once and the TPMS lamp flashes — relearn mode is active.\n6. Start at the **left front** tire. Hold a magnet or TPMS activation tool over the valve stem. The horn chirps when that sensor reports.\n7. Repeat clockwise: **right front → right rear → left rear** (and **spare** if equipped).\n8. After all sensors confirm, the horn double-chirps to exit relearn mode.\n\n## Notes\n\nIf the horn does not sound after the third headlight cycle, the sequence timed out — start over from step 3. Some F-150 trims allow OBD-tool relearn via FORScan or a TPMS reset tool, which is faster.\n'),
(@gen, 'battery_disconnect_order', 'battery-disconnect',
 'Battery disconnect order — F-150 (P702)',
 '## Disconnect\n\n1. **Ignition OFF**, key outside, doors closed for 30 seconds.\n2. Open hood. Standard ICE has one 12V battery on the right (passenger) side. **PowerBoost hybrid** has a second 12V auxiliary in the same bay.\n3. Negative (10 mm) first, lift off, secure aside.\n4. Positive (red cap) last.\n5. On **PowerBoost**, disconnect both 12V batteries (auxiliary first, then main).\n\n## Reconnect\n\n1. Positive first, negative last.\n2. Steering lock-to-lock to recentre EPS.\n3. Start and idle 3 minutes for ECU idle relearn.\n4. Drive several miles; any active Ford camera-based assist (Blind Spot, Pre-Collision) self-calibrates during normal driving.\n\n## Notes\n\nF-150 has a Battery Management System (BMS) — after replacement, the BMS must be told the new battery''s amp-hour rating. This requires FORScan or dealer IDS. Without it, charge state estimation drifts and start-stop becomes erratic.\n'),
(@gen, 'jump_start', 'jump-start',
 'Jump-start — F-150 (P702)',
 '## Locate\n\n12V battery (right-side engine bay). Jump posts are clearly marked on the battery.\n\n## Connect\n\n1. Red to dead F-150 **+**.\n2. Red to donor **+**.\n3. Black to donor **−**.\n4. Black to a clean unpainted bolt on the dead F-150''s engine block.\n\n## PowerBoost\n\nWith the PowerBoost hybrid 12V system, donor capacity matters more — both 12V batteries draw together at start. Use a donor with at least 600 CCA, or a jump pack rated for 1500A peak.\n\n## Start\n\n1. Donor running 2–3 minutes.\n2. Push **START/STOP** with brake.\n3. Remove cables in reverse order.\n4. Drive ≥ 30 minutes.\n\n## Notes\n\nF-150 Lightning (electric, not P702 conventional) uses a high-voltage architecture and cannot be jump-started this way — it has its own 12V auxiliary and can also act as a jump source for other vehicles via Pro Power Onboard.\n'),
(@gen, 'spare_tire', 'spare-tire-change',
 'Spare tire lower & change — F-150 (P702)',
 '## Locate equipment\n\nFull-size spare under the bed, jack and lug wrench behind the rear seat (SuperCrew/SuperCab) or in the glovebox compartment (Regular Cab).\n\n## Lower the spare\n\n1. Insert the jack handle through the bumper access hole into the spare-tire winch coupling.\n2. Turn the handle **counterclockwise** to lower the spare to the ground.\n3. Disconnect the cable retainer from the wheel.\n4. Slide the spare out from under the truck.\n\n## Swap the wheel\n\n1. Crack the lug nuts on the flat a half-turn before lifting.\n2. Jack at the frame rail next to the affected wheel (avoid the rear differential housing).\n3. Remove lugs in a star pattern, swap wheels.\n4. Hand-thread lugs, lower vehicle, torque to **176 N·m (130 ft·lb)** in star pattern. Re-torque after 100 miles.\n\n## Stow the flat\n\n1. Slide the flat under the bed with the valve stem facing **down** (matches the spare orientation).\n2. Connect the cable retainer through the centre of the wheel.\n3. Turn the jack handle **clockwise** to raise the flat into the storage position until the winch clicks.\n4. Verify the flat is snug against the underbody.\n');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

-- =====================================================================
-- CHEVROLET SILVERADO T1 2019-2024 — gen 38
-- =====================================================================
SET @gen := 38;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Chevrolet Silverado%' AND is_public = 1 LIMIT 1);

INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'oil_life_reset', 'oil-life-reset',
 'Oil-Life System reset — Silverado (T1)',
 '## When to use\n\nAfter each oil change. GM''s Oil-Life System (OLS) adapts to driving conditions.\n\n## Procedure (DIC button method)\n\n1. Ignition **ON**, engine off.\n2. Press **MENU** on the driver-information centre (DIC) repeatedly until **Vehicle Information** appears.\n3. Press the up/down arrows to scroll to **Oil Life**.\n4. Press and hold **SET/CLR** until **100% Oil Life** is displayed.\n\n## Procedure (gas pedal method, older T1 models without DIC button)\n\n1. Ignition **ON**, engine off.\n2. Within 5 seconds press the accelerator pedal **fully to the floor and release three times**.\n3. The Change Engine Oil light flashes, then extinguishes — reset complete.\n\n## Notes\n\nDuramax diesel T1 (3.0L LM2) shows oil-life in the same menu but tracks a separate fuel-dilution counter not visible to the driver. DPF regen frequency affects oil-life prediction.\n'),
(@gen, 'tpms_relearn', 'tpms-relearn',
 'TPMS relearn — Silverado (T1)',
 '## When to use\n\nAfter rotating tires, replacing a sensor, or seasonal wheel swap.\n\n## Procedure (without scan tool)\n\n1. Park, ignition **ON**, transmission in **P**.\n2. From the DIC, scroll to **Tire Pressure** and press **SET/CLR** to enter learn mode. The horn chirps and the left-front turn signal illuminates.\n3. Hold a magnet or sensor activator over the **left front** valve stem. Horn chirps once when learned.\n4. Within 90 seconds move to **right front**, **right rear**, **left rear** — each chirps as learned.\n5. After all four chirp, the horn double-chirps. Relearn is complete.\n\n## Notes\n\nIf the relearn times out (90-second gap), restart from step 2. Most TPMS reset tools (~$20) work — they emit a 125 kHz signal that triggers the sensor without holding a magnet.\n'),
(@gen, 'battery_disconnect_order', 'battery-disconnect',
 'Battery disconnect — Silverado (T1)',
 '## Disconnect\n\n1. Ignition **OFF**, key outside, doors closed.\n2. Hood open. 12V battery is on the passenger side. The 5.3L L84 and 6.2L L87 V8 may have a second battery (dual-battery package on diesel and tow-prep trims).\n3. Negative first (10 mm), then positive.\n4. On dual-battery trucks, repeat on both batteries — negatives off both before positives.\n\n## Reconnect\n\n1. Positive first, negative last (on both batteries if dual).\n2. Steering lock-to-lock for EPS recentre.\n3. Idle 3 minutes. T1 with 10-speed (10L80) may need a short drive to recalibrate adaptive shifts.\n\n## Notes\n\nGM trucks with **stop-start** have a separate small battery in the engine bay for the starter circuit. Replacing it requires the same negative-first order; the BCM auto-detects the new battery.\n'),
(@gen, 'jump_start', 'jump-start',
 'Jump-start — Silverado (T1)',
 '## Connect\n\n1. Red to dead Silverado **+** post or jump terminal.\n2. Red to donor **+**.\n3. Black to donor **−**.\n4. Black to a clean unpainted bolt on the dead Silverado''s engine block (engine lifting eye works well).\n\n## Start\n\n1. Donor running 2–3 minutes.\n2. Start the Silverado (or press **START/STOP**).\n3. Remove cables in reverse order.\n4. Drive ≥ 30 minutes to recharge.\n\n## Notes\n\nDiesel T1 (3.0L LM2 Duramax) cranks longer than gas at low temperature. If the donor is a small sedan, run donor for 5+ minutes first to top up before attempting start.\n'),
(@gen, 'spare_tire', 'spare-tire-change',
 'Spare tire lower & change — Silverado (T1)',
 '## Lower the spare\n\nFull-size spare under the bed. Tools in the rear seat area.\n\n1. Insert the extension and lug wrench through the bumper access hole.\n2. Turn **counterclockwise** to lower the spare. Continue until the retainer is on the ground.\n3. Disconnect the retainer through the wheel centre.\n4. Slide the spare out.\n\n## Swap the wheel\n\n1. Crack lugs on the flat half a turn.\n2. Jack at the frame rail next to the affected wheel.\n3. Remove lugs in a star pattern.\n4. Mount spare, hand-thread lugs.\n5. Lower vehicle, torque lugs to **190 N·m (140 ft·lb)** in a star pattern.\n\n## Stow the flat\n\nValve stem **down** to match the carrier. Connect retainer through centre, turn **clockwise** until the winch clicks. Verify snug fit.\n');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

-- =====================================================================
-- RAM 1500 DT 2019-2024 — gen 43
-- =====================================================================
SET @gen := 43;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Ram 1500%' AND is_public = 1 LIMIT 1);

INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'oil_life_reset', 'oil-change-indicator-reset',
 'Oil Change Indicator System reset — Ram 1500 (DT)',
 '## When to use\n\nAfter each oil change. Mopar''s Oil Change Indicator System (OCIS) adapts to driving conditions — typical interval is 10,000 mi normal / 4,000 mi severe.\n\n## Procedure (via Uconnect)\n\n1. Press **START/STOP** twice without the brake to enter ignition **ON**.\n2. On the Uconnect display, tap **Controls** → **Vehicle Maintenance** → **Oil Change Indicator**.\n3. Tap **Reset** and confirm.\n4. Cycle the ignition off, then on; the wrench icon should be cleared.\n\n## Procedure (via instrument cluster, no Uconnect 5)\n\n1. Ignition **ON**, engine off.\n2. Within 10 seconds, press the **accelerator pedal slowly to the floor three times in succession**.\n3. Turn ignition **OFF** then **ON**. Cluster should display **Oil Change Required** as cleared.\n\n## eTorque note\n\nThe 3.6L Pentastar eTorque uses a belt-driven motor generator that runs briefly at every key-off. This idle time **is** counted in OCIS. Hybrid-driving patterns can extend the interval beyond 10k mi.\n'),
(@gen, 'tpms_relearn', 'tpms-relearn',
 'TPMS sensor relearn — Ram 1500 (DT)',
 '## When to use\n\nAfter rotating tires, replacing a sensor, or seasonal wheel swap.\n\n## Procedure\n\nThe Ram 1500 DT uses **auto-relearn** — the system samples sensor IDs during driving and updates automatically. No manual relearn is required in normal use.\n\n1. Adjust all four tires to the cold placard pressure (driver door jamb, typically 35 psi normal / 40-45 psi tow).\n2. Drive at speeds above 15 mph (24 km/h) for 20+ minutes.\n3. The TPMS warning extinguishes once all four sensors are paired.\n\n## Manual relearn (if auto fails)\n\n1. Ignition **ON**, engine off.\n2. Uconnect → **Settings** → **Tire Pressure Monitoring** → **Train Sensors**.\n3. Follow on-screen prompts (left front, right front, right rear, left rear, plus spare on dual-battery package trims).\n4. Hold a TPMS activator over each valve stem; horn chirps confirm pairing.\n\n## Notes\n\nThe TRX (6.2L SC) uses different OE tire diameters and pressure profile (32 psi); use the door jamb on a TRX, not generic 35 psi.\n'),
(@gen, 'battery_disconnect_order', 'battery-disconnect',
 'Battery disconnect order — Ram 1500 (DT)',
 '## Disconnect\n\n1. **Ignition OFF**, key outside, doors closed 30 seconds.\n2. Open hood. The main 12V is on the **passenger side** of the engine bay. eTorque trucks have a small **48V belt-starter battery** in the same bay — **do not disconnect** the 48V unless you are servicing it (and only with the system isolated per FSM).\n3. Loosen the negative terminal (10 mm) on the main 12V, lift the clamp off.\n4. Loosen the positive (red cap).\n\n## Reconnect\n\n1. Positive first, then negative.\n2. Steering lock-to-lock.\n3. Idle 3 minutes; on eTorque, allow the truck to sit in **D** with foot on brake for 30 seconds for the 48V system to re-handshake before driving.\n\n## Notes\n\nThe TRX (6.2L SC V8, no eTorque) is a conventional single-battery system. The diesel EcoDiesel has a beefier H8 AGM but follows the same procedure.\n'),
(@gen, 'jump_start', 'jump-start',
 'Jump-start — Ram 1500 (DT)',
 '## Connect\n\n1. Red to dead Ram **+** post.\n2. Red to donor **+**.\n3. Black to donor **−**.\n4. Black to clean unpainted bolt on the dead Ram''s engine block (engine lifting eye on Pentastar / HEMI is a good ground).\n\n## eTorque\n\nThe eTorque belt-starter generator may handle starting once the 12V has a small charge. After connecting jumpers, wait 1 minute before pressing **START/STOP** to let the 48V system stabilise.\n\n## Start\n\n1. Donor running 2–3 minutes.\n2. Press **START/STOP** with brake.\n3. Remove cables in reverse order.\n4. Drive ≥ 30 minutes.\n');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

-- =====================================================================
-- TESLA MODEL 3 2017-2023 — gen 25
-- =====================================================================
SET @gen := 25;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Tesla Model 3%' AND is_public = 1 LIMIT 1);

INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'service_reminder_reset', 'cabin-filter-reset',
 'Cabin air filter service reminder reset — Model 3',
 '## When to use\n\nAfter replacing the cabin HEPA / cabin filter. Tesla''s Model 3 doesn''t use the Maintenance Minder concept many ICE cars do, but it does track filter service and brake-fluid moisture content.\n\n## Procedure (via touchscreen)\n\n1. With the car awake, tap **Controls** (car icon, bottom left).\n2. Tap **Service** → **Cabin Filter**.\n3. Tap **Reset** and confirm.\n4. The countdown for the next service window restarts (2 years on standard cabin filter, 3 years on HEPA).\n\n## Notes\n\nModel 3 cabin filter access is behind the passenger-side dash kick panel. Two filters stacked — replace both as a set.\n'),
(@gen, 'tpms_relearn', 'tpms-pairing',
 'TPMS pairing — Model 3',
 '## When to use\n\nAfter tire rotation, sensor replacement, or wheel-set swap.\n\n## Procedure\n\nModel 3 (pre-LCI without UWB sensors) uses auto-relearn after driving:\n\n1. Set placard pressures (front 42 psi / rear 42 psi for the OE Aero/Sport 18"/19").\n2. Drive at 25+ mph for 10+ minutes.\n3. TPMS pairs automatically; warning extinguishes.\n\nFor the **2022+ Refresh** with UWB (ultra-wideband) sensors, pairing also happens automatically but requires the car to be parked outside with clear sky view for the UWB to triangulate sensor positions to corners (front-left, front-right, etc.) — this is what enables per-wheel pressure display on the touchscreen.\n\n## Notes\n\nThird-party non-UWB sensors will still report pressure but the touchscreen will show generic numbered positions rather than corner labels.\n'),
(@gen, 'battery_disconnect_order', 'battery-12v-replacement',
 '12V auxiliary battery replacement — Model 3',
 '## When to use\n\nThe Model 3 12V battery (lead-acid pre-2021, lithium-iron-phosphate 2021+) supports the touchscreen, lights, and computers. Replacement interval is 3–5 years (lead-acid) or 8–10 years (LiFePO4 on Refresh).\n\n## Procedure\n\n**Do not** start work without putting the car in High-Voltage Disable mode:\n\n1. Touch **Service** → **Power Off** on the touchscreen. The car powers down (interior lights go off, contactors open).\n2. Wait 2 minutes minimum before opening any covers.\n3. Open the frunk. Lift the maintenance panel (push fasteners). The 12V battery sits under a metallic shield.\n4. Disconnect the **negative** terminal first, secure away from the post.\n5. Disconnect the **positive** terminal.\n6. Remove the holddown bracket and lift out the battery.\n\n## Reconnect\n\n1. Positive first, then negative.\n2. Reinstall shield.\n3. The car wakes when the key card is presented; on the touchscreen, an alert may indicate **12V battery has been replaced** — confirm to dismiss.\n\n## Notes\n\nNever attempt this on a Tesla without the touchscreen Power Off step — disconnecting 12V with HV contactors closed can crash multiple modules and require service centre re-flashing.\n'),
(@gen, 'jump_start', 'external-12v-power',
 'External 12V power (jump-start equivalent) — Model 3',
 '## When to use\n\nIf the 12V is too dead to open the frunk or wake the car, an external 12V supply can power the low-voltage bus enough to use the frunk release.\n\n## Procedure\n\n1. Pry off the small panel on the **front fascia** near the right (passenger) side of the lower bumper to expose two tow-eye threads — these are not 12V access.\n2. Instead, gently pry off the tab panel on the lower bumper directly under the headlight. Two pigtail wires (red and black) emerge.\n3. Connect a 12V donor with jumper clamps: red to red, black to black, **briefly** (15 seconds).\n4. Press the frunk release on the keycard or key fob. The frunk pops.\n5. Disconnect the external supply and proceed with full 12V replacement (above).\n\n## Critical safety\n\nDo **not** attempt to jump-start the car as you would an ICE — the Model 3 contactors are HV interlocked, and engaging them with weak 12V can damage the BMS or pyro disconnects. The external 12V is **only** for opening the frunk.\n'),
(@gen, 'key_fob_battery', 'key-card-battery',
 'Key card / phone key / fob battery — Model 3',
 '## Primary keys\n\nModel 3 ships with two **key cards** (NFC). The optional **key fob** uses a CR2032.\n\n## Phone key — no battery\n\nThe phone-key app uses Bluetooth Low Energy on the paired phone. The phone''s battery is the only one in play. If you lose Bluetooth, use the key card on the B-pillar reader.\n\n## Fob battery replacement\n\n1. Pry the cap off the back of the fob with a coin or non-marring tool.\n2. Lift the old CR2032 out (+ up).\n3. Insert new cell same orientation.\n4. Snap the cap back on.\n\nNo re-pairing required after a fob battery swap.\n');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

-- =====================================================================
-- MITSUBISHI OUTLANDER GN 2022-2025 — gen 30
-- HaynesPro live-extracted (typeId t_619037936) Service indicator reset + SAS
-- =====================================================================
SET @gen := 30;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Mitsubishi Outlander%' AND is_public = 1 LIMIT 1);

INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md) VALUES
(@gen, 'service_reminder_reset', 'service-indicator-reset',
 'Service indicator reset — Outlander (GN)',
 '## When to use\n\nAfter completing the scheduled oil-control-system service. The GN-platform Outlander (shared with Nissan X-Trail T33) uses a menu-driven reset on the multifunction steering wheel.\n\n## Procedure\n\n1. Turn the ignition switch to the **ON** position. Do not start the engine.\n2. Use the multifunction steering wheel controls to scroll through the driver-info display menu.\n3. Open **SETTINGS** → **MAINTENANCE** → **Oil control system**.\n4. Highlight the reset prompt and press **OK**.\n5. Confirm the selection.\n6. The new interval period is shown briefly.\n7. Exit the menu. The reset is complete.\n\n## Notes\n\nIf the menu path does not appear, the vehicle may not yet have detected service due — the reset is only offered after the threshold is crossed.\n'),
(@gen, 'steering_angle_calibration', 'sas-initialisation',
 'Steering angle sensor initialisation — Outlander (GN)',
 '## When to use\n\nAfter wheel alignment, replacement of the steering rack, replacement of the steering angle sensor, or any battery disconnect that affects the ABS module.\n\n## Procedure\n\n1. Start the engine and let it idle.\n2. With the engine running, turn the steering wheel slowly from **lock to lock**.\n3. Drive the vehicle in a straight line at moderate speed for at least 5 minutes.\n4. The system completes the initialisation passively during this drive.\n5. If the SAS warning persists after step 3, connect a diagnostic tool with Mitsubishi (or Nissan) coverage and trigger **Steering Angle Sensor Calibration** in the ABS module.\n\n## Notes\n\nThe GN Outlander shares its ADAS suite with the X-Trail T33 — many SAS issues throw codes in both the ABS module and the ProPILOT ADAS controller. After SAS calibration, the forward-camera self-calibration runs automatically when speed exceeds 25 mph (40 km/h) on a marked road.\n'),
(@gen, 'battery_disconnect_order', 'battery-disconnect',
 'Battery disconnect order — Outlander (GN)',
 '## Disconnect\n\n1. **Ignition OFF**, key outside, doors closed 30 seconds.\n2. The 12V battery is in the **engine bay**.\n3. Negative (10 mm) first, lift off, secure aside.\n4. Positive (red cap) last.\n\n## Reconnect\n\n1. Positive first, negative last.\n2. After reconnect, the SAS will need re-initialisation (see procedure above).\n3. Lock-to-lock to start the EPS re-centre.\n4. Idle 3 minutes for the engine ECU.\n\n## Notes\n\nThe Outlander PHEV (different platform, GG/GF generation) carries a 12V auxiliary in the cargo area in addition to the high-voltage traction battery. The GN gas version is conventional single-battery.\n'),
(@gen, 'jump_start', 'jump-start',
 'Jump-start — Outlander (GN)',
 '## Connect\n\n1. Red to dead Outlander **+** post.\n2. Red to donor **+**.\n3. Black to donor **−**.\n4. Black to clean unpainted bolt on the dead Outlander''s engine block.\n\n## Start\n\n1. Donor running 2–3 minutes.\n2. Press **START/STOP** with brake.\n3. Remove cables in reverse order.\n4. Drive ≥ 30 minutes.\n\nAfter restart, the SAS may need re-initialisation if the battery was severely discharged — drive in a straight line for 5 minutes to allow passive calibration.\n');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

SELECT 'procedures batch 2 inserted' AS status,
  (SELECT COUNT(*) FROM procedures WHERE generation_id IN (25,26,30,38,41,42,43)) AS rows_added;
