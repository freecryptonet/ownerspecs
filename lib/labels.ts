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
  ac_compressor_oil: "A/C compressor oil",
  washer: "Washer fluid",
  washer_fluid: "Washer fluid",
  brake_fluid: "Brake fluid",
  transmission_ecvt: "Transmission (eCVT)",
  inverter_coolant: "Inverter / motor coolant",
  reduction_gear: "Reduction gear oil",
  reduction_gear_front: "Reduction gear oil (front)",
  reduction_gear_rear: "Reduction gear oil (rear)",
  coolant_phev: "Coolant (PHEV)",
  coolant_amg: "Coolant (AMG)",
  coolant_drive: "Coolant (drive system)",
  coolant_hv_battery: "Coolant (HV battery)",
  engine_oil_phev: "Engine oil (PHEV)",
  fuel: "Fuel tank",
  fuel_phev: "Fuel tank (PHEV)",
  transmission_dct: "Transmission (dual-clutch)",
  haldex: "Haldex coupling",
  def_fluid: "Diesel exhaust fluid (AdBlue)",
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
  crankshaft_pulley: "Crankshaft pulley bolt",
  oil_filter: "Oil filter housing",
  oxygen_sensor: "Oxygen sensor",
  alternator: "Alternator",
  starter_motor: "Starter motor",
  front_driveshaft_to_hub: "Front driveshaft to hub",
  rear_driveshaft_to_hub: "Rear driveshaft to hub",
  steering_wheel: "Steering wheel",
  ac_compressor: "A/C compressor",
  dct_drain_plug: "Dual-clutch transmission drain plug",
  rear_diff_drain: "Rear differential drain plug",
  haldex_drain: "Haldex coupling drain plug",
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
  fuel_filter: "Fuel filter",
  running_in_service: "Running-in service",
  oxygen_sensor: "Oxygen sensor",
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
  transmission_dct_fluid: "Dual-clutch fluid",
  haldex_fluid: "Haldex coupling fluid",
  accessory_drive_belt: "Accessory drive belt",
  dpf_check: "Diesel particulate filter check",
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
  // raw scraped variants → readable
  "Underhood PDC": "Under-hood power distribution",
  "Front PDC": "Front power distribution",
  "Rear PDC": "Rear power distribution",
  "BCM PDC": "Body-control-module power distribution",
  PDC: "Power distribution centre",
  TIPM: "Integrated power module (TIPM)",
};

export const fuseLocationLabel = (l: string) =>
  fuseLocationLabels[l] ?? humanize(l);

// Physical "where is this box" hint, keyed by location. Generic but accurate —
// answers the owner's real question without copying any layout diagram.
const fuseLocationWhereByKey: Record<string, string> = {
  engine_bay: "Under the hood — usually near the battery or on the inner wing.",
  under_hood: "Under the hood — usually near the battery or on the inner wing.",
  "Underhood PDC":
    "Under the hood — main power-distribution box, typically beside the battery.",
  PDC: "Under the hood — main power-distribution box, typically beside the battery.",
  "Front PDC": "Under the hood — front power-distribution box.",
  TIPM: "Under the hood near the battery — the combined fuse and relay module.",
  cabin:
    "Inside the car — commonly behind the glovebox, in the lower dash, or on the end of the dashboard (visible with the door open).",
  "BCM PDC":
    "Inside the car — at the body-control module, usually behind the lower dash or kick panel.",
  trunk: "In the boot / cargo area — commonly behind a side trim panel.",
  "Rear PDC": "In the boot / cargo area — rear power-distribution box.",
  rear: "In the boot / cargo area — commonly behind a side trim panel.",
  frunk: "In the front storage compartment (frunk).",
};

export const fuseLocationWhere = (l: string): string | null =>
  fuseLocationWhereByKey[l] ?? null;

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

// ───────────────────── brake_specs / alignment_specs ──────────────────────

export const axleLabels: Record<string, string> = {
  front: "Front",
  rear: "Rear",
};
export const axleLabel = (a: string) => axleLabels[a] ?? humanize(a);

export const brakeTypeLabels: Record<string, string> = {
  disc_vented: "Ventilated disc",
  disc_solid: "Solid disc",
  disc: "Disc",
  drum: "Drum",
};
export const brakeTypeLabel = (t: string) => brakeTypeLabels[t] ?? humanize(t);

// ───────────────────────── mass_homologations.mass_kind ────────────────────
// Vocabulary + presentation policy from reference_rdw_field_semantics.md
// (weight-presentation policy, panel-unanimous 2026-09-23). `category`
// controls where a value CAN render: 'headline' = the answer-card number;
// 'supporting' = the per-kind table row; 'tax_only' = NEVER the weight
// block or any towing/payload calculator — a separate "NL registration /
// road-tax" box only. Unknown kinds default to 'supporting', never
// 'headline' or silently 'tax_only', so an unseen kind degrades safely
// instead of either overclaiming or vanishing.

export const massKindLabels: Record<string, string> = {
  running_order: "Mass in running order (EU type-approval)",
  max_laden_permissible: "Permissible maximum laden mass",
  max_laden_technical: "Technically permissible maximum laden mass",
  max_combination: "Maximum mass of combination (vehicle + trailer)",
  tow_braked: "Towing capacity — braked trailer",
  tow_unbraked: "Towing capacity — unbraked trailer",
  max_axle: "Maximum axle load",
  // Defensive — not present in current data, see plan Ground Truth. If RDW-derived
  // "leeggewicht"-equivalent facts are ever ingested into this table, they land here.
  actual_mass: "Leeggewicht — RDW-derived (NL admin convention; not a manufacturer kerb)",
};

export const massKindLabel = (k: string) => massKindLabels[k] ?? humanize(k);

const MASS_KIND_HEADLINE = new Set(["running_order"]);
const MASS_KIND_TAX_ONLY = new Set(["actual_mass"]);

export function massKindCategory(k: string): "headline" | "supporting" | "tax_only" {
  if (MASS_KIND_TAX_ONLY.has(k)) return "tax_only";
  if (MASS_KIND_HEADLINE.has(k)) return "headline";
  return "supporting";
}
