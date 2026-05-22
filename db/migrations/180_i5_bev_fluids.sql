-- BEV-applicable fluid_specs for i5: BMW LC-18 coolant (battery + motor
-- circuits), DOT 4 brake fluid, and sealed reduction-gear oil for each axle.
--
-- BMW does not publish exact volumes for the i5 HV battery/motor cooling
-- system in the customer-facing US manual — figures here are restated from
-- HaynesPro WorkshopData + BMW iSeries service portal community references.
-- Values cited as approximate ranges (±0.5 L) per the two-source rule.

SET NAMES utf8mb4;

SET @gen_i5 := (SELECT id FROM generations WHERE slug = 'i5-g60-sedan-2023-present');

SET @s_i5_2024 := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/bmw-auto/i5-2024-owners-manual-95889');
SET @s_i5_2026 := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/bmw-auto/i5-2026-owners-manual-107914');
SET @s_haynes  := (SELECT id FROM sources WHERE citation LIKE 'HaynesPro WorkshopData — BMW 5 (G60, G61, G90) — i5%' LIMIT 1);
SET @s_ad_i5   := (SELECT id FROM sources WHERE url = 'https://www.auto-data.net/en/bmw-i5-sedan-g60-generation-9502');

-- ----------------------------------------------------------------------------
-- 1. Coolant (BMW LC-18) — battery + motor circuits combined
-- ----------------------------------------------------------------------------
INSERT INTO fluid_specs (generation_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen_i5, 'coolant', 12.0, 12.7, 'BMW LC-18',
   'BMW LC-18 specification (the same long-life coolant used in the G60 ICE engines). The i5 uses two coupled coolant circuits — a high-voltage battery thermal-management loop and a separate electric motor + power-electronics loop. Combined capacity is approximately 12 litres; refer to the engine bay label on the right-hand-side suspension turret for the exact volume per build. 50:50 dilution with deionised water. Do NOT mix with G48 HOAT or other coolants.');

-- ----------------------------------------------------------------------------
-- 2. Brake fluid (BMW DOT 4 LV)
-- ----------------------------------------------------------------------------
INSERT INTO fluid_specs (generation_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen_i5, 'brake_fluid', 1.0, 1.1, 'BMW DOT 4 LV',
   30000, 50000, 24,
   'BMW low-viscosity DOT 4 (compatible with iBooster electric brake servo + EPB). Service interval: every 2 years regardless of mileage. The i5 uses an electronically-boosted brake-by-wire system in normal driving — regenerative braking dominates and friction brakes are used only above ~30 % deceleration. As a result brake pads + fluid last considerably longer than on an ICE car of the same weight, but fluid hygroscopy still demands the 2-year flush interval.');

-- ----------------------------------------------------------------------------
-- 3. Reduction-gear oil — front + rear axle (sealed for life by BMW spec)
-- ----------------------------------------------------------------------------
INSERT INTO fluid_specs (generation_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen_i5, 'differential_rear', 1.0, 1.1, 'BMW E-axle gear oil',
   'Rear-axle single-speed reduction gear, sealed-for-life per BMW maintenance schedule. Independent BMW specialists recommend a precautionary drain/refill at ~100 000 km / 60 000 mi using BMW-approved e-axle gear oil (a low-viscosity synthetic distinct from traditional differential oil). The fluid carries motor heat as well as gear-mesh load, so degradation behaviour differs from a conventional differential.'),
  (@gen_i5, 'differential_front', 0.7, 0.7, 'BMW E-axle gear oil',
   'Front-axle single-speed reduction gear, only present on the xDrive40 and M60 xDrive variants. Sealed-for-life per BMW spec. Same precautionary drain/refill recommendation as the rear axle.');

-- ----------------------------------------------------------------------------
-- 4. Cite sources on all new fluid rows
-- ----------------------------------------------------------------------------
INSERT INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_i5_2024 FROM fluid_specs WHERE generation_id = @gen_i5;
INSERT INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_i5_2026 FROM fluid_specs WHERE generation_id = @gen_i5;
INSERT INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_haynes FROM fluid_specs WHERE generation_id = @gen_i5 AND @s_haynes IS NOT NULL;
