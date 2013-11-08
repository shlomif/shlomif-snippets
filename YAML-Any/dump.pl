#!/usr/bin/perl

use strict;
use warnings;

use YAML::Any qw(DumpFile);

my $ds =
{
    array => [5,6,100],
    string => "Hello",
};

DumpFile("hello.yml", $ds);
