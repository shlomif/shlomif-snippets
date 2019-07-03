#!/usr/bin/env python

"""
Bidirectional Fibonacci Numbers Iterator:

https://en.wikipedia.org/wiki/Fibonacci_number .

=head1 COPYRIGHT & LICENSE

Copyright 2018 by Shlomi Fish

This program is distributed under the MIT / Expat License:
L<http://www.opensource.org/licenses/mit-license.php>

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

=cut
"""

from six import print_


class FibBidi(object):
    """docstring for FibBidi"""
    def __init__(self):
        self.state = [0, 1]
        self.n = 0

    def increment(self):
        """docstring for increment"""
        self.n += 1
        self.state = [self.state[1], self.state[0]+self.state[1], ]

    def decrement(self):
        """docstring for decrement"""
        self.n -= 1
        self.state = [self.state[1]-self.state[0], self.state[0]]

    def get(self):
        """get F[n]"""
        return self.state[0]

    def idx(self):
        """get the current index"""
        return self.n

    def clone(self):
        """docstring for clone"""
        ret = FibBidi()
        ret.n = self.n
        ret.state = self.state + []
        return ret


def main():
    """the main function"""
    fib = FibBidi()
    fib.increment()
    fib.increment()
    fib.increment()
    assert fib.idx() == 3
    assert fib.get() == 2
    fib.increment()
    newfib = fib.clone()
    newfib.increment()
    newfib.decrement()
    assert fib.get() == newfib.get()
    assert fib.idx() == newfib.idx()

    fib = FibBidi()
    while True:
        print_("{}: {}".format(fib.idx(), fib.get()))
        fib.decrement()


main()
