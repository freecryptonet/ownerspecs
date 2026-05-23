-- A4 B9 coolant rows — clean the `notes` field after mig 204's CONCAT
-- appended audit-trail text that's now leaking onto the public /coolant
-- page. Migration trail belongs in the SQL file comments, not in row notes.
--
-- MariaDB's REGEXP_REPLACE backslash-escapes behave differently than POSIX —
-- the regex approach was unreliable. Direct REPLACE on the exact string
-- works.

SET NAMES utf8mb4;

UPDATE fluid_specs fs
JOIN generations g ON g.id = fs.generation_id
SET fs.notes = TRIM(REPLACE(fs.notes,
    ' Corrected 2026-05-23 from VW G13 to G12EVO (TL-VW 774L) per HaynesPro A4 B9 1.4 TFSI CVNA t_318011813 lubricants page. The B9 MLB Evo platform uses G12EVO from launch, not the earlier G13.',
    ''))
WHERE g.family_slug = 'audi-a4-b9-2015-2025'
  AND fs.fluid_type = 'coolant';

SELECT g.slug, fs.id, LEFT(COALESCE(fs.notes, '(NULL)'), 80) AS notes_head
FROM fluid_specs fs
JOIN generations g ON g.id = fs.generation_id
WHERE g.family_slug = 'audi-a4-b9-2015-2025'
  AND fs.fluid_type = 'coolant'
ORDER BY g.start_year, fs.id;
