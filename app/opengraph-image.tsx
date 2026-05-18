import { ImageResponse } from "next/og";

export const alt =
  "ownerspecs — Vehicle specification and owner-manual reference";
export const size = { width: 1200, height: 630 };
export const contentType = "image/png";

export default async function Image() {
  return new ImageResponse(
    (
      <div
        style={{
          width: "100%",
          height: "100%",
          display: "flex",
          flexDirection: "row",
          background: "#FFFFFF",
          fontFamily: "Inter",
        }}
      >
        {/* Accent stripe */}
        <div
          style={{
            width: 16,
            height: "100%",
            background: "#2563EB",
            display: "flex",
          }}
        />

        {/* Content */}
        <div
          style={{
            flex: 1,
            display: "flex",
            flexDirection: "column",
            padding: "72px 88px",
            justifyContent: "space-between",
          }}
        >
          {/* Top: wordmark + small badge */}
          <div
            style={{
              display: "flex",
              alignItems: "center",
              justifyContent: "space-between",
            }}
          >
            <div
              style={{
                display: "flex",
                alignItems: "center",
                gap: 16,
              }}
            >
              <div
                style={{
                  width: 28,
                  height: 28,
                  background: "#2563EB",
                  display: "flex",
                }}
              />
              <div
                style={{
                  fontSize: 36,
                  fontWeight: 700,
                  letterSpacing: -0.5,
                  color: "#0E1116",
                  display: "flex",
                }}
              >
                ownerspecs
              </div>
            </div>
            <div
              style={{
                fontSize: 16,
                fontWeight: 600,
                color: "#2563EB",
                background: "#EFF6FF",
                border: "1px solid #2563EB",
                padding: "8px 16px",
                letterSpacing: 1,
                textTransform: "uppercase",
                display: "flex",
              }}
            >
              Cross-verified · cited · free
            </div>
          </div>

          {/* Middle: tagline */}
          <div
            style={{
              display: "flex",
              flexDirection: "column",
              gap: 24,
            }}
          >
            <div
              style={{
                fontSize: 72,
                fontWeight: 700,
                lineHeight: 1.05,
                letterSpacing: -2,
                color: "#0E1116",
                maxWidth: 940,
                display: "flex",
              }}
            >
              Vehicle specification and owner-manual reference.
            </div>
            <div
              style={{
                fontSize: 26,
                fontWeight: 400,
                lineHeight: 1.4,
                color: "#4A5567",
                maxWidth: 880,
                display: "flex",
              }}
            >
              Every car, every generation, every market — engine specs, fluid
              capacities, torque values, maintenance schedules, fuse layouts.
            </div>
          </div>

          {/* Bottom: data category strip */}
          <div
            style={{
              display: "flex",
              flexDirection: "row",
              gap: 24,
              fontSize: 18,
              fontWeight: 500,
              color: "#0E1116",
            }}
          >
            <span style={{ display: "flex" }}>Fluids</span>
            <span style={{ color: "#C5CAD2", display: "flex" }}>·</span>
            <span style={{ display: "flex" }}>Maintenance</span>
            <span style={{ color: "#C5CAD2", display: "flex" }}>·</span>
            <span style={{ display: "flex" }}>Torque</span>
            <span style={{ color: "#C5CAD2", display: "flex" }}>·</span>
            <span style={{ display: "flex" }}>Battery</span>
            <span style={{ color: "#C5CAD2", display: "flex" }}>·</span>
            <span style={{ display: "flex" }}>Bulbs</span>
            <span style={{ color: "#C5CAD2", display: "flex" }}>·</span>
            <span style={{ display: "flex" }}>Fuses</span>
            <span style={{ color: "#C5CAD2", display: "flex" }}>·</span>
            <span style={{ display: "flex" }}>Procedures</span>
            <span style={{ color: "#C5CAD2", display: "flex" }}>·</span>
            <span style={{ display: "flex" }}>Towing</span>
          </div>
        </div>
      </div>
    ),
    { ...size },
  );
}
