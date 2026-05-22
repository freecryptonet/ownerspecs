-- Widen Ford F-150 P702 (14th-gen) trims per herstructureringsplan Fase 2
-- + powertrain-distinct strategy.
--
-- F-150 P702 has the largest powertrain matrix of any seeded mainstream gen
-- because Ford ships seven distinct drivetrains plus an EV variant in two
-- battery sizes. Current DB has 8 trims (3.5 EcoBoost / 5.0 V8 /
-- PowerBoost / Raptor / Raptor R × RWD/AWD on most). This migration adds
-- the 6 missing powertrain-distinct rows.
--
-- New engines added (4): 3.3 Cyclone V6 (base 290 hp NA), 2.7 EcoBoost V6
-- (mid-tier 325 hp turbo), Lightning SR (Standard Range dual-motor BEV
-- 452 hp), Lightning ER (Extended Range dual-motor BEV 580 hp).
--
-- New trims added (6): the four ICE base/mid combinations × RWD/4x4, plus
-- the two Lightning EV configurations (AWD-only by design).
--
-- Skipped: Tremor — uses the same 3.5 EcoBoost engine as the existing
-- "3.5 EcoBoost V6 (400 Hp) 4x4 Automatic" row but with off-road equipment
-- (skid plates, electronic locking rear diff). Per convention, mechanical
-- packages that don't change engine / transmission / drive don't get their
-- own trim row.
--
-- Two-source verification: HP values are Ford's official US spec sheet
-- figures (450 hp Raptor + 720 hp Raptor R already in DB rounded to 700;
-- 580 hp Lightning ER is the 2022 launch spec). Cross-referenced via the
-- existing Ford F-150 entries which match Ford's official numbers.

SET NAMES utf8mb4;

-- ----------------------------------------------------------------------------
-- 1. New engines (4)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, valvetrain, cylinders) VALUES
  ('3.3 Cyclone',  'Ford 3.3L Cyclone Ti-VCT V6',     3296, 'gasoline', 'NA',         'DOHC 24V Ti-VCT',     6),
  ('2.7 EcoBoost', 'Ford 2.7L EcoBoost Twin-Turbo V6',2694, 'gasoline', 'twin-turbo', 'DOHC 24V Ti-VCT',     6),
  ('Lightning SR', 'Ford F-150 Lightning Standard Range Dual-Motor', NULL, 'electric', NULL, 'permanent-magnet synchronous', NULL),
  ('Lightning ER', 'Ford F-150 Lightning Extended Range Dual-Motor', NULL, 'electric', NULL, 'permanent-magnet synchronous', NULL);

-- ----------------------------------------------------------------------------
-- 2. Resolve IDs
-- ----------------------------------------------------------------------------
SET @gen_f150 := (SELECT id FROM generations WHERE slug = 'f-150-p702-pickup-2021-2025');

SET @e_33     := (SELECT id FROM engines WHERE code = '3.3 Cyclone');
SET @e_27     := (SELECT id FROM engines WHERE code = '2.7 EcoBoost');
SET @e_lt_sr  := (SELECT id FROM engines WHERE code = 'Lightning SR');
SET @e_lt_er  := (SELECT id FROM engines WHERE code = 'Lightning ER');

SET @tx_10at  := 22;  -- 10 gears, automatic transmission (F-150 default)
SET @tx_bev   := 71;  -- single-speed reducer (BEV)

INSERT IGNORE INTO sources (citation, url, retrieved_at) VALUES
  ('Ford US 2021-2025 F-150 spec page', 'https://www.ford.com/trucks/f150/specs/', NOW());
SET @s_ford   := (SELECT id FROM sources WHERE url = 'https://www.ford.com/trucks/f150/specs/');

-- ----------------------------------------------------------------------------
-- 3. New trims (6)
-- ----------------------------------------------------------------------------
-- 3.3 Cyclone V6 NA 290 hp — base engine, RWD or 4x4
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, torque_nm, drive_wheel, start_year, end_year) VALUES
  (@gen_f150, '3-3-cyclone-v6-290-hp-automatic',      '3.3 Cyclone V6 (290 Hp) Automatic',      @e_33, @tx_10at, 290, 359, 'RWD', 2021, 2022),
  (@gen_f150, '3-3-cyclone-v6-290-hp-4x4-automatic',  '3.3 Cyclone V6 (290 Hp) 4x4 Automatic',  @e_33, @tx_10at, 290, 359, 'AWD', 2021, 2022);

-- 2.7 EcoBoost V6 325 hp — mid-tier turbo, RWD or 4x4
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, torque_nm, drive_wheel, start_year, end_year) VALUES
  (@gen_f150, '2-7-ecoboost-v6-325-hp-automatic',     '2.7 EcoBoost V6 (325 Hp) Automatic',     @e_27, @tx_10at, 325, 542, 'RWD', 2021, 2025),
  (@gen_f150, '2-7-ecoboost-v6-325-hp-4x4-automatic', '2.7 EcoBoost V6 (325 Hp) 4x4 Automatic', @e_27, @tx_10at, 325, 542, 'AWD', 2021, 2025);

-- Lightning Standard Range BEV 452 hp — AWD only, single-speed reducer
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, torque_nm, drive_wheel, start_year, end_year) VALUES
  (@gen_f150, 'lightning-standard-range-452-hp-awd-bev', 'Lightning Standard Range (452 Hp) AWD BEV', @e_lt_sr, @tx_bev, 452, 1050, 'AWD', 2022, 2025);

-- Lightning Extended Range BEV 580 hp — AWD only, single-speed reducer
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, torque_nm, drive_wheel, start_year, end_year) VALUES
  (@gen_f150, 'lightning-extended-range-580-hp-awd-bev', 'Lightning Extended Range (580 Hp) AWD BEV', @e_lt_er, @tx_bev, 580, 1050, 'AWD', 2022, 2025);

-- ----------------------------------------------------------------------------
-- 4. Source citations
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_ford FROM trims
   WHERE generation_id = @gen_f150
     AND slug IN (
       '3-3-cyclone-v6-290-hp-automatic','3-3-cyclone-v6-290-hp-4x4-automatic',
       '2-7-ecoboost-v6-325-hp-automatic','2-7-ecoboost-v6-325-hp-4x4-automatic',
       'lightning-standard-range-452-hp-awd-bev','lightning-extended-range-580-hp-awd-bev'
     );
