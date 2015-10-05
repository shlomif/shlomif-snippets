#!/usr/bin/perl

use strict;
use warnings;

use vars qw($y $z);

sub x
{
    local $y = shift;

    local $z = 10;

    $y->();
}

x( sub { print "z=$z\n"; } );
