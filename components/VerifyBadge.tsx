export function VerifyBadge({
  sourceCount,
  reviewDate,
  scope = "across",
}: {
  sourceCount: number;
  reviewDate: string;
  scope?: "across" | "in";
}) {
  const verb =
    scope === "in" ? "Verified in" : "Verified across";
  // "Verified across N independent sources" only when N≥2 (the cross-verification
  // claim the site makes). A single-cited source is stated honestly as "cited"
  // rather than over-claiming cross-verification.
  const label =
    sourceCount <= 0
      ? "Catalogue data — owner-manual data in progress"
      : sourceCount === 1
        ? "1 source cited"
        : `${verb} ${sourceCount} independent sources`;
  return (
    <div className="verify-badge">
      <svg
        width="14"
        height="14"
        viewBox="0 0 16 16"
        fill="none"
        stroke="currentColor"
        strokeWidth="1.6"
      >
        <path d="m4 8 3 3 5-6" />
        <circle cx="8" cy="8" r="7" />
      </svg>
      <span>{label}</span>
      <span className="div" />
      <span className="meta">Last reviewed {reviewDate}</span>
    </div>
  );
}
