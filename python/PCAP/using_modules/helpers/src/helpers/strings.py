

def extract_upper(phrase):
    """
    extract_upper takes a string and return a list containing
    only the uppercase characters from the string.

    >>> extract_upper("Hello There, BOB")
    ['H', 'T', 'B', 'O', 'B']
    """
    return list(filter(str.isupper, phrase))

def extract_lower(phrase):
    return list(filter(str.islower,phrase))

# print(f"__name__ in extra.py: {__name__}")