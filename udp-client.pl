#!/usr/bin/perl -w
use strict;
use Socket;
use Sys::Hostname;

use Time::HiRes qw(usleep);

my $delay_in_usecs = shift || 20_000;
my $num_packets    = shift || 100;

my ( $count, $hisiaddr, $hispaddr, $histime,
    $host, $iaddr, $paddr, $port, $proto,
    $rin, $rout, $rtime, $SECS_of_70_YEARS );

$SECS_of_70_YEARS = 2208988800;

$iaddr = gethostbyname("192.168.1.100");
$proto = getprotobyname('udp');

#$port = getservbyname('time', 'udp');
$port  = 5000;
$paddr = sockaddr_in( 0, $iaddr );    # 0 means let kernel pick

socket( SOCKET, PF_INET, SOCK_DGRAM, $proto ) || die "socket: $!";
bind( SOCKET, $paddr ) || die "bind: $!";

$host = "192.168.1.12";

$| = 1;

$SIG{TERM} = sub {
    print "\$count is $count\n";
    exit(-1);
};

$hisiaddr = inet_aton($host) || die "unknown host";
$hispaddr = sockaddr_in( $port, $hisiaddr );
for ( $count = 0 ; $count < $num_packets ; $count++ )
{
    my $msg = pack( "A40", sprintf( "%s", $count ) );
    print "Sending \"$msg\"!\n";

    #if ($count % 100 == 0)
    #{
    #    print "Sending \"$msg\"!\n";
    #}
    defined( send( SOCKET, $msg, 0, $hispaddr ) ) || die "send $host: $!";
    if ( $delay_in_usecs > 0 )
    {
        usleep($delay_in_usecs);
    }

    #sleep(1);
    #usleep(20000);
    #usleep(200000);
}
print $count, "\n";
