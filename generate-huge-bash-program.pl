#!/usr/bin/perl

use strict;
use warnings;

use feature qw/say/;

say "#!/bin/bash";
for my $n (1 .. 100_000_000)
{
    say qq{echo "Hello $n"};
}
