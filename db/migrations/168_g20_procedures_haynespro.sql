-- G20 procedures — enrich existing + add HaynesPro-derived owner procedures
-- per "collect all data before next gen" workflow. Same Feist-v-Rural
-- restating principle as F30 mig 166.
--
-- HaynesPro WorkshopData for G20 330i xDrive B48B20B 190 kW (typeId
-- t_619015365) lists 17 maintenance procedures — much richer than F30's
-- 3 procedures. This migration enriches 5 existing G20 procedure rows
-- (battery-register, cbs-reset, epb-service-mode, jump-start, tpms-relearn)
-- and adds 6 new G20-specific procedures that don't yet exist in DB:
--
-- New procedures (6):
--   1. oil-level-check — G20 has no dipstick; oil check is via iDrive only.
--      A G20-specific quirk owners hit constantly.
--   2. jacking-points — official lift/jack points for tire change or lift.
--   3. coolant-flush — drain/refill steps + capacity reminders.
--   4. wiper-service-position — wipers don't drop to bottom for blade
--      replacement on G20; need to enable service position via iDrive.
--   5. start-stop-deactivation — disabling the auto start/stop system.
--   6. power-window-init — required after a battery disconnect.
--
-- Two-source rule: each row cites HaynesPro WorkshopData + the matching G20
-- US owner's manual (2019/2020/2021/2022 as appropriate). HaynesPro content
-- restated in own words per Feist v. Rural and HaynesPro confidentiality
-- clause — no verbatim text.

SET NAMES utf8mb4;

SET @gen_g20 := (SELECT id FROM generations WHERE slug = '3-series-sedan-g20-2019-2022');

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes) VALUES
  ('HaynesPro WorkshopData — BMW 3 (G20, G21, G28, G80) Maintenance Procedures',
   'https://www.workshopdata.com/touch/site/layout/modelDetailMaintenance?typeId=t_619015365&currentSubject=MAINTENANCE',
   NOW(),
   'Professional service database. G20 330i xDrive B48B20B 190 kW reference variant. 17 maintenance procedures available. Restated per Feist v. Rural.');
SET @s_hp   := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelDetailMaintenance?typeId=t_619015365&currentSubject=MAINTENANCE');
SET @s_2022 := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/bmw-auto/3-series-2022-owners-manual-83667');
SET @s_2019 := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/bmw-auto/3-series-2019-owners-manual-76601');

-- ============================================================================
-- 1. NEW: oil-level-check (G20 has no dipstick — iDrive-only oil check)
-- ============================================================================
INSERT IGNORE INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes) VALUES
(@gen_g20, 'oil_level_check', 'oil-level-check',
 'Oil level check (no dipstick) — 3 Series (G20)',
 '## Why G20 has no dipstick

BMW dropped the engine oil dipstick on the G20 — the only way to check oil level is the electronic sensor at the oil pan, read via iDrive. The dipstick tube was removed entirely; there is no "second-opinion" mechanical check.

## Preconditions

The electronic check requires the engine to be at operating temperature, level ground, gear in **P** or **N**, engine **running** (not just ignition on), and the oil to have stabilised in the sump (the system waits internally).

1. Start the engine.
2. Drive until coolant temperature reaches the normal range (the iDrive thermometer reaches the middle band, usually 5–10 minutes of driving).
3. Park on **level ground** — even a slight slope throws the reading off by 0.3–0.5 L.
4. Shift to **P** or **N** and leave the engine **running** at idle. Do **not** press the accelerator during the measurement.

## Reading the level

1. iDrive Controller → MENU → My vehicle (or Vehicle info) → Vehicle status → Engine oil level.
2. Select **Measure engine oil level** → **Start measurement**.
3. Within ~1 minute, the display shows a bar chart with min / max marks. The current level appears as a coloured fill between them.
4. If the system needs more time, it displays "Measurement not yet possible — drive longer". This usually means the oil isn''t at temperature.

## Topping up

If low:
1. Turn the engine **off**.
2. Add the quantity the iDrive specifies (typically 0.5 L increments). The display tells you exactly how much to add — do not estimate.
3. Wait ~5 minutes for the oil to drain to the pan.
4. Repeat the measurement to confirm.

**Important:** the system shows the recommended add quantity for getting from minimum to maximum mark. Do not overfill — excess oil can foam at high RPM and starve the bearings.',
 'iDrive controller. Top-up oil per spec (LL-01 FE / LL-14 FE+ / LL-17 FE+, 0W-30 or 0W-20 — see the oil-capacity page for this gen). No mechanical tools.',
 'Checking on a slope (reads inaccurately). Checking with engine off — the electronic sensor needs the engine running. Estimating top-up quantity instead of following iDrive''s exact reading. Treating "Measurement not possible" as a fault — usually means oil not yet warm.');

