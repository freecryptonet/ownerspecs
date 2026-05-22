-- Widen Ford Mustang S550 with the 3.7L V6 base trims per Fase 2.
--
-- The S550 fastback (2015-2017 pre-LCI) shipped with three engines: the
-- 2.3L EcoBoost turbo four (already seeded), the 5.0L Coyote V8 (already
-- seeded as 421 hp pre-LCI + 426 hp LCI tunes), and the 3.7L Cyclone V6
-- (300 hp) — the entry-level engine that Ford dropped for the 2018 LCI.
-- This migration adds the missing V6 rows.
--
-- New engine (1): 3.7L Cyclone Ti-VCT V6 — different from the 3.5L Cyclone
-- (F-150 base, mig 156) and from the Duratec 37 (Lincoln MKZ era).
--
-- New trims (2): manual + automatic. Both RWD-only (S550 was rear-drive
-- except where modified aftermarket; Ford did not offer factory AWD on
-- the S550 fastback).

SET NAMES utf8mb4;

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, valvetrain, cylinders, bore_mm, stroke_mm, compression) VALUES
  ('3.7 Ti-VCT V6', 'Ford 3.7L Ti-VCT Cyclone V6', 3726, 'gasoline', 'NA', 'DOHC 24V Ti-VCT', 6, 95.50, 86.70, 10.50);

SET @gen_mustang := (SELECT id FROM generations WHERE slug = 'mustang-s550-fastback-2015-2017');
SET @e_v6        := (SELECT id FROM engines WHERE code = '3.7 Ti-VCT V6');
SET @tx_mt6      := 11;  -- 6 gears, manual transmission
SET @tx_at6      := 8;   -- 6 gears, automatic transmission

INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, torque_nm, drive_wheel, start_year, end_year) VALUES
  (@gen_mustang, '3-7-ti-vct-v6-300-hp',           '3.7 Ti-VCT V6 (300 Hp)',           @e_v6, @tx_mt6, 300, 380, 'RWD', 2015, 2017),
  (@gen_mustang, '3-7-ti-vct-v6-300-hp-automatic', '3.7 Ti-VCT V6 (300 Hp) Automatic', @e_v6, @tx_at6, 300, 380, 'RWD', 2015, 2017);

-- Sources
INSERT IGNORE INTO sources (citation, url, retrieved_at) VALUES
  ('Ford US 2015-2017 Mustang spec sheet', 'https://www.ford.com/cars/mustang/specs/', NOW());
SET @s_ford := (SELECT id FROM sources WHERE url = 'https://www.ford.com/cars/mustang/specs/');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_ford FROM trims
   WHERE generation_id = @gen_mustang
     AND slug IN ('3-7-ti-vct-v6-300-hp','3-7-ti-vct-v6-300-hp-automatic');
