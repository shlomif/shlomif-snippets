#!/usr/bin/perl

use strict;
use warnings;

use File::ReadBackwards;
use Getopt::Long;

my $count;
GetOptions(
    "n=i" => \$count,
);

if (!defined($count))
{
    die "Please specify -n for the line count.";
}

my $filename = shift;

my $bw = File::ReadBackwards->new($filename)
    or die "Could not backwards-open '$filename' - $!";

foreach my $idx (1 .. $count)
{
    $bw->readline();
}

my $wanted_len = $bw->tell();

$bw->close();

open my $truncate_fh, "+<", $filename
    or die "Could not truncate-open '$filename' - $!";

truncate($truncate_fh, $wanted_len);

close($truncate_fh);


