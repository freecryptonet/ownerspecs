-- Source-notes correction: 4 source rows incorrectly claim that the
-- referenced Audi owner's manual "confirms G13 coolant" — but the actual
-- manuals (verified 2026-05-23 against ownersmanual.audi.com directly,
-- A6 C8 part 4K1012720AF) list G12EVO (TL 774 L), not G13.
--
-- These notes were written in mig 193 (A4 B9 HaynesPro inhaal-pull) and
-- mig 198 (A6 C8 HaynesPro inhaal-pull) — both pre-real-source-verification.
-- Per the citation discipline rule established in
-- [[feedback-data-sources-hierarchy]], the notes field on a source row
-- should describe what the source ACTUALLY says, not lore.
--
-- Affected source rows:
--   688 — Audi A4 2020 Owner's Manual
--   689 — Audi A4 2024 Owner's Manual
--   710 — Audi A6 2020 Owner's Manual
--   711 — Audi A6 2024 Owner's Manual

SET NAMES utf8mb4;

UPDATE sources SET notes = 'Confirms Audi LongLife oil recommendation. Coolant spec on the B9 platform is G12EVO (TL 774 L) per the manual''s Service section. 552 pages.' WHERE id = 688;
UPDATE sources SET notes = 'Final-year B9 LCI owner''s manual. Confirms VW 508.00 LongLife IV FE 0W-20 engine oil and G12EVO (TL 774 L) coolant. 624 pages.' WHERE id = 689;
UPDATE sources SET notes = 'Pre-LCI C8 owner''s manual. Confirms Audi LongLife oil recommendation (VW 504.00 5W-30 pre-MHEV variants) and G12EVO (TL 774 L) coolant — verified against the official ownersmanual.audi.com portal 2026-05-23. 316 pages.' WHERE id = 710;
UPDATE sources SET notes = 'LCI C8 owner''s manual. Confirms VW 508.00 LongLife IV FE 0W-20 across MHEV variants and G12EVO (TL 774 L) coolant — verified against the official ownersmanual.audi.com portal 2026-05-23. 346 pages.' WHERE id = 711;

-- ----------------------------------------------------------------------------
-- Also clean the audit-trail string from the regular A6 coolant rows
-- (same leak pattern as the A4 B9 fix in mig 205) — mig 202 used CONCAT
-- to leave the migration-trail in the notes, which renders publicly.
-- ----------------------------------------------------------------------------
UPDATE fluid_specs fs
JOIN generations g ON g.id = fs.generation_id
SET fs.notes = NULL
WHERE g.family_slug = 'audi-a6-c8-2018-present'
  AND g.model_id = (SELECT id FROM models WHERE slug = 'a6')
  AND fs.fluid_type = 'coolant'
  AND fs.notes LIKE '%Corrected 2026-05-23%';

-- Audit
SELECT id, citation, LEFT(notes, 200) AS notes_head FROM sources WHERE id IN (688, 689, 710, 711);
