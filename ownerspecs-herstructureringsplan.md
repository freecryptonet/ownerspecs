# Volledig analyse- en herstructureringsplan voor ownerspecs.com

> Concurrentie-analyse van ultimatespecs.com en auto-data.net vs. de huidige structuur van ownerspecs.com, plus een concreet plan om ze te outranken.

---

## 1. Hoe de concurrentie is gestructureerd

### Ultimatespecs.com — de hiërarchie

Ze werken met **vijf niveaus**, elk met een eigen pagina en eigen rol in de funnel:

```
/car-specs                                       (alle merken)
   /BMW-models                                   (alle BMW modellen)
      /BMW-models/BMW-3-Series                   (model — alle generaties)
         /BMW/M8103/F30-3-Series-Sedan-LCI       (generatie/bodystyle — alle versies)
            /BMW/72268/...-320i.html             (specifieke trim — de spec sheet)
```

Wat opvalt:

- De **modelpagina** ("BMW 3 Series") is een dunne hub die alleen alle generaties opsomt
- De **generatie-pagina** (`F30 LCI`) is de echte hub — daar zitten alle motoren in één tabel, gefilterd op Plugin Hybrid / Petrol / Diesel, met links naar elke trim
- De **trim-pagina** is de daadwerkelijke spec sheet (motor, dimensies, prestaties, verbruik, remmen, ophanging) — dit is hun belangrijkste landingspagina vanuit Google
- Elke trim-pagina heeft "F30 LCI Versions" als een **complete lijst van sibling-links** (alle andere trims binnen dezelfde generatie) — dit is de motor van hun interne linking
- Daarnaast linken ze proactief naar 'previous generation' en 'next generation' onderaan
- Geen aparte sub-pagina's voor onderhoud, vloeistoffen, etc. — alles staat op één trim-pagina

### Auto-data.net — de hiërarchie

Vrijwel identiek aan ultimatespecs maar net iets anders genoemd:

```
/allbrands                                       (alle merken)
   /bmw-brand-86                                 (BMW — alle modellen)
      /bmw-3-series-model-953                    (3 Series — alle generaties)
         /bmw-3-series-sedan-f30-lci-...-4512    (generatie — alle versies)
            /bmw-...-320i-184hp-23001            (trim — de spec sheet)
```

Verschillen met ultimatespecs:

- Ze hangen het horsepower-getal **in de URL** van de trim-pagina ("320i-184hp"), wat een sterke long-tail SEO signaal geeft
- Hun trim-pagina is dichter, met meer datavelden (engine code, weight-to-power ratio, max trailer load, drag coefficient, turning circle)
- Hun model-pagina is óók dun — alleen een lijst generaties
- Hun generatie-pagina heeft een tabel met alle versies + key-specs naast elkaar (snelheid/0-100/verbruik), dus die pagina kan zelf ranken op brede zoekopdrachten zoals "BMW F30 LCI specs"

### Het gemeenschappelijke patroon

Beide concurrenten doen **exact hetzelfde**:

1. **Merk** = alleen index
2. **Model** = lichte hub, lijst generaties (krijgt weinig zoekverkeer behalve voor "BMW 3 Series specs")
3. **Generatie + bodystyle** = mid-tier hub, alle trims in tabelvorm — ranked op "BMW F30 specs", "3 Series Sedan F30 specifications"
4. **Trim** = de eindpagina, **de echte SEO-machine** — ranked op "BMW 320i F30 LCI specs", "BMW 320i 184hp specs"

De interne linking is bij beide bijna industriëel:

- Elke trim-pagina linkt naar **alle siblings** (andere trims in dezelfde generatie) — vaak 20-30+ links
- Elke trim linkt **omhoog** naar generatie + model + merk via breadcrumb
- Elke generatie-pagina linkt naar **vorige en volgende generatie**
- Elke pagina toont een merk-index footer (60+ merken)
- "Compare with another car" en "Latest specs" creëren extra contextuele links

---

## 2. Wat ownerspecs.com nu doet

### Wat goed gaat

- Je URL-structuur is **al correct**: `/bmw/3-series-f30-sedan-2012-2018/335i-306-hp` is duidelijk en SEO-vriendelijk
- Je hebt een goede breadcrumb-structuur
- Je hebt iets wat de concurrentie niet heeft: **uitgesplitste subpagina's per onderwerp** (oil-capacity, coolant, torque, maintenance-schedule, electrical, procedures, tires) — dit is goud waard voor long-tail
- Je hebt **bronnen + datums** zichtbaar op elke pagina — pure E-E-A-T win
- Je hebt een aparte **engines** sectie (per motor-code) — dat hebben concurrenten ook niet, en het is geweldig voor zoekopdrachten als "N55B30A specs"

