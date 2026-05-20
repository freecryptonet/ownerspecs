-- Add tools_required + common_mistakes columns to procedures + seed by type.
-- Procedure tools/mistakes are largely canonical per procedure_type — they
-- don't vary much between brands. This migration applies them across all
-- 192 existing procedures grouped by procedure_type.

ALTER TABLE procedures
  ADD COLUMN tools_required  TEXT NULL,
  ADD COLUMN common_mistakes TEXT NULL;

-- =====================================================================
-- Service / oil-life resets (no tools required, menu-driven)
-- =====================================================================
UPDATE procedures SET
  tools_required = 'None — completely menu-driven. No physical tools needed.',
  common_mistakes = '• Releasing the trip button or OK button before the system finishes the countdown — the reset will not take.\n• Resetting **All** instead of the specific service that was just done — masks every counter and hides legitimately overdue items.\n• Performing the reset BEFORE the service is actually done — defeats the system''s ability to predict the next interval.'
WHERE procedure_type IN ('oil_life_reset', 'maintenance_minder_reset', 'service_reminder_reset');

-- =====================================================================
-- TPMS relearn / calibration
-- =====================================================================
UPDATE procedures SET
  tools_required = '• Tire pressure gauge (verify gauge accuracy against a known-good unit before use)\n• TPMS activation tool (~$20 on Amazon) — only on vehicles with direct sensors; not needed for indirect (ABS-based) systems\n• Magnet — older direct-TPMS systems before activator tools became cheap',
  common_mistakes = '• Setting hot pressures instead of cold — adds 3-5 psi of measurement error per tire, which makes the system retain the wrong baseline.\n• Starting the relearn before the spare has been reset to its placard pressure (when spare TPMS is fitted).\n• Driving the calibration loop on snowy/icy roads — wheel speeds fluctuate, indirect systems mis-learn.\n• Forgetting to re-calibrate after seasonal wheel swap when tire diameters differ ≥3%.'
WHERE procedure_type IN ('tpms_relearn');

-- =====================================================================
-- Battery disconnect order
-- =====================================================================
UPDATE procedures SET
  tools_required = '• 10 mm wrench (8 mm or 13 mm on a few European cars) — match the negative terminal nut\n• Insulated gloves (recommended)\n• Safety glasses (battery acid splash protection)\n• Battery memory saver (optional but recommended — preserves radio presets, BCM learn data, window auto-up)',
  common_mistakes = '• Disconnecting positive FIRST — if the wrench touches the body while still on the post, it short-circuits the entire battery through the wrench, melts the tool, and can splash acid.\n• Letting the loose negative cable spring back onto the post during work — creates a momentary short.\n• Reconnecting without checking the negative cable clamp is fully tight — intermittent contact triggers ABS / SRS / BMS faults.\n• Skipping the 30-second module-sleep wait — modules can corrupt their learn data if power drops while writing to EEPROM.'
WHERE procedure_type IN ('battery_disconnect_order', 'battery_replacement');

-- =====================================================================
-- Jump-start
-- =====================================================================
UPDATE procedures SET
  tools_required = '• Jumper cables (minimum 4 AWG gauge, 6+ AWG for diesels)\n• Donor vehicle with at least equivalent battery capacity, OR a portable jump pack rated for ≥1000 A peak\n• Insulated gloves and safety glasses\n• On hybrids/EVs: knowledge of where the under-hood jump terminal is — never jump from the rear/under-floor 12V auxiliary',
  common_mistakes = '• Clamping the dead-side negative directly to the battery negative post — hydrogen gas vented from a discharged battery ignites from the spark, causing the case to crack and acid to spray. ALWAYS clamp to an unpainted engine ground point.\n• Reversing the polarity (red on negative, black on positive) — instantly fries the ECU, alternator diodes, and most modules. Newer cars have fuse-link protection but older ones do not.\n• Starting the dead car within the first 60 seconds of donor running — donor battery hasn''t replenished enough capacity yet.\n• Disconnecting cables in the wrong order — remove from the dead-side ground first, then donor negative, then both positives. Reverse of the connection order.'
WHERE procedure_type IN ('jump_start');

-- =====================================================================
-- Key fob battery
-- =====================================================================
UPDATE procedures SET
  tools_required = '• Replacement CR2032 (or CR2025 / CR2016 — verify by checking the old cell)\n• Small flathead or plastic spudger to split the fob halves\n• Clean cloth (skin oils from fingers shorten cell life)',
  common_mistakes = '• Touching the new cell with bare fingers — finger oils across the (+) face create a partial short that drains the cell in weeks.\n• Installing the cell upside-down (+ side down instead of up). Some fobs survive this; others fail to start the car.\n• Forcing the halves back together without aligning the latch — cracks the case along the seam.\n• Using a knife to pry the fob — damages the case AND risks slipping into your hand.'
WHERE procedure_type IN ('key_fob_battery');

