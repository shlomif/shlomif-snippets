#!/usr/bin/perl

use strict;
use warnings;

use IO::All;
use List::MoreUtils qw(uniq);

my $text = io("all-spammed-domains.txt")->slurp();

my @links = $text =~ m{((?:\[http://[^\]]+\])|(?:http://\S+))}gms;

# print map { "$_\n" } @links;

my @domains = map { m{\A\[?http://([^/]+)(?:/|\s|\z)} || die "Cannot match for $_"; $1 } @links;

print map { "$_\n" } uniq (sort { $a cmp $b } @domains);
