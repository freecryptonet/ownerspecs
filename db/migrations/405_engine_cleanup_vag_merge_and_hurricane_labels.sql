-- mig 405: engine data cleanup — merge orphan VAG engine rows + scrub "Hurricane" trim labels
--
-- TWO independent cleanups bundled (one rebuild):
--
-- PART A — Hurricane trim-name leftovers (cosmetic, rendered on live trim pages)
--   "Hurricane" is the wrong engine name for both the 2.0L GME-T4 and the 1.3L GSE-T4
--   (the real Hurricane is a 3.0L twin-turbo I6). Scrub the word from 3 trim display names.
--
-- PART B — orphan-engine merge (fixes a VISIBLE duplicate-content bug)
--   Each of these 8 VAG engines exists as TWO rows:
--     * survivor = the live "EA888 / <code>" row — carries all the trims AND the correct
--       hand-seeded fluids (oil 0W-20 / VW 508.00 + filter 06L115562B, coolant G12EVO).
--     * orphan   = the clean-code "<code>" row — ZERO trims, only auto-data scraper-junk
--       fluids (oil mis-specced 0W-30 / 5W-40 / VW 502 00 / VW 504 00, DCT fluid absurdly
--       labelled "SAE 75W-90"). These orphan fluids render as a phantom second engine block
--       on gen oil-capacity pages (confirmed live on /audi/a4-sedan-b9-2015-2018/oil-capacity).
--
--   Fix: delete each orphan's spec_sources + fluid_specs + the orphan engine row, then move
--   the clean code/slug/display_name onto the survivor. code & slug are UNIQUE, so the orphan
--   must be deleted before the survivor can take its slug.
--
--   survivor -> orphan (clean code / slug / display_name):
--     20  -> 354  DNFG  dnfg  "R (2.0 TSI) (DNFG) 235kW"   (VW Golf Mk8 R)
--     36  -> 276  CYRB  cyrb  "2.0 TFSI (CYRB) 185kW"      (Audi A4 B9)
--     37  -> 266  CVKB  cvkb  "2.0 TFSI (CVKB) 140kW"      (Audi A4 B9)
--     72  -> 259  CHHB  chhb  "2.0 TSI (CHHB) 162kW"       (VW Passat B8 / Tiguan AD1)
--     73  -> 337  DKZA  dkza  "2.0 TSI (DKZA) 140kW"       (VW Tiguan AD1)
--     74  -> 285  CZPA  czpa  "2.0 TFSI (CZPA) 132kW"      (VW Tiguan AD1)
--     242 -> 300  DDVB  ddvb  "50 TDI (DDVB) 210kW"        (Audi A6 C8)
--     243 -> 345  DMGA  dmga  "3.0 TDI MHEV (DMGA) 210kW"  (Audi A6 C8)
--
--   Orphans confirmed (mig-405 pre-check) to hold fluid_specs ONLY — 0 trims/torque/parts/intervals.
--   Survivor's old ugly /engines/ea888-<code> URL will 404 after the slug move; the clean
--   /engines/<code> URL stays live (now served by the merged survivor). No internal links break
--   (gen-page engine links read engines.slug and update on rebuild).
--
-- VERIFICATION STATUS (per the two-source rule):
--   * Spec DIRECTION verified: EA888 evo4 = 0W-20 / VW 508.00; HaynesPro A4 B9 CVKB t_318011812
--     confirms 0DJ 6-spd manual + 0CK 7-spd DCT (so the orphan DCT "SAE 75W-90" is junk). The
--     merge keeps the correct survivor specs by deleting the wrong orphan rows.
--   * Capacity NUMBERS retained from prior seeding, NOT re-verified this session (HaynesPro
--     adjustmentData + Audi OM portal both resisted automated extraction). FLAGGED for a later
--     targeted pass — the survivor litres kept as-is:
--       coolant total: CVKB/CYRB 8.0 L · CHHB/DKZA/CZPA 8.5 L · DNFG 9.0 L
--       engine oil (w/ filter): ~5.2 L (2.0 TFSI) / 5.7 L (Golf R) — confirm per engine
--       manual gearbox (0DJ): 1.9 L · DSG (0CK): 5.5 L
--   These numbers are unchanged by this migration; they're listed so the follow-up pass knows
--   exactly which cells still need a HaynesPro/OEM litre confirmation.

-- ---- PART A: Hurricane trim-label scrub -------------------------------------
UPDATE trims SET name = '2.0 Turbo I4 Trailhawk Elite (270 Hp) AWD 9AT' WHERE id = 863;
UPDATE trims SET name = '1.3 T4 Sport/Latitude (177 Hp) FWD/AWD 9AT'    WHERE id = 867;
UPDATE trims SET name = 'GT 2.0 Turbo AWD (268 Hp) 9AT'                 WHERE id = 870;

-- ---- PART B: orphan-engine merge --------------------------------------------
-- 1. drop spec_sources tied to the orphan fluid_specs (avoid dangling citations)
DELETE ss FROM spec_sources ss
WHERE ss.spec_table = 'fluid_specs'
  AND ss.spec_id IN (SELECT id FROM fluid_specs WHERE engine_id IN (259,266,276,285,300,337,345,354));

-- 2. drop the orphan scraper-junk fluid rows (also removes the phantom engine block)
DELETE FROM fluid_specs WHERE engine_id IN (259,266,276,285,300,337,345,354);

-- 3. delete the orphan engine rows (frees the clean code + slug)
DELETE FROM engines WHERE id IN (259,266,276,285,300,337,345,354);

-- 4. move the clean code / slug / display_name onto the live survivor rows
UPDATE engines SET code='DNFG', slug='dnfg', display_name='R (2.0 TSI) (DNFG) 235kW'  WHERE id=20;
UPDATE engines SET code='CYRB', slug='cyrb', display_name='2.0 TFSI (CYRB) 185kW'     WHERE id=36;
UPDATE engines SET code='CVKB', slug='cvkb', display_name='2.0 TFSI (CVKB) 140kW'     WHERE id=37;
UPDATE engines SET code='CHHB', slug='chhb', display_name='2.0 TSI (CHHB) 162kW'      WHERE id=72;
UPDATE engines SET code='DKZA', slug='dkza', display_name='2.0 TSI (DKZA) 140kW'      WHERE id=73;
UPDATE engines SET code='CZPA', slug='czpa', display_name='2.0 TFSI (CZPA) 132kW'     WHERE id=74;
UPDATE engines SET code='DDVB', slug='ddvb', display_name='50 TDI (DDVB) 210kW'       WHERE id=242;
UPDATE engines SET code='DMGA', slug='dmga', display_name='3.0 TDI MHEV (DMGA) 210kW' WHERE id=243;
