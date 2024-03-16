#!/usr/bin/perl

use strict;
use warnings;

my $dir = shift(@ARGV);

opendir my $dir_handle, $dir
    or die "Could not open directory $dir - $!";

FILES_LOOP:
while ( my $file = readdir($dir_handle) )
{
    next FILES_LOOP if !-f $file;
    my $new = $file;
    if ( $new =~ s{ *\d{1,2}:\d{1,2}:\d{4}(\.jpg)\z}{$1}i )
    {
        rename( $file, $new );
    }
}
closedir($dir_handle);
