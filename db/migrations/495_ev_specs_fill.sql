-- 495: fill EV battery/range/charging on trims (catalog data, like hp/CO2 — not
-- citation-gated). EPA range from fueleconomy.gov (official US), converted mi->km;
-- WLTP + charging from manufacturer press, cross-verified (ev-database used only
-- where >=2 sources agreed). EPA left NULL for non-US trims. range_epa_km is a
-- representative figure (EPA varies by wheel). Tesla: usable kWh + pack voltage
-- left NULL (Tesla publishes none; only multi-source-solid fields written).

ALTER TABLE trims MODIFY plug_type VARCHAR(24) NULL;

-- ===== BMW i (gens 119/129/135/169/206/210/266) =====
UPDATE trims SET battery_kwh_usable=80.7, battery_kwh_total=83.9, pack_voltage=400, range_epa_km=455, range_wltp_km=590, dc_charge_kw=205, ac_charge_kw=11, charge_10_80_min=31, consumption_wh_km=160, plug_type='CCS (CCS1 US)' WHERE id=411; -- i4 eDrive40
UPDATE trims SET battery_kwh_usable=80.7, battery_kwh_total=83.9, pack_voltage=400, range_epa_km=433, range_wltp_km=510, dc_charge_kw=205, ac_charge_kw=11, charge_10_80_min=31, consumption_wh_km=190, plug_type='CCS (CCS1 US)' WHERE id=412; -- i4 M50
UPDATE trims SET battery_kwh_usable=81.2, battery_kwh_total=84.4, pack_voltage=400, range_epa_km=475, range_wltp_km=540, dc_charge_kw=205, ac_charge_kw=11, charge_10_80_min=30, consumption_wh_km=165, plug_type='CCS (CCS1 US)' WHERE id=567; -- i5 eDrive40
UPDATE trims SET battery_kwh_usable=81.2, battery_kwh_total=84.4, pack_voltage=400, range_epa_km=433, range_wltp_km=500, dc_charge_kw=205, ac_charge_kw=11, charge_10_80_min=30, consumption_wh_km=175, plug_type='CCS (CCS1 US)' WHERE id=568; -- i5 xDrive40
UPDATE trims SET battery_kwh_usable=81.2, battery_kwh_total=84.4, pack_voltage=400, range_epa_km=412, range_wltp_km=485, dc_charge_kw=205, ac_charge_kw=11, charge_10_80_min=30, consumption_wh_km=195, plug_type='CCS (CCS1 US)' WHERE id=569; -- i5 M60
UPDATE trims SET battery_kwh_usable=81.2, battery_kwh_total=84.4, pack_voltage=400, range_wltp_km=520, dc_charge_kw=205, ac_charge_kw=11, charge_10_80_min=30, consumption_wh_km=170, plug_type='CCS (Combo 2, EU)' WHERE id=615; -- i5 Touring eDrive40 (not US)
UPDATE trims SET battery_kwh_usable=81.2, battery_kwh_total=84.4, pack_voltage=400, range_wltp_km=490, dc_charge_kw=205, ac_charge_kw=11, charge_10_80_min=30, consumption_wh_km=185, plug_type='CCS (Combo 2, EU)' WHERE id=616; -- i5 Touring xDrive40
UPDATE trims SET battery_kwh_usable=81.2, battery_kwh_total=84.4, pack_voltage=400, range_wltp_km=470, dc_charge_kw=205, ac_charge_kw=11, charge_10_80_min=30, consumption_wh_km=200, plug_type='CCS (Combo 2, EU)' WHERE id=617; -- i5 Touring M60
UPDATE trims SET battery_kwh_usable=74, battery_kwh_total=80, pack_voltage=400, range_wltp_km=460, dc_charge_kw=150, ac_charge_kw=11, charge_10_80_min=34, consumption_wh_km=187, plug_type='CCS (Combo 2, EU)' WHERE id=910; -- iX3 (not US)
UPDATE trims SET battery_kwh_usable=101.7, battery_kwh_total=105.7, pack_voltage=400, range_epa_km=512, range_wltp_km=611, dc_charge_kw=195, ac_charge_kw=11, charge_10_80_min=34, consumption_wh_km=191, plug_type='CCS (CCS1 US)' WHERE id=903; -- i7 eDrive50
UPDATE trims SET battery_kwh_usable=101.7, battery_kwh_total=105.7, pack_voltage=400, range_epa_km=499, range_wltp_km=605, dc_charge_kw=195, ac_charge_kw=11, charge_10_80_min=34, consumption_wh_km=196, plug_type='CCS (CCS1 US)' WHERE id=904; -- i7 xDrive60
UPDATE trims SET battery_kwh_usable=101.7, battery_kwh_total=105.7, pack_voltage=400, range_epa_km=459, range_wltp_km=525, dc_charge_kw=195, ac_charge_kw=11, charge_10_80_min=34, consumption_wh_km=215, plug_type='CCS (CCS1 US)' WHERE id=905; -- i7 M70
UPDATE trims SET battery_kwh_usable=64.7, battery_kwh_total=66.5, pack_voltage=400, range_wltp_km=430, dc_charge_kw=130, ac_charge_kw=11, charge_10_80_min=29, consumption_wh_km=172, plug_type='CCS (Combo 2, EU)' WHERE id=909; -- iX1 xDrive30 (not US)
UPDATE trims SET battery_kwh_usable=71, battery_kwh_total=76.6, pack_voltage=400, range_wltp_km=445, dc_charge_kw=150, ac_charge_kw=11, charge_10_80_min=31, consumption_wh_km=190, plug_type='CCS (Combo 2, EU)' WHERE id=906; -- iX xDrive40 (not US)
UPDATE trims SET battery_kwh_usable=105.2, battery_kwh_total=111.5, pack_voltage=400, range_epa_km=497, range_wltp_km=600, dc_charge_kw=195, ac_charge_kw=11, charge_10_80_min=35, consumption_wh_km=195, plug_type='CCS (CCS1 US)' WHERE id=907; -- iX xDrive50
UPDATE trims SET battery_kwh_usable=105.2, battery_kwh_total=111.5, pack_voltage=400, range_epa_km=459, range_wltp_km=540, dc_charge_kw=195, ac_charge_kw=11, charge_10_80_min=38, consumption_wh_km=215, plug_type='CCS (CCS1 US)' WHERE id=908; -- iX M60

