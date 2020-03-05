#!/usr/bin/perl

use strict;
use warnings;

use SVG ();

# TODO : Fix the case where $width != $height.
my $width  = 300;
my $height = $width;

my $svg = SVG->new( width => $width, height => $height, );

my $big_group    = $svg->group( style => { 'color' => "red" } );
my $inner_group1 = $big_group->group( style => { 'stroke' => "green" } );
my $inner_group2 = $big_group->group( style => { 'stroke' => "blue" } );
$inner_group1->rectangle( x => 2,   y => 2,   width => 100, height => 100 );
$inner_group2->rectangle( x => 100, y => 100, width => 100, height => 100 );

my $text = $svg->xmlify( -namespace => "svg" );

# Workaround for Mozilla.
# $text =~ s{xmlns=}{xmlns:svg=};
print $text;

__END__

=head1 COPYRIGHT & LICENSE

Copyright 2020 by Shlomi Fish

This program is distributed under the MIT / Expat License:
L<http://www.opensource.org/licenses/mit-license.php>

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

=cut
