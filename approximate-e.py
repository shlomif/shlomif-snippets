#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2018 shlomif <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.

"""
approximate e
"""


def main():
    n = 0
    sum_ = 0.0
    term = 1.0
    sum_ += term
    while True:
        n += 1
        term /= n
        sum_ += term
        print("%.70f" % sum_)


main()
