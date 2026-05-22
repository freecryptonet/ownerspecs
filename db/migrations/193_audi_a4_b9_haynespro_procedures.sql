-- Audi A4 B9 family — HaynesPro inhaal-pull.
--
-- Per the feedback rule established 2026-05-22, every new gen must include a
-- HaynesPro WorkshopData pull + OEM owner manual citation. Mig 192 shipped
-- the A4 B9 family without this step; mig 193 corrects that.
--
-- 5 procedures restated per Feist v. Rural (facts only, never verbatim) from
-- HaynesPro WorkshopData (Audi A4 8W typeId t_318011812 — 2.0 TFSI CVKB
-- 140 kW 2016-2024) plus cross-verification against the BMW US/EU-style 2020
-- A4 owner's manual (Audi LongLife oil recommendation + G12++ / G13 coolant
-- compatibility).
--
-- Applied to all 4 B9 family gens: sedan pre-LCI (24), Avant pre-LCI (149),
-- sedan LCI (150), Avant LCI (151).

SET NAMES utf8mb4;

-- ----------------------------------------------------------------------------
-- 1. Sources (HaynesPro + 2 OEM manuals)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO sources (citation, url, retrieved_at, notes) VALUES
  ('HaynesPro WorkshopData — Audi A4 (8W) Maintenance Procedures',
   'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_317000026',
   NOW(),
   'B9/8W chassis maintenance procedure dataset. Captured procedures: service indicator reset, DSG 0CK 7-speed fluid change, EPB service mode, battery disconnect/reconnect, jacking points. 45 engine variants in chassis.'),
  ('Audi A4 2020 Owner''s Manual',
   'https://ownersmanuals2.com/audi/a4-2020-owners-manual-77805',
   NOW(),
   'Confirms Audi LongLife oil recommendation + VW G12++ TL774G / G13 TL774 coolant compatibility on B9 LCI. 552 pages.'),
  ('Audi A4 2024 Owner''s Manual',
   'https://ownersmanuals2.com/audi/a4-2024-owners-manual-95741',
   NOW(),
   'Final-year B9 LCI owner''s manual. Confirms VW 508.00 LongLife IV FE 0W-20 oil + G13 OAT coolant.');

SET @s_haynes_a4 := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_317000026');
SET @s_a4_2020   := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/audi/a4-2020-owners-manual-77805');
SET @s_a4_2024   := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/audi/a4-2024-owners-manual-95741');

-- ----------------------------------------------------------------------------
-- 2. 5 restated procedures, written to canonical sedan pre-LCI (gen 24)
-- ----------------------------------------------------------------------------

INSERT IGNORE INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes) VALUES
(24, 'maintenance', 'service-indicator-reset', 'Service indicator (SII) reset — A4 (B9)',
'## Why a diagnostic tool is required\nUnlike many manufacturers that let owners reset the service indicator from the dashboard menu, Audi locks the SII reset behind a VAS 6160 A factory-style diagnostic tool. Compatible third-party tools include VCDS (Ross-Tech), OBDeleven Pro, Carista Pro, or any VAG-compatible scan tool with service-reset coding. The dash menu route (Carline / Service Plan) only displays interval status — it does NOT reset.\n\n## Procedure\n1. With the ignition off, connect the diagnostic tool to the OBD port (driver''s footwell, right side of pedal box).\n2. Turn the ignition on but do NOT start the engine.\n3. From the diagnostic tool''s service-reset menu, select **Audi → A4 → 8W (B9) → Service indicator reset**.\n4. Choose between: **Engine oil change**, **Inspection service**, or **Both**. Most owners reset both at the same time after a full service.\n5. Confirm the reset on the tool. The dash cluster will briefly show "Service interval reset" and the remaining-mileage countdown will reset to the next interval (typically 16,000 km / 10,000 mi for fixed plan, up to 30,000 km / 18,640 mi for LongLife flexible).\n\n## LongLife vs Fixed service plan\nAudi A4 B9 ships with the LongLife flexible service plan by default in Europe. North-American models default to Fixed (every 10,000 mi). The plan setting also lives in the diagnostic tool — change it from "LongLife" to "Fixed" if you''re using a non-LongLife oil (e.g., conventional VW 502.00 instead of 504.00).',
'VCDS / OBDeleven / Carista / VAS 6160 A or equivalent diagnostic tool, OBD-II connector',
'Trying to reset via the dash menu (only displays the indicator, no reset function); leaving the service plan set to "LongLife" while using non-LongLife oil (will demand service prematurely)'),

