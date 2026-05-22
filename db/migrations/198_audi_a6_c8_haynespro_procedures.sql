-- Audi A6 C8 family — HaynesPro + OEM owner's manual inhaal-pull.
--
-- Mirrors mig 193 (A4 B9 family) for the C8: 5 restated procedures cited
-- against HaynesPro WorkshopData (A6 4K/C8 chassis) + the 2020 and 2024
-- Audi A6 owner's manuals via ownersmanuals2.com. Procedures are written
-- into the canonical sedan pre-LCI gen (115), then cloned to the 4 family
-- siblings (152 Avant, 153 LCI sedan, 154 LCI Avant, 155 Allroad) with
-- title prefix adjustments.
--
-- The two transmission-fluid procedures cover the C8's split: 4-cylinder
-- 40/45 TFSI + 35/40 TDI use the DL382 7-speed wet S tronic (DCT), while
-- V6 50 TDI / 55 TFSI + PHEV 50/55 TFSI e use the ZF 8HP 8-speed
-- Tiptronic automatic. Both need periodic fluid service despite Audi's
-- "lifetime fill" marketing.

SET NAMES utf8mb4;

-- ----------------------------------------------------------------------------
-- 1. Sources
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Audi A6 (C8 / 4K) Maintenance Procedures',
   'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_317000027',
   NOW(),
   'C8/4K chassis maintenance procedure dataset. Procedures captured: service indicator reset, DL382 0DL/0CK 7-speed S tronic fluid change, ZF 8HP / 0HL Tiptronic fluid change, EPB service mode, jacking points (including air-suspension service position on Allroad / adaptive air sedan).',
   1, 0),
  ('Audi A6 2020 Owner''s Manual',
   'https://ownersmanuals2.com/audi/a6-s6-2020-owners-manual-75409',
   NOW(),
   'Pre-LCI C8 owner''s manual. Confirms Audi LongLife oil recommendation (VW 504.00 5W-30 pre-MHEV variants), VW G13 coolant. 316 pages.',
   1, 0),
  ('Audi A6 2024 Owner''s Manual',
   'https://ownersmanuals2.com/audi/a6-2024-owners-manual-95746',
   NOW(),
   'LCI C8 owner''s manual. Confirms VW 508.00 LongLife IV FE 0W-20 across MHEV variants, VW G13 coolant. 346 pages.',
   1, 0);

SET @s_haynes_a6 := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_317000027');
SET @s_a6_2020   := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/audi/a6-s6-2020-owners-manual-75409');
SET @s_a6_2024   := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/audi/a6-2024-owners-manual-95746');

-- ----------------------------------------------------------------------------
-- 2. Five new procedures on canonical sedan gen 115 (A6 V (C8))
-- ----------------------------------------------------------------------------

INSERT IGNORE INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes) VALUES
(115, 'maintenance', 'service-indicator-reset', 'Service indicator (SII) reset — A6 (C8)',
'## Why a diagnostic tool is required\nLike the A4 B9, the A6 C8 locks the service indicator reset behind a factory-style diagnostic tool — VAS 6160 A on Audi''s side, or any VAG-compatible third-party scan tool with service-reset coding (VCDS / Ross-Tech, OBDeleven Pro, Carista Pro, iCarsoft VAG). The MMI / dash menu (Carline → Service Plan / Service interval display) only shows interval status. It does NOT reset.\n\n## Procedure\n1. With the ignition off, connect the diagnostic tool to the OBD-II port (driver''s footwell, just above the pedals).\n2. Turn the ignition on but do NOT start the engine.\n3. Navigate the diagnostic tool''s service-reset menu: **Audi → A6 → 4K (C8) → Service indicator reset**.\n4. Choose between **Engine oil change**, **Inspection service**, or **Both**. Most owners reset both at the same time after a full service.\n5. Confirm. The instrument cluster will briefly display "Service interval reset" and the next-service countdown will reset (typically 16,000 km / 10,000 mi for Fixed plan, up to 30,000 km / 18,640 mi for LongLife flexible).\n\n## LongLife vs Fixed service plan\nC8 ships with the LongLife flexible service plan by default in Europe. North-American models default to Fixed (every 10,000 mi). The plan setting also lives in the diagnostic tool — switch from "LongLife" to "Fixed" if you''re using a non-LongLife oil (e.g., conventional VW 502.00 instead of VW 504.00 / 508.00). Running LongLife mode with non-LongLife oil will demand service prematurely — and Audi can argue voided warranty if the wrong oil is mid-interval at a claim.\n\n## MHEV-variant note\nMHEV-equipped C8s (2020+ post-rollout) require their 12V auxiliary battery to be at full charge before the reset — the J367 battery monitor module will refuse the reset if it detects low voltage.',
'VCDS / OBDeleven / Carista / VAS 6160 A or equivalent diagnostic tool, OBD-II connector',
'Trying to reset via the dash menu (only displays the indicator, no reset function); leaving the service plan set to "LongLife" while using non-LongLife oil; reset attempted with depleted auxiliary 12V battery on MHEV variants (J367 will refuse)'),

