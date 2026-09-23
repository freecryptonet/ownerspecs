"""The ~12-15 representative vehicle cross-section for the RDW data-quality audit.
Brands x segments x fuels x bodies + an import-heavy model + the car we hold a CoC for.

`coc` values are gold ground-truth from a held CoC; `coc_tvv` scopes the gold check to the
exact (variant, uitvoering) the CoC was issued for, since a cohort blends many TVVs and the
dominant TVV's modal value can differ from a rarer TVV's. `expected_body` lists RDW
`inrichting` enum values (exact case: 'hatchback', 'MPV', 'sedan', 'stationwagen', 'coupe',
'cabriolet', 'terreinwagen' — RDW's controlled vocabulary, confirmed live) the model is KNOWN
to offer in reality (the external reality anchor). `cross_ranges` are trusted external min/max
(kentekenfeiten cohorts) for the cross-source signal. Extend as CoCs arrive.

CORRECTED 2026-09-23 (supersedes the prior note in this docstring — do not re-invert):
`massa_rijklaar` = the EU type-approval / CoC §13 "mass in running order" (kerb + 75 kg driver +
90% fuel). It IS the DOCUMENT-verified value (Kia Rio: RDW 1160 = CoC §13 1160, exact) and
carries the CoC-gold check below. `massa_ledig_voertuig` = RDW-DERIVED
(`massa_rijklaar - 100 kg`, a flat Dutch admin convention), NOT a manufacturer/CoC value, NOT a
true kerb — it is audited for fill/range only and carries NO `coc` key anywhere in this sample.
Verified exactly (100 kg delta) over 8,000 rows including EVs, where it is even more fictional
(kerb - 25, since an EV has no fuel). The document-verifiable mass fields (RDW stores these
verbatim from the type approval, confirmed byte-for-byte against a held CoC for the Rio's exact
TVV) are massa_rijklaar (CoC §13), technische_max_massa_voertuig (CoC §16.1),
maximum_trekken_massa_geremd (§18 braked), maximum_massa_trekken_ongeremd (§18 unbraked), and
maximum_massa_samenstelling (§16.4 train).
"""

