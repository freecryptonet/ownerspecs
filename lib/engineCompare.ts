// Curated engine-vs-engine comparison pairs. Each entry is two engines.slug values
// that already exist in the DB. generateStaticParams renders one /compare/engines/[pair]
// page per entry; the engine page links back only to pairs listed here (so no 404s).
// Keep pairs to engines that share a model/family — that's where the comparison is meaningful.
export const ENGINE_PAIRS: Array<[string, string]> = [
  // Suzuki Swift (ZC/ZD) M-family — same 78 mm bore, growing stroke
  ["m13a", "m15a"],
  ["m15a", "m16a"],
  ["m13a", "m16a"],
  // Chrysler/Dodge HEMI V8 family
  ["ezb", "ezh"], // 5.7 HEMI: MDS (2003-08) vs Eagle/VVT (2009+)
  ["esf", "esg"], // 6.1 SRT8 vs 6.4 392 HEMI
  ["ezh", "esg"], // 5.7 vs 6.4 HEMI — "which HEMI"
  // BMW modular turbo — 4-cyl vs 6-cyl (e.g. 330i vs M340i)
  ["b48b20", "b58b30o1"],
];

export function enginePairSlug(a: string, b: string): string {
  return `${a}-vs-${b}`;
}

export function splitEnginePair(slug: string): [string, string] | null {
  const idx = slug.indexOf("-vs-");
  if (idx === -1) return null;
  return [slug.slice(0, idx), slug.slice(idx + 4)];
}

// For an engine slug, return the sibling slugs it has a curated comparison with,
// each paired with the canonical pair-slug (orientation as listed in ENGINE_PAIRS).
export function compareSiblings(slug: string): Array<{ sibling: string; pair: string }> {
  const out: Array<{ sibling: string; pair: string }> = [];
  for (const [a, b] of ENGINE_PAIRS) {
    if (a === slug) out.push({ sibling: b, pair: enginePairSlug(a, b) });
    else if (b === slug) out.push({ sibling: a, pair: enginePairSlug(a, b) });
  }
  return out;
}
