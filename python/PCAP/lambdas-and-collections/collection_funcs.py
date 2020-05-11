#!/usr/bin/env python3.7

from functools import reduce

domain = [1, 2 , 3, 4 , 5]

# map
# example: f(x) = x * 2
our_range = map(lambda num: num * 2, domain)
print(list(our_range))

# filter
evens = filter(lambda num: num % 2 == 0 , domain)
print(list(evens))

# reduce
the_sum = reduce(lambda acc, num: acc + num, domain, 0)
print(the_sum)
