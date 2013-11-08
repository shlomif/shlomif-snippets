#!/usr/bin/perl

use strict;
use warnings;

use XML::LibXML;

my $parser = XML::LibXML->new();
$parser->load_ext_dtd(0);
$parser->no_network(1);
$parser->validation(1);
# $parser->expand_entities(0);
$parser->recover(1);

my $dom = $parser->load_xml(
    location => "./test.xml",
);

my $note_xpath = XML::LibXML::XPathExpression->new('note');

foreach my $measure ($dom->findnodes('//measure'))
{
    # print $node->toString();
    foreach my $note ($measure->findnodes($note_xpath))
    {
        printf "Measure={$measure} Note={$note}\n";
    }
}
