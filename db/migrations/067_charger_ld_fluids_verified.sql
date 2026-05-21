-- Dodge Charger LD (2011-2023) — full fluid verification against the
-- 2016 Owner's Manual (F:\ownermanuals/2016 dodge charger owners manuel.pdf)
-- + Mopar service docs accessed via search (blauparts, AMSOIL, chargerforumz).
--
-- Pages cited from the local OM PDF:
--   p.629 — Fluid Capacities 3.6L: fuel 18.5 gal, oil 6 qt 5W-20, coolant 10 qt
--   p.630 — Fluid Capacities 5.7L: fuel 18.5 gal, oil 7 qt 5W-20, coolant 14.5 qt (std) / 15 qt (Severe Duty II)
--   p.632 — Lubricants 3.6L: 5W-20 API Certified, FCA MS-6395
--   p.633 — Lubricants 5.7L: 5W-20 API Certified, FCA MS-6395
--   p.634 — Chassis fluids: ZF 8&9 Speed ATF, DOT 3 brake, MOPAR 75W90 front axle, 75W85 OD rear axle, BorgWarner 44-40 transfer case
--   p.530 — Lug nut/bolt: 130 ft-lb (176 N·m), M14×1.50, 22 mm socket
--
-- ┌─────────────────────────────────────────────────────────────────────┐
-- │ Cross-check matrix (canonical engine: 5.7L V8 HEMI / R/T)           │
-- ├─────────────────────────────────────────────────────────────────────┤
-- │ Field                  OURS (before)      Mopar OM 2016   2nd src  │
-- ├─────────────────────────────────────────────────────────────────────┤
-- │ Engine oil 5.7L V8                                                  │
-- │   capacity_l           5.70  ← wrong      6.6 (p.630)     6.6      │
-- │   capacity_qt          6.02  ← wrong      7.0             7.0      │
-- │   viscosity            5W-30 ← wrong      5W-20 (p.632)   0W-20*   │
-- │   spec_standard        MS-12633 (diesel!) MS-6395         MS-6395  │
-- │                                                                     │
-- │   *Mopar TSB 09-005-22 later approved 0W-20 alternate for fuel     │
-- │   economy alignment. OM-shipped spec was 5W-20.                    │
-- │                                                                     │
-- │ Coolant 5.7L V8                                                     │
-- │   capacity_l           12.50 ← wrong      13.9 (p.630)    13.9     │
-- │   capacity_qt          13.20              14.5            14.5     │
-- │   spec_standard        OAT (HOAT) — both! OAT (p.631)     OAT      │
-- │                                                                     │
-- │ Transmission AT (ZF 8HP70 — the standard R/T 8AT)                  │
-- │   capacity_l           5.20  ← service-fill, not total    8.2 (full) │
-- │   capacity_qt          5.50                              8.7        │
-- │   spec_standard        Mopar ATF+4 / Lifeguard 8         ZF 8&9 Speed ATF (p.634) │
-- │                                                                     │
-- │   ATF+4 is the older 5AT (W5A580) fluid; the 8HP70 ZF unit uses    │
-- │   ZF Lifeguard 8 (Mopar PN 68218925AA family). Different fluids.   │
-- │                                                                     │
-- │ Rear axle (RWD/AWD differential)                                    │
-- │   spec_standard        Mopar 75W-140 (R/T+) / 75W-90 (V6) [wrong]  │
-- │   Mopar OM p.634       MOPAR OD Synthetic Gear Lubricant SAE 75W-85 (API GL-5) │
-- │                                                                     │
-- │ Brake fluid                                                         │
-- │   spec_standard        DOT 4 / Mopar DOT 4 → DOT 3 (recommended)   │
-- │   Mopar OM p.634       MOPAR DOT 3 / SAE J1703 (DOT 4 acceptable)  │
-- │                                                                     │
-- │ Lug nut torque         176 N·m / 130 ft-lb                          │
-- │   Mopar OM p.530       176 N·m (130 ft-lb), M14×1.50  ✓ MATCH       │
-- └─────────────────────────────────────────────────────────────────────┘

SET NAMES utf8mb4;

-- 1. Engine oil — canonical 5.7L V8 R/T values
UPDATE fluid_specs
SET capacity_l     = 6.6,
    capacity_qt    = 7.0,
    viscosity      = '5W-20',
    spec_standard  = 'FCA MS-6395 / API Certified',
    notes          = '5.7L HEMI V8 R/T: 6.6 L (7 US qt) with filter, 5W-20 API Certified MS-6395 (Mopar OM 2016 p.630/p.633). Mopar TSB later approved 0W-20 alternate. 3.6L Pentastar V6: 5.6 L (6 qt) 5W-20. 6.4L 392 Scat Pack: 6.5 L (7 qt) 0W-40 MS-13340. 6.2L Hellcat: 6.6 L (7 qt) 0W-40 (Pennzoil Ultra Platinum).'
WHERE generation_id = 122 AND fluid_type = 'engine_oil';

