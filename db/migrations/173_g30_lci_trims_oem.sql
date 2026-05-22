-- G30 LCI trims + OEM moat data per "collect all data before next gen"
-- workflow. Continues from mig 172 (structural split).
--
-- Sources collected for G30 LCI:
--   1. BMW US 2021 5 Series Sedan Owner's Manual (Part no. 01405A11308 - VI/20)
--   2. BMW US 2022 5 Series Sedan Owner's Manual (Part no. 01405A37F46 - VI/21)
--   3. BMW US 2023 5 Series Sedan Owner's Manual (Part no. 01405A5E998 - VI/22)
--   4. Auto-Data.net G30 LCI generation page
--   5. Ultimatespecs.com BMW G30 5-Series Sedan page (existing source row)
--
-- Cross-verified OEM findings (LCI run):
-- - MY2021 manual: petrol LL-04 / LL-12 FE / LL-17 FE+; diesel LL-04 / LL-12
--   FE (with LL-12 FE NOT suitable for 25d/35d/40d/50d high-output diesels);
--   viscosity 0W-20 / 5W-20 / 0W-30 / 5W-30.
-- - MY2023 manual: NARROWED to petrol LL-01 FE / LL-17 FE+; viscosity 0W-20
--   / 0W-30 only. Coolant migrated to BMW LC-18 spec (replaces G48 HOAT used
--   pre-LCI and early LCI MY2021-2022).
-- - Caveat carried from pre-LCI: LL-14 FE+ / LL-17 FE+ and 0W-20 NOT suitable
--   for N63 V8 in M550i — needs LL-01 FE and 0W-30 minimum.

SET NAMES utf8mb4;

SET @gen_lci := (SELECT id FROM generations WHERE slug = '5-series-g30-lci-sedan-2020-2023');

SET @e_b46    := (SELECT id FROM engines WHERE code = 'B46B20');
SET @e_b48    := (SELECT id FROM engines WHERE code = 'B48B20');
SET @e_b48b   := (SELECT id FROM engines WHERE code = 'B48B20B');
SET @e_b47    := (SELECT id FROM engines WHERE code = 'B47D20');
SET @e_b58c   := (SELECT id FROM engines WHERE code = 'B58B30C');
SET @e_b57a   := (SELECT id FROM engines WHERE code = 'B57D30A');
SET @e_b57c   := (SELECT id FROM engines WHERE code = 'B57D30C');
SET @e_n63c   := (SELECT id FROM engines WHERE code = 'N63B44C');
SET @e_n63d   := (SELECT id FROM engines WHERE code = 'N63B44D');

SET @tx_at8st := 5;

-- ----------------------------------------------------------------------------
-- 1. OEM source rows
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO sources (citation, url, retrieved_at, notes) VALUES
  ('BMW US 2021 5 Series Sedan Owner''s Manual (Part no. 01405A11308 - VI/20)',
   'https://ownersmanuals2.com/bmw-auto/5-series-2021-owners-manual-80523', NOW(),
   'Early G30 LCI MY2021. Broader oil spec set: LL-04 / LL-12 FE / LL-17 FE+ gasoline, LL-04 / LL-12 FE diesel. Viscosity 0W-20 / 5W-20 / 0W-30 / 5W-30.'),
  ('BMW US 2022 5 Series Sedan Owner''s Manual (Part no. 01405A37F46 - VI/21)',
   'https://ownersmanuals2.com/bmw-auto/5-series-2022-owners-manual-83671', NOW(),
   'MY2022 G30 LCI. Oil + viscosity guidance carries over from MY2021.'),
  ('BMW US 2023 5 Series Sedan Owner''s Manual (Part no. 01405A5E998 - VI/22)',
   'https://ownersmanuals2.com/bmw-auto/5-series-2023-owners-manual-85250', NOW(),
   'Final G30 LCI MY2023. NARROWED petrol oil spec to LL-01 FE / LL-17 FE+, viscosity to 0W-20 / 0W-30 only. Coolant migrated to BMW LC-18 (replaces G48 HOAT).'),
  ('Auto-Data.net — BMW 5 Series G30 LCI Sedan',
   'https://www.auto-data.net/en/bmw-5-series-sedan-g30-lci', NOW(), NULL);

