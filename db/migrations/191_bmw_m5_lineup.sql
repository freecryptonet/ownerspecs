-- BMW M5 model + 3 gens (F90, G90 sedan, G99 Touring).
-- F90 is on G30 platform; G90/G99 on G60 platform.
--
-- Engines: S63 4.4 V8 (id 188, exists) for F90; new S68B44 V8+electric
-- hybrid for G90/G99 (717 hp combined).

SET NAMES utf8mb4;

SET @make_bmw := (SELECT id FROM makes WHERE slug = 'bmw');

INSERT IGNORE INTO models (make_id, slug, name, bio, is_active) VALUES
  (@make_bmw, 'm5', 'M5',
   'BMW M5 is the high-performance variant of the 5 Series, developed by BMW M GmbH. The F90 generation (2018-2023) used the S63 V8 twin-turbo (600-635 hp). The G90 generation (2024+) replaces it with the all-new S68 V8 + electric hybrid drivetrain rated at 717 hp combined — the most powerful M5 ever, available in both G90 sedan and G99 Touring form.',
   1);

SET @model_m5 := (SELECT id FROM models WHERE make_id = @make_bmw AND slug = 'm5');

-- Reuse existing S63 (id 188); add new S68
INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('S68B44', 'BMW S68 4.4L V8 Twin-Turbo + Electric Hybrid (M5 G90 / G99 Touring / XM)', 4395, 'Petrol', 'Twin-turbo', 8);

SET @e_s63 := 188;
SET @e_s68 := (SELECT id FROM engines WHERE code = 'S68B44');
SET @tx_at8st := 5;

-- ============================================================================
-- M5 F90 sedan 2018-2023 — family bmw-5-series-g30-2017-2024
-- ============================================================================
INSERT INTO generations (
  model_id, slug, ordinal, codename, family_slug, family_label, display_name, body_type,
  start_year, end_year, layout, platform, editorial_intro,
  length_mm, width_mm, height_mm, wheelbase_mm,
  fuel_tank_l, cargo_l, is_active
)
VALUES (
  @model_m5, 'm5-f90-sedan-2018-2023', 1, 'F90',
  'bmw-5-series-g30-2017-2024', 'BMW 5 Series G30 family (2017-2024)',
  'F90 M5', 'Sedan', 2018, 2023, 'AWD', 'BMW CLAR (M)',
'The F90 M5 is the sixth-generation BMW M5, launched mid-2017 for the 2018 model year and produced through 2023. Built on the G30 5 Series chassis but with extensive M-specific upgrades, the F90 was the first M5 ever fitted with all-wheel drive (M xDrive) — selectable as either AWD, AWD-Sport (rear-biased), or pure RWD via the iDrive M settings.\n\nPower comes from the S63B44T4 — a 4.4-litre twin-turbo V8 rated 600 hp standard, 625 hp Competition (2018+), and 635 hp in the limited-run M5 CS (2021-2022, only 1100 units worldwide). 0-100 km/h is 3.4 s standard, 3.0 s for the CS. Top speed limited to 250 km/h (305 km/h with M Driver''s Package). Cargo 530 L (same as G30 sedan). OEM oil: BMW Longlife-01 5W-30 (high HTHS spec), capacity 8.5 L. Coolant: BMW G48 HOAT throughout the production run.',
  4983, 1903, 1473, 2982,
  68, 530, 1
);

SET @gen_f90 := (SELECT id FROM generations WHERE slug = 'm5-f90-sedan-2018-2023');

