-- Audi A6 C8 family — backfill spec_sources on the 4 new gens.
-- Mig 195 only cloned spec_sources for fluid_specs + procedures (matching the
-- pattern used in mig 192 for A4 B9). This leaves torque/parts/service/bulbs/
-- fuses/tire_pressures/electrical_specs on the new gens uncited even though
-- their values were cloned 1:1 from sources with citations.
--
-- This migration covers all 8 spec tables on the 4 new gens (152 = Avant
-- pre-LCI, 153 = LCI sedan, 154 = LCI Avant, 155 = Allroad C8).

SET NAMES utf8mb4;

-- ----------------------------------------------------------------------------
-- Avant pre-LCI (152) ← clones from sedan (115)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'torque_specs', t_new.id, ss.source_id
FROM torque_specs t_old
JOIN torque_specs t_new ON t_new.generation_id = 152
                       AND t_new.fastener = t_old.fastener
                       AND (t_new.torque_nm <=> t_old.torque_nm)
                       AND (t_new.engine_id <=> t_old.engine_id)
JOIN spec_sources ss ON ss.spec_table = 'torque_specs' AND ss.spec_id = t_old.id
WHERE t_old.generation_id = 115;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'parts', p_new.id, ss.source_id
FROM parts p_old
JOIN parts p_new ON p_new.generation_id = 152
                AND p_new.part_type = p_old.part_type
                AND (p_new.part_number <=> p_old.part_number)
JOIN spec_sources ss ON ss.spec_table = 'parts' AND ss.spec_id = p_old.id
WHERE p_old.generation_id = 115;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'service_intervals', s_new.id, ss.source_id
FROM service_intervals s_old
JOIN service_intervals s_new ON s_new.generation_id = 152
                            AND s_new.service = s_old.service
                            AND (s_new.miles_normal <=> s_old.miles_normal)
JOIN spec_sources ss ON ss.spec_table = 'service_intervals' AND ss.spec_id = s_old.id
WHERE s_old.generation_id = 115;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'bulbs', b_new.id, ss.source_id
FROM bulbs b_old
JOIN bulbs b_new ON b_new.generation_id = 152
                AND b_new.position = b_old.position
                AND (b_new.bulb_code <=> b_old.bulb_code)
JOIN spec_sources ss ON ss.spec_table = 'bulbs' AND ss.spec_id = b_old.id
WHERE b_old.generation_id = 115;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fuses', f_new.id, ss.source_id
FROM fuses f_old
JOIN fuses f_new ON f_new.generation_id = 152
                AND f_new.location = f_old.location
                AND f_new.position = f_old.position
                AND (f_new.circuit_name <=> f_old.circuit_name)
JOIN spec_sources ss ON ss.spec_table = 'fuses' AND ss.spec_id = f_old.id
WHERE f_old.generation_id = 115;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'tire_pressures', tp_new.id, ss.source_id
FROM tire_pressures tp_old
JOIN tire_pressures tp_new ON tp_new.generation_id = 152
                          AND tp_new.position = tp_old.position
                          AND tp_new.load_condition = tp_old.load_condition
                          AND (tp_new.psi <=> tp_old.psi)
JOIN spec_sources ss ON ss.spec_table = 'tire_pressures' AND ss.spec_id = tp_old.id
WHERE tp_old.generation_id = 115;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'electrical_specs', e_new.id, ss.source_id
FROM electrical_specs e_old
JOIN electrical_specs e_new ON e_new.generation_id = 152
                           AND (e_new.battery_group <=> e_old.battery_group)
                           AND (e_new.cca <=> e_old.cca)
JOIN spec_sources ss ON ss.spec_table = 'electrical_specs' AND ss.spec_id = e_old.id
WHERE e_old.generation_id = 115;

