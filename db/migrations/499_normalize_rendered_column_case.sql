-- 499: normalize casing on rendered short-token columns (audit follow-up to
-- migs 497/498). Minority case variants folded into the dominant convention.

-- generations.body_type — Title Case for words, uppercase for the SUV acronym
-- (dominant: Sedan 61 / SUV 91 / Coupe 40 / Pickup 7 / Roadster 2 / Liftback 1).
UPDATE generations SET body_type = CASE BINARY body_type
    WHEN 'sedan' THEN 'Sedan'
    WHEN 'coupe' THEN 'Coupe'
    WHEN 'suv' THEN 'SUV'
    WHEN 'pickup' THEN 'Pickup'
    WHEN 'roadster' THEN 'Roadster'
    WHEN 'liftback' THEN 'Liftback'
    ELSE body_type END
WHERE BINARY body_type IN ('sedan','coupe','suv','pickup','roadster','liftback');

-- transmissions.type — canonical acronyms. Also correctness: the trim page
-- matches transmission_* fluid rows on the MT/AT/CVT/DCT token, so the word/
-- lowercase forms ('automatic','manual','cvt','dct') can mis-filter.
UPDATE transmissions SET type = CASE BINARY type
    WHEN 'automatic' THEN 'AT'
    WHEN 'manual' THEN 'MT'
    WHEN 'cvt' THEN 'CVT'
    WHEN 'dct' THEN 'DCT'
    ELSE type END
WHERE BINARY type IN ('automatic','manual','cvt','dct');

-- engines.aspiration — lowercase words, NA acronym uppercase
-- (dominant: turbo 538 / NA 316 / supercharged 10 / twin-turbo 37).
UPDATE engines SET aspiration = CASE BINARY aspiration
    WHEN 'na' THEN 'NA'
    WHEN 'Turbo' THEN 'turbo'
    WHEN 'Twin-turbo' THEN 'twin-turbo'
    ELSE aspiration END
WHERE BINARY aspiration IN ('na','Turbo','Twin-turbo');
