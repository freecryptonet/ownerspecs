-- Editorial intros batch 3 — herstructureringsplan §3 Niveau 4 #2.
--
-- Ten more 140-175 word intros, including the BMW 3-Series F30 that motivated
-- the original plan. Same authoring rules as 141/143.

SET NAMES utf8mb4;

-- Honda CR-V RW (start 2017)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The fifth-generation CR-V launched in late 2016 for the 2017 model year, internally designated RW (with regional variants RT and RM). It was the first CR-V built on Honda''s compact global platform shared with the Civic FC. The RW grew slightly in every external dimension over the RM/RE predecessor, adopted a more upright greenhouse and introduced a substantially larger cargo area behind the second row.

The North-American range carried the L15B7 1.5-litre turbocharged four (Sport, EX, EX-L, Touring) and the R20A 2.4-litre naturally aspirated four (base LX, dropped after the 2019 model year). The CR-V Hybrid arrived for 2020 with a 2.0-litre Atkinson-cycle four paired with Honda''s two-motor i-MMD system. A mid-cycle facelift in 2020 brought revised front-end lighting, a hands-free power tailgate on the Touring trim and Honda Sensing 2.0. Production runs at Honda''s East Liberty Auto Plant in Ohio and at Honda of Canada Manufacturing in Alliston, Ontario for North America.'
WHERE mk.slug = 'honda' AND m.slug = 'cr-v' AND g.start_year = 2017;

-- Toyota Highlander XU70 (start 2020)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The fourth-generation Highlander launched in late 2019 for the 2020 model year, internally designated XU70. It is built on the TNGA-K platform shared with the Camry XV70 and Avalon, replacing the dedicated K platform of the XU50 predecessor. The XU70 grew in length and wheelbase over the XU50 while retaining three-row seating with a 7- or 8-passenger capacity.

The North-American range carries the 2GR-FKS 3.5-litre V6 paired with an 8-speed automatic, and the A25A-FXS 2.5-litre four with the Toyota Hybrid System II — both across the LE / XLE / Limited / Platinum trim ladder. A mid-cycle refresh introduced the T24A-FTS 2.4-litre turbocharged four to replace the 3.5 V6 in non-hybrid trims, alongside revised front-end styling. The Grand Highlander joined the lineup in 2024 as a longer-wheelbase variant on a separate platform stretch. Production runs at Toyota Motor Manufacturing Indiana in Princeton.'
WHERE mk.slug = 'toyota' AND m.slug = 'highlander' AND g.start_year = 2020;

-- Honda Pilot YF (start 2023)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The fourth-generation Pilot launched for the 2023 model year, internally designated YF. It is built on the same compact global platform used by the Passport, Odyssey and Ridgeline, but with a stretched wheelbase to accommodate three rows of seating in either 7- or 8-passenger configurations. The YF Pilot is the first Pilot to use Honda''s i-VTM4 torque-vectoring all-wheel-drive system in its TrailSport off-road variant.

The lineup uses the J35Y8 3.5-litre direct-injection V6 paired with a 10-speed automatic (the same 10R80-equivalent that Honda co-developed with Ford). There is no hybrid Pilot in this generation. The TrailSport variant adds skid plates, all-terrain tyres, a 1-inch lift and revised approach/departure angles, and is the first Pilot intended for serious off-road use. The Elite trim adds a panoramic moonroof, 21-inch wheels and a head-up display. Production runs at Honda''s Lincoln, Alabama plant.'
WHERE mk.slug = 'honda' AND m.slug = 'pilot' AND g.start_year = 2023;

-- Kia Telluride ON (start 2020)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The first-generation Telluride launched for the 2020 model year, internally designated ON. It is built on the Hyundai-Kia midsize SUV platform shared with the Hyundai Palisade, and is the largest SUV in Kia''s North-American lineup. The Telluride was designed in California specifically for North-American taste and uses styling cues distinct from the rest of the Kia range — vertical headlamps, a boxier silhouette and prominent body-side cladding.

The lineup uses the Lambda II G6DH 3.8-litre naturally aspirated V6 paired with an eight-speed automatic, with available all-wheel drive across all trims (LX, S, EX, SX, X-Line, X-Pro). There is no hybrid Telluride in this generation. A heavy mid-cycle refresh for 2023 added the X-Line and X-Pro off-road variants (with the X-Pro running 18-inch wheels and all-terrain tyres), revised front-end styling and a single curved display. Production runs at Kia Manufacturing Georgia in West Point.'
WHERE mk.slug = 'kia' AND m.slug = 'telluride' AND g.start_year = 2020;

-- Ford Explorer U625 (start 2020)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The sixth-generation Explorer launched for the 2020 model year, internally designated U625. It returned to a rear-wheel-drive-based platform (CD6) after three generations on a front-wheel-drive transverse platform, restoring the body-on-frame-like driving character of the Ranger-derived first- and second-generation Explorers, though the U625 itself is unibody. The CD6 platform is shared with the Lincoln Aviator and the Police Interceptor Utility.

The lineup uses the 2.3-litre EcoBoost turbocharged four (base XLT and Limited), the 3.0-litre EcoBoost twin-turbo V6 (Platinum and ST), and the 3.0-litre Hybrid V6 (Limited Hybrid). All variants use a 10-speed automatic developed jointly with GM. The Explorer ST is the high-performance variant tuned by Ford Performance and was the first ST-badged SUV in the Ford lineup. A heavy mid-cycle refresh for 2025 brought a redesigned dashboard, larger infotainment screen and revised front-end styling. Production runs at Ford''s Chicago Assembly Plant.'
WHERE mk.slug = 'ford' AND m.slug = 'explorer' AND g.start_year = 2020;

