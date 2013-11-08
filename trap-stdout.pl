#!/usr/bin/perl

use strict;
use warnings;

use IO::Scalar;

close(STDOUT);

my $buffer;
tie *STDOUT, 'IO::Scalar', \$buffer;

print "Hello\n";
print "Shlomif\n";
open my $out, ">hello.txt";
print {$out} $buffer;
close($out);

1;

