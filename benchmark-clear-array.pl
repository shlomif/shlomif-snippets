#! /usr/bin/env perl
#
# Copyright (c) 2020 Shlomi Fish ( https://www.shlomifish.org/ )
# Author: Shlomi Fish ( https://www.shlomifish.org/ )
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

use strict;
use warnings;
use 5.014;
use autodie;

use Benchmark qw/ :all /;

timethese(
    10_000,
    {
        'at' => sub {
            my @r;
            foreach my $i ( 1 .. 20 )
            {
                @r = ( 1 .. 1000 );
                @r = ();
            }
            return;
        },
        'dollar' => sub {
            my @r;
            foreach my $i ( 1 .. 20 )
            {
                @r  = ( 1 .. 1000 );
                $#r = -1;
            }
            return;
        },
    }
);

=head1 RESULTS

    Benchmark: timing 10000 iterations of at, dollar...
            at:  3 wallclock secs ( 3.40 usr +  0.00 sys =  3.40 CPU) @ 2941.18/s (n=10000)
        dollar:  5 wallclock secs ( 5.07 usr +  0.00 sys =  5.07 CPU) @ 1972.39/s (n=10000)

=cut