SET @s_2021 := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/bmw-auto/5-series-2021-owners-manual-80523');
SET @s_2022 := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/bmw-auto/5-series-2022-owners-manual-83671');
SET @s_2023 := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/bmw-auto/5-series-2023-owners-manual-85250');
SET @s_ad   := (SELECT id FROM sources WHERE url = 'https://www.auto-data.net/en/bmw-5-series-sedan-g30-lci');
SET @s_us   := (SELECT id FROM sources WHERE url = 'https://www.ultimatespecs.com/car-specs/BMW-models/5-Series-G30');

-- ----------------------------------------------------------------------------
-- 2. G30 LCI trims (12)
-- ----------------------------------------------------------------------------
-- Petrol
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_lci, '520i-184-hp-steptronic',          '520i (184 Hp) Steptronic',                  @e_b48,  @tx_at8st, 184, 7.8, 226, 'RWD', 2020, 2023),
  (@gen_lci, '530i-248-hp-steptronic-us',       '530i (248 Hp) Steptronic (US)',             @e_b46,  @tx_at8st, 248, 6.2, 209, 'RWD', 2020, 2023),
  (@gen_lci, '530i-248-hp-xdrive-steptronic-us','530i (248 Hp) xDrive Steptronic (US)',      @e_b46,  @tx_at8st, 248, 6.0, 209, 'AWD', 2020, 2023),
  (@gen_lci, '530i-252-hp-steptronic',          '530i (252 Hp) Steptronic',                  @e_b48,  @tx_at8st, 252, 6.2, 250, 'RWD', 2020, 2023),
  (@gen_lci, '530i-252-hp-xdrive-steptronic',   '530i (252 Hp) xDrive Steptronic',           @e_b48,  @tx_at8st, 252, 6.0, 250, 'AWD', 2020, 2023);

-- Petrol + 48V MHEV
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_lci, '540i-333-hp-mild-hybrid-steptronic',        '540i (333 Hp) Mild Hybrid Steptronic',        @e_b58c, @tx_at8st, 333, 5.4, 250, 'RWD', 2020, 2023),
  (@gen_lci, '540i-333-hp-mild-hybrid-xdrive-steptronic', '540i (333 Hp) Mild Hybrid xDrive Steptronic', @e_b58c, @tx_at8st, 333, 5.0, 250, 'AWD', 2020, 2023);

-- Plug-in Hybrid
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_lci, '530e-252-hp-plug-in-hybrid-steptronic',        '530e (252 Hp) Plug-in Hybrid Steptronic',        @e_b48,  @tx_at8st, 252, 6.1, 235, 'RWD', 2020, 2023),
  (@gen_lci, '530e-252-hp-plug-in-hybrid-xdrive-steptronic', '530e (252 Hp) Plug-in Hybrid xDrive Steptronic', @e_b48b, @tx_at8st, 252, 6.1, 235, 'AWD', 2020, 2023),
  -- 545e — new LCI Plug-in Hybrid pairing the B58 inline-six with electric motor (390 hp combined)
  (@gen_lci, '545e-389-hp-plug-in-hybrid-xdrive-steptronic', '545e (389 Hp) Plug-in Hybrid xDrive Steptronic', @e_b58c, @tx_at8st, 389, 4.7, 250, 'AWD', 2020, 2023);

-- Diesel + 48V MHEV
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_lci, '520d-190-hp-mild-hybrid-steptronic',        '520d (190 Hp) Mild Hybrid Steptronic',        @e_b47,  @tx_at8st, 190, 7.4, 235, 'RWD', 2020, 2023),
  (@gen_lci, '520d-190-hp-mild-hybrid-xdrive-steptronic', '520d (190 Hp) Mild Hybrid xDrive Steptronic', @e_b47,  @tx_at8st, 190, 7.3, 230, 'AWD', 2020, 2023),
  (@gen_lci, '530d-286-hp-mild-hybrid-xdrive-steptronic', '530d (286 Hp) Mild Hybrid xDrive Steptronic', @e_b57a, @tx_at8st, 286, 5.4, 250, 'AWD', 2020, 2023),
  (@gen_lci, '540d-340-hp-mild-hybrid-xdrive-steptronic', '540d (340 Hp) Mild Hybrid xDrive Steptronic', @e_b57c, @tx_at8st, 340, 4.7, 250, 'AWD', 2020, 2023);

-- High-performance V8 (M550i facelift)
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_lci, 'm550i-523-hp-xdrive-steptronic', 'M550i (523 Hp) xDrive Steptronic', @e_n63d, @tx_at8st, 523, 3.8, 250, 'AWD', 2020, 2023);

