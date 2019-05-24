#!/usr/bin/perl
use strict;
use warnings;
use Socket;
use Sys::Hostname;

my ( $count, $hisiaddr, $hispaddr, $histime, $host, $rout, $rtime, );

my $SECS_of_70_YEARS = 2208988800;

my $iaddr = gethostbyname( hostname() );
my $proto = getprotobyname('udp');
my $port  = getservbyname( 'time', 'udp' );
my $paddr = sockaddr_in( 5000, INADDR_ANY );    # 0 means let kernel pick

socket( SOCKET, PF_INET, SOCK_DGRAM, $proto ) || die "socket: $!";
bind( SOCKET, $paddr ) || die "bind: $!";

my $rin = '';
vec( $rin, fileno(SOCKET), 1 ) = 1;

$SIG{TERM} = sub {
    print "\$count is $count\n";
    exit(-1);
};

# timeout after 10.0 seconds
$count = 0;
while ( select( $rout = $rin, undef, undef, 200.0 ) )
{
    $rtime = '';
    ( $hispaddr = recv( SOCKET, $rtime, 40, 0 ) ) || die "recv: $!";
    if ( $count % 25000 == 0 )
    {
        print "$count time=" . time() . "\n";
    }
    ++$count;
    print "Received Message: \"$rtime\"!\n";
}

