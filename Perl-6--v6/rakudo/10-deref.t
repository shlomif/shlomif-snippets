use v6;

use Test;

plan 2;

{
    my $x = [0, 100, 280, 33, 400, 5665];

    # TEST
    is (@$x[1], 100, '@$x works');

    # TEST
    is (@$x[3]+50, 83, '@$x works inside a larger expression');
}

