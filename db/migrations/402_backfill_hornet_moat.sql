-- mig 402: backfill Dodge Hornet (gen 339) moat. Fluids already present (12 rows, OM
-- source 875). The Hornet is the Alfa Romeo Tonale (same vehicle); HaynesPro's Tonale 1.3T
-- PHEV data is used for the OM-gap fields it covers (tyre pressure, alternator torque,
-- GSE-T4 spark-plug gap). 12V battery + lug torque come from a flagged non-OEM reference.
--
-- Engines 2038 (GSE-T4 1.3T) + 187 (GME-T4 2.0T) — codes already correct.
--
-- Sources: 875 = Hornet OM (Mopar, public) — bulbs, fuses, maintenance, oil filter.
--          NEW svc = Tonale workshop service specs (tyre, alternator torque, plug gap).
--          NEW agg = flagged non-OEM reference (12V battery, lug + drain torque).

SET @g  := 339;
SET @om := 875;
SET @e13 := 2038;

INSERT INTO sources (type, citation, url, public_link, is_public, retrieved_at, notes) VALUES
  ('service_manual', 'Dodge Hornet / Alfa Romeo Tonale workshop service specifications', NULL, 0, 1, NOW(),
   'Workshop-grade service data for the shared Hornet/Tonale platform (cold tyre pressures + sizes, alternator torque, GSE-T4 spark-plug gap). Vendor-neutral per house policy.'),
  ('reference', 'Dodge Hornet aggregated service reference (non-OEM)', NULL, 0, 1, NOW(),
   '12V battery group/CCA and lug/drain torque. NOT OEM documentation: OM defers/omits these. Compiled from third-party battery-fitment references. Provenance flagged.');
SET @svc := (SELECT id FROM sources WHERE citation='Dodge Hornet / Alfa Romeo Tonale workshop service specifications' LIMIT 1);
SET @agg := (SELECT id FROM sources WHERE citation='Dodge Hornet aggregated service reference (non-OEM)' LIMIT 1);

-- 1. ELECTRICAL (flagged 12V; Hornet is PHEV/MHEV, HV battery noted separately)
INSERT INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES
  (@g, 'H5 / 47 (EFB)', 650, 60, NULL);

-- 2. BULBS (OM p269: all exterior + interior lighting is LED, dealer-serviced)
INSERT INTO bulbs (generation_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@g, 'Headlamp (low/high)',     'LED', 2, 1),
  (@g, 'Daytime running light',   'LED', 2, 1),
  (@g, 'Front turn signal',       'LED', 2, 1),
  (@g, 'Front fog lamp',          'LED', 2, 1),
  (@g, 'Rear tail/stop',          'LED', 2, 1),
  (@g, 'Rear turn signal',        'LED', 2, 1),
  (@g, 'Center high-mount stop',  'LED', 1, 1),
  (@g, 'License plate',           'LED', 2, 1),
  (@g, 'Interior dome/courtesy',  'LED', 2, 1);

-- 3. FUSES (OM p261-263; PHEV high-voltage + body fuses)
INSERT INTO fuses (generation_id, location, position, amperage, circuit_name, is_relay) VALUES
  (@g, 'PDC', 'F01',  5, 'Electric air heater (EAH)',              0),
  (@g, 'PDC', 'F03',  5, 'Integrated Dual Charge Module (IDCM)',   0),
  (@g, 'PDC', 'F04',  5, 'Charge Port Indicator Module (CPIM)',    0),
  (@g, 'PDC', 'F05', 15, 'Power Electronic Coolant Pump 2',        0),
  (@g, 'PDC', 'F07',  5, 'Auxiliary heater pump (AHP)',            0),
  (@g, 'PDC', 'F08',  5, 'Power Inverter Module feed 1',           0),
  (@g, 'PDC', 'F09', 10, 'Battery Pack Control Module feed 1',     0),
  (@g, 'PDC', 'F11', 10, 'Battery Pack Control Module feed 2',     0),
  (@g, 'PDC', 'F12',  5, 'Electronic Pedestrian Protection Module',0),
  (@g, 'PDC', 'T03', 30, 'Horn',                                   1),
  (@g, 'PDC', 'T05', 30, 'A/C compressor',                         1),
  (@g, 'PDC', 'T07', 50, 'Aux.1 / DTCM',                           0),
  (@g, 'PDC', 'T08', 30, 'HVAC fan',                               1);

