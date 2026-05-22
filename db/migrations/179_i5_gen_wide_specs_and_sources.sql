-- Follow-up to mig 178: restore the spec_sources INSERTs that aborted in the
-- first run and clone gen-wide spec data from G60 ICE (gen 128) so the i5
-- gen page subroutes (/tires, /torque, /electrical, /maintenance-schedule,
-- /procedures, /parts) don't 404.
--
-- Procedures cloned: only those applicable to a BEV. ICE-specific procedures
-- removed afterwards (oil-level-check, at-fluid-zf-8hp).

SET NAMES utf8mb4;

SET @gen_src := (SELECT id FROM generations WHERE slug = '5-series-g60-sedan-2023-present');
SET @gen_i5  := (SELECT id FROM generations WHERE slug = 'i5-g60-sedan-2023-present');

-- ----------------------------------------------------------------------------
-- 1. Spec_sources for trims (carried over from mig 178)
-- ----------------------------------------------------------------------------
SET @s_i5_2024 := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/bmw-auto/i5-2024-owners-manual-95889');
SET @s_i5_2026 := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/bmw-auto/i5-2026-owners-manual-107914');
SET @s_ad_i5   := (SELECT id FROM sources WHERE url = 'https://www.auto-data.net/en/bmw-i5-sedan-g60-generation-9502');
SET @s_haynes  := (SELECT id FROM sources WHERE citation LIKE 'HaynesPro WorkshopData — BMW 5 (G60, G61, G90) — i5%' LIMIT 1);

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_ad_i5 FROM trims WHERE generation_id = @gen_i5;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_haynes FROM trims WHERE generation_id = @gen_i5 AND @s_haynes IS NOT NULL;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_i5_2024 FROM trims WHERE generation_id = @gen_i5;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'trims', id, @s_i5_2026 FROM trims WHERE generation_id = @gen_i5;

-- ----------------------------------------------------------------------------
-- 2. Clone gen-wide spec data from G60 ICE
-- ----------------------------------------------------------------------------
INSERT INTO electrical_specs (generation_id, trim_id, market_id, battery_group, cca, ah, alternator_amps)
SELECT @gen_i5, trim_id, market_id, battery_group, cca, ah, alternator_amps
FROM electrical_specs WHERE generation_id = @gen_src;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory)
SELECT @gen_i5, market_id, position, bulb_code, quantity, led_from_factory
FROM bulbs WHERE generation_id = @gen_src;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name, is_relay)
SELECT @gen_i5, market_id, location, position, amperage, circuit_name, is_relay
FROM fuses WHERE generation_id = @gen_src;

INSERT INTO tire_pressures (generation_id, trim_id, market_id, position, load_condition, psi, kpa, tire_size)
SELECT @gen_i5, trim_id, market_id, position, load_condition, psi, kpa, tire_size
FROM tire_pressures WHERE generation_id = @gen_src AND trim_id IS NULL;

INSERT INTO torque_specs (generation_id, fastener, engine_id, trim_id, torque_nm, torque_ftlb, thread_lock, notes)
SELECT @gen_i5, fastener, engine_id, trim_id, torque_nm, torque_ftlb, thread_lock, notes
FROM torque_specs WHERE generation_id = @gen_src AND engine_id IS NULL;

INSERT INTO service_intervals (generation_id, service, engine_id, trim_id, miles_normal, miles_severe, km_normal, km_severe, months, notes)
SELECT @gen_i5, service, engine_id, trim_id, miles_normal, miles_severe, km_normal, km_severe, months, notes
FROM service_intervals WHERE generation_id = @gen_src AND engine_id IS NULL
  AND service NOT IN ('engine_oil', 'engine_oil_filter', 'engine_air_filter', 'spark_plugs');

INSERT INTO parts (generation_id, part_type, engine_id, trim_id, part_number, source_brand, gap_mm, size, notes)
SELECT @gen_i5, part_type, engine_id, trim_id, part_number, source_brand, gap_mm, size, notes
FROM parts WHERE generation_id = @gen_src AND engine_id IS NULL
  AND part_type NOT IN ('spark_plug', 'engine_oil_filter', 'engine_air_filter');

-- Procedures: clone only BEV-applicable ones (exclude oil-level-check + at-fluid-zf-8hp)
INSERT INTO procedures (generation_id, market_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT @gen_i5, market_id, procedure_type, slug, title, body_md, tools_required, common_mistakes
FROM procedures
WHERE generation_id = @gen_src
  AND slug NOT IN ('oil-level-check', 'at-fluid-zf-8hp');

-- Coolant procedure title needs i5-specific qualifier — update only on i5 gen
UPDATE procedures
SET title = REPLACE(title, '5 Series (G30)', 'i5 (G60)')
WHERE generation_id = @gen_i5;

-- ----------------------------------------------------------------------------
-- 3. Cite sources on the cloned procedure rows
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'procedures', p_new.id, ss.source_id
FROM procedures p_old
JOIN procedures p_new ON p_new.generation_id = @gen_i5 AND p_new.slug = p_old.slug
JOIN spec_sources ss ON ss.spec_table = 'procedures' AND ss.spec_id = p_old.id
WHERE p_old.generation_id = @gen_src;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'bulbs', b_new.id, ss.source_id
FROM bulbs b_old
JOIN bulbs b_new ON b_new.generation_id = @gen_i5
                AND b_new.position = b_old.position
                AND b_new.bulb_code = b_old.bulb_code
JOIN spec_sources ss ON ss.spec_table = 'bulbs' AND ss.spec_id = b_old.id
WHERE b_old.generation_id = @gen_src;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'tire_pressures', tp_new.id, ss.source_id
FROM tire_pressures tp_old
JOIN tire_pressures tp_new ON tp_new.generation_id = @gen_i5
                          AND tp_new.position = tp_old.position
                          AND tp_new.load_condition = tp_old.load_condition
                          AND (tp_new.psi <=> tp_old.psi)
JOIN spec_sources ss ON ss.spec_table = 'tire_pressures' AND ss.spec_id = tp_old.id
WHERE tp_old.generation_id = @gen_src AND tp_old.trim_id IS NULL;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'torque_specs', t_new.id, ss.source_id
FROM torque_specs t_old
JOIN torque_specs t_new ON t_new.generation_id = @gen_i5
                       AND t_new.fastener = t_old.fastener
                       AND (t_new.torque_nm <=> t_old.torque_nm)
JOIN spec_sources ss ON ss.spec_table = 'torque_specs' AND ss.spec_id = t_old.id
WHERE t_old.generation_id = @gen_src AND t_old.engine_id IS NULL;
