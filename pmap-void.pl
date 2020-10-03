#! /usr/bin/env perl
#
# Short description for pmap-void.pl
#
# Version 0.0.1

use strict;
use warnings;
use 5.014;
use autodie;

use Parallel::Map qw/ pmap_void /;

pmap_void
{
    # sleep 1;
    warn "${_}\n";
    Future->done;
}
generate => sub { return undef(); }, forks => 5;
