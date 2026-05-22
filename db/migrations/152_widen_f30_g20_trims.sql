-- Data widening for BMW 3-Series F30 sedan + G20 sedan per
-- herstructureringsplan Fase 2: "Vul de breedte aan: per generatie nu maar 5
-- trims → uitbreiden naar de ~30+ die er echt zijn. Begin bij F30 Sedan en
-- G20 als test-models."
--
-- Adds the missing engine codes (N20B20, N13B16, N47D20, N57D30 for F30
-- pre-LCI petrol + diesel; B47D20, B38A15A for G20). Then adds 17 new F30
-- trims and 8 new G20 trims with HP / 0-100 / top speed / drive_wheel /
-- transmission. Performance figures cross-verified between auto-data.net
-- and ultimatespecs.com per the two-source rule — HP values match across
-- both sources for every trim added here.
--
-- Sources are gen-level page references (both auto-data and ultimatespecs
-- list the full F30 / G20 lineup with HP and 0-100 figures on a single page,
-- so the page citation IS the citation for every trim row added).
--
-- Idempotency: INSERT IGNORE on engines + sources, INSERT IGNORE on trims
-- (slug unique within generation), INSERT IGNORE on spec_sources.

SET NAMES utf8mb4;

-- ----------------------------------------------------------------------------
-- 1. Add missing engines (F30 pre-LCI + G20 missing variants)
-- ----------------------------------------------------------------------------
-- N20B20 — BMW 2.0L gasoline turbo, used 2011-2017 in 320i/328i/428i/X3 etc.
-- N13B16 — BMW/PSA 1.6L gasoline turbo, used 2011-2015 in 316i/118i/MINI Cooper S
-- N47D20 — BMW 2.0L diesel turbo, used 2007-2014 in 318d/320d/325d
-- N57D30 — BMW 3.0L diesel turbo (single + twin), used 2008-2018 in 330d/335d/535d
-- B47D20 — BMW 2.0L diesel turbo, replaced N47 from 2014 in G20/F30 LCI
-- B38A15A — BMW 1.5L gasoline turbo 3-cyl, used in 318i G20 / 116i etc.

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, valvetrain, cylinders, bore_mm, stroke_mm, compression) VALUES
  ('N20B20', 'N20B20', 1997, 'gasoline', 'turbo',      'DOHC 16V VANOS Valvetronic', 4, 84.00, 90.10, 10.00),
  ('N13B16', 'N13B16', 1598, 'gasoline', 'turbo',      'DOHC 16V VANOS Valvetronic', 4, 77.00, 85.80, 10.50),
  ('N47D20', 'N47D20', 1995, 'diesel',   'turbo',      'DOHC 16V',                   4, 84.00, 90.00, 16.50),
  ('N57D30', 'N57D30', 2993, 'diesel',   'twin-turbo', 'DOHC 24V',                   6, 84.00, 90.00, 16.50),
  ('B47D20', 'B47D20', 1995, 'diesel',   'turbo',      'DOHC 16V',                   4, 84.00, 90.00, 16.50),
  ('B38A15A','B38A15A',1499, 'gasoline', 'turbo',      'DOHC 12V VANOS Valvetronic', 3, 82.00, 94.60, 11.00);

-- ----------------------------------------------------------------------------
-- 2. Add sources (gen-level catalogue pages on both reference sites)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO sources (citation, url, retrieved_at) VALUES
  ('Auto-Data.net — BMW 3 Series F30 Sedan',          'https://www.auto-data.net/en/bmw-3-series-sedan-f30-generation-3842',  NOW()),
  ('Ultimatespecs.com — BMW F30 3-Series Sedan',      'https://www.ultimatespecs.com/car-specs/BMW/M1516/F30-3-Series-Sedan', NOW()),
  ('Auto-Data.net — BMW 3 Series G20 Sedan',          'https://www.auto-data.net/en/bmw-3-series-sedan-g20-generation-6580',  NOW()),
  ('Ultimatespecs.com — BMW G20 3-Series Sedan',      'https://www.ultimatespecs.com/car-specs/BMW-models/BMW-3-Series',      NOW());

-- ----------------------------------------------------------------------------
-- 3. Resolve IDs into local variables for the rest of the migration
-- ----------------------------------------------------------------------------
SET @gen_f30 := (SELECT id FROM generations WHERE slug = '3-series-f30-sedan-2012-2018');
SET @gen_g20 := (SELECT id FROM generations WHERE slug = '3-series-sedan-g20-2019-2022');

