#!/usr/bin/env perl

use strict;
use warnings;
use autodie;

use Socket        qw( INADDR_ANY PF_INET SOCK_DGRAM sockaddr_in );
use Sys::Hostname qw( hostname );

STDOUT->autoflush(1);

my ( $rout, );

my $SECS_of_70_YEARS = 2208988800;

my $iaddr = gethostbyname( hostname() );
my $proto = getprotobyname('udp');
my $port  = getservbyname( 'time', 'udp' );
my $paddr = sockaddr_in( 5000, INADDR_ANY );    # 0 means let kernel pick

my $SOCKET;
socket( $SOCKET, PF_INET, SOCK_DGRAM, $proto ) or die "socket: $!";
bind( $SOCKET, $paddr )                        or die "bind: $!";

my $rin = '';
vec( $rin, fileno($SOCKET), 1 ) = 1;

my $count = 0;
$SIG{TERM} = sub {
    print "\$count is $count\n";
    exit(-1);
};

# timeout after 10.0 seconds
while ( select( $rout = $rin, undef, undef, 200.0 ) )
{
    my $rtime = '';
    if ( not( my $hispaddr = recv( $SOCKET, $rtime, 40, 0 ) ) )
    {
        die "recv: $!";
    }
    if ( $count % 25000 == 0 )
    {
        print "$count time=" . time() . "\n";
    }
    ++$count;
    print qq#Received Message: "$rtime"!\n#;
}