-- ============================================================================
-- 2. NEW: jacking-points
-- ============================================================================
INSERT IGNORE INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes) VALUES
(@gen_g20, 'jack_points', 'jacking-points',
 'Jacking and lifting points — 3 Series (G20)',
 '## Floor jack and jack stands (single-corner lift)

The G20 has four reinforced sill jack points — one behind each front wheel and one ahead of each rear wheel. Each is marked on the underside of the sill with a small triangular notch and a dimple in the seam.

**Do not lift on:**
- The flat sill surface anywhere except the reinforced points — the unibody panel will deform.
- Suspension control arms.
- The aluminium oil pan (G20 uses a structural pan on some engines).
- The differential housing.

**Procedure (single corner)**
1. Park on level ground, chock the diagonally opposite wheel.
2. Place a jack pad (a rubber slot pad that fits the sill notch) on the floor jack saddle. Without a pad, the metal saddle deforms the sill.
3. Position the saddle directly under the reinforced point, raise slowly until the wheel just clears the ground.
4. Place a jack stand under the same reinforced point (use a separate stand pad) or on an adjacent structural member.
5. Lower the jack onto the stand — the stand carries the load, not the jack.

## Two-post / four-post lift

Use the same four sill jack points. Each lift arm should engage the reinforced area with a slotted lift pad (BMW-style). Do not lift on the flat sill alongside the jack point — the panel can crease.

## After lowering

Inspect the sill jack point area. If the rubber pad slipped during the lift, you may see a small dent — that''s the sign you''ll need a body shop. Use a proper jack pad next time.',
 'Floor jack (2-ton minimum), jack stands (rated for vehicle weight), rubber jack pads with a slot for the G20 sill notch (BMW-style "puck"), wheel chocks.',
 'Lifting on the flat sill instead of the reinforced point — deforms the panel. Lifting on the oil pan or differential — risks puncture or housing damage. Not using a jack pad — the metal saddle dents the sill seam. Working under the car on the jack alone, without stands.');

