-- Editorial intros batch 2 — herstructureringsplan §3 Niveau 4 #2.
--
-- Ten more 140-175 word intros covering high-volume mainstream gens already
-- seeded in earlier migrations. Same authoring rules as 141:
--   * No spec numbers (HP, dims, prices) — those live in tables.
--   * Verifiable historical facts only.
--   * No marketing claims.
--
-- Matches by (make_slug, model_slug, start_year). Silent no-op when slugs drift.

SET NAMES utf8mb4;

-- Toyota RAV4 XA50 (start 2019)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The fifth-generation RAV4 launched in late 2018 for the 2019 model year, the first RAV4 built on the GA-K (TNGA-K) platform. The XA50 reset the RAV4''s design language sharply rearward of the rounded XA40 predecessor, taking on a more squared-off SUV profile with a higher beltline, raised hood line and visible body cladding around the wheelarches.

The North-American range includes the A25A-FKS 2.5-litre naturally aspirated four with Toyota''s Dynamic Force technology paired with an 8-speed automatic, and the A25A-FXS hybrid (HV) with the Toyota Hybrid System II. Toyota added the RAV4 Prime plug-in hybrid in 2021 with a larger-capacity lithium-ion pack supporting EV-mode operation. A mid-cycle refresh for the 2023 model year brought USB-C ports and an updated infotainment head unit. The XA50 is built at Toyota Motor Manufacturing Canada in Cambridge and Woodstock, Ontario, and at Toyota''s Kentucky plant for North America.'
WHERE mk.slug = 'toyota' AND m.slug = 'rav4' AND g.start_year = 2019;

-- Toyota Corolla E210 (start 2019)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The twelfth-generation Corolla launched in late 2018 for the 2019 model year as a hatchback, with the sedan following in 2020. The E210 is the first Corolla built on Toyota''s TNGA-C platform, replacing the older MC underpinning of the E170. Toyota repositioned the Corolla upmarket relative to its predecessor with a stiffer body shell, multi-link rear suspension on hatchback and hybrid variants (replacing the torsion beam used on lesser sedans), and a more aggressive front-end design.

Powertrains in North America include the M20A-FKS 2.0-litre four with Dynamic Force technology paired with a CVT that uses a physical launch gear, the older 2ZR-FE 1.8-litre on base sedan trims, and the M20A-FXS in hybrid form. Outside North America the 1.8-litre hybrid and a 1.2-litre 8NR-FTS turbocharged four are also offered. A facelift arrived for the 2023 model year with updated front lighting. Production runs at Toyota''s Blue Springs, Mississippi plant for North America.'
WHERE mk.slug = 'toyota' AND m.slug = 'corolla' AND g.start_year = 2019;

-- Ford Mustang S550 (start 2015)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The sixth-generation Mustang launched for the 2015 model year, internally designated S550. It marked the first independent rear suspension on a non-Cobra Mustang since the 2004 SVT Cobra — a substantial chassis re-engineering aimed at global sales positioning beyond the traditional North-American market. The S550 also broadened the powertrain lineup with the EcoBoost 2.3-litre turbocharged four alongside the carryover 5.0-litre Coyote V8; the V6 base engine was phased out after the 2017 model year.

The S550 received a significant facelift for the 2018 model year (often called S550 LCI) with revised front-end styling, the 10R80 ten-speed automatic replacing the 6R80, an updated Coyote with port-and-direct fuel injection and the Mach 1 reviving in 2021 as the top non-Shelby variant. Shelby GT350 and GT500 sat on the S550 platform with the Voodoo flat-plane-crank V8 and the Predator supercharged V8 respectively. Production runs at Ford''s Flat Rock Assembly Plant in Michigan. The seventh-generation S650 Mustang replaced the S550 for 2024.'
WHERE mk.slug = 'ford' AND m.slug = 'mustang' AND g.start_year = 2015;

-- Volkswagen Golf Mk8 (start 2020)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The eighth-generation Golf launched in late 2019 for the 2020 model year, internally designated Mk8. It is the second Golf built on Volkswagen''s MQB Evo platform, retaining the architectural fundamentals of the Mk7 but with substantially upgraded electronic architecture — a new MEB-derived infotainment, a touch-based climate panel and capacitive steering-wheel controls.

The petrol lineup centres on the EA211 evo 1.0- and 1.5-litre TSI four-cylinder turbocharged engines, with the 48V mild-hybrid eTSI variant standard on most trims. Diesels use the EA288 evo 2.0 TDI. The GTI carries the EA888 evo4 2.0 TSI; the R variant adds permanent all-wheel drive with rear-axle torque vectoring. A plug-in hybrid eHybrid and GTE joined the range in 2020. A heavily revised Mk8.5 launched in 2024 with a redesigned infotainment unit, restored physical climate buttons and styling updates. The Mk8 is not sold in North America beyond the GTI and R hot-hatch variants. Production runs at the Volkswagen Wolfsburg plant in Germany.'
WHERE mk.slug = 'volkswagen' AND m.slug = 'golf' AND g.start_year = 2020;

