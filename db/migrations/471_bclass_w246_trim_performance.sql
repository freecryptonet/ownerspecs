-- mig 471: Mercedes-Benz B-Class (W246) gen 317 — fill trim performance columns.
-- The trim comparison table rendered torque/0-100/top-speed/fuel/CO2/trans as "—"
-- for the 12 ICE variants. Figures from auto-data.net per-variant pages (the catalog
-- source the site's trims use; performance + marketing numbers). Fuel/CO2 use the
-- lower bound of the published range. Transmission: 7G-DCT=16, 6-speed manual=11,
-- single-speed EV=20.

SET @gen := 317;

UPDATE trims SET torque_nm=180, zero_100_kmh_s=10.7, top_speed_kmh=190, fuel_combined_l_100km=5.5, co2_g_km=126, transmission_id=11 WHERE generation_id=@gen AND slug='b-160-102-hp';
UPDATE trims SET torque_nm=200, zero_100_kmh_s=10.4, top_speed_kmh=190, fuel_combined_l_100km=5.9, co2_g_km=137, transmission_id=11 WHERE generation_id=@gen AND slug='b-180-122-hp';
UPDATE trims SET torque_nm=250, zero_100_kmh_s=8.6,  top_speed_kmh=220, fuel_combined_l_100km=5.9, co2_g_km=137, transmission_id=11 WHERE generation_id=@gen AND slug='b-200-156-hp';
UPDATE trims SET torque_nm=270, zero_100_kmh_s=9.2,  top_speed_kmh=200, transmission_id=11 WHERE generation_id=@gen AND slug='b-200-ngt-156-hp';
UPDATE trims SET torque_nm=300, zero_100_kmh_s=7.5,  top_speed_kmh=225, fuel_combined_l_100km=6.5, co2_g_km=151, transmission_id=16 WHERE generation_id=@gen AND slug='b-220-4matic-184-hp';
UPDATE trims SET torque_nm=350, zero_100_kmh_s=6.7,  top_speed_kmh=235, fuel_combined_l_100km=6.6, co2_g_km=154, transmission_id=16 WHERE generation_id=@gen AND slug='b-250-4matic-211-hp';
UPDATE trims SET torque_nm=240, zero_100_kmh_s=14.0, top_speed_kmh=180, fuel_combined_l_100km=4.1, co2_g_km=108, transmission_id=11 WHERE generation_id=@gen AND slug='b-160-cdi-90-hp';
UPDATE trims SET torque_nm=260, zero_100_kmh_s=11.6, top_speed_kmh=190, fuel_combined_l_100km=4.1, co2_g_km=108, transmission_id=11 WHERE generation_id=@gen AND slug='b-180-cdi-109-hp';
UPDATE trims SET torque_nm=300, zero_100_kmh_s=9.5,  top_speed_kmh=210, fuel_combined_l_100km=4.4, co2_g_km=114, transmission_id=11 WHERE generation_id=@gen AND slug='b-200-cdi-136-hp';
UPDATE trims SET torque_nm=300, zero_100_kmh_s=9.8,  top_speed_kmh=207, fuel_combined_l_100km=5.0, co2_g_km=130, transmission_id=16 WHERE generation_id=@gen AND slug='b-200-cdi-4matic-136-hp';
UPDATE trims SET torque_nm=350, zero_100_kmh_s=8.3,  top_speed_kmh=220, fuel_combined_l_100km=4.4, co2_g_km=114, transmission_id=16 WHERE generation_id=@gen AND slug='b-220-cdi-170-hp';
UPDATE trims SET torque_nm=350, zero_100_kmh_s=8.3,  top_speed_kmh=220, fuel_combined_l_100km=5.0, co2_g_km=130, transmission_id=16 WHERE generation_id=@gen AND slug='b-220d-4matic-177-hp';
-- B 250 e: torque/0-100/top already set in mig 470; add single-speed gearbox + zero tailpipe CO2.
UPDATE trims SET transmission_id=20, co2_g_km=0 WHERE generation_id=@gen AND slug='b-250e';