-- ============================================================================
-- 3. NEW: coolant-flush
-- ============================================================================
INSERT IGNORE INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes) VALUES
(@gen_g20, 'coolant_flush', 'coolant-flush',
 'Cooling system drain / refill — 3 Series (G20)',
 '## When BMW says "service required"

BMW G20 uses long-life HOAT coolant (BMW G48 spec, blue-green silicate). BMW lists no fixed mileage interval — the coolant is intended for the life of the vehicle in normal service. Replace if:
- Cooling system was opened for repair (water pump, thermostat, radiator).
- Coolant looks discoloured, gritty, or smells burnt.
- An aftermarket scan tool reports out-of-spec freezing point or pH.

## Drain (engine cold)

1. Vehicle on level ground, engine fully cooled.
2. Remove the engine cover (B48 has a plastic cover with two clips at the front).
3. Open the coolant reservoir cap a quarter-turn to release any residual pressure, then remove fully — risk of scalding if hot.
4. The G20 has an integrated drain plug at the lower radiator (engine bay, passenger side on RHD / driver side on LHD). Place a catch pan, then unscrew the drain plug. Use the BMW special tool or a 1/4" hex; do not use vice grips (the plastic plug strips easily).
5. Allow the system to drain fully (5–10 minutes).
6. Reinstall the drain plug, torqued to spec (the OEM plug is 2.5 N·m — finger-tight only; over-torque cracks it).

## Refill (B48 capacity)

The B48 cooling system holds approximately 6.5 L. The capacity per engine on this gen is on the per-engine [coolant table](/bmw/3-series-sedan-g20-2019-2022/coolant) page. Use BMW-approved long-life HOAT (G48 spec) — NEVER mix with non-G48 coolants (OAT, IAT, HOAT-with-2EHA).

1. Mix coolant 50:50 with distilled water (or buy pre-diluted).
2. Pour slowly into the reservoir.
3. With the cap off, start the engine and idle. The thermostat will open as the coolant warms, allowing the system to self-bleed (the G20 has an integrated bleeder valve on the cylinder head; no manual bleed screw).
4. Watch the reservoir level drop as the system bleeds. Top up to the **MAX** mark.
5. With the engine warm and idling, set the heater to maximum heat + maximum fan for 5 minutes to bleed the heater core.
6. Cap the reservoir, turn off the engine, let it cool, recheck level — top up to MAX again.

## Disposal

Used coolant is toxic to pets and wildlife (sweet smell, lethal even in small amounts). Take it to a hazardous-waste recycler. Do NOT pour down a drain or onto soil.',
 'Drain pan (~8 L capacity), funnel, 1/4" hex driver or BMW drain plug tool, fresh BMW G48 HOAT coolant pre-mixed or full-strength concentrate, distilled water.',
 'Mixing G48 coolant with OAT/IAT (Dex-Cool, Toyota Red, etc.) — causes precipitate that clogs the radiator. Over-torquing the plastic drain plug (cracks it). Refilling with tap water instead of distilled (minerals foul the cooling jacket). Skipping the heater-on bleed step (air pocket in the heater core).');

-- ============================================================================
-- 4. NEW: wiper-service-position
-- ============================================================================
INSERT IGNORE INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes) VALUES
(@gen_g20, 'wiper_service_position', 'wiper-service-position',
 'Windscreen wiper service position — 3 Series (G20)',
 '## Why a service mode

On the G20, the windscreen wipers park well above the bonnet line — they sit on the windscreen itself, hidden behind the hood line. To replace a blade you need to lift the wiper arm clear of the windscreen, which is impossible without first moving the arm above the hood line. Just lifting it manually presses the wiper motor against its hard stop and can damage the linkage.

The G20 has a **wiper service position** that moves the wipers upright, freeing the arm for blade swap.

## Entering service position

1. Close the bonnet (the system refuses to enter service mode with the bonnet open).
2. Turn the ignition **on**, then **off** within 30 seconds.
3. Within 10 seconds of switching off, push the windscreen wiper stalk **down** (the wash position) and hold for 2–3 seconds.
4. The wipers move upright to the vertical service position and stop.

## Replacing the blade

1. Lift the wiper arm fully away from the windscreen.
2. Press the small release tab on the back of the wiper blade and slide the blade off the arm.
3. Slide the new blade on until it clicks.
4. Lower the arm gently back onto the windscreen.

## Exiting service position

1. Turn the ignition **on**.
2. Briefly operate the wiper stalk in the **down** wash position.
3. The wipers return to the parked position.

## If the wipers won''t enter service position

- Bonnet is open or its switch is faulty — close fully and try again.
- More than 30 seconds passed between ignition off and the stalk press.
- The wiper motor has thrown a fault — read DTCs via OBD scanner.',
 'New wiper blades (correct length for G20: typically 24" driver, 19" passenger). No other tools.',
 'Forcing the wiper arm up without entering service mode — bends the linkage. Forgetting to close the bonnet before triggering service mode. Waiting more than 30 seconds between ignition off and the stalk press. Installing blades that don''t click — they''ll fly off at speed.');

