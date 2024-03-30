#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 1;

use lib ".";
use GenerateMantra ();

{
    my $gen = GenerateMantra->new();

    # TEST
    is_deeply( $gen->permute( [ "zero", "one" ], [0] ), [ "zero", "one" ] );
}
