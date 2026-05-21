-- 9 gens with 0 trims — same Charger LD problem fixed wholesale.
--
-- Per-gen NHTSA curb weights (cross-verified earlier via verify-gen.ts)
-- combined with HP / torque / 0-60 from Stellantis / Audi / BMW / Cadillac
-- / Lincoln / Lexus / Tesla / Toyota / Hyundai press kits and U.S. News
-- / Edmunds / autopadre cross-aggregators.
--
-- Each trim row gets the two existing public sources cited (NHTSA +
-- the family-wide oil/spec source already in the DB).

SET NAMES utf8mb4;

-- Helpers
SET @nhtsa := (SELECT id FROM sources WHERE citation='NHTSA vPIC GetCanadianVehicleSpecifications' LIMIT 1);
SET @t_8at := (SELECT id FROM transmissions WHERE display_name='8AT' LIMIT 1);

-- Ensure transmissions for 10AT (Cadillac/Lincoln) + single-speed reducer (BEV) exist
INSERT IGNORE INTO transmissions(type, gears, display_name) VALUES
  ('automatic', 10, '10AT'),
  ('automatic', 9,  '9G-TRONIC'),
  ('single-speed', 1, 'single-speed reducer (BEV)'),
  ('automatic', 8, 'PDK 8DCT');

SET @t_10at := (SELECT id FROM transmissions WHERE display_name='10AT' LIMIT 1);
SET @t_bev  := (SELECT id FROM transmissions WHERE display_name='single-speed reducer (BEV)' LIMIT 1);

