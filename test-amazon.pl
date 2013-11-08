#!/usr/bin/perl

use strict;
use warnings;

use XML::Amazon;
use LWP::UserAgent;
use IO::All;

my $amazon =
    XML::Amazon->new(
        token => "0VRRHTFJECHSKYNYD282",
        associate => "shlomifishhom-20",
    );

my $asin = shift;
my $item = $amazon->asin($asin);

my $image_url = $item->image('l');

my $ua = LWP::UserAgent->new();
my $response = $ua->get($image_url);
if ($response->is_success)
{
    io("$asin.jpg")->print($response->content);
}
else
{
    die $response->status_line();
}
