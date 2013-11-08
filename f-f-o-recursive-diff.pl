#!/usr/bin/perl

use strict;
use warnings;

use File::Find::Object;
use List::MoreUtils qw(all);

my @indexes = (0,1);
my @paths;
for my $idx (@indexes)
{
    push @paths, shift(@ARGV);
}

my @finders = map { File::Find::Object->new({}, $_ ) } @paths;

my @results;

my @fns;

sub fetch
{
    my $idx = shift;

    if ($results[$idx] = $finders[$idx]->next_obj())
    {
        $fns[$idx] = join("/", @{$results[$idx]->full_components()});
    }

    return;
}

sub only_in
{
    my $idx = shift;

    printf("Only in %s: %s\n", $paths[$idx], $fns[$idx]);
    fetch($idx);

    return;
}

for my $idx (@indexes)
{
    fetch($idx);
}

COMPARE:
while (all { $_ } @results)
{
    my $skip = 0;
    foreach my $idx (@indexes)
    {
        if (!$results[$idx]->is_file())
        {
            fetch($idx);
            $skip = 1;
        }
    }
    if ($skip)
    {
        next COMPARE;
    }

    if ($fns[0] lt $fns[1])
    {
        only_in(0);
    }
    elsif ($fns[1] lt $fns[0])
    {
        only_in(1);
    }
    else
    {
        system("diff", "-u", map {$_->path() } @results);
        foreach my $idx (@indexes)
        {
            fetch($idx);
        }
    }
}

foreach my $idx (@indexes)
{
    while($results[$idx])
    {
        only_in($idx);
    }
}

