import type { Metadata } from "next";
import { Inter, IBM_Plex_Mono } from "next/font/google";
import "./globals.css";

const inter = Inter({
  subsets: ["latin"],
  weight: ["400", "500", "600", "700"],
  variable: "--font-sans",
  display: "swap",
});

const plexMono = IBM_Plex_Mono({
  subsets: ["latin"],
  weight: ["400", "500", "600"],
  variable: "--font-mono",
  display: "swap",
});

export const metadata: Metadata = {
  metadataBase: new URL("https://ownerspecs.com"),
  title: {
    default: "ownerspecs — Vehicle specification and owner-manual reference",
    template: "%s · ownerspecs",
  },
  description:
    "Cross-verified vehicle specifications, fluid capacities, torque values, maintenance schedules, fuse maps and electrical data for every car, every generation, every market.",
  applicationName: "ownerspecs",
  openGraph: {
    type: "website",
    siteName: "ownerspecs",
    title: "ownerspecs — Vehicle specification and owner-manual reference",
    description:
      "Cross-verified vehicle specifications and owner-manual data for every car, every generation, every market.",
    url: "https://ownerspecs.com",
  },
  twitter: {
    card: "summary_large_image",
    title: "ownerspecs",
    description:
      "Vehicle specification and owner-manual reference — cross-verified, cited, free to read.",
  },
  robots: { index: true, follow: true },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html
      lang="en"
      data-accent="blue"
      className={`${inter.variable} ${plexMono.variable}`}
    >
      <body>{children}</body>
    </html>
  );
}