### Waar je gevoel klopt — de problemen

1. **De modelpagina (`/bmw/3-series`) is goed dun gehouden**, dat is correct. Geen probleem hier.

2. **Het echte structurele probleem zit op de generatie-pagina** (`/bmw/3-series-f30-sedan-2012-2018`):
   - Je toont 'Dimensions & capacities' met **één set getallen** (Length 4624 mm, Width 1811 mm, etc.) terwijl auto-data.net erkent dat lengte verschilt per facelift (4624 pre-LCI vs 4633 LCI) en hoogte/breedte ook
   - Je hebt 'Gen-wide fluids' — dat is een goed concept, maar je toont 'Drivetrain & chassis' als één blok terwijl in werkelijkheid 335i RWD is en 335i xDrive AWD is, en de remmen verschillen tussen 320i (vented voor/achter discs) en 335i (groter)
   - In jouw F30 generatie zie ik **maar 5 trims**, terwijl er in werkelijkheid ~35+ trims zijn (316d, 318d, 320d, 320d ED, 320d xDrive, 320i, 320i xDrive, 328i, 330d, 335i, ActiveHybrid, M3, plus alle Auto/manual varianten). Je hebt niet de breedte
   - Er ontbreekt een **filterbare tabel met alle trims naast elkaar** met de key-specs (Hp, 0-100, top speed, verbruik) — dit is wat concurrenten op de generatie-pagina laten ranken

3. **De trim-pagina herhaalt teveel** wat al op de generatie-pagina staat. Op de 335i pagina staat opnieuw 'Fluids' met dezelfde brake fluid, A/C refrigerant — die staan ook al op de generatie-pagina als 'gen-wide fluids'. Dat is content-duplicatie binnen je eigen site.

4. **Splitsing pre-facelift vs facelift (LCI) ontbreekt** — concurrenten behandelen `F30` (2012-2015) en `F30 LCI` (2015-2019) als twee aparte generatie-entries omdat de motoren, verbruikswaarden en sommige dimensies anders zijn. Jij hebt ze samen onder `3-series-f30-sedan-2012-2018`.

5. **Internal linking is veel te beperkt** — je hebt 4-5 sibling-links onderaan, concurrenten hebben er 20-35. Je linkt niet naar 'compare', 'vorige generatie' (E90), 'volgende generatie' (G20) prominent in de vlees-content. En je linkt nergens cross-model (bv. van BMW 3 Series naar BMW 5 Series via "ook interessant").

6. **Bodystyle hangt nu samen met de generatie-slug** (`3-series-f30-sedan-2012-2018`) — voor BMW betekent dat dat F31 Touring, F34 GT, F32 4-series straks een aparte slug nodig hebben. Dat is op zich oké (concurrenten doen ook zo) maar je moet je strategie hierop bewust afstemmen.

---

## 3. De aanbevolen structuur voor ownerspecs.com

### URL-hiërarchie (5 niveaus — gelijk aan concurrentie)

```
ownerspecs.com/                                    (1) Site index
  /[make]                                          (2) Make index — alle modellen
  /[make]/[model]                                  (3) Model index — alle generaties van dat model
  /[make]/[model]-[gencode]-[bodystyle]-[years]    (4) Generatie hub — ALLE trims in tabel
  /[make]/[model]-[gencode]-[bodystyle]-[years]/[trim-slug]  (5) Trim spec sheet

Plus sub-pagina's onder generatie (NIET onder trim):
  /[make]/[gen-slug]/oil-capacity
  /[make]/[gen-slug]/coolant
  /[make]/[gen-slug]/transmission-fluid
  /[make]/[gen-slug]/brake-fluid
  /[make]/[gen-slug]/torque
  /[make]/[gen-slug]/maintenance-schedule
  /[make]/[gen-slug]/electrical
  /[make]/[gen-slug]/tires
  /[make]/[gen-slug]/procedures
  /[make]/[gen-slug]/fuses                       (nieuw — eigen pagina)
  /[make]/[gen-slug]/bulbs                       (nieuw — eigen pagina)
  /[make]/[gen-slug]/towing                      (nieuw — eigen pagina)
```

