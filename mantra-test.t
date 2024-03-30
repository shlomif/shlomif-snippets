#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 2;

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
}
