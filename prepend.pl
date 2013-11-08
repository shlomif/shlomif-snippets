#!/usr/bin/perl

use strict;
use warnings;

my $filename = shift(@ARGV);
my $new_fn = $filename . '.new';

open my $in, '<', $filename
    or die "Cannot open $filename for reading - $!";
open my $out, '>', $new_fn
    or die "Cannot open $new_fn for writing - $!";

print {$out} <<'EOF';
ENTHDR|1|3.0
STAGEHDR|Barcoded
EOF

while (my $line = <$in>)
{
    print {$out} $line;
}

close($out);
close($in);

rename($new_fn, $filename);