**Belangrijk verschil met concurrentie**: jouw 10+ subpagina's per generatie geven je 10x meer landingspagina's dan ultimatespecs heeft. Dat is je belangrijkste SEO-wapen. Een query als "BMW F30 oil capacity" laat ultimatespecs een trim-pagina serveren waar de info diep verstopt zit — jij hebt een dedicated pagina. Behoud dit en breid het uit.

### Splits pre-facelift en facelift apart

Wat nu `3-series-f30-sedan-2012-2018` is, zou twee aparte generatie-entries moeten worden:

- `/bmw/3-series-f30-sedan-2012-2015` (pre-LCI: N20/N52/N55, ~35 trims)
- `/bmw/3-series-f30-lci-sedan-2015-2019` (LCI: B48/B58, ~35 trims)

Reden: zoekopdrachten als "BMW F30 LCI specs" en "BMW F30 facelift specs" zijn substantieel, en de werkelijke specs verschillen (verbruik, CO2, soms motorvermogen). Concurrenten doen dit ook. Wel kruisverwijzen ("Pre-facelift: F30 (2012-2015)" prominent linken).

En bij BMW 3 Series ook bodystyles uitsplitsen:

- F30 Sedan, F31 Touring, F34 GT (Gran Turismo) zijn elk eigen generatie-entries

### Wat hoort op welke pagina

#### Niveau 2 — Make (`/bmw`)

**Dun en breed.** Doel: linken naar elk model. Bevat:

- H1 "BMW"
- Korte intro (2 zinnen, generic)
- Lijst alle modellen, gegroepeerd: 1 Series, 2 Series, 3 Series, ..., X1, X3, X5, ..., i3, i4, iX
- Per model: aantal generaties + aantal trims
- Géén specs op deze pagina

Status: doe je goed. Behouden.

#### Niveau 3 — Model (`/bmw/3-series`)

**Dun maar wel iets dikker dan nu.** Bevat:

- H1 "BMW 3 Series"
- Modelgeschiedenis in 1-2 alinea's (dit is je E-E-A-T moment: "geïntroduceerd in 1975 als opvolger van de 02-series, …")
- Tijdlijn-tabel: alle generaties met productiejaren, gen-codes (E21, E30, E36, E46, E90, F30, G20), aantal trims
- Per generatie een link met thumbnail
- Géén individuele specs hier

Status: nu te dun. Voeg modelgeschiedenis toe en zorg dat àlle generaties zichtbaar zijn (ook al heb je nog niet alle data — kun je placeholder doen).

#### Niveau 4 — Generatie/bodystyle hub (`/bmw/3-series-f30-sedan-2012-2015`)

**Dit is je middle-tier SEO-machine.** Bevat:

