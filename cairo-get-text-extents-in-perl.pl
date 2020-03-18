#! /usr/bin/env perl
#
# Author Shlomi Fish <shlomif@cpan.org>
# Version 0.0.1
#

=head1 ABOUT

Cairo program to get the text extents:

=over 4

=item * L<https://www.cairographics.org/manual/cairo-text.html>

=item * L<https://metacpan.org/pod/Cairo>

=back

=cut

use strict;
use warnings;
use 5.014;
use autodie;

use Cairo ();

my $surface = Cairo::ImageSurface->create( 'argb32', 2000, 1000 );
my $cr      = Cairo::Context->create($surface);
$cr->select_font_face( "Arial", "normal", "bold" );
$cr->set_font_size(16);
my $extents = $cr->text_extents("Hello");

use Data::Dumper qw/ Dumper /;
print Dumper( [$extents] );

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
