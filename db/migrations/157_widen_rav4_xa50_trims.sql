-- Widen Toyota RAV4 XA50 trims + fix the 200 hp / 203 hp discrepancy on the
-- existing AWD NA row. Per herstructureringsplan Fase 2.
--
-- Real Toyota US spec for the XA50 2.5L A25A-FKS in any drive configuration
-- is 203 hp. The existing row "2.5 (200 Hp) AWD Automatic" with hp=200 is
-- 3 hp short of the official figure (the TRD Off-Road row already uses 203
-- on the same engine, confirming the convention). This migration drops the
-- 200 hp row and replaces it with two correct-hp rows: the missing FWD
-- variant and a corrected AWD variant. Backlink continuity for the old
-- slug is handled by an entry in next.config.ts TRIM_REDIRECTS.
--
-- Impact check: 3 spec_sources rows reference the old 200hp trim_id, 0
-- references in fluid_specs / torque_specs / parts / tire_pressures.
-- spec_sources are cleared and re-created against the new rows so the
-- citations still attribute correctly.

SET NAMES utf8mb4;

SET @gen_rav4    := (SELECT id FROM generations WHERE slug = 'rav4-xa50-suv-2019-2021');
SET @e_a25a_fks  := (SELECT id FROM engines WHERE code = 'A25A-FKS');
SET @tx_ub80e    := 3;  -- Toyota UB80E · 8-speed AT (Camry seed also uses)

-- Capture the existing wrong-hp row's id + its source links before deleting
SET @old_trim_id := (SELECT id FROM trims WHERE generation_id = @gen_rav4 AND slug = '2-5-200-hp-awd-automatic');

-- ----------------------------------------------------------------------------
-- 1. Insert the two correct rows
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO trims (generation_id, slug, name, engine_id, transmission_id, hp, torque_nm, drive_wheel, start_year, end_year) VALUES
  (@gen_rav4, '2-5-203-hp-automatic',      '2.5 (203 Hp) Automatic',      @e_a25a_fks, @tx_ub80e, 203, 244, 'FWD', 2019, 2021),
  (@gen_rav4, '2-5-203-hp-awd-automatic',  '2.5 (203 Hp) AWD Automatic',  @e_a25a_fks, @tx_ub80e, 203, 244, 'AWD', 2019, 2021);

-- ----------------------------------------------------------------------------
-- 2. Migrate sources from the old row to the new AWD row, then drop the old
-- ----------------------------------------------------------------------------
SET @new_awd_id := (SELECT id FROM trims WHERE generation_id = @gen_rav4 AND slug = '2-5-203-hp-awd-automatic');

UPDATE IGNORE spec_sources
   SET spec_id = @new_awd_id
 WHERE spec_table = 'trims' AND spec_id = @old_trim_id;

DELETE FROM spec_sources WHERE spec_table = 'trims' AND spec_id = @old_trim_id;
DELETE FROM trims WHERE id = @old_trim_id;

-- ----------------------------------------------------------------------------
-- 3. Add sources for the new FWD row (re-use the auto-data RAV4 ref if any)
-- ----------------------------------------------------------------------------
SET @s_ad_rav4 := (SELECT id FROM sources WHERE url LIKE '%auto-data.net%rav4%' LIMIT 1);
SET @s_us_rav4 := (SELECT id FROM sources WHERE url LIKE '%ultimatespecs.com%RAV4%' LIMIT 1);

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_ad_rav4 FROM trims
   WHERE generation_id = @gen_rav4 AND slug = '2-5-203-hp-automatic' AND @s_ad_rav4 IS NOT NULL;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_us_rav4 FROM trims
   WHERE generation_id = @gen_rav4 AND slug = '2-5-203-hp-automatic' AND @s_us_rav4 IS NOT NULL;
