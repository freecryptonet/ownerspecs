-- Editorial intros seed — herstructureringsplan §3 Niveau 4 #2.
--
-- Five hand-written ~140-170 word intros for the most-visited gens in the
-- catalogue: Civic FE, Camry XV70, BMW G20 3-Series, F-150 P702, Model 3.
-- Strict rules followed:
--   * No spec numbers (HP, dimensions, prices) — those live in the spec tables
--     and would rot when data is refined.
--   * Verifiable historical facts only (launch year, codename meaning,
--     platform, predecessor, succession, production location).
--   * No marketing claims ("best driving", "premium feel") — straight prose.
--
-- UPDATE matches by (make_slug, model_slug, start_year) so the seed survives
-- minor gen-slug drift. Rows with no matching gen are silent no-ops.

SET NAMES utf8mb4;

-- ----------------------------------------------------------------------------
-- Honda Civic FE / FL — 11th generation (2022-)
-- ----------------------------------------------------------------------------
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The eleventh-generation Civic launched for the 2022 model year, internally designated FE for the sedan and FL for the hatchback. It returned to the longer, lower silhouette established by the tenth-generation FC, but with cleaner, more conservative surfaces — Honda dropped the segmented bumper detailing of the previous car in favour of a single cohesive front mask.

Three drivetrains anchor the range: the L15B7 1.5-litre turbocharged four on Sport and Touring, the K20C2 2.0-litre naturally aspirated four on LX and EX, and from the 2025 model year a hybrid variant using the e:HEV two-motor system shared with the Accord. The Si returns on the L15B7 with a six-speed manual; the Type R FL5 sits at the top of the range. North-American Civics are produced at Honda Manufacturing of Indiana in Greensburg.'
WHERE mk.slug = 'honda' AND m.slug = 'civic' AND g.start_year = 2022;

-- ----------------------------------------------------------------------------
-- Toyota Camry XV70 — 8th generation (2018-2024)
-- ----------------------------------------------------------------------------
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The eighth-generation Camry debuted in late 2017 for the 2018 model year as the first Camry built on Toyota''s TNGA-K platform. The XV70 marked a substantial visual departure from its conservative predecessors with a more aggressive coupe-like silhouette, a markedly lower seating position, and a wider track. Toyota explicitly emphasised driving dynamics for the first time in the nameplate''s history.

Powertrains include the A25A-FKS 2.5-litre four with Dynamic Force technology, the 2GR-FKS 3.5-litre V6 (later dropped from some markets), and the A25A-FXS in hybrid form running the Toyota Hybrid System II. A facelift arrived for the 2021 model year with revised front-end styling, an optional all-wheel-drive variant on the 2.5-litre four, and Toyota Safety Sense 2.5+ standard across the lineup. The XV70 was built at Toyota Motor Manufacturing Kentucky in Georgetown for North America; the ninth-generation Camry replaced it for 2025 as hybrid-only.'
WHERE mk.slug = 'toyota' AND m.slug = 'camry' AND g.start_year = 2018;

-- ----------------------------------------------------------------------------
-- BMW 3 Series G20 — 7th generation (2019-)
-- ----------------------------------------------------------------------------
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The seventh-generation 3 Series debuted in October 2018 for the 2019 model year, internally designated G20. Built on BMW''s CLAR (Cluster Architecture) platform shared with the 5 Series and X3, the G20 grew slightly in every external dimension over the F30 but used more aluminium and high-strength steel to reduce body weight. BMW returned to a more conventional 3 Series silhouette after the F30 styling, with a longer hood line and L-shaped tail lamps that became a brand signature for the generation.

The petrol lineup centres on the B48 2.0-litre four (320i / 330i) and the B58 3.0-litre inline-six (M340i, with 48V mild hybrid from 2020); diesel variants use the B47. A plug-in hybrid 330e arrived in 2019. The M3 sits on the G80 chassis sharing the S58 inline-six. A facelift in 2022 introduced iDrive 8 on the new curved display and revised front-end LEDs. Production runs at the BMW Group Munich plant.'
WHERE mk.slug = 'bmw' AND m.slug = '3-series' AND g.start_year = 2019;

-- ----------------------------------------------------------------------------
-- Ford F-150 P702 — 14th generation (2021-)
-- ----------------------------------------------------------------------------
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The fourteenth-generation F-150 launched in autumn 2020 for the 2021 model year, internal program code P702. It retained its predecessor''s P552 aluminium-intensive body architecture but rebodied virtually every panel and significantly updated the chassis, interior and electrical architecture. The fourteenth generation also introduced the F-150 Lightning fully electric variant in 2022.

The conventional powertrain lineup includes the 3.3-litre naturally aspirated V6, the 2.7- and 3.5-litre EcoBoost twin-turbo V6s, the 5.0-litre Coyote V8, and the 3.5-litre PowerBoost — a hybrid pairing the high-output EcoBoost with an electric motor and the 2.4 kW or 7.2 kW Pro Power Onboard generator. Trim levels span from XL work-truck through Lariat, King Ranch, Platinum and Limited to the off-road Raptor; a 5.2-litre supercharged Raptor R joined the range in 2023. Production runs at Ford''s Dearborn Truck Plant in Michigan and the Kansas City Assembly Plant in Missouri.'
WHERE mk.slug = 'ford' AND m.slug = 'f-150' AND g.start_year = 2021;

-- ----------------------------------------------------------------------------
-- Tesla Model 3 — first generation (2017-)
-- ----------------------------------------------------------------------------
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The Tesla Model 3 entered production in July 2017 as the company''s first mass-market sedan, intended to scale Tesla''s output by roughly an order of magnitude over the Model S. The car uses a smaller, simpler platform than the Model S and a stripped-back interior centred entirely on a 15-inch touchscreen — there is no traditional instrument cluster, and physical controls are limited to two stalks, two scroll wheels and the door release.

The North-American line originally ran Standard Range, Long Range and Performance variants, with Long Range and Performance available in Dual Motor all-wheel drive. A significant interior refresh in 2021 added a heated steering wheel, double-pane glass and a redesigned centre console. The Model 3 Highland refresh launched in late 2023 with redesigned exterior LEDs, no stalk turn signals, a stiffer chassis and additional sound insulation. Production runs at Tesla''s Fremont, California gigafactory for North America and at Giga Shanghai for export markets including Europe.'
WHERE mk.slug = 'tesla' AND m.slug = 'model-3' AND g.start_year = 2017;