INSERT INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_f90, 'm5-600-hp-xdrive-steptronic',                'M5 (600 Hp) xDrive Steptronic',                @e_s63, @tx_at8st, 600, 3.4, 250, 'AWD', 2018, 2023),
  (@gen_f90, 'm5-625-hp-competition-xdrive-steptronic',   'M5 Competition (625 Hp) xDrive Steptronic',     @e_s63, @tx_at8st, 625, 3.3, 250, 'AWD', 2018, 2023),
  (@gen_f90, 'm5-635-hp-cs-xdrive-steptronic',            'M5 CS (635 Hp) xDrive Steptronic',              @e_s63, @tx_at8st, 635, 3.0, 305, 'AWD', 2021, 2022);

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, notes) VALUES
  (@gen_f90, 'engine_oil', @e_s63, 8.50, 9.00, '5W-30', 'BMW Longlife-01', 10000, 16000, 'S63B44 V8 twin-turbo. LL-01 (high HTHS) required — NOT LL-04 or LL-12 FE. M5 CS gets shortened OCI from BMW (8000 mi). Independent specialists recommend 5000 mi on track-day cars.');
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, notes) VALUES
  (@gen_f90, 'coolant', @e_s63, 14.5, 15.3, NULL, 'BMW G48', NULL, NULL, 'V8 + intercooler circuits combine for ~14.5 L. Drain-and-refill typically recovers ~8 L. BMW G48 HOAT throughout F90 production.');

-- ============================================================================
-- M5 G90 sedan 2024-present — family bmw-5-series-g60-2023-present
-- ============================================================================
INSERT INTO generations (
  model_id, slug, ordinal, codename, family_slug, family_label, display_name, body_type,
  start_year, end_year, layout, platform, editorial_intro,
  length_mm, width_mm, height_mm, wheelbase_mm,
  fuel_tank_l, cargo_l, is_active
)
VALUES (
  @model_m5, 'm5-g90-sedan-2024-present', 2, 'G90',
  'bmw-5-series-g60-2023-present', 'BMW 5 Series G60 family (2023-present)',
  'G90 M5', 'Sedan', 2024, NULL, 'AWD', 'BMW CLAR-2 (M)',
'The G90 M5 is the seventh-generation BMW M5, launched mid-2024 for the 2025 model year, and the first M5 to be sold as a plug-in hybrid. The S68B44 V8 twin-turbo (585 hp) pairs with an integrated electric motor (197 hp) for **717 hp combined** and 1000 Nm of torque — the most powerful production M5 ever. A 22.1 kWh (gross) / 18.6 kWh (usable) high-voltage battery sits between the rear seats and provides about 60 km (37 mi) of pure-electric WLTP range.\n\nWeight is up substantially vs F90 (~2435 kg vs ~1970 kg) — BMW M''s solution is a wider track, more aggressive aero, M-specific carbon-ceramic brakes (optional), and active anti-roll bars from the latest CLAR-2 platform. 0-100 km/h: 3.5 seconds; top speed 250 km/h (305 with M Driver''s Package). Body type is sedan; the G99 M5 Touring is a separate ownerspecs gen. OEM oil: BMW Longlife-22 FE++ 0W-30 (the new generation low-friction spec used across the entire G60 family). Coolant: BMW LC-18 in all three circuits — engine, electric motor + power electronics, HV battery.',
  5096, 1970, 1518, 2995,
  68, 466, 1
);

SET @gen_g90 := (SELECT id FROM generations WHERE slug = 'm5-g90-sedan-2024-present');

INSERT INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_g90, 'm5-717-hp-plug-in-hybrid-xdrive-steptronic', 'M5 (717 Hp) Plug-in Hybrid xDrive Steptronic', @e_s68, @tx_at8st, 717, 3.5, 305, 'AWD', 2024, NULL);

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, notes) VALUES
  (@gen_g90, 'engine_oil', @e_s68, 9.00, 9.50, '0W-30', 'BMW Longlife-22 FE++', 10000, 16000, 'S68 V8 hybrid ICE side. LL-22 FE++ low-friction spec — the same grade used across the G60 family.');
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, notes) VALUES
  (@gen_g90, 'coolant', @e_s68, 18.0, 19.0, NULL, 'BMW LC-18', NULL, NULL, 'Three coupled coolant circuits: engine + intercoolers, electric motor + power electronics, HV battery thermal management. Combined volume ~18 L (50:50 dilution with water). BMW LC-18 specification throughout.');

