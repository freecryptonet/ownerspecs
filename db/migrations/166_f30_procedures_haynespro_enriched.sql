-- F30 procedure enrichment from HaynesPro WorkshopData + BMW US owner's
-- manuals 2015-2018. Per herstructureringsplan + "collect all data before
-- next gen" workflow. Applies to BOTH F30 pre-LCI (2012-2015) and F30 LCI
-- (2015-2018) — the listed procedures are not LCI-specific in BMW spec.
--
-- Sources used:
--   1. HaynesPro WorkshopData "Maintenance procedures" section for
--      BMW 3 (F30, F31, F80, Q30) 320i B48B20A — covers battery,
--      service indicator reset (with/without iDrive), and related
--      adjustment procedures. Professional dealer-tier source.
--      Restated in own words per Feist v. Rural — facts only, no verbatim.
--   2. BMW US 2018 3 Series Sedan Owner's Manual (Part no. 01402984107 -
--      X/17) — owner-facing equivalent of the same procedures.
--   3. BMW US 2015 3 Series Sedan Owner's Manual for pre-LCI cross-
--      verification.
--
-- Existing procedure rows had thin one-line bodies (e.g. "Battery in trunk.
-- Negative at IBS sensor first. ISTA registration required."). This
-- migration UPDATES them with 250-400 word restated walk-throughs covering
-- the actual steps, plus populates the previously-NULL tools_required and
-- common_mistakes columns.

SET NAMES utf8mb4;

SET @gen_pre := (SELECT id FROM generations WHERE slug = '3-series-f30-sedan-2012-2015');
SET @gen_lci := (SELECT id FROM generations WHERE slug = '3-series-f30-lci-sedan-2015-2018');

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes) VALUES
  ('HaynesPro WorkshopData — BMW 3 (F30, F31, F80, Q30) Maintenance Procedures',
   'https://www.workshopdata.com/touch/site/layout/modelDetailMaintenance?typeId=t_317000540&currentSubject=MAINTENANCE',
   NOW(),
   'Professional service database; F30 LCI 320i B48B20A reference variant. Content restated in own words per Feist v. Rural — facts and restated procedures only, no verbatim text per HaynesPro confidentiality clause.');
SET @s_hp   := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelDetailMaintenance?typeId=t_317000540&currentSubject=MAINTENANCE');
SET @s_2018 := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/bmw-auto/3-series-2018-owners-manual-76585');
SET @s_2015 := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/bmw-auto/3-series-2015-owners-manual-51260');

-- ----------------------------------------------------------------------------
-- 1. Battery disconnect — enriched body + tools + common_mistakes
-- ----------------------------------------------------------------------------
UPDATE procedures
SET body_md = 'The F30 battery sits in the trunk floor on the right side under a removable cover, not in the engine bay. BMW routes jump-start posts to the engine compartment (red positive cover near the strut tower; chassis ground stud nearby) so jumping does not require trunk access. A battery service generally does.

**Before disconnecting**
- Switch off all electrical consumers (lights, climate control, infotainment) and turn the ignition off.
- Remove the trunk cover panel on the right side to access the battery.

**Disconnect order**
1. Negative cable FIRST at the Intelligent Battery Sensor (IBS) — not the battery post directly. The IBS clamps to the negative cable; a 10 mm wrench releases the terminal nut. Move the cable away from the post.
2. Positive cable second — lift the red cover, 10 mm wrench, remove and isolate from any metal contact.

**Wait period**
After disconnecting, wait at least 1 minute before working on pyrotechnic components (airbags, seat-belt pretensioners) so the SRS capacitors fully discharge.

**Reconnect order**
Positive first, negative last. Tighten to BMW spec (~5 N·m on the M6 terminal nut).

**Battery management system (BEM)**
The F30 runs a Battery Energy Management System that tracks the state of charge through the IBS. If you simply install a new battery without registering it, the system continues to charge as if for the previous battery — undercharging the new one and shortening its life. Two paths:
- BMW ISTA / D dealer software (correct AH and chemistry registered)
- Third-party: Carly, BimmerCode, or similar OBD apps with BEM support

The same registration is required if the existing battery is disconnected for an extended period — the charge-state model resets to zero.

