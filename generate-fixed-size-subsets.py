#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2018 shlomif <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.

"""

"""


def gen_subsets(max_, count, i):
    if count == 0:
        yield []
    else:
        for n in range(i, max_):
            for s in gen_subsets(max_, count-1, n+1):
                yield [n] + s


for s in gen_subsets(10, 4, 0):
    print(s)
