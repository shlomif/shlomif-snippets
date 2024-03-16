#!/usr/bin/perl

use strict;
use warnings;

sub gen_permutations
{
    my $n                  = shift;
    my $m                  = shift;
    my $start_item         = shift || 1;
    my $orig_array         = shift || [ (undef) x $n ];
    my $num_already_picked = shift || 0;

    if ( $num_already_picked == $m )
    {
        return [ [@$orig_array] ];
    }

    my @ret;

    foreach
        my $first_item ( $start_item .. ( $n - ( $m - $num_already_picked ) ) )
    {
        foreach my $pos ( grep { !defined( $orig_array->[$_] ) }
            ( 0 .. $#$orig_array ) )
        {
            my $new_array = [@$orig_array];
            $new_array->[$pos] = $first_item;
            push @ret,
                @{
                gen_permutations(
                    $n,              $m,
                    $first_item + 1, $new_array,
                    $num_already_picked + 1,
                )
                };
        }
    }

    return \@ret;
}

my ( $n_test, $m_test ) = @ARGV;
print join( ",", map { defined($_) ? $_ : "(unfilled)" } @$_ ) . "\n"
    foreach @{ gen_permutations( $n_test, $m_test ) };
