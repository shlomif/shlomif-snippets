#!/usr/bin/pugs

use v6;
use Test;

plan 6;

my %gsf_cache = (1 => []);

sub multiply_squaring_factors($n,$m)
{
    return sort { $^a <=> $^b } one(@$n,@$m).values;
}

sub get_squaring_factors($n,$start_from=2)
{
    if (%gsf_cache.exists($n))
    {
        return %gsf_cache{$n};
    }

    my $p = [//] grep { $n % $_ == 0 } ($start_from .. $n);
    # This function is recursive to make better use of the Memoization
    # feature.
    my $division_factors = get_squaring_factors(int($n / $p), $p);
    return 
        (%gsf_cache{$n} = multiply_squaring_factors([$p], $division_factors));
}


# TEST
is_deeply(get_squaring_factors(1), [], "SqFact of 1");
# TEST
is_deeply(get_squaring_factors(2), [2], "SqFact of 2");
# TEST
is_deeply(get_squaring_factors(4), [], "SqFact of 4");
# TEST
is_deeply(get_squaring_factors(10), [2,5], "SqFact of 10");
# TEST
is_deeply(get_squaring_factors(9*4), [], "SqFact of 36");
# TEST
is_deeply(get_squaring_factors(9*2), [2], "SqFact of 18");

