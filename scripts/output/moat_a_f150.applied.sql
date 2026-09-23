-- ⚠️ DRY RUN — DO NOT APPLY WITHOUT CONTROLLER REVIEW. Not executed against prod.
-- Generated 2026-09-23/24 to prove the Moat-A (owner-manual → spec_facts) pipeline per
-- docs/superpowers/plans/2026-09-23-moat-a-oem-extraction.md (Tasks 1-6, tracer bullet only).
--
-- Subject: Ford F-150 (P702), generation_id = 26 (verified read-only:
--   SELECT g.id,g.slug,... WHERE g.slug LIKE '%f-150%'  ->  26 | f-150-p702-pickup-2021-2025 | 2021 | 2025 | make_id=8 Ford)
--
-- Sources (both already local at F:\projects\ownerspecs\manuals\, converted to .md this session
-- via scripts/convert_manuals.py — no bulk conversion, on-demand only per project convention):
--   PRIMARY   2024 MY OM  ford_2024_Ford_F-150_Owners_Manual_version_1_om_EN-US.pdf
--             775 pages, sha256 a4767780f03cb85e359ab68e0022077c9ab21fa85d84aad3beff0f0cf74d9f60
--             in-document footer: "Edition date: 202308" (Aug 2023)
--   SECONDARY 2021 MY OM  ford_2021-Ford-F-150-Owners-Manual-version-2_om_EN-US_10_2021.pdf
--             796 pages, sha256 3acfc485c60986463cab604a4c3838e8288fa1c1cf1093ef6a18dfef7277380f
--             in-document footer: "Edition date: 202104, Second-Printing" (Apr 2021)
--   original_url reconstructed from scripts/crawl_ford_us.py's documented naming convention
--   (fordservicecontent.com/Ford_Content/Catalog/owner_information/<basename-without-ford_-prefix>).
--   A live HEAD probe from this session got HTTP 403 from Akamai (bot-manager blocking a bare
--   curl, not evidence the file is gone — the crawler's own browser-fingerprint header set is
--   what got past it originally). CONTROLLER: please re-verify the URL resolves in a browser
--   before flipping public_link=1 live, or downgrade to public_link=0 if it doesn't.
--
-- Engine identity (read-only verification, no shadow-dupe issue found for the two engines used
-- here): engines.id=184 "Ford 2.7L EcoBoost Twin-Turbo V6" (code Nano), engines.id=25 "Coyote"
-- (5.0L V8). Both are cleanly linked to F-150 gen-26 trims with no duplicate/orphan competing rows.
-- NOTE: engines.id=172 (3.5L EcoBoost, code D35) is shared by BOTH the base F-150 3.5 EcoBoost
-- trims AND the Raptor 3.5 EcoBoost trim, but the 2024 OM prints DIFFERENT coolant capacities for
-- "3.5L EcoBoost, excluding Raptor" (13.1 L) vs "3.5L EcoBoost, Raptor" (12.7 L) — engine_id alone
-- cannot disambiguate which coolant value applies to which trim. Deliberately SKIPPED from this
-- tracer batch rather than guessing; flagged as a catalog gap (needs a trim-level qualifier or a
-- split engine row before Moat-A can cite 3.5L EcoBoost coolant capacity correctly).
-- Also skipped: 3.5L PowerBoost (HEV) coolant, which the OM reports as THREE circuit values
-- (low-temp w/ battery radiator, low-temp w/o, high-temp) — doesn't fit the single-scalar
-- coolant_capacity fact_type without inventing a new qualifier convention; flagged for plan 5/8.
--
-- fact_types used (already seeded by mig 579 — no schema extension needed for this tracer):
--   59 engine_oil_capacity (fluid, L, num) · 60 oil_viscosity (fluid, NULL, text)
--   62 coolant_capacity (fluid, L, num)     · 67 torque_lug_nut (torque, Nm, num)
-- markets: 1 = US (pre-existing, mig 001).
--
-- Two-edition cross-check outcome (per the "OM citation is not proof" + "cite 2-3 years apart"
-- rules): oil capacity/viscosity and lug-nut torque are IDENTICAL across the 2021 and 2024
-- editions -> single row, sourced to the 2024 (primary) edition, valid_from backdated to the
-- earliest confirming edition. Coolant capacity DIFFERS between editions on BOTH engines (a real
-- mid-cycle spec revision) -> two versioned rows each, per Task 5 Step 3's disagreement handling.
--
-- Legacy-schema cross-reference (fluid_specs/torque_specs, generation_id=26 — POINTER ONLY, not
-- ground truth, per CLAUDE.md/plan Task 1 Step 3): legacy engine_oil rows for id184/id25 already
-- matched the verified values (5.7 L / 7.33 L) so no discrepancy there. Legacy coolant rows
-- (14.30 L id184, 12.50 L id25) turned out to match neither edition exactly for id184 (14.30 vs
-- verified 14.3/14.6) and to match the OLDER 2021 edition exactly for id25 (12.50 vs verified
-- 12.5/13.5) — i.e. the legacy row was silently stale relative to the 2024 OM, exactly the failure
-- mode [[feedback_om_citation_not_verification]] warns about. Legacy torque_specs lug_nut
-- (204 Nm/150 ft-lb, "per 2022 F-150 OM") matches both editions actually pulled here.
--
-- Apply path (when the controller approves):
--   scp -i ~/.ssh/autodtcs_key scripts/output/moat_a_f150.sql root@72.62.154.119:/tmp/moat_a_f150.sql
--   ssh -i ~/.ssh/autodtcs_key root@72.62.154.119 'mariadb ownerspecs < /tmp/moat_a_f150.sql'
-- No build/deploy/render-layer change needed or performed (plan 4 stops at DB rows; plan 5 renders).

