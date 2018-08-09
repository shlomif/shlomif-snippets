#!/usr/bin/perl

use strict;
use warnings;

use PPI;
use Data::Dumper;

my $Document = PPI::Document->new("lib/Test/Run/Core.pm");

my $start_line = 966;
my $elem = $Document->find_first(
    sub {
        my ($self, $elem) = @_;

        if (!defined($elem->location()))
        {
            return 0;
        }
        print join(",", @{$elem->location()}), "\n";
        return ($elem->location()->[0] == $start_line);
    }
);

my $method_name = "_report_start_single_method_run";

1;
