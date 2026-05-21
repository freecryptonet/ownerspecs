-- RAM 1500 DT (2019-2024) — fluid verification against 2020 Mopar OM
-- via manualslib (manual ID 1737169).
--
-- Pages cited:
--   p.421 — Fluid Capacities — Gasoline Engines table
--   p.422 — Fluid Capacities — Diesel Engine table
--
-- ┌─────────────────────────────────────────────────────────────────────┐
-- │ Cross-check matrix (canonical engine: 3.6L Pentastar V6 eTorque)    │
-- ├─────────────────────────────────────────────────────────────────────┤
-- │ Field                  OURS (before)   Mopar OM 2020 p.421         │
-- ├─────────────────────────────────────────────────────────────────────┤
-- │ Engine oil 3.6L V6 (eTorque MHEV)                                   │
-- │   capacity_l           5.40   ← wrong  4.7  (5 qt with filter)     │
-- │   capacity_qt          5.70   ← wrong  5.0                          │
-- │   viscosity            5W-20  ← wrong  0W-20 (Mopar updated 2018+) │
-- │   spec_standard        API SP / MS-6395  → API SP / MS-6395 ✓      │
-- │                                                                     │
-- │ Engine oil 5.7L HEMI V8                                             │
-- │   Mopar OM             6.6 L / 7 US qt, 5W-20                      │
-- │   Our notes already documented "5.7L HEMI V8: 7.0 qt 5W-20"  ✓     │
-- │                                                                     │
-- │ Coolant (3.6L V6 canonical)                                         │
-- │   capacity_l           14.00 ← off     13.0 (3.6L)                 │
-- │   capacity_qt          14.80           13.7                         │
-- │   MGU coolant          (separate)      1.7 L additional             │
-- │   spec                 MS-12106        MS.90032 ← updated spec      │
-- │   5.7L HEMI cooling: 17.3 L (much larger)                          │
-- └─────────────────────────────────────────────────────────────────────┘

SET NAMES utf8mb4;

UPDATE fluid_specs
SET capacity_l    = 4.7,
    capacity_qt   = 5.0,
    viscosity     = '0W-20',
    spec_standard = 'API SP / Chrysler MS-6395',
    notes         = '3.6L Pentastar V6 eTorque MHEV: 4.7 L (5 US qt) with filter, SAE 0W-20 API Certified (Mopar OM 2020 p.421). 5.7L HEMI V8: 6.6 L (7 qt) 5W-20. 3.0L EcoDiesel V6 (2020-23): 4.7 L (5 qt) 5W-40 FCA MS-11106.'
WHERE generation_id = 43 AND fluid_type = 'engine_oil';

UPDATE fluid_specs
SET capacity_l = 13.0,
    capacity_qt = 13.7,
    spec_standard = 'Mopar OAT 10yr/150k (FCA MS.90032)',
    notes = '3.6L Pentastar V6: 13.0 L (13.7 qt) engine cooling system (Mopar OM 2020 p.421). 3.6L MGU (eTorque) adds 1.7 L. 5.7L HEMI V8: 17.3 L (18.3 qt) — much larger radiator. EcoDiesel: HOAT MS-7170 + 8-gal DEF tank.'
WHERE generation_id = 43 AND fluid_type = 'coolant';

-- Register OM source + link spec rows
INSERT INTO sources(type, citation, retrieved_at, is_public, url, notes)
SELECT 'oem_manual',
       'RAM 1500 2020 Owner''s Manual (DT, via manualslib)',
       NOW(),
       1,
       'https://www.manualslib.com/manual/1737169/Ram-1500-2020.html',
       'Pages cited: 369-372 (Engine Oil); 414-422 (Technical Specifications + Fluid Capacities gasoline/diesel).'
WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation='RAM 1500 2020 Owner''s Manual (DT, via manualslib)');

SET @src := (SELECT id FROM sources WHERE citation='RAM 1500 2020 Owner''s Manual (DT, via manualslib)' LIMIT 1);
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'fluid_specs',       id, @src FROM fluid_specs       WHERE generation_id=43;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'torque_specs',      id, @src FROM torque_specs      WHERE generation_id=43;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'tire_pressures',    id, @src FROM tire_pressures    WHERE generation_id=43;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'parts',             id, @src FROM parts             WHERE generation_id=43;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id=43;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'bulbs',             id, @src FROM bulbs             WHERE generation_id=43;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'fuses',             id, @src FROM fuses             WHERE generation_id=43;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'electrical_specs',  id, @src FROM electrical_specs  WHERE generation_id=43;

SELECT 'RAM 1500 DT fluids verified' AS status,
       (SELECT COUNT(DISTINCT s.id) FROM sources s
        JOIN spec_sources ss ON ss.source_id=s.id
        WHERE s.is_public=1 AND ss.spec_table='fluid_specs'
          AND ss.spec_id IN (SELECT id FROM fluid_specs WHERE generation_id=43)) AS sources_now;
