-- BMW i5 G61 Touring (2024-present) — wagon BEV sibling of i5 sedan (gen 129).
--
-- BMW launched the i5 Touring at the same time as the G61 ICE Touring in
-- 2024. Same drivetrain options as the i5 sedan (eDrive40 RWD, xDrive40
-- AWD, M60 xDrive AWD) but in the wagon body. Range is slightly lower than
-- the sedan due to higher drag coefficient (~+5% WLTP penalty).

SET NAMES utf8mb4;

SET @gen_sedan := 129;  -- i5-g60-sedan-2023-present
SET @model_i5  := (SELECT id FROM models WHERE slug = 'i5');

INSERT INTO generations (
  model_id, slug, ordinal, codename, family_slug, family_label, display_name, body_type,
  start_year, end_year, layout, platform, editorial_intro,
  length_mm, width_mm, height_mm, wheelbase_mm,
  front_track_mm, rear_track_mm, fuel_tank_l, cargo_l,
  front_suspension, rear_suspension, front_brakes, rear_brakes,
  is_active
)
SELECT
  @model_i5,
  'i5-g61-touring-2024-present',
  ordinal,
  'G61',
  'bmw-5-series-g60-2023-present',
  'BMW 5 Series G60 family (2023-present)',
  'G61 Touring',
  'Estate',
  2024, NULL,
  layout,
  platform,
'The i5 Touring is BMW''s first fully-electric 5 Series wagon, launched alongside the G61 ICE Touring for the 2024 model year and built on the same CLAR-2 chassis as the i5 sedan. Mechanically the drivetrain is unchanged: same 81.2 kWh (net) lithium-ion floor-pack, same single-rear PMSM (eDrive40) or dual-motor (xDrive40 + M60 xDrive) layouts, and same DC fast-charge profile (up to 205 kW for the M60, 195 kW for the 40 variants). The wagon body adds 25–30 mm of height for cargo and brings drag coefficient to ~0.26 (sedan ~0.23–0.24), which costs roughly 5% of WLTP range vs the sedan.\n\nCargo is the defining wagon trade-off: 570 L upright / 1700 L folded — identical to the G61 ICE Touring. The HV battery and motor cooling circuits use BMW LC-18 coolant (the same long-life formula adopted across the G60 family); a 12V auxiliary lead-acid battery handles vehicle electronics with regenerative braking dominating wear-item life (brake pads + fluid last considerably longer than on an ICE wagon of the same weight). For maintenance specs see the i5 sedan page — all reduction-gear oil, brake fluid, and coolant volumes are identical.',
  5060, 1900, 1515, 2995,
  front_track_mm, rear_track_mm, NULL, 570,
  front_suspension, 'Multi-link, self-levelling air',
  front_brakes, rear_brakes,
  is_active
FROM generations
WHERE id = @gen_sedan;

SET @gen_touring := (SELECT id FROM generations WHERE slug = 'i5-g61-touring-2024-present');

-- Clone trims (all 3 i5 variants on Touring body)
INSERT INTO trims (generation_id, slug, name, engine_id, hp, torque_nm, zero_100_kmh_s, top_speed_kmh, drive_wheel, curb_weight_kg, start_year, end_year)
SELECT @gen_touring, slug, name, engine_id, hp, torque_nm, zero_100_kmh_s, top_speed_kmh, drive_wheel, curb_weight_kg, 2024, end_year
FROM trims WHERE generation_id = @gen_sedan;

-- Clone gen-wide spec data from i5 sedan
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, trim_id, market_id, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes)
SELECT @gen_touring, fluid_type, engine_id, trim_id, market_id, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes
FROM fluid_specs WHERE generation_id = @gen_sedan;

INSERT INTO torque_specs (generation_id, fastener, engine_id, trim_id, torque_nm, torque_ftlb, thread_lock, notes)
SELECT @gen_touring, fastener, engine_id, trim_id, torque_nm, torque_ftlb, thread_lock, notes
FROM torque_specs WHERE generation_id = @gen_sedan AND engine_id IS NULL;

INSERT INTO parts (generation_id, part_type, engine_id, trim_id, part_number, source_brand, gap_mm, size, notes)
SELECT @gen_touring, part_type, engine_id, trim_id, part_number, source_brand, gap_mm, size, notes
FROM parts WHERE generation_id = @gen_sedan AND engine_id IS NULL;

INSERT INTO service_intervals (generation_id, service, engine_id, trim_id, miles_normal, miles_severe, km_normal, km_severe, months, notes)
SELECT @gen_touring, service, engine_id, trim_id, miles_normal, miles_severe, km_normal, km_severe, months, notes
FROM service_intervals WHERE generation_id = @gen_sedan AND engine_id IS NULL;

INSERT INTO electrical_specs (generation_id, trim_id, market_id, battery_group, cca, ah, alternator_amps)
SELECT @gen_touring, trim_id, market_id, battery_group, cca, ah, alternator_amps
FROM electrical_specs WHERE generation_id = @gen_sedan;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory)
SELECT @gen_touring, market_id, position, bulb_code, quantity, led_from_factory
FROM bulbs WHERE generation_id = @gen_sedan;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name, is_relay)
SELECT @gen_touring, market_id, location, position, amperage, circuit_name, is_relay
FROM fuses WHERE generation_id = @gen_sedan;

INSERT INTO tire_pressures (generation_id, trim_id, market_id, position, load_condition, psi, kpa, tire_size)
SELECT @gen_touring, trim_id, market_id, position, load_condition, psi, kpa, tire_size
FROM tire_pressures WHERE generation_id = @gen_sedan AND trim_id IS NULL;

INSERT INTO procedures (generation_id, market_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT @gen_touring, market_id, procedure_type, slug, title, body_md, tools_required, common_mistakes
FROM procedures WHERE generation_id = @gen_sedan;

-- Retitle: i5 (G60) → i5 Touring (G61)
UPDATE procedures
SET title = REPLACE(title, 'i5 (G60)', 'i5 Touring (G61)')
WHERE generation_id = @gen_touring;

-- Clone spec_sources
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', f_new.id, ss.source_id
FROM fluid_specs f_old
JOIN fluid_specs f_new ON f_new.generation_id = @gen_touring
                     AND f_new.fluid_type = f_old.fluid_type
                     AND (f_new.engine_id <=> f_old.engine_id)
                     AND (f_new.capacity_l <=> f_old.capacity_l)
                     AND (f_new.viscosity <=> f_old.viscosity)
JOIN spec_sources ss ON ss.spec_table = 'fluid_specs' AND ss.spec_id = f_old.id
WHERE f_old.generation_id = @gen_sedan;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'procedures', p_new.id, ss.source_id
FROM procedures p_old
JOIN procedures p_new ON p_new.generation_id = @gen_touring AND p_new.slug = p_old.slug
JOIN spec_sources ss ON ss.spec_table = 'procedures' AND ss.spec_id = p_old.id
WHERE p_old.generation_id = @gen_sedan;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'trims', t_new.id, ss.source_id
FROM trims t_old
JOIN trims t_new ON t_new.generation_id = @gen_touring AND t_new.slug = t_old.slug
JOIN spec_sources ss ON ss.spec_table = 'trims' AND ss.spec_id = t_old.id
WHERE t_old.generation_id = @gen_sedan;
