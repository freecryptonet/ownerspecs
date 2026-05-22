-- Editorial intros batch 4 — herstructureringsplan §3 Niveau 4 #2.
--
-- Ten more 140-175 word intros covering the remaining high-volume seeded gens
-- in mid-size SUV, full-size pickup, luxury sedan and minivan segments.
-- Same authoring rules as 141/143/145.

SET NAMES utf8mb4;

-- Toyota Tacoma N300 (4th gen, start 2023)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The fourth-generation Tacoma launched in mid-2023 for the 2024 model year. It is the first Tacoma built on Toyota''s body-on-frame TNGA-F platform, shared with the Tundra XK70, Sequoia, Land Cruiser 300, Lexus GX 550 and Lexus LX 600. The new platform replaces the long-running N300 (third-generation) ladder frame with a stiffer high-strength-steel design and substantially revises front and rear suspension geometry.

The petrol lineup uses the T24A-FTS 2.4-litre turbocharged four — the same engine family as the Highlander turbo and the GR Corolla — paired with either an 8-speed automatic or a six-speed manual (on TRD Off-Road and Pre-Runner). An i-FORCE MAX hybrid variant pairs the T24A-FTS with a single electric motor in the transmission. Trim levels run from base SR through SR5, TRD Sport, TRD Off-Road, TRD Pro, Limited and the new Trailhunter overlanding-focused trim. Production runs at Toyota''s Guanajuato, Mexico plant and at San Antonio, Texas.'
WHERE mk.slug = 'toyota' AND m.slug = 'tacoma' AND g.start_year = 2023;

-- Hyundai Palisade LX2 (start 2020)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The first-generation Palisade launched for the 2020 model year, internally designated LX2. It is built on the Hyundai-Kia midsize SUV platform shared with the Kia Telluride and replaced the Santa Fe XL as Hyundai''s three-row family SUV. The Palisade was designed in California specifically for North-American taste and is sold globally as Hyundai''s flagship SUV outside markets where the Genesis GV80 fills that role.

The lineup uses the Lambda II G6DH 3.8-litre naturally aspirated V6 paired with an 8-speed automatic, with available all-wheel drive across all trims (SE, SEL, XRT, Limited, Calligraphy). There is no hybrid Palisade in the LX2 generation. A heavy mid-cycle refresh for 2023 introduced revised front-end styling with a more prominent cascading grille, a single curved display, the XRT off-road variant and an updated infotainment system. Production runs at Hyundai Motor Company''s Ulsan Plant 4 in South Korea.'
WHERE mk.slug = 'hyundai' AND m.slug = 'palisade' AND g.start_year = 2020;

-- Ram 1500 DT (start 2019)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The fifth-generation Ram 1500 launched in early 2018 for the 2019 model year, internally designated DT. It is built on Stellantis (then FCA US)''s body-on-frame light-duty truck platform shared with the previous-generation DS Ram 1500 (which continues in production for fleet sales as the Ram 1500 Classic). The DT introduced a redesigned interior centred on a 12-inch portrait infotainment screen, an eight-speed ZF 8HP-derived automatic, and the 48V eTorque mild-hybrid system available on most engines.

The petrol lineup includes the Pentastar 3.6-litre V6 with eTorque, the HEMI 5.7-litre V8 with optional eTorque, and the 6.2-litre supercharged HEMI in the TRX off-road performance variant (sold 2021-2024). The 3.0-litre EcoDiesel V6 was offered 2020-2023. The Ram 1500 REV electric truck and the Ramcharger range-extended hybrid joined the lineup in 2024. Production runs at Stellantis Sterling Heights Assembly Plant in Michigan.'
WHERE mk.slug = 'ram' AND m.slug = '1500' AND g.start_year = 2019;

