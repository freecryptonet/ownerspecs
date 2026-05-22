-- Audi S6 + RS6 (C8) — 6 new gens that complete the audi-a6-c8-2018-present
-- family. typeIds + engine codes captured 2026-05-22 via Playwright on Tim's
-- authenticated HaynesPro session at modelId d_319001693:
--
--   DKMB    S6 (2.9 V6 TFSI biturbo)     2894 cc    331 kW (444 hp)  2019-...
--   DEWA    S6 (3.0 TDI V6 EU only)      2967 cc    257 kW (349 hp)  2019-2021
--   DMKD    S6 (3.0 TDI V6 EU only)      2967 cc    253 kW (344 hp)  2021-...
--   DJPB    RS6 (4.0 V8 TFSI biturbo)    3996 cc    441 kW (591 hp)  2019-2024
--   DWLA    RS6 (4.0 V8)                 3996 cc    441 kW (591 hp)  2023-...
--   DYGB    RS6 (4.0 V8)                 3996 cc    441 kW (591 hp)  2023-...
--   DYGA    RS6 Performance (4.0 V8)     3996 cc    463 kW (621 hp)  2023-...
--
-- The S6 model + RS6 model follow the BMW M3 / M5 pattern: separate `models`
-- table rows under Audi, NOT trims of the regular A6. This is the existing
-- convention from the M-lineup pull (mig 190 / 191) and matches how Audi
-- markets them.
--
-- Scope: this migration adds gens + trims + cloned electrical/bulbs/fuses/
-- procedures from the canonical A6 sedan (115). It does NOT clone fluid_specs
-- or torque_specs — the S6 2.9 TFSI biturbo and RS6 4.0 V8 biturbo have
-- different OEM oil specs, capacities, and torque values than the regular
-- A6. Those will be filled in a follow-up migration after a per-engine
-- HaynesPro pull.

SET NAMES utf8mb4;

SET @make_audi := 11;
SET @gen_a6 := 115; -- canonical A6 C8 sedan to clone procedures/electrical/etc. from

-- ----------------------------------------------------------------------------
-- 1. New models: S6 + RS6 under Audi
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO models (make_id, slug, name) VALUES
  (@make_audi, 's6', 'S6'),
  (@make_audi, 'rs6', 'RS6');

SET @model_s6  := (SELECT id FROM models WHERE make_id = @make_audi AND slug = 's6');
SET @model_rs6 := (SELECT id FROM models WHERE make_id = @make_audi AND slug = 'rs6');

-- ----------------------------------------------------------------------------
-- 2. New engines (HaynesPro-verified codes)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, valvetrain, cylinders) VALUES
  ('DKMB', '2.9 TFSI V6 biturbo (S6, DKMB)',           2894, 'petrol', 'biturbo',  'DOHC 24V', 6),
  ('DEWA', '3.0 TDI V6 (S6 EU pre-LCI, DEWA)',         2967, 'diesel', 'turbo',    'DOHC 24V', 6),
  ('DMKD', '3.0 TDI V6 (S6 EU LCI, DMKD)',             2967, 'diesel', 'turbo',    'DOHC 24V', 6),
  ('DJPB', '4.0 TFSI V8 biturbo (RS6 pre-LCI, DJPB)',  3996, 'petrol', 'biturbo',  'DOHC 32V', 8),
  ('DWLA', '4.0 TFSI V8 biturbo (RS6 LCI std, DWLA)',  3996, 'petrol', 'biturbo',  'DOHC 32V', 8),
  ('DYGB', '4.0 TFSI V8 biturbo (RS6 LCI std, DYGB)',  3996, 'petrol', 'biturbo',  'DOHC 32V', 8),
  ('DYGA', '4.0 TFSI V8 biturbo (RS6 Performance, DYGA)', 3996, 'petrol', 'biturbo', 'DOHC 32V', 8);

SET @e_dkmb := (SELECT id FROM engines WHERE code = 'DKMB');
SET @e_dewa := (SELECT id FROM engines WHERE code = 'DEWA');
SET @e_dmkd := (SELECT id FROM engines WHERE code = 'DMKD');
SET @e_djpb := (SELECT id FROM engines WHERE code = 'DJPB');
SET @e_dwla := (SELECT id FROM engines WHERE code = 'DWLA');
SET @e_dygb := (SELECT id FROM engines WHERE code = 'DYGB');
SET @e_dyga := (SELECT id FROM engines WHERE code = 'DYGA');