**After reconnection — items to reset**
- Clock and date
- Radio presets
- Window auto-up/down (hold up to full close, hold for 3 seconds past stop on each window)
- Sunroof initialisation if equipped
- Start/Stop relearn (a few cycles)',
    tools_required = '10 mm wrench (terminal nuts); torque wrench (optional); BMW ISTA / D OR Carly / BimmerCode (for BEM registration); rags to isolate disconnected cables',
    common_mistakes = 'Disconnecting the positive terminal first instead of negative — risks short-circuit if the wrench touches chassis. Skipping BEM registration after a new battery — system undercharges, halving the new battery''s life. Touching trunk battery negative directly to jumper cable instead of using engine-bay jump posts.'
WHERE generation_id IN (@gen_pre, @gen_lci) AND slug = 'battery-disconnect';

-- ----------------------------------------------------------------------------
-- 2. Condition Based Service (CBS) reset
-- ----------------------------------------------------------------------------
UPDATE procedures
SET body_md = 'The F30 uses BMW Condition Based Service (CBS): each maintenance item (engine oil, brake pads, brake fluid, microfilter, vehicle check, spark plugs, exhaust gas check) has its own sensor or counter. The iDrive displays Service Requirements as each counter reaches its threshold. After performing a service the corresponding counter has to be reset manually — the car does not detect that the work happened.

**Reset via iDrive (F30 LCI default, F30 pre-LCI with Professional Navigation)**
1. Start the engine, then turn the ignition to ON without starting (push Start/Stop without depressing the brake).
2. iDrive Controller → MENU → Vehicle info → Vehicle status → Service requirements.
3. Cursor to the item just serviced (Engine oil and filter, Brake fluid, etc.).
4. Hold the right rotary knob for ~2 seconds until "Reset" appears.
5. Confirm Reset.

**Reset without iDrive (early pre-LCI 320i / 328i base trims)**
1. With the ignition off, press and hold the trip-reset (BC) button on the dash.
2. Turn the ignition to ON (do not start).
3. Continue holding the button until the service item appears on the dashboard display.
4. Release, then press and hold again to confirm.

**CBS items tracked**
- Engine oil and filter (CBS-driven; nominal cap 30,000 km / 24 months Europe; shorter ex-Europe per market: 8,000-20,000 km).
- Front brake pads (pad-wear sensor monitors thickness).
- Rear brake pads (same).
- Brake fluid (time-based, 2 years default).
- Vehicle check (annual).
- Spark plugs (mileage-based per engine; N20/N55 around 60,000 mi pre-LCI; B48/B58 around 75,000 mi LCI).
- Exhaust gas check (annual emissions reminder; market-dependent).

**Important**
Reset only AFTER the work is actually done. The reset is the new "zero" for the next interval — resetting prematurely tells the car a clean filter / fresh oil is in place when it isn''t. For brake pad CBS, the wear curve is calibrated to BMW OEM pad friction; aftermarket pads will throw off the next reset accuracy.',
    tools_required = 'In-car only — iDrive controller (LCI / late pre-LCI) or trip-reset button (early pre-LCI base trims). No tools.',
    common_mistakes = 'Resetting before completing the work. Resetting the wrong item (Engine oil instead of Brake fluid). Forgetting to reset multiple items after a major service — each has its own counter. Using aftermarket brake pads expecting CBS to track them accurately.'
WHERE generation_id IN (@gen_pre, @gen_lci) AND slug = 'cbs-reset';

-- ----------------------------------------------------------------------------
-- 3. Jump-start
-- ----------------------------------------------------------------------------
UPDATE procedures
SET body_md = 'The F30 main battery sits in the trunk floor. Jump-start posts are routed to the engine compartment so a donor vehicle never needs trunk access.

**Locate the jump points**
- Positive (+) post: red plastic cover near the front of the engine bay, passenger-side area near the strut tower. Lift the cover to reveal a stud marked with a +.
- Negative ground: a steel stud welded to the chassis near the strut tower (marked with the ground symbol). Use this as the ground point — NEVER connect a jumper cable directly to the trunk battery negative terminal during a jump.

**Sequence**
1. Connect the red (+) jumper to the F30 jump post (positive).
2. Connect the other red end to the donor''s positive terminal.
3. Connect the black (–) jumper to the donor''s negative terminal.
4. Connect the other black end to the F30 chassis ground stud — NOT the trunk battery.
5. Start the donor and run for 2-3 minutes to give the F30 some charge.
6. Start the F30. Once running, leave it for at least 20 minutes to charge the battery.
7. Disconnect in reverse order: F30 ground first, then donor negative, then donor positive, then F30 positive.

**Reasons for the chassis ground rule**
Connecting the negative cable directly to the trunk battery post bypasses the Intelligent Battery Sensor (IBS) and causes the BEM system to misread the charge state. The system can register a permanent charge-state error that only ISTA can clear.

