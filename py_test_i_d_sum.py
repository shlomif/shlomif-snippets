#! /usr/bin/env python3
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2020 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.

"""

"""


def check(d, n):
    sumleft = 0
    for i in range(1, d):
        sumleft += (i*d**(n-1)-i**n)
    sumright = 0
    for i in range(1, d+1):
        sumright += i*(i**n-(i-1)**n-d**(n-1))
    if sumleft != sumright:
        print(d, n, sumleft, sumright)
        assert 0


s = 2
while True:
    print('Reached', s)
    for d in range(2, s-1):
        check(d, s-d)
    s += 1
