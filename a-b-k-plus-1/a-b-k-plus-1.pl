#!/usr/bin/perl -w

use strict;

use Math::GMP;

my $a = Math::GMP->new(shift || 1);
my $b = Math::GMP->new(shift || 2);

my $product = $a*$b;
my $k = 0;
while(1)
{
    my $product_plus_one = $product-1;
    if ($product_plus_one->probab_prime(10))
    {
        print "Found prime at $k\n";
    }
}
continue
{
    $product *= $b;
    $k++;
}