-- ----------------------------------------------------------------------------
-- 3. HaynesPro source already exists as id=709 (corrected by mig 199).
--    Per-typeId citation is via the same source row.
-- ----------------------------------------------------------------------------
SET @s_haynes := 709;

-- Public OEM-manual source for S/RS6 — reuse the existing A6 Audi
-- Owner's Manual sources where possible. Mig 198 created id=710 + 711.
SET @s_a6_2020 := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/audi/a6-s6-2020-owners-manual-75409');
SET @s_a6_2024 := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/audi/a6-2024-owners-manual-95746');

-- ============================================================================
-- 4. S6 (C8) Sedan 2019-2023 — pre-LCI
-- ============================================================================
INSERT INTO generations (
  model_id, slug, ordinal, codename, family_slug, family_label, display_name, body_type,
  start_year, end_year, layout, platform, editorial_intro,
  length_mm, width_mm, height_mm, wheelbase_mm,
  front_track_mm, rear_track_mm, fuel_tank_l, cargo_l,
  front_suspension, rear_suspension, front_brakes, rear_brakes,
  is_active
)
VALUES (
  @model_s6, 's6-c8-sedan-2019-2023', 1, 'C8',
  'audi-a6-c8-2018-present', 'Audi A6 C8 family (2018-present)',
  'S6 (C8) Sedan', 'Sedan',
  2019, 2023, 'AWD', 'MLB Evo',
'The S6 (C8) Sedan is the high-performance variant of the fifth-generation A6, launched 2019 for the 2020 model year. Built on the same MLB Evo platform as the A6 with quattro permanent AWD and the ZF 8HP Tiptronic 8-speed automatic. Two engine offerings split by market:\n\n- **US / global**: 2.9 TFSI V6 biturbo (HaynesPro engine code **DKMB**) — 2894 cc, 444 hp (331 kW), 0-100 km/h in 4.4 s, electronically-limited 250 km/h top speed.\n- **EU only**: 3.0 TDI V6 (HaynesPro engine code **DEWA** pre-2021) — 2967 cc, 349 hp (257 kW), 48V mild-hybrid with electric powered compressor (EPC) for low-RPM torque fill.\n\nVisual signature: more aggressive front fascia with quad-tip exhaust, S6-specific 20" wheels (21" optional), Nappa leather sport seats. Compared with the regular A6 the S6 sits ~10 mm lower on a sport-tuned air or steel coil suspension (option dependent). Cargo and dimensions are otherwise the same as the regular A6 sedan.',
  4942, 1886, 1452, 2924,
  NULL, NULL, 73, 530,
  'Independent multi-link, sport-tuned', 'Independent multi-link, sport-tuned',
  'Ventilated discs (S6 brake package)', 'Ventilated discs (S6 brake package)',
  1
);
SET @g_s6_sedan_pre := LAST_INSERT_ID();

-- ============================================================================
-- 5. S6 (C8) Avant 2019-2023 — pre-LCI
-- ============================================================================
INSERT INTO generations (
  model_id, slug, ordinal, codename, family_slug, family_label, display_name, body_type,
  start_year, end_year, layout, platform, editorial_intro,
  length_mm, width_mm, height_mm, wheelbase_mm,
  fuel_tank_l, cargo_l,
  front_suspension, rear_suspension, front_brakes, rear_brakes,
  is_active
)
VALUES (
  @model_s6, 's6-c8-avant-2019-2023', 2, 'C8',
  'audi-a6-c8-2018-present', 'Audi A6 C8 family (2018-present)',
  'S6 (C8) Avant', 'Estate',
  2019, 2023, 'AWD', 'MLB Evo',
'The S6 Avant is the wagon variant of the S6 (C8), sharing the 2.9 TFSI V6 biturbo (DKMB) or 3.0 TDI V6 (DEWA, EU only) powertrain, ZF 8HP Tiptronic 8-speed automatic, and permanent quattro AWD with the S6 sedan. Compared with the sedan, the Avant is the same length (4942 mm) but 38 mm taller (1490 mm) to accommodate the cargo bay, providing 565 L upright (1680 L folded) — identical body layout to the regular A6 Avant.\n\nIn the EU the S6 Avant was the more popular bodystyle thanks to the Avant''s practicality combined with V8-shaming straight-line performance from the V6 TDI mild-hybrid setup. The 3.0 TDI variant produces 700 N·m of torque from 2500 rpm via electric powered compressor (EPC) assist for lag-free pull.',
  4942, 1886, 1490, 2924,
  73, 565,
  'Independent multi-link, sport-tuned', 'Independent multi-link, sport-tuned',
  'Ventilated discs (S6 brake package)', 'Ventilated discs (S6 brake package)',
  1
);
SET @g_s6_avant_pre := LAST_INSERT_ID();

