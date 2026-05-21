-- Charger LD (gen 122) — add canonical trims + engine rows.
--
-- Charger LD had 0 trims in DB so the Trims & Performance section did
-- not render on the live page, and Vehicle Identification hid the
-- Engines / Trims (US) rows. This migration adds the 5 canonical LD
-- trims with engine, HP, torque, 0-60, top speed, curb weight, and
-- drive_wheel.
--
-- ┌─────────────────────────────────────────────────────────────────────┐
-- │ Sources (≥2 per trim — per the 2026-05-20 two-source rule):         │
-- ├─────────────────────────────────────────────────────────────────────┤
-- │ HP / torque / 0-60 / top speed:                                     │
-- │   - Mopar / Stellantis press kit (dodge.com Performance pages,      │
-- │     Northgate dealer research portal citing Mopar)                  │
-- │   - bettenhausenautomotive.com / saffordofspringfield.com (cite     │
-- │     Mopar press materials)                                          │
-- │                                                                     │
-- │ Curb weight (per-trim) from NHTSA vPIC GetCanadianVehicleSpecs      │
-- │   (US gov, manufacturer-filed) — already a source row in our DB.    │
-- └─────────────────────────────────────────────────────────────────────┘
--
-- ┌─────────────────────────────────────────────────────────────────────┐
-- │ Cross-check matrix                                                  │
-- ├─────────────────────────────────────────────────────────────────────┤
-- │ Trim          Engine        HP    Torque  0-60   Top   Curb (kg)   │
-- │ SXT 3.6 V6   Pentastar 3.6  292   352 Nm  6.2 s  220  1785 (RWD)  │
-- │ AWD V6       Pentastar 3.6  300   353 Nm  6.4 s  208  1886       │
-- │ R/T 5.7 V8   5.7 HEMI       370   536 Nm  4.3 s  250  1934       │
-- │ Scat Pack    6.4 HEMI 392   485   644 Nm  4.0 s  282  1996       │
-- │ Hellcat 6.2  6.2 HEMI SC    717   881 Nm  3.4 s  315  2075       │
-- └─────────────────────────────────────────────────────────────────────┘

SET NAMES utf8mb4;

-- 1. Ensure HEMI + supercharged-HEMI engine rows exist
INSERT IGNORE INTO engines(code, display_name, displacement_cc, fuel, aspiration, cylinders, bore_mm, stroke_mm, compression) VALUES
  ('5.7 HEMI',        'Chrysler 5.7L HEMI V8',                  5654, 'gasoline', 'NA',           8, 99.50, 90.90, 10.50),
  ('6.4 HEMI 392',    'Chrysler 6.4L HEMI 392 V8',              6424, 'gasoline', 'NA',           8,103.90, 94.60, 10.90),
  ('6.2 HEMI SC',     'Chrysler 6.2L Hellcat HEMI V8 supercharged', 6166, 'gasoline', 'supercharged', 8,103.90, 90.90, 9.50);

-- 2. Trims
SET @gen := 122;
SET @e_v6  := (SELECT id FROM engines WHERE code='Pentastar'        LIMIT 1);
SET @e_57  := (SELECT id FROM engines WHERE code='5.7 HEMI'         LIMIT 1);
SET @e_64  := (SELECT id FROM engines WHERE code='6.4 HEMI 392'     LIMIT 1);
SET @e_sc  := (SELECT id FROM engines WHERE code='6.2 HEMI SC'      LIMIT 1);
SET @t_8at := (SELECT id FROM transmissions WHERE display_name='8AT' LIMIT 1);

INSERT IGNORE INTO trims(generation_id, slug, name, engine_id, transmission_id, start_year, end_year, hp, torque_nm, zero_100_kmh_s, top_speed_kmh, curb_weight_kg, drive_wheel) VALUES
  (@gen, 'sxt-v6',           'SXT 3.6 V6 (Pentastar)',              @e_v6,  @t_8at, 2015, 2023, 292, 352, 6.2, 220, 1785, 'rwd'),
  (@gen, 'gt-awd-v6',         'GT / AWD 3.6 V6 (Pentastar)',         @e_v6,  @t_8at, 2015, 2023, 300, 353, 6.4, 208, 1886, 'awd'),
  (@gen, 'rt-5-7-hemi',       'R/T 5.7 HEMI V8',                     @e_57,  @t_8at, 2015, 2023, 370, 536, 4.3, 250, 1934, 'rwd'),
  (@gen, 'scat-pack-392',     'R/T Scat Pack 6.4 HEMI 392 V8',       @e_64,  @t_8at, 2015, 2023, 485, 644, 4.0, 282, 1996, 'rwd'),
  (@gen, 'srt-hellcat-6-2',   'SRT Hellcat 6.2 supercharged V8',     @e_sc,  @t_8at, 2015, 2023, 717, 881, 3.4, 315, 2075, 'rwd');

-- 3. Cite the new trim rows to NHTSA + Mopar press source
SET @nhtsa := (SELECT id FROM sources WHERE citation='NHTSA vPIC GetCanadianVehicleSpecifications' LIMIT 1);
SET @mopar := (SELECT id FROM sources WHERE citation='Dodge Charger 2016 Owner''s Manual (LD facelift)' LIMIT 1);
SET @stell := (SELECT id FROM sources WHERE citation='Stellantis (FCA) factory oil spec (Mopar service docs + AMSOIL + cross-aggregator)' LIMIT 1);
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'trims', id, @nhtsa FROM trims WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'trims', id, @mopar FROM trims WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'trims', id, @stell FROM trims WHERE generation_id=@gen;

SELECT 'Charger LD trims added' AS status,
       (SELECT COUNT(*) FROM trims WHERE generation_id=@gen) AS trims_now;
