#!/usr/bin/env python3
"""Generate mig 361 — fill Audi C8/B9 empty procedure body_md from 4 templates.

Templates (restated in our own words; no vendor names per repo policy):
- dsg-7sp-fluid-change       (B9 A4 sedan/avant + LCI; DL501 0B5 S-tronic)
- epb-service-mode           (C8 A6/S6/RS6 — clone of B9 body, mechanism is identical)
- jacking-points-air-suspension (C8 air-spring models)
- zf-8hp-fluid-change        (C8 + B9 quattro)
"""

EPB_BODY = """## Why EPB service mode matters
The C8 A6/S6/RS6 (and B9 A4/S4/RS4) use motor-on-caliper electronic parking brake actuators on each rear caliper. Like all motor-on-caliper systems, the rear caliper piston **cannot be wound back manually** without first either (a) putting the EPB into service mode via a diagnostic tool, or (b) removing the actuator and using the Torx emergency-release procedure. Forcing the piston with a generic wind-back tool destroys the actuator gearbox.

## Battery check first
The EPB cycle draws substantial current — confirm the main starter battery (rear right luggage area on C8, boot floor on B9) is at full charge, or connect a stabilised charger / jump-start terminal to the engine bay charging post before starting.

## Service mode via diagnostic tool
1. Connect a VAG-compatible diagnostic tool (VCDS / OBDeleven / VAS 5052) to the OBD-II port.
2. Block the front wheels, move the selector to **P**, switch ignition **ON** but do not start the engine.
3. From the diagnostic tool: **Module 53 (Parking Brake) → Service position → Renew brake pads**. The rear EPB motors retract; a service icon and "Parking brake — service mode" message appear in the cluster.

## Mechanical emergency release (if the EPB will not respond)
1. Release the parking brake, switch ignition off, wait 30 seconds.
2. Raise the vehicle and remove the rear wheels.
3. Disconnect the EPB actuator electrical connector at each caliper.
4. Remove the three actuator-to-caliper bolts. The actuator-to-caliper seal is single-use — order new ones in advance.
5. With the actuator off the caliper, insert a Torx **T45 bit** into the spindle drive and turn anti-clockwise to retract the piston.
6. **Renew the actuator mounting bolts** (single-use per OEM spec). Refit the actuator with new seal and new bolts, torque to spec.

## Brake pad renewal
1. Raise the vehicle, remove rear wheels.
2. With service mode active, disconnect the brake pad wear sensor connector (if fitted).
3. Remove the caliper carrier bolts, slide the caliper off, and tie it up so the brake hose does not bear weight.
4. Press the rear caliper piston back using a VAG-compatible wind-back tool — the rear pistons require a wind+push action, not just push.
5. Inspect rotors; replace if at or below the minimum thickness stamped on the hub face.
6. Fit new pads, refit the caliper carrier, torque to spec, refit the wear sensor.
7. Reconnect the EPB actuator electrical connector and lower the vehicle.
8. Re-initialise the EPB via the diagnostic tool: **Module 53 → Basic setting → Initialisation**. The system exits service mode and re-tensions the cables.
9. With the vehicle stationary, pump the brake pedal several times to bed the piston against the new pads. Top up brake fluid if necessary."""

EPB_TOOLS = "Torx T45 bit; VAG-compatible piston wind-back tool; diagnostic tool with module-53 access (VCDS / OBDeleven / VAS); DOT 4 LV brake fluid (VW TL 766-Z); new actuator-to-caliper seal + new mounting bolts (single-use); torque wrench."
EPB_MISTAKES = "Winding the piston back manually with a generic G-clamp tool (destroys the EPB gearbox); reusing the single-use actuator seal or mounting bolts; running the service-mode cycle on a depleted battery (sets fault codes); forgetting to exit service mode and re-initialise before driving away."

