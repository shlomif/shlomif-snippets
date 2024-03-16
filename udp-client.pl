#!/usr/bin/env perl

use strict;
use warnings;
use autodie;

use Socket qw( inet_aton sockaddr_in );

use IO::Socket::INET ();
use Time::HiRes      qw( usleep );

my $delay_in_usecs = shift || 20_000;
my $num_packets    = shift || 100;

my $count = 0;

my $iaddr = "localhost";

my $port = 5000;

my $SOCKET = IO::Socket::INET->new(
    Proto     => 'udp',
    LocalAddr => $iaddr,
);

my $host = "localhost";

STDOUT->autoflush(1);

$SIG{TERM} = sub {
    print "\$count is $count\n";
    exit(-1);
};

my $hisiaddr = inet_aton($host) || die "unknown host";
my $hispaddr = sockaddr_in( $port, $hisiaddr );
for ( ; $count < $num_packets ; ++$count )
{
    my $msg = pack( "A40", sprintf( "%s", $count ) );
    print qq#Sending "$msg"!\n#;
    defined( $SOCKET->send( $msg, 0, $hispaddr ) ) or die "send ${host}: $!";
    if ( $delay_in_usecs > 0 )
    {
        usleep($delay_in_usecs);
    }
}
print $count, "\n";
