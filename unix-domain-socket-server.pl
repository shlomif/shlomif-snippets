#!/usr/bin/perl

use strict;
use warnings;

use IO::Socket::UNIX;

my $server = IO::Socket::UNIX->new(
    Type => SOCK_STREAM(),
    Local => "$ENV{HOME}/tmp/unix-domain-socket-test/foo.sock",
    Listen => 1,
);

my $count = 1;
while (my $conn = $server->accept())
{
    $conn->print("Hello " . ($count++) . "\n");
}
