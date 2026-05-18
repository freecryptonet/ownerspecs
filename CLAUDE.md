# ownerspecs.com — Claude operating notes

For strategy + design rationale, read `PLAN.md`. This file is for **operating** the project.

## What it is

Internationally-focused automotive specs site competing with auto-data.net and ultimatespecs.com. The moat is owner-manual / FSM data those incumbents don't publish (fluid capacities, torques, maintenance schedules, batteries, bulbs, fuses, procedures). Same audience as sister sites autodtcs.com + servicereset.net.

Sister cluster: vindecoder.site (US), autodtcs.com (intl), servicereset.net (intl), ownerspecs.com (intl), zonewijzer.nl (NL). Cross-link only where audience and content align.

## Where things live

| | Local | Production |
|---|---|---|
| Code | `F:\projects\ownerspecs\` | `/home/deploy/ownerspecs/` on VPS |
| SSH | n/a | `ssh -i ~/.ssh/autodtcs_key root@72.62.154.119` |
| Process | n/a | pm2 app **`os`** on port **3004** (under `deploy` user) |
| Web | n/a | nginx vhost `/etc/nginx/sites-available/ownerspecs.com` → proxy to 127.0.0.1:3004; Let's Encrypt cert auto-renews |
| DB | tunnel via `~/start-mariadb-tunnel.bat` (port 3306 → 127.0.0.1:3306 on VPS) | MariaDB schema `ownerspecs` on Hostinger Business plan box (same shared box autodtcs/servicereset use) |
| DB user (app) | n/a | `ownerspecs_app@127.0.0.1` / `@localhost` (password in `/home/deploy/ownerspecs/.env.local`) |
| GitHub | not yet pushed (gh CLI not installed locally) | target: `freecryptonet/ownerspecs` |
| Memory | `C:\Users\Z620\.claude\projects\F--projects-ownerspecs\memory\` | n/a |

## Stack

- **Next.js 16.2.6** + React 19 + TypeScript + App Router
- **mysql2** with connection pool (`lib/db.ts` — `query<T>()`, `queryOne<T>()`)
- **Inter + IBM Plex Mono** via `next/font/google` (no Tailwind — vanilla CSS with design tokens in `app/globals.css`)
- **@next/third-parties** for GA4 (env-gated)
- All page routes are server components; nothing client-side yet

## Design system rules (locked)

**Engineering Reference aesthetic** — Wikipedia + GitHub + auto-data, never magazine. If you're tempted to:

- Use a serif/editorial font → **stop.** Inter only, IBM Plex Mono for tabular numerics.
- Add italics, dropcaps, scores, "Pros / Cons", `§` section labels → **stop.** Those signal editorial/blog; we're reference.
- Add an atmospheric dark hero with overlay text → **stop.** Wikipedia-infobox: small photo + structured spec table.
- Hide data behind accordions → **stop.** Auto-data shows everything; we should too.
- Default to cards everywhere → **prefer tables.** Use 1 px borders, alt-row stripes, monospaced spec values. Cards only for the answer-card pattern on deep moat pages.

**Mandatory on every page:**
- Verification badge with source count + last-reviewed date
- Inline `[n]` citation superscripts on spec values (every number that was extracted from a source)
- Sources block at the bottom — only sources that are actually cited via `spec_sources` should appear

Reference mockups live in `mockups/` (HTML) — the production design system in `app/globals.css` is the same tokens + components. Reload mockups locally with `python -m http.server 8765` from that dir if you want to compare iterations.

## Common operations

**Deploy a code change:**
```bash
# from F:\projects\ownerspecs\
scp -i ~/.ssh/autodtcs_key <changed-file> root@72.62.154.119:/home/deploy/ownerspecs/<path>
ssh -i ~/.ssh/autodtcs_key root@72.62.154.119 'chown -R deploy:deploy /home/deploy/ownerspecs && sudo -u deploy bash -c "cd /home/deploy/ownerspecs && npm run build && pm2 restart os"'
```

**Run a SQL migration:**
```bash
scp -i ~/.ssh/autodtcs_key db/migrations/NNN_name.sql root@72.62.154.119:/tmp/
ssh -i ~/.ssh/autodtcs_key root@72.62.154.119 'mariadb ownerspecs < /tmp/NNN_name.sql'
```

**Inspect the DB:**
```bash
ssh -i ~/.ssh/autodtcs_key root@72.62.154.119 'mariadb ownerspecs -e "SHOW TABLES;"'
# or as the app user to verify grants:
ssh -i ~/.ssh/autodtcs_key root@72.62.154.119 'cat /home/deploy/ownerspecs/.env.local'  # gets the password
```

**pm2 control:**
```bash
ssh -i ~/.ssh/autodtcs_key root@72.62.154.119 'sudo -u deploy pm2 logs os --lines 50'
ssh -i ~/.ssh/autodtcs_key root@72.62.154.119 'sudo -u deploy pm2 restart os'
```

**Local dev** (if pulling down the project to dev locally):
1. Open the MariaDB tunnel: `~/start-mariadb-tunnel.bat` (forwards 127.0.0.1:3306 to VPS)
2. Copy `.env.example` → `.env.local` and fill `DB_PASSWORD` (get it from `/home/deploy/ownerspecs/.env.local` on VPS)
3. `npm install && npm run dev`

## Data conventions

- **URL pattern**: `/[brand]/[generation]` for the generation hub (e.g. `/honda/civic-sedan-x-2016-2021`); `/[brand]/[generation]/[topic]` for deep moat pages
- **Slugs**: generation slug includes model + body + ordinal + years (e.g. `civic-sedan-x-2016-2021`). Globally unique within brand.
- **market_id** on spec tables is nullable: `NULL` = global default, non-NULL = per-market override. When querying, fall back from market-specific → global.
- **Citations**: every spec row must trace to ≥1 source (≥2 preferred) via `spec_sources(spec_table, spec_id, source_id)`. The polymorphic join lets one source cite multiple spec tables.
- **Numbers**: store both metric and imperial where the OEM publishes both (e.g. `torque_nm` + `torque_ftlb`). Don't compute one from the other — capture what the manual says.
- **Provenance for images**: every row in `images` must have `source`, `license`, `attribution`, `original_url`, `download_date`. Render attribution in the page footer.

## Don'ts

- Never publish verbatim text from any owner manual or FSM. Facts only; procedures restated in our own words.
- Never embed image URLs from auto-data.net or ultimatespecs.com's CDN. Source images separately (OEM press / Wikimedia / Flickr CC).
- Never break the source-tracking invariant — if you add a spec value without inserting a `spec_sources` row, that spec won't carry a citation and the page won't show it in the sources block.
- Never use `git push --force`, `pm2 delete vd/vd-staging/zw/fc`, or any destructive op on the shared VPS without explicit confirmation. Other production sites live there.

## Pending

See the project memory file `ownerspecs-project.md` for the live pending list (Phase 2+ items: per-topic sub-pages, scraping pipeline, brand/model index pages, image ingestion, GA4 + GSC verification, GitHub remote push).