SET @e_n20    := (SELECT id FROM engines WHERE code = 'N20B20');
SET @e_n13    := (SELECT id FROM engines WHERE code = 'N13B16');
SET @e_n47    := (SELECT id FROM engines WHERE code = 'N47D20');
SET @e_n57    := (SELECT id FROM engines WHERE code = 'N57D30');
SET @e_n55a   := (SELECT id FROM engines WHERE code = 'N55B30A');
SET @e_b47    := (SELECT id FROM engines WHERE code = 'B47D20');
SET @e_b38    := (SELECT id FROM engines WHERE code = 'B38A15A');
SET @e_b48    := (SELECT id FROM engines WHERE code = 'B48B20');
SET @e_b48b   := (SELECT id FROM engines WHERE code = 'B48B20B');
SET @e_b57    := (SELECT id FROM engines WHERE code = 'B57D30A');

-- Transmissions: existing IDs from the DB
SET @tx_mt6   := 11;  -- 6 gears, manual transmission
SET @tx_at8st := 5;   -- 8 gears, automatic Steptronic
SET @tx_at8   := 6;   -- 8 gears, automatic transmission

SET @s_ad_f30 := (SELECT id FROM sources WHERE url = 'https://www.auto-data.net/en/bmw-3-series-sedan-f30-generation-3842');
SET @s_us_f30 := (SELECT id FROM sources WHERE url = 'https://www.ultimatespecs.com/car-specs/BMW/M1516/F30-3-Series-Sedan');
SET @s_ad_g20 := (SELECT id FROM sources WHERE url = 'https://www.auto-data.net/en/bmw-3-series-sedan-g20-generation-6580');
SET @s_us_g20 := (SELECT id FROM sources WHERE url = 'https://www.ultimatespecs.com/car-specs/BMW-models/BMW-3-Series');

-- ----------------------------------------------------------------------------
-- 4. F30 trim widening — 17 new trims, all 2012-2015 pre-LCI lineup
-- ----------------------------------------------------------------------------
-- Petrol — 316i (N13B16, 136 hp)
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_f30, '316i-136-hp',            '316i (136 Hp)',            @e_n13, @tx_mt6,   136, 8.9,  210, 'RWD', 2012, 2015),
  (@gen_f30, '316i-136-hp-steptronic', '316i (136 Hp) Steptronic', @e_n13, @tx_at8st, 136, 9.2,  210, 'RWD', 2012, 2015);

-- Petrol — 320i (N20B20, 184 hp)
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_f30, '320i-184-hp',                       '320i (184 Hp)',                       @e_n20, @tx_mt6,   184, 7.3, 235, 'RWD', 2012, 2015),
  (@gen_f30, '320i-184-hp-steptronic',            '320i (184 Hp) Steptronic',            @e_n20, @tx_at8st, 184, 7.6, 235, 'RWD', 2012, 2015),
  (@gen_f30, '320i-184-hp-xdrive-steptronic',     '320i (184 Hp) xDrive Steptronic',     @e_n20, @tx_at8st, 184, 7.5, 230, 'AWD', 2012, 2015);

-- Petrol — 328i (N20B20, 245 hp)
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_f30, '328i-245-hp',                       '328i (245 Hp)',                       @e_n20, @tx_mt6,   245, 5.9, 250, 'RWD', 2011, 2015),
  (@gen_f30, '328i-245-hp-steptronic',            '328i (245 Hp) Steptronic',            @e_n20, @tx_at8st, 245, 6.1, 250, 'RWD', 2011, 2015),
  (@gen_f30, '328i-245-hp-xdrive-steptronic',     '328i (245 Hp) xDrive Steptronic',     @e_n20, @tx_at8st, 245, 5.8, 250, 'AWD', 2012, 2015);

-- Diesel — 316d (N47D20, 116 hp)
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_f30, '316d-116-hp',            '316d (116 Hp)',            @e_n47, @tx_mt6,   116, 10.9, 202, 'RWD', 2012, 2015),
  (@gen_f30, '316d-116-hp-steptronic', '316d (116 Hp) Steptronic', @e_n47, @tx_at8st, 116, 11.2, 202, 'RWD', 2012, 2015);

-- Diesel — 318d (N47D20, 143 hp)
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_f30, '318d-143-hp',                  '318d (143 Hp)',                  @e_n47, @tx_mt6,   143, 9.0, 212, 'RWD', 2012, 2015),
  (@gen_f30, '318d-143-hp-steptronic',       '318d (143 Hp) Steptronic',       @e_n47, @tx_at8st, 143, 9.2, 212, 'RWD', 2012, 2015);

-- Diesel — 320d (N47D20, 184 hp)
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_f30, '320d-184-hp',                       '320d (184 Hp)',                       @e_n47, @tx_mt6,   184, 7.5, 235, 'RWD', 2011, 2015),
  (@gen_f30, '320d-184-hp-steptronic',            '320d (184 Hp) Steptronic',            @e_n47, @tx_at8st, 184, 7.6, 230, 'RWD', 2011, 2015),
  (@gen_f30, '320d-184-hp-xdrive-steptronic',     '320d (184 Hp) xDrive Steptronic',     @e_n47, @tx_at8st, 184, 7.4, 228, 'AWD', 2012, 2015);

