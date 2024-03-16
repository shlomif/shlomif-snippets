#!/usr/bin/perl

use strict;
use warnings;

use File::Find::Object;

sub find_needle
{
    my $base = shift;

    my $finder = File::Find::Object->new( {}, $base );

    while ( defined( my $r = $finder->next() ) )
    {
        if ( $r =~ /target/ )
        {
            return $r;
        }
    }

    return;
}

my $found = find_needle( shift(@ARGV) );

if ( defined($found) )
{
    print "$found\n";
}
else
{
    die "Could not find target.";
}
