#!/usr/bin/perl

use strict;
use warnings;

print_filename();

my $filename = "hello.txt";

sub print_filename
{
    print $filename, "\n";
}