ZF8HP_BODY = """## Why this fluid is not really lifetime
The ZF 8HP transmission (8HP50/8HP55/8HP65/8HP75 across Audi B9 and C8 quattro variants) is filled with lifetime ATF at the factory — but in practice, every workshop that opens a high-mileage 8HP recommends a fluid + integrated filter change at 60-100k mi / 100-160k km. Old ATF darkens, loses friction-modifier balance, and the integrated valve-body filter clogs, causing slipping, harsh shifts, and torque-converter lockup judder.

## Fluid + filter spec
- **ATF**: ZF Lifeguard 8 (also sold under various OEM part numbers: VAG G055540A2, BMW 83 22 2 152 426, ZF 8700 002 / 8700 003).
- **Capacity (drain + refill)**: ~5.0 L (8HP50, B9 quattro) / ~6.0 L (8HP65, C8 standard) / ~7.0 L (8HP75 / 8HP70HIS, RS6 / RS7 / S8 D5). The whole system holds ~9.0-11.0 L; only the pan volume drains.
- **Filter**: integrated into the pan. The whole pan + filter is replaced as one assembly (a paper element is bonded to the steel pan). Single-use pan-to-case gasket.
- **Pan bolts**: single-use; renew with kit.

## Procedure
1. Park on a level surface and warm the gearbox to ~30-40°C (a short drive of ~10 min).
2. Switch ignition off. Raise the vehicle on a four-post lift or level wheel-on stands — the gearbox **must** be level for accurate fluid-level setting.
3. Remove the underbody tray and the small access cover at the bell-housing if required for filler-plug access.
4. Place a large catch pan; capacity at least 8 L. Remove the **drain plug** (centre of pan on most variants) and let the fluid drain fully — typically 4-7 L.
5. Remove the pan bolts in a cross-pattern. Lower the pan slowly; residual fluid will spill from the corners.
6. Wipe the case mating face. Inspect the pan magnet for steel fines — light grey paste is normal; visible flakes or chips indicate internal wear (stop and investigate).
7. Fit the new pan + integrated filter + new gasket. Torque pan bolts to OEM spec (typically 8 N·m + 90° angle, single-use bolts).
8. Refit the drain plug with a new seal washer, torque to spec (~30 N·m on most ZF 8HP variants).
9. From the fill port on the side of the case, pump in fresh ATF. Start with the previous drain volume.
10. With the gearbox at **30-40°C** on the diagnostic tool live-data readout, **engine running, selector in P** for the level set: open the fill plug; fluid should trickle out steadily. If a steady stream emerges, the level is correct. If nothing comes out, add more and recheck.
11. Refit the fill plug with a new seal; torque to ~30 N·m.
12. Take a short drive — shift through all gears slowly — and inspect for leaks. Adaptation values reset themselves over the next ~100 km of mixed driving."""

ZF8HP_TOOLS = "ZF Lifeguard 8 ATF (5-7 L per service); replacement pan + integrated filter assembly; new gasket + single-use bolts; new drain + fill plug seals; ATF fill pump (manual or pressurised); diagnostic tool capable of reading gearbox oil temperature; T20/T25 Torx and 8 mm Allen sockets; torque wrench; catch pan (8 L+); four-post lift or level wheel-stands."
ZF8HP_MISTAKES = "Setting fluid level cold or with the engine off (overfills or underfills); reusing the bonded pan + filter from the prior service; ignoring metal fines on the magnet (the gearbox is signalling internal wear); reusing single-use pan bolts; doing the service on a hot gearbox above 50°C (level reading is off)."

