#!/usr/bin/perl

use strict;
use warnings;

use Benchmark qw(:all :hireswallclock);

my $step_size = 7;

open my $null_fh, ">", "/dev/null";

sub using_splice
{
    my @all_bets = ( 1 .. 200 );

    while (@all_bets)
    {
        print {$null_fh} join( ',', splice( @all_bets, 0, $step_size ) ), ",\n";
    }
}

sub using_regex
{
    my @all_bets = ( 1 .. 200 );
    my $bet_txt  = join ",", @all_bets;
    $bet_txt .= ",";

    while ( $bet_txt =~ /\G((?:\d+,){1,$step_size})/og )
    {
        print {$null_fh} $1, "\n";
    }
}

# using_splice();
# using_regex();

timethese(
    10_000,
    {
        'using_regex'  => \&using_regex,
        'using_splice' => \&using_splice,
    }
);

close($null_fh);
