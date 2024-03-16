#!/usr/bin/perl -w
use strict;
BEGIN { $ENV{PATH} = '/usr/ucb:/bin' }
use Socket;
use Carp;
my $EOL = "\015\012";

sub logmsg { print "$0 $$: @_ at ", scalar localtime, "\n" }

my $port  = shift || 2345;
my $proto = getprotobyname('tcp');
$port = $1 if $port =~ /(\d+)/;    # untaint port number

socket( Server, PF_INET, SOCK_STREAM, $proto ) || die "socket: $!";
setsockopt( Server, SOL_SOCKET, SO_REUSEADDR, pack( "l", 1 ) )
    || die "setsockopt: $!";
bind( Server, sockaddr_in( $port, INADDR_ANY ) ) || die "bind: $!";
listen( Server, SOMAXCONN )                      || die "listen: $!";

logmsg "server started on port $port";

my $paddr;

sub REAPER
{
    my $waitedpid = wait;
    $SIG{CHLD} = \&REAPER;    # loathe sysV
    logmsg "reaped $waitedpid" . ( $? ? " with exit $?" : '' );
}

$SIG{CHLD} = \&REAPER;

for ( ; $paddr = accept( Client, Server ) ; close Client )
{
    my ( $port, $iaddr ) = sockaddr_in($paddr);
    my $name = gethostbyaddr( $iaddr, AF_INET );

    logmsg "connection from $name [", inet_ntoa($iaddr), "]
            at port $port";

    while (<Client>)
    {
        print $_;
    }

}