SET NAMES utf8mb4;

-- ===================================================================
-- 1. DOCUMENTS — one row per OM edition
-- ===================================================================

INSERT INTO documents
  (doc_type, provenance_kind, vehicle_instance_id, vehicle_type_id, generation_id, make_id,
   market_id, issuing_authority, citation, source_label, original_url, public_link,
   license, attribution, storage_path, file_sha256, page_count, edition, model_year,
   effective_date, retrieved_at, notes)
VALUES
  ('owner_manual', 'oem_portal', NULL, NULL, 26, 8,
   1, NULL, 'Ford F-150 Owner''s Manual (2024)', NULL,
   'https://www.fordservicecontent.com/Ford_Content/Catalog/owner_information/2024_Ford_F-150_Owners_Manual_version_1_om_EN-US.pdf', 0,
   NULL, NULL, 'manuals/ford_2024_Ford_F-150_Owners_Manual_version_1_om_EN-US.pdf',
   'a4767780f03cb85e359ab68e0022077c9ab21fa85d84aad3beff0f0cf74d9f60', 775, 'version 1', 2024,
   '2023-08-01', '2026-05-30 00:00:00',
   'Retrieved by scripts/crawl_ford_us.py; exact fetch timestamp not logged by the crawler — retrieved_at approximated from local file mtime. Primary edition for this tracer batch.');
SET @doc_2024 := LAST_INSERT_ID();

INSERT INTO documents
  (doc_type, provenance_kind, vehicle_instance_id, vehicle_type_id, generation_id, make_id,
   market_id, issuing_authority, citation, source_label, original_url, public_link,
   license, attribution, storage_path, file_sha256, page_count, edition, model_year,
   effective_date, retrieved_at, notes)
VALUES
  ('owner_manual', 'oem_portal', NULL, NULL, 26, 8,
   1, NULL, 'Ford F-150 Owner''s Manual (2021, Second Printing)', NULL,
   'https://www.fordservicecontent.com/Ford_Content/Catalog/owner_information/2021-Ford-F-150-Owners-Manual-version-2_om_EN-US_10_2021.pdf', 0,
   NULL, NULL, 'manuals/ford_2021-Ford-F-150-Owners-Manual-version-2_om_EN-US_10_2021.pdf',
   '3acfc485c60986463cab604a4c3838e8288fa1c1cf1093ef6a18dfef7277380f', 796, 'version 2 (Second Printing)', 2021,
   '2021-04-01', '2026-05-30 00:00:00',
   'Retrieved by scripts/crawl_ford_us.py; exact fetch timestamp not logged by the crawler — retrieved_at approximated from local file mtime. Secondary/cross-check edition — cited directly as source_document_id for the pre-revision coolant-capacity rows below.');
SET @doc_2021 := LAST_INSERT_ID();

-- ===================================================================
-- 2. SPEC_FACTS — engine-scoped (2.7L EcoBoost id=184, 5.0L Coyote id=25) + gen-wide (lug nut)
-- ===================================================================

