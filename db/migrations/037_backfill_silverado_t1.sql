-- Backfill Silverado T1 — moat audit revealed bulbs/fuses/parts tables were
-- empty for gen 38. This restores them to parity with other ICE trucks
-- (Ford F-150 P702, Ram 1500 DT). Restated from Chevy Silverado 2022 OM +
-- ACDelco/GM Genuine parts catalog.

SET NAMES utf8mb4;
SET @gen := 38;
SET @src := (SELECT id FROM sources WHERE citation LIKE 'Chevrolet Silverado%' AND is_public = 1 LIMIT 1);

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen, NULL, 'headlight_low',  '9012 (HIR2)', 2, 0),
  (@gen, NULL, 'headlight_high', '9011 (HIR1)', 2, 0),
  (@gen, NULL, 'headlight_led',  'LED (LTZ/HC)', 2, 1),
  (@gen, NULL, 'fog_front',      'PSX24W', 2, 0),
  (@gen, NULL, 'drl',            'LED', 2, 1),
  (@gen, NULL, 'turn_front',     '3157NA', 2, 0),
  (@gen, NULL, 'brake_tail',     '3157', 2, 0),
  (@gen, NULL, 'brake_chmsl',    'LED', 1, 1),
  (@gen, NULL, 'reverse',        '921 (W16W)', 2, 0),
  (@gen, NULL, 'turn_rear',      '3157NA', 2, 0),
  (@gen, NULL, 'license_plate',  '194 (W5W)', 2, 0),
  (@gen, NULL, 'cargo_lamp',     '906', 2, 0),
  (@gen, NULL, 'interior_dome',  '578 (festoon)', 1, 0),
  (@gen, NULL, 'interior_map',   '194 (W5W)', 2, 0),
  (@gen, NULL, 'bed_lamp',       'LED (LTZ/HC)', 2, 1);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src FROM bulbs WHERE generation_id = @gen;

-- FUSES — derived from 2022 Chevrolet Silverado OM section 11 (engine bay
-- and instrument panel fuse block)
INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen, NULL, 'engine_bay', 'F1',  60,  'ABS pump motor'),
  (@gen, NULL, 'engine_bay', 'F2',  40,  'ABS solenoid'),
  (@gen, NULL, 'engine_bay', 'F4',  40,  'Engine cooling fan #1'),
  (@gen, NULL, 'engine_bay', 'F5',  40,  'Engine cooling fan #2'),
  (@gen, NULL, 'engine_bay', 'F8',  30,  'Front blower motor'),
  (@gen, NULL, 'engine_bay', 'F11', 30,  'Trailer brake controller'),
  (@gen, NULL, 'engine_bay', 'F14', 30,  'Driveline (4WD actuator)'),
  (@gen, NULL, 'engine_bay', 'F18', 25,  'Headlight low LH'),
  (@gen, NULL, 'engine_bay', 'F19', 25,  'Headlight low RH'),
  (@gen, NULL, 'engine_bay', 'F23', 20,  'Fuel pump'),
  (@gen, NULL, 'engine_bay', 'F26', 20,  'Trailer accessory'),
  (@gen, NULL, 'engine_bay', 'F32', 15,  'Engine ignition coils'),
  (@gen, NULL, 'engine_bay', 'F35', 15,  'PCM (Powertrain Control Module)'),
  (@gen, NULL, 'engine_bay', 'F38', 10,  'Horn'),
  (@gen, NULL, 'cabin',      'IP1', 20,  'Driver power lock / window'),
  (@gen, NULL, 'cabin',      'IP2', 20,  'Passenger power lock / window'),
  (@gen, NULL, 'cabin',      'IP5', 25,  'Sliding rear window'),
  (@gen, NULL, 'cabin',      'IP8', 15,  'Audio / radio'),
  (@gen, NULL, 'cabin',      'IP12',15,  'Heated seats'),
  (@gen, NULL, 'cabin',      'IP15',10,  'Body Control Module IGN'),
  (@gen, NULL, 'cabin',      'IP20',20,  'Front 12V power outlet'),
  (@gen, NULL, 'cabin',      'IP22',10,  'OBD-II diagnostic port');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src FROM fuses WHERE generation_id = @gen;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen, NULL, 'spark_plug',    '12671659',   'ACDelco (GM OE)', 1.10, NULL,    '5.3L L84 / 6.2L L87 V8 — iridium 41-103'),
  (@gen, NULL, 'spark_plug',    '12698554',   'ACDelco (GM OE)', 1.10, NULL,    '2.7L L3B turbo I4 — iridium'),
  (@gen, NULL, 'oil_filter',    '12715393',   'ACDelco (GM OE)', NULL, NULL,    'Spin-on; 5.3L / 6.2L V8 (PF66)'),
  (@gen, NULL, 'oil_filter',    '12685430',   'ACDelco (GM OE)', NULL, NULL,    'Cartridge; 2.7L L3B turbo'),
  (@gen, NULL, 'oil_filter',    '12701040',   'ACDelco (GM OE)', NULL, NULL,    '3.0L LM2 Duramax diesel — Duralife'),
  (@gen, NULL, 'air_filter',    '84121219',   'ACDelco (GM OE)', NULL, NULL,    'Engine air filter (T1)'),
  (@gen, NULL, 'cabin_filter',  '23321737',   'ACDelco (GM OE)', NULL, NULL,    'Activated carbon'),
  (@gen, NULL, 'wiper_front_d', '84571726',   'GM Genuine',      NULL, '22 in', 'Driver beam blade'),
  (@gen, NULL, 'wiper_front_p', '84571727',   'GM Genuine',      NULL, '22 in', 'Passenger beam blade');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src FROM parts WHERE generation_id = @gen;

SELECT 'silverado-t1 backfill complete' AS status,
  (SELECT COUNT(*) FROM bulbs WHERE generation_id = @gen) AS bulbs,
  (SELECT COUNT(*) FROM fuses WHERE generation_id = @gen) AS fuses,
  (SELECT COUNT(*) FROM parts WHERE generation_id = @gen) AS parts;
