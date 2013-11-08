#!/usr/bin/perl

use strict;
use warnings;

use List::MoreUtils qw(none);

my @filenames = map { shift(@ARGV) } (0 .. 1);

if (@ARGV)
{
    die "Excess elements after arg1 arg2";
}

my @handles;
foreach my $filename (@filenames)
{
    open my $fh, "<", $filename
        or die "Could not open file '$filename' for reading";

    push @handles, $fh;
}

while (none { eof($_) } @handles)
{
    my @lines = map { scalar(<$_>) } @handles;
    chomp(@lines);

    print join("\t", @lines), "\n";
}

foreach my $fh (@handles)
{
    close($fh);
}
