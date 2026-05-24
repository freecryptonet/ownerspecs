-- mig 404: scrub remaining "Tonale" sibling-brand references from rendered columns on the
-- Dodge Hornet (gen 339): mig 402 wrote "(Tonale service data)" into a torque note + a parts
-- note, and the pre-existing family_label named "(Tonale/Hornet)". Neutralize all.

UPDATE torque_specs SET notes = REPLACE(notes, 'Tonale service data', 'workshop service data')
  WHERE generation_id = 339 AND notes LIKE '%Tonale%';

UPDATE parts SET notes = REPLACE(notes, 'Tonale service data', 'workshop service data')
  WHERE generation_id = 339 AND notes LIKE '%Tonale%';

UPDATE generations SET family_label = 'Stellantis Small Wide Platform (Hornet)'
  WHERE family_slug = 'stellantis-small-wide-2022-present';
