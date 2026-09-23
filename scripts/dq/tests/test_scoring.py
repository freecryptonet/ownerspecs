from scripts.dq.scoring import is_present, fill_rate, modal_agreement


def test_is_present():
    assert is_present("1600") is True
    assert is_present(0) is True          # numeric zero is a value at this layer
    assert is_present(None) is False
    assert is_present("") is False
    assert is_present("   ") is False


def test_fill_rate():
    rows = [{"m": "1"}, {"m": ""}, {"m": "3"}, {"m": None}]
    assert fill_rate(rows, "m") == 0.5
    assert fill_rate([], "m") == 0.0


def test_modal_agreement():
    assert modal_agreement(["a", "a", "a", "b"]) == ("a", 0.75, 4)
    assert modal_agreement([]) == (None, 0.0, 0)
    assert modal_agreement([None, "", "x"]) == ("x", 1.0, 1)
