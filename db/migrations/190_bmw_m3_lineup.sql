-- BMW M3 model + 5 gens (F80, G80, G80 LCI, G81, G81 LCI) following the
-- separate-model pattern established by i4 + i5. Each M3 gen belongs to
-- the corresponding 3-Series family for cross-reference.
--
-- Engines added:
-- - S55B30 — 3.0L twin-turbo I6, 425/444/450 hp (M3 F80, M3 CS F80)
-- - S58B30 — 3.0L twin-turbo I6, 480/510/530/550 hp (M3 G80, M3 G80 LCI,
--   M3 G81 Touring, M3 G81 LCI Touring)
--
-- Auto-data dimensions (mm):
-- - F80 sedan: 4671 x 1877 x 1424
-- - G80 sedan: 4795 x 1918 x 1438 (pre-LCI)
-- - G80 LCI sedan: 4794 x 1903 x 1438
-- - G81 Touring: 4794 x 1903 x 1436
-- - G81 LCI Touring: 4801 x 1918 x 1447

SET NAMES utf8mb4;

SET @make_bmw := (SELECT id FROM makes WHERE slug = 'bmw');

-- ----------------------------------------------------------------------------
-- 1. M3 model + new engines
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO models (make_id, slug, name, bio, is_active) VALUES
  (@make_bmw, 'm3', 'M3',
   'BMW M3 is the high-performance variant of the 3 Series, developed by BMW M GmbH. Built on the same chassis as the standard 3 Series sedan (and Touring from 2022) but with bespoke engines, suspension, brakes, cooling and bodywork. The F80 (2014-2018) used the S55 twin-turbo inline-six; the G80 / G81 generation (2020-present) ships with the S58 twin-turbo inline-six rated up to 550 hp in xDrive Competition form.',
   1);

SET @model_m3 := (SELECT id FROM models WHERE make_id = @make_bmw AND slug = 'm3');

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('S55B30', 'BMW S55 3.0L Twin-Turbo I6 (M3 F80 / M4 F82-F83 / M2 Comp F87)', 2979, 'Petrol', 'Twin-turbo', 6),
  ('S58B30', 'BMW S58 3.0L Twin-Turbo I6 (M3 G80 / M4 G82 / M2 G87 Comp / X3 M F97 / X4 M F98)', 2993, 'Petrol', 'Twin-turbo', 6);

SET @e_s55 := (SELECT id FROM engines WHERE code = 'S55B30');
SET @e_s58 := (SELECT id FROM engines WHERE code = 'S58B30');
SET @tx_at8st := 5;

-- ============================================================================
-- M3 F80 sedan 2014-2018 — family bmw-3-series-f30-2012-2019
-- ============================================================================
INSERT INTO generations (
  model_id, slug, ordinal, codename, family_slug, family_label, display_name, body_type,
  start_year, end_year, layout, platform, editorial_intro,
  length_mm, width_mm, height_mm, wheelbase_mm,
  fuel_tank_l, cargo_l, is_active
)
VALUES (
  @model_m3, 'm3-f80-sedan-2014-2018', 1, 'F80',
  'bmw-3-series-f30-2012-2019', 'BMW 3 Series F30 family (2012-2019)',
  'F80 M3', 'Sedan', 2014, 2018, 'RWD', 'BMW CLAR (M)',
'The F80 M3 is the fifth-generation BMW M3, built 2014-2018 on the F30 3 Series chassis but with extensive M-specific upgrades — wider track (60 mm front / 80 mm rear over a 335i), forged 18- or 19-inch wheels, M Compound or optional carbon-ceramic brakes, an Active M Differential, and a unique cooling pack. Power comes from the BMW M-developed S55B30 — a 3.0-litre twin-turbo inline-six rated at 425 hp (431 PS) in the standard car, 444 hp in the Competition Package (2016+), and 460 hp in the limited-run M3 CS (2018).\n\nTransmissions: 6-speed manual standard, 7-speed M DCT (dual-clutch) optional. 0-100 km/h is 4.1 seconds (DCT) / 4.3 (manual); top speed 250 km/h (off the limiter via M Driver''s Package). Body type is sedan only — the same engine in the F82 coupé / F83 convertible is sold under the M4 nameplate. OEM oil: BMW Longlife-01 5W-30 (NOT LL-04 — the S55 high-HTHS spec requires the full LL-01 grade), capacity 6.5 L. Coolant: BMW G48 HOAT, with a separate intercooler water-air circuit using the same coolant.',
  4671, 1877, 1424, 2812,
  60, 480, 1
);

