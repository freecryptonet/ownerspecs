-- F30 LCI trims + G20 PHEV / mild-hybrid extras — second widening pass for
-- the BMW 3-Series gens per herstructureringsplan Fase 2.
--
-- Note: F30 LCI (2015-2018) and F30 pre-LCI (2012-2015) currently share the
-- same gen entry (`3-series-f30-sedan-2012-2018`). The plan calls for these
-- to be split eventually; until then LCI trims with name + HP identical to
-- pre-LCI variants are skipped (slug would conflict). LCI variants added
-- here are the ones with distinct nameplate or distinct HP from the pre-LCI
-- additions in migration 152: 318i (LCI-only), 330i (replaces 328i in LCI),
-- 340i (replaces 335i in LCI), 330e PHEV, 320d 190hp (vs pre-LCI 184hp),
-- 318d 150hp (vs pre-LCI 143hp), 325d 224hp (vs pre-LCI 218hp).
--
-- Two-source verification: HP figures cross-verified between auto-data.net
-- and ultimatespecs.com for every trim row added here.

SET NAMES utf8mb4;

-- ----------------------------------------------------------------------------
-- ID resolution
-- ----------------------------------------------------------------------------
SET @gen_f30 := (SELECT id FROM generations WHERE slug = '3-series-f30-sedan-2012-2018');
SET @gen_g20 := (SELECT id FROM generations WHERE slug = '3-series-sedan-g20-2019-2022');

SET @e_b38   := (SELECT id FROM engines WHERE code = 'B38A15A');
SET @e_b47   := (SELECT id FROM engines WHERE code = 'B47D20');
SET @e_n47   := (SELECT id FROM engines WHERE code = 'N47D20');
SET @e_b48   := (SELECT id FROM engines WHERE code = 'B48B20');
SET @e_b48b  := (SELECT id FROM engines WHERE code = 'B48B20B');
SET @e_b58a  := (SELECT id FROM engines WHERE code = 'B58B30A');
SET @e_b57   := (SELECT id FROM engines WHERE code = 'B57D30A');

SET @tx_mt6   := 11;
SET @tx_at8st := 5;

-- Sources for F30 LCI page
INSERT IGNORE INTO sources (citation, url, retrieved_at) VALUES
  ('Auto-Data.net — BMW 3 Series F30 LCI Sedan', 'https://www.auto-data.net/en/bmw-3-series-sedan-f30-lci-facelift-2015-generation-4512', NOW());
SET @s_ad_f30lci := (SELECT id FROM sources WHERE url = 'https://www.auto-data.net/en/bmw-3-series-sedan-f30-lci-facelift-2015-generation-4512');
SET @s_us_f30   := (SELECT id FROM sources WHERE url = 'https://www.ultimatespecs.com/car-specs/BMW/M1516/F30-3-Series-Sedan');
SET @s_ad_g20   := (SELECT id FROM sources WHERE url = 'https://www.auto-data.net/en/bmw-3-series-sedan-g20-generation-6580');
SET @s_us_g20   := (SELECT id FROM sources WHERE url = 'https://www.ultimatespecs.com/car-specs/BMW-models/BMW-3-Series');

-- ----------------------------------------------------------------------------
-- F30 LCI trims (14)
-- ----------------------------------------------------------------------------
-- 318i petrol (B38A15A, 136 hp) — LCI introduced
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_f30, '318i-136-hp',            '318i (136 Hp)',            @e_b38, @tx_mt6,   136, 8.9, 210, 'RWD', 2015, 2018),
  (@gen_f30, '318i-136-hp-steptronic', '318i (136 Hp) Steptronic', @e_b38, @tx_at8st, 136, 9.1, 210, 'RWD', 2015, 2018);

-- 330i petrol (B48B20, 252 hp) — replaces 328i in LCI
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_f30, '330i-252-hp',                       '330i (252 Hp)',                       @e_b48,  @tx_mt6,   252, 5.9, 250, 'RWD', 2015, 2018),
  (@gen_f30, '330i-252-hp-steptronic',            '330i (252 Hp) Steptronic',            @e_b48,  @tx_at8st, 252, 5.8, 250, 'RWD', 2015, 2018),
  (@gen_f30, '330i-252-hp-xdrive-steptronic',     '330i (252 Hp) xDrive Steptronic',     @e_b48b, @tx_at8st, 252, 5.8, 250, 'AWD', 2015, 2018);

-- 330e Plug-in Hybrid (B48B20 + electric, 252 hp combined)
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_f30, '330e-252-hp-plug-in-hybrid-steptronic', '330e (252 Hp) Plug-in Hybrid Steptronic', @e_b48, @tx_at8st, 252, 6.1, 225, 'RWD', 2016, 2018);

-- 340i petrol (B58B30A, 326 hp) — replaces 335i in LCI
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_f30, '340i-326-hp',                       '340i (326 Hp)',                       @e_b58a, @tx_mt6,   326, 5.2, 250, 'RWD', 2015, 2018),
  (@gen_f30, '340i-326-hp-steptronic',            '340i (326 Hp) Steptronic',            @e_b58a, @tx_at8st, 326, 5.1, 250, 'RWD', 2015, 2018),
  (@gen_f30, '340i-326-hp-xdrive-steptronic',     '340i (326 Hp) xDrive Steptronic',     @e_b58a, @tx_at8st, 326, 4.9, 250, 'AWD', 2015, 2018);

