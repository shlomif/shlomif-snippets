#!/usr/bin/perl

use strict;
use warnings;

sub my_reverse
{
    my ($s) = @_;

    my $ret = "";

    for my $idx ( 0 .. length($s) - 1 )
    {
        $ret = substr( $s, $idx, 1 ) . $ret;
    }

    return $ret;
}

my $string = shift(@ARGV);

print "Reversed is:\n", my_reverse($string), "\n";
