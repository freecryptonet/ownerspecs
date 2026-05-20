-- Delete orphan fluid_specs rows.
-- Background: an earlier ingestion path inserted partial rows (capacity_l
-- only) into fluid_specs. Later batches re-added the same fluid_type with
-- the full spec set, producing 2 rows per (gen, fluid_type) on 40+ gens.
-- The orphans render as empty rows in the oil-capacity / coolant tables.
--
-- Pattern: orphan = capacity_qt + viscosity + spec_standard + filter_part_no
-- + notes all NULL, AND another row exists for the same (gen, fluid_type)
-- with at least one of those fields set.

SET NAMES utf8mb4;

DELETE ss FROM spec_sources ss
INNER JOIN fluid_specs o ON ss.spec_table='fluid_specs' AND ss.spec_id=o.id
WHERE o.capacity_qt IS NULL
  AND o.viscosity IS NULL
  AND o.spec_standard IS NULL
  AND o.filter_part_no IS NULL
  AND o.notes IS NULL
  AND o.trim_id IS NULL
  AND EXISTS (
    SELECT 1 FROM (SELECT id, generation_id, fluid_type, capacity_qt, viscosity, spec_standard FROM fluid_specs) g
    WHERE g.generation_id = o.generation_id
      AND g.fluid_type = o.fluid_type
      AND g.id <> o.id
      AND (g.capacity_qt IS NOT NULL OR g.viscosity IS NOT NULL OR g.spec_standard IS NOT NULL)
  );

DELETE o FROM fluid_specs o
WHERE o.capacity_qt IS NULL
  AND o.viscosity IS NULL
  AND o.spec_standard IS NULL
  AND o.filter_part_no IS NULL
  AND o.notes IS NULL
  AND o.trim_id IS NULL
  AND EXISTS (
    SELECT 1 FROM (SELECT id, generation_id, fluid_type, capacity_qt, viscosity, spec_standard FROM fluid_specs) g
    WHERE g.generation_id = o.generation_id
      AND g.fluid_type = o.fluid_type
      AND g.id <> o.id
      AND (g.capacity_qt IS NOT NULL OR g.viscosity IS NOT NULL OR g.spec_standard IS NOT NULL)
  );

SELECT 'Orphan dedupe done' AS status, COUNT(*) AS fluid_rows FROM fluid_specs;
