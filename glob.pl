#!/usr/bin/perl

use Time::HiRes qw(clock_gettime);

$| = 1;
chdir "/tmp/glob" || die "$!";
for($i=0; $i<39; $i++) {
  $pattern = ("a*"x$i) . "b";
  $t = clock_gettime(CLOCK_REALTIME);
  $mul = 10;
  for($j=0; $j<$mul; $j++) {
      glob $pattern;
  }
  $t1 = clock_gettime(CLOCK_REALTIME);
  printf("%d %.9f\n", $i, ($t1-$t)/$mul);
}
