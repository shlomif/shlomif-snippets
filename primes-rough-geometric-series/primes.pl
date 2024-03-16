#!/usr/bin/perl

use strict;
use warnings;

# use autodie;

use Math::BigInt lib => 'GMP', ':constant';

STDOUT->autoflush(1);

my $start_int = 256;
my $end_int   = 0x80000000;

sub next_number
{
    my $this = shift;

    return ( $this * 9 / 8 );
}

my $i = $start_int;

while ( $i < $end_int )
{
    open my $p_fh, "-|", "primes", "$i"
        or die "Cannot open primes - $!";
    print scalar <$p_fh>;
    close($p_fh);
}
continue
{
    $i = next_number($i);
}

