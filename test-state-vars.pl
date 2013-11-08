use strict;
use warnings;

use feature qw(:5.10);

sub counter1
{
    state $i = 0;
    return ++$i;
}

say "counter1() = ", counter1();
say "counter1() = ", counter1();

sub make_counter
{
    my $i = 0;
    return sub {
        return ++$i;
    };
}

my $c1 = make_counter();
my $c2 = make_counter();

say '$c1->() = ', $c1->();
say '$c2->() = ', $c2->();
say '$c1->() = ', $c1->();
say '$c2->() = ', $c2->();

sub make_state_counter
{
    return sub {
        state $i = 0;
        return ++$i;
    };
}

my $sc1 = make_state_counter();
my $sc2 = make_state_counter();

say '$sc1->() = ', $sc1->();
say '$sc2->() = ', $sc2->();
say '$sc1->() = ', $sc1->();
say '$sc2->() = ', $sc2->();

