#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 8;

my $regex = <<"EOF";
a(aa)*a+a(aa)*(a+b)((a+b)(aa)*(a+b))*(a+b)(aa)*a +
(b+a(aa)*ab+a(aa)*(a+b)((a+b)(aa)*(a+b))*((a+b)+(a+b)(aa)*ab))
(bb+ba(aa)*ab+((a+b)+ba(aa)*(a+b))((a+b)(aa)*(a+b))*((a+b)+(a+b)(aa)*ab))*
(bb+ba(aa)*ab+((a+b)+ba(aa)*(a+b))((a+b)(aa)*(a+b))*((a+b)(aa)*a))
EOF

$regex = <<"EOF";
((((((((((((((aa)|((aa))*)|(bb))|((bb))*)|((ab)((((aa)|(bb)))*(ab))))|(((ab)
((((aa)|(bb)))*(ab))))*)|((ab)((((aa)|(bb)))*(ba))))|(((ab)((((aa)|(bb)))*
(ba))))*)|((ba)((((aa)|(bb)))*(ab))))|(((ba)((((aa)|(bb)))*(ab))))*)|((ba)
((((aa)|(bb)))*(ba))))|(((ba)((((aa)|(bb)))*(ba))))*))*((aa)|((bb)|
(((ab)((((aa)|(bb)))*(ab)))|(((ab)((((aa)|(bb)))*(ba)))|
(((ba)((((aa)|(bb)))*(ab)))|((ba)((((aa)|(bb)))*(ba)))))))))
EOF

$regex =~ tr{\n }{}d;
$regex =~ tr{+}{|};
$regex =~ s{\(}{(?:}g;

my $r = qr{\A$regex\z};

# like ("", $r, "Empty string");
# TEST
like("aa", $r, "aa");
# TEST
like("bb", $r, "bb");
# TEST
like ("baab", $r, "baab");
# TEST
like ("abab", $r, "abab");
# TEST
like ("abbabb", $r, "abbabb");
# TEST
unlike ("a", $r, "not(a)");
# TEST
unlike ("b", $r, "not(b)");
# TEST
unlike ("ababb", $r, "not(ababb)");
