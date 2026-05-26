-- mig 483: CX-90 (KK, gen 95) — correct specs against the actual 2024 US owner's
-- manual (source 566). The rows already CITED the OM but carried lore values that
-- don't match it (capacities, intervals) — a citation-integrity miss. Verified
-- every value below against the PDF (Mazda-hosted, so source 566 -> public_link=1).
--
-- OM page 699 (capacities, e-Skyactiv-G 3.3T petrol), page 698 (lubricant specs),
-- pages 594-595 (scheduled maintenance), page 702 (all lights are LED).

SET @gen := 95;
SET @om := 566;

-- 1) Make the OM a clickable source (manufacturer domain).
UPDATE sources
   SET public_link = 1,
       url = 'https://www.mazdausa.com/siteassets/global-resources/vehicle-resources/owner-manuals/2024/cx-90/2024-cx-90-vehicle-owners-manual.pdf',
       retrieved_at = NOW()
 WHERE id = @om;

-- 2) Fluid capacities/specs (engine 160 = 3.3T petrol; drivetrain rows gen-wide).
UPDATE fluid_specs SET capacity_l=6.0, capacity_qt=6.3
 WHERE generation_id=@gen AND fluid_type='engine_oil' AND engine_id=160;
UPDATE fluid_specs SET capacity_l=10.2, capacity_qt=10.8,
       spec_standard='Mazda Long-life FL22 (green); high-output 11.3 L'
 WHERE generation_id=@gen AND fluid_type='coolant' AND engine_id=160;
UPDATE fluid_specs SET capacity_l=7.3, capacity_qt=7.7,
       spec_standard='Mazda Original Oil ATF-A7 (Mazda: periodic replacement unnecessary)'
 WHERE generation_id=@gen AND fluid_type='transmission_at';
UPDATE fluid_specs SET capacity_l=0.51, capacity_qt=0.54,
       spec_standard='Mazda Long Life Hypoid Gear Oil SG1'
 WHERE generation_id=@gen AND fluid_type='transfer_case';
UPDATE fluid_specs SET capacity_l=0.90, capacity_qt=1.0,
       spec_standard='Mazda Long Life Hypoid Gear Oil SG1'
 WHERE generation_id=@gen AND fluid_type='rear_differential';

-- front differential was missing
INSERT INTO fluid_specs (generation_id, fluid_type, capacity_l, capacity_qt, spec_standard)
VALUES (@gen, 'front_differential', 0.35, 0.37, 'Mazda Long Life Hypoid Gear Oil SG1');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', id, @om FROM fluid_specs WHERE generation_id=@gen AND fluid_type='front_differential';

-- 3) Bulbs — OM: "All the light bulbs are the LED type." Two rows were wrongly
-- halogen (aggregator guess).
UPDATE bulbs SET bulb_code='LED', led_from_factory=1
 WHERE generation_id=@gen AND position='reverse' AND bulb_code='921 (W16W)';
UPDATE bulbs SET bulb_code='LED', led_from_factory=1
 WHERE generation_id=@gen AND position='turn_rear' AND bulb_code='WY21W';

-- 4) Scheduled-maintenance intervals (OM pages 594-595, normal driving).
UPDATE service_intervals SET miles_normal=10000, km_normal=16000, miles_severe=5000, km_severe=8000
 WHERE generation_id=@gen AND service='engine_oil_and_filter';
UPDATE service_intervals SET miles_normal=40000, km_normal=64000
 WHERE generation_id=@gen AND service='spark_plugs';
UPDATE service_intervals SET miles_normal=30000, km_normal=48000, months=24
 WHERE generation_id=@gen AND service='cabin_air_filter';
INSERT INTO service_intervals (generation_id, service, miles_normal, km_normal, months, notes)
VALUES (@gen, 'coolant_flush', 60000, 96000, 60, 'First replacement at 120,000 mi / 120 months, then every 60,000 mi / 60 months');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'service_intervals', id, @om FROM service_intervals WHERE generation_id=@gen AND service='coolant_flush';

-- backfill capacity_qt sanity already set above; ensure corrected bulbs/svc cite the OM
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'bulbs', id, @om FROM bulbs WHERE generation_id=@gen AND position IN ('reverse','turn_rear');