-- Subaru Outback BT (start 2019, ran 2019-2024)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The sixth-generation Outback launched in late 2019 for the 2020 model year, internally designated BT. It was the first Outback built on Subaru''s Global Platform (SGP) — a stiffer, lighter architecture shared with the contemporary Legacy, Impreza, Crosstrek and Forester. The BT preserved the lifted-wagon proportions that define the Outback model line while adopting a more upright greenhouse than its predecessor.

The North-American range carries the FA24F 2.4-litre direct-injection turbo flat-four (Outback XT trims) and the FB25 2.5-litre naturally aspirated flat-four (base Outback). The Lineartronic TR580 CVT is the only transmission. The Wilderness variant arrived for the 2022 model year with a 0.8-inch lift, all-terrain Yokohama Geolandar tyres, revised final-drive gearing and skid plates. A mid-cycle refresh for 2023 brought a redesigned front fascia and the Wilderness styling cues spread to upper trims. Production runs at Subaru Indiana Automotive in Lafayette for North America.'
WHERE mk.slug = 'subaru' AND m.slug = 'outback' AND g.start_year = 2019;

-- Mazda 3 BP (start 2019)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The fourth-generation Mazda 3 launched in early 2019 for the 2019 model year, internally designated BP. It is the first 3 built on the SkyActiv-Vehicle Architecture, replacing the BM/BN-era platform with a substantially stiffer body shell, a simpler torsion-beam rear suspension (replacing the BM''s multi-link) and a revised set of i-Activsense driver-assistance features.

Powertrains include the PE-VPS 2.0-litre and PY-VPS 2.5-litre SkyActiv-G naturally aspirated four-cylinders, the SH-VPTS 1.8-litre SkyActiv-D diesel (outside North America), the eX-VPS 2.0-litre SkyActiv-X compression-ignition petrol (also outside North America) and the PY-VPTS 2.5-litre turbocharged version that powers the AWD Turbo variants. A mild-hybrid 24V system is fitted to most petrol engines. The BP is offered in five-door hatchback and four-door sedan body styles. A facelift for 2024 brought revised front-end styling and an updated infotainment unit. Production runs at Mazda Hofu in Japan, with North-American sedans built at Mazda de México in Salamanca.'
WHERE mk.slug = 'mazda' AND m.slug = '3' AND g.start_year = 2019;

-- Tesla Model Y (start 2020)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The Tesla Model Y entered production in early 2020 at Tesla''s Fremont, California plant, with first deliveries in March of that year. It shares roughly 75% of its parts with the Model 3 sedan but adopts an SUV-style crossover body with a higher seating position, more cargo volume behind the rear seats and an optional third row (sold in some markets and discontinued in others).

The range originally launched with Long Range and Performance variants in Dual Motor all-wheel drive only; a Standard Range RWD variant was added in 2021. The Model Y is the first Tesla to use the company''s structural battery pack with 4680 cylindrical cells on cars built in Austin and Berlin — the battery housing serves as part of the body floor, reducing weight and parts count. A heavily revised version (internally Juniper) launched in early 2025 with redesigned exterior LEDs, suspension recalibration and interior updates. Production runs at Fremont, Giga Shanghai, Giga Berlin and Giga Texas in Austin.'
WHERE mk.slug = 'tesla' AND m.slug = 'model-y' AND g.start_year = 2020;

-- Honda Accord CV (start 2023)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The eleventh-generation Accord launched for the 2023 model year, the eleventh body style on a continuous nameplate that traces back to 1976. It uses an updated version of the CV2/CV3 platform that underpinned the tenth-generation Accord, but with the Accord moving to a hybrid-only lineup in most upper trims for North America for the first time in the model''s history.

The base LX and EX trims carry the L15B7 1.5-litre turbocharged four shared with the Civic, while Sport, EX-L, Sport-L and Touring all use the e:HEV two-motor hybrid system with the LFC 2.0-litre naturally aspirated four as the engine. The Touring trim is the first Accord to come standard with Google built-in infotainment. Honda dropped the manual transmission and the 2.0-litre turbo (with its 10-speed automatic) from the lineup with the eleventh-generation transition. Production runs at Honda''s Marysville Auto Plant in Ohio for North America.'
WHERE mk.slug = 'honda' AND m.slug = 'accord' AND g.start_year = 2023;

