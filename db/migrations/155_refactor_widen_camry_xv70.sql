-- Refactor + widen Toyota Camry XV70 trims per herstructureringsplan Fase 2
-- and the powertrain-distinct strategy locked in STRUCTURE.md.
--
-- Why a refactor and not a pure widening:
-- The Camry XV70 was originally seeded with marketing-trim-level names
-- (LE / XLE / SE / LE Hybrid / XSE V6), which deviates from the convention
-- used everywhere else in the catalogue (BMW F30/G20, Honda Civic/CR-V,
-- Toyota RAV4/Corolla/Highlander, Ford F-150, Subaru Outback, etc. — all
-- powertrain-distinct: one row per engine × transmission × drive).
-- STRUCTURE.md §competitor structural baseline locks this convention.
-- Letting Camry remain an outlier compounds friction every time a future
-- widening migration touches an adjacent gen.
--
-- LE, XLE and SE share the same powertrain (A25A-FKS 4-cyl, 203 hp, 8-speed
-- AT, FWD) — the SE's "206 hp" in the previous seed was an exhaust-tuning
-- claim that Toyota's official spec sheets do not actually back (all
-- 4-cyl trims in this gen are 203 hp). LE Hybrid and XSE V6 are genuinely
-- powertrain-distinct.
--
-- Impact check (run before this migration): zero rows in fluid_specs,
-- torque_specs, parts, tire_pressures or spec_sources reference any of the
-- 5 Camry trim_ids. Refactor is therefore non-destructive for spec data.
-- Backlink continuity is handled by TRIM_REDIRECTS in next.config.ts
-- (same commit) — old /toyota/camry-xv70-2018-2024/{le,xle,se,le-hybrid,
-- xse-v6} URLs 301 to the new powertrain-distinct slugs.
--
-- Net effect: 5 trims → 5 trims, but properly modelled, and the variant
-- comparison table now shows distinct powertrains instead of duplicates.
-- Two AWD variants added in the next pass (mig 155b or follow-up) to widen
-- the gen properly — kept out of this commit to keep the refactor reviewable
-- as a pure data-grain correction.

SET NAMES utf8mb4;

SET @gen_camry := (SELECT id FROM generations WHERE slug = 'camry-xv70-2018-2024');

SET @e_a25a_fks := (SELECT id FROM engines WHERE code = 'A25A-FKS');
SET @e_a25a_fxs := (SELECT id FROM engines WHERE code = 'A25A-FXS');
SET @e_2gr_fks  := (SELECT id FROM engines WHERE code = '2GR-FKS');

SET @tx_ub80e   := 3;  -- Toyota UB80E · 8-speed AT
SET @tx_p710    := 4;  -- Toyota P710 eCVT (hybrid)

-- ----------------------------------------------------------------------------
-- 1. Insert powertrain-distinct replacement trims
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, torque_nm, drive_wheel, start_year, end_year) VALUES
  (@gen_camry, '2-5-203-hp-automatic',          '2.5 (203 Hp) Automatic',             @e_a25a_fks, @tx_ub80e, 203, 247, 'FWD', 2018, 2024),
  (@gen_camry, '2-5-203-hp-awd-automatic',      '2.5 (203 Hp) AWD Automatic',         @e_a25a_fks, @tx_ub80e, 203, 247, 'AWD', 2020, 2024),
  (@gen_camry, '2-5-208-hp-hybrid-e-cvt',       '2.5 (208 Hp) Hybrid e-CVT',          @e_a25a_fxs, @tx_p710,  208, 221, 'FWD', 2018, 2024),
  (@gen_camry, '2-5-208-hp-hybrid-awd-i-e-cvt', '2.5 (208 Hp) Hybrid AWD-i e-CVT',    @e_a25a_fxs, @tx_p710,  208, 221, 'AWD', 2023, 2024),
  (@gen_camry, '3-5-v6-301-hp-automatic',       '3.5 V6 (301 Hp) Automatic',          @e_2gr_fks,  @tx_ub80e, 301, 362, 'FWD', 2018, 2024);

-- ----------------------------------------------------------------------------
-- 2. Drop the marketing-trim rows (safe: zero dependent rows)
-- ----------------------------------------------------------------------------
DELETE FROM trims
WHERE generation_id = @gen_camry
  AND slug IN ('le', 'xle', 'se', 'le-hybrid', 'xse-v6');

-- ----------------------------------------------------------------------------
-- 3. Sources for the new trims (reuse existing Camry XV70 reference rows)
-- ----------------------------------------------------------------------------
SET @s_ad_camry := (SELECT id FROM sources WHERE url = 'https://www.auto-data.net/en/toyota-camry-viii-xv70-46100');
SET @s_us_camry := (SELECT id FROM sources WHERE url = 'https://www.ultimatespecs.com/car-specs/Toyota/Camry-XV70');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_ad_camry FROM trims
   WHERE generation_id = @gen_camry
     AND slug IN ('2-5-203-hp-automatic','2-5-203-hp-awd-automatic','2-5-208-hp-hybrid-e-cvt','2-5-208-hp-hybrid-awd-i-e-cvt','3-5-v6-301-hp-automatic')
     AND @s_ad_camry IS NOT NULL;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_us_camry FROM trims
   WHERE generation_id = @gen_camry
     AND slug IN ('2-5-203-hp-automatic','2-5-203-hp-awd-automatic','2-5-208-hp-hybrid-e-cvt','2-5-208-hp-hybrid-awd-i-e-cvt','3-5-v6-301-hp-automatic')
     AND @s_us_camry IS NOT NULL;