-- ===== Hyundai IONIQ 5 (39) + Kia EV6 (120) — 800V E-GMP =====
UPDATE trims SET battery_kwh_usable=54, battery_kwh_total=58, pack_voltage=523, range_epa_km=354, range_wltp_km=400, dc_charge_kw=175, ac_charge_kw=11, charge_10_80_min=17, consumption_wh_km=163, plug_type='CCS (CCS1 US)' WHERE id=150; -- IONIQ5 SR RWD
UPDATE trims SET battery_kwh_usable=54, battery_kwh_total=58, pack_voltage=523, range_wltp_km=362, dc_charge_kw=175, ac_charge_kw=11, charge_10_80_min=17, consumption_wh_km=181, plug_type='CCS (CCS1 US)' WHERE id=149; -- IONIQ5 SR AWD (not US)
UPDATE trims SET battery_kwh_usable=70, battery_kwh_total=72.6, pack_voltage=653, range_epa_km=412, range_wltp_km=481, dc_charge_kw=221, ac_charge_kw=11, charge_10_80_min=17, consumption_wh_km=189, plug_type='CCS (CCS1 US)' WHERE id=152; -- IONIQ5 LR AWD
UPDATE trims SET battery_kwh_usable=80, battery_kwh_total=84, pack_voltage=697, range_epa_km=356, range_wltp_km=448, dc_charge_kw=238, ac_charge_kw=11, charge_10_80_min=18, consumption_wh_km=224, plug_type='CCS (CCS1 US)' WHERE id=151; -- IONIQ5 N
UPDATE trims SET battery_kwh_usable=54, battery_kwh_total=58, pack_voltage=523, range_epa_km=373, range_wltp_km=394, dc_charge_kw=175, ac_charge_kw=11, charge_10_80_min=18, consumption_wh_km=172, plug_type='CCS (CCS1 US)' WHERE id=400; -- EV6 RWD SR (167hp = 58kWh)
UPDATE trims SET battery_kwh_usable=74, battery_kwh_total=77.4, pack_voltage=697, range_epa_km=499, range_wltp_km=528, dc_charge_kw=233, ac_charge_kw=11, charge_10_80_min=18, consumption_wh_km=172, plug_type='CCS (CCS1 US)' WHERE id=401; -- EV6 RWD LR
UPDATE trims SET battery_kwh_usable=74, battery_kwh_total=77.4, pack_voltage=697, range_epa_km=441, range_wltp_km=506, dc_charge_kw=233, ac_charge_kw=11, charge_10_80_min=18, consumption_wh_km=172, plug_type='CCS (CCS1 US)' WHERE id=402; -- EV6 AWD GT-Line

