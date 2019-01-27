#!/usr/bin/env python

# The Expat License
#
# Copyright (c) 2017, Shlomi Fish
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


import heapq
import math
import sys

from six import print_


class MyIter2:
    def __init__(self, e, n, m=0):
        self.e = e
        self.n = n
        self.m = m
        self.s = n ** e + m ** e
        self.max = 2 * n ** e

    def skip(self, tgt):
        # Not working
        if tgt > self.max:
            return False
        if tgt == self.s:
            return True
        m = math.floor(math.sqrt(tgt-self.init_s))
        self.m = m
        self.s = self.init_s + ((m*(m+1)))
        if self.s < tgt:
            self.m += 1
            self.s += (m + 1) << 1
        return True

    def adv(self):
        if self.m == self.n:
            return False
        self.m += 1
        e = self.e
        self.s = self.n ** e + self.m ** e
        return True

    def n_inc(self):
        self.n += 1
        e = self.e
        self.s = self.n ** e + self.m ** e
        self.init_s = self.s
        self.max = 2 * self.n ** e

    def clone(self):
        return MyIter2(self.e, self.n, self.m)


class IterSumTwo:
    def i(self):
        it = self.it
        return (it.s, it.n, it.clone())

    def __init__(self, e):
        self.q = []
        self.n = 0
        self.e = e
        self.it = MyIter2(e, 0, 0)
        heapq.heappush(self.q, self.i())

    def next(self):
        s, n, i = heapq.heappop(self.q)
        if n == self.n:
            self.n += 1
            self.it.n_inc()
            heapq.heappush(self.q, self.i())
        m = i.m
        if i.adv():
            heapq.heappush(self.q, (i.s, n, i))
        return s, n, m

    def skip(self, tgt):
        new = []
        maxn = 0
        for x in self.q:
            s, n, i = x
            if i.skip(tgt):
                new.append((i.s, n, i))
                if maxn < n:
                    maxn = n
        while self.it.max < tgt:
            self.it.n_inc()
        while self.it.s <= tgt:
            if maxn != self.it.n:
                s, n, i = self.i()
                i.skip(tgt)
                new.append((i.s, n, i))
            self.it.n_inc()
        # print_(cnt)
        heapq.heapify(new)
        self.q = new


def test_func(e):
    it = IterSumTwo(e)
    c = 0
    prevs = []
    prevs.append(it.next())
    while True:
        c += 1
        n = it.next()
        if n[0] == prevs[0][0]:
            prevs.append(n)
        else:
            if len(prevs) >= 2:
                print_(len(prevs), prevs[0][0],
                       [(x, y) for z, x, y in prevs])
                sys.stdout.flush()
            prevs = [n]


test_func(3)
