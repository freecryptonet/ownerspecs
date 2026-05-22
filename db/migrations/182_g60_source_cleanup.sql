-- Further G60 source cleanup after mig 181.
--
-- Three remaining issues found during the post-mig-181 live audit:
--
-- 1. Source 656 (BMW US 2023 5 Series Manual — the G30 LCI MY2023 manual)
--    is cited on G60 rows. This came in via mig 174's HaynesPro procedure
--    additions (which used @s_lci_2023 = source 656) and was carried onto
--    G60 by mig 177's spec_sources JOIN. Source 656 must NOT cite G60
--    rows — the G30 LCI 2023 manual is not authoritative for G60.
--
-- 2. Source 668 is a duplicate of source 663 (same citation, different URL).
--    Source 663 was created in mig 176; source 668 in mig 181 because the
--    181 author didn't realise 663 existed. Re-cite all 668 usages to 663
--    and delete 668.
--
-- 3. Source 663 notes mention "i5 deferred to separate model entry" — that
--    is now stale since i5 was created in mig 178. Update notes.

SET NAMES utf8mb4;

-- ----------------------------------------------------------------------------
-- 1. Remove source 656 (G30 LCI 2023 manual) from G60 + i5 rows
-- ----------------------------------------------------------------------------
DELETE FROM spec_sources
WHERE source_id = 656
  AND (
    (spec_table = 'procedures' AND spec_id IN (SELECT id FROM procedures WHERE generation_id IN (128, 129)))
    OR (spec_table = 'fluid_specs' AND spec_id IN (SELECT id FROM fluid_specs WHERE generation_id IN (128, 129)))
    OR (spec_table = 'trims' AND spec_id IN (SELECT id FROM trims WHERE generation_id IN (128, 129)))
    OR (spec_table = 'bulbs' AND spec_id IN (SELECT id FROM bulbs WHERE generation_id IN (128, 129)))
    OR (spec_table = 'tire_pressures' AND spec_id IN (SELECT id FROM tire_pressures WHERE generation_id IN (128, 129)))
    OR (spec_table = 'torque_specs' AND spec_id IN (SELECT id FROM torque_specs WHERE generation_id IN (128, 129)))
  );

-- ----------------------------------------------------------------------------
-- 2. Re-cite source 668 usages to source 663, then delete 668
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT spec_table, spec_id, 663 FROM spec_sources WHERE source_id = 668;

DELETE FROM spec_sources WHERE source_id = 668;
DELETE FROM sources WHERE id = 668;

-- ----------------------------------------------------------------------------
-- 3. Refresh source 663 notes (i5 is no longer deferred)
-- ----------------------------------------------------------------------------
UPDATE sources
SET notes = '9-variant lineup with engine codes B47D20B / B48B20P / B48B16P / B48B20V / B57D30B / B58B30C; the BEV variants (i5 eDrive40 HA0, xDrive40 XE2, M60 xDrive XE2) live under the dedicated i5 model entry.'
WHERE id = 663;