-- ============================================================================
-- 6. S6 (C8 LCI) Sedan 2023-present
-- ============================================================================
INSERT INTO generations (
  model_id, slug, ordinal, codename, family_slug, family_label, display_name, body_type,
  start_year, end_year, layout, platform, editorial_intro,
  length_mm, width_mm, height_mm, wheelbase_mm,
  fuel_tank_l, cargo_l,
  front_suspension, rear_suspension, front_brakes, rear_brakes,
  is_active
)
VALUES (
  @model_s6, 's6-c8-lci-sedan-2023-present', 3, 'C8 LCI',
  'audi-a6-c8-2018-present', 'Audi A6 C8 family (2018-present)',
  'S6 (C8 LCI) Sedan', 'Sedan',
  2023, NULL, 'AWD', 'MLB Evo',
'The S6 (C8 LCI) is the facelift variant of the C8 S6, on sale from mid-2023 (production switch from pre-LCI mid-2023). Visual changes match the regular C8 LCI — wider Singleframe grille with S6-specific honeycomb mesh, sharper LED Matrix headlights, OLED tail lights on top trims, revised lower bumpers with vertical air intakes. The MMI Touch Response dual-screen architecture carries over.\n\nPowertrain rationalisation continues: 2.9 TFSI V6 biturbo (**DKMB**) continues unchanged for the global market (444 hp / 331 kW). The EU TDI variant transitions from DEWA to **DMKD** for MY2022+ (3.0 V6 TDI, 344 hp / 253 kW — slight power reduction reflecting Euro 6d-Temp emissions retuning). ZF 8HP Tiptronic 8-speed automatic and permanent quattro AWD carry over.',
  4942, 1886, 1452, 2924,
  73, 530,
  'Independent multi-link, sport-tuned', 'Independent multi-link, sport-tuned',
  'Ventilated discs (S6 brake package)', 'Ventilated discs (S6 brake package)',
  1
);
SET @g_s6_sedan_lci := LAST_INSERT_ID();

-- ============================================================================
-- 7. S6 (C8 LCI) Avant 2023-present
-- ============================================================================
INSERT INTO generations (
  model_id, slug, ordinal, codename, family_slug, family_label, display_name, body_type,
  start_year, end_year, layout, platform, editorial_intro,
  length_mm, width_mm, height_mm, wheelbase_mm,
  fuel_tank_l, cargo_l,
  front_suspension, rear_suspension, front_brakes, rear_brakes,
  is_active
)
VALUES (
  @model_s6, 's6-c8-lci-avant-2023-present', 4, 'C8 LCI',
  'audi-a6-c8-2018-present', 'Audi A6 C8 family (2018-present)',
  'S6 (C8 LCI) Avant', 'Estate',
  2023, NULL, 'AWD', 'MLB Evo',
'The S6 (C8 LCI) Avant is the wagon variant of the facelift S6, sharing the LCI sedan''s revised front fascia and the 2.9 TFSI V6 biturbo (DKMB) or 3.0 TDI V6 (DMKD, EU only) powertrain. The Avant body is shared with the regular A6 Avant LCI — 4942 mm length × 1886 mm width × 1490 mm height, 565 L cargo upright. ZF 8HP Tiptronic 8-speed automatic and permanent quattro AWD.',
  4942, 1886, 1490, 2924,
  73, 565,
  'Independent multi-link, sport-tuned', 'Independent multi-link, sport-tuned',
  'Ventilated discs (S6 brake package)', 'Ventilated discs (S6 brake package)',
  1
);
SET @g_s6_avant_lci := LAST_INSERT_ID();

