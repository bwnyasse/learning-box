#!/usr/bin/env python3.7

name = input("what is your name ? ")

if len(name) >= 6:
    print("Your name is long")
elif len(name) == 5:
    print("Your name is 5 char")
elif len(name) >= 4:
    print("Your name is 4 or more char")
else:
    print("your name is short")