SAMPLE = [
    {
        "key": "kia-rio-yb", "merk": "KIA", "hb": ["RIO"],
        "date_van": "20110101", "date_tot": "20180101",
        "fields": {
            # Document-verifiable — held CoC gold, TVV B5P11/M61BZ1. Confirmed live against
            # RDW: technische_max=1620, geremd=1110, ongeremd=450, samenstelling=2730 —
            # all four match the CoC exactly for this TVV (massa_rijklaar=1160 CoC-checked below).
            "technische_max_massa_voertuig": {"lo": 900, "hi": 2500, "coc": 1620,
                                               "coc_tvv": ("B5P11", "M61BZ1")},
            "maximum_trekken_massa_geremd": {"lo": 0, "hi": 2500, "coc": 1110,
                                              "coc_tvv": ("B5P11", "M61BZ1")},
            "maximum_massa_trekken_ongeremd": {"lo": 0, "hi": 1000, "coc": 450,
                                                "coc_tvv": ("B5P11", "M61BZ1")},
            "maximum_massa_samenstelling": {"lo": 1500, "hi": 4000, "coc": 2730,
                                             "coc_tvv": ("B5P11", "M61BZ1")},
            # RDW-derived (rijklaar-100, NL admin convention) — kept deliberately WITHOUT a
            # `coc` key; it is not a manufacturer/CoC value. Range/fill only.
            "massa_ledig_voertuig": {"lo": 700, "hi": 2000},
            # Document-verifiable — CoC §13 "mass in running order" (kerb + 75 kg driver +
            # 90% fuel). Held CoC gold, TVV B5P11/M61BZ1 — RDW 1160 = CoC 1160, exact.
            "massa_rijklaar": {"lo": 700, "hi": 2000, "coc": 1160,
                                "coc_tvv": ("B5P11", "M61BZ1")},
            "inrichting": {"expected_body": ["hatchback"], "min_share": 0.02},
        },
    },
    {
        "key": "vw-golf-7", "merk": "VOLKSWAGEN", "hb": ["GOLF"],
        "date_van": "20121101", "date_tot": "20201231",
        "fields": {
            "massa_rijklaar": {"lo": 900, "hi": 2200},
            "inrichting": {"expected_body": ["hatchback"], "min_share": 0.05},
        },
    },
    # --- Breadth cohorts (no CoC; exercise fill/agreement/range/expected signals) ---
    {
        # Diesel-era compact SUV/crossover. RDW's inrichting enum has NO 'suv' value at
        # all for this class — it splits between 'MPV' and 'stationwagen' — so an
        # expected_body=['suv'] check always rejects. That is itself the finding: the
        # enum gap, not a mis-code, for crossover-shaped vehicles.
        "key": "peugeot-3008-mk1", "merk": "PEUGEOT", "hb": ["3008"],
        "date_van": "20090101", "date_tot": "20160101",
        "fields": {
            "massa_ledig_voertuig": {"lo": 1150, "hi": 2000},
            "technische_max_massa_voertuig": {"lo": 1600, "hi": 2600},
            "maximum_trekken_massa_geremd": {"lo": 0, "hi": 2200},
            "inrichting": {"expected_body": ["suv"], "min_share": 0.02},
            "massa_rijklaar": {"lo": 1150, "hi": 2100},
        },
    },
    {
        # BEV sedan — contrast case: RDW correctly codes this as 'sedan' at ~100%.
        "key": "tesla-model-3", "merk": "TESLA", "hb": ["MODEL 3"],
        "date_van": "20190101", "date_tot": "20240101",
        "fields": {
            "massa_ledig_voertuig": {"lo": 1500, "hi": 2100},
            "technische_max_massa_voertuig": {"lo": 1900, "hi": 2600},
            "maximum_trekken_massa_geremd": {"lo": 0, "hi": 1500},
            "inrichting": {"expected_body": ["sedan"], "min_share": 0.02},
            "massa_rijklaar": {"lo": 1500, "hi": 2200},
        },
    },
    {
        # Genuine MPV — RDW splits it roughly evenly between 'stationwagen' and 'MPV';
        # 'MPV' still clears the min_share bar so this is a legitimate-diversity case,
        # not a mis-code.
        "key": "citroen-c4-picasso", "merk": "CITROEN", "hb": ["C4 PICASSO"],
        "date_van": "20070101", "date_tot": "20180101",
        "fields": {
            "massa_ledig_voertuig": {"lo": 1250, "hi": 1900},
            "technische_max_massa_voertuig": {"lo": 1700, "hi": 2500},
            "maximum_trekken_massa_geremd": {"lo": 0, "hi": 1800},
            "inrichting": {"expected_body": ["MPV"], "min_share": 0.02},
            "massa_rijklaar": {"lo": 1250, "hi": 2000},
        },
    },
    {
        # Import-heavy US pony car (long history of private/parallel import into NL).
        # NB the `hb` list deliberately spells out trim-qualified handelsbenaming values
        # (GT / EcoBoost / V6 / Convert / Coupe / "FORD MUSTANG") rather than a bare
        # "MUSTANG" substring — a bare match also catches "MUSTANG MACH-E" (an unrelated
        # EV crossover) and swamps the true pony-car population 63/37, which falsely
        # reads as RDW body mis-coding. With the EV excluded, RDW correctly codes this
        # cohort coupe/cabriolet at ~98% — a sample-construction lesson for the ingest
        # pipeline, not an RDW field defect. See the report's operational-caveats section.
        "key": "ford-mustang", "merk": "FORD",
        "hb": ["MUSTANG GT", "MUSTANG ECOBOOST", "MUSTANG V6", "MUSTANG CONVERT",
               "MUSTANG COUPE", "FORD MUSTANG"],
        "date_van": "20100101", "date_tot": "20240101",
        "fields": {
            "massa_ledig_voertuig": {"lo": 1250, "hi": 2000},
            "technische_max_massa_voertuig": {"lo": 1800, "hi": 2400},
            "maximum_trekken_massa_geremd": {"lo": 0, "hi": 1600},
            "inrichting": {"expected_body": ["coupe"], "min_share": 0.02},
            "massa_rijklaar": {"lo": 1300, "hi": 2100},
        },
    },
    {
        # High-volume NL hatchback — RDW codes this correctly at ~100%.
        "key": "vw-polo", "merk": "VOLKSWAGEN", "hb": ["POLO"],
        "date_van": "20090101", "date_tot": "20240101",
        "fields": {
            "massa_ledig_voertuig": {"lo": 700, "hi": 1600},
            "technische_max_massa_voertuig": {"lo": 1000, "hi": 2200},
            "maximum_trekken_massa_geremd": {"lo": 0, "hi": 1500},
            "inrichting": {"expected_body": ["hatchback"], "min_share": 0.02},
            "massa_rijklaar": {"lo": 700, "hi": 1700},
        },
    },
    {
        # High-volume NL hatchback, gen-E window — RDW is mostly correct here (~81%
        # hatchback), a brand/model-specific contrast to the Yaris/Picanto mis-codes.
        "key": "opel-corsa-e", "merk": "OPEL", "hb": ["CORSA"],
        "date_van": "20140101", "date_tot": "20240101",
        "fields": {
            "massa_ledig_voertuig": {"lo": 700, "hi": 1600},
            "technische_max_massa_voertuig": {"lo": 1000, "hi": 2200},
            "maximum_trekken_massa_geremd": {"lo": 0, "hi": 1500},
            "inrichting": {"expected_body": ["hatchback"], "min_share": 0.02},
            "massa_rijklaar": {"lo": 700, "hi": 1700},
        },
    },
    {
        # High-volume NL hatchback — Clio also sells as an estate (stationwagen) under
        # the same handelsbenaming, so a <80% hatchback agreement here is legitimate
        # body diversity, not mis-coding (hatchback still clears the presence bar).
        "key": "renault-clio", "merk": "RENAULT", "hb": ["CLIO"],
        "date_van": "20090101", "date_tot": "20240101",
        "fields": {
            "massa_ledig_voertuig": {"lo": 700, "hi": 1600},
            "technische_max_massa_voertuig": {"lo": 1000, "hi": 2200},
            "maximum_trekken_massa_geremd": {"lo": 0, "hi": 1500},
            "inrichting": {"expected_body": ["hatchback"], "min_share": 0.02},
            "massa_rijklaar": {"lo": 700, "hi": 1700},
        },
    },
    {
        # High-volume NL hatchback, pre-Yaris-Cross window — RDW codes ~99% of this
        # pure-hatchback generation as 'MPV'. Systematic mis-code, not brand-specific
        # (mirrors the Golf/Picanto pattern).
        "key": "toyota-yaris", "merk": "TOYOTA", "hb": ["YARIS"],
        "date_van": "20090101", "date_tot": "20200101",
        "fields": {
            "massa_ledig_voertuig": {"lo": 700, "hi": 1600},
            "technische_max_massa_voertuig": {"lo": 1000, "hi": 2200},
            "maximum_trekken_massa_geremd": {"lo": 0, "hi": 1500},
            "inrichting": {"expected_body": ["hatchback"], "min_share": 0.02},
            "massa_rijklaar": {"lo": 700, "hi": 1700},
        },
    },
    {
        # High-volume NL city car — RDW codes ~99% of this hatchback as 'MPV', same
        # systematic pattern as the Yaris.
        "key": "kia-picanto", "merk": "KIA", "hb": ["PICANTO"],
        "date_van": "20090101", "date_tot": "20240101",
        "fields": {
            "massa_ledig_voertuig": {"lo": 700, "hi": 1600},
            "technische_max_massa_voertuig": {"lo": 1000, "hi": 2200},
            "maximum_trekken_massa_geremd": {"lo": 0, "hi": 1500},
            "inrichting": {"expected_body": ["hatchback"], "min_share": 0.02},
            "massa_rijklaar": {"lo": 700, "hi": 1700},
        },
    },
    {
        # High-volume NL hatchback — RDW codes this correctly at ~100%.
        "key": "ford-fiesta", "merk": "FORD", "hb": ["FIESTA"],
        "date_van": "20090101", "date_tot": "20240101",
        "fields": {
            "massa_ledig_voertuig": {"lo": 700, "hi": 1600},
            "technische_max_massa_voertuig": {"lo": 1000, "hi": 2200},
            "maximum_trekken_massa_geremd": {"lo": 0, "hi": 1500},
            "inrichting": {"expected_body": ["hatchback"], "min_share": 0.02},
            "massa_rijklaar": {"lo": 700, "hi": 1700},
        },
    },
]
