#!/usr/bin/perl

use strict;
use warnings;

use File::Spec;
use List::MoreUtils (qw(any));

sub only_mods
{
    my $path = shift;

    opendir( my $d, $path );
    my $ret = any { !m{\.mod\z} } File::Spec->no_upwards( readdir($d) );
    closedir($d);

    return $ret;
}

my $path = shift(@ARGV);
exit( !only_mods($path) );

