# Manuals Sources: manualslib.com & startmycar.com

Internal reference for the ownerspecs scraping pipeline. Verified 2026-05-19 via Playwright.

## manualslib.com

Massive OEM-manual aggregator (cross-category, not just cars). Anonymous viewing OK; PDF download is captcha + soft sign-in walled but works without account.

### URL pattern
- Brand index (all categories): `https://www.manualslib.com/brand/{brand}/` — e.g. `/brand/bmw/`
- Brand + category index: `https://www.manualslib.com/brand/{brand}/automobile.html` (paginated, A-Z anchors `?page=N`)
- **There is no intermediate model page** — the listing links straight to manual records.
- Manual record: `https://www.manualslib.com/manual/{numeric_id}/{Brand-ModelSlug}.html` (e.g. `/manual/1043128/Bmw-I3.html`). The slug encodes whatever the uploader called the manual (often a chassis code: `Bmw-E90`, `Bmw-G30-2018`, `Bmw-Z3-Coupe-2001`).
- Per-page viewer: append `?page=N` (1-indexed) up to the total page count.
- Download page: `https://www.manualslib.com/download/{numeric_id}/{slug}.html` — recaptcha tickbox, then redirect to PDF.

### In-browser viewer — text extraction
Despite the "PDF viewer" framing, **each page is rendered as a single rasterized image** (not canvas, no per-glyph text layer). The `?page=N` HTML body contains chrome only — page indices, TOC, "Also See for X", "Related Manuals". The `<body>.innerText` of a content page (e.g. i3 p.20, body text 4.4 KB) holds **no OCR of the page content** — only navigation and TOC entries. The TOC strings themselves ARE useful structured data (chapter names, section names).
- `canvas` count: 0. No `pdftext`/`textLayer`/`itemprop="text"` element.
- The page image itself lazy-loads under a wrapper; it's a JPG, not vector text.
- **Implication for Playwright:** cannot scrape values from manual pages via DOM. You must download the source PDF and parse it (most OEM owner's manuals are real text PDFs — pdfminer/pdf-parse works), OR send the page image to Vision/OCR.
- Useful DOM data per manual record (no download needed): title, page count, "Also See for X" sibling-manual list, full Table of Contents text, breadcrumb category.

### Free vs paid
Free. No paywall, no premium tier. Viewing all pages anonymously works. Downloads require a recaptcha tick + (sometimes) a "Sign In" prompt that can be dismissed; total file delivered is a real PDF (`Size: 18 MB | Pages: 236` shown on the download page). No per-IP page-limit hit in this session.

### Coverage quality
- Strong: US-market BMW/Honda/Toyota/Suzuki etc. owner's manuals 2000-2023, plus a lot of pre-2000 service/electrical manuals (E36, E46, E60 service manuals).
- Mixed: very-recent MY (2024-2026) often only via "Quick Start Guide" or "Technical Training" supplements until full handbooks are uploaded.
- Weak: JDM/EU-only models, low-volume trims, and any manufacturer that pursues DMCA. Slugs are uploader-named and inconsistent (`Bmw-Bmw-M2`, `Bmw-Serie-5-E60-2006`) so don't trust slugs for de-dup — use the numeric id.

### Owner's vs workshop vs supplement
Read the listing text, NOT the URL. Each row says e.g. `339 pages X5 Owner's Manual`, `1002 pages 5251 Service Manual`, `386 pages E36 Electrical Troubleshooting Manual`, `43 pages G30 2018 Technical Training Manual`, `12 pages Quick Start Manual`. Filter strings: `Owner's Manual`, `Service Manual`, `Maintenance Manual`, `Technical Training`, `Electrical Troubleshooting`, `Quick Start`, `User manual` (the last is usually an OEM nav/iDrive supplement, not the car manual).

---

## startmycar.com

Community-curated automotive site (Rewise Inc., 2026). Has owner's-manual PDFs hosted on-domain and a few aggregated data sections.

### Site structure
- Brand index: `/{brand}` — e.g. `/bmw` (model picker).
- Model page: `/{brand}/{model}` — e.g. `/bmw/3-series`. Hub with links to sub-sections.
- Sub-sections under each model:
  - `/info/manuals` — owner's manual PDFs by year
  - `/info/manuals/service-repair` — service/repair manuals
  - `/info/fusebox` — fuse box diagrams (typed, structured)
  - `/info/fusebox/{year}` (or `/info/fusebox/{year}/{generation_code}` when multiple gens overlap, e.g. `/2018/g20` vs `/2018/f30`)
  - `/problems` — user-submitted issue reports (multilingual, low signal)
  - `/community`, `/reviews`, `/compare`, `/guides`

### Manuals — hosted vs linked out
**Hosted on-site** at `https://manuals.startmycar.com/published/{Make}-{Model}_{Year}_{Locale}_{hash}.pdf` — direct download, no captcha, no login. Example: `https://manuals.startmycar.com/published/Toyota-Celica_2005_EN-US_US_0248ba5bc4.pdf`.

### Data quality per section
- **Fuse box diagrams: high quality, structured.** Real HTML `<table>` rows of `Type | No. | Description` plus interactive SVG/webp diagrams (`images.startmycar.com/legos/fusebox-thumbnails/...webp`). Per-generation, per-year. **This is the best on-site scraping target** — clean DOM tables.
- **Owner's manuals: sparse coverage.** BMW 3-Series only has 4 PDFs (2006, 2007, 2010, 2023). Toyota Celica has 2001-2005. Generally weak compared to manualslib.
- **Guides (`/guides/*`): templated generic content** with the model name interpolated. "How much motor oil does your 3 Series need?" literally says "look it up in your owner's manual" — NOT model-specific spec data. **Do not scrape these as facts.**
- **Problems / community / reviews: UGC, multilingual, unreliable** for spec scraping.

### Generation-level navigation
Yes, partially. The fuse-box index groups years under generation headers (G20, F30, E90, E46, E36, E30 for the 3-Series) and URLs disambiguate with `/{year}/{gencode}` when generations overlap. **But** there are no dedicated `/{brand}/{model}/{generation}` hub pages — generation is implicit in the year+code URL combo.

### Aggregated spec/maintenance tables
Only the fuse-box module has real curated tables. No on-site torque charts, oil-capacity tables, or fluid-spec tables found at this layer.

---

## How both sites render manual PDFs (summary for the Playwright question)
- **manualslib.com:** server-side rasterizes each PDF page to a JPG. No text layer in the DOM. Playwright cannot extract spec values via selectors — must download the source PDF (captcha-walled) or OCR the image.
- **startmycar.com:** does not have an in-browser viewer — clicking "Download PDF" hits the raw PDF on `manuals.startmycar.com`. From there, run a real PDF parser (most OEM manuals 2010+ are text PDFs).
- **Rule of thumb:** never try to read manualslib content via DOM. Always fetch the PDF (either via manualslib's captcha flow or — preferred — find the same manual mirrored on startmycar.com and grab the direct PDF).

---

## Recipes

### "I need the oil capacity for a 2020 BMW 3 Series G20"
1. Try startmycar fusebox-style structured data first — N/A for oil, skip.
2. startmycar manuals: `/bmw/3-series/info/manuals` — no 2020 listed. Try 2023 PDF as closest, scan maintenance section.
3. manualslib fallback: `/brand/bmw/automobile.html`, ctrl-F "G20" or "3 Series Sedan 2020". Open the matching manual record, hit `/download/{id}/...`, solve captcha, parse PDF.

### "I need the fuse layout for a 2018 BMW 3 Series F30"
- One stop: `https://www.startmycar.com/bmw/3-series/info/fusebox/2018/f30` — DOM tables, scrape directly. No PDF needed.

### "I need the full owner's manual for a 2005 Toyota Celica"
- `https://www.startmycar.com/toyota/celica/info/manuals/2005` → click Download → `manuals.startmycar.com/published/Toyota-Celica_2005_EN-US_US_*.pdf`. Direct fetch.

### "I need a service/workshop manual (not owner's)"
- manualslib only. Filter listing strings for `Service Manual` / `Electrical Troubleshooting` / `Maintenance Manual`. startmycar's `/info/manuals/service-repair` is mostly link-outs and shallow.

---

## Pitfalls

- **manualslib uploader-named slugs lie.** `Bmw-E90.html` may be a 114-page user-uploaded excerpt, not the OEM handbook. Always check the page-count and the title string on the record page.
- **manualslib has duplicates per market/year/locale.** Same model often has 5-10 records (US/EU/UK/different MY). Pick by page count (full handbooks are 200-400 pp) and category label `Owner's Manual`.
- **manualslib download requires captcha tick — Playwright automation will get blocked.** For bulk fetch, either solve captchas via a service or scrape the page images (slow, low quality).
- **startmycar `/guides/*` looks like spec data but is generic boilerplate.** Never treat its text as a per-model fact source.
- **startmycar `/problems` is multilingual UGC** — Arabic/French/Spanish entries are common, signal is anecdotal.
- **startmycar manual coverage is shallow.** Expect 3-5 years per popular model, often non-contiguous. ManualsLib is the bigger archive.
- **Both sites: "BMW M2 Owner's Manual" type duplication** — title text differs from URL slug. Index on numeric id (manualslib) or `{make}-{model}-{year}-{locale}` (startmycar PDF filename).
- **Ads & GDPR iframes inflate DOM** on both sites (Google Ads, recaptcha, doubleclick) — filter `googleads|doubleclick|safeframe|recaptcha` when listing iframes.