-- ============================================================================
-- 8. RS6 Avant (C8) 2019-2023 — pre-LCI (Avant-only)
-- ============================================================================
INSERT INTO generations (
  model_id, slug, ordinal, codename, family_slug, family_label, display_name, body_type,
  start_year, end_year, layout, platform, editorial_intro,
  length_mm, width_mm, height_mm, wheelbase_mm,
  fuel_tank_l, cargo_l,
  front_suspension, rear_suspension, front_brakes, rear_brakes,
  is_active
)
VALUES (
  @model_rs6, 'rs6-avant-c8-2019-2023', 1, 'C8',
  'audi-a6-c8-2018-present', 'Audi A6 C8 family (2018-present)',
  'RS6 Avant (C8)', 'Estate',
  2019, 2023, 'AWD', 'MLB Evo',
'The RS6 Avant (C8) is the eighth-generation Audi RS-badged super-wagon, launched 2019 as the top-of-range C8 variant. **Avant-only globally — there is no RS6 sedan on the C8.** Engine: Audi 4.0 TFSI V8 biturbo (HaynesPro engine code **DJPB**) — 3996 cc, 591 hp (441 kW), 800 N·m torque, mild-hybrid 48V system with cylinder-on-demand (CoD) shutting off four cylinders at light load. 0-100 km/h in 3.6 s, top speed electronically limited to 250 km/h (305 km/h with optional Dynamic Plus package).\n\nDrivetrain: ZF 8HP Tiptronic 8-speed automatic with launch control, permanent quattro AWD with self-locking centre differential + optional rear sport diff. Standard wheels: 21" forged aluminium; optional 22" carbon-ceramic brakes (440 mm front discs). Suspension: standard adaptive air suspension with 30 mm reduced ride height vs A6, or optional Dynamic Ride Control (DRC) coil-over hydraulically-cross-linked anti-roll. Body widened by 80 mm over standard A6 Avant (1951 mm vs 1886 mm) with bespoke fender flares.\n\nProduction ran 2019 through model year 2024 in some markets before LCI variants (DWLA / DYGB / DYGA Performance) took over.',
  4995, 1951, 1487, 2929,
  73, 565,
  'Adaptive air or DRC coil-over (Dynamic Ride Control)', 'Adaptive air or DRC coil-over (Dynamic Ride Control)',
  'Ventilated discs (440 mm), carbon-ceramic optional', 'Ventilated discs (370 mm), carbon-ceramic optional',
  1
);
SET @g_rs6_avant_pre := LAST_INSERT_ID();

-- ============================================================================
-- 9. RS6 Avant (C8 LCI) 2023-present — Avant-only, includes Performance trim
-- ============================================================================
INSERT INTO generations (
  model_id, slug, ordinal, codename, family_slug, family_label, display_name, body_type,
  start_year, end_year, layout, platform, editorial_intro,
  length_mm, width_mm, height_mm, wheelbase_mm,
  fuel_tank_l, cargo_l,
  front_suspension, rear_suspension, front_brakes, rear_brakes,
  is_active
)
VALUES (
  @model_rs6, 'rs6-avant-c8-lci-2023-present', 2, 'C8 LCI',
  'audi-a6-c8-2018-present', 'Audi A6 C8 family (2018-present)',
  'RS6 Avant (C8 LCI)', 'Estate',
  2023, NULL, 'AWD', 'MLB Evo',
'The RS6 Avant (C8 LCI) is the facelifted RS6, on sale from 2023. The visual refresh follows the rest of the C8 family — wider Singleframe with vertical RS6-specific honeycomb mesh, new LED Matrix headlights, OLED tail lights. The mechanical platform is unchanged from the pre-LCI: 4.0 TFSI V8 biturbo with cylinder-on-demand, ZF 8HP Tiptronic 8-speed automatic, permanent quattro AWD with self-locking centre diff.\n\nThree HaynesPro typeIds covered:\n- **DWLA** — 4.0 V8 standard, 591 hp (441 kW), MY2023+ (cleanest replacement for DJPB pre-LCI)\n- **DYGB** — 4.0 V8 standard, 591 hp (441 kW), alternate engine variant for MY2023+ (specific market or build-week distinction noted by Audi internally)\n- **DYGA** — 4.0 V8 **RS6 Performance**, 621 hp (463 kW). The Performance variant gains 30 hp via revised turbo wastegate map + ECU tune, sport-tuned exhaust, lighter wheels, and the option to remove the 250 km/h limiter (305 km/h with Dynamic Plus). Production confirmed from 2023.\n\nDimensions unchanged from pre-LCI: 4995 × 1951 × 1487 mm, 2929 mm wheelbase, 565 L cargo upright. Adaptive air or DRC coil-over suspension; carbon-ceramic brakes optional (Performance package).',
  4995, 1951, 1487, 2929,
  73, 565,
  'Adaptive air or DRC coil-over (Dynamic Ride Control)', 'Adaptive air or DRC coil-over (Dynamic Ride Control)',
  'Ventilated discs (440 mm), carbon-ceramic optional', 'Ventilated discs (370 mm), carbon-ceramic optional',
  1
);
SET @g_rs6_avant_lci := LAST_INSERT_ID();