(24, 'maintenance', 'dsg-7sp-fluid-change', 'DSG 7-speed (DQ381 / 0CK) wet dual-clutch fluid change — A4 (B9)',
'## The 0CK (DQ381) is a wet DSG\nThe Audi A4 B9 quattro variants use the 0CK 7-speed dual-clutch (DQ381) — a **wet** DSG with its own oil bath, distinct from the dry-clutch DQ200 used on lower-powered FWD variants. Audi specifies a fluid change every 60,000 km (37,000 mi) under severe service, or every 80,000-100,000 km (50,000-62,000 mi) on the LongLife flexible plan. Independent VW/Audi specialists strongly recommend 60,000 km regardless of plan — the fluid carries clutch wear particles and degrades faster than the published interval suggests.\n\n## Procedure (refill 3.8 L)\n1. **Set the fluid temperature first.** Park on a level surface. Connect the diagnostic tool (VCDS or equivalent) and monitor transmission fluid temperature live. The level check is only valid at exactly **20 °C** — both lower and higher temperatures invalidate the level reading.\n2. Place a drain tray under the gearbox. The 0CK has no drain bolt — instead, remove the **oil pump** at the bottom of the case (this is the drain).\n3. With the pump removed, drain the entire box. Expect ~3.5-3.8 L of dark, sulphur-smelling fluid (the wet-clutch friction surfaces shed material, so the colour is always darker than a fresh gearbox).\n4. Refit the oil pump with a fresh seal.\n5. Remove the **filler/level plug** (side of the case). Use the Audi VAS 6617 hand pump (or an equivalent funnel + tube) to fill the gearbox from the top of the filler port. Refill quantity: **3.8 L** of VW G 052 182 A2 / G 055 530 (DSG fluid — NOT generic ATF, the clutch friction modifiers are specific).\n6. With the fluid still warm, run the engine for 30 seconds with the selector in N. Cycle through R, N, D back to N, pausing 2-3 seconds per gear.\n7. Bring the transmission to **exactly 20 °C** (let it cool or warm to this temperature — use the diagnostic tool''s live temperature read).\n8. Remove the filler plug at 20 °C. Some fluid should drip out. If nothing comes out, top up via the filler port until fluid drips out and then slows. Per spec the **fluid level should sit 2 mm below the filler plug edge**.\n9. Renew the filler plug seal and torque to **35 Nm**. Filler plug is single-use — must be renewed each service.\n\n## DSG hydraulic mechatronic unit fluid (separate)\nThe DQ381 also has a **separate** hydraulic control unit fluid (mechatronic side) which uses VW G 004 000 M2 / pentosin and is changed less often (60,000-100,000 km). Procedure is similar but uses a different filler port — see HaynesPro story 319000658.',
'VCDS / OBDeleven (with live transmission temperature read), Audi VAS 6617 hand pump (or equivalent funnel/tube fluid pump), drain tray, VW G 052 182 A2 / G 055 530 DSG fluid (~4 L), new filler plug + seal',
'Checking the level when the fluid is too hot or too cold (only valid at 20 °C); reusing the filler plug (single-use); using generic ATF (causes harsh shifts and clutch slip); forgetting the mechatronic-side fluid (separate change)'),

