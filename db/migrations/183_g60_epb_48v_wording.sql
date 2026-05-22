-- Cosmetic body_md refinement on the EPB procedure: the G30 LCI-era wording
-- "On vehicles with 48V mild-hybrid systems (any G30 LCI mHev variant) the
-- additional 48V battery must also be active" was carried verbatim onto G60
-- + i5 by mig 177's clone. On G60 all variants have 48V — the wording reads
-- awkwardly when a G60 owner looking at the procedure sees a G30 LCI mHev
-- caveat aimed at them. Updated to a phrase that covers both generations.

SET NAMES utf8mb4;

UPDATE procedures
SET body_md = REPLACE(body_md,
  'On vehicles with 48V mild-hybrid systems (any G30 LCI mHev variant) the additional 48V battery must also be active',
  'On vehicles with 48V mild-hybrid systems (all G60 mHev + PHEV variants; G30 LCI mHev models from MY2021) the additional 48V battery must also be active')
WHERE generation_id IN (128, 129) AND slug = 'epb-service-mode';
