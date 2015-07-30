#!/usr/bin/perl

use strict;
use warnings;

STDOUT->autoflush(1);
my $num_megas = shift(@ARGV);
{
    my $x = "1" x ($num_megas * 1024 * 1024);

    print "Now allocated $num_megas MB! Press enter to continue\n";
    <>;
}
print "After freeing. Press enter to continue\n";
<>;