(24, 'maintenance', 'epb-service-mode', 'Electronic parking brake (EPB) service mode and pad renewal — A4 (B9)',
'## Why EPB service mode matters\nThe A4 B9 uses motor-on-caliper EPB actuators on each rear caliper. Like all motor-on-caliper systems, the rear caliper piston **cannot be wound back manually** without first either (a) putting the EPB into service mode via a diagnostic tool, or (b) removing the actuator and using the TX45 emergency-release tool. Forcing the piston with a generic wind-back tool will destroy the actuator gearbox.\n\n## Battery check first\nThe EPB cycle draws substantial current — ensure the main starter battery (luggage compartment) is at full charge or connected to a stabilised charger / jump-start terminal in the engine bay before starting.\n\n## Service mode via diagnostic tool\n1. Connect VCDS / VAS 5051 / VAS 5052 / OBDeleven to the OBD port.\n2. Block the front wheels and move the selector to P.\n3. From the diagnostic tool: **Steering wheel module / Parking brake → Service position → Pads**. The EPB motors will fully retract; a service icon appears in the cluster.\n\n## Mechanical emergency release (if the EPB will not respond)\n1. Release the parking brake, turn the ignition off, wait 30 seconds.\n2. Raise the vehicle and remove the rear wheels.\n3. Disconnect the EPB actuator electrical connector.\n4. Remove the actuator from the caliper (renew the actuator-to-caliper seal; it is single-use).\n5. With the actuator off the caliper, insert a Torx **T45 bit** into the spindle drive and turn anti-clockwise to retract the piston.\n6. **Renew the actuator mounting bolts** (single-use per Audi spec). Refit the actuator with the new bolts hand-tight, check alignment, then torque.\n7. Reconnect the electrical connector — the contact area around the connector should be clean and free of brake dust.\n8. Repeat on the opposite side.\n\n## Brake pad renewal\n1. Raise the vehicle, remove the rear wheels.\n2. With the diagnostic tool service mode active, disconnect the brake pad wear sensor connector.\n3. Remove the brake caliper. Tie it up so the brake hose does not bear weight.\n4. Remove the pads. Press the caliper piston back using Audi **T10145** (or any VAG-compatible piston wind-back tool — the A4 B9 rear pistons require a wind+push action, not just push).\n5. Inspect the discs and replace if at or below minimum thickness.\n6. Refit the new pads, caliper, and wear sensor (renew if damaged).\n7. Reconnect the EPB actuator electrical connector.\n8. Re-initialise the EPB via the diagnostic tool: **Steering wheel module / Parking brake → Basic setting / Initialisation**. The system will exit service mode and re-tension the cables.\n9. Pump the brake pedal several times to bed the piston against the new pads. Top up brake fluid if necessary.',
'TX45 / Torx T45 bit, Audi T10145 piston wind-back tool (or VAG-compatible equivalent), VCDS / OBDeleven / VAS 5051 diagnostic tool, brake fluid (DOT 4 LV per VW TL 766-Z), new EPB actuator bolts + seal, battery charger / jump start terminal',
'Trying to wind the piston back manually (destroys the actuator); reusing the actuator-to-caliper seal or mounting bolts (both single-use); running the EPB cycle on a depleted battery (sets fault codes and aborts service mode); forgetting the diagnostic-tool initialisation step after pad renewal'),

