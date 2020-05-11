#!/usr/bin/env python3.7

def square(num):
    return num * num

square_lamba = lambda num: num * num

print(square(4))

print(square_lamba(4))

# assert square(4) == square_lamba(4)