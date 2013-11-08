#!/usr/bin/perl

use strict;
use warnings;

use IO::All;

foreach my $fn (`ack -l NEXT`)
{
    chomp($fn);
    my @lines = io()->file($fn)->getlines();
    foreach my $l (@lines)
    {
        if ($l =~ m{\Ause NEXT;\Z})
        {
            $l = "use MRO::Compat;\n";
        }
        else
        {
            $l =~ s{->NEXT::\w+}{->next::method}g;
        }
    }
    io->file($fn)->print(@lines);
}
