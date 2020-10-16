#! /usr/bin/env perl
#
# Short description for perl-ternary-as-an-lvalue.pl
#
# Version 0.0.1
# Copyright (C) 2020 Shlomi Fish < https://www.shlomifish.org/ >
#
# Licensed under the terms of the MIT license.

use strict;
use warnings;
use 5.014;
use autodie;

use Path::Tiny qw/ path tempdir tempfile cwd /;

my $x = 1;
my $y = 1;

my $cond = shift @ARGV;

( $cond ? $x : $y ) = 240;

say "x = < $x > y = < $y >";
