#!/usr/bin/perl

use strict;
use warnings;

use Math::BigRat;

my @input = split(/[,\s]+/, shift(@ARGV));

my $n = Math::BigRat->new(shift(@ARGV));

sub power_of_2
{
    my $in = shift;

    my $n = Math::BigRat->new($in->bstr());

    my $e = 0;
    while ($n % 2 == 0)
    {
        $e++;
        $n /= 2;
    }
    if ($n == 1)
    {
        return $e;
    }
    else
    {
        return;
    }
}

my $found = 1;
while ($found)
{
    my $e = power_of_2($n);
    print $n->bstr(), (defined($e) ? " [$e]" : ""), "\n";
    $found = 0;
    SEQ_ITER:
    foreach my $f (@input)
    {
        if (($n * $f)->is_int())
        {
            $n *= $f;
            $found = 1;
            last SEQ_ITER;
        }
    }
}
