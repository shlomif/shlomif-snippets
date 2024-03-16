#!/usr/bin/perl

use strict;
use warnings;
use autodie;

my @a;
open my $in_fh, '<', 'prime_list.txt';
while ( my $l = <$in_fh> )
{
    if ( $l =~ /\d/ )
    {
        chomp($l);
        push @a, $l;
    }
}
close($in_fh);

push @a, "-1";

print "primes[" . scalar(@a) . "] = {\n";
print join( ",\n", ( map { "    " . $_; } @a ) );
print "\n};\n";