SET @gen_f80 := (SELECT id FROM generations WHERE slug = 'm3-f80-sedan-2014-2018');

INSERT INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_f80, 'm3-425-hp-m-dct',          'M3 (425 Hp) M DCT',          @e_s55, @tx_at8st, 425, 4.1, 250, 'RWD', 2014, 2018),
  (@gen_f80, 'm3-425-hp-manual',         'M3 (425 Hp) 6-Speed Manual', @e_s55, NULL,      425, 4.3, 250, 'RWD', 2014, 2018),
  (@gen_f80, 'm3-444-hp-competition-dct','M3 (444 Hp) Competition M DCT', @e_s55, @tx_at8st, 444, 4.0, 280, 'RWD', 2016, 2018),
  (@gen_f80, 'm3-460-hp-cs-dct',         'M3 CS (460 Hp) M DCT',       @e_s55, @tx_at8st, 460, 3.9, 280, 'RWD', 2018, 2018);

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, notes)
VALUES
  (@gen_f80, 'engine_oil', @e_s55, 6.50, 6.90, '5W-30', 'BMW Longlife-01',
   10000, 16000, 'S55 twin-turbo I6. LL-01 (NOT LL-04 or LL-12 FE) — the S55 requires full HTHS-3.5+ to handle the high oil temperatures at track-day duty cycles. Many M owners shorten the OCI to 5000-7500 mi.'),
  (@gen_f80, 'coolant', @e_s55, 11.0, 11.6, NULL, 'BMW G48', NULL, NULL,
   'Main engine coolant + dedicated charge-air-cooler (CAC) water-air circuit on the same G48 spec. Total system volume ~11 L; ~6 L on a drain-only service.');

-- ============================================================================
-- M3 G80 sedan 2020-2024 (pre-LCI) — family bmw-3-series-g20-2019-present
-- ============================================================================
INSERT INTO generations (
  model_id, slug, ordinal, codename, family_slug, family_label, display_name, body_type,
  start_year, end_year, layout, platform, editorial_intro,
  length_mm, width_mm, height_mm, wheelbase_mm,
  fuel_tank_l, cargo_l, is_active
)
VALUES (
  @model_m3, 'm3-g80-sedan-2020-2024', 2, 'G80',
  'bmw-3-series-g20-2019-present', 'BMW 3 Series G20 family (2019-present)',
  'G80 M3', 'Sedan', 2020, 2024, 'AWD', 'BMW CLAR (M)',
'The G80 M3 is the sixth-generation BMW M3, launched mid-2020 for the 2021 model year and produced through 2024 before the LCI facelift. The most significant change vs F80: a new S58B30 twin-turbo inline-six (replacing the S55), rated 480 hp standard / 510 hp Competition / 530 hp xDrive Competition. The 510-hp Competition is the volume seller (M Steptronic 8-speed automatic only); the 480-hp manual is RWD-only and the only manual M3 in this generation.\n\nM xDrive (M-specific AWD with selectable RWD-only "2WD" mode) is exclusive to the 510+ hp Competition variants. Body type is sedan; the G82 coupé sells under the M4 nameplate, and the G81 Touring (added 2022) is a separate ownerspecs gen. OEM oil: BMW Longlife-04 0W-30, capacity 6.5 L — Shell Helix Ultra ECT 5W-30 is the BMW-approved alternate. Coolant: BMW G48 HOAT on pre-LCI MY2021-2023; MY2024 transitions to BMW LC-18.',
  4795, 1918, 1438, 2857,
  59, 480, 1
);

SET @gen_g80 := (SELECT id FROM generations WHERE slug = 'm3-g80-sedan-2020-2024');

