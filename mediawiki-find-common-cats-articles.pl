#!/usr/bin/perl

use strict;
use warnings;

use MediaWiki::API;
use IO::All;

my $mw = MediaWiki::API->new( { api_url => "http://cms.wikia.com/api.php" } );

# log in to the wiki
$mw->login(
    {
        lgname     => 'Shlomif',
        lgpassword => io("wikia-password.txt")->chomp->getline()
    }
) || die $mw->{error}->{code} . ': ' . $mw->{error}->{details};

# get a list of articles in category
my $articles1 = $mw->list(
    {
        action  => 'query',
        list    => 'categorymembers',
        cmtitle => 'Category:Blogging_Software',
        cmlimit => 'max'
    }
) || die $mw->{error}->{code} . ': ' . $mw->{error}->{details};

# get a list of articles in category
my $articles2 = $mw->list(
    {
        action  => 'query',
        list    => 'categorymembers',
        cmtitle => 'Category:Perl_software',
        cmlimit => 'max'
    }
) || die $mw->{error}->{code} . ': ' . $mw->{error}->{details};

my %common;
foreach my $art ( @$articles1, @$articles2 )
{
    ++$common{ $art->{title} };
}
print map { "$_\n" } sort { $a cmp $b } grep { $common{$_} == 2 } keys(%common);
