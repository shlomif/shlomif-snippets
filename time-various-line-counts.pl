#!/usr/bin/perl

use strict;
use warnings;

use Benchmark ':hireswallclock';

sub wc_count
{
    my $s = `wc -l mega.xml`;
    $s =~ /^(\d+)/;
    return $1;
}

sub lo_count
{
    open my $in, "<", "mega.xml";
    local $.;
    while (<$in>)
    {
    }
    my $ret = $.;
    close($in);
    return $ret;
}

if ( lo_count() != wc_count() )
{
    die "Error";
}

timethese(
    100,
    {
        'wc' => \&wc_count,
        'lo' => \&lo_count,
    }
);
