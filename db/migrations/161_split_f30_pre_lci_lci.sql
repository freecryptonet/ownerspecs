-- Split BMW 3-Series F30 sedan into pre-LCI (2012-2015) and LCI (2015-2018)
-- per herstructureringsplan Fase 1.1.
--
-- The combined "3-series-f30-sedan-2012-2018" gen entry was the plan's
-- canonical example of where unified-gen modelling hurts: different
-- powertrains (N20/N47/N55 pre-LCI vs B47/B48/B58/B38 LCI), different
-- engine codes for the same nameplate (320i N20 pre-LCI vs 320i B48 LCI),
-- different US trim availability (328i was pre-LCI only, replaced by 330i
-- in LCI, replaced by 340i for the inline-six in LCI). This migration
-- materialises the split.
--
-- Mechanics:
-- 1) The existing gen row is renamed to the pre-LCI slug (2012-2015),
--    end_year corrected to 2015, editorial_intro narrowed to pre-LCI
--    content only.
-- 2) A new gen row "3-series-f30-lci-sedan-2015-2018" is inserted with the
--    same gen-wide dimension / chassis fields and an LCI-focused editorial.
-- 3) The 14 LCI trims I added in mig 153 (318i 136 hp, 330i 252 hp, 340i
--    326 hp, 330e PHEV 252 hp, 320d 190 hp, 318d 150 hp Steptronic,
--    325d 224 hp) are moved to the new LCI gen.
-- 4) Gen-wide spec rows (engine_id IS NULL fluid_specs / torque_specs /
--    parts / service_intervals; all rows in electrical_specs, bulbs,
--    fuses, tire_pressures, images, procedures) are duplicated onto the
--    LCI gen. spec_sources entries follow via match-by-content JOIN so
--    [N] citation footnotes still resolve on LCI sub-pages.
-- 5) Engine-scoped spec rows (existing N55 oil/coolant/transmission_at)
--    stay on the pre-LCI gen because N55 was a pre-LCI-only engine in
--    the F30. LCI engine-scoped rows (B48 oil, B58 coolant, etc.) are
--    still pending — when seeded later they'll naturally land on the
--    LCI gen via generation_id targeting.
--
-- URL handling lives in next.config.ts GEN_SPLITS + LCI-trim overrides
-- (same commit). Old "/bmw/3-series-f30-sedan-2012-2018" 301s to LCI as
-- primary; pre-LCI trim URLs explicitly override to the pre-LCI gen.
--
-- Idempotency: this migration is NOT idempotent by design because it
-- renames an existing row + creates a new one. Re-running will fail on the
-- INSERT (slug uniqueness) — that's the safer behaviour; if needed, undo
-- by hand before re-running.

SET NAMES utf8mb4;

-- ----------------------------------------------------------------------------
-- 1. Capture the pre-existing gen id + rename to pre-LCI shape
-- ----------------------------------------------------------------------------
SET @gen_pre := (SELECT id FROM generations WHERE slug = '3-series-f30-sedan-2012-2018');

UPDATE generations
SET slug             = '3-series-f30-sedan-2012-2015',
    display_name     = 'F30',
    end_year         = 2015,
    editorial_intro  =
'The sixth-generation 3 Series launched in early 2012 for the 2012 model year, internally designated F30 (sedan). It was the first 3 Series built on a substantially different platform from its E90 predecessor and the first to use BMW''s electric power steering across the lineup — a change that drew significant commentary from owners and the enthusiast press for its altered feel relative to the hydraulic steering of the E46 and E90.

The pre-LCI petrol lineup centred on the N20 2.0-litre turbocharged four (320i / 328i) and the N55 3.0-litre turbocharged inline-six (335i). Diesel variants ran the N47 (316d / 318d / 320d / 325d) and N57 (330d / 335d). The pre-LCI F30 ran 2012 through mid-2015 before BMW''s mid-cycle refresh — see the F30 LCI for the 2015-2018 variant with the modular B-series engine family. Production ran at BMW''s Munich plant.'
WHERE id = @gen_pre;

