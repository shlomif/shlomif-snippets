#!/usr/bin/perl

use strict;
use warnings;

use File::Spec;

use JSON qw(encode_json);

sub recurse
{
    my $dirname = shift;

    opendir my $dh, $dirname
        or Carp::confess ("Cannot open $dirname");
    my @files = File::Spec->no_upwards(readdir($dh));
    close($dh);

    return
    +{
        map
        {
            my $fn = $_;
            my $sub_path = File::Spec->catfile($dirname, $fn);

            $fn => (-d $sub_path ? recurse($sub_path) : [stat($sub_path)]),
        } sort {$a cmp $b } @files,
    }
}

binmode STDOUT, ':encoding(utf8)';

my $initial_dirname = shift(@ARGV);
print encode_json(
    recurse($initial_dirname),
);
