#!/usr/bin/perl

use strict;
use warnings;

use YAML::Any qw(LoadFile);

my ($ds) = LoadFile("hello.yml");

print "String == '", $ds->{string}, "'\n";