(115, 'maintenance', 'dsg-7sp-fluid-change', 'DSG 7-speed (DL382 / 0DL) wet dual-clutch fluid change — A6 (C8)',
'## The DL382 (0DL) is a wet DSG used on 4-cylinder C8s\nThe Audi A6 C8 4-cylinder variants (40/45 TFSI, 35/40 TDI) use the DL382 7-speed S tronic — a **wet** dual-clutch gearbox with its own oil bath, distinct from the dry-clutch DQ200 used on smaller VW Group models. Audi specifies "lifetime fluid" in marketing, but independent VW/Audi specialists recommend a fluid change every 60,000 km (37,000 mi) or every 4 years, whichever first — the wet clutch friction surfaces shed material, and the fluid loses viscosity / additive package long before any catastrophic failure.\n\nNote: V6 trims (50 TDI / 55 TFSI) and PHEVs (50/55 TFSI e) do NOT use the DL382 — they use the ZF 8HP Tiptronic. See the separate `zf-8hp-fluid-change` procedure.\n\n## Procedure (refill ~7 L)\n1. **Set the fluid temperature first.** Park on a level surface. Connect the diagnostic tool (VCDS or equivalent) and monitor transmission fluid temperature live. The level check is only valid at exactly **35-45 °C** (Audi-specified range for the DL382, higher than the A4 B9''s DQ381) — both lower and higher temperatures invalidate the level reading.\n2. Place a drain tray under the gearbox. The DL382 has no drain bolt — instead, remove the **oil pump** at the bottom of the case.\n3. With the pump removed, drain the entire box. Expect 6-7 L of dark, sulphur-smelling fluid (wet-clutch byproducts).\n4. Refit the oil pump with a fresh seal. Torque to **9 Nm**.\n5. Remove the **filler/level plug** (side of the case). Use the Audi VAS 6617 hand pump (or an equivalent funnel + tube) to fill from the top of the filler port. **Refill quantity: ~7.0 L of VW G 052 529 A2 / G 055 540 (DSG fluid — NOT generic ATF). The DL382 takes more fluid than the smaller DQ381.**\n6. With the fluid still warm, run the engine for 30 seconds with the selector in N. Cycle through R, N, D back to N, pausing 2-3 seconds per gear.\n7. Bring the transmission to **35-45 °C** (let it warm to this temperature — use the diagnostic tool''s live temperature read).\n8. Remove the filler plug within the temperature window. Some fluid should drip out. If nothing comes out, top up via the filler port until fluid drips out and then slows. Per spec the **fluid level should sit at the lower edge of the filler plug** (fluid drips, then stops, when temperature is correct).\n9. Renew the filler plug seal and torque to **35 Nm**. Filler plug is single-use — must be renewed each service.\n\n## DSG hydraulic mechatronic unit fluid (separate)\nThe DL382 also has a **separate** hydraulic control unit fluid (mechatronic side) which uses VW G 004 000 M2 / pentosin and is changed less often (60,000-100,000 km). Procedure is similar but uses a different filler port on top of the case.',
'VCDS / OBDeleven (with live transmission temperature read), Audi VAS 6617 hand pump (or equivalent funnel/tube fluid pump), drain tray, VW G 052 529 A2 / G 055 540 DSG fluid (~8 L), new filler plug + seal, fresh oil-pump seal',
'Checking the level at the wrong temperature (DL382 spec is 35-45 °C, not the DQ381''s 20 °C); reusing the filler plug or oil-pump seal (both single-use); using generic ATF (causes harsh shifts and clutch slip); forgetting the mechatronic-side fluid (separate change every 60-100k km); not torquing the oil pump bolts to spec (leaks)'),

