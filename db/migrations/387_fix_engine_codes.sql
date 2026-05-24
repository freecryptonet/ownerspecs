-- mig 387: correct engine code/name errors introduced this session (flagged by Tim)
--
-- THREE accuracy errors:
-- 1. "Hurricane" mislabel: the 2.0L turbo I4 (engines 187, 203) and 1.3L turbo
--    (engine 2038) were named "Hurricane". WRONG. "Hurricane" is the 3.0L twin-turbo
--    inline-SIX (Wagoneer/Ram 1500 2022+). The 2.0L turbo is GME-T4 (Global Medium
--    Engine, 4-cyl); the 1.3L turbo is GSE-T4 (Global Small Engine / FireFly).
--    Stellantis only began marketing the 2.0L as "Hurricane 4" in 2024 — anachronistic
--    for Wrangler JL (2018+), Cherokee KL, Compass MP.
-- 2. engine 2043 (4.0L SOHC V6) note said "EER-related" — wrong; EER is the 2.7L V6.
--    The 4.0L is EGQ, a PowerTech (EKG)-derived bored/stroked design.
-- 3. engine 187 display baked in "eTorque MHEV" — that's a trim-level feature
--    (Wrangler JL 2.0T has eTorque; Cherokee/Compass 2.0T do not). Removed from the
--    engine-level name.

-- 1. 2.0L GME-T4 turbo (shared: Wrangler JL, Gladiator, Cherokee KL, Compass MP)
UPDATE engines SET
    code = 'GME-T4 2.0T',
    display_name = 'Stellantis GME-T4 2.0L I4 turbo (Global Medium Engine; "Hurricane 4" branding from 2024)'
  WHERE id = 187;

-- 2. 2.0L GME-T4 in 4xe PHEV configuration (GC WL 4xe, Wrangler JL 4xe)
UPDATE engines SET
    code = 'GME-T4 2.0T PHEV',
    display_name = 'Stellantis GME-T4 2.0L turbo PHEV (4xe; Global Medium Engine + electric)'
  WHERE id = 203;

-- 3. 1.3L GSE-T4 turbo (Renegade BU, Hornet R/T PHEV, intl Compass/500X)
UPDATE engines SET
    code = 'GSE-T4 1.3T',
    display_name = 'Stellantis GSE-T4 1.3L I4 turbo (Global Small Engine / FireFly)'
  WHERE id = 2038;

-- 4. 4.0L SOHC V6 — correct the engine-code note (EGQ, not EER-related)
UPDATE engines SET
    display_name = 'Chrysler 4.0L SOHC V6 (EGQ; PowerTech-derived, Nitro R/T)'
  WHERE id = 2043;

-- 5. 3.6L Pentastar (id 138) — display was bare "Pentastar"; clarify
UPDATE engines SET
    display_name = 'Chrysler 3.6L Pentastar V6 (ERB/ERC/ERG)'
  WHERE id = 138 AND display_name = 'Pentastar';