1. **Hero met identificatie**: make, model, generatie, bodystyle, productiejaren, een hero-foto
2. **Generatie-overzicht** (2-3 alinea's E-E-A-T content): wat is deze generatie? wat zijn de motoren? marktverschillen US/EU/JDM? facelift-verschillen?
3. **Filterbare specs-tabel met ALLE trims** (dit is wat je nu mist):
   - Kolommen: Trim naam | Motor (code) | Hp | Torque | Transmissie | Aandrijving | 0-100 | Top speed | Verbruik | CO2 | Bouwjaren
   - 1 rij per trim
   - Filterbar op: brandstof (benzine/diesel/hybride/EV), transmissie (manual/auto), aandrijving (FWD/RWD/AWD)
   - Iedere rij linkt naar de trim-pagina
4. **Dimensies** — maar nu **met disclaimer dat dimensies kunnen verschillen tussen trims** (M-pakket, xDrive verhoogt rijhoogte). Toon range (Length 4624-4633 mm) plus link naar trim-pagina voor exacte waarde.
5. **Generatie-brede vloeistoffen** (alleen wat ECHT gen-wide is: brake fluid spec, A/C refrigerant) — dit is een goede concept
6. **Owner-manual data hub** — kaarten naar de 10+ subpagina's: oil-capacity, coolant, transmission, brake-fluid, torque, maintenance-schedule, electrical, tires, fuses, bulbs, procedures, towing
7. **Vorige + volgende generatie** prominent (zoals ultimatespecs)
8. **Andere bodystyles van dezelfde generatie** ("Looking for the Touring? F31 (2012-2015)")
9. **Bronnen + revisiedatum** — wat je al doet

#### Niveau 5 — Trim spec sheet (`/bmw/3-series-f30-sedan-2012-2015/320i-184-hp`)

**Dit is je bottom-of-funnel landingspagina.** Bevat:

1. **Identiteit-blok**: trim naam, motor code, vermogen, transmissie, aandrijving, generatie + jaren
2. **Hero met foto** (mag generation-shared zijn, dat doe je al)
3. **Volledige specs tabel** — alleen voor DEZE trim:
   - Engine: code, displacement, bore×stroke, compressie, klepconfig, aspiratie, brandstofsysteem
   - Performance: Hp/Nm/rpm, 0-100, top speed, weight-to-power, verbruik (city/extra/combined), CO2, emission standard
   - Dimensies (trim-specifiek): lengte, breedte, hoogte (kan verschillen met M-pakket), wheelbase, front/rear track, ground clearance, drag coefficient, turning circle
   - Gewicht: curb, gross, max load, max roof load, towing braked/unbraked
   - Wielen/banden/remmen: tire size, rim size, front/rear brakes (vented disc met diameter), suspension
4. **Trim-specifieke vloeistoffen** (engine-oil voor exact deze motor, coolant capacity, transmissie-olie als manueel/automaat verschilt)
5. **Trim-specifieke maintenance schedule** — gefilterd voor deze motor (sommige services verschillen tussen N20 en N55)
6. **Trim-specifieke torque + OEM part numbers** — banden, wiper-blades verschillen vaak per trim
7. **Tire pressures (placard)** — kan trim-specifiek zijn met M-pakket
8. **Andere trims in dezelfde generatie** — ALLE 30+ trims als links, niet maar 4. Dit is hoe ultimatespecs intern linkt.
9. **Vergelijk-CTA** ("Vergelijk 320i met 320d", "Vergelijk met 320i van de pre-LCI"): contextuele compare-links
10. **Link omhoog naar gen-wide subpagina's** (oil-capacity, maintenance schedule, etc.) — niet de tabellen herhalen, alleen een "Zie het complete overzicht over alle motoren" link

**Belangrijk om weg te halen van de trim-pagina:**

- Brake fluid + A/C refrigerant (die zijn gen-wide, hoort op gen-pagina + dedicated subpagina's)
- 'Compare across all engines' lijst (die hoort op de gen-pagina, niet op een trim-pagina)
- Sources blok — verkort tot een korte "Sources" mini-blok met expand-link

#### Niveau 5b — Onderwerp-subpagina's (`/bmw/[gen]/oil-capacity`)

**Dit is je verborgen wapen — concurrentie heeft dit niet.** Per generatie:

- `oil-capacity` — capacity per motor, viscositeit, OEM spec, filter PN, drain interval. Wat je al hebt.
- `coolant` — capaciteit per motor + radiator type
- `transmission-fluid` — automaat vs manueel, ATF type, capaciteit per gearbox-code
- `brake-fluid` — gen-wide hoofdzakelijk, maar flush interval per markt
- `torque` — alle fasteners (lug, drain plug, spark plug, caliper, suspension, hub)
- `maintenance-schedule` — service intervals normal + severe duty
- `electrical` — battery group, CCA, alternator, fuse-map, bulb-manifest. Kun je opsplitsen in `electrical`, `fuses`, `bulbs` apart als de data groot is.
- `tires` — OE sizes, placard PSI, bolt pattern, rim offset, run-flat ja/nee
- `procedures` — oil-reset, jump-start, TPMS relearn, battery disconnect order, jacking points, key-fob battery (dit is je servicereset.net crossover-content)
- `fuses` — under-hood en cabin fuse box layout met diagrams
- `bulbs` — complete bulb manifest per locatie (koplamp low-beam, high-beam, mistlamp, knipperlicht etc.)
- `towing` — braked/unbraked trailer load, payload, roof load, trailer wiring pinout

**Dit zijn 12 extra landingspagina's per generatie**. Voor BMW alleen al (10 modellen × 4 generaties × 12 pagina's = 480 long-tail landingspagina's bovenop je trim-pagina's). Dat is geweldig.

#### Niveau 5c — Procedure-pagina's (`/procedures/[procedure-slug]`)

Onafhankelijk van merk. Bevat:

- "Oil life reset BMW iDrive" — generic met daarna sectie per generatie
- "BMW jump-start procedure F30" — kunnen op aparte pagina staan of als sub van de gen-pagina

Tip: zorg dat je dezelfde procedure niet op twee plekken hebt (canonical-conflict).

### Engine-pagina's (`/engines/n55b30a`)

**Goed concept, behouden.** Maak hier de bron-van-waarheid voor:

- Motor-specs (displacement, bore×stroke, klepconfig)
- Welke voertuigen gebruiken deze motor (link naar elke trim die N55B30A heeft — BMW 335i F30, 535i F10, X3 F25, etc.)
- Bekende problemen, common DTCs (CROSSOVER met autodtcs.com — link op DTC-code naar autodtcs.com)
- Olie-spec voor deze motor

Dit geeft je een hele extra zoekvraag-categorie: "N55 engine specs", "B48 oil capacity", "M54B22 reliability".

---

## 4. Internal linking strategie

Concurrenten zijn industrieel met linking. Jij moet hetzelfde doen. Op elke pagina:

### Op de trim-pagina (5 link-clusters)

1. **Breadcrumb omhoog** — Catalogus › BMW › 3 Series › F30 LCI Sedan › 320i (184 Hp)
2. **Alle siblings binnen de generatie** — 30+ links naar andere trims. Concurrenten doen dit. Plat dump aan de onderkant is prima ("F30 LCI versions: - 316d - 316d Auto - 318d - 318d Auto - 318i ..."). Voeg key-specs in mouse-over toe.
3. **Vorige + volgende generatie** — "Same trim, earlier generation: BMW E90 320i (2005-2011)" + "Next generation: BMW G20 320i (2019-...)"
4. **Gen-wide subpagina's** — kaarten naar oil-capacity, coolant, torque, etc.
5. **Comparison-CTA's** — "320i vs 320d" + "320i F30 vs 320i G20" + "320i vs A4 (Audi)" — dit zijn long-tail goudmijnen

### Op de gen-pagina

1. Breadcrumb
2. Alle trims (de tabel zelf is je interne link-machine)
3. Vorige + volgende generatie
4. Andere bodystyles (F30 Sedan → F31 Touring → F34 GT)
5. Alle gen-wide subpagina's

### Op de subpagina (oil-capacity)

1. Breadcrumb
2. Verticale tabs voor andere subpagina's (zoals je nu al hebt: Overview, Fluids, Torque, Maintenance, Electrical, Procedures)
3. "Zie ook" naar gerelateerde subpagina's binnen dezelfde gen
4. Cross-make link op motor-niveau: "Same N55B30A engine? Zie ook BMW 5 Series F10 535i oil capacity"

### Topical clusters / hub-and-spoke

Bouw thematische clusters via je guides (`/guides`):

- "5W-20 vs 5W-30 oil viscosity guide" → linkt naar alle pagina's waar 5W-30 wordt voorgeschreven
- "Severe duty maintenance schedule explained" → linkt naar elke maintenance-schedule pagina
- "What is a TPMS relearn" → linkt naar alle TPMS-procedure pagina's

---

## 5. Concrete actie-items in volgorde

### Fase 1 — structuur fixen (week 1-2)

1. Splits `3-series-f30-sedan-2012-2018` in twee generatie-entries: pre-LCI (2012-2015) en LCI (2015-2019). Zet 301-redirects voor de oude URL.
2. Op de gen-pagina: voeg de filterbare full-trim-tabel toe met alle 30+ trims + key-specs naast elkaar. Dit is je nieuwe ranking-pagina voor "BMW F30 LCI specs".
3. Op de gen-pagina: verwijder de single-set 'Dimensions & capacities' tabel, vervang door range + verwijs naar trim-pagina voor exacte waarde.
4. Op de trim-pagina: voeg de complete sibling-trim-lijst toe (alle 30+ trims).
5. Op de trim-pagina: voeg "Vorige generatie / volgende generatie / dezelfde trim" link toe.

### Fase 2 — data verbreden (week 3-6)

1. Vul de breedte aan: per generatie nu maar 5 trims → uitbreiden naar de ~30+ die er echt zijn. Begin bij F30 Sedan en G20 als test-models.
2. Voeg bodystyles uit: F31 Touring, F34 GT als aparte gen-entries.
3. Voeg pre-2012 generaties toe: E90, E46, E36, E30 (allemaal aparte gen-entries per bodystyle).

### Fase 3 — subpagina's uitbreiden (week 4-8 parallel)

1. Per generatie de subpagina's afmaken die ontbreken: coolant, transmission-fluid, brake-fluid, electrical/fuses/bulbs, tires, towing, procedures. Je hebt nu 7, doel is 12.
2. Schrijf op elke subpagina een 100-200 woord intro met E-E-A-T context ("De F30 LCI gebruikt sinds 2015 BMW Longlife-04 olie voor de B48 benzine, terwijl de B47 diesel LL-12 vereist. Hier is de exacte capacitiet per motor…").

### Fase 4 — internal linking maximaliseren (week 6-10)

1. Bouw een sibling-trim block component die op elke trim-pagina alle siblings toont.
2. Bouw een 'gen-history' block dat op elke gen-pagina en trim-pagina de vorige en volgende generatie toont.
3. Bouw 'cross-bodystyle' suggesties (F30 → F31 → F34).
4. Bouw een 'common-engine' block dat op trim-pagina's andere voertuigen toont die dezelfde motor delen (335i F30 N55 → 535i F10 N55, X3 35i F25 N55, etc.).

### Fase 5 — comparison-pagina's (week 8-12)

1. Bouw `/compare/[trim-a]-vs-[trim-b]` pagina's. Dit zijn enorme long-tail rankers.
2. Begin met de meest gezochte: 320i vs 320d, 330i vs 330e, M3 vs M4, etc.
3. Auto-genereren met data die je al hebt.

### Fase 6 — guides + thematische content (lopend)

1. Schrijf guides die als hub fungeren: "Complete guide to BMW oil specifications", "BMW diesel particulate filter regeneration explained", "Which BMWs share the N55 engine?".
2. Deze linken massaal naar je trim- en gen-pagina's.

---

## 6. Belangrijke do's & don'ts

**Doen:**

- Behoud je bronnen + datums prominent. Dat is je grootste E-E-A-T voorsprong.
- Behoud je 'verified across N sources' badge.
- Behoud je engine-catalogus (`/engines/n55b30a`) — concurrenten hebben dit niet.
- Voeg per generatie een unieke 100-300 woord redactionele tekst toe (geschiedenis, marktverschillen, faceliftverschillen) — geen lorem ipsum, geen herhaling.
- Houd je trim-URL's beschrijvend (`/320i-184-hp` is goed, beter zou zijn `/320i-184hp-sedan-2015` als je nog veel uniciteit nodig hebt, maar wat je hebt werkt).

**Niet doen:**

- Geen identieke data tonen op zowel gen- als trim-pagina. Als brake fluid gen-wide is, toon het op de gen-pagina + dedicated subpagina, en op de trim-pagina alleen een verwijzing.
- Geen lege subpagina's publiceren (tablet met "TBD" of "data ontbreekt") — die schaden je site quality signaal. Liever niet-publiceren tot je data hebt.
- Geen Engelse en Nederlandse content vermengen op één pagina — maak een schone /nl/ subpath als je multilingual gaat.
- Niet één gen-entry voor pre-facelift + facelift houden — splitsen.

---

## 7. Wat je écht uniek maakt vs. concurrentie

Als je dit goed uitvoert, heb je:

1. **Owner-manual data die zij niet hebben** — fluid capacities, torque values, fuse maps, procedures (12 subpagina's per gen)
2. **Engine-catalogus** met cross-vehicle references (welke auto's delen N55)
3. **Cross-sectorale cross-links** naar autodtcs.com (DTC codes per motor) en servicereset.net (service-reset procedures)
4. **Bronnen + revisiedatums** zichtbaar (E-E-A-T)
5. **Cross-verified** badge met aantal bronnen
6. **Een schonere UI** dan ultimatespecs (die ziet er rommelig uit met advertenties)

De concurrentie verslaan op pure specs is lastig (zij hebben 50.000+ trims, jij hebt ~400). Maar op **owner-manual data + maintenance + procedures** kun je ze in 6-12 maanden voorbij streven omdat zij die data simpelweg niet hebben.

---

## 8. Mogelijke vervolgstappen

Concrete vervolgactiviteiten die voortbouwen op dit plan:

- Een concrete URL-redirect plan opstellen voor het splitsen van de F30 pagina in pre-LCI en LCI
- Een gedetailleerde data-template (JSON-schema) ontwerpen voor de filterbare trim-tabel op de gen-pagina
- De internal-linking componenten in pseudo-code schetsen (sibling-block, gen-history-block, common-engine-block)
- Een prioriteitenlijst maken van welke modellen/generaties als eerste de complete behandeling moeten krijgen