(115, 'maintenance', 'zf-8hp-fluid-change', 'ZF 8HP (0HL) Tiptronic 8-speed automatic fluid + filter change — A6 (C8) V6 / PHEV',
'## The ZF 8HP serves the C8 V6 and PHEV variants\nThe Audi A6 C8 V6 variants (50 TDI 3.0L V6, 55 TFSI 3.0L V6) and the plug-in hybrid variants (50 TFSI e, 55 TFSI e) all use the ZF 8HP Tiptronic — Audi calls it **0HL** in its internal coding. This is the same 8-speed planetary automatic ZF supplies to BMW, Jaguar, Land Rover, and the wider VW Group. Audi specifies "lifetime fluid" but ZF itself publishes a 60,000-80,000 mi (96,000-128,000 km) interval. The fluid is shear-stable but the **internal sump filter is integral to the pan** — fluid alone is not a full service; the pan + filter assembly should be replaced together (ZF kit Z058 / Audi equivalent).\n\n## Procedure (refill 5-6 L)\n1. **Warm to operating temperature.** Drive 10-15 minutes until the transmission reaches normal operating temp (~80 °C). Connect the diagnostic tool and monitor transmission fluid temperature live.\n2. Park on a level surface, engine off. The ZF 8HP **must** be checked at the correct fluid temperature — Audi specifies **30-50 °C** for the level check on the C8 (different from the running-warm drain temperature).\n3. Remove the drain plug from the bottom of the pan. Drain into a clean tray. Expect ~5 L of dark red fluid.\n4. Remove the bolts securing the transmission **pan** (the integral filter is built into the pan). Lower the pan carefully — additional fluid may pool inside. Drain residual fluid.\n5. Discard the entire pan + filter assembly. **Do NOT reuse — the filter media is part of the pan structure.** Fit the new ZF / Audi-spec pan + filter assembly with a fresh seal. Torque pan bolts in the **specified sequence** (criss-cross from centre out) to **8 Nm**.\n6. Refit the drain plug with a fresh seal — **torque to 32 Nm**.\n7. Use a fluid pump to fill from the **fill plug** (also on the side of the case, near where the level check happens). Refill quantity: **~5.0 L of Audi G 060 162 A2 / ZF Lifeguard 8** (Audi spec equivalent — NOT generic ATF, the friction modifiers and viscosity index differ).\n8. With the fluid in, start the engine. Cycle through P, R, N, D, S, back to P, pausing 3-5 seconds in each gear.\n9. Allow the transmission to reach **30-50 °C** (warm but not hot — use diagnostic tool live read).\n10. With the engine still running and the gear selector in P, crack the **fill plug**. Fluid should drip slowly out. If no fluid: top up via the fill plug until fluid begins to drip. Per ZF spec the level is correct when fluid drips, then slows to a stop, with the transmission within the 30-50 °C window.\n11. Renew the fill plug seal — torque to **32 Nm**. **The fill plug is the same single-use seal type as the drain plug.**\n\n## Why warm-then-cool sequence matters\nThe ZF 8HP holds significant fluid in the torque converter and clutch packs that doesn''t come out on the static drain. The cycle-through-gears step circulates this fluid back to the pan; the temperature window during level check ensures consistent volumetric reading. Skipping either invalidates the fill level — you''ll be running over- or under-filled.\n\n## Mid-cycle Audi C8 note\nFor C8 vehicles built late 2022+ (some MY23 pre-LCI cars and all LCI), Audi shifted to a revised ZF 8HP variant with electronically-controlled torque converter lockup. The fluid spec and interval are identical; the difference is internal valve body programming. The procedure does not change.',
'VCDS / OBDeleven (with live transmission temperature read), Audi VAS 6617 / ZF 8HP refill pump, drain tray, ZF Lifeguard 8 / Audi G 060 162 A2 fluid (~6 L), ZF / Audi pan + filter assembly + seal kit, new drain + fill plug seals, torque wrench (5-35 Nm range)',
'Checking the level cold or running too hot (window is 30-50 °C); reusing the integral pan + filter (the filter is part of the pan); using generic ATF instead of ZF Lifeguard 8 / G 060 162 A2 (causes shudder, harsh shifts, eventual valve body wear); skipping the gear-cycle step before level check (fluid trapped in TC inflates reading by ~1 L); not torquing the pan bolts in sequence (warps the pan, causes leaks)'),

