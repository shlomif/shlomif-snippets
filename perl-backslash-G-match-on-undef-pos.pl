#! /usr/bin/env perl
#
# Short description for perl-g-match.pl
#
# Version 0.0.1
# Copyright (C) 2025 Shlomi Fish < https://www.shlomifish.org/ >
#
# Licensed under the terms of the MIT license.

use strict;
use warnings;
use 5.014;
use autodie;

use Carp         qw/ confess /;
use Getopt::Long qw/ GetOptions /;
use Path::Tiny   qw/ cwd path tempdir tempfile /;

sub run
{
    my $string = "hello";

    if ( not defined pos($string) )
    {
        say "pos() is undefined";
    }

    if ( $string =~ /\Gh/g )
    {
        say "\\G matched";
    }
}

run();

__END__