-- Chevrolet Silverado T1 (start 2019)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The fourth-generation Silverado 1500 launched in autumn 2018 for the 2019 model year, internally designated T1XX (shared with the GMC Sierra 1500). The T1XX moved GM''s full-size light-duty trucks to a mixed-material body using high-strength steel for the frame and aluminium for the doors, hood and tailgate, reducing curb weight versus the K2XX predecessor. The T1XX is the first Silverado offered in six cab/bed configurations rather than the previous three.

The petrol lineup includes the L82 4.3-litre V6, the L3B 2.7-litre turbocharged four (with two states of tune), the L84 5.3-litre V8 with Dynamic Fuel Management, the L87 6.2-litre V8, and the LM2 / LZ0 3.0-litre Duramax inline-six diesel. The ZR2 off-road variant arrived in 2022 with Multimatic DSSV spool-valve dampers; the High Country trim sits at the top of the luxury range. A facelift for 2022 added the larger 13.4-inch infotainment screen and revised front fascia. Production runs at GM''s Fort Wayne Assembly in Indiana and Silao Assembly in Mexico.'
WHERE mk.slug = 'chevrolet' AND m.slug = 'silverado' AND g.start_year = 2019;

-- Toyota Tundra XK70 (start 2022)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The third-generation Tundra launched for the 2022 model year, internally designated XK70 (and known in some markets as the Tundra TNGA-F). It is built on Toyota''s body-on-frame TNGA-F platform shared with the Sequoia, Land Cruiser 300 / GX 550 and Lexus LX 600. The XK70 is the first Tundra without a V8 option — Toyota dropped the long-running 3UR-FE 5.7-litre V8 in favour of a twin-turbocharged V6 across the lineup.

The petrol lineup uses the V35A-FTS 3.5-litre twin-turbo V6 in standard and i-FORCE MAX hybrid configurations (the hybrid pairs the V6 with a single electric motor in the 10-speed automatic and a 1.87 kWh nickel-metal-hydride battery). A 10-speed automatic is the only transmission. Trim levels run from SR work-truck through SR5, Limited, Platinum and 1794 Edition to the off-road TRD Pro and the on-road Capstone. Production runs at Toyota Motor Manufacturing Texas in San Antonio.'
WHERE mk.slug = 'toyota' AND m.slug = 'tundra' AND g.start_year = 2022;

-- Subaru Forester SK (start 2018, 5th gen 2019 MY)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The fifth-generation Forester launched in mid-2018 for the 2019 model year, internally designated SK. It is the first Forester built on the Subaru Global Platform (SGP) shared with the Impreza, Crosstrek, Outback BT and Ascent, replacing the SJ''s dedicated platform. The SK preserves the Forester''s tall, boxy proportions while modernising the body shell, NVH treatment and electronic architecture.

The North-American range carries the FB25D 2.5-litre direct-injection naturally aspirated flat-four with a Lineartronic CVT — there is no turbocharged or hybrid variant in North America (the Japanese-market Forester e-Boxer mild hybrid is not sold in the US). The Wilderness variant arrived for the 2022 model year with a 9.2-inch ground clearance, all-terrain Yokohama Geolandar tyres, revised final-drive gearing and skid plates. A mid-cycle refresh for 2022 also brought revised front lighting and EyeSight 4.0 driver assistance. Production runs at Subaru of Indiana Automotive in Lafayette.'
WHERE mk.slug = 'subaru' AND m.slug = 'forester' AND g.start_year = 2018;

-- Porsche 911 992 (start 2019)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The eighth-generation 911 launched in late 2018 for the 2019 model year, internally designated 992. It is built on a revised MMB (Modular Sports Car Platform) shared with the 911 991''s successor architecture, retaining the rear-engine, rear- or all-wheel-drive layout that has defined the 911 since the original 1964 model. The 992 grew slightly in width over the 991, used more aluminium in the body shell and adopted a stepped engine cover that visually references early air-cooled 911s.

The lineup uses the 9A2 evo 3.0-litre twin-turbocharged flat-six in Carrera, Carrera S and Carrera 4S variants, the 4.0-litre naturally aspirated flat-six in the GT3 / GT3 RS, the same 3.0-litre twin-turbo in higher tune in the Turbo and Turbo S, and the T-Hybrid 3.6-litre flat-six in the Carrera GTS (from the 992.2 facelift in 2024). An eight-speed PDK dual-clutch is the primary transmission with a seven-speed manual offered on Carrera T and GT3. Production runs at Porsche''s Zuffenhausen plant in Stuttgart.'
WHERE mk.slug = 'porsche' AND m.slug = '911' AND g.start_year = 2019;

-- BMW 3-Series F30 (start 2012) — the plan's hero example
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The sixth-generation 3 Series launched in early 2012 for the 2012 model year, internally designated F30 (sedan), F31 (Touring) and F34 (Gran Turismo). It was the first 3 Series built on a substantially different platform from its E90 predecessor and the first to use BMW''s electric power steering across the lineup — a change that drew significant commentary from owners and the enthusiast press for its altered feel relative to the hydraulic steering of the E46 and E90.

The petrol lineup centred on the N20 2.0-litre turbocharged four (320i, 328i) and the N55 3.0-litre turbocharged inline-six (335i). A mid-cycle refresh (the F30 LCI) arrived in mid-2015, replacing the N20 with the modular B48 and the N55 with the B58 inline-six on 340i designations. Diesel variants ran the N47 and later B47. Plug-in hybrid 330e launched in 2016. The F30 was succeeded by the G20 in 2019. Production ran at BMW''s Munich plant.'
WHERE mk.slug = 'bmw' AND m.slug = '3-series' AND g.start_year = 2012;
