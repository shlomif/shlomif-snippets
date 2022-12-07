#!/usr/bin/perl

# Copyright (c) 2022 Shlomi Fish ( https://www.shlomifish.org/ )
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

my $state = "START";

sub read_choice
{
    print "STATE == $state ; Enter your choice:\n";

    my $l = <>;
    chomp($l);
    if ( $l !~ /\A[0-9]\z/ )
    {
        die "Wrong <$l>!";
    }
    return $l;
}

my %handlers = (
    "START" => sub {
        my $choice = read_choice;

        $state = ( $choice == 0 ) ? 0 : "END";

        return;
    },
    0 => sub {
        my $choice = read_choice;

        if ( $choice eq 0 )
        {
            print "Going to START.\n";
            $state = "START";
        }
        else
        {
            print "You entered choice <$choice>.\n";
        }

        return;
    },
    END => sub {
        exit(0);
    },
);

while (1)
{
    $handlers{$state}->();
}
