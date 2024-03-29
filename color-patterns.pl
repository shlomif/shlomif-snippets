#!/usr/bin/perl

# Written by Shlomi Fish - http://www.shlomifish.org/ - 2008
# Licensed under the MIT/X11 License.
#
# Example:
# perl color-patterns.pl --pat hello=red --pat '(?i:maxim)'=blue

use strict;
use warnings;

use Getopt::Long;
use Term::ANSIColor;

my %patterns;
GetOptions( "pat=s" => \%patterns );

my @p;
while ( my ( $k, $v ) = each(%patterns) )
{
    push @p, { pat => qr{$k}, color => $v };
}

while ( my $l = <> )
{
    foreach my $pat (@p)
    {
        my $re = $pat->{pat};
        my $c  = $pat->{color};
        $l =~ s/($re)/colored($1, $c)/eg;
    }
    print $l;
}
