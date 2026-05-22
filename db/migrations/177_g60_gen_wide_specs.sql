-- G60 missing gen-wide spec rows — causes 404 on /tires, /torque, /electrical,
-- /maintenance-schedule, /procedures subpages. Fix: clone the gen-wide data
-- from G30 LCI (gen 127), which shares the same BMW chassis/electrical/brake
-- conventions: ZF 8HP gearbox, EPB system, all-LED lighting, no-dipstick oil
-- level, BMW Condition-Based Service (CBS), 140 Nm wheel bolt torque etc.
--
-- Items NOT cloned (G60 differs):
-- - fluid_specs (already populated by mig 176 with G60-specific oil/coolant)
-- - tire_pressures with trim_id NOT NULL (G60 trim-specific 245/40 R20 etc.
--   need a separate trim-specific tire migration once OEM data is collected)
--
-- Items cloned:
-- - electrical_specs (gen-wide battery group / CCA — BMW EVO battery carries)
-- - bulbs (G60 is all-LED standard, identical position layout to G30 LCI)
-- - fuses (gen-wide fuse box layout; G60 may add 48V-specific fuses but
--   baseline carries)
-- - tire_pressures with trim_id NULL (gen-wide spare/space-saver pressures)
-- - torque_specs with engine_id NULL (wheel bolts, suspension bolts —
--   chassis-level torques)
-- - service_intervals (CBS-based; identical across G30 LCI and G60)
-- - procedures (all 8 carry: CBS reset, battery register, jump-start, TPMS
--   reset, oil-level-check, coolant-drain-refill, epb-service-mode,
--   at-fluid-zf-8hp)

SET NAMES utf8mb4;

SET @gen_src := (SELECT id FROM generations WHERE slug = '5-series-g30-lci-sedan-2020-2023');
SET @gen_g60 := (SELECT id FROM generations WHERE slug = '5-series-g60-sedan-2023-present');

-- electrical_specs (gen-wide)
INSERT INTO electrical_specs (generation_id, trim_id, market_id, battery_group, cca, ah, alternator_amps)
SELECT @gen_g60, trim_id, market_id, battery_group, cca, ah, alternator_amps
FROM electrical_specs WHERE generation_id = @gen_src;

-- bulbs (gen-wide; all-LED layout carries forward)
INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory)
SELECT @gen_g60, market_id, position, bulb_code, quantity, led_from_factory
FROM bulbs WHERE generation_id = @gen_src;

-- fuses (gen-wide)
INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name, is_relay)
SELECT @gen_g60, market_id, location, position, amperage, circuit_name, is_relay
FROM fuses WHERE generation_id = @gen_src;

-- tire_pressures (gen-wide, trim_id NULL)
INSERT INTO tire_pressures (generation_id, trim_id, market_id, position, load_condition, psi, kpa, tire_size)
SELECT @gen_g60, trim_id, market_id, position, load_condition, psi, kpa, tire_size
FROM tire_pressures WHERE generation_id = @gen_src AND trim_id IS NULL;

-- torque_specs (gen-wide, engine_id NULL — wheel bolts, suspension, brake caliper)
INSERT INTO torque_specs (generation_id, fastener, engine_id, trim_id, torque_nm, torque_ftlb, thread_lock, notes)
SELECT @gen_g60, fastener, engine_id, trim_id, torque_nm, torque_ftlb, thread_lock, notes
FROM torque_specs WHERE generation_id = @gen_src AND engine_id IS NULL;

-- service_intervals (gen-wide, engine_id NULL — CBS-driven intervals)
INSERT INTO service_intervals (generation_id, service, engine_id, trim_id, miles_normal, miles_severe, km_normal, km_severe, months, notes)
SELECT @gen_g60, service, engine_id, trim_id, miles_normal, miles_severe, km_normal, km_severe, months, notes
FROM service_intervals WHERE generation_id = @gen_src AND engine_id IS NULL;

-- parts (gen-wide, engine_id NULL — chassis-level part numbers)
INSERT INTO parts (generation_id, part_type, engine_id, trim_id, part_number, source_brand, gap_mm, size, notes)
SELECT @gen_g60, part_type, engine_id, trim_id, part_number, source_brand, gap_mm, size, notes
FROM parts WHERE generation_id = @gen_src AND engine_id IS NULL;

-- procedures (all 8: battery-register, cbs-reset, jump-start, tpms-reset,
--  oil-level-check, coolant-drain-refill, epb-service-mode, at-fluid-zf-8hp)
INSERT INTO procedures (generation_id, market_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT @gen_g60, market_id, procedure_type, slug, title, body_md, tools_required, common_mistakes
FROM procedures WHERE generation_id = @gen_src;

-- Copy spec_sources via content-matching JOINs (same pattern as gen-split migs)
INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'bulbs', b_new.id, ss.source_id
FROM bulbs b_old
JOIN bulbs b_new ON b_new.generation_id = @gen_g60
                AND b_new.position = b_old.position
                AND b_new.bulb_code = b_old.bulb_code
JOIN spec_sources ss ON ss.spec_table = 'bulbs' AND ss.spec_id = b_old.id
WHERE b_old.generation_id = @gen_src;

INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'torque_specs', t_new.id, ss.source_id
FROM torque_specs t_old
JOIN torque_specs t_new ON t_new.generation_id = @gen_g60
                       AND t_new.fastener = t_old.fastener
                       AND (t_new.torque_nm <=> t_old.torque_nm)
JOIN spec_sources ss ON ss.spec_table = 'torque_specs' AND ss.spec_id = t_old.id
WHERE t_old.generation_id = @gen_src AND t_old.engine_id IS NULL;

INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'tire_pressures', tp_new.id, ss.source_id
FROM tire_pressures tp_old
JOIN tire_pressures tp_new ON tp_new.generation_id = @gen_g60
                          AND tp_new.position = tp_old.position
                          AND tp_new.load_condition = tp_old.load_condition
                          AND (tp_new.psi <=> tp_old.psi)
JOIN spec_sources ss ON ss.spec_table = 'tire_pressures' AND ss.spec_id = tp_old.id
WHERE tp_old.generation_id = @gen_src AND tp_old.trim_id IS NULL;

INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'procedures', p_new.id, ss.source_id
FROM procedures p_old
JOIN procedures p_new ON p_new.generation_id = @gen_g60 AND p_new.slug = p_old.slug
JOIN spec_sources ss ON ss.spec_table = 'procedures' AND ss.spec_id = p_old.id
WHERE p_old.generation_id = @gen_src;
