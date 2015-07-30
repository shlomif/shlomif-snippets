#!/usr/bin/perl -w

use strict;

use Math::GMP;

my $x = Math::GMP->new(shift);

# my $result = Math::GMP::gmp_probab_prime($x, 10);
my $result = $x->probab_prime(10);

print +(($result == 0) ? "No":
      ($result == 1) ? "Probably" :
      ($result == 2) ? "Yes" :
      "Error");
print "\n";