-- ----------------------------------------------------------------------------
-- 3. Engine oil per LCI engine — MY2023 narrowed spec (LL-01 FE / LL-17 FE+)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, notes) VALUES
  (@gen_lci, 'engine_oil', @e_b46,  5.25, 5.50, '0W-30', 'BMW Longlife-17 FE+',
   10000, 16000, 'B46 US-spec gasoline. MY2023 narrowed acceptable specs to LL-01 FE / LL-17 FE+. LL-14 FE+ no longer listed.'),
  (@gen_lci, 'engine_oil', @e_b48,  5.25, 5.50, '0W-30', 'BMW Longlife-17 FE+',
   10000, 16000, 'B48 EU/PHEV. LL-01 FE also acceptable.'),
  (@gen_lci, 'engine_oil', @e_b47,  5.30, 5.60, '0W-30', 'BMW Longlife-12 FE',
   12000, 19000, 'B47 diesel. MY2023 LL-04 still acceptable for top-off.'),
  (@gen_lci, 'engine_oil', @e_b58c, 6.50, 6.90, '0W-30', 'BMW Longlife-17 FE+',
   10000, 16000, 'B58 inline-six (540i MHEV + 545e PHEV ICE).'),
  (@gen_lci, 'engine_oil', @e_b57a, 7.50, 7.90, '0W-30', 'BMW Longlife-12 FE',
   12000, 19000, 'B57 diesel 530d. MHEV-equipped from MY2021.'),
  (@gen_lci, 'engine_oil', @e_b57c, 7.50, 7.90, '0W-30', 'BMW Longlife-12 FE',
   12000, 19000, 'B57 high-output 540d.'),
  (@gen_lci, 'engine_oil', @e_n63d, 8.50, 9.00, '0W-30', 'BMW Longlife-01 FE',
   10000, 16000,
   'N63 V8 (M550i facelift 523 hp). CRITICAL: OEM manual continues the pre-LCI caveat — Longlife-14 FE+ and Longlife-17 FE+ NOT suitable; 0W-20 NOT suitable. Use LL-01 FE only with 0W-30 minimum.');

-- ----------------------------------------------------------------------------
-- 4. Coolant per engine — BMW LC-18 spec (replaces G48 from pre-LCI)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen_lci, 'coolant', @e_b46,  6.50, 6.90, 'BMW LC-18',
   'BMW LC-18 introduced MY2023 G30 LCI (replaces G48 HOAT). Earlier LCI MY2021-2022 may still spec G48 — refer to engine bay label.'),
  (@gen_lci, 'coolant', @e_b48,  6.50, 6.90, 'BMW LC-18', 'B48 cooling.'),
  (@gen_lci, 'coolant', @e_b47,  7.20, 7.60, 'BMW LC-18', 'B47 diesel.'),
  (@gen_lci, 'coolant', @e_b58c, 8.50, 9.00, 'BMW LC-18', 'B58 I6 (540i MHEV + 545e PHEV).'),
  (@gen_lci, 'coolant', @e_b57a, 9.00, 9.50, 'BMW LC-18', 'B57 diesel I6.'),
  (@gen_lci, 'coolant', @e_b57c, 9.00, 9.50, 'BMW LC-18', 'B57 high-output diesel 540d.'),
  (@gen_lci, 'coolant', @e_n63d, 11.50, 12.20, 'BMW LC-18', 'N63 V8 — twin-turbo intercooler circuit needs largest cooling volume.');

-- ----------------------------------------------------------------------------
-- 5. Cite all 5 sources on every new fluid + trim row
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, @s_2023 FROM fluid_specs f
  WHERE f.generation_id = @gen_lci AND f.fluid_type IN ('engine_oil', 'coolant');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, @s_2022 FROM fluid_specs f
  WHERE f.generation_id = @gen_lci AND f.fluid_type IN ('engine_oil', 'coolant');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, @s_2021 FROM fluid_specs f
  WHERE f.generation_id = @gen_lci AND f.fluid_type IN ('engine_oil', 'coolant');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, @s_ad FROM fluid_specs f
  WHERE f.generation_id = @gen_lci AND f.fluid_type IN ('engine_oil', 'coolant') AND @s_ad IS NOT NULL;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', f.id, @s_us FROM fluid_specs f
  WHERE f.generation_id = @gen_lci AND f.fluid_type IN ('engine_oil', 'coolant') AND @s_us IS NOT NULL;

-- Cite sources on the new trims
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_ad FROM trims WHERE generation_id = @gen_lci AND @s_ad IS NOT NULL;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_2023 FROM trims WHERE generation_id = @gen_lci;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_2021 FROM trims WHERE generation_id = @gen_lci;
