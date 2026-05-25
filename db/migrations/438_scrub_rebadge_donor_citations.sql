-- 438: Scrub Toyota donor-manual citations from the Suzuki rebadge gens (sibling/donor rule).
-- Across (321) = RAV4 (donor SM 40); Swace (329) = Corolla (donor SM 32).
-- The donor SM was leaking "Toyota RAV4 / Corolla" into the rendered Sources block. Cite ONLY
-- the Suzuki OM publicly (donor SM + HaynesPro stay as internal, unrendered cross-check).
-- Step 1: make sure the Suzuki OM cites every rendered row (so nothing loses its citation when
-- the donor link is dropped). Step 2: delete the donor SM links for these gens.

-- ===== Across (gen 321) -> Suzuki Across OM (845); drop RAV4 SM (40) =====
SET @g=321; SET @om=845; SET @donor=40;
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'fluid_specs',       id,@om FROM fluid_specs       WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'electrical_specs',  id,@om FROM electrical_specs  WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'torque_specs',      id,@om FROM torque_specs      WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',    id,@om FROM tire_pressures    WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'bulbs',             id,@om FROM bulbs             WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'fuses',             id,@om FROM fuses             WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'service_intervals', id,@om FROM service_intervals WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'parts',             id,@om FROM parts             WHERE generation_id=@g;
DELETE ss FROM spec_sources ss JOIN fluid_specs       t ON ss.spec_table='fluid_specs'       AND ss.spec_id=t.id WHERE t.generation_id=@g AND ss.source_id=@donor;
DELETE ss FROM spec_sources ss JOIN electrical_specs  t ON ss.spec_table='electrical_specs'  AND ss.spec_id=t.id WHERE t.generation_id=@g AND ss.source_id=@donor;
DELETE ss FROM spec_sources ss JOIN torque_specs      t ON ss.spec_table='torque_specs'      AND ss.spec_id=t.id WHERE t.generation_id=@g AND ss.source_id=@donor;
DELETE ss FROM spec_sources ss JOIN tire_pressures    t ON ss.spec_table='tire_pressures'    AND ss.spec_id=t.id WHERE t.generation_id=@g AND ss.source_id=@donor;
DELETE ss FROM spec_sources ss JOIN bulbs             t ON ss.spec_table='bulbs'             AND ss.spec_id=t.id WHERE t.generation_id=@g AND ss.source_id=@donor;
DELETE ss FROM spec_sources ss JOIN fuses             t ON ss.spec_table='fuses'             AND ss.spec_id=t.id WHERE t.generation_id=@g AND ss.source_id=@donor;
DELETE ss FROM spec_sources ss JOIN service_intervals t ON ss.spec_table='service_intervals' AND ss.spec_id=t.id WHERE t.generation_id=@g AND ss.source_id=@donor;
DELETE ss FROM spec_sources ss JOIN parts             t ON ss.spec_table='parts'             AND ss.spec_id=t.id WHERE t.generation_id=@g AND ss.source_id=@donor;

-- ===== Swace (gen 329) -> Suzuki Swace OM (846); drop Corolla SM (32) =====
SET @g=329; SET @om=846; SET @donor=32;
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'fluid_specs',       id,@om FROM fluid_specs       WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'electrical_specs',  id,@om FROM electrical_specs  WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'torque_specs',      id,@om FROM torque_specs      WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',    id,@om FROM tire_pressures    WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'bulbs',             id,@om FROM bulbs             WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'fuses',             id,@om FROM fuses             WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'service_intervals', id,@om FROM service_intervals WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'parts',             id,@om FROM parts             WHERE generation_id=@g;
DELETE ss FROM spec_sources ss JOIN fluid_specs       t ON ss.spec_table='fluid_specs'       AND ss.spec_id=t.id WHERE t.generation_id=@g AND ss.source_id=@donor;
DELETE ss FROM spec_sources ss JOIN electrical_specs  t ON ss.spec_table='electrical_specs'  AND ss.spec_id=t.id WHERE t.generation_id=@g AND ss.source_id=@donor;
DELETE ss FROM spec_sources ss JOIN torque_specs      t ON ss.spec_table='torque_specs'      AND ss.spec_id=t.id WHERE t.generation_id=@g AND ss.source_id=@donor;
DELETE ss FROM spec_sources ss JOIN tire_pressures    t ON ss.spec_table='tire_pressures'    AND ss.spec_id=t.id WHERE t.generation_id=@g AND ss.source_id=@donor;
DELETE ss FROM spec_sources ss JOIN bulbs             t ON ss.spec_table='bulbs'             AND ss.spec_id=t.id WHERE t.generation_id=@g AND ss.source_id=@donor;
DELETE ss FROM spec_sources ss JOIN fuses             t ON ss.spec_table='fuses'             AND ss.spec_id=t.id WHERE t.generation_id=@g AND ss.source_id=@donor;
DELETE ss FROM spec_sources ss JOIN service_intervals t ON ss.spec_table='service_intervals' AND ss.spec_id=t.id WHERE t.generation_id=@g AND ss.source_id=@donor;
DELETE ss FROM spec_sources ss JOIN parts             t ON ss.spec_table='parts'             AND ss.spec_id=t.id WHERE t.generation_id=@g AND ss.source_id=@donor;
