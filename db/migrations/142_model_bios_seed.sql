-- Model bios seed — herstructureringsplan §3 Niveau 3.
--
-- Five hand-written ~140-160 word model bios. These render on the model
-- index page (e.g. /honda/civic) above the generation grid, lifting it
-- above a "thin hub" rank.
--
-- Same authoring rules as 141_editorial_intros_seed.sql: verifiable
-- historical facts, no spec numbers, no marketing claims. Matches by
-- (make_slug, model_slug) so the seed survives slug drift.

SET NAMES utf8mb4;

-- ----------------------------------------------------------------------------
-- Honda Civic
-- ----------------------------------------------------------------------------
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Honda Civic has been the company''s compact mainstay since the original two-door subcompact launched in July 1972 in Japan. Over eleven generations the Civic has grown from a 1.2-litre economy car to a global compact car platform spanning sedan, hatchback, coupe (discontinued after the tenth generation) and high-performance Type R variants.

The Civic established Honda''s reputation for high-revving four-cylinder engines, crisp manual gearboxes and chassis tuning that favoured driver engagement over isolation. It remains one of the longest-running automotive nameplates in continuous production and has been a perennial fixture on best-selling vehicle lists in North America, Japan and Asia. The current eleventh-generation Civic (chassis code FE for sedan, FL for hatchback) is built in Greensburg, Indiana for North America and at Yorii in Saitama, Japan for the home market.'
WHERE mk.slug = 'honda' AND m.slug = 'civic';

-- ----------------------------------------------------------------------------
-- Toyota Camry
-- ----------------------------------------------------------------------------
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Toyota Camry has been Toyota''s mid-size sedan since the standalone Camry replaced the Celica Camry compact in 1982 on the V10 chassis. Eight generations and four decades later it has been the best-selling passenger car in the United States for most years between 2002 and 2024, displaced only briefly by the Honda Accord and, in the late-2010s, by light trucks dominating the overall sales rank.

The Camry has historically prioritised refinement, longevity and low cost of ownership over driving engagement. The XV70 generation (2018-2024) marked Toyota''s most aggressive attempt to broaden that brief, introducing sharper styling and a stiffer TNGA-K platform. The ninth-generation Camry, launched for the 2025 model year, is hybrid-only across the lineup — the first time Toyota has eliminated a conventional gasoline option in the nameplate. North-American production runs at Toyota Motor Manufacturing Kentucky in Georgetown.'
WHERE mk.slug = 'toyota' AND m.slug = 'camry';

-- ----------------------------------------------------------------------------
-- BMW 3 Series
-- ----------------------------------------------------------------------------
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The BMW 3 Series replaced the 02 Series compact sport sedan in 1975 and has become the defining product of the BMW brand — the benchmark compact sport sedan against which the segment has measured itself for seven generations. The line debuted with the E21 (1975-1983) and progressed through E30, E36, E46, E90, F30 and G20 chassis codes.

The 3 Series has anchored BMW''s rear-wheel-drive, inline-six engineering identity for decades, though four-cylinder variants and all-wheel-drive xDrive options have been available throughout most of its history. Body variants include sedan, coupe (split off as the 4 Series after 2014), Touring estate, Compact (E36 and E46), convertible (also separated to the 4 Series) and the long-wheelbase Li sedan sold primarily in China. The M3 high-performance variant has run continuously since the E30 generation. The current G20 entered production in 2018; its facelifted LCI arrived in 2022.'
WHERE mk.slug = 'bmw' AND m.slug = '3-series';

-- ----------------------------------------------------------------------------
-- Ford F-150
-- ----------------------------------------------------------------------------
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Ford F-150 is the half-ton variant of the Ford F-Series, which has been the best-selling truck in the United States every year since 1977 and the best-selling vehicle of any kind in the United States every year since 1982. The F-150 nameplate has been continuous since the 1975 model year, when Ford added a half-ton model between the F-100 and F-250 to qualify for a different emissions standard.

Across fourteen generations the F-150 has expanded from a body-on-frame work truck into a flagship range spanning a Lariat-and-above premium tier (King Ranch, Platinum, Limited), an electric variant (Lightning, 2022 onwards) and a high-performance off-road variant (Raptor, 2010 onwards, with a supercharged Raptor R added in 2023). The thirteenth and fourteenth generations introduced aluminium-intensive body construction. Production is concentrated at the Dearborn Truck Plant in Michigan and the Kansas City Assembly Plant in Missouri.'
WHERE mk.slug = 'ford' AND m.slug = 'f-150';

-- ----------------------------------------------------------------------------
-- Tesla Model 3
-- ----------------------------------------------------------------------------
UPDATE models m
JOIN makes mk ON mk.id = m.make_id
SET m.bio =
'The Tesla Model 3 is the company''s smaller sedan, positioned below the Model S as Tesla''s mass-market product. It was unveiled in March 2016, entered customer deliveries in July 2017, reached European customers in 2019 and the first China-built Model 3s rolled off the line at Giga Shanghai in late 2019.

The Model 3 was designed to scale Tesla''s production volume by an order of magnitude over the Model S, using a simpler platform, a stripped-back interior centred on a single 15-inch touchscreen and (initially) a single visible variant rather than the per-trim badging of the Model S. The Model 3 has been Tesla''s highest-volume vehicle for most of its production run and has anchored the company''s revenue and profitability since 2018. A heavily revised version (internally Highland) launched in late 2023 with redesigned exterior, suspension and interior. Production runs at Tesla''s Fremont, California plant and Giga Shanghai.'
WHERE mk.slug = 'tesla' AND m.slug = 'model-3';
