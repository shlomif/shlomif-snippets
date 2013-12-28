#!/usr/bin/perl

use strict;
use warnings;

use Test::Differences qw( eq_or_diff );
use Test::More tests => 4;

sub cross_product
{
    my ($sets) = @_;

    if (! @$sets)
    {
        return [ [] ];
    }
    else
    {
        my $first_set = $sets->[0];
        my $cross = cross_product([ @$sets[1 .. $#$sets] ]);

        print "foo\n";

        return [
            map { my $item = $_; map { [$item, @$_] } @$cross } @$first_set
        ];
    }
}

# TEST
eq_or_diff (
    cross_product([ [1,2], [3,4] ]),
    [ [1,3,],[1,4],[2,3],[2,4], ],
    "Basic Test",
);

# TEST
eq_or_diff (
    cross_product([ [1,2,3,4,], ]),
    [ [1,],[2,],[3,],[4,], ],
    "Single set.",
);

# TEST
eq_or_diff (
    cross_product([ [1,], [qw(foo bar baz)] ]),
    [ [1, "foo",],[1, "bar"],[1, "baz"], ],
    "Single element set.",
);

# TEST
eq_or_diff (
    cross_product([ [1,2,], [3,4,], [5,6], ]),
    [[1,3,5],[1,3,6],[1,4,5],[1,4,6],[2,3,5],[2,3,6],[2,4,5],[2,4,6]],
    "Three sets",
);
