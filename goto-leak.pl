#!/usr/bin/perl

use strict;
use warnings;

sub naturals
{
    my ($n) = @_;
    sub {
        if ( $n > 0 )
        {
            [ $n, naturals( $n - 1 ) ]
        }
        else
        {
            undef;
        }
    }
}

sub stream_sum
{
    my ( $s, $tot ) = @_;
    if ( my $fs = &$s )
    {
        @_ = ( $$fs[1], $$fs[0] + $tot );
        goto \&stream_sum;
    }
    else
    {
        $tot;
    }
}

my $ns = naturals 200000;
<STDIN>;
my $res = stream_sum( $ns, 0 );
<STDIN>;
