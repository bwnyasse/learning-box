#!/usr/bin/env python3.7

name = input("What is your first name? ")

# 1) Call `print` with a different string using a single conditional expression
print(
    "Your name is as long or longer than the average first name in the United States"
) if len(name) >= 6 else print(
    "Your name is shorter than the average first name in the United States"
)

# 2) Set `message` using a single conditional expression
message = (
    "The first letter in your name is among the five most common" 
    if name[0].lower() in ["a", "j", "m", "e", "l"] 
    else "The first letter of your name is not among the five most common")
print(message)

# 3) Change the string passed to the `print` function using a conditional expression
for letter in name:
    print(f"{letter} {'is a vowel' if letter.lower() in ['a', 'e', 'i', 'o', 'u'] else 'is a consonant'}")
