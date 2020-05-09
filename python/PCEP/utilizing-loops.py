#!/usr/bin/env python3.7

request = int(input("How many values should we process: "))

for value in range(1, request + 1):
    if value % 3 == 0 and value % 5 == 0 :
        print("FizzBuzz")
    elif value % 3 == 0:
        print("Fizz")
    elif value % 5 == 0:
        print("Buzz") 
    else:
        print(value)