DSG7_BODY = """## DL501 (0B5) — the 7-speed wet-clutch S-tronic
The A4 B9 with quattro and the 2.0 TFSI / 3.0 TDI / S4 / S5 longitudinal applications use the **DL501 (0B5)** 7-speed wet-clutch dual-clutch transmission ("S-tronic"). It runs in a bath of ATF that lubricates the gear-set and cools the wet clutches. This is **not** the DQ200 dry-clutch unit on transverse VW Group cars — never use DQ200 fluid spec.

## Fluid spec + intervals
- **Fluid**: VW G052529A2 ATF (wet S-tronic spec — *not* the older G052182A2 from earlier wet DSG, and *not* the G052532A2 dry-clutch fluid).
- **Capacity (drain + refill)**: ~7.5 L for the bath; ~4-5 L drains. The system holds ~7.5 L total.
- **External filter**: bolted to the side of the case; renew at every fluid service.
- **Internal mechatronic filter** (inside the unit): renew every second fluid service or 80-100k mi / 130-160k km.
- **Service interval (recommended)**: 40-60k mi / 60-90k km, not the 100k mi "lifetime" suggested by some markets.

## Procedure
1. Drive 10-15 min to reach ~30°C gearbox oil temperature; do **not** fully warm the gearbox.
2. Park on a level lift. Engine off, selector in **P**.
3. Remove the underbody panel for transmission access. Place a clean catch pan under the box (at least 6 L capacity).
4. Remove the **drain plug** (hex on the bottom of the sump). Let fluid drain ~10 min — expect 4-5 L.
5. Renew the drain plug seal; refit the drain plug, torque to ~30 N·m.
6. Remove the external ATF filter (typically 3 Torx bolts). Catch residual fluid; new filter comes with a fresh seal.
7. Refit the external filter, torque the bolts in cross-pattern to OEM spec.
8. From the fill plug (side of the case, hex socket), pump in fresh G052529A2 ATF. Start with the drain volume measured.
9. With the diagnostic tool reading gearbox oil temperature live, start the engine and let the gearbox warm. The level-setting window is **30-50°C** (model-specific; check workshop spec). With engine running, foot on brake, cycle the selector through P/R/N/D/S a few times.
10. With the gearbox at correct temperature, open the fill plug. Correct level is when fluid runs out steadily (not as a stream). If nothing comes out, add more.
11. Refit the fill plug with a new seal, torque to spec.
12. Verify no leaks and let the box self-adapt during the next drive — slow shifts in the first minutes are normal."""

DSG7_TOOLS = "VW G052529A2 ATF (~7 L per service); external ATF filter kit; new drain + fill plug seals; Torx T20/T25; 14 mm hex socket for drain/fill plugs; diagnostic tool with module-02 live data; ATF fill pump; torque wrench; catch pan (6 L+)."
DSG7_MISTAKES = "Using the wrong ATF (DQ200/DQ250 fluid will not lubricate the wet clutches properly); skipping the external filter; setting fluid level outside the 30-50°C window (huge error band); reusing the single-use plug seals; topping up after an undrained service rather than a true drain-and-refill."

JACKING_BODY = """## Why jacking an air-suspension car needs care
The C8 A6 allroad, S6 (some markets), RS6, and A8 D5 ride on the Audi *adaptive air suspension* system. Each corner has an air spring + electronically adjustable damper. If you lift one or two wheels of the air-spring car without first switching the suspension into **Jack mode** (sometimes labelled "Workshop mode" or "Lift mode" in the MMI), the levelling system fights the lift: compressors run to add pressure to the loaded corners, while the unloaded corners over-extend their air struts. Best case is fault codes; worst case is a damaged strut and a $1500-2000 part.

## Putting the suspension into Jack mode
1. With the car stationary, ignition **ON**, all doors closed:
2. **MMI** → **Vehicle / Car** → **Servicing & checks** → **Jack mode** (or **Lift mode** on later MMI builds).
3. Confirm. The cluster displays "Lift mode active — suspension levelling disabled". The car will not adjust ride height while raised.
4. Jack mode persists until you switch it off via MMI **or** drive faster than ~5 km/h. If you bring the car back down on a flat surface and need to drive it off the lift, recall MMI Jack mode and turn it OFF first — otherwise the suspension may take a minute to re-level and gives the impression of a deflated strut.

## Lifting points (factory)
- **Side lifting points** (pinch-weld reinforced areas): four locations, marked by black notches in the underbody plastic just inboard of the rocker panels. The reinforcing plate inside has a flat steel pad ~50 mm × 80 mm. Use a hockey-puck-style rubber jack pad or a flat lift arm pad — never a pointed jack saddle (it will perforate the rocker).
- **Centre lifting points** (on a two-post lift): the front centre point is the cross-member between the lower control arms; the rear centre is at the rear differential housing (the cast aluminium boss directly under the diff). Never lift on the air-strut housing itself or on the air-line manifold.
- **Wheel-on / single-corner jack**: only via the side lifting points. Do not use the engine sump or oil pan as a jack point — they are aluminium and crack readily.

## Air-strut precautions
- Do not unplug an air strut while the suspension is unsupported — the spring may extend uncontrollably.
- If the car will be on stands for >2 hours, support the chassis at the side lift points and let the wheels hang. The struts will not be damaged by static droop, but the compressor will run if Jack mode is exited.
- When lowering back to the ground, drive the car ~50 m to allow ride-height re-levelling to complete before evaluating any work."""

