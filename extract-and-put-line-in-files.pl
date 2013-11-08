#!/usr/bin/perl

use strict;
use warnings;

use File::Slurp;

use List::MoreUtils qw(firstidx);

my ($extract_string, $put_string, $filenames_file) = @ARGV;

my $filenames_list = read_file($filenames_file, {chomp => 1, array_ref => 1});

foreach my $filename (@$filenames_list)
{
    my $lines = read_file($filename, {array_ref => 1});

    my $idx = firstidx { index($_, $extract_string) >= 0 } @$lines;

    if ($idx < 0)
    {
        die "Cannot find '$extract_string' anywhere in $filename.";
    }

    my ($extracted_line) = splice(@$lines, $idx, 1);

    my $put_idx = firstidx { index($_, $put_string) >= 0 } @$lines;

    if ($put_idx < 0)
    {
        die "Cannot find '$put_string' anywhere in $filename.";
    }

    splice(@$lines, $put_idx+1, 0, $extracted_line);

    write_file($filename, @$lines);
}
