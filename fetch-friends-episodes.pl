#!/usr/bin/perl

use strict;
use warnings;

use WWW::Mechanize;

my $page_url = "http://www.geocities.com/vspramod/Links/friends/friends.htm";

my $mech = WWW::Mechanize->new();

$mech->get($page_url);

my $links = $mech->links();

my $episode_links = [ grep { $_->text() =~ /^\d\d\d.*The One/ } @$links ];

foreach my $l (@$episode_links)
{
    print "Download " . $l->url_abs() . "\n";
    my $episode_mech = $mech->clone();
    $episode_mech->get($l->url_abs());
    if ($l->url_abs() =~ m{/([^/]+)$})
    {
        my $fn = $1;
        print "Into $fn\n";
        open O, ">", "downloads/$fn";
        print O $episode_mech->content();
        close(O);
    }
}
