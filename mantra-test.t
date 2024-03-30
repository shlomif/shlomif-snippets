#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 4;

use lib ".";
use GenerateMantra ();

{
    my $gen = GenerateMantra->new();

    # TEST
    is_deeply( $gen->permute( [ "zero", "one", ], [ 0, ] ),
        [ "zero", "one", ] );

    # TEST
    is_deeply( $gen->permute( [ "zero", "one", ], [ 1, ] ),
        [ "one", "zero", ] );

    # TEST
    is_deeply( $gen->permute( [ "zero", "One", "TWO" ], [ 1, 2, ] ),
        [ "One", "TWO", "zero", ] );

    # TEST
    is_deeply( $gen->permute( [ "zero", "One", "TWO" ], [ 0, 2, ] ),
        [ "zero", "TWO", "One", ] );
}
