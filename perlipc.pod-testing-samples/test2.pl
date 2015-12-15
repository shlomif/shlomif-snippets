#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper;

    use Config;

    if (!defined $Config{sig_name})
    {
        die "No sigs?";
    }

    my (%signo, @signame);

    my $index = 0;

    foreach my $name (split(' ', $Config{sig_name})) {
        $signo{$name} = $index;
        $signame[$index] = $name;

        $index++;
    }

print Dumper(\%signo, \@signame);
