/** Dual-unit display helpers. Each `xxxDual` returns a formatted string
 *  with the primary metric unit plus the equivalent in the secondary
 *  imperial (US) and / or UK unit. Optimised to capture search-volume
 *  in both unit systems from a single page. */

export function mmDual(mm: number | null | undefined): string {
  if (mm == null) return "—";
  const inches = mm / 25.4;
  return `${mm} mm · ${inches.toFixed(1)} in`;
}

export function kgDual(kg: number | null | undefined): string {
  if (kg == null) return "—";
  const lbs = kg * 2.20462;
  return `${kg} kg · ${Math.round(lbs)} lb`;
}

export function kgRangeDual(min: number, max: number): string {
  const minLb = Math.round(min * 2.20462);
  const maxLb = Math.round(max * 2.20462);
  return min === max
    ? `${min} kg · ${minLb} lb`
    : `${min}–${max} kg · ${minLb}–${maxLb} lb`;
}

export function litreDual(l: number | string | null | undefined): string {
  if (l == null) return "—";
  const ln = typeof l === "string" ? parseFloat(l) : l;
  if (!isFinite(ln)) return "—";
  const usGal = ln * 0.264172;
  const ukGal = ln * 0.219969;
  return `${ln.toFixed(0)} L · ${usGal.toFixed(1)} gal (US) · ${ukGal.toFixed(1)} gal (UK)`;
}

export function litreCargoDual(l: number | null | undefined): string {
  if (l == null) return "—";
  const cuft = l * 0.0353147;
  return `${l} L · ${cuft.toFixed(1)} cu·ft`;
}

/** Convert L/100km to US mpg and UK (imperial) mpg in one cell. */
export function consumptionDual(
  l100km: number | string | null | undefined,
): string {
  if (l100km == null) return "—";
  const v = typeof l100km === "string" ? parseFloat(l100km) : l100km;
  if (!isFinite(v) || v <= 0) return "—";
  const usMpg = 235.215 / v;
  const ukMpg = 282.481 / v;
  return `${v.toFixed(1)} L/100km · ${usMpg.toFixed(1)} mpg (US) · ${ukMpg.toFixed(1)} mpg (UK)`;
}

/** Top speed: km/h → mph. */
export function speedDual(kmh: number | null | undefined): string {
  if (kmh == null) return "—";
  const mph = kmh * 0.621371;
  return `${kmh} km/h · ${Math.round(mph)} mph`;
}

/** Engine bore / stroke: mm + inches (Imperial). Decimal precision matters
 *  for engine specs. */
export function boreStrokeDual(
  bore: string | number | null | undefined,
  stroke: string | number | null | undefined,
): string {
  if (bore == null || stroke == null) return "—";
  const b = typeof bore === "string" ? parseFloat(bore) : bore;
  const s = typeof stroke === "string" ? parseFloat(stroke) : stroke;
  const bIn = (b / 25.4).toFixed(2);
  const sIn = (s / 25.4).toFixed(2);
  return `${b} × ${s} mm · ${bIn} × ${sIn} in`;
}

/** Engine displacement: cm³ → cu·in. Common search volume for US muscle / V8 / classic enthusiasts. */
export function displacementDual(cc: number | null | undefined): string {
  if (cc == null) return "—";
  const cuIn = cc * 0.0610237;
  const litres = cc / 1000;
  return `${cc} cm³ · ${litres.toFixed(1)} L · ${cuIn.toFixed(1)} cu·in`;
}
