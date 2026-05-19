# Image sourcing — practical reference

For ownerspecs.com. Per-page hero is one car image keyed to `(make, model, generation, trim?)`. Every row in `images` carries `source`, `license`, `attribution`, `original_url`, `download_date`. Never hot-link a third-party CDN; always re-host.

## 1. OEM press rooms (primary source, 2005-present)

| OEM (covers) | URL | Reg? | License posture | Find-by pattern | Resolution / format |
|---|---|---|---|---|---|
| BMW Group (BMW, MINI, Rolls-Royce) | press.bmwgroup.com | Y, free, instant | Editorial; press use OK with credit "Photo: BMW AG" | Search → filter by model + year → "Photos" tab | 3000-5000 px JPEG |
| Toyota (Toyota, Lexus) | pressroom.toyota.com, lexus.com/pressroom | N | Editorial; credit "Photo: Toyota" | Vehicle → model page → Image Gallery | 2000-4500 px JPEG |
| Honda / Acura | hondanews.com, acuranews.com | N | Editorial use; credit Honda/Acura | News releases → attached media | 3000+ px JPEG |
| Stellantis NA (Chrysler/Dodge/Jeep/Ram/Fiat/Alfa) | media.stellantisnorthamerica.com | Y, free, auto-approve | Editorial; credit "Photo: Stellantis" | Brand filter + model + year | 3000-5000 px JPEG |
| Ford (Ford, Lincoln) | media.ford.com, lincoln.media.com | Y, free | Editorial; credit Ford | Vehicle archive → model → year | 3000+ px JPEG |
| GM (Chevy/Buick/GMC/Cadillac) | media.gm.com, media.cadillac.com | Y, free, manual approve ~24h | Editorial; credit GM | Brand → model → photos tab | 3000-6000 px JPEG |
| Hyundai / Genesis | hyundainews.com, genesisnews.com | N | Editorial; credit Hyundai/Genesis | Models → year → media kit | 3000+ px JPEG |
| Kia | kianewscenter.com | N | Editorial; credit Kia | Same | 3000+ px JPEG |
| Mercedes-Benz | media.mercedes-benz.com | Y, free (Daimler PressClub) | Editorial; credit Mercedes-Benz AG | Search by model code (W205, W206) + year | 4000-6000 px JPEG |
| VW Group (VW, Audi, Porsche, Bentley) | newsroom.vw.com, media.audiusa.com, presse.porsche.de | Y for global, N for US sites | Editorial; credit OEM | Model + model year filter | 3000-5000 px JPEG |
| Mazda | insidemazda.mazdausa.com, mazdamediagallery.com | Y for gallery, free | Editorial; credit Mazda | Vehicle galleries → model → year | 3000+ px JPEG |
| Nissan / Infiniti | usa.nissannews.com, infinitinews.com | N | Editorial; credit Nissan/Infiniti | Vehicles → model → media | 3000+ px JPEG |
| Subaru | media.subaru.com | Y, free | Editorial; credit SoA | Vehicles → model → year → photos | 3000-5000 px JPEG |
| Volvo | media.volvocars.com | N | Editorial; credit Volvo Cars | Models → year | 4000+ px JPEG |
| **Tesla** | **No public press library.** Use Wikimedia + Tesla's own newsroom embeds (tesla.com/blog), or Flickr CC. | — | — | — | — |

"Editorial use" definition is vague everywhere — see §4.

## 2. Wikimedia Commons (fallback, pre-2005, niche trims)

- **Category tree:** `Category:<Make>_<Model>` → `Category:<Make>_<Model>_<generation-code>` (e.g. `Category:BMW_3_Series_(G20)`). Year crosscut: `Category:1990s_automobiles`, `Category:2000s_automobiles`.
- **API query (find images for a generation):**
  ```
  https://commons.wikimedia.org/w/api.php?action=query&generator=categorymembers&gcmtitle=Category:BMW_3_Series_(G20)&gcmtype=file&gcmlimit=50&prop=imageinfo&iiprop=url|extmetadata|size&format=json
  ```
  Returns `imageinfo.url`, `extmetadata.LicenseShortName`, `extmetadata.Artist`, `extmetadata.LicenseUrl`.