-- Mazda CX-5 KF (start 2017)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The second-generation CX-5 launched in late 2016 for the 2017 model year, internally designated KF. It is built on a revised version of the KE first-generation platform with substantial body-shell stiffening and revised NVH treatment, but with the same fundamental SkyActiv-Vehicle architecture and macpherson/multilink suspension layout. The KF refined rather than reset the CX-5 formula, with a more conservative exterior than its predecessor and a substantially upgraded interior.

The North-American range carries the PE-VPS 2.5-litre SkyActiv-G naturally aspirated four and the PY-VPTS 2.5-litre turbocharged variant introduced in 2019 for the Signature trim. A 2.2-litre SkyActiv-D diesel was sold briefly in North America (model year 2019 only). Outside North America the SH-VPTS 1.8-litre diesel and PE-VPS 2.0-litre SkyActiv-G are also offered. Multiple mid-cycle refreshes brought updated infotainment and standard i-Activsense driver assistance. The CX-5 ran until 2024 in most markets before the CX-50 replaced it in some regions. Production runs at Mazda Hofu in Japan and at Mazda Sollers Manufacturing Rus in Vladivostok historically.'
WHERE mk.slug = 'mazda' AND m.slug = 'cx-5' AND g.start_year = 2017;

-- Honda Odyssey RL6 (5th gen, start 2018)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The fifth-generation Odyssey launched in mid-2017 for the 2018 model year, internally designated RL6. It is built on Honda''s compact global platform stretched for minivan duty (shared with the Pilot YF and the Acura MDX YD4 in chassis fundamentals). The RL6 grew slightly in length over the RL5 predecessor while retaining the eight-passenger capacity, sliding side doors and Magic Slide second-row seats that define the Odyssey.

The lineup uses the J35Y6 3.5-litre direct-injection V6 paired with either a 9-speed automatic (LX, EX) or a 10-speed automatic (EX-L, Touring, Elite) — Honda''s own 10-speed designed and built in-house. There is no hybrid Odyssey in this generation; the Toyota Sienna remains the sole hybrid minivan in the segment. A mid-cycle refresh for the 2021 model year brought updated front-end styling, the standard CabinWatch and CabinTalk in-car video and intercom features, and Honda Sensing 2.0. Production runs at Honda Manufacturing of Alabama in Lincoln.'
WHERE mk.slug = 'honda' AND m.slug = 'odyssey' AND g.start_year = 2018;

-- Toyota Sienna XL40 (start 2021)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The fourth-generation Sienna launched in late 2020 for the 2021 model year, internally designated XL40. It is the first hybrid-only minivan in the North-American market — Toyota replaced the long-running 2GR-FKS 3.5-litre V6 with the A25A-FXS 2.5-litre four-cylinder Atkinson-cycle paired with the Toyota Hybrid System II. The XL40 is built on a stretched TNGA-K platform shared with the Highlander XU70 and Camry XV70.

The lineup retains the Sienna''s traditional seven- or eight-passenger configurations, sliding side doors and available all-wheel drive (with an electric motor on the rear axle when AWD is selected). The Woodland Edition arrived for 2022 with revised suspension, all-terrain tyres and a 0.6-inch lift — the first off-road-oriented Sienna in the model''s history. A mid-cycle refresh for 2025 brought a redesigned interior with a 12.3-inch infotainment screen. Production runs at Toyota Motor Manufacturing Indiana in Princeton.'
WHERE mk.slug = 'toyota' AND m.slug = 'sienna' AND g.start_year = 2021;

-- Audi A4 B9 (start 2015)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The fifth-generation A4 launched in 2015 (European MY2016, North-American MY2017), internally designated B9. It is built on Volkswagen Group''s MLB Evo platform shared with the Audi A5, Q5 and Porsche Macan, replacing the B8/B8.5 platform of the previous A4. The B9 brought substantially revised electrical architecture with the optional Virtual Cockpit digital instrument panel and the second-generation MMI infotainment.

