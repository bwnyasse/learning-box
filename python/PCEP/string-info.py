#!/usr/bin/env python3.7

message = input("Enter a message: ")

print("First character:", message[0])
print("Last character:", message[-1])
print("Middle character:", message[int(len(message) / 2)])
print("Even index characters:", message[0::2])
print("Odd index characters:", message[1::2])
print("Reversed message:",message[::-1])