(24, 'maintenance', 'battery-disconnect-reconnect', 'Battery disconnection and reconnection — A4 (B9)',
'## Why this is not a 2-minute job\nThe A4 B9 stores adaptive learning data (transmission shift points, throttle pedal map, air mass meter calibration, comfort settings) in volatile memory tied to the battery. A naïve disconnect-reconnect erases all of it. Audi specifies a multi-step procedure that includes pre-charging the battery, working with the J367 battery monitor module, and post-reconnect re-initialisation of the power windows + ESP.\n\n## Before disconnecting\n1. Turn the ignition off. Remove the key from the ignition switch (or remove the comfort key from the vehicle).\n2. Open the luggage compartment and remove the carpet over the spare wheel well — the starter battery sits on the right side under the floor.\n3. **Connect a stabilised battery charger to the engine-bay jump-start terminals** (NOT directly to the battery terminals, which can confuse the J367 battery monitor). The jump terminals are the approved interface for charging or jump-starting.\n4. For diesel variants with **SCR (selective catalytic reduction)**: wait **10 minutes** after ignition-off before disconnecting, to allow AdBlue additive to drain back into the storage tank. Skipping this can cause AdBlue contamination of the SCR injector.\n5. For pyrotechnic component work (airbags, seat belt pretensioners): turn the ignition ON momentarily (do not start the engine) before disconnecting the negative cable. This disarms the pyrotechnic circuits.\n\n## Disconnect\n1. Disconnect the negative (earth) cable first. Wrap the terminal in a clean cloth so it cannot accidentally contact the battery post.\n2. For pyrotechnic work: wait 10 seconds before working on airbag / pretensioner components — capacitor discharge time.\n3. (If renewing the battery) Disconnect the positive cable.\n\n## Before reconnecting\n1. Disconnect the J367 battery monitor module connector (small electronics module on the negative battery terminal). Reconnecting the cable with J367 still plugged in can latch a fault code.\n2. Reconnect the battery: positive first, then negative.\n3. Reconnect the J367 module.\n\n## After reconnecting\n1. Turn the ignition on. The cluster will show several warning lights (ESP, TPMS, possibly EPB) — this is expected.\n2. Use the diagnostic tool: **Read out all fault codes → Clear** the freshly-set codes (e.g., "Terminal 30 voltage lost" in every module).\n3. Drive the vehicle until the ESP warning light extinguishes (the system calibrates from gyro + wheel-speed correlation, usually within 5 km).\n4. **Re-initialise the power windows**: with the driver''s door closed, pull each window switch all the way up, hold for 2 seconds after the window stops; then push each switch all the way down, hold for 2 seconds after the window stops. Repeat for each window. Until done, one-touch up/down and pinch-protection are disabled.\n5. For diesel variants: check that the AdBlue tank-level indicator on the cluster reads correctly. If it shows "0 km" but the tank is full, run the diagnostic tool''s **SCR adaptation** to recalibrate.',
'10 mm spanner (battery terminals), stabilised battery charger / engine-bay jump-start cable, VCDS / OBDeleven / VAS 5051 diagnostic tool, clean cloth (insulate disconnected terminal)',
'Disconnecting without first pre-charging (J367 sees voltage drop as failure and latches a fault); skipping the SCR 10-minute wait on diesels (causes AdBlue injector contamination); reconnecting J367 before reconnecting cables (latches "module init failed" code); forgetting to re-initialise power windows (one-touch + pinch protection stay disabled)'),

(24, 'maintenance', 'jacking-lifting-points', 'Jacking and lifting points — A4 (B9)',
'## OEM jack points\nThe A4 B9 has four reinforced sill jack points, one per corner, marked from the factory with a black plastic notch insert in the underbody plastic cladding. Use these for any single-corner lift (changing a wheel, replacing a brake rotor). Trolley jacks with the right adaptor can also use them, but DIY use of the supplied scissor jack should be reserved to roadside emergencies.\n\n## Two-post lift points\nFor a two-post lift, Audi specifies front lift points just behind the front wheel arch (where the subframe meets the front sill) and rear lift points just forward of the rear wheel arch. Both are reinforced; both are clearly marked in the body shop manual but visible from below as a flat steel pad. **Do NOT lift on the pinch weld outside the marked jack points** — the B9 has aluminium sills that crush easily under arm pressure.\n\n## Adaptive air suspension caveat\nA4 B9 variants with the optional adaptive air suspension (more common on Avant and Allroad) require the suspension to be set to **"Vehicle lifted"** mode in the MMI menu before lifting — this prevents the air struts from automatically extending or retracting while the wheels are unweighted. Failure to set this can damage the level sensors. After lowering: drive at low speed for 200 m to allow the system to re-level.',
'Trolley jack (any tonnage ≥ 2 t for single-corner lift; 3 t for two-corner lift), rubber jack pad (do not lift directly on aluminium), wheel chocks for the opposite axle',
'Lifting on the painted aluminium sill outside the marked jack points (sill crushes); forgetting the "Vehicle lifted" mode on air-suspension cars (damages level sensors)');