(115, 'maintenance', 'epb-service-mode', 'Electronic parking brake (EPB) service mode and rear pad renewal — A6 (C8)',
'## Why EPB service mode matters\nThe A6 C8 uses motor-on-caliper EPB actuators on each rear caliper — the same approach as the A4 B9. The rear caliper piston **cannot be wound back manually** without first either (a) putting the EPB into service mode via a diagnostic tool, or (b) removing the actuator and using the TX45 emergency-release tool. Forcing the piston with a generic wind-back tool will destroy the actuator gearbox.\n\n## Battery check first\nThe EPB cycle draws substantial current. Ensure the main starter battery (luggage compartment, under the floor near the spare-wheel well) is at full charge or connected to a stabilised charger via the **engine-bay jump-start terminals** — never directly to the battery negative terminal, which confuses the J367 battery monitor module on MHEV variants.\n\n## Service mode via diagnostic tool\n1. Connect VCDS / VAS 5051 / VAS 5052 / OBDeleven to the OBD port.\n2. Block the front wheels. Move the selector to P. Turn the ignition on (do not start the engine).\n3. From the diagnostic tool: **Steering wheel module → Parking brake → Service position → Pads**. The EPB motors will fully retract; a service icon appears in the cluster.\n\n## Mechanical emergency release (if the EPB will not respond)\n1. Release the parking brake, turn the ignition off, wait 30 seconds.\n2. Raise the vehicle and remove the rear wheels.\n3. Disconnect the EPB actuator electrical connector.\n4. Remove the actuator from the caliper (renew the actuator-to-caliper seal; it is single-use).\n5. With the actuator off the caliper, insert a Torx **T45 bit** into the spindle drive and turn anti-clockwise to retract the piston.\n6. **Renew the actuator mounting bolts** (single-use per Audi spec). Refit the actuator with the new bolts hand-tight, check alignment, then torque to **8 Nm**.\n7. Reconnect the electrical connector — the contact area around the connector should be clean and free of brake dust.\n8. Repeat on the opposite side.\n\n## Brake pad renewal\n1. Raise the vehicle, remove the rear wheels.\n2. With the diagnostic tool service mode active, disconnect the brake pad wear sensor connector (single-side on Audi A6 C8 — left rear).\n3. Remove the brake caliper carrier bolts (single-use per Audi C8 spec; replace with new). Tie the caliper up so the brake hose does not bear weight.\n4. Remove the pads. Press the caliper piston back using Audi **T10145** (or VAG-compatible piston wind-back tool — the A6 C8 rear pistons require a wind + push action, not just push).\n5. Inspect the discs and replace if at or below minimum thickness (typically 22 mm for the standard 320 mm rear disc, 21 mm for the lighter 300 mm rear).\n6. Refit the new pads, caliper (with new carrier bolts), and wear sensor (renew if damaged or if pad position differs).\n7. Reconnect the EPB actuator electrical connector.\n8. Re-initialise the EPB via the diagnostic tool: **Steering wheel module → Parking brake → Basic setting / Initialisation**. The system will exit service mode and re-tension the cables.\n9. Pump the brake pedal several times to bed the piston against the new pads. Top up brake fluid if necessary (DOT 4 LV per VW TL 766-Z spec, also called G 013 J0G).',
'Torx T45 bit, Audi T10145 piston wind-back tool (or VAG-compatible equivalent), VCDS / OBDeleven / VAS 5051 diagnostic tool, brake fluid (VW TL 766-Z / G 013 J0G — DOT 4 LV), new EPB actuator-to-caliper seal, new actuator + caliper-carrier mounting bolts (single-use), battery charger or stabilised power supply',
'Trying to wind the piston back manually (destroys the actuator); reusing the actuator-to-caliper seal or mounting bolts (both single-use); running the EPB cycle on a depleted battery (sets fault codes and aborts service mode); forgetting the diagnostic-tool initialisation step after pad renewal'),

