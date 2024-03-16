#!/usr/bin/perl

use strict;
use warnings;

package Tie::ArrayIndirect;

use base 'Tie::Array';

sub TIEARRAY
{
    my ( $class, $ref ) = @_;

    return bless { 'ref' => $ref }, $class;
}

sub FETCH
{
    my ( $self, $index ) = @_;
    return $self->{'ref'}->[$index];
}

sub FETCHSIZE
{
    my ($self) = @_;

    return scalar( @{ $self->{'ref'} } );
}

sub STORE
{
    my ( $self, $index, $val ) = @_;

    return ( $self->{'ref'}->[$index] = $val );
}

sub EXISTS
{
    my ( $self, $index ) = @_;

    return exists( $self->{'ref'}->[$index] );
}

sub DELETE
{
    my ( $self, $index ) = @_;

    return delete( $self->{'ref'}->[$index] );
}

package main;

sub return_ref
{
    return [ 0, 1, 22, 303 ];
}

my $ref = return_ref();

my @array;

tie @array, 'Tie::ArrayIndirect', $ref;

print "array[2] = " . $array[2] . "\n";

push @array, 4444.4;

print "ref->[4] = ", $ref->[4], "\n";