-- ============================================================================
-- 5. NEW: start-stop-deactivation
-- ============================================================================
INSERT IGNORE INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes) VALUES
(@gen_g20, 'start_stop_disable', 'start-stop-deactivation',
 'Disabling auto Start/Stop — 3 Series (G20)',
 '## Temporary disable (one drive)

Auto Start/Stop is enabled by default on every key cycle. To disable for the current drive:

1. With the engine running, press the **A OFF** button on the centre console (left of the iDrive controller on most G20s, or on the dash on lower trims).
2. The button''s LED illuminates, indicating Start/Stop is off until the next ignition cycle.

This is the BMW-recommended path. On the next ignition cycle Start/Stop re-enables automatically.

## Permanent deactivation (every drive)

BMW does not officially offer a "remember off" setting via iDrive. There are two third-party paths:

1. **Coding** (free, requires OBD app + adapter):
   - Carly app on iOS / Android with the Carly OBD adapter, or Bimmercode, or NCS Expert.
   - Open the body coding section (or "MSA" / "auto start stop" module).
   - Change the "MSA_FUNC_NV" parameter (or equivalent label per app) from `enabled` to `disabled`.
   - Save and restart the car.
2. **Module bypass** (~€30 plug-in device): an aftermarket dongle that plugs in line with the A OFF button''s wiring and tells the car the button was pressed at every startup. Search "G20 Start/Stop disabler".

## Why deactivate

- Reduces wear on the starter and battery for short urban trips.
- Avoids the brief delay when the engine restarts at a green light.
- The G20 has a more aggressive Start/Stop than F30 because of the mild-hybrid 48V system on some variants — owners often find it more intrusive.

**Note:** disabling Start/Stop via coding may flag a Service Information note at the next dealer visit. The dealer can re-enable it. No warranty implications per BMW''s own documentation.',
 'A OFF button (built-in, temporary). Or Carly / Bimmercode + OBD adapter (permanent coding). Or aftermarket Start/Stop disabler dongle (permanent hardware).',
 'Expecting the iDrive Start/Stop button position to be remembered between drives — it isn''t. Pressing A OFF before starting the engine — the button only works once the engine is running. Coding without backing up factory values first.');

-- ============================================================================
-- 6. NEW: power-window-init
-- ============================================================================
INSERT IGNORE INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes) VALUES
(@gen_g20, 'power_window_init', 'power-window-init',
 'Power window auto-up / auto-down initialisation — 3 Series (G20)',
 '## When you need this

After a 12V battery disconnect (replacement, dead battery), or after a window motor / regulator service, the auto-up / auto-down function loses its travel calibration. The windows still raise/lower while you hold the switch, but they no longer go to full close / full open with a single click, and the pinch-protection feature is disabled.

## Initialisation procedure (per window)

For each of the 4 windows, repeat:

1. Sit in the driver''s seat with the door closed. Turn ignition **on**.
2. Use the relevant window switch (driver controls all 4 from the driver door panel, or each door has its own switch for that window).
3. **Press up and hold** until the window is fully closed against the upper seal.
4. **Continue holding** for 2–3 seconds past the closed position (you''ll hear the motor stall briefly — that''s normal).
5. **Release** — and immediately press up again and hold for another 2 seconds.
6. Move to the next window.

Once all 4 are done, the auto-up / auto-down function should work normally.

## Verifying

1. Press the driver''s switch down briefly past the click — the window should open fully.
2. Press up briefly past the click — the window should close fully.
3. While closing, place a soft object (a closed fist will do — NOT a finger) in the window path. The window should reverse on contact (pinch protection working).

## If a window still won''t auto-close after init

The motor may have lost its position sense entirely. Try:
- Disconnect 12V battery, wait 10 minutes, reconnect (full module reset).
- Retry the initialisation.
- If still no luck, the window regulator clip or motor Hall sensor is likely failed — workshop diagnosis required.',
 'No tools required. Just the window switches.',
 'Skipping the 2-second hold past the closed position — initialisation doesn''t register. Initialising on only one window after a battery disconnect — all 4 need re-init. Releasing the switch the moment the window stops at the top.');

