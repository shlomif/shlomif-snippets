#!/usr/bin/perl -C

# Code by Shlomi Fish, mauke, and simcop2387 for detecting the directionality
# of a string based on the first letter that has meaningful directionality.
#

use strict;
use warnings;

use Data::Dump;
use Encode qw(decode);

sub directionality
{
    my $string = shift;

    if (my ($match) = $string =~ /([\p{Bidi_Class:L}\p{Bidi_Class:R}])/)
    {
        return (($match =~ /\A\p{Bidi_Class:L}/) ? "L" : "R");
    }
    else
    {
        return "N";
    }
}

my $text = decode('UTF-8', shift(@ARGV));

my %verdicts = ("L" => "LTR", "R" => "RTL", "N" => "Neutral");

print $verdicts{directionality($text)}, "\n";

=head1 COPYRIGHT

Copyright 2012 by Shlomi Fish

This program is distributed under your choice of:

1. The MIT (X11) License:
L<http://www.opensource.org/licenses/mit-license.php>

2. The Public Domain as defined by Creative Commons Zero 1.0 Universal
(CC0 1.0) (or at your option any later version):

L<http://creativecommons.org/publicdomain/zero/1.0/>

=head2 MIT License

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

=head2 CC0 1.0 Universal

The person who associated a work with this deed has dedicated the work to the
public domain by waiving all of his or her rights to the work worldwide under
copyright law, including all related and neighboring rights, to the extent
allowed by law.

You can copy, modify, distribute and perform the work, even for commercial
purposes, all without asking permission. See Other Information below.

=cut
