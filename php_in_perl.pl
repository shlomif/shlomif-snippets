#!/usr/bin/perl

# Implement PHP's str_shuffle() and microtime() in Perl 5.
# Written by Shlomi Fish ( http://www.shlomifish.org/ )
#
# Copyright by Shlomi Fish, 2009 and licensed under the MIT/X11 License (
#  http://www.opensource.org/licenses/mit-license.php ).
#
# If you like this code, please consider contributing to either me:
# http://www.shlomifish.org/meta/how-to-help/ or the Perl Foundation:
# http://www.perlfoundation.org/ .

use strict;
use warnings;

use List::Util qw(shuffle);

# See
# http://php.net/manual/en/function.str-shuffle.php

sub str_shuffle
{
    my $string = shift;

    return join( "", shuffle( split //, $string ) );
}

sub test_str_shuffle
{
    my $string = shift;

    print sprintf( qq{Shuffling of "%s" is "%s".\n},
        $string, str_shuffle($string) );
}

use Time::HiRes qw(gettimeofday);

# See:
# http://php.net/manual/en/function.microtime.php

sub microtime
{
    my $get_as_float = shift;

    my ( $secs, $microsecs ) = gettimeofday();

    if ($get_as_float)
    {
        return $secs + ( $microsecs * 1e-6 );
    }
    else
    {
        return "$microsecs $secs";
    }
}

sub test_microtime
{
    my $get_as_float = shift;

    print "Microtime("
        . ( $get_as_float ? "true" : "false" ) . ") = "
        . microtime($get_as_float) . "\n";
}

test_str_shuffle("HelloWorld");
test_str_shuffle("This sentence is false.");

test_microtime(1);
test_microtime();