-- ============================================================================
-- M5 G99 Touring 2024-present — family bmw-5-series-g60-2023-present
-- ============================================================================
INSERT INTO generations (
  model_id, slug, ordinal, codename, family_slug, family_label, display_name, body_type,
  start_year, end_year, layout, platform, editorial_intro,
  length_mm, width_mm, height_mm, wheelbase_mm,
  fuel_tank_l, cargo_l, is_active
)
VALUES (
  @model_m5, 'm5-g99-touring-2024-present', 3, 'G99',
  'bmw-5-series-g60-2023-present', 'BMW 5 Series G60 family (2023-present)',
  'G99 M5 Touring', 'Estate', 2024, NULL, 'AWD', 'BMW CLAR-2 (M)',
'The G99 is the first M5 Touring (wagon) since the limited-run E61 M5 Touring of 2007-2010 — and the first ever M5 Touring sold globally including North America. Launched mid-2024 alongside the G90 M5 sedan, the G99 shares the same S68 V8 + electric hybrid drivetrain (717 hp / 1000 Nm) but in the G61-bodied wagon shell with the same self-levelling rear air suspension. Cargo 500 L upright (1630 L folded).\n\nWeight is slightly up from the sedan (~2475 kg) but performance hardly suffers — 0-100 km/h takes 3.6 seconds (0.1 s slower). Top speed 250 km/h limited, 305 km/h with M Driver''s Package. OEM oil + coolant + drivetrain match the G90 sedan: BMW Longlife-22 FE++ engine oil (9 L), BMW LC-18 coolant (~18 L combined three circuits), ZF M Steptronic 8-speed automatic.',
  5096, 1970, 1518, 2995,
  68, 500, 1
);

SET @gen_g99 := (SELECT id FROM generations WHERE slug = 'm5-g99-touring-2024-present');

INSERT INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_g99, 'm5-touring-717-hp-plug-in-hybrid-xdrive-steptronic', 'M5 Touring (717 Hp) Plug-in Hybrid xDrive Steptronic', @e_s68, @tx_at8st, 717, 3.6, 305, 'AWD', 2024, NULL);

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, notes) VALUES
  (@gen_g99, 'engine_oil', @e_s68, 9.00, 9.50, '0W-30', 'BMW Longlife-22 FE++', 10000, 16000, 'S68 same as G90 sedan.');
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, notes) VALUES
  (@gen_g99, 'coolant', @e_s68, 18.0, 19.0, NULL, 'BMW LC-18', NULL, NULL, 'Three coupled circuits same as G90 sedan.');

-- ============================================================================
-- Sources + citations
-- ============================================================================
INSERT IGNORE INTO sources (citation, url, retrieved_at, notes) VALUES
  ('Auto-Data.net — BMW M5 (F90)', 'https://www.auto-data.net/en/bmw-m5-f90-generation-5634', NOW(), 'F90 M5 + Competition + CS, 2018-2023.'),
  ('Auto-Data.net — BMW M5 (G90)', 'https://www.auto-data.net/en/bmw-m5-g90-generation-10141', NOW(), 'G90 M5 sedan 2024+ S68 V8 hybrid 717 hp.'),
  ('Auto-Data.net — BMW M5 Touring (G99)', 'https://www.auto-data.net/en/bmw-m5-touring-g99-generation-10142', NOW(), 'G99 M5 Touring 2024+ same S68 hybrid drivetrain in wagon body.');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', t.id, s.id FROM trims t, sources s
  WHERE t.generation_id = @gen_f90 AND s.url = 'https://www.auto-data.net/en/bmw-m5-f90-generation-5634';
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, s.id FROM fluid_specs f, sources s
  WHERE f.generation_id = @gen_f90 AND s.url = 'https://www.auto-data.net/en/bmw-m5-f90-generation-5634';

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', t.id, s.id FROM trims t, sources s
  WHERE t.generation_id = @gen_g90 AND s.url = 'https://www.auto-data.net/en/bmw-m5-g90-generation-10141';
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, s.id FROM fluid_specs f, sources s
  WHERE f.generation_id = @gen_g90 AND s.url = 'https://www.auto-data.net/en/bmw-m5-g90-generation-10141';

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', t.id, s.id FROM trims t, sources s
  WHERE t.generation_id = @gen_g99 AND s.url = 'https://www.auto-data.net/en/bmw-m5-touring-g99-generation-10142';
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, s.id FROM fluid_specs f, sources s
  WHERE f.generation_id = @gen_g99 AND s.url = 'https://www.auto-data.net/en/bmw-m5-touring-g99-generation-10142';