-- ----------------------------------------------------------------------------
-- 2. Insert the LCI gen, copying gen-wide chassis / dimension fields
-- ----------------------------------------------------------------------------
INSERT INTO generations (
  model_id, slug, ordinal, codename, display_name, body_type,
  start_year, end_year, layout, platform, editorial_intro,
  length_mm, width_mm, height_mm, wheelbase_mm,
  front_track_mm, rear_track_mm, fuel_tank_l, cargo_l,
  front_suspension, rear_suspension, front_brakes, rear_brakes,
  is_active
)
SELECT
  model_id,
  '3-series-f30-lci-sedan-2015-2018',
  ordinal,
  'F30 LCI',
  'F30 LCI',
  body_type,
  2015,
  2018,
  layout,
  platform,
'The F30 LCI (Life Cycle Impulse) is the mid-cycle refresh of the sixth-generation 3 Series, launched mid-2015 and produced through 2018 (the F31 Touring continued into 2019). The LCI replaced the N20 2.0-litre four-cylinder with BMW''s modular B48 across the 320i / 330i petrol range, brought the B58 3.0-litre inline-six in the new 340i nameplate (replacing the 335i), and updated the diesel lineup with the B47 (320d / 318d) alongside the carryover N57 (330d / 335d). The plug-in hybrid 330e launched in 2016. Visually the LCI is identified by reshaped front and rear lights with revised LED signatures and a slightly revised front bumper. Production ran at BMW''s Munich plant. The F30 LCI was succeeded by the G20 in 2019.',
  length_mm, width_mm, height_mm, wheelbase_mm,
  front_track_mm, rear_track_mm, fuel_tank_l, cargo_l,
  front_suspension, rear_suspension, front_brakes, rear_brakes,
  is_active
FROM generations
WHERE id = @gen_pre;

SET @gen_lci := (SELECT id FROM generations WHERE slug = '3-series-f30-lci-sedan-2015-2018');

-- ----------------------------------------------------------------------------
-- 3. Move LCI trims to the new gen
-- ----------------------------------------------------------------------------
UPDATE trims
SET generation_id = @gen_lci
WHERE generation_id = @gen_pre
  AND slug IN (
    '318i-136-hp',
    '318i-136-hp-steptronic',
    '330i-252-hp',
    '330i-252-hp-steptronic',
    '330i-252-hp-xdrive-steptronic',
    '330e-252-hp-plug-in-hybrid-steptronic',
    '340i-326-hp',
    '340i-326-hp-steptronic',
    '340i-326-hp-xdrive-steptronic',
    '320d-190-hp',
    '320d-190-hp-steptronic',
    '320d-190-hp-xdrive-steptronic',
    '318d-150-hp-steptronic',
    '325d-224-hp-steptronic'
  );

-- ----------------------------------------------------------------------------
-- 4. Duplicate gen-wide spec rows onto the LCI gen
-- ----------------------------------------------------------------------------

-- fluid_specs (engine_id NULL — brake, AC refrigerant)
INSERT INTO fluid_specs (
  generation_id, fluid_type, engine_id, trim_id, market_id,
  capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no,
  drain_interval_mi, drain_interval_km, drain_interval_months, notes
)
SELECT
  @gen_lci, fluid_type, engine_id, trim_id, market_id,
  capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no,
  drain_interval_mi, drain_interval_km, drain_interval_months, notes
FROM fluid_specs
WHERE generation_id = @gen_pre AND engine_id IS NULL;

-- torque_specs (all currently engine_id NULL on F30)
INSERT INTO torque_specs (
  generation_id, fastener, engine_id, trim_id,
  torque_nm, torque_ftlb, thread_lock, notes
)
SELECT
  @gen_lci, fastener, engine_id, trim_id,
  torque_nm, torque_ftlb, thread_lock, notes
FROM torque_specs
WHERE generation_id = @gen_pre AND engine_id IS NULL;

-- parts (all currently engine_id NULL on F30)
INSERT INTO parts (
  generation_id, part_type, engine_id, trim_id,
  part_number, source_brand, gap_mm, size, notes
)
SELECT
  @gen_lci, part_type, engine_id, trim_id,
  part_number, source_brand, gap_mm, size, notes
FROM parts
WHERE generation_id = @gen_pre AND engine_id IS NULL;

-- service_intervals (all currently engine_id NULL on F30)
INSERT INTO service_intervals (
  generation_id, service, engine_id, trim_id,
  miles_normal, miles_severe, km_normal, km_severe, months, notes
)
SELECT
  @gen_lci, service, engine_id, trim_id,
  miles_normal, miles_severe, km_normal, km_severe, months, notes
FROM service_intervals
WHERE generation_id = @gen_pre AND engine_id IS NULL;

