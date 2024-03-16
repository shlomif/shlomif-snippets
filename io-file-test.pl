#!/usr/bin/perl

use strict;
use warnings;

use IO::File;

{
    my $fh = IO::File->new(">&STDOUT");
    $fh->print("SFO From here to there\n");
    $fh->close();
}

{
    my $fh = IO::File->new( "myfile.txt", "w" );
    $fh->print("SFO From here to there and everywhere\n");
    $fh->close();
}
