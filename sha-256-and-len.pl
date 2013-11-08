#!/usr/bin/perl

use strict;
use warnings;

use bytes;

use Digest::SHA;

my $sha = Digest::SHA->new(256);

my $data;
my $len = 0;
while (read(*STDIN, $data, 32768))
{
    $sha->add($data);
    $len += length($data);
}
print "Len: $len\nDigest: " . $sha->hexdigest() . "\n";

