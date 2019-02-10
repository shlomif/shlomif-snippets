#!/usr/bin/perl

use strict;
use warnings;

my $prev = "Z";
my @fns;

sub duplicates
{
    if ( @fns >= 2 )
    {
        print( map { "$_\n" } @fns );
        print "\n";
    }
    $#fns = -1;
}

while (<>)
{
    chomp;
    if ( my ( $checksum, $filename ) = /\A([0-9a-fA-F]+)\s+(\S.*)\z/ )
    {
        if ( $checksum ne $prev )
        {
            duplicates();
        }

        $prev = $checksum;
        push @fns, $filename;
    }
}

duplicates();
