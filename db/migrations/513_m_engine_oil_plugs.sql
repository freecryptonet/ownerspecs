-- mig 513: engine-scoped oil capacity + spark plugs for the Suzuki M-engines
-- (M13A 2071, M15A 2070, M16A 2069) on the Swift ZC (348) and SX4 (349) gens.
-- Cross-checked (HKS application chart + engine-specs.net + AUTODOC for oil; NGK IFR6J11
-- confirmed across M13A/M15A/M16A via oreca/eBay cross-fitment/strperformance).
-- Surfaces oil + plug on the /engines/* pages and the engine-vs-engine comparison.

-- fix the SX4 source name (model was renamed from "SX4 S-Cross" in mig 512)
UPDATE sources SET citation='Suzuki SX4 Service Manual' WHERE id=1036;

-- drop the thin scraper engine_oil rows (NULL engine, capacity-only) we're replacing
DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (8856, 8858);
DELETE FROM fluid_specs WHERE id IN (8856, 8858);

-- engine-scoped engine oil
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, notes) VALUES
(348, 2071, 'engine_oil', 3.7, 3.91, '5W-30', 'API SL/SM', 'With filter'),
(348, 2070, 'engine_oil', 3.8, 4.02, '5W-30', 'API SL/SM', 'With filter (0W-20 acceptable)'),
(348, 2069, 'engine_oil', 4.2, 4.44, '5W-30', 'API SL/SM', 'With filter (0W-20 acceptable)'),
(349, 2070, 'engine_oil', 3.8, 4.02, '5W-30', 'API SL/SM', 'With filter (0W-20 acceptable)'),
(349, 2069, 'engine_oil', 4.2, 4.44, '5W-30', 'API SL/SM', 'With filter (0W-20 acceptable)');

-- spark plugs (NGK IFR6J11 iridium, 1.1 mm gap — common across the M-family)
INSERT INTO parts (generation_id, engine_id, part_type, part_number, source_brand, gap_mm, notes) VALUES
(348, 2071, 'spark_plug', 'IFR6J11', 'NGK', 1.1, 'Iridium'),
(348, 2070, 'spark_plug', 'IFR6J11', 'NGK', 1.1, 'Iridium'),
(348, 2069, 'spark_plug', 'IFR6J11', 'NGK', 1.1, 'Iridium'),
(349, 2070, 'spark_plug', 'IFR6J11', 'NGK', 1.1, 'Iridium'),
(349, 2069, 'spark_plug', 'IFR6J11', 'NGK', 1.1, 'Iridium');

-- citations (348 -> Suzuki Swift SM 1026, 349 -> Suzuki SX4 SM 1036)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, 1026 FROM fluid_specs WHERE generation_id=348 AND fluid_type='engine_oil';
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, 1036 FROM fluid_specs WHERE generation_id=349 AND fluid_type='engine_oil';
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'parts', id, 1026 FROM parts WHERE generation_id=348 AND part_type='spark_plug';
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'parts', id, 1036 FROM parts WHERE generation_id=349 AND part_type='spark_plug';
