#!/usr/bin/perl

use strict;
use warnings;

use Benchmark qw(:all);

timethese(300,
    +{
        'push' =>
            sub {
                my @array;
                for my $x (1 .. 100_000)
                {
                    push @array, $x;
                }
                return [reverse(@array)];
            },
        'unshift' =>
            sub {
                my @array;
                for my $x (1 .. 100_000)
                {
                    unshift @array, $x;
                }
                return \@array;
            },
    },
);

