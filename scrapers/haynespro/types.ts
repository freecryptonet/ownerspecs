/**
 * HaynesPro per-vehicle harvest types.
 *
 * One `HaynesProVehicleHarvest` represents the union of EVERY useful field
 * HaynesPro publishes for a single typeId (= engine variant on a chassis).
 * The harvester (`harvest_all.md` workflow) walks the three primary pages —
 * Lubricants, Adjustment Data, and Maintenance category — and writes one
 * JSON file per typeId combining all three.
 *
 * Catalog targets per HaynesPro source:
 *   Lubricants page      → fluid_specs (engine_oil, coolant, brake, ATF,
 *                                       DCT, transfer_case, differential,
 *                                       ac_refrigerant)
 *                         + torque_specs (drain plugs)
 *   Adjustment Data page → engine specs (cc, valves, compression),
 *                          electrical_specs (battery Ah/CCA per equip code),
 *                          brake discs (front/rear diameter + thickness),
 *                          suspension (ride height, alignment),
 *                          tire_pressures (when published),
 *                          torque_specs (engine, brake, suspension, wheel),
 *                          A/C refrigerant grams.
 *   Maintenance category → procedures (storyId-based) inventory.
 *                          The full body_md of each procedure is left out
 *                          here — capture separately via parseStory.md.
 *
 * Source: Tim's authenticated workshopdata.com session.
 * Capture method: Playwright + in-page extraction via browser_evaluate.
 */

// ============================================================================
// Top-level shape
// ============================================================================

export type HaynesProVehicleHarvest = {
  /** Audi/BMW/etc engine code, e.g. "DMTA", "B48B20B". */
  engine_code: string | null;
  /** HaynesPro typeId, e.g. "t_619035648". */
  typeId: string;
  /** HaynesPro chassis modelId for breadcrumb, e.g. "d_319001693". */
  modelId: string | null;
  /** Vehicle label as HaynesPro displays it. */
  vehicle_label: string;
  /** Years range as HaynesPro displays. */
  years: string | null;
  /** ISO timestamp of capture. */
  fetched_at: string;
  /** Sources of each section (URLs). */
  source_urls: {
    lubricants: string | null;
    adjustment_data: string | null;
    maintenance: string | null;
  };
  lubricants: LubricantsBlock | null;
  adjustment_data: AdjustmentDataBlock | null;
  procedures: MaintenanceProcedure[] | null;
};

// ============================================================================
// Lubricants page
// ============================================================================

export type LubricantsBlock = {
  engine_oil: OilEntry | null;
  coolant: CoolantEntry | null;
  brake_fluid: BrakeFluidEntry | null;
  transmission_at: TransmissionEntry | null;
  transmission_dct: TransmissionEntry | null;
  transmission_mt: TransmissionEntry | null;
  transfer_case: GenericFluidEntry | null;
  front_differential: GenericFluidEntry | null;
  rear_differential: GenericFluidEntry | null;
  haldex: GenericFluidEntry | null;
  ac_refrigerant: ACRefrigerantEntry | null;
};

export type OilEntry = {
  /** Preferred lubricant per HaynesPro. */
  preferred: { viscosity: string | null; spec: string | null } | null;
  /** Listed alternatives in HaynesPro order. */
  alternatives: Array<{ viscosity: string | null; spec: string | null }>;
  /** Engine sump capacity including filter, in litres. */
  sump_l: number | null;
  /** Drain plug torque in Newton-metres. */
  drain_nm: number | null;
  /** "Renew the seal" / "Threads lightly oiled" qualifier if present. */
  drain_note: string | null;
};

export type CoolantEntry = {
  /** OEM-specified coolant additive spec (e.g. "TL-VW 774L (G12EVO)", "BMW LC-18"). */
  spec: string | null;
  /** Total cooling-system capacity in litres. */
  capacity_l: number | null;
  /** Frost protection ranges if listed. */
  frost_protection: Array<{ antifreeze_pct: string; min_temp_c: number | null }>;
};

export type BrakeFluidEntry = {
  preferred_spec: string | null;
  alternative_spec: string | null;
  capacity_at_l: number | null;
  capacity_dct_l: number | null;
  capacity_mt_l: number | null;
};

export type TransmissionEntry = {
  /** Workshop code, e.g. "0CK", "0D5", "ZF 8HP / 0HL". */
  code: string | null;
  /** Number of forward gears. */
  speeds: number | null;
  /** Fluid spec (e.g. "VW G 060 162 A2", "Honda HCF-2"). */
  fluid_spec: string | null;
  fluid_viscosity: string | null;
  initial_fill_l: number | null;
  drain_refill_l: number | null;
  drain_refill_l_max: number | null;
  filler_plug_torque_nm: number | null;
  drain_plug_torque_nm: number | null;
  level_check_temp_c: number | null;
  notes: string | null;
};

