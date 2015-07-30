#!/usr/bin/perl -w

use strict;
use Data::Dumper;

sub create_factor_map
{
    my $how_much = shift;

    my @numbers_proto = ( 0 .. $how_much);
    my @numbers =
        (map
            {
                {
                    'idx' => $_,
                    'factors' => {},
                    'Sh' => 0
                };
            }
         @numbers_proto
        );

    my $factor;
    my $limit = $how_much / 2;
    my ($power_exp, $power_limit, $power);
    my ($i);

    for($factor = 2; $factor <= $limit ; $factor++)
    {
        if (scalar(keys(%{$numbers[$factor]->{'factors'}})) == 0)
        {
            # This is a prime number

            $power_limit = int(log($how_much)/log($factor));
            $power = $factor;
            for($power_exp = 1 ; $power_exp <= $power_limit ; $power_exp++, $power *= $factor)
            {
                for($i = $power ; $i < $how_much ; $i += $power)
                {
                    $numbers[$i]->{'factors'}->{$factor} = $power_exp;
                }
            }
        }
    }

    return \@numbers;
}

sub calc_sheeritons
{
    my $numbers = shift;

    my ($a, $run_once, $num_iters);

    for(my $num=3 ; $num < scalar(@{$numbers}) ; $num+=2)
    {
        $a = 1;
        $run_once = 1;
        $num_iters = 0;
        while ($run_once || ($a != 1))
        {
            $run_once = 0;
            $a = (($a*2) % $num);
            $num_iters++;
        }
        $numbers->[$num]->{'Sh'} = $num_iters;
    }
}

sub gcd
{
    my $a = shift;
    my $b = shift;

    if ($b>$a)
    {
        ($a,$b)=($b,$a);
    }

    while ($a % $b)
    {
        ($a, $b) = ($b, $a % $b);
    }
    return $b;
}

sub lcm
{
    my $a = shift;
    my $b = shift;

    return ($a*$b)/gcd($a,$b);
}

sub multi_lcm
{
    my @numbers = @_;

    @numbers = (sort { $a <=> $b } @numbers);

    my $max_num = $numbers[$#numbers];

    my $lcm;

    for($lcm=$max_num; ; $lcm += $max_num)
    {
        if (scalar(grep { $lcm % $_ != 0 } @numbers) == 0)
        {
            return $lcm;
        }
    }

    return 0;
}

sub analyze
{
    my $numbers = shift;

    my $num;
    my $record;
    my $factors_hash;
    my @factors;
    my $factor1;
    my $limit;
    my $sh;
    my $lcm;

    for($num=3 ; $num < scalar(@$numbers) ; $num+=2)
    {
        $record = $numbers->[$num];
        $factors_hash = $record->{'factors'};
        @factors = (sort { $a <=> $b } keys(%$factors_hash));
        if (scalar(@factors) >= 2)
        {
            my @sh_bases;

            @sh_bases = (map { $numbers->[$_ ** $factors_hash->{$_}]->{'Sh'} } @factors);
            $lcm = &multi_lcm(@sh_bases);
            $sh = $record->{'Sh'};
            print "num = $num\n";
            print "lcm = $lcm\n";
            print "sh = $sh\n";
            if ($lcm != $sh)
            {
                die "Hello!";
            }
            print "------------\n";
        }
    }
}

my $numbers = create_factor_map(10000);
calc_sheeritons($numbers);

analyze($numbers);

#my $d = Data::Dumper->new([\$numbers], ['$numbers']);
#print $d->Dump();