-- ----------------------------------------------------------------------------
-- 3. Cite all 3 sources on each new procedure row
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'procedures', p.id, @s_haynes_a4
FROM procedures p
WHERE p.generation_id = 24
  AND p.slug IN ('service-indicator-reset', 'dsg-7sp-fluid-change', 'epb-service-mode', 'battery-disconnect-reconnect', 'jacking-lifting-points');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'procedures', p.id, @s_a4_2020
FROM procedures p
WHERE p.generation_id = 24
  AND p.slug IN ('service-indicator-reset', 'dsg-7sp-fluid-change', 'epb-service-mode', 'battery-disconnect-reconnect', 'jacking-lifting-points');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'procedures', p.id, @s_a4_2024
FROM procedures p
WHERE p.generation_id = 24
  AND p.slug IN ('service-indicator-reset', 'dsg-7sp-fluid-change', 'epb-service-mode', 'battery-disconnect-reconnect', 'jacking-lifting-points');

-- ----------------------------------------------------------------------------
-- 4. Clone the 5 new procedures to the other 3 B9 family gens (149/150/151)
--    with codename retitling at insertion time.
-- ----------------------------------------------------------------------------
INSERT INTO procedures (generation_id, market_id, procedure_type, slug,
  title, body_md, tools_required, common_mistakes)
SELECT t.gen_id, p.market_id, p.procedure_type, p.slug,
       REPLACE(p.title, 'A4 (B9)', t.label),
       p.body_md, p.tools_required, p.common_mistakes
FROM procedures p
JOIN (
  SELECT 149 AS gen_id, 'A4 Avant (B9)'      AS label UNION ALL
  SELECT 150,            'A4 (B9 LCI)'                UNION ALL
  SELECT 151,            'A4 Avant (B9 LCI)'
) t
WHERE p.generation_id = 24
  AND p.slug IN ('service-indicator-reset', 'dsg-7sp-fluid-change', 'epb-service-mode', 'battery-disconnect-reconnect', 'jacking-lifting-points')
  -- Skip rows that already exist on the target gen (idempotent re-run safety)
  AND NOT EXISTS (
    SELECT 1 FROM procedures p2
    WHERE p2.generation_id = t.gen_id AND p2.slug = p.slug
  );

-- Cite the same 3 sources on cloned rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'procedures', p.id, @s_haynes_a4
FROM procedures p
WHERE p.generation_id IN (149, 150, 151)
  AND p.slug IN ('service-indicator-reset', 'dsg-7sp-fluid-change', 'epb-service-mode', 'battery-disconnect-reconnect', 'jacking-lifting-points');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'procedures', p.id, @s_a4_2020
FROM procedures p
WHERE p.generation_id IN (149, 150, 151)
  AND p.slug IN ('service-indicator-reset', 'dsg-7sp-fluid-change', 'epb-service-mode', 'battery-disconnect-reconnect', 'jacking-lifting-points');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'procedures', p.id, @s_a4_2024
FROM procedures p
WHERE p.generation_id IN (149, 150, 151)
  AND p.slug IN ('service-indicator-reset', 'dsg-7sp-fluid-change', 'epb-service-mode', 'battery-disconnect-reconnect', 'jacking-lifting-points');

-- ----------------------------------------------------------------------------
-- 5. Cite the OEM manuals on existing fluid_specs rows for the B9 family
--    (engine_oil + coolant) — earlier mig 192 inherited citations from gen 24
--    but did not add the 2020/2024 manuals as explicit OEM corroboration.
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', f.id, @s_a4_2020
FROM fluid_specs f
WHERE f.generation_id IN (24, 149, 150, 151)
  AND f.fluid_type IN ('engine_oil', 'coolant');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', f.id, @s_a4_2024
FROM fluid_specs f
WHERE f.generation_id IN (24, 149, 150, 151)
  AND f.fluid_type IN ('engine_oil', 'coolant');
