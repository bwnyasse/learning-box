#!/usr/bin/env python3.7

# 1) Import the built-in `math` module
import math

# 2) Import the `reverse` and `shuffle` from the custom `strhelpers` module (Needs to be created)
from strhelpers import reverse , str_shuffle as shuffle

name = "Kevin Bacon"

assert math.ceil(14.11) == 15, f"Expected 15, but got {math.ceil(14.11)}"
assert (
    reverse(name) == "nocaB niveK"
), f"Expected 'nocaB niveK', but got {reverse(name)}"
assert type(shuffle(name)) == str, f"Expected a string, but got {type(shuffle(name))}"
assert sorted(shuffle(name)) == sorted(
    name
), f"Expected [' ', 'B', 'K', 'a', 'c', 'e', 'i', 'n', 'n', 'o', 'v'], but got {sorted(shuffle(name))}"