The petrol lineup centres on the EA888 evo 2.0 TFSI four-cylinder (40 TFSI / 45 TFSI) with various states of tune and the EA839 3.0 TFSI V6 in the higher-output S4 (turbocharged on the B9, replacing the supercharged 3.0 of the B8 S4). Diesel variants ran the EA288 2.0 TDI. A mild-hybrid 12V/48V system arrived with the B9 facelift in 2019. The RS 4 Avant carries the EA839 2.9 TFSI biturbo V6. Production runs at Audi Ingolstadt and Audi Neckarsulm for global markets.'
WHERE mk.slug = 'audi' AND m.slug = 'a4' AND g.start_year = 2015;

-- Mercedes-Benz E-Class W213 (start 2017)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The fifth-generation E-Class launched in early 2016 for the European market and mid-2016 for the 2017 model year in North America, internally designated W213. It is built on Mercedes'' first-generation MRA platform shared with the S-Class W222 and C-Class W205. The W213 introduced Drive Pilot semi-autonomous driving on its launch, the dual 12.3-inch widescreen cockpit and substantially revised aerodynamics over the W212 predecessor.

The petrol lineup centred on the M274 2.0-litre four-cylinder (E300), the M276 3.0-litre V6 (E400), and the AMG-developed M177 4.0-litre twin-turbo V8 (E63 / E63 S, sold as AMG E 63 / E 63 S). A mild-hybrid M256 3.0-litre inline-six replaced the V6 with the W213 facelift in 2020 (E450). Plug-in hybrid E350e and E300de variants joined the range in 2017. Body variants include sedan, T-Modell estate, coupe and cabriolet, plus the long-wheelbase Chinese-market V213. Production runs at Mercedes-Benz Sindelfingen for global markets.'
WHERE mk.slug = 'mercedes-benz' AND m.slug = 'e-class' AND g.start_year = 2017;

-- BMW X3 G01 (start 2018)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The third-generation X3 launched in late 2017 for the 2018 model year, internally designated G01. It is the first X3 built on BMW''s CLAR platform shared with the 3 Series G20 and 5 Series G30, replacing the dedicated F25 platform of the previous X3. The G01 grew slightly in every external dimension over the F25 while reducing curb weight through more aluminium and high-strength steel in the body shell.

The North-American range carries the B48 2.0-litre turbocharged four (xDrive30i) and the B58 3.0-litre turbocharged inline-six (M40i, with 48V mild hybrid from 2020). Diesel variants run the B47 outside North America. The plug-in hybrid xDrive30e arrived in 2020. The X3 M and X3 M Competition (G01 M40e and G01 M-LCI) use the S58 inline-six — the M Competition is a full M division product rather than a Motorsport-tuned variant. A heavy LCI facelift for 2022 introduced revised front-end styling and iDrive 8. Production runs at BMW Spartanburg in South Carolina for global markets.'
WHERE mk.slug = 'bmw' AND m.slug = 'x3' AND g.start_year = 2018;

-- Hyundai Elantra CN7 (start 2021)
UPDATE generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
SET g.editorial_intro =
'The seventh-generation Elantra launched for the 2021 model year, internally designated CN7. It is built on Hyundai''s K3 platform shared with the Kia Forte K3 and the Hyundai Kona. The CN7 introduced Hyundai''s sharper ''Sensuous Sportiness'' design language to the Elantra, with prominent character lines on the bodyside and a coupe-influenced roofline that drew commentary from owners as the most aggressive Elantra styling to date.

The North-American lineup uses the Smartstream G2.0 MPi 2.0-litre naturally aspirated four (SE, SEL, Limited) paired with a continuously variable transmission, a Hybrid variant with the Smartstream G1.6 1.6-litre four with the six-speed dual-clutch and an electric motor, and the high-performance Elantra N with the Theta III T-GDi 2.0-litre turbocharged four. A facelift for the 2024 model year introduced revised front and rear lighting and updated infotainment. Production runs at Hyundai Motor Manufacturing Alabama in Montgomery for North America.'
WHERE mk.slug = 'hyundai' AND m.slug = 'elantra' AND g.start_year = 2021;
