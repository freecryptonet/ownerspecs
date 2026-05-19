type TabKey =
  | "overview"
  | "specifications"
  | "maintenance"
  | "fluids"
  | "torque"
  | "electrical"
  | "procedures"
  | "compare";

export function GenerationTabs({
  brand,
  generation,
  active,
  counts,
}: {
  brand: string;
  generation: string;
  active: TabKey;
  counts: Partial<Record<TabKey, number>>;
}) {
  const base = `/${brand}/${generation}`;
  const tabs: Array<{ key: TabKey; label: string; href: string }> = [
    { key: "overview", label: "Overview", href: base },
    { key: "specifications", label: "Specifications", href: `${base}#specifications` },
    { key: "maintenance", label: "Maintenance", href: `${base}/maintenance-schedule` },
    { key: "fluids", label: "Fluids", href: `${base}/oil-capacity` },
    { key: "torque", label: "Torque", href: `${base}/torque` },
    { key: "electrical", label: "Electrical", href: `${base}/electrical` },
    { key: "procedures", label: "Procedures", href: `${base}/procedures` },
    { key: "compare", label: "Compare", href: "/compare" },
  ];
  return (
    <div className="tabs">
      <div className="tabs-inner">
        {tabs.map((t) => (
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
