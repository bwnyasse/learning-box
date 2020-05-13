#!/usr/bin/env python3.7

from helpers.strings import extract_lower
from helpers import variables
from helpers import *
import helpers

print(f"Lowercase Letters: {extract_lower(variables.name)}")
print(f"Uppercase Letters: {extract_upper(variables.name)}")
print(f"from helpers: {helpers.strings.extract_lower(variables.name)}")