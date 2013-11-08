#!/usr/bin/perl

use strict;
use warnings;

sub my_reverse
{
    my ($s) = @_;

    my $ret = "";

    my @chars = ($s =~ /(.)/gms);

    foreach my $c (@chars)
    {
        $ret = $c . $ret;
    }

    return $ret;
}

my ($string) = @ARGV;

print "Reversed is:\n", my_reverse($string), "\n";
