-- Finish the F30 LCI split — duplicate the gen-wide spec tables that
-- mig 161 missed due to column-name mismatches between the migration SQL
-- and the actual table schemas.
--
-- Tables still pending duplication onto the LCI gen (post-mig-161):
--   electrical_specs, bulbs, fuses, tire_pressures, images, procedures
--
-- The earlier mig 161 attempted these with incorrect columns (notes / count /
-- box / slot / circuit etc. that don't exist on those tables). This
-- migration uses each table's actual schema.
--
-- After this completes, the LCI gen page will have a hero image, the bulbs
-- and fuses topic pages will populate, tire-pressure placard data will
-- show on trim pages, electrical-specs page renders battery info, and the
-- procedures index has the gen-wide entries.

SET NAMES utf8mb4;

SET @gen_pre := (SELECT id FROM generations WHERE slug = '3-series-f30-sedan-2012-2015');
SET @gen_lci := (SELECT id FROM generations WHERE slug = '3-series-f30-lci-sedan-2015-2018');

-- ----------------------------------------------------------------------------
-- electrical_specs (no notes column; has market_id)
-- ----------------------------------------------------------------------------
INSERT INTO electrical_specs (generation_id, trim_id, market_id, battery_group, cca, ah, alternator_amps)
SELECT @gen_lci, trim_id, market_id, battery_group, cca, ah, alternator_amps
FROM electrical_specs WHERE generation_id = @gen_pre;

-- ----------------------------------------------------------------------------
-- bulbs (quantity not count; led_from_factory; no notes)
-- ----------------------------------------------------------------------------
INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory)
SELECT @gen_lci, market_id, position, bulb_code, quantity, led_from_factory
FROM bulbs WHERE generation_id = @gen_pre;

-- ----------------------------------------------------------------------------
-- fuses (location/position/amperage/circuit_name/is_relay; no box/slot/circuit/notes)
-- ----------------------------------------------------------------------------
INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name, is_relay)
SELECT @gen_lci, market_id, location, position, amperage, circuit_name, is_relay
FROM fuses WHERE generation_id = @gen_pre;

-- ----------------------------------------------------------------------------
-- tire_pressures (market_id was missing in mig 161)
-- ----------------------------------------------------------------------------
INSERT INTO tire_pressures (generation_id, trim_id, market_id, position, load_condition, psi, kpa, tire_size)
SELECT @gen_lci, trim_id, market_id, position, load_condition, psi, kpa, tire_size
FROM tire_pressures WHERE generation_id = @gen_pre AND trim_id IS NULL;

-- ----------------------------------------------------------------------------
-- images (source / license / download_date are NOT NULL — must be copied)
-- ----------------------------------------------------------------------------
INSERT INTO images (
  generation_id, trim_id, market_id, url, source, license, attribution,
  original_url, download_date, caption, position, width, height
)
SELECT
  @gen_lci, trim_id, market_id, url, source, license, attribution,
  original_url, download_date, caption, position, width, height
FROM images WHERE generation_id = @gen_pre AND trim_id IS NULL;

-- ----------------------------------------------------------------------------
-- procedures (tools_required + common_mistakes nullable; slug NOT globally
-- unique — verified safe to duplicate)
-- ----------------------------------------------------------------------------
INSERT INTO procedures (
  generation_id, market_id, procedure_type, slug, title, body_md,
  tools_required, common_mistakes
)
SELECT
  @gen_lci, market_id, procedure_type, slug, title, body_md,
  tools_required, common_mistakes
FROM procedures WHERE generation_id = @gen_pre;

-- ----------------------------------------------------------------------------
-- Copy spec_sources for the bulbs / fuses / tire_pressures / electrical_specs
-- duplicates. Procedures + images don't typically have spec_sources rows.
-- ----------------------------------------------------------------------------
INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'electrical_specs', e_new.id, ss.source_id
FROM electrical_specs e_old
JOIN electrical_specs e_new ON e_new.generation_id = @gen_lci
                           AND (e_new.battery_group <=> e_old.battery_group)
                           AND (e_new.cca <=> e_old.cca)
JOIN spec_sources ss ON ss.spec_table = 'electrical_specs' AND ss.spec_id = e_old.id
WHERE e_old.generation_id = @gen_pre;

INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'bulbs', b_new.id, ss.source_id
FROM bulbs b_old
JOIN bulbs b_new ON b_new.generation_id = @gen_lci
                AND b_new.position = b_old.position
                AND b_new.bulb_code = b_old.bulb_code
JOIN spec_sources ss ON ss.spec_table = 'bulbs' AND ss.spec_id = b_old.id
WHERE b_old.generation_id = @gen_pre;

INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fuses', f_new.id, ss.source_id
FROM fuses f_old
JOIN fuses f_new ON f_new.generation_id = @gen_lci
                AND f_new.location = f_old.location
                AND f_new.position = f_old.position
JOIN spec_sources ss ON ss.spec_table = 'fuses' AND ss.spec_id = f_old.id
WHERE f_old.generation_id = @gen_pre;

INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'tire_pressures', tp_new.id, ss.source_id
FROM tire_pressures tp_old
JOIN tire_pressures tp_new ON tp_new.generation_id = @gen_lci
                          AND tp_new.position = tp_old.position
                          AND tp_new.load_condition = tp_old.load_condition
                          AND (tp_new.psi <=> tp_old.psi)
JOIN spec_sources ss ON ss.spec_table = 'tire_pressures' AND ss.spec_id = tp_old.id
WHERE tp_old.generation_id = @gen_pre AND tp_old.trim_id IS NULL;