-- =====================================================================
-- Spare tire change
-- =====================================================================
UPDATE procedures SET
  tools_required = '• Vehicle''s OE scissor jack (under cargo floor or behind rear seat)\n• Lug wrench (often integrated with the jack handle)\n• Wheel chock or solid block to prevent rolling\n• Hi-viz reflective triangle if changing roadside\n• Optional: torque wrench (verify torque after lowering — see the gen''s /torque page)',
  common_mistakes = '• Loosening lug nuts AFTER lifting — wheel spins. Always crack each nut a half-turn BEFORE jacking.\n• Tightening lug nuts in a clockwise sequence — warps the rotor. ALWAYS use a star/cross pattern.\n• Jacking on the side rocker panel or floor pan — bends the body. Use the dedicated lift point notch inboard of the wheel.\n• Driving the compact spare above 50 mph (80 km/h) or further than 50 miles — the spare is rated for emergency use only.\n• Forgetting to re-check spare pressure (typically 60 psi / 420 kPa) before relying on it.'
WHERE procedure_type IN ('spare_tire');

-- =====================================================================
-- Steering angle sensor (SAS) initialisation
-- =====================================================================
UPDATE procedures SET
  tools_required = '• Diagnostic scan tool with ABS module access (most $50+ OBD scanners have this for common brands)\n• Optional: laser alignment rig if the steering wheel is also off-centre after the work',
  common_mistakes = '• Trying to drive the SAS calibration without first centering the steering wheel mechanically — the system learns "centre" as whatever angle the wheel is at when calibration starts.\n• Doing the calibration on a sloped surface — gravity pulls the steering, false centre.\n• Skipping the SAS reset after a battery disconnect — some vehicles will hold the old value but ABS/ESC may engage unexpectedly during sharp turns until relearn.'
WHERE procedure_type IN ('steering_angle_calibration');

-- =====================================================================
-- EPB (electric parking brake) service mode
-- =====================================================================
UPDATE procedures SET
  tools_required = '• Scan tool with manufacturer-specific EPB service mode support (Foxwell NT510, Autel MaxiCheck, Bimmercode app, Carly app, OBDeleven, FORScan, MaxiCOM, etc.)\n• Standard brake service tools: socket set, brake caliper tool, brake cleaner, anti-squeal compound, jack and stands',
  common_mistakes = '• Trying to hand-wind the EPB caliper piston back like an old hydraulic caliper — the motor-driven screw inside will be permanently damaged ($500-700 caliper).\n• Forgetting to exit service mode before driving away — the parking brake will not engage automatically and may release on inclines.\n• Skipping the caliper-bracket bolt torque check after pad replacement — wheel hub/knuckle interface has 100+ N·m torque values that are easy to under-tighten.\n• Replacing pads but not the wear sensor — the dashboard light returns on the next drive cycle.'
WHERE procedure_type IN ('epb_service_mode', 'brake_pad_replacement');

-- =====================================================================
-- Battery registration (BMW / Mercedes / Audi / Volvo with BMS)
-- =====================================================================
UPDATE procedures SET
  tools_required = '• OBD-II scan tool with battery registration capability for the specific brand:\n  - BMW / Mini: ISTA (dealer), Bimmercode, Carly app, Foxwell NT510 BMW\n  - Audi / VW / Skoda: VCDS (full), OBDeleven Pro\n  - Mercedes-Benz: XENTRY/DAS (dealer), Launch X431 Pro\n  - Volvo: VIDA, VDASH\n  - Ford: FORScan with extended licence\n  - GM: Tech 2 / MDI, or GDS2 via aftermarket adapter',
  common_mistakes = '• Skipping registration entirely — the IBS (Intelligent Battery Sensor) continues to think the old battery''s capacity is in place, so the alternator over-charges a new AGM (boils electrolyte) or under-charges a new flooded.\n• Registering as AGM when an EFB or flooded was installed (or vice versa) — wrong charge profile.\n• Entering the wrong amp-hour rating — get it from the battery label, not the old battery.\n• Not waiting 5 minutes after registration before starting — some modules need that long to update charge state estimation.'
WHERE procedure_type IN ('battery_register');

-- =====================================================================
-- Tesla-specific 12V replacement
-- =====================================================================
UPDATE procedures SET
  tools_required = '• 10 mm socket / wrench for the battery terminals\n• Insulated gloves\n• Replacement battery — Tesla 12V is brand-specific:\n  - Pre-2021 Model 3/Y: standard lead-acid Group 26R\n  - 2021+ Refresh Model 3/Y: lithium-iron-phosphate (LiFePO4) — DO NOT replace with lead-acid',
  common_mistakes = '• Skipping the touchscreen "Service → Power Off" step — disconnecting 12V with HV contactors closed can crash modules and force a service-centre re-flash.\n• Working under the frunk before the 2-minute power-down has completed.\n• Replacing the 2021+ LiFePO4 with a standard lead-acid — the BMS expects lithium charge curves and will alarm or refuse to charge.\n• Forgetting to reinstall the protective metal shield over the battery — it''s a crush-protection plate in a front collision.'
WHERE procedure_type IN ('battery_disconnect_order') AND generation_id IN (SELECT id FROM generations WHERE codename IN ('Model Y') OR id = 25);

SELECT 'tools + mistakes seeded' AS status,
  (SELECT COUNT(*) FROM procedures WHERE tools_required IS NOT NULL) AS with_tools,
  (SELECT COUNT(*) FROM procedures WHERE common_mistakes IS NOT NULL) AS with_mistakes,
  (SELECT COUNT(*) FROM procedures) AS total;