INSERT INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_g80, 'm3-480-hp-manual',                    'M3 (480 Hp) 6-Speed Manual',         @e_s58, NULL,      480, 4.2, 250, 'RWD', 2020, 2024),
  (@gen_g80, 'm3-510-hp-competition-steptronic',    'M3 Competition (510 Hp) Steptronic', @e_s58, @tx_at8st, 510, 3.9, 250, 'RWD', 2020, 2024),
  (@gen_g80, 'm3-530-hp-cs-xdrive-steptronic',      'M3 CS (530 Hp) xDrive Steptronic',   @e_s58, @tx_at8st, 530, 3.4, 302, 'AWD', 2023, 2024),
  (@gen_g80, 'm3-510-hp-competition-xdrive-steptronic', 'M3 Competition (510 Hp) xDrive Steptronic', @e_s58, @tx_at8st, 510, 3.5, 290, 'AWD', 2021, 2024);

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, notes)
VALUES
  (@gen_g80, 'engine_oil', @e_s58, 6.50, 6.90, '0W-30', 'BMW Longlife-04',
   10000, 16000, 'S58 twin-turbo I6. BMW-approved alternates: Shell Helix Ultra ECT 5W-30. Track-day OCI shortened to 5000 mi by most owners. Use only 0W-30 viscosity (not 5W-30 in cold climates).'),
  (@gen_g80, 'coolant', @e_s58, 11.5, 12.2, NULL, 'BMW G48', NULL, NULL,
   'Main + CAC coolant circuit. MY2021-2023 specs G48 HOAT. From MY2024 the LCI run migrates to BMW LC-18 — see the M3 G80 LCI gen page.');

-- ============================================================================
-- M3 G80 LCI sedan 2024-present — family bmw-3-series-g20-2019-present
-- ============================================================================
INSERT INTO generations (
  model_id, slug, ordinal, codename, family_slug, family_label, display_name, body_type,
  start_year, end_year, layout, platform, editorial_intro,
  length_mm, width_mm, height_mm, wheelbase_mm,
  fuel_tank_l, cargo_l, is_active
)
VALUES (
  @model_m3, 'm3-g80-lci-sedan-2024-present', 3, 'G80 LCI',
  'bmw-3-series-g20-2019-present', 'BMW 3 Series G20 family (2019-present)',
  'G80 LCI M3', 'Sedan', 2024, NULL, 'AWD', 'BMW CLAR (M)',
'The G80 LCI is the mid-cycle facelift of the G80 M3, launched mid-2024 for the 2025 model year. Externally the LCI brings the BMW M-specific revised LED headlight signature, updated air curtains, and new wheel designs; internally the BMW Curved Display with iDrive 8.5 is now standard. Power outputs adjusted slightly: 480 hp standard manual carries over, 530 hp xDrive Competition becomes the new ceiling for the volume Competition (Comp RWD discontinued in some markets). The M3 CS sold during 2023-2024 ends with the LCI.\n\nMechanically the S58 engine, ZF M Steptronic 8-speed, and chassis hardware are unchanged. Key OEM-spec migration: BMW LC-18 coolant becomes standard from the LCI onwards (replaces G48 HOAT). Engine oil stays at LL-04 0W-30 for the S58.',
  4794, 1903, 1438, 2857,
  59, 480, 1
);

SET @gen_g80_lci := (SELECT id FROM generations WHERE slug = 'm3-g80-lci-sedan-2024-present');

INSERT INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_g80_lci, 'm3-480-hp-manual',                    'M3 (480 Hp) 6-Speed Manual',         @e_s58, NULL,      480, 4.2, 250, 'RWD', 2024, NULL),
  (@gen_g80_lci, 'm3-530-hp-competition-xdrive-steptronic', 'M3 Competition (530 Hp) xDrive Steptronic', @e_s58, @tx_at8st, 530, 3.5, 290, 'AWD', 2024, NULL);

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, notes)
VALUES
  (@gen_g80_lci, 'engine_oil', @e_s58, 6.50, 6.90, '0W-30', 'BMW Longlife-04', 10000, 16000, 'S58 same as G80 pre-LCI.'),
  (@gen_g80_lci, 'coolant', @e_s58, 11.5, 12.2, NULL, 'BMW LC-18', NULL, NULL,
   'LCI run migrated to BMW LC-18 coolant. NOT compatible with G48 HOAT used on pre-LCI G80 — do not mix.');