(115, 'maintenance', 'jacking-points-air-suspension', 'Jacking points and air-suspension service mode — A6 (C8)',
'## Four reinforced jack pads — and air-suspension cars need extra steps\nThe A6 C8 has four reinforced jack pads on the underbody sill, each marked with a small triangular indentation in the plastic underbody panel:\n- **Front (both sides):** approximately 30 cm rearward of the front wheel arch, under the sill.\n- **Rear (both sides):** approximately 30 cm forward of the rear wheel arch, under the sill.\n\nDo NOT lift on the rocker panel itself, the floor pan, the fuel tank, the rear differential, or the front sub-frame — these will deform under jack load. Use a jack pad / hockey puck with a slot that locates over the seam-weld at each jack-pad location to spread the load.\n\n## Air-suspension preparation (Allroad standard; sedan/Avant adaptive air optional)\nThe A6 Allroad C8 comes with air suspension standard, and the air-suspension package is optional on the sedan and Avant (Audi calls it "adaptive air suspension"). Air-suspension cars require special preparation before raising:\n\n1. With the vehicle running, press the off-road / lift button on the centre console (or use MMI → Vehicle → Drive Mode → Lift), selecting "Lift" or "Allroad lift" mode. This raises the vehicle by 25-40 mm and locks the air-suspension struts.\n2. Switch the ignition OFF.\n3. **From the MMI** (or via diagnostic tool on cars without the MMI menu): Vehicle → Adaptive air suspension → **Jacking mode** (Audi diagnostic name: "Service / Jacking position"). The system disables auto-levelling, vents air to prevent the struts being damaged by jack-induced height change, and holds the chassis static.\n4. Raise the vehicle on the jack pads as normal.\n\n## Without air-suspension service mode, two failure modes happen\n- The air-suspension system tries to compensate as the chassis rises — the compressor runs continuously and the struts can over-extend (damaging the diaphragms).\n- On reconnect-after-jacking, the chassis ends up at the wrong reference height — the system reports "Adaptive air suspension fault" and limits ride-height adjustment until a diagnostic-tool recalibration.\n\n## After lowering\nFor air-suspension cars, exit jacking mode via the MMI before starting the engine. The system will measure ride height and re-level autonomously over the first 5-10 minutes of driving.',
'4-tonne / 2-tonne capacity floor jack, 2-4 jack stands rated for vehicle weight (~2200 kg max for A6 Allroad), jack pad / hockey-puck adapters, MMI access or diagnostic tool (VCDS / OBDeleven) for air-suspension cars',
'Lifting on the rocker panel or floor pan (not the reinforced jack pads — will deform sheet metal); leaving air-suspension cars in normal mode while jacking (over-extends struts, damages diaphragms); not exiting jacking mode in MMI before driving (system reports fault, won''t self-level)');

-- ----------------------------------------------------------------------------
-- 3. Source links — link all 5 new procedures to the 3 sources
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'procedures', p.id, s.id
FROM procedures p
CROSS JOIN (SELECT @s_haynes_a6 AS id UNION ALL SELECT @s_a6_2020 UNION ALL SELECT @s_a6_2024) s
WHERE p.generation_id = 115
  AND p.slug IN ('service-indicator-reset', 'dsg-7sp-fluid-change', 'zf-8hp-fluid-change', 'epb-service-mode', 'jacking-points-air-suspension');

