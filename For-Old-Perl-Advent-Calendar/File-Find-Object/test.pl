#!/usr/bin/perl

use strict;
use warnings;

use File::Spec;
use File::Find::Object;
use File::Slurp;
use Email::Simple;

sub last_component
{
    my $path  = shift;
    my @comps = File::Spec->splitdir($path);
    return $comps[-1];
}

my $tree =
    File::Find::Object->new( {}, File::Spec->catdir( $ENV{HOME}, ".Mail" ) );

my @maildirs;
while ( my $result = $tree->next() )
{
    if ( last_component($result) eq "cur" )
    {
        # Make sure we don't get each and every files in the directory as a
        # result.
        $tree->prune();
        push @maildirs, $result;
    }
}
foreach my $dir (@maildirs)
{
    opendir( my $dir_handle, $dir );
    my @contents = readdir($dir_handle);
    closedir($dir_handle);

    foreach my $file ( File::Spec->no_upwards(@contents) )
    {
        my $fullpath = File::Spec->catfile( $dir, $file );

        if ( !-f $fullpath )
        {
            next FILES_LOOP;
        }

        my $text  = read_file($fullpath);
        my $email = Email::Simple->new($text);
        my $from  = $email->header("From");
        if ( defined($from) && ( $from =~ /Schwern/ ) )
        {
            print "$fullpath\n";
        }
    }
}

