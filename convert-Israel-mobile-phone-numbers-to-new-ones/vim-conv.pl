#!/usr/bin/perl -w

use strict;

use lib '/home/shlomi/progs/perl/conv_cell';

use ShlomifConvCell;

my $number = join("", <STDIN>);

print my_conv(local_to_international($number));