-- --- 2.7L EcoBoost (engines.id = 184) -------------------------------------------------

-- engine_oil_capacity: 6.0 qt (5.7 L) incl. filter — IDENTICAL in both editions
--   2024 OM p.590 (PDF page 594): "Variant Including the Oil Filter / All. 6.0 qt (5.7 L)"
--   2021 OM p.591 (PDF page 596): same "6.0 qt (5.7 L)"
INSERT INTO spec_facts
  (generation_id, vehicle_type_id, engine_id, fact_type_id, qualifier, value_num, value_text, unit,
   is_primary, market_id, source_document_id, document_field_id, valid_from, valid_to,
   supersedes_id, change_set_id, conflict_group, qa_state, extracted_by, qa_by, qa_at)
VALUES
  (26, NULL, 184, 59, NULL, 5.700, NULL, 'L',
   1, 1, @doc_2024, NULL, '2021-04-01', NULL,
   NULL, NULL, NULL, 'pending', 'claude-tracer-bullet', NULL, NULL);

-- oil_viscosity: SAE 5W-30, WSS-M2C961-A1 — IDENTICAL in both editions
--   2024 OM p.590: "Motorcraft SAE 5W-30 Motor Oil ... WSS-M2C961-A1"
--   2021 OM p.591: "Motorcraft SAE 5W-30 Synthetic Blend Motor Oil ... WSS-M2C961-A1"
INSERT INTO spec_facts
  (generation_id, vehicle_type_id, engine_id, fact_type_id, qualifier, value_num, value_text, unit,
   is_primary, market_id, source_document_id, document_field_id, valid_from, valid_to,
   supersedes_id, change_set_id, conflict_group, qa_state, extracted_by, qa_by, qa_at)
VALUES
  (26, NULL, 184, 60, NULL, NULL, '5W-30 (WSS-M2C961-A1)', NULL,
   1, 1, @doc_2024, NULL, '2021-04-01', NULL,
   NULL, NULL, NULL, 'pending', 'claude-tracer-bullet', NULL, NULL);

-- coolant_capacity: DISAGREES between editions — genuine mid-cycle revision.
--   2021 OM p.598 (PDF page 603): "All. 15.1 qt (14.3 L)"
--   2024 OM p.597 (PDF page 601-602): "All. 15.4 qt (14.6 L)"
-- Row A (superseded, 2021-04-01 .. 2023-08-01):
INSERT INTO spec_facts
  (generation_id, vehicle_type_id, engine_id, fact_type_id, qualifier, value_num, value_text, unit,
   is_primary, market_id, source_document_id, document_field_id, valid_from, valid_to,
   supersedes_id, change_set_id, conflict_group, qa_state, extracted_by, qa_by, qa_at)
VALUES
  (26, NULL, 184, 62, NULL, 14.300, NULL, 'L',
   1, 1, @doc_2021, NULL, '2021-04-01', '2023-08-01',
   NULL, NULL, NULL, 'pending', 'claude-tracer-bullet', NULL, NULL);
SET @coolant_27_old := LAST_INSERT_ID();

-- Row B (current, 2023-08-01 ..):
INSERT INTO spec_facts
  (generation_id, vehicle_type_id, engine_id, fact_type_id, qualifier, value_num, value_text, unit,
   is_primary, market_id, source_document_id, document_field_id, valid_from, valid_to,
   supersedes_id, change_set_id, conflict_group, qa_state, extracted_by, qa_by, qa_at)
VALUES
  (26, NULL, 184, 62, NULL, 14.600, NULL, 'L',
   1, 1, @doc_2024, NULL, '2023-08-01', NULL,
   @coolant_27_old, NULL, NULL, 'pending', 'claude-tracer-bullet', NULL, NULL);

-- --- 5.0L Coyote V8 (engines.id = 25) --------------------------------------------------

-- engine_oil_capacity: 7.75 qt (7.33 L) incl. filter — IDENTICAL in both editions
--   2024 OM p.595 (PDF page 599-600): "Variant Including the Oil Filter / All. 7.75 qt (7.33 L)"
--   2021 OM p.596 (PDF page 601): same "7.75 qt (7.33 L)"
INSERT INTO spec_facts
  (generation_id, vehicle_type_id, engine_id, fact_type_id, qualifier, value_num, value_text, unit,
   is_primary, market_id, source_document_id, document_field_id, valid_from, valid_to,
   supersedes_id, change_set_id, conflict_group, qa_state, extracted_by, qa_by, qa_at)
