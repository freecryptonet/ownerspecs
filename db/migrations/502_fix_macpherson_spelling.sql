-- 502: fix the "McPherson" misspelling in suspension descriptors.
-- The strut is named after Earle S. MacPherson; "McPherson" is a common
-- misspelling (37 front-suspension rows had it vs 16 correct "MacPherson").
-- This is a correctness fix, not a style choice. The broader phrasing variety
-- in front/rear_suspension + brakes ("MacPherson strut" vs "Independent type
-- MacPherson", mixed in/mm units) is freeform editorial content, left as-is.
UPDATE generations SET front_suspension = REPLACE(front_suspension, 'McPherson', 'MacPherson')
WHERE front_suspension LIKE '%McPherson%';
UPDATE generations SET rear_suspension = REPLACE(rear_suspension, 'McPherson', 'MacPherson')
WHERE rear_suspension LIKE '%McPherson%';
