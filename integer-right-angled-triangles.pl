#!/usr/bin/perl

# An old program (pre 2000) to calculate potential other legs in Pythagorean
# triangles.
#
# Please don't use and instead take a look at:
#
# https://bitbucket.org/shlomif/project-euler
#
# License is http://opensource.org/licenses/mit-license.php .

use strict;
use warnings;

sub find_integer_triangles_by_leg
{
    my ($first_leg) = @_;
    my $max_leg = 1000;
    my @values;

    foreach my $i (
        1 .. (
            ( $first_leg > $max_leg ) ? ( $first_leg * 2 ) : ( $max_leg * 2 )
        )
        )
    {
        my $hypotenuse = sqrt( $i * $i + $first_leg * $first_leg );
        if ( $hypotenuse == int($hypotenuse) )
        {
            push @values, $i;
        }
    }
    return \@values;
}

my ($leg) = @ARGV;

print join( ", ", @{ find_integer_triangles_by_leg($leg) } ), "\n";

