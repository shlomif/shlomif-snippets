#! /usr/bin/env perl
#
# Short description for test-YAML-XS.pl
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

use YAML::XS qw/ LoadFile /;

sub myls
{
    my ($stage) = @_;
    print "$stage\n";
    system("set -x; ls -lA");
    return;
}

sub run
{
    myls("before");

    eval { LoadFile(">clobber.yaml"); };
    myls("after");
    exit(0);

    my $output_fn;

    GetOptions( "output|o=s" => \$output_fn, )
        or die "errror in cmdline args: $!";

    exit(0);
}

run();

1;

__END__

=encoding UTF-8

=head1 NAME

=head1 VERSION

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2007 by Shlomi Fish.

This is free software, licensed under:

  The MIT (X11) License

=cut