-- electrical_specs (gen-wide)
INSERT INTO electrical_specs (
  generation_id, trim_id, battery_group, cca, ah, alternator_amps, notes
)
SELECT
  @gen_lci, trim_id, battery_group, cca, ah, alternator_amps, notes
FROM electrical_specs
WHERE generation_id = @gen_pre;

-- bulbs (gen-wide)
INSERT INTO bulbs (generation_id, position, bulb_code, count, notes)
SELECT @gen_lci, position, bulb_code, count, notes
FROM bulbs WHERE generation_id = @gen_pre;

-- fuses (gen-wide)
INSERT INTO fuses (generation_id, box, slot, circuit, amperage, notes)
SELECT @gen_lci, box, slot, circuit, amperage, notes
FROM fuses WHERE generation_id = @gen_pre;

-- tire_pressures (gen-wide placard, trim_id NULL)
INSERT INTO tire_pressures (
  generation_id, trim_id, position, load_condition, psi, kpa, tire_size
)
SELECT
  @gen_lci, trim_id, position, load_condition, psi, kpa, tire_size
FROM tire_pressures
WHERE generation_id = @gen_pre AND trim_id IS NULL;

-- images (hero is the same vehicle visually)
INSERT INTO images (
  generation_id, trim_id, url, position, caption,
  attribution, license, original_url, width, height
)
SELECT
  @gen_lci, trim_id, url, position, caption,
  attribution, license, original_url, width, height
FROM images
WHERE generation_id = @gen_pre AND trim_id IS NULL;

-- procedures (gen-wide content like oil-life reset, jump-start)
INSERT INTO procedures (
  generation_id, procedure_type, slug, title, body_md
)
SELECT
  @gen_lci, procedure_type, slug, title, body_md
FROM procedures
WHERE generation_id = @gen_pre;

-- ----------------------------------------------------------------------------
-- 5. Copy spec_sources to point at the new duplicate rows
-- ----------------------------------------------------------------------------
-- Match new LCI rows back to their pre-LCI originals via shared content
-- (fluid_type / fastener / part_type / service / position / etc.) so the
-- per-row [N] citation footnotes carry over to the LCI sub-pages.

INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', f_new.id, ss.source_id
FROM fluid_specs f_old
JOIN fluid_specs f_new ON f_new.generation_id = @gen_lci
                     AND f_new.fluid_type = f_old.fluid_type
                     AND (f_new.engine_id <=> f_old.engine_id)
                     AND (f_new.capacity_l <=> f_old.capacity_l)
                     AND (f_new.viscosity <=> f_old.viscosity)
JOIN spec_sources ss ON ss.spec_table = 'fluid_specs' AND ss.spec_id = f_old.id
WHERE f_old.generation_id = @gen_pre AND f_old.engine_id IS NULL;

INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'torque_specs', t_new.id, ss.source_id
FROM torque_specs t_old
JOIN torque_specs t_new ON t_new.generation_id = @gen_lci
                       AND t_new.fastener = t_old.fastener
                       AND (t_new.engine_id <=> t_old.engine_id)
                       AND (t_new.torque_nm <=> t_old.torque_nm)
JOIN spec_sources ss ON ss.spec_table = 'torque_specs' AND ss.spec_id = t_old.id
WHERE t_old.generation_id = @gen_pre AND t_old.engine_id IS NULL;

INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'parts', p_new.id, ss.source_id
FROM parts p_old
JOIN parts p_new ON p_new.generation_id = @gen_lci
                AND p_new.part_type = p_old.part_type
                AND (p_new.engine_id <=> p_old.engine_id)
                AND (p_new.part_number <=> p_old.part_number)
JOIN spec_sources ss ON ss.spec_table = 'parts' AND ss.spec_id = p_old.id
WHERE p_old.generation_id = @gen_pre AND p_old.engine_id IS NULL;

INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'service_intervals', s_new.id, ss.source_id
FROM service_intervals s_old
JOIN service_intervals s_new ON s_new.generation_id = @gen_lci
                            AND s_new.service = s_old.service
                            AND (s_new.engine_id <=> s_old.engine_id)
JOIN spec_sources ss ON ss.spec_table = 'service_intervals' AND ss.spec_id = s_old.id
WHERE s_old.generation_id = @gen_pre AND s_old.engine_id IS NULL;
