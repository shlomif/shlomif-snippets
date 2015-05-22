#!/usr/bin/perl

use strict;
use warnings;

use IO::Handle;

open O, ">", "test.txt";
if (fork())
{
    sleep(1);
    print O "Hello\n";
    O->flush;
}
else
{
    print O "Good\n";
    O->flush;
}
close(O);
