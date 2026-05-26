"use client";

import { useEffect, useState } from "react";

// Platform-aware keyboard hint for the search box. Renders "⌘ K" on the server
// + initial client render (so hydration matches), then swaps to "Ctrl K" on
// non-Apple platforms after mount. Doing it in useEffect (not an inline script)
// avoids React reverting the text during hydration.
export function SearchKbd() {
  const [label, setLabel] = useState("⌘ K");
  useEffect(() => {
    const nav = navigator as Navigator & { userAgentData?: { platform?: string } };
    const ua = nav.userAgentData?.platform || navigator.platform || navigator.userAgent || "";
    if (!/Mac|iPhone|iPad|iPod/i.test(ua)) setLabel("Ctrl K");
  }, []);
  return (
    <span className="kbd" id="search-kbd">
      {label}
    </span>
  );
}
