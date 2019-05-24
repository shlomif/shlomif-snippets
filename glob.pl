#!/usr/bin/perl

use strict;
use warnings;

use Time::HiRes qw(clock_gettime CLOCK_REALTIME);

$| = 1;
chdir "/tmp/glob" || die "$!";
system( "touch", ( "a" x 100 ) );
for my $i ( 0 .. 40 )
{
    my $pattern = ( "a*" x $i ) . "b";
    my $t       = clock_gettime( CLOCK_REALTIME() );
    my $mul     = 10;
    for my $j ( 1 .. $mul )
    {
        glob $pattern;
    }
    my $t1 = clock_gettime( CLOCK_REALTIME() );
    printf( "%d %.9f\n", $i, ( $t1 - $t ) / $mul );
}
