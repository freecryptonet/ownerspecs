-- 494: EV-specific trim columns. EVs need battery/range/charging data that ICE
-- trims don't — our schema had none, so EV pages showed only hp/torque + fluids.
-- All nullable; ICE trims leave them NULL. Per-variant (range/battery differ by trim).
ALTER TABLE trims
  ADD COLUMN battery_kwh_usable DECIMAL(5,1) NULL AFTER fuel_combined_l_100km,
  ADD COLUMN battery_kwh_total  DECIMAL(5,1) NULL AFTER battery_kwh_usable,
  ADD COLUMN pack_voltage       SMALLINT UNSIGNED NULL AFTER battery_kwh_total,
  ADD COLUMN range_epa_km       SMALLINT UNSIGNED NULL AFTER pack_voltage,
  ADD COLUMN range_wltp_km      SMALLINT UNSIGNED NULL AFTER range_epa_km,
  ADD COLUMN dc_charge_kw       SMALLINT UNSIGNED NULL AFTER range_wltp_km,
  ADD COLUMN ac_charge_kw       DECIMAL(4,1) NULL AFTER dc_charge_kw,
  ADD COLUMN charge_10_80_min   SMALLINT UNSIGNED NULL AFTER ac_charge_kw,
  ADD COLUMN consumption_wh_km  SMALLINT UNSIGNED NULL AFTER charge_10_80_min,
  ADD COLUMN plug_type          VARCHAR(16) NULL AFTER consumption_wh_km;