-- ----------------------------------------------------------------------------
-- 10. Trims per gen
-- ----------------------------------------------------------------------------

-- S6 (C8) sedan + Avant — two trim variants (V6 petrol + V6 TDI EU)
INSERT INTO trims (generation_id, slug, name, engine_id, hp, drive_wheel, start_year, end_year)
VALUES
  (@g_s6_sedan_pre, '2-9-tfsi-v6-biturbo-444hp-tiptronic-quattro', 'S6 2.9 TFSI V6 biturbo (DKMB)', @e_dkmb, 444, 'AWD', 2019, 2023),
  (@g_s6_sedan_pre, '3-0-tdi-v6-349hp-tiptronic-quattro-eu',       'S6 3.0 TDI V6 (DEWA, EU)',     @e_dewa, 349, 'AWD', 2019, 2021),
  (@g_s6_avant_pre, '2-9-tfsi-v6-biturbo-444hp-tiptronic-quattro', 'S6 2.9 TFSI V6 biturbo (DKMB)', @e_dkmb, 444, 'AWD', 2019, 2023),
  (@g_s6_avant_pre, '3-0-tdi-v6-349hp-tiptronic-quattro-eu',       'S6 3.0 TDI V6 (DEWA, EU)',     @e_dewa, 349, 'AWD', 2019, 2021);

-- S6 (C8 LCI) sedan + Avant
INSERT INTO trims (generation_id, slug, name, engine_id, hp, drive_wheel, start_year, end_year)
VALUES
  (@g_s6_sedan_lci, '2-9-tfsi-v6-biturbo-444hp-tiptronic-quattro', 'S6 2.9 TFSI V6 biturbo (DKMB)', @e_dkmb, 444, 'AWD', 2023, NULL),
  (@g_s6_sedan_lci, '3-0-tdi-v6-344hp-tiptronic-quattro-eu',       'S6 3.0 TDI V6 (DMKD, EU)',     @e_dmkd, 344, 'AWD', 2021, NULL),
  (@g_s6_avant_lci, '2-9-tfsi-v6-biturbo-444hp-tiptronic-quattro', 'S6 2.9 TFSI V6 biturbo (DKMB)', @e_dkmb, 444, 'AWD', 2023, NULL),
  (@g_s6_avant_lci, '3-0-tdi-v6-344hp-tiptronic-quattro-eu',       'S6 3.0 TDI V6 (DMKD, EU)',     @e_dmkd, 344, 'AWD', 2021, NULL);

-- RS6 Avant pre-LCI — single trim (DJPB)
INSERT INTO trims (generation_id, slug, name, engine_id, hp, drive_wheel, start_year, end_year)
VALUES
  (@g_rs6_avant_pre, '4-0-tfsi-v8-biturbo-591hp-tiptronic-quattro', 'RS6 Avant 4.0 V8 TFSI (DJPB)', @e_djpb, 591, 'AWD', 2019, 2024);

