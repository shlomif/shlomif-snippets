#!/usr/bin/perl

use strict;
use warnings;

my $numbers_string = shift(@ARGV);

my @numbers = split(/,/, $numbers_string);

my $max;
my $start;
my $end;

for (my $i=0; $i < @numbers ; ++$i)
{
    if (!defined($max) || ($numbers[$i] >= $max))
    {
        my $init_i = $i;

        while (($i < @numbers) && ($numbers[$i] == $numbers[$init_i]))
        {
            ++$i;
        }
        --$i;

        if (!defined($start) || ($max < $numbers[$i]) || ($end-$start < $i-$init_i))
        {
            ($start, $end) = ($init_i, $i);
            $max = $numbers[$i];
        }
    }
}
print "$start,$end\n";
