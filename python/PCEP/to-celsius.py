#!/usr/bin/env python3.7

# Python implementation here
fahrenheit = input("What temperature (in Fahrenheit) would you like converted to Celsius? ")

fahrenheit_as_float = float(fahrenheit)
celsius = (fahrenheit_as_float - 32) * 5 / 9
print(fahrenheit_as_float, "F is", round(celsius,2) , "C")