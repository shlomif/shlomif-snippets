#!/usr/bin/perl

# Similar to grep -l .

use strict;
use warnings;

use autodie;

sub does_file_match
{
    my ($filename, $re) = @_;

    open my $in, '<', $filename;

    while (my $line = <$in>)
    {
        chomp($line);

        if ($line =~ $re)
        {
            close($in);
            return 1;
        }
    }

    close($in);
    return '';
}
