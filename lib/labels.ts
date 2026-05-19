/**
 * Single source of truth for every "DB enum value → human-readable label"
 * mapping in the catalogue. Previously each page maintained its own
 * Record<string, string> which:
 *   1. Diverged across pages (gen hub had transmission_cvt, oil-capacity
 *      page didn't, etc.)
 *   2. Carried demo data ("Engine oil (1.5T)") that leaked onto every
 *      generation regardless of model.
 *   3. Fell through to raw underscore strings ("transmission at",
 *      "front differential") when a DB value wasn't in the map.
 *
 * Rules for adding entries:
 *   - The MAP value is the canonical user-facing label.
 *   - No model/engine-specific qualifiers in labels. "Engine oil", not
 *     "Engine oil (1.5T)". Engine-specific context belongs in row notes.
 *   - When a new fluid/torque/service/etc. type is added in a migration,
 *     add the label here in the same change.
 *
 * Fallback: every helper calls humanize() which produces "Front
 * differential" from "front_differential" — readable even if no map entry
 * exists. So missing entries degrade gracefully instead of looking broken.
 */

/** Convert "front_differential" → "Front differential". */
export function humanize(raw: string): string {
  return raw
    .replace(/[_-]/g, " ")
    .replace(/\s+/g, " ")
    .trim()
    .replace(/(^|\s)(\S)/g, (_, sp, ch) => sp + ch.toUpperCase());
}

// ───────────────────────── fluid_specs.fluid_type ─────────────────────────

export const fluidLabels: Record<string, string> = {
  engine_oil: "Engine oil",
  engine_oil_2_0: "Engine oil (2.0)",
  engine_oil_1_0t: "Engine oil (1.0T)",
  engine_oil_diesel: "Engine oil (diesel)",
  engine_oil_v6: "Engine oil (V6)",
  engine_oil_hybrid: "Engine oil (hybrid)",
  transmission_at: "Transmission (auto)",
  transmission_cvt: "Transmission (CVT)",
  transmission_mt: "Transmission (manual)",
  transmission_dsg: "Transmission (DSG)",
  transmission_pdk: "Transmission (PDK)",
  gearbox: "Reducer / gearbox",
  transfer_case: "Transfer case",
  front_differential: "Front differential",
  rear_differential: "Rear differential",
  coolant: "Coolant",
  brake: "Brake fluid",
  ps: "Power steering",
  ac_refrigerant: "A/C refrigerant",
  washer: "Washer fluid",
};

export const fluidLabel = (t: string) => fluidLabels[t] ?? humanize(t);

// ───────────────────────── torque_specs.fastener ──────────────────────────

export const torqueLabels: Record<string, string> = {
  lug_nut: "Wheel lug nut",
  spark_plug: "Spark plug",
  oil_drain: "Oil drain plug",
  wheel_hub_nut: "Wheel hub nut",
  caliper_bolt: "Caliper slide bolt",
  caliper_bracket_bolt: "Caliper carrier bolt",
  control_arm_bolt: "Front control arm bolt",
  sway_bar_link: "Sway bar end link",
  cv_axle_nut: "CV axle nut",
  cylinder_head_bolt: "Cylinder head bolt",
  intake_manifold: "Intake manifold bolt",
  exhaust_manifold: "Exhaust manifold bolt",
  flywheel_bolt: "Flywheel bolt",
  transfer_case_drain: "Transfer case drain",
  diff_fill_plug: "Differential fill plug",
  rear_diff_fill_plug: "Rear diff fill plug",
  gearbox_drain: "Gearbox drain",
  gearbox_fill: "Gearbox fill",
  pdk_drain: "PDK drain",
  cvt_drain: "CVT drain",
  service_disconnect: "HV service disconnect",
  "half-shaft_nut": "Half-shaft / hub nut",
};

export const torqueLabel = (f: string) => torqueLabels[f] ?? humanize(f);

// ───────────────────────── service_intervals.service ──────────────────────

