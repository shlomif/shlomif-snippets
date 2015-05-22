#!/usr/bin/perl

# Special-ls:
# An ls-like program that is smarter in processing numeric strings or
# sub-strings.
# Limitations :
# 1. only lists files from the command-line.
# 2. Does not handle pathes (with slashes) very well.
# 3. Others (?).
# 4. Floaties are not handled very well.
#
# Written by Shlomi Fish, 2004
# Distributed under the MIT X11 license. (practically public domain)
#
# Retrospectively, I can be somewhat smarter and simply find the greatest
# common prefix of the strings, and then process the next character based
# on the last character in the common prefix.

use strict;
use warnings;

# my @files = (@ARGV);
my @files = (<STDIN>);
chomp(@files);

sub my_split
{
    my $f = shift;
    my @components = ($f =~ /((?:\d+)|(?:\D+))/g);
    return \@components;
}

sub my_compare
{
    my @strings = @_;
    my @comps = (map { my_split($_) } @strings);
    my $digit = ($comps[0][0] =~ /^\d/)?1:0;
    my $digit2 = ($comps[1][0] =~ /^\d/)?1:0;
    if ($digit != $digit2)
    {
        return ($strings[0] cmp $strings[1]);
    }
    my $i = 0;
    for($i=0;
        ($i<scalar(@{$comps[0]})) && ($i<scalar(@{$comps[1]}));
        $i++,($digit^=0x1))
    {
        my $side1 = $comps[0][$i];
        my $side2 = $comps[1][$i];
        my $verdict = ($digit ? ($side1 <=> $side2) : ($side1 cmp $side2));
        if ($verdict)
        {
            return $verdict;
        }
    }
    return (length($strings[0]) <=> length($strings[1]));
}

# my_split($ARGV[0]);
print (map { "$_\n" } sort { my_compare($a,$b) } @files);