- **Licenses we accept:** CC-BY-2.0/3.0/4.0, CC-BY-SA-2.0/3.0/4.0, CC0, PD-self, PD-old. **Skip:** CC-BY-NC, CC-BY-ND, GFDL-only.
- **Attribution text:** `"{Artist} / Wikimedia Commons, {LicenseShortName}"` linked to `original_url`. For BY-SA, our footer must also link the license deed (`https://creativecommons.org/licenses/by-sa/4.0/`).

## 3. Flickr CC (1990s + enthusiast shots)

- **Search URL:** `https://www.flickr.com/search/?text=<make>+<model>+<year>&license=4%2C5%2C9%2C10&sort=relevance`
  - License codes: `4`=BY-2.0, `5`=BY-SA-2.0, `9`=CC0, `10`=PD. (`6`=BY-ND, `7`=BY-NC — skip.)
- **API (no key needed for read on photos.search):** `flickr.photos.search&license=4,5,9,10&text=...&extras=license,owner_name,url_o,url_l`.
- **Attribution:** `"{owner_name} on Flickr, CC BY 2.0"` linked to the photo page. License codes 4 and 5 are the two safe-for-commercial defaults.

## 4. "Editorial use only" — the actual risk

Every OEM press kit says "editorial use" without defining it. Motor1, Edmunds, Cars.com, MotorTrend, The Drive all use these images on commercial spec/review pages with attribution. **No public record of an OEM suing or DMCA'ing a specs/review site for press-kit reuse.** Worst case observed industry-wide: takedown email, comply same-day. Risk profile for ownerspecs.com is effectively zero provided:

1. Credit line visible on every page using the image (`Photo: BMW AG`).
2. No alteration beyond resize/crop.
3. Not used to imply OEM endorsement of ownerspecs.
4. Respond to any takedown request within 48h.

Treat OEM press as **de facto safe**, document the rule in `app/(legal)/image-policy/page.tsx`, and move on.

## 5. Recipe — sourcing a hero for `<year> <make> <model>`

1. **Try OEM press** (table §1). Search `"<model> <year>"`. Pick the highest-resolution front-3/4 in the headline trim. Download original JPEG.
2. **If pre-2005 or absent:** Wikimedia Commons API call (§2) on the generation category. Filter by license whitelist. Pick the best 3/4 shot.
3. **If Wikimedia is thin:** Flickr CC search (§3) with `license=4,5,9,10`.
4. **Last resort:** keep the SVG silhouette placeholder (`/public/placeholder-car.svg`). Never embed an auto-data/ultimatespecs URL.

## 6. Pipeline plumbing

- **Storage:** Local `/public/images/{make}/{model}/{generation}-{trim?}.jpg` on the Next.js box. We're on a Hostinger VPS; outbound bandwidth is cheap, latency to user beats S3/R2 for our traffic level (<100k/mo). Migrate to Cloudflare R2 only when we exceed VPS storage (≈40 GB at 200 KB avg × 200k images — fine on a 200 GB VPS for years).
- **Optimisation:** Next.js `<Image>` with `sizes` set; the build-time loader handles AVIF/WebP. Keep the original JPEG on disk for re-encoding.
- **Insert per image** into `images`: `source` ∈ {`oem-press`, `wikimedia`, `flickr-cc`, `unsplash`}, `license` short code (`editorial`, `cc-by-sa-4.0`, `cc-by-2.0`, `cc0`), `attribution` (the rendered string), `original_url`, `download_date`.
- **Footer rendering:** `<ImageAttribution>` component reads from the row and emits `Photo: {attribution} ({license link})`.
- **Scraper:** `scrapers/images/<source>.ts` per source. OEM ones drive Playwright; Wikimedia + Flickr are plain `fetch` to JSON APIs. All write through the same `upsertImage()` in `db/images.ts`.