export const serviceLabels: Record<string, string> = {
  engine_oil_and_filter: "Engine oil & filter",
  tire_rotation: "Tire rotation",
  brake_inspection: "Brake inspection",
  engine_air_filter: "Engine air filter",
  cabin_air_filter: "Cabin air filter",
  transmission_at_fluid: "Auto transmission fluid",
  transmission_cvt_fluid: "CVT fluid",
  transmission_dsg_fluid: "DSG fluid",
  transmission_pdk_fluid: "PDK fluid",
  transmission_mt_fluid: "Manual gear oil",
  transfer_case_fluid: "Transfer case fluid",
  front_differential_fluid: "Front diff fluid",
  rear_differential_fluid: "Rear diff fluid",
  brake_fluid_flush: "Brake fluid flush",
  spark_plugs: "Spark plugs",
  coolant_flush: "Coolant flush",
  valve_clearance: "Valve clearance inspect & adjust",
  drive_belt_inspection: "Drive belt inspection",
  drive_belt_replacement: "Drive belt replacement",
  timing_belt_replacement: "Timing belt replacement",
  tpms_sensor_battery: "TPMS sensor battery",
  power_steering_fluid: "Power steering fluid",
  reducer_fluid: "Reducer fluid",
  gearbox_fluid: "Gearbox fluid",
  lubricate_caliper: "Caliper lubrication",
  wiper_blades: "Wiper blades",
  ac_desiccant: "A/C desiccant",
  hv_battery_inspection: "HV battery inspection",
  pdk_clutch_inspection: "PDK clutch inspection",
};

export const serviceLabel = (s: string) => serviceLabels[s] ?? humanize(s);

// ───────────────────────── bulbs.position ─────────────────────────────────

export const bulbLabels: Record<string, string> = {
  headlight_low: "Headlight · low beam",
  headlight_high: "Headlight · high beam",
  fog_front: "Fog · front",
  fog_rear: "Fog · rear",
  drl: "Daytime running light",
  brake_tail: "Brake / tail",
  reverse: "Reverse",
  license_plate: "Licence plate",
  interior_dome: "Interior · dome",
  interior_map: "Interior · map lights",
  glove_box: "Glove box",
  trunk: "Trunk",
  frunk: "Frunk",
  cargo: "Cargo",
  cargo_bed: "Cargo bed",
  turn_front: "Turn signal · front",
  turn_rear: "Turn signal · rear",
  side_marker: "Side marker",
};

export const bulbLabel = (p: string) => bulbLabels[p] ?? humanize(p);

// ───────────────────────── fuses.location ─────────────────────────────────

export const fuseLocationLabels: Record<string, string> = {
  under_hood: "Under-hood",
  cabin: "Cabin",
  engine_bay: "Engine bay",
  frunk: "Frunk",
  trunk: "Trunk",
  rear: "Rear",
};

export const fuseLocationLabel = (l: string) =>
  fuseLocationLabels[l] ?? humanize(l);

// ───────────────────────── tire_pressures.position / load ─────────────────

export const tirePositionLabels: Record<string, string> = {
  front: "Front",
  rear: "Rear",
  spare: "Spare",
};
export const tirePositionLabel = (p: string) =>
  tirePositionLabels[p] ?? humanize(p);

export const tireConditionLabels: Record<string, string> = {
  normal: "Normal load",
  loaded: "Loaded",
  max_load: "Maximum load",
  winter: "Winter / cold weather",
};
export const tireConditionLabel = (c: string) =>
  tireConditionLabels[c] ?? humanize(c);

// ───────────────────────── parts.part_type ────────────────────────────────

export const partLabels: Record<string, string> = {
  spark_plug: "Spark plug",
  oil_filter: "Oil filter",
  oil_filter_v6: "Oil filter (V6)",
  air_filter: "Engine air filter",
  cabin_filter: "Cabin air filter",
  wiper_front_d: "Front wiper (driver)",
  wiper_front_p: "Front wiper (passenger)",
  wiper_rear: "Rear wiper",
  brake_pad_front: "Brake pads (front)",
  brake_pad_rear: "Brake pads (rear)",
};
export const partLabel = (t: string) => partLabels[t] ?? humanize(t);
