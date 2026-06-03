type TabKey =
  | "overview"
  | "specifications"
  | "maintenance"
  | "fluids"
  | "torque"
  | "brakes"
  | "electrical"
  | "procedures"
  | "compare";

export function GenerationTabs({
  brand,
  generation,
  active,
  counts = {},
}: {
  brand: string;
  generation: string;
  active: TabKey;
  counts?: Partial<Record<TabKey, number>>;
}) {
  const base = `/${brand}/${generation}`;
  const tabs: Array<{ key: TabKey; label: string; href: string }> = [
    { key: "overview", label: "Overview", href: base },
    { key: "specifications", label: "Specifications", href: `${base}#specifications` },
    { key: "maintenance", label: "Maintenance", href: `${base}/maintenance-schedule` },
    { key: "fluids", label: "Fluids", href: `${base}/oil-capacity` },
    { key: "torque", label: "Torque", href: `${base}/torque` },
    { key: "brakes", label: "Brakes", href: `${base}/brakes` },
    { key: "electrical", label: "Electrical", href: `${base}/electrical` },
    { key: "procedures", label: "Procedures", href: `${base}/procedures` },
    { key: "compare", label: "Compare", href: "/compare" },
  ];
  // The Brakes page only exists for gens that actually have brake/alignment
  // data (most don't yet). Render its tab only when it's active or the caller
  // signals data via counts.brakes — otherwise it would be a dead 404 link.
  const visibleTabs = tabs.filter(
    (t) => t.key !== "brakes" || active === "brakes" || (counts.brakes ?? 0) > 0,
  );
  return (
    <div className="tabs">
      <div className="tabs-inner">
        {visibleTabs.map((t) => (
          <a
            key={t.key}
            className={`tab${active === t.key ? " active" : ""}`}
            href={t.href}
          >
            {t.label}
            {typeof counts[t.key] === "number" && (
              <span className="count">{counts[t.key]}</span>
            )}
          </a>
        ))}
      </div>
    </div>
  );
}

export type { TabKey };
