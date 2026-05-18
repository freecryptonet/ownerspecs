import type { SourceRow } from "@/lib/generation";

export function SourcesBlock({ sources }: { sources: SourceRow[] }) {
  if (sources.length === 0) return null;
  return (
    <section className="sources-block">
      <h3>Sources</h3>
      <ol className="sources-list">
        {sources.map((s) => (
          <li key={s.id}>
            <span>
              <span className="who">
                {s.url ? (
                  <a href={s.url} rel="noopener" target="_blank">
                    {s.citation}
                  </a>
                ) : (
                  s.citation
                )}
              </span>
              {s.notes && <span className="what">{s.notes}</span>}
            </span>
            <span className="when">
              Retrieved {new Date(s.retrieved_at).toISOString().slice(0, 10)}
            </span>
          </li>
        ))}
      </ol>
    </section>
  );
}
