#!/usr/bin/perl

use strict;
use warnings;

my $init_time = time();

while(1)
{
    sleep(5);
    print +(time()-$init_time), "\n";
}

