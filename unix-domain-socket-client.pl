#!/usr/bin/perl

use strict;
use warnings;

use IO::Socket::UNIX;

my $client = IO::Socket::UNIX->new(
    Type => SOCK_STREAM(),
    Peer => "$ENV{HOME}/tmp/unix-domain-socket-test/foo.sock",
);

my $contents = do
{
    local $/;
    <$client>;
};

print "Got <<$contents>>\n";