-- 4. TORQUE (alternator from Tonale service data; lug + drain flagged)
INSERT INTO torque_specs (generation_id, engine_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@g, @e13, 'Alternator bracket bolt', 50,  37, '1.3L GSE-T4 (Tonale service data): 45-55 N·m.'),
  (@g, NULL,  'Wheel lug nut',          150, 110, 'M12 lug ~150 N·m (Giorgio/small-wide platform) — aggregated reference, NOT OEM documentation.'),
  (@g, NULL,  'Engine oil drain plug',   25,  18, 'Generic M12 drain-plug torque ~25 N·m — aggregated reference, NOT OEM documentation.');

-- 5. SERVICE INTERVALS (OM)
INSERT INTO service_intervals (generation_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@g, 'engine_oil_and_filter', NULL, 4000, NULL, 6500, 12, 'OM: oil-change-indicator system; severe duty 4,000 mi.'),
  (@g, 'tire_rotation',         NULL, NULL, NULL, NULL, NULL, 'OM: rotate at every oil-change interval.'),
  (@g, 'brake_inspection',      NULL, NULL, NULL, NULL, NULL, 'OM: inspect pads, rotors, hoses, park brake at every oil change.'),
  (@g, 'engine_air_filter',     NULL, NULL, NULL, NULL, NULL, 'OM: inspect/replace engine air cleaner per chart.'),
  (@g, 'spark_plugs',           NULL, NULL, NULL, NULL, NULL, 'OM: mileage-based per maintenance chart (1.3L / 2.0L).'),
  (@g, 'coolant_flush',         NULL, NULL, NULL, NULL, 120, 'OM: long-life coolant per maintenance chart.'),
  (@g, 'transmission_at',       NULL, NULL, NULL, NULL, NULL, 'OM: 6-speed DCT (R/T) / 9-speed (GT) fluid per chart.');

-- 6. PARTS
INSERT INTO parts (generation_id, engine_id, part_type, part_number, source_brand, gap_mm, notes) VALUES
  (@g, @e13, 'spark_plug', 'Mopar (OE)', 'Mopar', 0.65, '1.3L GSE-T4: gap 0.65 mm (Tonale service data); Mopar plug, OE PN not printed.'),
  (@g, NULL,  'oil_filter', 'Mopar (OE)', 'Mopar', NULL, 'OM: Mopar Engine Oil Filter; OE PN not printed.');

-- 7. TIRE PRESSURES (Tonale workshop service data; front 2.4 bar / rear 2.2 bar)
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@g, 'front', 'normal', 35.0, 240, '235/50R18'),
  (@g, 'rear',  'normal', 32.0, 220, '235/50R18'),
  (@g, 'front', 'normal', 35.0, 240, '235/45R19'),
  (@g, 'rear',  'normal', 32.0, 220, '235/45R19');

-- citations
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @om FROM bulbs WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @om FROM fuses WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @om FROM service_intervals WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @om FROM parts WHERE generation_id=@g AND part_type='oil_filter';
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @svc FROM parts WHERE generation_id=@g AND part_type='spark_plug';
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @svc FROM torque_specs WHERE generation_id=@g AND engine_id IS NOT NULL;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @agg FROM torque_specs WHERE generation_id=@g AND engine_id IS NULL;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @agg FROM electrical_specs WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @svc FROM tire_pressures WHERE generation_id=@g;
