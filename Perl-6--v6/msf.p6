#!/usr/bin/pugs

use v6;
use Test;

plan 2;

sub multiply_squaring_factors($n,$m)
{
    return sort { $^a <=> $^b } one(@$n,@$m).values;
}

# TEST
is_deeply(multiply_squaring_factors([2,3,5], [2,7]), [3,5,7], "msf 1");

# TEST
is_deeply(multiply_squaring_factors([2,3,5], [2,3,7]), [5,7], "msf 2");

# TEST
is_deeply(multiply_squaring_factors([2,3,5,13], [2,3]), [5,13], "msf 3");

