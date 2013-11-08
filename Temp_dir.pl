#!/usr/bin/perl

use strict;
use warnings;

use autodie;

use File::Temp qw(tempdir);
use File::Spec;

my $dir = tempdir( CLEANUP => 1 );

my $filename = File::Spec->catfile($dir, 'myfile.txt');

open my $fh, '>', $filename;
print {$fh} "Hello\n";
close ($fh);

print "Success!\n";
