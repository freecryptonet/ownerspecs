import { Cites } from "@/components/Cites";

/**
 * Per-datapoint provenance pill. Distinct from VerifyBadge (page-level
 * source-count summary) — this labels ONE rendered value as either a
 * document-verified fact (qa_state='approved', cited via buildCitationIndex)
 * or legacy/uncited catalogue data, per the dual-moat render layer's
 * "verified-wins-per-field with labelled legacy fallback" rule
 * (docs/superpowers/plans/2026-09-24-render-layer-dual-moat.md).
 */
export function ProvenanceBadge({
  kind,
  citationNums,
}: {
  kind: "verified" | "legacy";
  citationNums?: number[];
}) {
  return (
    <span className={`provenance-pill provenance-${kind}`}>
      {kind === "verified" ? "Verified" : "Legacy — unverified"}
      {kind === "verified" && citationNums && citationNums.length > 0 && (
        <Cites nums={citationNums} />
      )}
    </span>
  );
}