-- ============================================================================
-- M3 G81 Touring 2022-2024 (pre-LCI) — family bmw-3-series-g20-2019-present
-- ============================================================================
INSERT INTO generations (
  model_id, slug, ordinal, codename, family_slug, family_label, display_name, body_type,
  start_year, end_year, layout, platform, editorial_intro,
  length_mm, width_mm, height_mm, wheelbase_mm,
  fuel_tank_l, cargo_l, is_active
)
VALUES (
  @model_m3, 'm3-g81-touring-2022-2024', 4, 'G81',
  'bmw-3-series-g20-2019-present', 'BMW 3 Series G20 family (2019-present)',
  'G81 M3 Touring', 'Estate', 2022, 2024, 'AWD', 'BMW CLAR (M)',
'The G81 M3 Touring is the first BMW M3 wagon ever produced — launched mid-2022 for the 2023 model year and built through 2024 before the LCI. Mechanically identical to the G80 sedan from the firewall forward (S58 twin-turbo I6, M Steptronic 8-speed automatic, M xDrive AWD only — no manual option on Touring); the wagon adds 460 L of cargo with the rear seats upright (1510 L folded) and uses self-levelling rear air suspension.\n\nOnly one trim was offered: M3 Touring Competition xDrive at 510 hp / 650 Nm — same output as the equivalent sedan but ~80 kg heavier (1865 kg vs ~1780 kg sedan). 0-100 km/h is 3.6 seconds (0.1 s slower than the sedan equivalent), top speed 280 km/h with M Driver''s Package. OEM oil + coolant match the G80 sedan: BMW LL-04 0W-30 (6.5 L), G48 HOAT coolant on MY2023-2024.',
  4794, 1903, 1436, 2857,
  59, 460, 1
);

SET @gen_g81 := (SELECT id FROM generations WHERE slug = 'm3-g81-touring-2022-2024');

INSERT INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_g81, 'm3-touring-510-hp-competition-xdrive-steptronic', 'M3 Touring Competition (510 Hp) xDrive Steptronic', @e_s58, @tx_at8st, 510, 3.6, 280, 'AWD', 2022, 2024);

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, notes)
VALUES
  (@gen_g81, 'engine_oil', @e_s58, 6.50, 6.90, '0W-30', 'BMW Longlife-04', 10000, 16000, 'S58 same as G80 sedan.'),
  (@gen_g81, 'coolant', @e_s58, 11.5, 12.2, NULL, 'BMW G48', NULL, NULL, 'G48 HOAT throughout the pre-LCI Touring run.');

-- ============================================================================
-- M3 G81 LCI Touring 2024-present — family bmw-3-series-g20-2019-present
-- ============================================================================
INSERT INTO generations (
  model_id, slug, ordinal, codename, family_slug, family_label, display_name, body_type,
  start_year, end_year, layout, platform, editorial_intro,
  length_mm, width_mm, height_mm, wheelbase_mm,
  fuel_tank_l, cargo_l, is_active
)
VALUES (
  @model_m3, 'm3-g81-lci-touring-2024-present', 5, 'G81 LCI',
  'bmw-3-series-g20-2019-present', 'BMW 3 Series G20 family (2019-present)',
  'G81 LCI M3 Touring', 'Estate', 2024, NULL, 'AWD', 'BMW CLAR (M)',
'The G81 LCI is the facelift M3 Touring (Competition xDrive only), launched alongside the G80 LCI sedan in 2024 for the 2025 model year. Externally and internally mirrors the G80 LCI''s changes (revised LED signature, Curved Display + iDrive 8.5, updated wheels). The MY2025 Touring is the first M3 wagon to crack 530 hp; an even higher 550 hp variant exists in some markets as a limited-edition tribute (badged with an "M3 CS Touring" lookalike package although BMW has not officially built an M3 CS Touring).\n\nMechanically the S58 engine is unchanged. Coolant migrates to BMW LC-18 from the LCI onwards. Engine oil stays at LL-04 0W-30. Cargo capacity 500 L upright (1510 L folded) for the LCI body.',
  4801, 1918, 1447, 2857,
  59, 500, 1
);

SET @gen_g81_lci := (SELECT id FROM generations WHERE slug = 'm3-g81-lci-touring-2024-present');

