"""The ~12-15 representative vehicle cross-section for the RDW data-quality audit.
Brands x segments x fuels x bodies + an import-heavy model + the cars we hold CoCs for.
`coc` values are gold ground-truth from held CoCs; `expected_body` lists body types the
model is KNOWN to offer (the external reality anchor); `cross_ranges` are trusted external
min/max (kentekenfeiten cohorts) for the cross-source signal. Extend as CoCs arrive."""

SAMPLE = [
    {
        "key": "kia-rio-yb", "merk": "KIA", "hb": ["RIO"],
        "date_van": "20110101", "date_tot": "20180101",
        "fields": {
            "massa_rijklaar": {"lo": 700, "hi": 2000, "coc": 1160, "coc_tvv": ("B5P11", "M61BZ1")},
            "maximum_trekken_massa_geremd": {"lo": 0, "hi": 2500},
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
    # TODO(sample): add ~10 more — a diesel, an EV, an MPV, a pickup/import-heavy model,
    # and the remaining CoC cars (Tucson, Sportage, i20, CX-5, Auris, Pulsar). Each entry
    # is data, not logic; adding one requires no code change.
]
