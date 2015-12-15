#!/usr/bin/perl

use strict;
use warnings;

use Time::HiRes qw(sleep);

use Net::Telnet;

my $t = Net::Telnet->new(Timeout => 10);

my $PASSWORD = $ENV{PASSWORD};

$t->open(Host => 'localhost', Port => 4212);

$t->waitfor('/Password:/');
$t->print("$PASSWORD\n");

while (1)
{
    $t->cmd("next\n");

    sleep(2);
}
