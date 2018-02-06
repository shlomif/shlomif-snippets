# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php

from six import print_

x = [1.0, 2.0]

while True:
    x.append((x[-1] + x[-2]) / 2)

    def decompose(sum_, term, exp):
        if sum_ == 0:
            return
        if sum_ >= term:
            print_("+ 2^%d" % exp, end='')
            sum_ -= term
        return decompose(sum_, term/2, exp-1)
    print_("x[%d] = " % len(x), end='')
    decompose(x[-1], 2.0, 1)
    print_("")
