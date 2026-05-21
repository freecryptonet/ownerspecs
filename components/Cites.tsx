/**
 * Inline citation footnote: renders [1][2] superscripts that link to
 * positions in the page's <ol class="sources-list">. Sources block
 * items must carry `id={`src-${n}`}` so the anchor resolves.
 *
 * Empty when no citations — never renders a stray [] for unsourced rows.
 */
export function Cites({ nums }: { nums: number[] }) {
  if (!nums || nums.length === 0) return null;
  return (
    <sup className="cite">
      {nums.map((n, i) => (
        <span key={n}>
          [<a href={`#src-${n}`} style={{ color: "inherit", textDecoration: "none" }}>{n}</a>]
          {i < nums.length - 1 ? "" : ""}
        </span>
      ))}
    </sup>
  );
}