-- RS6 Avant LCI — three trims (two standard engine codes + Performance)
INSERT INTO trims (generation_id, slug, name, engine_id, hp, drive_wheel, start_year, end_year)
VALUES
  (@g_rs6_avant_lci, '4-0-v8-591hp-tiptronic-quattro-dwla',     'RS6 Avant 4.0 V8 (DWLA)',             @e_dwla, 591, 'AWD', 2023, NULL),
  (@g_rs6_avant_lci, '4-0-v8-591hp-tiptronic-quattro-dygb',     'RS6 Avant 4.0 V8 (DYGB)',             @e_dygb, 591, 'AWD', 2023, NULL),
  (@g_rs6_avant_lci, '4-0-v8-621hp-tiptronic-quattro-performance', 'RS6 Performance 4.0 V8 (DYGA)',    @e_dyga, 621, 'AWD', 2023, NULL);

-- ----------------------------------------------------------------------------
-- 11. Clone procedures + electrical + bulbs + fuses from canonical A6 sedan.
--     Skip the DCT/0CK procedure — S6/RS6 use ZF 8HP only.
-- ----------------------------------------------------------------------------

-- Helper: define the set of target gens for the cross-clone
-- (Variables don't work in IN-clauses cleanly, so we expand inline.)

INSERT INTO procedures (generation_id, market_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT g.id, p.market_id, p.procedure_type, p.slug,
       REPLACE(REPLACE(p.title, 'A6 (C8)', CONCAT(REPLACE(g.display_name, ' Sedan', ''), '')), 'A6', SUBSTRING_INDEX(g.display_name, ' ', 1)),
       p.body_md, p.tools_required, p.common_mistakes
FROM procedures p
CROSS JOIN generations g
WHERE p.generation_id = @gen_a6
  AND p.slug != 'dsg-7sp-fluid-change'    -- S6/RS6 use ZF 8HP only
  AND g.id IN (@g_s6_sedan_pre, @g_s6_avant_pre, @g_s6_sedan_lci, @g_s6_avant_lci, @g_rs6_avant_pre, @g_rs6_avant_lci);

-- Source links for the cloned procedures (copy the existing spec_sources)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'procedures', p_new.id, ss.source_id
FROM procedures p_old
JOIN procedures p_new ON p_new.slug = p_old.slug
                    AND p_new.generation_id IN (@g_s6_sedan_pre, @g_s6_avant_pre, @g_s6_sedan_lci, @g_s6_avant_lci, @g_rs6_avant_pre, @g_rs6_avant_lci)
JOIN spec_sources ss ON ss.spec_table = 'procedures' AND ss.spec_id = p_old.id
WHERE p_old.generation_id = @gen_a6
  AND p_old.slug != 'dsg-7sp-fluid-change';

-- Electrical specs (battery / alternator / starter — same as A6 V6 variants).
INSERT INTO electrical_specs (generation_id, trim_id, market_id, battery_group, cca, ah, alternator_amps)
SELECT g.id, e.trim_id, e.market_id, e.battery_group, e.cca, e.ah, e.alternator_amps
FROM electrical_specs e
CROSS JOIN generations g
WHERE e.generation_id = @gen_a6
  AND g.id IN (@g_s6_sedan_pre, @g_s6_avant_pre, @g_s6_sedan_lci, @g_s6_avant_lci, @g_rs6_avant_pre, @g_rs6_avant_lci);

-- Bulbs — S6/RS6 share the A6 lighting package
INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory)
SELECT g.id, b.market_id, b.position, b.bulb_code, b.quantity, b.led_from_factory
FROM bulbs b
CROSS JOIN generations g
WHERE b.generation_id = @gen_a6
  AND g.id IN (@g_s6_sedan_pre, @g_s6_avant_pre, @g_s6_sedan_lci, @g_s6_avant_lci, @g_rs6_avant_pre, @g_rs6_avant_lci);

-- Fuses — same C8 electrical architecture
INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name, is_relay)
SELECT g.id, f.market_id, f.location, f.position, f.amperage, f.circuit_name, f.is_relay
FROM fuses f
CROSS JOIN generations g
WHERE f.generation_id = @gen_a6
  AND g.id IN (@g_s6_sedan_pre, @g_s6_avant_pre, @g_s6_sedan_lci, @g_s6_avant_lci, @g_rs6_avant_pre, @g_rs6_avant_lci);

