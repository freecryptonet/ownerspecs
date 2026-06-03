// Visual fuse-box diagram: renders each fuse as a chip colour-coded by the
// standard ISO/DIN blade-fuse amperage colour code (the same colour key
// workshop databases print). We don't have the physical x/y slot coordinates,
// so this is an ordered, colour-coded grid — far more scannable than a plain
// table, and it surfaces the amperage at a glance. The detailed table still
// renders below for full circuit text + SEO.

type FuseChip = {
  id: number;
  position: string;
  amperage: string | null;
  circuit_name: string | null;
};

// ISO 8820 mini/standard blade-fuse colour code (amp -> {bg, ink}).
const AMP_COLOURS: Record<string, { bg: string; ink: string }> = {
  "1": { bg: "#2b2b2b", ink: "#fff" },
  "2": { bg: "#9aa0a6", ink: "#111" },
  "3": { bg: "#8e6fc4", ink: "#fff" },
  "4": { bg: "#e89ab8", ink: "#111" },
  "5": { bg: "#d9c08a", ink: "#111" },
  "7.5": { bg: "#7a5a2e", ink: "#fff" },
  "10": { bg: "#d23b3b", ink: "#fff" },
  "15": { bg: "#3f7fd0", ink: "#fff" },
  "20": { bg: "#f1d23e", ink: "#111" },
  "25": { bg: "#f4f4f4", ink: "#111" },
  "30": { bg: "#3ba14e", ink: "#fff" },
  "35": { bg: "#2f9aa3", ink: "#fff" },
  "40": { bg: "#e2902f", ink: "#111" },
  "50": { bg: "#d23b3b", ink: "#fff" },
  "60": { bg: "#3f7fd0", ink: "#fff" },
  "70": { bg: "#7a5a2e", ink: "#fff" },
  "80": { bg: "#f4f4f4", ink: "#111" },
  "100": { bg: "#8e6fc4", ink: "#fff" },
  "125": { bg: "#a8702f", ink: "#fff" },
  "150": { bg: "#9aa0a6", ink: "#111" },
  "200": { bg: "#6b6f73", ink: "#fff" },
  "400": { bg: "#444", ink: "#fff" },
};

function chipColour(amp: string | null): { bg: string; ink: string } {
  if (amp == null || String(amp).trim() === "") return { bg: "#eceff1", ink: "#90a4ae" }; // relay / unrated
  const key = String(Number(amp)); // normalise "7.50" -> "7.5", "30" -> "30"
  return AMP_COLOURS[key] ?? AMP_COLOURS[String(amp)] ?? { bg: "#cfd8dc", ink: "#111" };
}

export function FuseBoxDiagram({ fuses }: { fuses: FuseChip[] }) {
  const amps = [...new Set(fuses.map((f) => f.amperage).filter((a): a is string => a != null && String(a).trim() !== ""))]
    .sort((a, b) => Number(a) - Number(b));

  return (
    <div className="fusebox-diagram" style={{ margin: "0 0 14px" }}>
      <div
        style={{
          display: "grid",
          gridTemplateColumns: "repeat(auto-fill, minmax(58px, 1fr))",
          gap: 6,
          border: "1px solid var(--rule)",
          background: "var(--bg-alt)",
          padding: 10,
        }}
      >
        {fuses.map((f) => {
          const c = chipColour(f.amperage);
          const isRelay = f.amperage == null || String(f.amperage).trim() === "";
          return (
            <div
              key={f.id}
              title={f.circuit_name ?? undefined}
              style={{
                background: c.bg,
                color: c.ink,
                border: "1px solid rgba(0,0,0,0.18)",
                borderRadius: 3,
                padding: "5px 4px",
                textAlign: "center",
                fontFamily: "var(--font-mono)",
                lineHeight: 1.2,
                minHeight: 38,
                display: "flex",
                flexDirection: "column",
                justifyContent: "center",
              }}
            >
              <span style={{ fontSize: 11, fontWeight: 700 }}>{f.position}</span>
              <span style={{ fontSize: 10, opacity: 0.9 }}>{isRelay ? "relay" : `${f.amperage}A`}</span>
            </div>
          );
        })}
      </div>
      {amps.length > 0 && (
        <div style={{ display: "flex", flexWrap: "wrap", gap: 10, marginTop: 8, fontSize: 11, color: "var(--ink-soft)", fontFamily: "var(--font-mono)" }}>
          {amps.map((a) => {
            const c = chipColour(a);
            return (
              <span key={a} style={{ display: "inline-flex", alignItems: "center", gap: 4 }}>
                <span style={{ width: 12, height: 12, background: c.bg, border: "1px solid rgba(0,0,0,0.2)", borderRadius: 2, display: "inline-block" }} />
                {a}A
              </span>
            );
          })}
        </div>
      )}
    </div>
  );
}