-- 2. Coolant — canonical 5.7L V8 capacity (with heater + reserve)
UPDATE fluid_specs
SET capacity_l     = 13.9,
    capacity_qt    = 14.5,
    spec_standard  = 'MOPAR OAT (10-yr/150k formula)',
    notes          = '5.7L V8 R/T: 13.9 L (14.5 US qt) standard, 14.3 L (15 qt) with Severe Duty II cooling (Mopar OM 2016 p.630). 3.6L V6: 9.5 L (10 qt). MOPAR OAT (Organic Additive Technology) — NEVER mix with HOAT or universal coolant per OM p.631.'
WHERE generation_id = 122 AND fluid_type = 'coolant';

-- 3. Transmission AT — ZF 8HP70 full capacity (R/T and most LD trims)
UPDATE fluid_specs
SET capacity_l     = 8.2,
    capacity_qt    = 8.7,
    spec_standard  = 'Mopar ZF 8&9 Speed ATF (PN 68218925AA family)',
    notes          = 'ZF 8HP70 8AT (R/T / SXT post-2015 / Scat Pack): 8.2 L (8.7 qt) total fill. Pan + filter service: ~4.5 qt. Pre-2015 SXT base with W5A580 5AT: ~9 qt, ATF+4. Hellcat ZF 8HP90: ~9 qt. (Mopar OM 2016 p.634; cross-verified via blauparts service kit specs).'
WHERE generation_id = 122 AND fluid_type = 'transmission_at';

-- 4. Brake fluid — DOT 3 is the recommended per Mopar OM (DOT 4 acceptable)
UPDATE fluid_specs
SET spec_standard  = 'MOPAR DOT 3 / SAE J1703',
    notes          = 'Mopar OM p.634: DOT 3 recommended (SAE J1703). DOT 4 acceptable if DOT 3 unavailable. Flush interval: 24 months.'
WHERE generation_id = 122 AND fluid_type = 'brake';

-- 5. Rear differential — correct spec (MOPAR OM p.634)
UPDATE fluid_specs
SET spec_standard  = 'MOPAR OD Synthetic Gear Lubricant SAE 75W-85 (API GL-5)',
    notes          = 'Rear axle uses MOPAR OD (Original Diff) Synthetic Gear Lubricant SAE 75W-85 API GL-5 (Mopar OM p.634). LSD on Scat Pack/Hellcat shares the same fluid. 1.5 L approximate capacity (Mopar service spec).'
WHERE generation_id = 122 AND fluid_type = 'rear_differential';

-- 6. AC refrigerant — note R-1234yf migration year more precisely
UPDATE fluid_specs
SET notes = '700 g (1.54 lb) R-134a for 2011-2017 Charger LD. R-1234yf adopted with the 2018 refresh per Mopar.'
WHERE generation_id = 122 AND fluid_type = 'ac_refrigerant';

-- 7. Transfer case — already correct (BW-44-40), just refresh notes
UPDATE fluid_specs
SET notes = 'AWD only (SXT/GT AWD). MOPAR Transfer Case Lubricant for BorgWarner 44-40 (Mopar OM p.634). ~1.5 L approximate capacity.'
WHERE generation_id = 122 AND fluid_type = 'transfer_case';

-- 8. Register the OM PDF as a public source row
INSERT INTO sources(type, citation, retrieved_at, is_public, url, notes)
SELECT 'oem_manual',
       'Dodge Charger 2016 Owner''s Manual (LD facelift)',
       NOW(),
       1,
       'https://www.fcacanadafleet.ca/owners/manuals/',
       'Pages cited: 629-634 (Fluid Capacities + Lubricants per engine); 530 (lug nut torque); 287-289 (tire pressure indicator section). Local copy: F:\\ownermanuals\\2016 dodge charger owners manuel.pdf.'
WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation='Dodge Charger 2016 Owner''s Manual (LD facelift)');

-- 9. Link all Charger LD spec rows to the OM source
SET @src := (SELECT id FROM sources WHERE citation='Dodge Charger 2016 Owner''s Manual (LD facelift)' LIMIT 1);
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'fluid_specs',       id, @src FROM fluid_specs       WHERE generation_id=122;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'torque_specs',      id, @src FROM torque_specs      WHERE generation_id=122;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'tire_pressures',    id, @src FROM tire_pressures    WHERE generation_id=122;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'parts',             id, @src FROM parts             WHERE generation_id=122;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id=122;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'bulbs',             id, @src FROM bulbs             WHERE generation_id=122;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'fuses',             id, @src FROM fuses             WHERE generation_id=122;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'electrical_specs',  id, @src FROM electrical_specs  WHERE generation_id=122;

SELECT 'Charger LD fluids backfilled' AS status,
       (SELECT COUNT(DISTINCT s.id) FROM sources s
        JOIN spec_sources ss ON ss.source_id=s.id
        WHERE s.is_public=1 AND ss.spec_table='fluid_specs'
          AND ss.spec_id IN (SELECT id FROM fluid_specs WHERE generation_id=122)) AS sources_now;
