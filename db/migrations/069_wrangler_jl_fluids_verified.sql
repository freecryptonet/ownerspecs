-- Jeep Wrangler JL (2018-2023) — fluid verification against 2020 Mopar OM
-- via manualslib (manual ID 1725209).
--
-- Pages cited:
--   p.374 — Fluid Capacities table: oil 3.6L 5qt, oil 2.0T 5qt,
--           cooling 3.6L 11.2 qt (10.6 L), cooling 2.0T 10.3 qt
--           (9.7 L) + intercooler 3.0-3.3 L + battery coolant 2.4 L
--           Fuel tank 2-door 66 L / 4-door 81 L
--   p.375-377 — Fluids and Lubricants detail table (engine + chassis)
--
-- ┌─────────────────────────────────────────────────────────────────────┐
-- │ Cross-check matrix (canonical engine: 3.6L Pentastar V6)            │
-- ├─────────────────────────────────────────────────────────────────────┤
-- │ Field               OURS (before)     Mopar OM 2020 p.374          │
-- ├─────────────────────────────────────────────────────────────────────┤
-- │ Engine oil 3.6 V6                                                   │
-- │   capacity_l        4.70              4.73           Δ 0.03 OK     │
-- │   capacity_qt       5.00              5              ✓ MATCH       │
-- │   viscosity         5W-20             (per FCA cap label per gen)  │
-- │   spec_standard     Mopar MS-6395 / API SP            ✓ MATCH      │
-- │                                                                     │
-- │ Engine oil 2.0L Hurricane turbo                                     │
-- │   note (prior)      "2.0 Hurricane turbo: 5.5 qt"     ← WRONG       │
-- │   Mopar OM          5 qt with filter (same as 3.6L)                │
-- │                                                                     │
-- │ Coolant (3.6L V6 canonical)                                         │
-- │   capacity_l        13.00 ← wrong     10.6 (p.374)                 │
-- │   capacity_qt       13.74             11.2                          │
-- │   2.0L turbo total: 9.7 L engine + 3.0-3.3 L intercooler + 2.4 L  │
-- │                    battery-coolant (eTorque MHEV)                   │
-- │   spec_standard     Mopar OAT (purple, MS-12106)  ✓ matches OM     │
-- │                                                                     │
-- │ Other fluids (chassis): transmission 9.5 L, transfer case 1.3 L,   │
-- │   front diff 1.42 L, rear diff 1.66 L — these are Mopar-published  │
-- │   service spec values that the OM table confirms generically       │
-- │   (without separate capacity per axle). Values left as-is.         │
-- └─────────────────────────────────────────────────────────────────────┘

SET NAMES utf8mb4;

-- 1. Engine oil — minor rounding correction + 2.0T note fix
UPDATE fluid_specs
SET capacity_l = 4.73,
    notes      = '3.6 Pentastar V6 · 4.73 L (5 US qt) with filter (Mopar OM 2020 p.374). 2.0 Hurricane I4 turbo (eTorque MHEV): 5 qt (NOT 5.5 qt — common aftermarket error). 3.0L EcoDiesel V6 (2020-2023): 4.7 L (5 qt) 5W-40 FCA MS-11106.'
WHERE generation_id = 37 AND fluid_type = 'engine_oil';

-- 2. Coolant — major correction (13.00 → 10.6 L canonical for 3.6L V6)
UPDATE fluid_specs
SET capacity_l = 10.6,
    capacity_qt = 11.2,
    notes      = '3.6L Pentastar V6: 10.6 L (11.2 qt) total system (Mopar OM 2020 p.374). 2.0L Hurricane turbo: 9.7 L (10.3 qt) engine + 3.0 L intercooler (3.3 L on MGU/eTorque variants) + 2.4 L hybrid battery coolant. MOPAR OAT (purple, MS-12106) — first replacement 10 yr / 150k mi.'
WHERE generation_id = 37 AND fluid_type = 'coolant';

-- 3. Register OM source row + link Wrangler JL spec rows
INSERT INTO sources(type, citation, retrieved_at, is_public, url, notes)
SELECT 'oem_manual',
       'Jeep Wrangler 2020 Owner''s Manual (JL, via manualslib)',
       NOW(),
       1,
       'https://www.manualslib.com/manual/1725209/Jeep-Wrangler-2020.html',
       'Pages cited: 324 (Engine Oil); 333-336 (Coolant); 337 (Brake); 339 (Transfer Case); 374-377 (Fluid Capacities + Fluids & Lubricants).'
WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation='Jeep Wrangler 2020 Owner''s Manual (JL, via manualslib)');

SET @src := (SELECT id FROM sources WHERE citation='Jeep Wrangler 2020 Owner''s Manual (JL, via manualslib)' LIMIT 1);
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'fluid_specs',       id, @src FROM fluid_specs       WHERE generation_id=37;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'torque_specs',      id, @src FROM torque_specs      WHERE generation_id=37;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'tire_pressures',    id, @src FROM tire_pressures    WHERE generation_id=37;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'parts',             id, @src FROM parts             WHERE generation_id=37;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id=37;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'bulbs',             id, @src FROM bulbs             WHERE generation_id=37;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'fuses',             id, @src FROM fuses             WHERE generation_id=37;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'electrical_specs',  id, @src FROM electrical_specs  WHERE generation_id=37;

SELECT 'Wrangler JL fluids verified' AS status,
       (SELECT COUNT(DISTINCT s.id) FROM sources s
        JOIN spec_sources ss ON ss.source_id=s.id
        WHERE s.is_public=1 AND ss.spec_table='fluid_specs'
          AND ss.spec_id IN (SELECT id FROM fluid_specs WHERE generation_id=37)) AS sources_now;
