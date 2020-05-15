#!/usr/bin/env python3.7


# Defined `random_words` and `random_word` but we're only importing one directly
from words.generator import random_word

# *Only* provides `random_words` when the package is imported directly
from words import *


print(f"Random word generated: {random_word()}")
print(f"Random list of words: {random_words(5)}")
