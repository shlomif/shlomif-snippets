#!/usr/bin/perl -w

use strict;

use LWP::Simple;
use Data::Dumper;

require 'flush.pl';

my %unhtml_conv =
(
    'lt' => '<',
    'gt' => '>',
    'amp' => '&',
);

my $expression = "There is no IGLU Cabal";

my $expression_regex = "\\s*$expression";
$expression_regex =~ s/ /\\s+/g;

sub get_hackers_il_msg
{
    my $index = shift;

    my $text;

    $text = get("http://groups.yahoo.com/group/hackers-il/message/$index?source=1");

    # Take only whatever between the <pre>
    $text =~ s/^[\x00-\xFF]*?<pre>//;
    $text =~ s/<\/pre>[\x00-\xFF]*$//;

    # Convert all those &...; escapes
    # Is there a CPAN module that does this?
    $text =~ s/\&(amp|lt|gt);/$unhtml_conv{$1}/ge;

    my @lines = split(/\n/, $text);

    my ($fortune, $from);
    $fortune = "";

    while(scalar(@lines))
    {
        my $l = shift(@lines);
        if ($l =~ /^From:/)
        {
            $from = $l;
            $from =~ s/^From:\s*//;
            $from =~ s/<.*$//;
            $from =~ s/\s+$//; # Remove trailing whitespace
        }
        if ($l =~ /^$expression_regex/)
        {
            $fortune .= $l . "\n";
            while (scalar(@lines))
            {
                my $l = shift(@lines);
                if (($l =~ /^\s*$/) || ($l =~ /WARNING TO SPAMMERS/))
                {
                    last;
                }
                $fortune .= $l . "\n";
            }
            last;
        }
    }

    if ($fortune eq "")
    {
        return undef;
    }

    my $ret;

    $ret =
    {
        'fortune' => $fortune,
        'group' => "Hackers-IL",
        'from' => $from,
        'msg_index' => $index,
    };

    #my $d = Data::Dumper->new([ \$ret ], ["\$ret"]);
    #print $d->Dump();
    return $ret;
}

#&get_hackers_il_msg(1376);
# 729 is the first message with the IGLU Cabal mentioned
for my $msg_index (729 .. 1404)
{
    print STDERR "$msg_index\n";
    my $fortune = get_hackers_il_msg($msg_index);
    if (defined($fortune))
    {
        print $fortune->{'fortune'}, "\n";
        print "\t" . $fortune->{'from'} . " in " . $fortune->{'group'} . " msg No. " . $fortune->{'msg_index'} . "\n";
        print "%\n";
        flush(*STDOUT);
    }
}

### End Perl Script ###