**After a deep-discharge jump**
- Allow 2-3 minutes of jumping BEFORE turning the key. The body control module (BCM) and ECU need bus power first; cranking with the bus unpowered can trigger fault codes.
- The IBS records a transient spike during the jump and may flag a "battery event" — clear via diagnostic tool if persistent.
- Once running, drive for at least 20-30 minutes at sustained engine speed (highway better than stop-and-go) so the alternator can recharge the AGM battery properly.

**Do not push-start**
The F30 Steptronic 8AT requires hydraulic line pressure that the transmission pump can only build with the engine running. Push-starting will not work and may damage the transmission.',
    tools_required = 'Jumper cables (heavy-gauge, at least 4 AWG / 25 mm² for the F30''s starter draw). Donor vehicle, ideally with battery of similar capacity (~70 Ah).',
    common_mistakes = 'Connecting jumper black directly to the trunk battery negative — bypasses the IBS and corrupts BEM state. Trying to push-start an automatic. Cranking immediately at jump — must wait 2-3 min for bus power. Driving short-distance after the jump and expecting the battery to recharge; needs sustained alternator output.'
WHERE generation_id IN (@gen_pre, @gen_lci) AND slug = 'jump-start';

-- ----------------------------------------------------------------------------
-- 4. TPMS / RDC reset
-- ----------------------------------------------------------------------------
UPDATE procedures
SET body_md = 'The F30 uses Tire Pressure Monitor (TPM, called RDC in BMW German nomenclature) — direct radio sensors in each wheel valve transmitting pressure to the body control module. Many F30s also have FTM (Flat Tire Monitor), an indirect ABS-based system that reads wheel-speed deviations; both can co-exist.

After a tire change, rotation, swap to/from winter wheels, or any pressure adjustment, the TPM needs reinitialisation so the system learns the new "OK" baseline pressure for each corner.

**Reset via iDrive (F30 LCI default, F30 pre-LCI with Professional Navigation)**
1. Set all four tires to the OEM placard pressure (cold inflation). See the placard on the driver door pillar or the per-size pressure tables on this site.
2. Start the engine.
3. iDrive Controller → MENU → Settings (or Vehicle settings) → Tyre pressure monitor.
4. Select "Reset" / "Initialise" / "Perform reset".
5. Confirm.
6. Drive 5-10 minutes at varied speeds (rolling 30-60 mph / 50-100 km/h works). The system relearns each corner''s baseline during this drive.

**Reset via dashboard button (pre-LCI base trims without iDrive)**
1. Set tire pressures to placard.
2. Start the engine.
3. Press and hold the TPM button on the centre stack (or the BC button on the stalk on early F30s) for 3 seconds until the warning indicator flashes.
4. Drive 5-10 minutes.

**Sensor replacement**
If a wheel sensor itself is replaced (not just the tire), the new sensor''s unique ID must be programmed to the vehicle via diagnostic tool (BMW ISTA, Autel TS508, or similar). The F30 does not "auto-detect" a new sensor — it relies on the registered IDs.

**Notes**
- Direct TPM uses small batteries inside each sensor; lifespan ~7-10 years. A worn-out sensor reports as a "fault", not as a low-pressure warning.
- Some staggered M-Sport wheel sets (e.g. 225/40 R19 + 255/35 R19) have different placard pressures front vs rear — set per the door-pillar placard, then reset.
- The reset does not change the displayed unit (psi vs bar) — that''s a separate iDrive preference.',
    tools_required = 'Tire pressure gauge (digital or analog, accurate to ±1 psi). No diagnostic tool required for reset; required only if replacing a sensor.',
    common_mistakes = 'Resetting before inflating to placard pressure — system relearns the wrong baseline. Not driving long enough after reset; the system needs varied speeds for several minutes. Replacing a sensor without programming the new ID to the vehicle. Mixing direct TPM and indirect FTM expectations.'
WHERE generation_id IN (@gen_pre, @gen_lci) AND slug = 'tpms-reset';

-- ----------------------------------------------------------------------------
-- 5. Source citations on the enriched procedure rows
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'procedures', id, @s_hp FROM procedures
  WHERE generation_id IN (@gen_pre, @gen_lci);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'procedures', id, @s_2018 FROM procedures
  WHERE generation_id = @gen_lci;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'procedures', id, @s_2015 FROM procedures
  WHERE generation_id = @gen_pre;
