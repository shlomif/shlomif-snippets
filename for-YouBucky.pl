#!/bin/perl

use strict;
use warnings;

my $network_range = shift;

if (!defined($network_range))
{
    die "Please enter the network you wish to scan eg: 10.0.10\n";
}

for my $ip (1 .. 254)
{
    open my $ping, "ping -c 1 $network_range.$ip|"
        or die "Could not ping";

    while(my $line = <$ping>)
    {
        if ($line =~ /bytes from/)
        {
            if ($line =~ m{((?:\d+\.){3}\d+)})
            {
                print $1, "\n";
            }
        }
    }
    close($ping)
}
