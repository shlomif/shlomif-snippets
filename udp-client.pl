#!/usr/bin/env perl

use strict;
use warnings;
use autodie;

use Time::HiRes qw( usleep );
use IO::Socket  qw(  );
use Socket      qw( SOCK_DGRAM SOCK_STREAM getaddrinfo );

my $REMOTE_HOSTNAME = "localhost";
my $PORT            = 5000;

my %hints = ( socktype => SOCK_DGRAM );
my ( $err, @res ) = getaddrinfo( $REMOTE_HOSTNAME, "${PORT}", \%hints );
die "Cannot getaddrinfo - $err" if $err;

my $sock;

ADDRINFO_LOOP:
foreach my $ai (@res)
{
    my $candidate = IO::Socket->new();

    $candidate->socket( $ai->{family}, $ai->{socktype}, $ai->{protocol} )
        or next ADDRINFO_LOOP;

    $candidate->connect( $ai->{addr} )
        or next ADDRINFO_LOOP;

    $sock = $candidate;
    last ADDRINFO_LOOP;
}

die "Cannot connect to localhost:echo" unless $sock;

my $DELAY_IN_USECS = shift || 20_000;
my $NUM_PACKETS    = shift || 100;

my $SOCKET = $sock;

if (0)
{
    my $LOCAL_INTERNET_ADDRESS = "localhost";
    IO::Socket::INET->new(
        Proto     => 'udp',
        LocalAddr => $LOCAL_INTERNET_ADDRESS,
    );

}

STDOUT->autoflush(1);

my $count = 0;
$SIG{TERM} = sub {
    print "\$count is $count\n";
    exit(-1);
};

# my $REMOTE_INTERNET_ADDR = inet_aton($REMOTE_HOSTNAME) or die "unknown host";
# my $REMOTE_PORT_AND_ADDR = sockaddr_in( $PORT, $REMOTE_INTERNET_ADDR );
for ( ; $count < $NUM_PACKETS ; ++$count )
{
    my $msg = pack( "A40", sprintf( "%s", $count ) );
    print qq#Sending "$msg"!\n#;

    # defined( $SOCKET->send( $msg, 0, $REMOTE_PORT_AND_ADDR ) )
    # or die "send ${REMOTE_HOSTNAME}: $!";
    defined( $SOCKET->send( $msg, ) )
        or die "send ${REMOTE_HOSTNAME}: $!";
    if ( $DELAY_IN_USECS > 0 )
    {
        usleep($DELAY_IN_USECS);
    }
}
print $count, "\n";
