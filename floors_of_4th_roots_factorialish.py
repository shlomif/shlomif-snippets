#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2020 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.

"""
See:

https://i.imgur.com/24bIBTC.png

PI[floor(root4(2i+1))] / PI[floor(root4(2i+2))]

"""

from math import gcd


def calc(MAX):
    bottom = 1
    top = MAX
    val = None
    while bottom <= top:
        mid = ((top + bottom) >> 1)
        val = mid ** 4
        if val < MAX:
            bottom = mid + 1
        elif val > MAX:
            top = mid - 1
        else:
            break
    if val == MAX:
        limit = mid
    else:
        limit = max(top, bottom)
        val = limit ** 4
        while val > MAX:
            limit -= 1
            val = limit ** 4

    numer = 1
    denom = 1
    for i in range(2, limit+1, 2):
        numer *= i-1
        denom *= i
        if i & (0b1111111111111111) == 0:
            print('reached', i, '/', limit, flush=True)
            # continue
            g = gcd(numer, denom)
            numer //= g
            denom //= g
    g = gcd(numer, denom)
    numer //= g
    denom //= g
    return numer, denom


def print_me(MAX):
    n, d = calc(MAX)
    print("f({}) = {} / {}".format(MAX, n, d))


print_me(2016)
print_me(10**9)
print_me(10**20)
print_me(10**40)
