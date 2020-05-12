#!/usr/bin/env python3.7

from helpers import *
import extra

print(f"__name__ in main.py: {__name__}")

print(f"Lowercase Letters: {extract_lower(extra.name)}")
print(f"Uppercase Letters: {extract_upper(extra.name)}")