#!/usr/bin/env perl

use strict;
use warnings;
use autodie;

use Socket qw( inet_aton sockaddr_in );

use IO::Socket::INET ();
use Time::HiRes      qw( usleep );

my $DELAY_IN_USECS = shift || 20_000;
my $NUM_PACKETS    = shift || 100;

my $LOCAL_INTERNET_ADDRESS = "localhost";

my $PORT = 5000;

my $SOCKET = IO::Socket::INET->new(
    Proto     => 'udp',
    LocalAddr => $LOCAL_INTERNET_ADDRESS,
);

my $REMOTE_HOSTNAME = "localhost";

STDOUT->autoflush(1);

my $count = 0;
$SIG{TERM} = sub {
    print "\$count is $count\n";
    exit(-1);
};

my $REMOTE_INTERNET_ADDR = inet_aton($REMOTE_HOSTNAME) or die "unknown host";
my $REMOTE_PORT_AND_ADDR = sockaddr_in( $PORT, $REMOTE_INTERNET_ADDR );
for ( ; $count < $NUM_PACKETS ; ++$count )
{
    my $msg = pack( "A40", sprintf( "%s", $count ) );
    print qq#Sending "$msg"!\n#;
    defined( $SOCKET->send( $msg, 0, $REMOTE_PORT_AND_ADDR ) )
        or die "send ${REMOTE_HOSTNAME}: $!";
    if ( $DELAY_IN_USECS > 0 )
    {
        usleep($DELAY_IN_USECS);
    }
}
print $count, "\n";
