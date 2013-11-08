#!/usr/bin/perl

use strict;
use warnings;

use CPANPLUS::Backend;
my  $cb = CPANPLUS::Backend->new();


open my $in, "<", "current-mojomojo.txt";
while (my $line = <$in>)
{
    chomp($line);
    my ($mod, $ver) = split(/\t/, $line);

    my $mod_obj = $cb->parse_module(module => $mod);
    if ( $mod_obj->version() ne $ver )
    {
        print "${mod} : Version " . $mod_obj->version() . " is available. You have $ver\n";
    }
}
close($in);
