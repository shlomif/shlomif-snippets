#!/usr/bin/perl

use strict;
use warnings;

our $shucks = 0;

sub catch_zap
{
    my $signame = shift;

    ++$shucks;

    die "Somebody sent me a SIG$signame";
}

$SIG{INT} = \&catch_zap;    # best strategy

while (1)
{
    eval { sleep(1); };

    if ($@)
    {
        print "Recovering $shucks\n";
    }

}
