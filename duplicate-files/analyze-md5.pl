#!/usr/bin/perl

use strict;
use warnings;

my $prev = "Z";
my @fns = ();

sub duplicates
{
    if (@fns >= 2)
    {
        print (map { "$_\n" } @fns);
        print "\n";
    }
    @fns = ();
}

while (<>)
{
    chomp;
    /^([0-9a-fA-F]+)\s+(\.\/.+)$/;
    my ($checksum, $filename) = ($1, $2);
    if ($checksum eq $prev)
    {        
    }
    else
    {
        duplicates();
    }

    $prev = $checksum;
    push @fns, $filename;
}

duplicates();

