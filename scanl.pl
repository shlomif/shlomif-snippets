#!/usr/bin/perl

use strict;
use warnings;
use List::Util qw(reduce);

sub scanl {
    my ($op, @list) = @_;
    return reduce {
        return [@$a, $op->($a=$a->[-1], $b)];
    } [$list[0]], @list[1 .. $#list]
}

use Data::Dumper;

print Dumper [scanl sub { $a*$b }, 1..4];