-- ----------------------------------------------------------------------------
-- LCI sedan (153) ← clones from sedan (115)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'torque_specs', t_new.id, ss.source_id
FROM torque_specs t_old
JOIN torque_specs t_new ON t_new.generation_id = 153 AND t_new.fastener = t_old.fastener AND (t_new.torque_nm <=> t_old.torque_nm) AND (t_new.engine_id <=> t_old.engine_id)
JOIN spec_sources ss ON ss.spec_table = 'torque_specs' AND ss.spec_id = t_old.id
WHERE t_old.generation_id = 115;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'parts', p_new.id, ss.source_id
FROM parts p_old
JOIN parts p_new ON p_new.generation_id = 153 AND p_new.part_type = p_old.part_type AND (p_new.part_number <=> p_old.part_number)
JOIN spec_sources ss ON ss.spec_table = 'parts' AND ss.spec_id = p_old.id
WHERE p_old.generation_id = 115;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'service_intervals', s_new.id, ss.source_id
FROM service_intervals s_old
JOIN service_intervals s_new ON s_new.generation_id = 153 AND s_new.service = s_old.service AND (s_new.miles_normal <=> s_old.miles_normal)
JOIN spec_sources ss ON ss.spec_table = 'service_intervals' AND ss.spec_id = s_old.id
WHERE s_old.generation_id = 115;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'bulbs', b_new.id, ss.source_id
FROM bulbs b_old
JOIN bulbs b_new ON b_new.generation_id = 153 AND b_new.position = b_old.position AND (b_new.bulb_code <=> b_old.bulb_code)
JOIN spec_sources ss ON ss.spec_table = 'bulbs' AND ss.spec_id = b_old.id
WHERE b_old.generation_id = 115;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fuses', f_new.id, ss.source_id
FROM fuses f_old
JOIN fuses f_new ON f_new.generation_id = 153 AND f_new.location = f_old.location AND f_new.position = f_old.position AND (f_new.circuit_name <=> f_old.circuit_name)
JOIN spec_sources ss ON ss.spec_table = 'fuses' AND ss.spec_id = f_old.id
WHERE f_old.generation_id = 115;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'tire_pressures', tp_new.id, ss.source_id
FROM tire_pressures tp_old
JOIN tire_pressures tp_new ON tp_new.generation_id = 153 AND tp_new.position = tp_old.position AND tp_new.load_condition = tp_old.load_condition AND (tp_new.psi <=> tp_old.psi)
JOIN spec_sources ss ON ss.spec_table = 'tire_pressures' AND ss.spec_id = tp_old.id
WHERE tp_old.generation_id = 115;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'electrical_specs', e_new.id, ss.source_id
FROM electrical_specs e_old
JOIN electrical_specs e_new ON e_new.generation_id = 153 AND (e_new.battery_group <=> e_old.battery_group) AND (e_new.cca <=> e_old.cca)
JOIN spec_sources ss ON ss.spec_table = 'electrical_specs' AND ss.spec_id = e_old.id
WHERE e_old.generation_id = 115;

-- ----------------------------------------------------------------------------
-- LCI Avant (154) ← clones from LCI sedan (153)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'torque_specs', t_new.id, ss.source_id
FROM torque_specs t_old
JOIN torque_specs t_new ON t_new.generation_id = 154 AND t_new.fastener = t_old.fastener AND (t_new.torque_nm <=> t_old.torque_nm) AND (t_new.engine_id <=> t_old.engine_id)
JOIN spec_sources ss ON ss.spec_table = 'torque_specs' AND ss.spec_id = t_old.id
WHERE t_old.generation_id = 153;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'parts', p_new.id, ss.source_id
FROM parts p_old
JOIN parts p_new ON p_new.generation_id = 154 AND p_new.part_type = p_old.part_type AND (p_new.part_number <=> p_old.part_number)
JOIN spec_sources ss ON ss.spec_table = 'parts' AND ss.spec_id = p_old.id
WHERE p_old.generation_id = 153;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'service_intervals', s_new.id, ss.source_id
FROM service_intervals s_old
JOIN service_intervals s_new ON s_new.generation_id = 154 AND s_new.service = s_old.service AND (s_new.miles_normal <=> s_old.miles_normal)
JOIN spec_sources ss ON ss.spec_table = 'service_intervals' AND ss.spec_id = s_old.id
WHERE s_old.generation_id = 153;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'bulbs', b_new.id, ss.source_id
FROM bulbs b_old
JOIN bulbs b_new ON b_new.generation_id = 154 AND b_new.position = b_old.position AND (b_new.bulb_code <=> b_old.bulb_code)
JOIN spec_sources ss ON ss.spec_table = 'bulbs' AND ss.spec_id = b_old.id
WHERE b_old.generation_id = 153;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fuses', f_new.id, ss.source_id
FROM fuses f_old
JOIN fuses f_new ON f_new.generation_id = 154 AND f_new.location = f_old.location AND f_new.position = f_old.position AND (f_new.circuit_name <=> f_old.circuit_name)
JOIN spec_sources ss ON ss.spec_table = 'fuses' AND ss.spec_id = f_old.id
WHERE f_old.generation_id = 153;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'tire_pressures', tp_new.id, ss.source_id
FROM tire_pressures tp_old
JOIN tire_pressures tp_new ON tp_new.generation_id = 154 AND tp_new.position = tp_old.position AND tp_new.load_condition = tp_old.load_condition AND (tp_new.psi <=> tp_old.psi)
JOIN spec_sources ss ON ss.spec_table = 'tire_pressures' AND ss.spec_id = tp_old.id
WHERE tp_old.generation_id = 153;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'electrical_specs', e_new.id, ss.source_id
FROM electrical_specs e_old
JOIN electrical_specs e_new ON e_new.generation_id = 154 AND (e_new.battery_group <=> e_old.battery_group) AND (e_new.cca <=> e_old.cca)
JOIN spec_sources ss ON ss.spec_table = 'electrical_specs' AND ss.spec_id = e_old.id
WHERE e_old.generation_id = 153;