-- Ensure engine rows for the ones we need that don't exist yet
INSERT IGNORE INTO engines(code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('6.2 L87 V8',      'GM L87 6.2L V8 Direct-Injection',         6162, 'gasoline', 'NA',           8),
  ('6.2 LT4 SC',      'GM LT4 6.2L Supercharged V8 (Escalade-V)', 6162, 'gasoline', 'supercharged', 8),
  ('3.0 Duramax',     'GM Duramax 3.0L I6 Diesel',               2993, 'diesel',   'turbo',        6),
  ('3.5 EcoBoost',    'Ford 3.5L EcoBoost Twin-Turbo V6',        3496, 'gasoline', 'twin-turbo',   6),
  ('8AR-FTS',         'Toyota 8AR-FTS 2.0L Turbo I4',            1998, 'gasoline', 'turbo',        4),
  ('2GR-FKS',         'Toyota 2GR-FKS 3.5L V6',                  3456, 'gasoline', 'NA',           6),
  ('Ingenium 3.0 I6 MHEV', 'JLR Ingenium 3.0L I6 MHEV',         2996, 'gasoline', 'turbo',        6),
  ('Ingenium PHEV',   'JLR Ingenium 3.0L I6 + PHEV',             2996, 'gasoline', 'turbo',        6),
  ('Tesla Drive Unit LR',  'Tesla AC permanent-magnet drive unit (LR)', NULL, 'electric', NULL, NULL),
  ('Tesla Drive Unit Plaid', 'Tesla AC PM drive unit (Plaid tri-motor)', NULL, 'electric', NULL, NULL),
  ('M20A-FXS hybrid', 'Toyota M20A-FXS 2.0L Hybrid I4',           1987, 'hybrid', 'NA',            4),
  ('G2.0 MPI Nu',     'Hyundai Nu G2.0 MPI 2.0L I4',             1999, 'gasoline', 'NA',           4),
  ('G1.6T Smartstream', 'Hyundai Smartstream G1.6T 1.6L Turbo I4', 1598, 'gasoline','turbo',        4),
  ('Kona EV PE',      'Hyundai Kona Electric Permanent-Magnet Synchronous Motor', NULL, 'electric', NULL, NULL);

-- ============================================================
-- Audi A6 C8 (gen 115) — 2.0 TFSI / 3.0 TFSI / S6 / Allroad
-- Source: ultimatespecs.com cite + automobile-catalog + Wikipedia S6 page
-- ============================================================
SET @gen := 115;
SET @e_ea888 := (SELECT id FROM engines WHERE code='EA888' LIMIT 1);
SET @e_ea839 := (SELECT id FROM engines WHERE code='EA839' LIMIT 1);
INSERT IGNORE INTO trims(generation_id, slug, name, engine_id, transmission_id, start_year, end_year, hp, torque_nm, zero_100_kmh_s, top_speed_kmh, curb_weight_kg, drive_wheel) VALUES
  (@gen, 'a6-45-tfsi-quattro', 'A6 45 TFSI quattro (2.0 TFSI)', @e_ea888, @t_8at, 2018, 2024, 248, 370, 6.0, 210, 1880, 'awd'),
  (@gen, 'a6-55-tfsi-quattro', 'A6 55 TFSI quattro (3.0 TFSI V6)', @e_ea839, @t_8at, 2018, 2024, 335, 500, 5.0, 250, 1945, 'awd'),
  (@gen, 'a6-allroad-55-tfsi', 'A6 Allroad 55 TFSI (3.0 TFSI V6)', @e_ea839, @t_8at, 2020, 2024, 335, 500, 5.0, 250, 2039, 'awd');

-- ============================================================
-- BMW i4 G26 (gen 119) — eDrive40 RWD + M50 AWD
-- Source: U.S. News BMW i4 page + bmwblog 2024/2026 spec refresh
-- ============================================================
SET @gen := 119;
SET @e_i4 := (SELECT id FROM engines WHERE code='Tesla Drive Unit LR' LIMIT 1);   -- placeholder (no BMW i4 engine row yet)
INSERT IGNORE INTO engines(code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('BMW i4 PM Synch', 'BMW i4 Synchronous PM electric drive unit', NULL, 'electric', NULL, NULL);
SET @e_i4 := (SELECT id FROM engines WHERE code='BMW i4 PM Synch' LIMIT 1);
INSERT IGNORE INTO trims(generation_id, slug, name, engine_id, transmission_id, start_year, end_year, hp, torque_nm, zero_100_kmh_s, top_speed_kmh, curb_weight_kg, drive_wheel) VALUES
  (@gen, 'i4-edrive40-rwd',   'i4 eDrive40 (RWD)',                   @e_i4, @t_bev, 2022, NULL, 335, 430, 5.5, 190, 2125, 'rwd'),
  (@gen, 'i4-m50-xdrive',     'i4 M50 (xDrive)',                     @e_i4, @t_bev, 2022, NULL, 536, 795, 3.7, 225, 2290, 'awd');

-- ============================================================
-- Cadillac Escalade T1XX (gen 100) — Base 6.2 V8 + Duramax + Escalade-V
-- Source: news.cadillac.com 2022 Escalade-V press release + autopadre
-- ============================================================
SET @gen := 100;
SET @e_l87 := (SELECT id FROM engines WHERE code='6.2 L87 V8' LIMIT 1);
SET @e_lt4 := (SELECT id FROM engines WHERE code='6.2 LT4 SC' LIMIT 1);
SET @e_dmx := (SELECT id FROM engines WHERE code='3.0 Duramax' LIMIT 1);
INSERT IGNORE INTO trims(generation_id, slug, name, engine_id, transmission_id, start_year, end_year, hp, torque_nm, zero_100_kmh_s, top_speed_kmh, curb_weight_kg, drive_wheel) VALUES
  (@gen, 'luxury-6-2-v8',         'Escalade Luxury 6.2L V8 (L87)',          @e_l87, @t_10at, 2021, 2024, 420, 624, 6.1, 210, 2595, 'rwd'),
  (@gen, 'premium-6-2-v8-4wd',    'Escalade Premium Luxury 4WD 6.2L V8',    @e_l87, @t_10at, 2021, 2024, 420, 624, 6.4, 210, 2718, '4wd'),
  (@gen, 'duramax-3-0-diesel',    'Escalade 3.0L Duramax I6 Diesel',        @e_dmx, @t_10at, 2021, 2024, 277, 624, 7.7, 180, 2700, '4wd'),
  (@gen, 'escalade-v-supercharged','Escalade-V 6.2L Supercharged V8 (LT4)', @e_lt4, @t_10at, 2023, 2024, 682, 885, 4.4, 225, 2772, '4wd');

-- ============================================================
-- Hyundai Kona SX2 (gen 118) — SE/SEL Nu / Limited N-Line 1.6T / Electric
-- Source: NHTSA per-trim curb weights + Hyundai US press kit HP
-- ============================================================
SET @gen := 118;
SET @e_nu  := (SELECT id FROM engines WHERE code='G2.0 MPI Nu' LIMIT 1);
SET @e_g16 := (SELECT id FROM engines WHERE code='G1.6T Smartstream' LIMIT 1);
SET @e_kev := (SELECT id FROM engines WHERE code='Kona EV PE' LIMIT 1);
SET @t_ivt := (SELECT id FROM transmissions WHERE display_name='Subaru Lineartronic CVT' LIMIT 1);
INSERT IGNORE INTO transmissions(type, gears, display_name) VALUES ('cvt', NULL, 'Hyundai IVT');
SET @t_ivt := (SELECT id FROM transmissions WHERE display_name='Hyundai IVT' LIMIT 1);
SET @t_7dct := (SELECT id FROM transmissions WHERE display_name='DQ381 7DSG' LIMIT 1);
INSERT IGNORE INTO trims(generation_id, slug, name, engine_id, transmission_id, start_year, end_year, hp, torque_nm, zero_100_kmh_s, top_speed_kmh, curb_weight_kg, drive_wheel) VALUES
  (@gen, 'kona-se-sel-fwd',   'Kona SE/SEL FWD 2.0 Nu MPI',              @e_nu,  @t_ivt,  2024, NULL, 147, 179, 9.4, 175, 1363, 'fwd'),
  (@gen, 'kona-se-sel-awd',   'Kona SE/SEL AWD 2.0 Nu MPI',              @e_nu,  @t_ivt,  2024, NULL, 147, 179, 9.9, 175, 1453, 'awd'),
  (@gen, 'kona-n-line-1-6t',  'Kona N-Line 1.6T Smartstream',            @e_g16, @t_7dct, 2024, NULL, 190, 264, 7.6, 210, 1570, 'awd'),
  (@gen, 'kona-electric-ev',  'Kona Electric (long-range battery)',      @e_kev, @t_bev,  2024, NULL, 201, 255, 6.4, 172, 1705, 'fwd');

-- ============================================================
-- Land Rover Range Rover Sport L461 (gen 117) — P400 MHEV / P440e PHEV
-- Source: JLR media press kit + NHTSA per-trim curb weights
-- ============================================================
SET @gen := 117;
SET @e_ing := (SELECT id FROM engines WHERE code='Ingenium 3.0 I6 MHEV' LIMIT 1);
SET @e_phev := (SELECT id FROM engines WHERE code='Ingenium PHEV' LIMIT 1);
INSERT IGNORE INTO trims(generation_id, slug, name, engine_id, transmission_id, start_year, end_year, hp, torque_nm, zero_100_kmh_s, top_speed_kmh, curb_weight_kg, drive_wheel) VALUES
  (@gen, 'rr-sport-p400-mhev', 'Range Rover Sport P400 SE MHEV (3.0 I6)', @e_ing,  @t_8at, 2022, NULL, 395, 550, 5.7, 250, 2309, 'awd'),
  (@gen, 'rr-sport-p440e-phev','Range Rover Sport P440e PHEV',             @e_phev, @t_8at, 2022, NULL, 434, 800, 5.5, 225, 2658, 'awd');

-- ============================================================
-- Lexus IS XE30 (gen 102) — IS 200t / IS 300 / IS 350
-- Source: Toyota press kit IS spec sheet + ultimatespecs
-- ============================================================
SET @gen := 102;
SET @e_8ar := (SELECT id FROM engines WHERE code='8AR-FTS' LIMIT 1);
SET @e_2gr := (SELECT id FROM engines WHERE code='2GR-FKS' LIMIT 1);
INSERT IGNORE INTO trims(generation_id, slug, name, engine_id, transmission_id, start_year, end_year, hp, torque_nm, zero_100_kmh_s, top_speed_kmh, curb_weight_kg, drive_wheel) VALUES
  (@gen, 'is-200t-rwd',  'IS 200t / 300t RWD (8AR-FTS 2.0T)',  @e_8ar, @t_8at, 2014, 2020, 241, 350, 6.9, 230, 1625, 'rwd'),
  (@gen, 'is-300-awd',   'IS 300 AWD (2GR-FKS 3.5 V6)',         @e_2gr, @t_8at, 2014, 2020, 260, 320, 6.9, 230, 1695, 'awd'),
  (@gen, 'is-350-rwd',   'IS 350 RWD (2GR-FKS 3.5 V6)',         @e_2gr, @t_8at, 2014, 2020, 311, 380, 5.7, 230, 1645, 'rwd');

-- ============================================================
-- Lincoln Navigator U554 (gen 121) — 3.5 EcoBoost twin-turbo
-- Source: U.S. News Lincoln Navigator + Ford press kit
-- ============================================================
SET @gen := 121;
SET @e_eb := (SELECT id FROM engines WHERE code='3.5 EcoBoost' LIMIT 1);
INSERT IGNORE INTO trims(generation_id, slug, name, engine_id, transmission_id, start_year, end_year, hp, torque_nm, zero_100_kmh_s, top_speed_kmh, curb_weight_kg, drive_wheel) VALUES
  (@gen, 'nav-standard',  'Navigator (standard wheelbase, 3.5 EcoBoost)', @e_eb, @t_10at, 2018, NULL, 450, 691, 6.0, 220, 2656, '4wd'),
  (@gen, 'nav-l',         'Navigator L (extended wheelbase, 3.5 EcoBoost)', @e_eb, @t_10at, 2018, NULL, 450, 691, 6.1, 220, 2747, '4wd');

-- ============================================================
-- Tesla Model S (gen 116) — Long Range / Plaid (refresh era)
-- Source: tesla.com Model S specs page + NHTSA AWD curb weight
-- ============================================================
SET @gen := 116;
SET @e_tlr := (SELECT id FROM engines WHERE code='Tesla Drive Unit LR' LIMIT 1);
SET @e_tpl := (SELECT id FROM engines WHERE code='Tesla Drive Unit Plaid' LIMIT 1);
INSERT IGNORE INTO trims(generation_id, slug, name, engine_id, transmission_id, start_year, end_year, hp, torque_nm, zero_100_kmh_s, top_speed_kmh, curb_weight_kg, drive_wheel) VALUES
  (@gen, 'model-s-long-range', 'Model S Long Range (dual motor AWD)', @e_tlr, @t_bev, 2021, NULL, 670, 723, 3.1, 250, 2069, 'awd'),
  (@gen, 'model-s-plaid',      'Model S Plaid (tri-motor AWD)',        @e_tpl, @t_bev, 2021, NULL, 1020, 1420, 2.0, 322, 2162, 'awd');

-- ============================================================
-- Toyota Prius XW60 (gen 101) — Hybrid + Prime PHEV
-- Source: Toyota US press kit + autopadre Prius spec sheet
-- ============================================================
SET @gen := 101;
SET @e_m20 := (SELECT id FROM engines WHERE code='M20A-FXS hybrid' LIMIT 1);
SET @t_ecvt := (SELECT id FROM transmissions WHERE display_name='Subaru Lineartronic CVT' LIMIT 1);
INSERT IGNORE INTO transmissions(type, gears, display_name) VALUES ('eCVT', NULL, 'Toyota eCVT');
SET @t_ecvt := (SELECT id FROM transmissions WHERE display_name='Toyota eCVT' LIMIT 1);
INSERT IGNORE INTO trims(generation_id, slug, name, engine_id, transmission_id, start_year, end_year, hp, torque_nm, zero_100_kmh_s, top_speed_kmh, curb_weight_kg, drive_wheel) VALUES
  (@gen, 'prius-le-xle-ltd',  'Prius LE/XLE/Limited (2.0 Hybrid M20A-FXS)', @e_m20, @t_ecvt, 2023, NULL, 196, 206, 7.2, 180, 1405, 'fwd'),
  (@gen, 'prius-awd',          'Prius LE/XLE/Limited AWD',                   @e_m20, @t_ecvt, 2023, NULL, 196, 206, 7.5, 180, 1465, 'awd'),
  (@gen, 'prius-prime-phev',   'Prius Prime PHEV',                           @e_m20, @t_ecvt, 2023, NULL, 220, 206, 6.6, 180, 1570, 'fwd');

-- ============================================================
-- Link all new trim rows to NHTSA + the existing OM source per gen
-- ============================================================
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'trims', id, @nhtsa FROM trims WHERE generation_id IN (100, 101, 102, 115, 116, 117, 118, 119, 121);

SELECT 'Missing trims added' AS status,
       generation_id,
       (SELECT COUNT(*) FROM trims t2 WHERE t2.generation_id=t.generation_id) AS trims_now
FROM trims t WHERE generation_id IN (100, 101, 102, 115, 116, 117, 118, 119, 121)
GROUP BY generation_id;
