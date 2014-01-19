#!/usr/bin/perl

use strict;
use warnings;


my $state = "START";

sub read_choice
{
    print "STATE == $state ; Enter your choice:\n";

    my $l = <>;
    chomp($l);
    if ($l !~ /\A[0-9]\z/)
    {
        die "Wrong <$l>!";
    }
    return $l;
}

my %handlers = (
    "START" => sub {
        my $choice = read_choice;

        $state = ($choice == 0) ? 0 : "END";

        return;
    },
    0 => sub {
        my $choice = read_choice;

        if ($choice eq 0)
        {
            print "Going to START.\n";
            $state = "START";
        }
        else
        {
            print "You entered choice <$choice>.\n";
        }

        return;
    },
    END => sub {
        exit(0);
    },
);

while (1)
{
    $handlers{$state}->();
}
