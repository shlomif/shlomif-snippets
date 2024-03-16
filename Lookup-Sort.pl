#!/usr/bin/perl

use strict;
use warnings;

my @foo = qw/foo bar baz first second third/;

my @positions = qw/first second third/;

my %pos = ( map { $positions[$_] => $_ + 1 } keys(@positions) );

my $max_pos = @positions + 2;

sub _get_pos
{
    my $k = shift;
    return exists( $pos{$k} ) ? $pos{$k} : $max_pos;
}

my @foo_sorted =
    sort {
    my $a_pos = _get_pos($a);
    my $b_pos = _get_pos($b);

    ( $a_pos <=> $b_pos ) or ( $a cmp $b );
    } @foo;

foreach my $i (@foo_sorted)
{
    print "$i\n";
}