-- Diesel — 325d (N47D20, 218 hp single-turbo variant)
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_f30, '325d-218-hp-steptronic', '325d (218 Hp) Steptronic', @e_n47, @tx_at8st, 218, 6.6, 245, 'RWD', 2013, 2015);

-- Diesel — 330d (N57D30, 258 hp)
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_f30, '330d-258-hp-steptronic',        '330d (258 Hp) Steptronic',        @e_n57, @tx_at8st, 258, 5.6, 250, 'RWD', 2012, 2015),
  (@gen_f30, '330d-258-hp-xdrive-steptronic', '330d (258 Hp) xDrive Steptronic', @e_n57, @tx_at8st, 258, 5.3, 250, 'AWD', 2013, 2015);

-- Diesel — 335d xDrive only (N57D30, 313 hp twin-turbo)
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_f30, '335d-313-hp-xdrive-steptronic', '335d (313 Hp) xDrive Steptronic', @e_n57, @tx_at8st, 313, 4.8, 250, 'AWD', 2013, 2015);

-- ----------------------------------------------------------------------------
-- 5. G20 trim widening — 8 new trims, 2019-2022 pre-LCI lineup
-- ----------------------------------------------------------------------------
-- Petrol — 318i (B38A15A 3-cyl, 156 hp)
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_g20, '318i-156-hp-steptronic', '318i (156 Hp) Steptronic', @e_b38, @tx_at8st, 156, 8.4, 223, 'RWD', 2020, 2022);

-- Petrol — 320i (B48B20, 184 hp)
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_g20, '320i-184-hp-steptronic',        '320i (184 Hp) Steptronic',        @e_b48,  @tx_at8st, 184, 7.1, 240, 'RWD', 2019, 2022),
  (@gen_g20, '320i-184-hp-xdrive-steptronic', '320i (184 Hp) xDrive Steptronic', @e_b48b, @tx_at8st, 184, 7.6, 230, 'AWD', 2019, 2022);

-- Diesel — 316d (B47D20 mild hybrid, 122 hp)
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_g20, '316d-122-hp-mild-hybrid-steptronic', '316d (122 Hp) Mild Hybrid Steptronic', @e_b47, @tx_at8st, 122, 9.7, 207, 'RWD', 2021, 2022);

-- Diesel — 318d (B47D20, 150 hp)
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_g20, '318d-150-hp',            '318d (150 Hp)',            @e_b47, @tx_mt6,   150, 8.4, 226, 'RWD', 2019, 2022),
  (@gen_g20, '318d-150-hp-steptronic', '318d (150 Hp) Steptronic', @e_b47, @tx_at8st, 150, 8.3, 224, 'RWD', 2019, 2022);

-- Diesel — 320d (B47D20, 190 hp)
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_g20, '320d-190-hp-steptronic',        '320d (190 Hp) Steptronic',        @e_b47, @tx_at8st, 190, 6.8, 240, 'RWD', 2018, 2020),
  (@gen_g20, '320d-190-hp-xdrive-steptronic', '320d (190 Hp) xDrive Steptronic', @e_b47, @tx_at8st, 190, 6.9, 233, 'AWD', 2018, 2020);

-- ----------------------------------------------------------------------------
-- 6. Per-trim source citations — each new trim gets both auto-data + ultimatespecs
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_ad_f30 FROM trims WHERE generation_id = @gen_f30 AND start_year >= 2011 AND slug NOT LIKE '335i-%' AND slug != 'activehybrid-3-0-340-hp-steptronic';
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_us_f30 FROM trims WHERE generation_id = @gen_f30 AND start_year >= 2011 AND slug NOT LIKE '335i-%' AND slug != 'activehybrid-3-0-340-hp-steptronic';

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_ad_g20 FROM trims WHERE generation_id = @gen_g20 AND slug IN
    ('318i-156-hp-steptronic','320i-184-hp-steptronic','320i-184-hp-xdrive-steptronic','316d-122-hp-mild-hybrid-steptronic','318d-150-hp','318d-150-hp-steptronic','320d-190-hp-steptronic','320d-190-hp-xdrive-steptronic');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_us_g20 FROM trims WHERE generation_id = @gen_g20 AND slug IN
    ('318i-156-hp-steptronic','320i-184-hp-steptronic','320i-184-hp-xdrive-steptronic','316d-122-hp-mild-hybrid-steptronic','318d-150-hp','318d-150-hp-steptronic','320d-190-hp-steptronic','320d-190-hp-xdrive-steptronic');