INSERT INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_g81_lci, 'm3-touring-530-hp-competition-xdrive-steptronic', 'M3 Touring Competition (530 Hp) xDrive Steptronic', @e_s58, @tx_at8st, 530, 3.5, 280, 'AWD', 2024, NULL),
  (@gen_g81_lci, 'm3-touring-550-hp-competition-xdrive-steptronic', 'M3 Touring Competition (550 Hp) xDrive Steptronic', @e_s58, @tx_at8st, 550, 3.4, 290, 'AWD', 2024, NULL);

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, notes)
VALUES
  (@gen_g81_lci, 'engine_oil', @e_s58, 6.50, 6.90, '0W-30', 'BMW Longlife-04', 10000, 16000, 'S58 same as G80 LCI sedan.'),
  (@gen_g81_lci, 'coolant', @e_s58, 11.5, 12.2, NULL, 'BMW LC-18', NULL, NULL, 'BMW LC-18 standard on the LCI Touring.');

-- ============================================================================
-- Sources + citations for all 5 M3 gens
-- ============================================================================
INSERT IGNORE INTO sources (citation, url, retrieved_at, notes) VALUES
  ('Auto-Data.net — BMW M3 (F80)', 'https://www.auto-data.net/en/bmw-m3-f80-generation-5337', NOW(), 'F80 M3 2014-2018 spec set.'),
  ('Auto-Data.net — BMW M3 (G80)', 'https://www.auto-data.net/en/bmw-m3-g80-generation-7930', NOW(), 'G80 M3 sedan pre-LCI 2020-2024.'),
  ('Auto-Data.net — BMW M3 (G80 LCI, facelift 2024)', 'https://www.auto-data.net/en/bmw-m3-g80-lci-facelift-2024-generation-10034', NOW(), 'G80 LCI M3 2024+.'),
  ('Auto-Data.net — BMW M3 Touring (G81)', 'https://www.auto-data.net/en/bmw-m3-touring-g81-generation-8930', NOW(), 'G81 M3 Touring pre-LCI 2022-2024.'),
  ('Auto-Data.net — BMW M3 Touring (G81 LCI, facelift 2024)', 'https://www.auto-data.net/en/bmw-m3-touring-g81-lci-facelift-2024-generation-10035', NOW(), 'G81 LCI M3 Touring 2024+.');

-- Cite each source on the matching gen's trims + fluid_specs
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', t.id, s.id FROM trims t, sources s
  WHERE t.generation_id = @gen_f80 AND s.url = 'https://www.auto-data.net/en/bmw-m3-f80-generation-5337';
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, s.id FROM fluid_specs f, sources s
  WHERE f.generation_id = @gen_f80 AND s.url = 'https://www.auto-data.net/en/bmw-m3-f80-generation-5337';

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', t.id, s.id FROM trims t, sources s
  WHERE t.generation_id = @gen_g80 AND s.url = 'https://www.auto-data.net/en/bmw-m3-g80-generation-7930';
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, s.id FROM fluid_specs f, sources s
  WHERE f.generation_id = @gen_g80 AND s.url = 'https://www.auto-data.net/en/bmw-m3-g80-generation-7930';

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', t.id, s.id FROM trims t, sources s
  WHERE t.generation_id = @gen_g80_lci AND s.url = 'https://www.auto-data.net/en/bmw-m3-g80-lci-facelift-2024-generation-10034';
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, s.id FROM fluid_specs f, sources s
  WHERE f.generation_id = @gen_g80_lci AND s.url = 'https://www.auto-data.net/en/bmw-m3-g80-lci-facelift-2024-generation-10034';

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', t.id, s.id FROM trims t, sources s
  WHERE t.generation_id = @gen_g81 AND s.url = 'https://www.auto-data.net/en/bmw-m3-touring-g81-generation-8930';
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, s.id FROM fluid_specs f, sources s
  WHERE f.generation_id = @gen_g81 AND s.url = 'https://www.auto-data.net/en/bmw-m3-touring-g81-generation-8930';

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', t.id, s.id FROM trims t, sources s
  WHERE t.generation_id = @gen_g81_lci AND s.url = 'https://www.auto-data.net/en/bmw-m3-touring-g81-lci-facelift-2024-generation-10035';
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, s.id FROM fluid_specs f, sources s
  WHERE f.generation_id = @gen_g81_lci AND s.url = 'https://www.auto-data.net/en/bmw-m3-touring-g81-lci-facelift-2024-generation-10035';
