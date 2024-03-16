#!/usr/bin/perl

use strict;
use warnings;

use Math::BigInt ":constant", lib => 'GMP';

sub is_32bit_signed
{
    my $i = shift;

    return ( ( $i <= ( ( 1 << 31 ) - 1 ) ) and ( -( 1 << 31 ) <= $i ) );
}

sub is_32bit_unsigned
{
    my $i = shift;

    return ( ( $i <= ( ( 1 << 32 ) - 1 ) ) and ( 0 <= $i ) );
}

my $i = shift(@ARGV);

print is_32bit_signed($i) ? "Signed 32-bit\n" : "Not 32-bit.\n";
