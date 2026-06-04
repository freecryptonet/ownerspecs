-- 575: BEV moat for the PSA e-CMP electrics — e-208 (trim 1400), e-2008 (1405),
-- e-C4 54 kWh (1436) + 50 kWh (1437). EV catalog columns on `trims` (battery,
-- range, charging, consumption, plug) — catalog data, NOT citation-gated, same
-- posture as hp/CO2 (per the EV data model). Figures from auto-data per-variant
-- pages; DC 100 kW / CCS / ~30 min 0-80% / 7.4 kW AC are the e-CMP platform
-- constants (PSA press + ev-database cross-check). hp = peak power.
-- Single-speed reduction gearbox fluid added gen-wide (renders on /differential-fluid).

-- e-208 50 kWh (gen 521) — 100 kW / 136 hp
UPDATE trims SET hp=136, battery_kwh_total=50, battery_kwh_usable=46, range_wltp_km=350,
  dc_charge_kw=100, ac_charge_kw=7.4, charge_10_80_min=30, consumption_wh_km=154, plug_type='CCS (Combo 2)'
  WHERE id=1400;
-- e-2008 50 kWh (gen 522) — 100 kW / 136 hp
UPDATE trims SET hp=136, battery_kwh_total=50, battery_kwh_usable=46, range_wltp_km=330,
  dc_charge_kw=100, ac_charge_kw=7.4, charge_10_80_min=30, consumption_wh_km=157, plug_type='CCS (Combo 2)'
  WHERE id=1405;
-- e-C4 54 kWh (gen 525) — 115 kW / 156 hp
UPDATE trims SET hp=156, battery_kwh_total=54, battery_kwh_usable=51, range_wltp_km=410,
  dc_charge_kw=100, ac_charge_kw=7.4, charge_10_80_min=30, consumption_wh_km=147, plug_type='CCS (Combo 2)'
  WHERE id=1436;
-- e-C4 50 kWh (gen 525) — 100 kW / 136 hp
UPDATE trims SET hp=136, battery_kwh_total=50, battery_kwh_usable=45, range_wltp_km=350,
  dc_charge_kw=100, ac_charge_kw=7.4, charge_10_80_min=30, consumption_wh_km=166, plug_type='CCS (Combo 2)'
  WHERE id=1437;

-- Reduction-gear (single-speed reducer) fluid — gen-wide for the BEV variant.
-- 75W / PSA B71 2316. Cite each gen's vendor-neutral source.
INSERT INTO fluid_specs (generation_id, fluid_type, viscosity, spec_standard, notes) VALUES
  (521, 'reduction_gear', 'SAE 75W', 'PSA B71 2316', 'e-208 single-speed reduction gearbox (e-CMP BEV); filled for life'),
  (522, 'reduction_gear', 'SAE 75W', 'PSA B71 2316', 'e-2008 single-speed reduction gearbox (e-CMP BEV); filled for life'),
  (525, 'reduction_gear', 'SAE 75W', 'PSA B71 2316', 'e-C4 single-speed reduction gearbox (e-CMP BEV); filled for life');

INSERT INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, 1685 FROM fluid_specs WHERE generation_id=521 AND fluid_type='reduction_gear';
INSERT INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, 1691 FROM fluid_specs WHERE generation_id=522 AND fluid_type='reduction_gear';
INSERT INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, 1729 FROM fluid_specs WHERE generation_id=525 AND fluid_type='reduction_gear';