-- ----------------------------------------------------------------------------
-- 4. Clone the 5 new procedures to the 4 family-sibling gens
--    with appropriate title prefix adjustment per body/LCI status
-- ----------------------------------------------------------------------------

-- Avant pre-LCI (152) ← from sedan (115)
INSERT IGNORE INTO procedures (generation_id, market_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT 152, market_id, procedure_type, slug,
       REPLACE(title, 'A6 (C8)', 'A6 Avant (C8)'),
       body_md, tools_required, common_mistakes
FROM procedures
WHERE generation_id = 115
  AND slug IN ('service-indicator-reset', 'dsg-7sp-fluid-change', 'zf-8hp-fluid-change', 'epb-service-mode', 'jacking-points-air-suspension');

-- LCI sedan (153) ← from sedan (115)
INSERT IGNORE INTO procedures (generation_id, market_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT 153, market_id, procedure_type, slug,
       REPLACE(title, 'A6 (C8)', 'A6 (C8 LCI)'),
       body_md, tools_required, common_mistakes
FROM procedures
WHERE generation_id = 115
  AND slug IN ('service-indicator-reset', 'dsg-7sp-fluid-change', 'zf-8hp-fluid-change', 'epb-service-mode', 'jacking-points-air-suspension');

-- LCI Avant (154) ← from sedan (115) with both body + LCI in title
INSERT IGNORE INTO procedures (generation_id, market_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT 154, market_id, procedure_type, slug,
       REPLACE(title, 'A6 (C8)', 'A6 Avant (C8 LCI)'),
       body_md, tools_required, common_mistakes
FROM procedures
WHERE generation_id = 115
  AND slug IN ('service-indicator-reset', 'dsg-7sp-fluid-change', 'zf-8hp-fluid-change', 'epb-service-mode', 'jacking-points-air-suspension');

-- Allroad (155) ← from sedan (115). Allroad has no DL382 (V6-only) so skip
-- the DSG procedure — but include the ZF 8HP one (used on all Allroad
-- variants). Keep service-indicator-reset, epb-service-mode, jacking
-- (the Allroad has air suspension standard — jacking matters most here).
INSERT IGNORE INTO procedures (generation_id, market_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT 155, market_id, procedure_type, slug,
       REPLACE(title, 'A6 (C8)', 'A6 Allroad (C8)'),
       body_md, tools_required, common_mistakes
FROM procedures
WHERE generation_id = 115
  AND slug IN ('service-indicator-reset', 'zf-8hp-fluid-change', 'epb-service-mode', 'jacking-points-air-suspension');

-- ----------------------------------------------------------------------------
-- 5. Clone source links from sedan procedures to sibling gens
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'procedures', p_new.id, ss.source_id
FROM procedures p_old
JOIN procedures p_new ON p_new.generation_id IN (152, 153, 154, 155) AND p_new.slug = p_old.slug
JOIN spec_sources ss ON ss.spec_table = 'procedures' AND ss.spec_id = p_old.id
WHERE p_old.generation_id = 115
  AND p_old.slug IN ('service-indicator-reset', 'dsg-7sp-fluid-change', 'zf-8hp-fluid-change', 'epb-service-mode', 'jacking-points-air-suspension');

-- ----------------------------------------------------------------------------
-- 6. Audit
-- ----------------------------------------------------------------------------
SELECT g.slug, COUNT(DISTINCT p.id) AS procedures,
       (SELECT COUNT(DISTINCT ss.source_id) FROM spec_sources ss
          WHERE ss.spec_table = 'procedures'
            AND ss.spec_id IN (SELECT id FROM procedures WHERE generation_id = g.id)) AS distinct_sources
FROM generations g
LEFT JOIN procedures p ON p.generation_id = g.id
WHERE g.family_slug = 'audi-a6-c8-2018-present'
GROUP BY g.id
ORDER BY g.start_year, g.body_type;
