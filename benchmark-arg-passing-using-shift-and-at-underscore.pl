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

package Obj;

sub pass0
{
    my $self = shift;
    my $args = shift;
    ++${ $args->{'sub'} };
    return;
}

sub pass1
{
    ++${ $_[1]->{'sub'} };
    return;
}

package main;

my $foo = 0;
my $obj = bless {}, 'Obj';
timethese(
    30_000_000,
    {
        'pass0' => sub { $obj->pass0( { sub => \$foo, } ); return; },
        'pass1' => sub { $obj->pass1( { sub => \$foo, } ); return; },
    }
);

=head1 RESULTS

    Benchmark: timing 30000000 iterations of pass0, pass1...
        pass0: 19 wallclock secs (18.88 usr +  0.00 sys = 18.88 CPU) @ 1588983.05/s (n=30000000)
        pass1: 16 wallclock secs (14.30 usr +  0.00 sys = 14.30 CPU) @ 2097902.10/s (n=30000000)

=cut

