#! /usr/bin/env python3
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2025 Shlomi Fish < https://www.shlomifish.org/ >
#
# Licensed under the terms of the MIT license.

"""

"""

import sys

se = set()


def ff(a, b):
    res = pow(a, b) % pow(b, a)
    return res


def f(s):
    for a in range(1, s):
        b = s - a
        assert b >= 1
        res = ff(a, b)
        se.add(res)
#         print(res)


def g():
    print(ff(2, 1093))
    sys.exit()


s = 2
while True:
    f(s)
    s += 1
    print(sorted(se))
