#!/usr/bin/perl

use strict;
use warnings;

use IO::Socket::UNIX;
use File::Path qw(mkpath);

my $dir = "$ENV{HOME}/tmp/unix-domain-socket-test";
mkpath($dir);

my $server = IO::Socket::UNIX->new(
    Type => SOCK_STREAM(),
    Local => "$dir/foo.sock",
    Listen => 1,
);

my $count = 1;
while (my $conn = $server->accept())
{
    $conn->print("Hello " . ($count++) . "\n");
}
