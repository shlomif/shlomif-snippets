#!/usr/bin/perl

use strict;
use warnings;

my $formula1 = shift(@ARGV);
my $formula2 = shift(@ARGV);

my @formulas = ($formula1, $formula2);

for my $base (2 .. 101)
{
    my @results;
    for my $formula_idx (0 .. 1)
    {
        my %found;
        for my $start_mod (0 .. $base-1)
        {
            local $_ = $start_mod;
            my $r = eval ($formulas[$formula_idx].'');
            push @{$found{$r % $base}}, $start_mod;
        }
        push @results, \%found;
    }
    print "Base $base ", join(";", map { my $x = $_;
            "[". join(",", map { $_ . " {" . join("|", @{$x->{$_}})  . "} " }sort { $a <=> $b } keys($_)) . "]" } @results), "\n";
}
