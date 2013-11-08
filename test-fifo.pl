#!/usr/bin/perl

use strict;
use warnings;

use IO::Select;
use POSIX;

my $s = IO::Select->new();

sysopen my $fifo, "myfifo", O_RDONLY|O_NONBLOCK;
$s->add($fifo);

while (1)
{
    print "Hello\n";
    if ($s->can_read(1))
    {
        my $data;
        if (sysread($fifo,$data, 2) == 2)
        {
            print "Data: \"$data\"\n";
        }
    }
}
