#!/usr/bin/perl

use strict;
use warnings;

use IO::All;

foreach my $f (io(".")->all())
{
    print "Going over $f\n";
    my @lines = io($f)->slurp();

    print map { "$f\:$_\n" }
          grep { my $n = $_; $lines[$n] =~ /PUBLIC/ && grep { $lines[$n-$_] =~ /ENTITY/ } (0 .. 2) }
          (0 .. $#lines);
}
