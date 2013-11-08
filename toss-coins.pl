#!/usr/bin/perl

use strict;
use warnings;

my @sides = (0,0);

my ($seed, $num_coins) = @ARGV;

srand($seed);

for my $idx (1 .. $num_coins)
{
    $sides[int(rand(2))]++;
}

print "You flipped $sides[0] heads and $sides[1] tails.\n";