-- 320d diesel (B47D20, 190 hp) — LCI tune up from pre-LCI 184hp
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_f30, '320d-190-hp',                       '320d (190 Hp)',                       @e_b47, @tx_mt6,   190, 7.3, 235, 'RWD', 2015, 2018),
  (@gen_f30, '320d-190-hp-steptronic',            '320d (190 Hp) Steptronic',            @e_b47, @tx_at8st, 190, 7.2, 230, 'RWD', 2015, 2018),
  (@gen_f30, '320d-190-hp-xdrive-steptronic',     '320d (190 Hp) xDrive Steptronic',     @e_b47, @tx_at8st, 190, 7.3, 228, 'AWD', 2015, 2018);

-- 318d diesel (B47D20, 150 hp) — LCI tune up from pre-LCI 143hp
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_f30, '318d-150-hp-steptronic', '318d (150 Hp) Steptronic', @e_b47, @tx_at8st, 150, 8.4, 212, 'RWD', 2015, 2018);

-- 325d diesel (N47TU/B47, 224 hp) — LCI higher tune
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_f30, '325d-224-hp-steptronic', '325d (224 Hp) Steptronic', @e_b47, @tx_at8st, 224, 6.1, 245, 'RWD', 2016, 2018);

-- ----------------------------------------------------------------------------
-- G20 PHEV + mild hybrid + early-diesel additions (7)
-- ----------------------------------------------------------------------------
-- 320e Plug-in Hybrid (B48 + electric, 204 hp combined)
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_g20, '320e-204-hp-plug-in-hybrid-steptronic', '320e (204 Hp) Plug-in Hybrid Steptronic', @e_b48, @tx_at8st, 204, 7.6, 220, 'RWD', 2021, 2022);

-- 330e Plug-in Hybrid (B48 + electric, 292 hp combined)
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_g20, '330e-292-hp-plug-in-hybrid-steptronic',        '330e (292 Hp) Plug-in Hybrid Steptronic',        @e_b48,  @tx_at8st, 292, 5.9, 230, 'RWD', 2019, 2022),
  (@gen_g20, '330e-292-hp-plug-in-hybrid-xdrive-steptronic', '330e (292 Hp) Plug-in Hybrid xDrive Steptronic', @e_b48b, @tx_at8st, 292, 5.8, 230, 'AWD', 2020, 2022);

-- 330d Mild Hybrid (B57D30A, 286 hp) — from 2020 facelift mid-cycle
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_g20, '330d-286-hp-mild-hybrid-steptronic',        '330d (286 Hp) Mild Hybrid Steptronic',        @e_b57, @tx_at8st, 286, 5.3, 250, 'RWD', 2020, 2022),
  (@gen_g20, '330d-286-hp-mild-hybrid-xdrive-steptronic', '330d (286 Hp) Mild Hybrid xDrive Steptronic', @e_b57, @tx_at8st, 286, 5.0, 250, 'AWD', 2020, 2022);

-- 330d pre-mild-hybrid (B57D30A, 265 hp) — 2019-2020 launch tune
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, zero_100_kmh_s, top_speed_kmh, drive_wheel, start_year, end_year) VALUES
  (@gen_g20, '330d-265-hp-steptronic',        '330d (265 Hp) Steptronic',        @e_b57, @tx_at8st, 265, 5.5, 250, 'RWD', 2019, 2020),
  (@gen_g20, '330d-265-hp-xdrive-steptronic', '330d (265 Hp) xDrive Steptronic', @e_b57, @tx_at8st, 265, 5.1, 250, 'AWD', 2019, 2020);

-- ----------------------------------------------------------------------------
-- Source citations for the new trims (auto-data + ultimatespecs)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_ad_f30lci FROM trims
   WHERE generation_id = @gen_f30 AND start_year >= 2015
     AND slug IN (
       '318i-136-hp','318i-136-hp-steptronic',
       '330i-252-hp','330i-252-hp-steptronic','330i-252-hp-xdrive-steptronic',
       '330e-252-hp-plug-in-hybrid-steptronic',
       '340i-326-hp','340i-326-hp-steptronic','340i-326-hp-xdrive-steptronic',
       '320d-190-hp','320d-190-hp-steptronic','320d-190-hp-xdrive-steptronic',
       '318d-150-hp-steptronic','325d-224-hp-steptronic'
     );
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_us_f30 FROM trims
   WHERE generation_id = @gen_f30 AND start_year >= 2015
     AND slug IN (
       '318i-136-hp','318i-136-hp-steptronic',
       '330i-252-hp','330i-252-hp-steptronic','330i-252-hp-xdrive-steptronic',
       '330e-252-hp-plug-in-hybrid-steptronic',
       '340i-326-hp','340i-326-hp-steptronic','340i-326-hp-xdrive-steptronic',
       '320d-190-hp','320d-190-hp-steptronic','320d-190-hp-xdrive-steptronic',
       '318d-150-hp-steptronic','325d-224-hp-steptronic'
     );

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_ad_g20 FROM trims
   WHERE generation_id = @gen_g20 AND slug IN (
     '320e-204-hp-plug-in-hybrid-steptronic',
     '330e-292-hp-plug-in-hybrid-steptronic','330e-292-hp-plug-in-hybrid-xdrive-steptronic',
     '330d-286-hp-mild-hybrid-steptronic','330d-286-hp-mild-hybrid-xdrive-steptronic',
     '330d-265-hp-steptronic','330d-265-hp-xdrive-steptronic'
   );
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_us_g20 FROM trims
   WHERE generation_id = @gen_g20 AND slug IN (
     '320e-204-hp-plug-in-hybrid-steptronic',
     '330e-292-hp-plug-in-hybrid-steptronic','330e-292-hp-plug-in-hybrid-xdrive-steptronic',
     '330d-286-hp-mild-hybrid-steptronic','330d-286-hp-mild-hybrid-xdrive-steptronic',
     '330d-265-hp-steptronic','330d-265-hp-xdrive-steptronic'
   );
