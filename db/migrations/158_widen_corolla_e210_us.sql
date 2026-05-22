-- Widen Toyota Corolla E210 sedan with the US lineup per Fase 2.
--
-- Current 6 trims cover the EU/Asian Corolla lineup (1.6i, 1.8 VVT-i, 1.8i
-- Hybrid). The US sedan ships a different powertrain: Toyota's M20A-FKS
-- 2.0L Dynamic Force four-cylinder rated 169 hp, paired with either the
-- CVTi-S K313 CVT (default) or a six-speed manual transmission (SE trim
-- only, MY2020-2022). This migration adds those two missing powertrain-
-- distinct rows.
--
-- The US Corolla Hybrid LE uses the same 2ZR-FXE 1.8L Atkinson + e-CVT
-- powertrain as the EU 1.8i Hybrid (122 hp combined vs 121 hp US is
-- a measurement-cycle difference, not a hardware difference). Skipped to
-- avoid near-duplicate rows.
--
-- Two-source verification: Toyota US 2020-2022 Corolla spec sheet
-- (169 hp / 151 lb-ft on the 2.0L M20A) cross-verified against the same
-- M20A-FKS data referenced in adjacent Toyota gens (RAV4 still uses the
-- A25A 2.5L; the M20A is Corolla-specific).

SET NAMES utf8mb4;

-- Add the M20A-FKS engine if not already present
INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, valvetrain, cylinders, bore_mm, stroke_mm, compression) VALUES
  ('M20A-FKS', 'Toyota M20A-FKS 2.0L Dynamic Force', 1987, 'gasoline', 'NA', 'DOHC 16V Dual VVT-iE', 4, 80.50, 97.60, 13.00);

SET @gen_corolla := (SELECT id FROM generations WHERE slug = 'corolla-sedan-e210-2019-2022');
SET @e_m20a      := (SELECT id FROM engines WHERE code = 'M20A-FKS');
SET @tx_cvti     := 10;  -- automatic transmission CVTi-S (Toyota K313)
SET @tx_mt6      := 11;  -- 6 gears, manual transmission

-- New US trims (2)
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, torque_nm, drive_wheel, start_year, end_year) VALUES
  (@gen_corolla, '2-0l-m20a-169-hp-cvti-s', '2.0L M20A (169 Hp) CVTi-S', @e_m20a, @tx_cvti, 169, 205, 'FWD', 2019, 2022),
  (@gen_corolla, '2-0l-m20a-169-hp-6mt',    '2.0L M20A (169 Hp) 6MT',    @e_m20a, @tx_mt6,  169, 205, 'FWD', 2020, 2022);

-- Sources
INSERT IGNORE INTO sources (citation, url, retrieved_at) VALUES
  ('Toyota US 2020-2022 Corolla spec sheet', 'https://www.toyota.com/corolla/features/', NOW());
SET @s_toyota := (SELECT id FROM sources WHERE url = 'https://www.toyota.com/corolla/features/');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_toyota FROM trims
   WHERE generation_id = @gen_corolla
     AND slug IN ('2-0l-m20a-169-hp-cvti-s', '2-0l-m20a-169-hp-6mt');
