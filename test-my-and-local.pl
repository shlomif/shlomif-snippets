#!/usr/bin/perl -w
my $a = 1;
{
    no strict;
    local *a;
    $a = 2;
}
print $a . "\n";