-- Mercedes-Benz C-Class W206 (start 2022)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The fifth-generation C-Class launched in 2021 for the 2022 model year, internally designated W206. It is built on the second-generation MRA platform shared with the E-Class W214 and adopts a cabin design closely aligned with the larger S-Class W223 — Mercedes'' MBUX Hyperscreen-derived portrait infotainment touchscreen replaces the previous dual-screen dashboard.

The petrol lineup is exclusively four-cylinder for the first time in the C-Class''s history: the M254 2.0-litre four-cylinder mild-hybrid (with an integrated starter-generator on the 48V system), available in C200, C300 and on AMG C43 with a twin-electric-turbo configuration. The plug-in hybrid C300e and C400e use the M254 with a substantially larger battery and an electric motor integrated into the 9G-Tronic transmission. The AMG C63 S E Performance, launched in 2023, is the first C63 with a four-cylinder engine and uses a P3 hybrid layout pairing the M139 turbo four with a rear-axle electric motor. Production runs at Mercedes-Benz Bremen in Germany and at Beijing Benz Automotive for the Chinese market.'
WHERE mk.slug = 'mercedes-benz' AND m.slug = 'c-class' AND g.start_year = 2022;

-- BMW X5 G05 (start 2019)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The fourth-generation X5 launched in late 2018 for the 2019 model year, internally designated G05. It is built on BMW''s CLAR platform shared with the 5 Series and 7 Series, replacing the dedicated F15 platform of its predecessor. The G05 grew slightly in length and wheelbase over the F15 while adopting a more conservative grille and headlight design with the L-shaped tail lamps characteristic of the late-2010s BMW design generation.

The North-American range carries the B58 3.0-litre inline-six petrol (xDrive40i) and the N63R 4.4-litre twin-turbo V8 (xDrive50i, replaced by the xDrive50e plug-in hybrid for 2024). Diesels (xDrive30d, xDrive40d) are offered outside North America. The high-performance X5 M50i and X5 M Competition use the S63 V8 — the M50i is a Motorsport-tuned variant, the M Competition is a full M division product. A heavy LCI facelift for 2023 introduced the curved iDrive 8 display, revised front-end styling and the 48V mild-hybrid setup across the lineup. Production runs at BMW Spartanburg in South Carolina.'
WHERE mk.slug = 'bmw' AND m.slug = 'x5' AND g.start_year = 2019;

-- Jeep Wrangler JL (start 2018)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The fourth-generation Wrangler launched in late 2017 for the 2018 model year, internally designated JL. It carries forward the Wrangler''s solid-axle, body-on-frame, removable-door-and-roof architecture that has defined the model since the 1986 YJ, but with substantial weight reduction through aluminium body panels (doors, hood, fenders, hinges, tailgate) and a more rigid frame. Two- and four-door (JLU) variants are offered, with the four-door being the higher-volume body style.

The petrol lineup centres on the Pentastar 3.6-litre V6 with the eight-speed 850RE automatic, and from 2019 the Hurricane 2.0-litre turbocharged four with the same automatic and the 48V eTorque mild-hybrid system. A 3.0-litre EcoDiesel V6 was offered briefly for 2020-2023. The 4xe plug-in hybrid joined the range for 2021 with the 2.0-litre Hurricane four mated to electric motors integrated into the transmission. The Rubicon trim retains heavy-duty Dana 44 axles and a 4:1 transfer case. Production runs at the Toledo Assembly Complex in Ohio.'
WHERE mk.slug = 'jeep' AND m.slug = 'wrangler' AND g.start_year = 2018;

-- Hyundai Tucson NX4 (start 2021)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The fourth-generation Tucson launched for the 2022 model year, internally designated NX4. It is built on Hyundai''s N3 platform shared with the Kia Sportage NQ5 and the Santa Cruz pickup, and represents Hyundai''s most significant Tucson redesign in the model''s two-decade history. The NX4 adopted Hyundai''s ''Parametric Dynamics'' design language with the parametric jewel-pattern grille and integrated hidden daytime running lamps that illuminate as part of the front-end pattern.

The North-American lineup carries the Smartstream G2.5 GDi 2.5-litre naturally aspirated four (base SE and SEL), a hybrid variant with the 1.6-litre T-GDi turbocharged four paired with a 6-speed automatic and an electric motor, and a plug-in hybrid using the same drivetrain with a larger lithium-polymer battery. Long-wheelbase variants are sold in some markets for added second-row legroom. A mid-cycle refresh in 2024 brought revised front lighting and a redesigned dashboard with a single curved display. Production runs at Hyundai Motor Manufacturing Alabama in Montgomery for North America.'
WHERE mk.slug = 'hyundai' AND m.slug = 'tucson' AND g.start_year = 2021;
