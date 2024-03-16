#!/usr/bin/perl

use strict;
use warnings;

sub random_hex
{
    my ($hex_digits_count) = @_;

    my $bytes_count = ( $hex_digits_count >> 1 );
    open my $fh, '<:raw', '/dev/urandom'
        or die "Cannot open /dev/urandom for reading.";

    my $buffer;
    if ( read( $fh, $buffer, $bytes_count ) != $bytes_count )
    {
        die "Read number of wrong bytes.";
    }

    return join( '', map { sprintf( "%.2X", ord($_) ); } split //, $buffer );
}

my ($count) = (@ARGV);
print random_hex($count), "\n";
