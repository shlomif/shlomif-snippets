#!/usr/bin/perl

use strict;
use warnings;

use Math::BigInt try => 'GMP';

sub fib_iter
{
    my ($n) = @_;

    my $this_fib = Math::BigInt->new(0);
    my $next_fib = Math::BigInt->new(1);

    my $pos = 0;

    while ($pos < $n)
    {
        ($this_fib, $next_fib) = ($next_fib, $this_fib+$next_fib);
    }
    continue
    {
        $pos++;
    }

    return $this_fib;
}

print +(fib_iter(shift(@ARGV)) . q##), "\n";