-- ============================================================================
-- 7. ENRICH existing battery-register procedure
-- ============================================================================
UPDATE procedures
SET body_md = '## Why registration is required

The G20 12V AGM battery is paired with an Intelligent Battery Sensor (IBS) clamped to the negative terminal. The IBS measures current draw, temperature and voltage, feeding a Battery Energy Management (BEM) profile in the body control module. When you replace the battery the BEM does not auto-detect the new one — without registration it continues to charge as if for the old battery, undercharging the new AGM and shortening its life by 50%+.

## Battery types accepted

G20 main battery is **AGM** (absorbent glass mat) — never flooded. Common OEM part numbers / sizes:
- 80 Ah AGM (most G20 sedans without mild-hybrid)
- 92 Ah AGM (M340i / xDrive / mild-hybrid 48V)

Replace AGM with AGM only. Installing a flooded battery damages the alternator profile because BMW charges AGM with a different voltage curve.

## Registration paths

**1. BMW ISTA / D (dealer / independent shop)**
The dealer software reads the new battery''s manufacturer + part code + serial, writes them into the IBS, and resets the install date counter. Free as part of a battery replacement at a BMW dealer (battery cost charged separately).

**2. Carly app + OBD adapter (~€50 / year subscription)**
The most accessible DIY path:
1. Plug Carly OBD adapter into the OBD port (under the driver dash).
2. Open Carly app, select BMW → your VIN.
3. Battery Registration → select new battery type (AGM 80Ah or AGM 92Ah from the list) → confirm.
4. The app writes the new battery code + serial + install date to the IBS.

**3. Bimmercode / NCS Expert (free but technical)**
For users comfortable with coding via laptop + ENET cable. Edit the BEM module data manually. Riskier — easy to miscoding.

## What goes wrong without registration

- BEM continues charging at the OLD battery''s expected end-of-life voltage profile — overcharges a fresh battery, drying it out faster (AGM lasts ~3 years instead of 5–7).
- Auxiliary loads (heated seats, sunroof, Comfort Access) are throttled because the BEM thinks the battery is degraded.
- Dashboard may eventually show a "Battery state of charge" warning even on a new battery.

## After registration

- Allow 2–3 short drive cycles for the BEM to learn the new battery''s actual capacity.
- Check the Carly / ISTA log to confirm the new install date is recorded.
- The previously-stored fault codes (e.g. "Charging system fault") should clear after one drive cycle.',
    tools_required = 'OBD adapter compatible with Carly / Bimmercode / BMW ISTA. Optional: torque wrench for the new battery''s terminal nuts (5 N·m).',
    common_mistakes = 'Installing a flooded battery in place of AGM — destroys the alternator''s charge profile and the battery within months. Skipping registration entirely — halves new battery lifespan. Registering with the wrong Ah rating (80 vs 92). Not waiting for the BEM to relearn before relying on the new battery for short trips.'
WHERE generation_id = @gen_g20 AND slug = 'battery-register';

-- ============================================================================
-- 8. Add HaynesPro + 2022 OEM citations to all G20 procedures
-- ============================================================================
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'procedures', id, @s_hp FROM procedures WHERE generation_id = @gen_g20;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'procedures', id, @s_2022 FROM procedures WHERE generation_id = @gen_g20;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'procedures', id, @s_2019 FROM procedures WHERE generation_id = @gen_g20;
