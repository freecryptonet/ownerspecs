-- A6 C8 family coolant — second source citation via the Audi official OM portal.
--
-- Yesterday's mig 202 corrected the coolant spec from G13 to G12EVO based
-- on a HaynesPro pull (source 709). Today we add the second source per the
-- two-source rule: the Audi-operated official owner's manual portal at
-- ownersmanual.audi.com, A6 C8 edition 4K1012720AF (06.2025), confirms the
-- exact same G12evo / TL 774 L specification.
--
-- This source is "manufacturer-owned domain" per the link-gating policy in
-- mig 194, so public_link = 1 — visitors get a clickable citation that
-- lands on the actual Audi site (the first real public link on these gens).
--
-- Verified at: https://ownersmanual.audi.com/app/rdw/module/S1VFSExNSVRURUw?language=en_GB
-- (URL is session-bound — direct deep-link requires going through the home
-- selector first; the URL above is documentary for the audit trail only.)
--
-- Applies to all 5 regular A6 family gens + 6 S/RS6 family gens (the entire
-- 4A chassis lineup shares this coolant spec per [[reference-audi-owners-manual-portal]]).

SET NAMES utf8mb4;

-- ----------------------------------------------------------------------------
-- 1. Add the Audi OM portal source row (public, clickable)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('Audi A6 Owner''s Manual (4K1012720AF, edition 06.2025)',
   'https://ownersmanual.audi.com/home/en_US',
   NOW(),
   'Official Audi-operated owner''s manual portal. C8 A6 (chassis code 4K) manual part number 4K1012720AF, edition June 2025. Verified 2026-05-23: Cooling system → Coolant section lists "Coolant additive: G12evo / Specification: TL 774 L" with frost-protection table 40-45% → -25 °C / 50-55% → -40 °C. The portal URL is session-bound; direct deep-link to the Coolant module is /app/rdw/module/S1VFSExNSVRURUw but requires prior part-number selection via the home page form. Manufacturer-owned domain → public_link enabled.',
   1, 1);

SET @s_audi_om := (SELECT id FROM sources WHERE url = 'https://ownersmanual.audi.com/home/en_US' AND citation LIKE '%4K1012720AF%');

-- ----------------------------------------------------------------------------
-- 2. Link this source to all coolant rows in the A6 C8 family
--    (regular A6 + S6 + RS6 — all share the 4A chassis coolant spec)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_audi_om
FROM fluid_specs fs
JOIN generations g ON g.id = fs.generation_id
WHERE g.family_slug = 'audi-a6-c8-2018-present'
  AND fs.fluid_type = 'coolant';

-- ----------------------------------------------------------------------------
-- 3. Audit
-- ----------------------------------------------------------------------------
SELECT g.slug,
       fs.capacity_l, fs.spec_standard,
       (SELECT COUNT(DISTINCT ss.source_id) FROM spec_sources ss
          JOIN sources s ON s.id = ss.source_id
         WHERE ss.spec_table = 'fluid_specs' AND ss.spec_id = fs.id AND s.is_public = 1) AS public_source_count
FROM fluid_specs fs
JOIN generations g ON g.id = fs.generation_id
WHERE g.family_slug = 'audi-a6-c8-2018-present'
  AND fs.fluid_type = 'coolant'
ORDER BY g.start_year, g.body_type, g.slug;
