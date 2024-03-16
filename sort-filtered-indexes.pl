#!/usr/bin/perl

use strict;
use warnings;

my @array = qw(c r v vr tr re c.p[1] c.p[3] c.p[2] c.p[4] c.p[7]
    c.p[6] c.p[5] c.p[8] c.t[1] c.t[3] c.t[2]);

my @relevant_indexes = grep { $array[$_] =~ m{\[\d+\]} } ( 0 .. $#array );
my @sorted_indexes   = sort { $array[$a] cmp $array[$b] } @relevant_indexes;

@array[@relevant_indexes] = @array[@sorted_indexes];

print map { "$_\n" } @array;