-- ----------------------------------------------------------------------------
-- Allroad (155) ← clones from Avant pre-LCI (152). Tire pressures inserted
-- raw without sources in mig 195 — left uncited until HaynesPro inhaal-pull.
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'torque_specs', t_new.id, ss.source_id
FROM torque_specs t_old
JOIN torque_specs t_new ON t_new.generation_id = 155 AND t_new.fastener = t_old.fastener AND (t_new.torque_nm <=> t_old.torque_nm) AND (t_new.engine_id <=> t_old.engine_id)
JOIN spec_sources ss ON ss.spec_table = 'torque_specs' AND ss.spec_id = t_old.id
WHERE t_old.generation_id = 152;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'parts', p_new.id, ss.source_id
FROM parts p_old
JOIN parts p_new ON p_new.generation_id = 155 AND p_new.part_type = p_old.part_type AND (p_new.part_number <=> p_old.part_number)
JOIN spec_sources ss ON ss.spec_table = 'parts' AND ss.spec_id = p_old.id
WHERE p_old.generation_id = 152;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'service_intervals', s_new.id, ss.source_id
FROM service_intervals s_old
JOIN service_intervals s_new ON s_new.generation_id = 155 AND s_new.service = s_old.service AND (s_new.miles_normal <=> s_old.miles_normal)
JOIN spec_sources ss ON ss.spec_table = 'service_intervals' AND ss.spec_id = s_old.id
WHERE s_old.generation_id = 152;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'bulbs', b_new.id, ss.source_id
FROM bulbs b_old
JOIN bulbs b_new ON b_new.generation_id = 155 AND b_new.position = b_old.position AND (b_new.bulb_code <=> b_old.bulb_code)
JOIN spec_sources ss ON ss.spec_table = 'bulbs' AND ss.spec_id = b_old.id
WHERE b_old.generation_id = 152;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fuses', f_new.id, ss.source_id
FROM fuses f_old
JOIN fuses f_new ON f_new.generation_id = 155 AND f_new.location = f_old.location AND f_new.position = f_old.position AND (f_new.circuit_name <=> f_old.circuit_name)
JOIN spec_sources ss ON ss.spec_table = 'fuses' AND ss.spec_id = f_old.id
WHERE f_old.generation_id = 152;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'electrical_specs', e_new.id, ss.source_id
FROM electrical_specs e_old
JOIN electrical_specs e_new ON e_new.generation_id = 155 AND (e_new.battery_group <=> e_old.battery_group) AND (e_new.cca <=> e_old.cca)
JOIN spec_sources ss ON ss.spec_table = 'electrical_specs' AND ss.spec_id = e_old.id
WHERE e_old.generation_id = 152;

-- ----------------------------------------------------------------------------
-- Audit — count source links per gen per spec table
-- ----------------------------------------------------------------------------
SELECT
  g.slug,
  (SELECT COUNT(*) FROM spec_sources ss WHERE ss.spec_table='fluid_specs' AND ss.spec_id IN (SELECT id FROM fluid_specs WHERE generation_id=g.id)) AS fluid_src,
  (SELECT COUNT(*) FROM spec_sources ss WHERE ss.spec_table='torque_specs' AND ss.spec_id IN (SELECT id FROM torque_specs WHERE generation_id=g.id)) AS torque_src,
  (SELECT COUNT(*) FROM spec_sources ss WHERE ss.spec_table='parts' AND ss.spec_id IN (SELECT id FROM parts WHERE generation_id=g.id)) AS parts_src,
  (SELECT COUNT(*) FROM spec_sources ss WHERE ss.spec_table='service_intervals' AND ss.spec_id IN (SELECT id FROM service_intervals WHERE generation_id=g.id)) AS service_src,
  (SELECT COUNT(*) FROM spec_sources ss WHERE ss.spec_table='bulbs' AND ss.spec_id IN (SELECT id FROM bulbs WHERE generation_id=g.id)) AS bulbs_src,
  (SELECT COUNT(*) FROM spec_sources ss WHERE ss.spec_table='fuses' AND ss.spec_id IN (SELECT id FROM fuses WHERE generation_id=g.id)) AS fuses_src,
  (SELECT COUNT(*) FROM spec_sources ss WHERE ss.spec_table='tire_pressures' AND ss.spec_id IN (SELECT id FROM tire_pressures WHERE generation_id=g.id)) AS tire_src
FROM generations g
WHERE g.family_slug = 'audi-a6-c8-2018-present'
ORDER BY g.start_year, g.body_type;
