#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use List::MoreUtils qw(any);

my $N = shift(@ARGV) || 8;

sub recurse
{
    my ( $y, $state, $row_counts ) = @_;

    if ( $y == $N )
    {
        print '-' x ( $N + 2 ), "\n";
        print map {
            my $yy = $_;
            (
                "|",
                (
                    map {
                        my $x = $_;
                        substr( $state, $yy * $N + $x, 1 ) eq chr(1)
                            ? "*"
                            : " "
                    } 0 .. $N - 1
                ),
                "|",
                "\n"
            )
        } ( 0 .. $N - 1 );
        print '-' x ( $N + 2 ), "\n";
        return;
    }

    if ( any { $_ <= 0 } @$row_counts[ $y .. $N - 1 ] )
    {
        return;
    }

    for my $x ( 0 .. $N - 1 )
    {
        if ( !ord( substr( $state, $y * $N + $x, 1 ) ) )
        {
            my $new_state = $state;
            substr( $new_state, $y * $N + $x, 1 ) = chr(1);
            my @new_rows = @$row_counts;
            for my $step ( [ 0, 1 ], [ -1, 1 ], [ 1, 1 ] )
            {
                my @c = ( $x, $y );
                $c[0] += $step->[0];
                $c[1] += $step->[1];

                while ( $c[0] >= 0 && $c[0] < $N && $c[1] >= 0 && $c[1] < $N )
                {
                    my $off = $c[1] * $N + $c[0];
                    if ( !ord( substr( $new_state, $off, 1 ) ) )
                    {
                        substr( $new_state, $off, 1 ) = 2;
                        --$new_rows[ $c[1] ];
                    }
                }
                continue
                {
                    $c[0] += $step->[0];
                    $c[1] += $step->[1];
                }
            }
            recurse( $y + 1, $new_state, \@new_rows );
        }
    }

    return;
}

recurse( 0, chr(0) x ( $N * $N ), [ ($N) x $N ] );
