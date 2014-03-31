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

    my $found = 0;
    foreach my $final_m (sort { $a <=> $b } keys(%{$results[0]}))
    {
        if (exists($results[1]->{$final_m}))
        {
            $found = 1;
        }
    }

    if (!$found)
    {
        die "For base $base , there are no valid solutions for the two formulas.";
    }
}