-- Source-links for electrical/bulbs/fuses (per-table)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'electrical_specs', e_new.id, ss.source_id
FROM electrical_specs e_old
JOIN electrical_specs e_new ON e_new.generation_id IN (@g_s6_sedan_pre, @g_s6_avant_pre, @g_s6_sedan_lci, @g_s6_avant_lci, @g_rs6_avant_pre, @g_rs6_avant_lci)
                          AND (e_new.battery_group <=> e_old.battery_group)
                          AND (e_new.cca <=> e_old.cca)
JOIN spec_sources ss ON ss.spec_table = 'electrical_specs' AND ss.spec_id = e_old.id
WHERE e_old.generation_id = @gen_a6;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'bulbs', b_new.id, ss.source_id
FROM bulbs b_old
JOIN bulbs b_new ON b_new.generation_id IN (@g_s6_sedan_pre, @g_s6_avant_pre, @g_s6_sedan_lci, @g_s6_avant_lci, @g_rs6_avant_pre, @g_rs6_avant_lci)
                AND b_new.position = b_old.position
                AND (b_new.bulb_code <=> b_old.bulb_code)
JOIN spec_sources ss ON ss.spec_table = 'bulbs' AND ss.spec_id = b_old.id
WHERE b_old.generation_id = @gen_a6;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fuses', f_new.id, ss.source_id
FROM fuses f_old
JOIN fuses f_new ON f_new.generation_id IN (@g_s6_sedan_pre, @g_s6_avant_pre, @g_s6_sedan_lci, @g_s6_avant_lci, @g_rs6_avant_pre, @g_rs6_avant_lci)
                AND f_new.location = f_old.location
                AND f_new.position = f_old.position
                AND (f_new.circuit_name <=> f_old.circuit_name)
JOIN spec_sources ss ON ss.spec_table = 'fuses' AND ss.spec_id = f_old.id
WHERE f_old.generation_id = @gen_a6;

-- Per-trim citation against the HaynesPro source (so the trim performance
-- table shows a source citation badge).
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'trims', t.id, @s_haynes
FROM trims t
WHERE t.generation_id IN (@g_s6_sedan_pre, @g_s6_avant_pre, @g_s6_sedan_lci, @g_s6_avant_lci, @g_rs6_avant_pre, @g_rs6_avant_lci);

-- ----------------------------------------------------------------------------
-- 12. Audit
-- ----------------------------------------------------------------------------
SELECT
  (SELECT COUNT(*) FROM generations WHERE family_slug = 'audi-a6-c8-2018-present') AS family_gens,
  (SELECT COUNT(*) FROM trims WHERE generation_id IN (@g_s6_sedan_pre, @g_s6_avant_pre, @g_s6_sedan_lci, @g_s6_avant_lci, @g_rs6_avant_pre, @g_rs6_avant_lci)) AS s_rs_trims,
  (SELECT COUNT(*) FROM procedures WHERE generation_id IN (@g_s6_sedan_pre, @g_s6_avant_pre, @g_s6_sedan_lci, @g_s6_avant_lci, @g_rs6_avant_pre, @g_rs6_avant_lci)) AS s_rs_procedures,
  (SELECT COUNT(*) FROM bulbs WHERE generation_id IN (@g_s6_sedan_pre, @g_s6_avant_pre, @g_s6_sedan_lci, @g_s6_avant_lci, @g_rs6_avant_pre, @g_rs6_avant_lci)) AS s_rs_bulbs;

SELECT g.slug, COUNT(t.id) AS trims
FROM generations g
LEFT JOIN trims t ON t.generation_id = g.id
WHERE g.id IN (@g_s6_sedan_pre, @g_s6_avant_pre, @g_s6_sedan_lci, @g_s6_avant_lci, @g_rs6_avant_pre, @g_rs6_avant_lci)
GROUP BY g.id ORDER BY g.start_year, g.body_type, g.slug;
