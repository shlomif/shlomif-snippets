#!/usr/bin/perl -w
## no critic
my $a = 1;
{
    no strict;
    local *a;
    $a = 2;
}
print $a . "\n";
## yes critic
