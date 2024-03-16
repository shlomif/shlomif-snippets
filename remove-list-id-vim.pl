#!/usr/bin/perl

use strict;
use warnings;

use 5.016;

use Mail::Box::Manager;

my $mgr = Mail::Box::Manager->new;

# my $folder = $mgr->open($filename);

$mgr->registerType( MH => 'Mail::Box::MH' );
my $trash = $mgr->open( 'trash-bak-1', access => 'rw' );
my $large =
    $mgr->open( 'trash-new', access => 'a', create => 1, type => "MH", );

my %discard = (
    map { $_ => 1 } (
        '<perl5-porters.perl.org>', '<vim_use.googlegroups.com>',
        '<vim_dev.googlegroups.com>',
    )
);

my $count_removed = 0;
my $count         = 0;
foreach my $message ( $trash->messages )
{
    print "Processed: ", ( ++$count ), "\n";
    if ( exists( $discard{ $message->get('List-Id') // '' } ) )
    {
        print "Removed ", ( ++$count_removed ), "\n";
    }
    else
    {
        $mgr->moveMessage( $large, $message );
    }
}

$trash->close;
$large->close;