export type GenericFluidEntry = {
  spec: string | null;
  viscosity: string | null;
  capacity_l: number | null;
  refill_l: number | null;
  filler_plug_torque_nm: number | null;
  drain_plug_torque_nm: number | null;
};

export type ACRefrigerantEntry = {
  type: string | null;       // "R1234yf" / "R134a"
  grams: number | null;
  tolerance_g: number | null;
  compressor_oil_spec: string | null;
  compressor_oil_ml: number | null;
};

// ============================================================================
// Adjustment Data page
// ============================================================================

export type AdjustmentDataBlock = {
  engine: EngineSpecs | null;
  cooling: CoolingSpecs | null;
  electrical: ElectricalSpecs | null;
  brakes: BrakeSpecs | null;
  suspension: SuspensionSpecs | null;
  wheels_tyres: WheelsTyresSpecs | null;
  torque_settings: TorqueSettings | null;
};

export type EngineSpecs = {
  code: string | null;
  capacity_cc: number | null;
  distribution_type: string | null;  // "Timing chain" / "Timing belt"
  cylinders: number | null;
  valves_per_cyl: number | null;
  valve_clearance: string | null;
  spark_plugs: number | null;
  compression_normal_bar: string | null;   // e.g. "12.0 - 17.0"
  compression_min_bar: number | null;
  compression_diff_max_bar: number | null;
  oil_pressure_idle_bar: string | null;     // e.g. "> 0.9"
  oil_pressure_run_bar_rpm: string | null;  // e.g. "> 1.3/2000"
  max_cylhead_distortion_mm: number | null;
};

export type CoolingSpecs = {
  cap_pressure_blue_bar: string | null;     // e.g. "1.4 - 1.6"
  cap_pressure_black_bar: string | null;
  cap_pressure_other_bar: string | null;
};

export type ElectricalSpecs = {
  /** Multiple battery options per equipment code. */
  batteries: Array<{
    equipment_code: string;
    capacity_ah: number | null;
    cca_din_a: number | null;
    chemistry: string | null;  // "AGM" / "EFB" / null
    jump_start_terminal_location: string | null;
    high_voltage_battery_location: string | null;
  }>;
  /** Camera-calibration adjustment specs if present (ADAS). */
  cameras?: Array<{
    code: string;
    target: string | null;
    height_mm: number | null;
    distance_mm: number | null;
  }>;
};

export type BrakeSpecs = {
  front: Array<BrakeDiscSpec>;
  rear: Array<BrakeDiscSpec>;
};

export type BrakeDiscSpec = {
  /** Equipment code(s), e.g. "1LN, 1LP" or "1ZA". */
  equipment_code: string;
  disc_diameter_mm: number | null;
  disc_thickness_mm: number | null;
  disc_thickness_min_mm: number | null;
  pad_thickness_min_mm: number | null;
  disc_runout_max_mm: number | null;
};

export type SuspensionSpecs = {
  suspensions: Array<{
    equipment_code: string;
    type: string;  // "Standard suspension" / "Sport suspension" / "Air suspension" / etc.
    ride_height_front_mm: number | null;
    ride_height_rear_mm: number | null;
    toe_front: string | null;
    toe_rear: string | null;
    camber_front: string | null;
    camber_rear: string | null;
    steering_angle_inner: string | null;
    steering_angle_outer: string | null;
    thrust_angle_max: string | null;
  }>;
};

export type WheelsTyresSpecs = {
  rim_size: string | null;
  speed_index_min: string | null;
  offset_et_mm: number | null;
  pressures: Array<{
    tire_size: string;
    front_load_psi: number | null;
    front_full_psi: number | null;
    rear_load_psi: number | null;
    rear_full_psi: number | null;
    spare_psi: number | null;
  }>;
};

export type TorqueSettings = {
  engine: Array<TorqueRow>;
  brakes_front: Array<TorqueRow>;
  brakes_rear: Array<TorqueRow>;
  transmission: Array<TorqueRow>;
  suspension: Array<TorqueRow>;
  wheels: TorqueRow | null;
  steering: Array<TorqueRow>;
  ac: Array<TorqueRow>;
};

export type TorqueRow = {
  fastener: string;            // "Engine oil drain plug" / "Wheel bolts" / "Spark plug (M12)"
  torque_nm: number | null;
  torque_nm_max: number | null;  // upper bound if range
  stage: string | null;          // "Stage 1" / "Stage 2 90°" / null
  notes: string | null;          // "Renew the seal" / "Threads lightly oiled"
};

// ============================================================================
// Maintenance category — procedure inventory
// ============================================================================

export type MaintenanceProcedure = {
  /** HaynesPro story ID, e.g. "319007174" — needed for citation. */
  story_id: string;
  /** English title as HaynesPro lists, e.g. "Dual-clutch transmission: gearbox fluid level check…". */
  title: string;
  /** Category/group, e.g. "MAINTENANCE", "SERVICERESET". */
  group: string | null;
  /** Full URL for direct deep-link. */
  url: string;
};
