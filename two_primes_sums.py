#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2020 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.

import primesieve

import sum_walker.iterator_wrapper


def primes():
    it = primesieve.Iterator()
    it.skipto(2)
    while True:
        yield it.next_prime()


pairs = sum_walker.iterator_wrapper.Walker(counts=[2], iterator=primes())
last = 0
while True:
    result_sum, combis = next(pairs)
    if len(combis) > last:
        last = len(combis)
        print(
            result_sum, ' = @', last, flush=True)
        # [[x[0].value, '+', x[1].value] for x in combis])
