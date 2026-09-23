/**
 * EU Whole-Vehicle Type-Approval line parser.
 *
 * Every EU-approved vehicle carries a type-approval line of the form
 * `e<country>*<directive>*<sequence>[*<extension>]` on its CoC (§ approval)
 * and its statutory plate. The country code after `e` identifies the member
 * state that ISSUED the approval (not where the car was built or sold); the
 * directive identifies the EU framework era.
 *
 * This is the identity backbone for ownerspecs' document-first model: a CoC,
 * an RDW open-data record, and the curated `generatie-curatie.tsv` mapping all
 * key on this line. The natural TVV key is (generation, type, variant, version)
 * — the approval number is an ATTRIBUTE split into base + extension (extensions
 * change across facelifts while the TVV is stable), so we return them separately.
 *
 * Ported 2026-09-23 from the retired outrank-vindecoderz plate-decoder
 * (vindecoder.site orphaned worktree). Universal — format is EU-mandated.
 */

export interface EuTypeApproval {
  approvalAuthority: string; // "e1", "e11" — the `e<country>` token
  approvalCountry: string; // resolved member state
  directive: string; // "2007/46", "2018/858"
  directiveEra: string; // human era label
  sequence: string; // per-authority running number
  extension: string | null; // trailing "*NN" revision, if present
  base: string; // "e1*2007/46*0607" — authority*directive*sequence (the TVV attribute key)
  raw: string; // input, trimmed
}

// UNECE R.0 type-approval authority numbers → issuing member state.
// Sources: UNECE TRANS/WP.29/343, EU Framework Directive 2007/46/EC Annex VII.
const APPROVAL_COUNTRIES: Record<string, string> = {
  e1: "Germany",
  e2: "France",
  e3: "Italy",
  e4: "Netherlands",
  e5: "Sweden",
  e6: "Belgium",
  e7: "Hungary",
  e8: "Czech Republic",
  e9: "Spain",
  e11: "United Kingdom",
  e12: "Austria",
  e13: "Luxembourg",
  e17: "Finland",
  e18: "Denmark",
  e19: "Romania",
  e20: "Poland",
  e21: "Portugal",
  e23: "Greece",
  e24: "Ireland",
  e25: "Croatia",
  e26: "Slovenia",
  e27: "Slovakia",
  e28: "Belarus",
  e29: "Estonia",
  e32: "Latvia",
  e34: "Bulgaria",
  e36: "Lithuania",
  e49: "Cyprus",
  e50: "Malta",
};

// EU framework-directive eras. The directive number dates the approval:
// 70/156 (original) → 98/14 → 2001/116 → 2007/46 → 2018/858 (Sept 2020+).
const DIRECTIVE_ERAS: Array<{ pattern: RegExp; label: string }> = [
  { pattern: /^70\/156$/, label: "Pre-1998 (original EU framework directive)" },
  { pattern: /^98\/14$/, label: "1998–2001 (EU Framework Directive 98/14/EC)" },
  { pattern: /^2001\/116$/, label: "2001–2007 (EU Framework Directive 2001/116/EC)" },
  { pattern: /^2007\/46$/, label: "2007–2020 (EU Framework Directive 2007/46/EC)" },
  { pattern: /^2018\/858$/, label: "2020–present (EU Framework Regulation 2018/858)" },
];

/**
 * Parse an EU type-approval line like `e11*2007/46*0753*02` into its parts.
 * Returns null if the string doesn't match the expected format.
 *
 * `base` is `authority*directive*sequence` (no extension) — the stable key we
 * store in `vehicle_types.approval_base` and match against curated mappings.
 */
export function parseEuTypeApproval(raw: string): EuTypeApproval | null {
  if (!raw) return null;
  const trimmed = raw.trim();

  // The `*` separator is ECE-standard; on real plates it's sometimes a unicode
  // star or an informal `x`. Normalize before parsing.
  const normalized = trimmed
    .replace(/[★☆✱✳✴]/g, "*")
    .replace(/\s+/g, "")
    .replace(/x/gi, "*")
    .toLowerCase();

  const parts = normalized.split("*");
  if (parts.length < 3) return null;
  if (!/^e\d+$/.test(parts[0])) return null;

  const approvalAuthority = parts[0];
  const approvalCountry =
    APPROVAL_COUNTRIES[approvalAuthority] || "Unknown EU member state";

  const directive = parts[1];
  const directiveEra =
    DIRECTIVE_ERAS.find((e) => e.pattern.test(directive))?.label ||
    `Directive ${directive} (era unknown — please report)`;

  const sequence = parts[2];
  const extension = parts[3] || null;
  const base = `${approvalAuthority}*${directive}*${sequence}`;

  return {
    approvalAuthority,
    approvalCountry,
    directive,
    directiveEra,
    sequence,
    extension,
    base,
    raw: trimmed,
  };
}
