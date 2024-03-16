#!/usr/bin/perl

use strict;
use warnings;

use autobox;

sub UNIVERSAL::with
{
    local $_ = shift;
    my $sub = shift;
    return $sub->( $_, @_ );
}

my $_with = sub {
    local $_ = shift;
    my $sub = shift;
    return $sub->( $_, @_ );
};

print +( 10 + 1 )->with( sub { $_ * $_; } ),   "\n";
print +( 10 + 1 )->$_with( sub { $_ * $_; } ), "\n";
