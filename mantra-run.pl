#! /usr/bin/env perl
#
# Short description for mantra-run.pl
#
# Version 0.0.1
# Copyright (C) 2024 Shlomi Fish < https://www.shlomifish.org/ >
#
# Licensed under the terms of the MIT license.

use strict;
use warnings;
use 5.014;
use autodie;

use Carp                                   qw/ confess /;
use Getopt::Long                           qw/ GetOptions /;
use Path::Tiny                             qw/ cwd path tempdir tempfile /;
use Docker::CLI::Wrapper::Container v0.0.4 ();

use lib ".";
use GenerateMantra ();

sub run
{
    my $output_fn;

    my $obj = Docker::CLI::Wrapper::Container->new(
        { container => "rinutils--deb--test-build", sys => "debian:sid", } );

    my @lines = (
        [ "Die, fucker, die!", ],
        [ "Yeah, Zine!", ],
        [ "Hallelujah!", ],
        [ "Now, fuck off!", "Fuck off, now!", ]
    );

    my $gen = GenerateMantra->new();
    $gen->{_count} = 10;

    foreach my $item3_perm ( [ 0, ], [ 1, ], )
    {
        my $para =
            [ map { @$_ }
                ( @lines[ 0 .. 2 ], [ @{ $lines[3] }[@$item3_perm] ], ) ];

        my @paras = @{ $gen->repeat( [$para] ) };
        my @text  = map {
            join "",
                map { "$_\n" }
                (@$_)
        } @paras;
        print join( "\n", @text ), "\n--------\n";
    }

    return;

    GetOptions( "output|o=s" => \$output_fn, )
        or die "errror in cmdline args: $!";

    if ( !defined($output_fn) )
    {
        die "Output filename not specified! Use the -o|--output flag!";
    }

   #     $obj->do_system( { cmd => [ "git", "clone", "-b", $BRANCH, $URL, ] } );

    exit(0);
}

run();

1;

__END__

=encoding UTF-8

=head1 NAME

XML::Grammar::Screenplay::App::FromProto

=head1 VERSION

version v0.16.0

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2007 by Shlomi Fish.

This is free software, licensed under:

  The MIT (X11) License

=cut