-- ===== Nissan Ariya (163) + Leaf (319) + Audi Q8 e-tron (292) — ~400V =====
UPDATE trims SET battery_kwh_usable=87, battery_kwh_total=91, pack_voltage=355, range_epa_km=465, range_wltp_km=533, dc_charge_kw=130, ac_charge_kw=7.4, charge_10_80_min=35, consumption_wh_km=163, plug_type='CCS (CCS1 US)' WHERE id=911; -- Ariya FWD 87
UPDATE trims SET battery_kwh_usable=87, battery_kwh_total=91, pack_voltage=355, range_epa_km=438, range_wltp_km=510, dc_charge_kw=130, ac_charge_kw=7.4, charge_10_80_min=35, consumption_wh_km=175, plug_type='CCS (CCS1 US)' WHERE id=912; -- Ariya e-4ORCE AWD 87
UPDATE trims SET battery_kwh_usable=39, battery_kwh_total=40, pack_voltage=350, range_epa_km=240, range_wltp_km=270, dc_charge_kw=50, ac_charge_kw=6.6, consumption_wh_km=164, plug_type='CHAdeMO' WHERE id=913; -- Leaf 40
UPDATE trims SET battery_kwh_usable=59, battery_kwh_total=62, pack_voltage=350, range_epa_km=346, range_wltp_km=385, dc_charge_kw=100, ac_charge_kw=6.6, charge_10_80_min=45, consumption_wh_km=185, plug_type='CHAdeMO' WHERE id=914; -- Leaf e+ 62
UPDATE trims SET battery_kwh_usable=89, battery_kwh_total=95, pack_voltage=396, range_wltp_km=491, dc_charge_kw=150, ac_charge_kw=11, charge_10_80_min=28, consumption_wh_km=219, plug_type='CCS (CCS1 US)' WHERE id=915; -- Q8 50 (not US)
UPDATE trims SET battery_kwh_usable=106, battery_kwh_total=114, pack_voltage=396, range_epa_km=459, range_wltp_km=582, dc_charge_kw=170, ac_charge_kw=11, charge_10_80_min=31, consumption_wh_km=218, plug_type='CCS (CCS1 US)' WHERE id=916; -- Q8 55
UPDATE trims SET battery_kwh_usable=106, battery_kwh_total=114, pack_voltage=396, range_epa_km=407, range_wltp_km=499, dc_charge_kw=170, ac_charge_kw=11, charge_10_80_min=31, consumption_wh_km=255, plug_type='CCS (CCS1 US)' WHERE id=917; -- SQ8

-- ===== Tesla (25/46/116) — EPA/charging/plug only; usable kWh + voltage NULL (unpublished) =====
UPDATE trims SET range_epa_km=386, range_wltp_km=409, dc_charge_kw=170, ac_charge_kw=11, consumption_wh_km=162, plug_type='NACS (CCS in EU)' WHERE id=94;  -- M3 SR+
UPDATE trims SET range_epa_km=518, range_wltp_km=580, dc_charge_kw=250, ac_charge_kw=11, consumption_wh_km=160, plug_type='NACS (CCS in EU)' WHERE id=97;  -- M3 LR RWD
UPDATE trims SET range_epa_km=518, range_wltp_km=580, dc_charge_kw=250, ac_charge_kw=11, consumption_wh_km=160, plug_type='NACS (CCS in EU)' WHERE id=96;  -- M3 LR AWD
UPDATE trims SET range_epa_km=507, range_wltp_km=530, dc_charge_kw=250, ac_charge_kw=11, consumption_wh_km=166, plug_type='NACS (CCS in EU)' WHERE id=95;  -- M3 Performance
UPDATE trims SET range_epa_km=393, range_wltp_km=455, dc_charge_kw=170, ac_charge_kw=11, consumption_wh_km=150, plug_type='NACS (CCS in EU)' WHERE id=182; -- MY SR 60
UPDATE trims SET range_epa_km=393, range_wltp_km=410, dc_charge_kw=170, ac_charge_kw=11, consumption_wh_km=160, plug_type='NACS (CCS in EU)' WHERE id=183; -- MY SR 50
UPDATE trims SET range_epa_km=488, range_wltp_km=514, dc_charge_kw=250, ac_charge_kw=11, consumption_wh_km=170, plug_type='NACS (CCS in EU)' WHERE id=184; -- MY Perf 80.5
UPDATE trims SET range_epa_km=488, range_wltp_km=480, dc_charge_kw=250, ac_charge_kw=11, consumption_wh_km=170, plug_type='NACS (CCS in EU)' WHERE id=185; -- MY Perf 75
UPDATE trims SET range_epa_km=525, range_wltp_km=533, dc_charge_kw=250, ac_charge_kw=11, consumption_wh_km=168, plug_type='NACS (CCS in EU)' WHERE id=186; -- MY LR 80.5
UPDATE trims SET range_epa_km=531, range_wltp_km=533, dc_charge_kw=250, ac_charge_kw=11, consumption_wh_km=162, plug_type='NACS (CCS in EU)' WHERE id=187; -- MY LR 78.1
UPDATE trims SET battery_kwh_total=100, range_epa_km=652, range_wltp_km=634, dc_charge_kw=250, ac_charge_kw=11.5, consumption_wh_km=160, plug_type='NACS (CCS in EU)' WHERE id=428; -- Model S LR
UPDATE trims SET battery_kwh_total=100, range_epa_km=637, range_wltp_km=600, dc_charge_kw=250, ac_charge_kw=11.5, consumption_wh_km=160, plug_type='NACS (CCS in EU)' WHERE id=429; -- Model S Plaid
