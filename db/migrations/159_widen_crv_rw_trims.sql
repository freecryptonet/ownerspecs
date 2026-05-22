-- Widen Honda CR-V RW (5th-gen) trims per Fase 2.
--
-- Current 6 trims cover the hybrid (4 variants — US + EU naming for the same
-- 2.0L LFA1 e-CVT) and one each of the 2.0L i-VTEC AWD and 2.4L NA AWD. The
-- gap is the US main lineup powertrain — the 1.5L L15B7 turbocharged four
-- (190 hp), which was standard on EX / EX-L / Touring trims for most of
-- the RW production run. Also missing: the 2.4 NA FWD variant (base LX
-- FWD) and the 2.0 i-VTEC FWD JDM variant.
--
-- New trims (4):
--   2.4L NA (184 Hp) FWD CVT          — US base LX
--   1.5L L15B7 turbo (190 Hp) FWD CVT — US EX (FWD)
--   1.5L L15B7 turbo (190 Hp) AWD CVT — US EX (AWD)
--   2.0L R20A NA (150 Hp) FWD CVT     — JDM base FWD
--
-- The L15B7 trims use engine_id 1 (same code as Civic Sport 180 hp + Civic
-- Si 200 hp). The 190 hp CR-V tune is a slightly higher map than the Civic
-- Sport — the engine catalogue page will list both vehicles under L15B7.

SET NAMES utf8mb4;

SET @gen_crv  := (SELECT id FROM generations WHERE slug = 'cr-v-rw-suv-2017-2022');
SET @e_k24w   := 30;
SET @e_l15b7  := 1;
SET @e_r20a   := 31;
SET @tx_cvt   := 17;  -- automatic transmission CVT

INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, torque_nm, drive_wheel, start_year, end_year) VALUES
  (@gen_crv, '2-4-184-hp-cvt',                 '2.4 (184 Hp) CVT',                 @e_k24w,  @tx_cvt, 184, 244, 'FWD', 2017, 2019),
  (@gen_crv, '1-5-vtec-turbo-190-hp-cvt',      '1.5 VTEC Turbo (190 Hp) CVT',      @e_l15b7, @tx_cvt, 190, 243, 'FWD', 2017, 2022),
  (@gen_crv, '1-5-vtec-turbo-190-hp-awd-cvt',  '1.5 VTEC Turbo (190 Hp) AWD CVT',  @e_l15b7, @tx_cvt, 190, 243, 'AWD', 2017, 2022),
  (@gen_crv, '2-0-i-vtec-150-hp-cvt',          '2.0 i-VTEC (150 Hp) CVT',          @e_r20a,  @tx_cvt, 150, 189, 'FWD', 2017, 2022);

-- Sources
INSERT IGNORE INTO sources (citation, url, retrieved_at) VALUES
  ('Honda US 2017-2022 CR-V spec sheet', 'https://automobiles.honda.com/cr-v', NOW());
SET @s_honda := (SELECT id FROM sources WHERE url = 'https://automobiles.honda.com/cr-v');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_honda FROM trims
   WHERE generation_id = @gen_crv
     AND slug IN ('2-4-184-hp-cvt','1-5-vtec-turbo-190-hp-cvt','1-5-vtec-turbo-190-hp-awd-cvt','2-0-i-vtec-150-hp-cvt');