JACKING_TOOLS = "Trolley jack with hockey-puck rubber pad or four-post lift with flat arm pads (never pointed saddles); jack stands rated for the gross axle weight; the in-car MMI to activate Jack mode; the OEM safety triangle (some markets) to confirm chocking; service-position chocks for the wheels not being lifted."
JACKING_MISTAKES = "Lifting without putting the air suspension in Jack mode (causes self-levelling fight and possible strut damage); using a pointed jack saddle directly on the rocker pinch weld (deforms or perforates it); lifting on the oil pan or air-strut housing; leaving Jack mode active and driving off (the suspension stays at whatever height it was — feels like a deflated strut)."


# (gen_id, title, slug, body, tools, mistakes) — gen IDs verified against live DB
TARGETS = [
    # epb-service-mode — 11 C8 variants (B9 4 rows already filled, leave alone)
    (115, "Electronic parking brake (EPB) service mode and pad renewal — A6 (C8)",         "epb-service-mode", EPB_BODY, EPB_TOOLS, EPB_MISTAKES),
    (152, "Electronic parking brake (EPB) service mode and pad renewal — A6 Avant (C8)",   "epb-service-mode", EPB_BODY, EPB_TOOLS, EPB_MISTAKES),
    (153, "Electronic parking brake (EPB) service mode and pad renewal — A6 (C8 LCI)",     "epb-service-mode", EPB_BODY, EPB_TOOLS, EPB_MISTAKES),
    (154, "Electronic parking brake (EPB) service mode and pad renewal — A6 Avant (C8 LCI)", "epb-service-mode", EPB_BODY, EPB_TOOLS, EPB_MISTAKES),
    (155, "Electronic parking brake (EPB) service mode and pad renewal — A6 allroad (C8)", "epb-service-mode", EPB_BODY, EPB_TOOLS, EPB_MISTAKES),
    (156, "Electronic parking brake (EPB) service mode and pad renewal — S6 (C8)",         "epb-service-mode", EPB_BODY, EPB_TOOLS, EPB_MISTAKES),
    (157, "Electronic parking brake (EPB) service mode and pad renewal — S6 Avant (C8)",   "epb-service-mode", EPB_BODY, EPB_TOOLS, EPB_MISTAKES),
    (158, "Electronic parking brake (EPB) service mode and pad renewal — S6 (C8 LCI)",     "epb-service-mode", EPB_BODY, EPB_TOOLS, EPB_MISTAKES),
    (159, "Electronic parking brake (EPB) service mode and pad renewal — S6 Avant (C8 LCI)", "epb-service-mode", EPB_BODY, EPB_TOOLS, EPB_MISTAKES),
    (160, "Electronic parking brake (EPB) service mode and pad renewal — RS6 Avant (C8)",  "epb-service-mode", EPB_BODY, EPB_TOOLS, EPB_MISTAKES),
    (161, "Electronic parking brake (EPB) service mode and pad renewal — RS6 Avant (C8 LCI)", "epb-service-mode", EPB_BODY, EPB_TOOLS, EPB_MISTAKES),

    # jacking-points-air-suspension — 11 C8 variants
    (115, "Jacking and lifting points — A6 (C8) air suspension",          "jacking-points-air-suspension", JACKING_BODY, JACKING_TOOLS, JACKING_MISTAKES),
    (152, "Jacking and lifting points — A6 Avant (C8) air suspension",    "jacking-points-air-suspension", JACKING_BODY, JACKING_TOOLS, JACKING_MISTAKES),
    (153, "Jacking and lifting points — A6 (C8 LCI) air suspension",      "jacking-points-air-suspension", JACKING_BODY, JACKING_TOOLS, JACKING_MISTAKES),
    (154, "Jacking and lifting points — A6 Avant (C8 LCI) air suspension", "jacking-points-air-suspension", JACKING_BODY, JACKING_TOOLS, JACKING_MISTAKES),
    (155, "Jacking and lifting points — A6 allroad (C8) air suspension",  "jacking-points-air-suspension", JACKING_BODY, JACKING_TOOLS, JACKING_MISTAKES),
    (156, "Jacking and lifting points — S6 (C8) air suspension",          "jacking-points-air-suspension", JACKING_BODY, JACKING_TOOLS, JACKING_MISTAKES),
    (157, "Jacking and lifting points — S6 Avant (C8) air suspension",    "jacking-points-air-suspension", JACKING_BODY, JACKING_TOOLS, JACKING_MISTAKES),
    (158, "Jacking and lifting points — S6 (C8 LCI) air suspension",      "jacking-points-air-suspension", JACKING_BODY, JACKING_TOOLS, JACKING_MISTAKES),
    (159, "Jacking and lifting points — S6 Avant (C8 LCI) air suspension", "jacking-points-air-suspension", JACKING_BODY, JACKING_TOOLS, JACKING_MISTAKES),
    (160, "Jacking and lifting points — RS6 Avant (C8) air suspension",   "jacking-points-air-suspension", JACKING_BODY, JACKING_TOOLS, JACKING_MISTAKES),
    (161, "Jacking and lifting points — RS6 Avant (C8 LCI) air suspension", "jacking-points-air-suspension", JACKING_BODY, JACKING_TOOLS, JACKING_MISTAKES),

    # zf-8hp-fluid-change — 11 C8 variants
    (115, "ZF 8HP automatic transmission fluid and filter change — A6 (C8)",         "zf-8hp-fluid-change", ZF8HP_BODY, ZF8HP_TOOLS, ZF8HP_MISTAKES),
    (152, "ZF 8HP automatic transmission fluid and filter change — A6 Avant (C8)",   "zf-8hp-fluid-change", ZF8HP_BODY, ZF8HP_TOOLS, ZF8HP_MISTAKES),
    (153, "ZF 8HP automatic transmission fluid and filter change — A6 (C8 LCI)",     "zf-8hp-fluid-change", ZF8HP_BODY, ZF8HP_TOOLS, ZF8HP_MISTAKES),
    (154, "ZF 8HP automatic transmission fluid and filter change — A6 Avant (C8 LCI)", "zf-8hp-fluid-change", ZF8HP_BODY, ZF8HP_TOOLS, ZF8HP_MISTAKES),
    (155, "ZF 8HP automatic transmission fluid and filter change — A6 allroad (C8)", "zf-8hp-fluid-change", ZF8HP_BODY, ZF8HP_TOOLS, ZF8HP_MISTAKES),
    (156, "ZF 8HP automatic transmission fluid and filter change — S6 (C8)",         "zf-8hp-fluid-change", ZF8HP_BODY, ZF8HP_TOOLS, ZF8HP_MISTAKES),
    (157, "ZF 8HP automatic transmission fluid and filter change — S6 Avant (C8)",   "zf-8hp-fluid-change", ZF8HP_BODY, ZF8HP_TOOLS, ZF8HP_MISTAKES),
    (158, "ZF 8HP automatic transmission fluid and filter change — S6 (C8 LCI)",     "zf-8hp-fluid-change", ZF8HP_BODY, ZF8HP_TOOLS, ZF8HP_MISTAKES),
    (159, "ZF 8HP automatic transmission fluid and filter change — S6 Avant (C8 LCI)", "zf-8hp-fluid-change", ZF8HP_BODY, ZF8HP_TOOLS, ZF8HP_MISTAKES),
    (160, "ZF 8HP automatic transmission fluid and filter change — RS6 Avant (C8)",  "zf-8hp-fluid-change", ZF8HP_BODY, ZF8HP_TOOLS, ZF8HP_MISTAKES),
    (161, "ZF 8HP automatic transmission fluid and filter change — RS6 Avant (C8 LCI)", "zf-8hp-fluid-change", ZF8HP_BODY, ZF8HP_TOOLS, ZF8HP_MISTAKES),

    # dsg-7sp-fluid-change — 4 B9 A4 + 4 C8 A6 (S6/RS6 use ZF 8HP only)
    (24,  "DSG 7-speed wet S-tronic (DL501) fluid + filter change — A4 (B9)",        "dsg-7sp-fluid-change", DSG7_BODY, DSG7_TOOLS, DSG7_MISTAKES),
    (149, "DSG 7-speed wet S-tronic (DL501) fluid + filter change — A4 Avant (B9)",  "dsg-7sp-fluid-change", DSG7_BODY, DSG7_TOOLS, DSG7_MISTAKES),
    (150, "DSG 7-speed wet S-tronic (DL501) fluid + filter change — A4 (B9 LCI)",    "dsg-7sp-fluid-change", DSG7_BODY, DSG7_TOOLS, DSG7_MISTAKES),
    (151, "DSG 7-speed wet S-tronic (DL501) fluid + filter change — A4 Avant (B9 LCI)", "dsg-7sp-fluid-change", DSG7_BODY, DSG7_TOOLS, DSG7_MISTAKES),
    (115, "DSG 7-speed wet S-tronic (DL501) fluid + filter change — A6 (C8)",        "dsg-7sp-fluid-change", DSG7_BODY, DSG7_TOOLS, DSG7_MISTAKES),
    (152, "DSG 7-speed wet S-tronic (DL501) fluid + filter change — A6 Avant (C8)",  "dsg-7sp-fluid-change", DSG7_BODY, DSG7_TOOLS, DSG7_MISTAKES),
    (153, "DSG 7-speed wet S-tronic (DL501) fluid + filter change — A6 (C8 LCI)",    "dsg-7sp-fluid-change", DSG7_BODY, DSG7_TOOLS, DSG7_MISTAKES),
    (154, "DSG 7-speed wet S-tronic (DL501) fluid + filter change — A6 Avant (C8 LCI)", "dsg-7sp-fluid-change", DSG7_BODY, DSG7_TOOLS, DSG7_MISTAKES),
]


def sql_quote(s):
    return "'" + s.replace("\\", "\\\\").replace("'", "''") + "'"


def main():
    print("-- mig 361: fill 41 empty Audi C8/B9 procedure body_md rows from 4 templates")
    print("-- Templates: epb-service-mode (11 C8 rows), jacking-points-air-suspension (11 C8 rows),")
    print("--            zf-8hp-fluid-change (11 C8 rows), dsg-7sp-fluid-change (8 C8+B9 rows)")
    print()
    for gen_id, title, slug, body, tools, mistakes in TARGETS:
        print(f"-- gen {gen_id} {slug}")
        print(
            f"UPDATE procedures SET title = {sql_quote(title)}, "
            f"body_md = {sql_quote(body)}, "
            f"tools_required = {sql_quote(tools)}, "
            f"common_mistakes = {sql_quote(mistakes)} "
            f"WHERE generation_id = {gen_id} AND slug = {sql_quote(slug)};"
        )


if __name__ == "__main__":
    main()
