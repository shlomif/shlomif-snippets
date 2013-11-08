#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use 5.012;

my %vars = (map { $_ => 0 } qw(A B C));

sub loop
{
    my ($var, $block) = @_;

    foreach my $value (0 .. 1)
    {
        $vars{$var} = $value;
        $block->();
    }
    return;
}

sub bool
{
    my $v = shift;
    return ($v ? "1" : "0");
}

binmode(STDOUT, ":encoding(utf8)");
printf("%5s%5s%5s%10s%10s\n", qw(A B C), '(A∩B)∪C', 'A∩(B∪C)');
loop('A',
    sub {
        loop('B',
            sub {
                loop ('C',
                    sub {
                        my ($A, $B, $C) = @vars{qw(A B C)};
                        printf("%5d%5d%5d%10d%10d\n",
                            @vars{qw(A B C)},
                            bool(($A && $B) || $C),
                            bool($A && ($B || $C)),
                        );
                    }
                )
            },
        )
    },
);
