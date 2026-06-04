-- 576: Scrub "via manualslib" from rendered source citations — violates the
-- never-name-vendor rule (manualslib is an aggregator that must not appear in
-- any rendered column). 4 public source rows leaked it. Preserve the page
-- number / chassis code; drop only the vendor parenthetical.

UPDATE sources SET citation = "Honda Civic Sedan 2022 Owner's Manual, p.668" WHERE id = 595;
UPDATE sources SET citation = "Mazda CX-50 2024 Owner's Manual, p.571"      WHERE id = 596;
UPDATE sources SET citation = "Jeep Wrangler 2020 Owner's Manual (JL)"       WHERE id = 599;
UPDATE sources SET citation = "RAM 1500 2020 Owner's Manual (DT)"            WHERE id = 600;

-- Defensive sweep: strip the substring from any other citation/notes that has it.
UPDATE sources SET citation = TRIM(REPLACE(REPLACE(citation, ' (via manualslib)', ''), 'via manualslib', ''))
  WHERE citation LIKE '%manualslib%';
UPDATE sources SET notes = TRIM(REPLACE(REPLACE(notes, ' (via manualslib)', ''), 'via manualslib', ''))
  WHERE notes LIKE '%manualslib%';
