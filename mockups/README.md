# ownerspecs.com — design mockups

Static HTML, vanilla CSS, no build step. Open any file in a browser.

## Files

| File | Demonstrates |
|---|---|
| `index.html` | Homepage — hero with value prop, instrument-cluster stat strip, brand-logo grid, 8-tile owner-manual moat grid, latest-updates rail |
| `generation.html` | The canonical page type. 2016-2021 Honda Civic Sedan. Editorial 16:9 hero with overlay, dropcap intro, 6-tile **key-specs strip with analog gauges**, **maintenance snapshot card with severity toggle**, accordion spec groups, **8-tile owner-manual moat grid**, pros/cons, related-trims rail |
| `oil-capacity.html` | The deep moat page. Answer-first card, per-trim breakdown table, contextual note (1.5T oil-dilution issue), **full sources block**, related-fluids rail |
| `maintenance.html` | Flagship maintenance page. Severity toggle, **horizontal service-ruler timeline** (scrollable), full by-mileage table with dot markers |
| `compare.html` | Three-trim compare. Sticky bottom compare bar, **diff-highlighted rows** (green leader bar, muted laggard bar, delta chips), owner-manual rows included alongside engine/performance |

## Color variants

Every page has a tiny dual-circle toggle in the header (oxblood ●  electric blue ●). Click to switch the entire palette live. Try both — oxblood reads as classic-racing-magazine, blue reads as precision-instrument-dashboard.

## Signature design moves

1. **Inline citation superscripts** — every spec value has a `[1][2]` superscript in accent color. The cross-source verification moat is visible in every UI moment. No incumbent does this.
2. **Analog gauges, not progress bars** — class-percentile shown as discrete tick marks (filled / unfilled / peak) like an instrument cluster.
3. **Service ruler timeline** — maintenance schedule rendered as a horizontal engineering scale with milestones as ticks. Memorable. Scrolls.
4. **Editorial dropcap intros** — magazine-style § labels and dropcaps on hero text.
5. **No card-bombing** — sections separated by horizontal rules with eyebrow labels in the gutter, not boxed cards.
6. **Press-photo placeholder** — hero frames are dark gradient + SVG line-art sedan with "PRESS PHOTO PLACEHOLDER" annotation, so the design reads correctly without depending on real OEM photos.

## Type stack

- **Fraunces** (variable serif, opsz 144 for display, 30 for editorial body) — H1/H2 and body editorial passages
- **IBM Plex Sans** — body, navigation, UI
- **IBM Plex Mono** — every spec value, eyebrows, citations, system labels

Tabular numerals enabled everywhere numbers appear (`font-variant-numeric: tabular-nums`).

## Palette

```
--bg            #FAFAF7   warm off-white paper
--ink           #0E1116   deep ink
--ink-soft      #383D44   secondary
--ink-mute      #7C8089   tertiary
--rule          #E5E2DA   hairline
--paper         #F7F3E8   card / panel
--accent OX     #7A2E2E   oxblood (default)
--accent BLUE   #1B4DE3   electric blue
--good          #2D5A3D   leader green (compare)
```

## What this is and isn't

These are **design mockups**, not production code. Real implementation comes next on Next.js 16 with the same tokens, components, and patterns. The HTML/CSS here is hand-written for evaluation, not as a starting point — production will reimplement in React + CSS modules / Tailwind + component primitives, but with this same visual system.

Open `index.html` first, then `generation.html` (the most important page type), then the deep pages.
