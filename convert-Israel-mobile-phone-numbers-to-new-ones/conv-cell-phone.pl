#!/usr/bin/perl -w

use strict;

use ShlomifConvCell;

foreach my $number (@ARGV)
{
    printf( "\n\n%s ==> %s\n\n", $number, my_conv($number));
}

