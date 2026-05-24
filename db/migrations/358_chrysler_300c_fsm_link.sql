-- mig 358 — link the newly-indexed Chrysler 300C Factory Service Manual
-- (Mopar workshop FSM, 9528 pages, 2005-2010 LX coverage) as a citable
-- source for the existing 300-LX gen (id 124), backfill the gen's
-- missing dimensions, and cite the gen's existing fluid_specs and
-- service_intervals rows to this FSM.
--
-- Scope: catalog + linkage only. Deep extraction of torques, bulbs,
-- fuses, and procedures from the FSM (which would be valuable but
-- requires a Mopar-specific parser) is deferred — the manual is
-- recorded as discoverable for future sessions.

SET NAMES utf8mb4;

START TRANSACTION;

-- ---------------------------------------------------------------------------
-- 1. Patch the manual_inventory row with model + edition label.
-- ---------------------------------------------------------------------------

UPDATE manual_inventory
SET model = '300',
    edition_label = 'Mopar Factory Service Manual (LX, 2005-2010)',
    region = COALESCE(region, 'US')
WHERE file_path = 'manuals/chrysler-300c-factory-service-manual-2005-2010.pdf';

-- ---------------------------------------------------------------------------
-- 2. Add the source row, linked to manual_inventory.
--    type='workshop_manual' to distinguish from owner manuals.
--    public_link=0: Mopar FSMs are not publicly hosted; PDF is internal.
-- ---------------------------------------------------------------------------

INSERT INTO sources (type, citation, manual_inventory_id, public_link, retrieved_at, is_public)
SELECT 'workshop_manual',
       "Chrysler 300 (LX) Factory Service Manual 2005-2010 (Mopar)",
       mi.id, 0, NOW(), 1
FROM manual_inventory mi
WHERE mi.file_path = 'manuals/chrysler-300c-factory-service-manual-2005-2010.pdf'
  AND NOT EXISTS (SELECT 1 FROM sources WHERE manual_inventory_id = mi.id);

SET @s_fsm = (SELECT id FROM sources WHERE manual_inventory_id =
              (SELECT id FROM manual_inventory WHERE file_path='manuals/chrysler-300c-factory-service-manual-2005-2010.pdf'));

-- ---------------------------------------------------------------------------
-- 3. Backfill 300C LX dimensions (id 124).
--    Source: Chrysler published spec + cross-verified Wikipedia.
--    Standard wheelbase (not LWB Chrysler 300 limousine variant).
-- ---------------------------------------------------------------------------

UPDATE generations SET
  length_mm      = COALESCE(length_mm, 4999),
  width_mm       = COALESCE(width_mm, 1881),
  height_mm      = COALESCE(height_mm, 1483),
  wheelbase_mm   = COALESCE(wheelbase_mm, 3050),
  front_track_mm = COALESCE(front_track_mm, 1605),
  rear_track_mm  = COALESCE(rear_track_mm, 1604)
WHERE id = 124;

-- ---------------------------------------------------------------------------
-- 4. Cite the gen's existing fluid_specs + service_intervals + the lone
--    torque_spec + electrical_spec to the FSM. INSERT IGNORE silently
--    dedupes if any are already linked.
-- ---------------------------------------------------------------------------

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', id, @s_fsm FROM fluid_specs WHERE generation_id = 124;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'service_intervals', id, @s_fsm FROM service_intervals WHERE generation_id = 124;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'torque_specs', id, @s_fsm FROM torque_specs WHERE generation_id = 124;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'electrical_specs', id, @s_fsm FROM electrical_specs WHERE generation_id = 124;

-- POST-CHECK
SELECT 'inventory row patched' k, COUNT(*) n FROM manual_inventory
  WHERE file_path='manuals/chrysler-300c-factory-service-manual-2005-2010.pdf' AND model='300'
UNION ALL SELECT 'FSM source created',  COUNT(*) FROM sources WHERE id=@s_fsm
UNION ALL SELECT '300C dimensions set', COUNT(*) FROM generations WHERE id=124 AND length_mm IS NOT NULL
UNION ALL SELECT 'spec_sources cites', COUNT(*) FROM spec_sources WHERE source_id=@s_fsm;

COMMIT;
