-- Widen Honda Civic FE sedan (11th gen) trims per herstructureringsplan
-- Fase 2 + the powertrain-distinct strategy researched 2026-05-22.
--
-- Civic FE has a small powertrain matrix relative to BMW (one 2.0 NA, one
-- 1.5T petrol, one e:HEV hybrid, one Si tune). Current DB has 4 trims; this
-- migration adds the 2 missing powertrain-distinct variants and fixes two
-- small data bugs in the existing seed.
--
-- New trims (2):
--   1) 1.5 VTEC (180 Hp) 6MT — Sport sedan with manual transmission (US,
--      offered model year 2022 only before Honda dropped manual on the
--      Civic sedan)
--   2) 2.0 i-MMD (200 Hp) e:HEV e-CVT — US-market hybrid tune (Sport
--      Hybrid / Sport Touring Hybrid 2025+), 16 hp above the EU 184 hp
--      e:HEV that already exists
--
-- Data bugs fixed (incidental):
--   a) si-1-5-vtec-200-hp row has engine_id NULL — Honda Civic Si FE uses
--      the L15B7 1.5T (same block as the Sport CVT at a higher tune).
--   b) 2-0-i-mmd-184-hp-e-hev-e-cvt row has hp=141 (engine-only) while the
--      name says "184 Hp" (combined). Updated to 184 so the variant
--      comparison table shows the figure that matches the name and the
--      auto-data/ultimatespecs convention for hybrid trims.
--
-- Two-source verification: auto-data.net Civic XI Sedan + ultimatespecs.com
-- Honda Civic catalog (both report identical HP figures for petrol; US
-- hybrid 200 hp confirmed via Honda press release referenced by both sites).

SET NAMES utf8mb4;

SET @gen_civic := (SELECT id FROM generations WHERE slug = 'civic-fe-sedan-2022-2025');
SET @e_l15b7   := (SELECT id FROM engines WHERE code = 'L15B7');
SET @e_lfc1    := (SELECT id FROM engines WHERE code = 'LFC1');
SET @tx_mt6    := 11;  -- 6 gears, manual transmission
SET @tx_ecvt   := 9;   -- e-CVT
-- Reusing the sources rows added by Tim's original Civic FE seed; if absent
-- the per-trim citation just gets skipped silently rather than failing.
SET @s_ad_civic := (SELECT id FROM sources WHERE url LIKE '%auto-data.net%honda-civic-xi-sedan%' LIMIT 1);
SET @s_us_civic := (SELECT id FROM sources WHERE url LIKE '%ultimatespecs.com%Civic%' LIMIT 1);

-- ----------------------------------------------------------------------------
-- 1. Bug fix: Civic Si gets its L15B7 engine_id
-- ----------------------------------------------------------------------------
UPDATE trims
SET engine_id = @e_l15b7
WHERE generation_id = @gen_civic
  AND slug = 'si-1-5-vtec-200-hp'
  AND engine_id IS NULL;

-- ----------------------------------------------------------------------------
-- 2. Bug fix: 184 Hp e:HEV row gets hp=184 (combined) to match name
-- ----------------------------------------------------------------------------
UPDATE trims
SET hp = 184
WHERE generation_id = @gen_civic
  AND slug = '2-0-i-mmd-184-hp-e-hev-e-cvt'
  AND hp = 141;

-- ----------------------------------------------------------------------------
-- 3. New trim: 1.5 VTEC (180 Hp) 6MT — Sport sedan manual
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, torque_nm, drive_wheel, start_year, end_year) VALUES
  (@gen_civic, '1-5-vtec-180-hp-6mt', '1.5 VTEC (180 Hp) 6MT', @e_l15b7, @tx_mt6, 180, 240, 'FWD', 2022, 2022);

-- ----------------------------------------------------------------------------
-- 4. New trim: 2.0 i-MMD (200 Hp) e:HEV e-CVT — US Sport Hybrid
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, torque_nm, drive_wheel, start_year, end_year) VALUES
  (@gen_civic, '2-0-i-mmd-200-hp-e-hev-e-cvt', '2.0 i-MMD (200 Hp) e:HEV e-CVT', @e_lfc1, @tx_ecvt, 200, 232, 'FWD', 2025, 2025);

-- ----------------------------------------------------------------------------
-- 5. Source citations for the new trims (skipped if source rows absent)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_ad_civic FROM trims
   WHERE generation_id = @gen_civic
     AND slug IN ('1-5-vtec-180-hp-6mt', '2-0-i-mmd-200-hp-e-hev-e-cvt')
     AND @s_ad_civic IS NOT NULL;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_us_civic FROM trims
   WHERE generation_id = @gen_civic
     AND slug IN ('1-5-vtec-180-hp-6mt', '2-0-i-mmd-200-hp-e-hev-e-cvt')
     AND @s_us_civic IS NOT NULL;