VALUES
  (26, NULL, 25, 59, NULL, 7.330, NULL, 'L',
   1, 1, @doc_2024, NULL, '2021-04-01', NULL,
   NULL, NULL, NULL, 'pending', 'claude-tracer-bullet', NULL, NULL);

-- oil_viscosity: SAE 5W-30, WSS-M2C961-A1 — IDENTICAL in both editions
INSERT INTO spec_facts
  (generation_id, vehicle_type_id, engine_id, fact_type_id, qualifier, value_num, value_text, unit,
   is_primary, market_id, source_document_id, document_field_id, valid_from, valid_to,
   supersedes_id, change_set_id, conflict_group, qa_state, extracted_by, qa_by, qa_at)
VALUES
  (26, NULL, 25, 60, NULL, NULL, '5W-30 (WSS-M2C961-A1)', NULL,
   1, 1, @doc_2024, NULL, '2021-04-01', NULL,
   NULL, NULL, NULL, 'pending', 'claude-tracer-bullet', NULL, NULL);

-- coolant_capacity: DISAGREES between editions — genuine mid-cycle revision.
--   2021 OM p.601 (PDF page 606): "All. 13.2 qt (12.5 L)"
--   2024 OM p.600 (PDF page 604): "All. 14.3 qt (13.5 L)"
-- Row A (superseded, 2021-04-01 .. 2023-08-01):
INSERT INTO spec_facts
  (generation_id, vehicle_type_id, engine_id, fact_type_id, qualifier, value_num, value_text, unit,
   is_primary, market_id, source_document_id, document_field_id, valid_from, valid_to,
   supersedes_id, change_set_id, conflict_group, qa_state, extracted_by, qa_by, qa_at)
VALUES
  (26, NULL, 25, 62, NULL, 12.500, NULL, 'L',
   1, 1, @doc_2021, NULL, '2021-04-01', '2023-08-01',
   NULL, NULL, NULL, 'pending', 'claude-tracer-bullet', NULL, NULL);
SET @coolant_50_old := LAST_INSERT_ID();

-- Row B (current, 2023-08-01 ..):
INSERT INTO spec_facts
  (generation_id, vehicle_type_id, engine_id, fact_type_id, qualifier, value_num, value_text, unit,
   is_primary, market_id, source_document_id, document_field_id, valid_from, valid_to,
   supersedes_id, change_set_id, conflict_group, qa_state, extracted_by, qa_by, qa_at)
VALUES
  (26, NULL, 25, 62, NULL, 13.500, NULL, 'L',
   1, 1, @doc_2024, NULL, '2023-08-01', NULL,
   @coolant_50_old, NULL, NULL, 'pending', 'claude-tracer-bullet', NULL, NULL);

-- --- Gen-wide (engine_id NULL): wheel/lug-nut torque -----------------------------------

-- torque_lug_nut: M14 x 1.5 bolt, 150 lb-ft (204 Nm) — IDENTICAL in both editions
--   2024 OM p.577 "WHEEL NUTS" (PDF page 581): "M14 x 1.5 / 150 lb.ft (204 Nm)"
--   2021 OM p.572 "WHEEL NUTS" (PDF page 576): same "M14 x 1.5 / 150 lb.ft (204 Nm)"
INSERT INTO spec_facts
  (generation_id, vehicle_type_id, engine_id, fact_type_id, qualifier, value_num, value_text, unit,
   is_primary, market_id, source_document_id, document_field_id, valid_from, valid_to,
   supersedes_id, change_set_id, conflict_group, qa_state, extracted_by, qa_by, qa_at)
VALUES
  (26, NULL, NULL, 67, NULL, 204.000, NULL, 'Nm',
   1, 1, @doc_2024, NULL, '2021-04-01', NULL,
   NULL, NULL, NULL, 'pending', 'claude-tracer-bullet', NULL, NULL);

-- ===================================================================
-- 3. Sanity check (run after apply, not part of the write)
-- ===================================================================
-- SELECT COUNT(*) FROM spec_facts WHERE generation_id = 26 AND qa_state = 'approved';
-- Expect: 9 (2 oil_capacity + 2 oil_viscosity + 4 coolant_capacity [2 superseded + 2 current] + 1 torque_lug_nut)
