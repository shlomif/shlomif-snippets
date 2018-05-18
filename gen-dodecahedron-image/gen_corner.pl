#!/usr/bin/perl

use strict;
use warnings;

use Vector;
use POSIX;

my $pi = atan2( 1, 1 ) * 4;

open my $fh, '>', 'corner.txt';

sub p_line
{
    my ( $v1, $v2, $rgb ) = @_;
    my $v3 = $v1 + $v2;
    print {$fh}
        join( " ", $v1->to_2d(), $v3->to_2d(), $rgb ? @{$rgb} : ( 0, 0, 0 ) ),
        "\n";
}

my ( @horiz, $vert, $source );

$horiz[0] = new Vector( 10, -2, 5 );

#$vert = ((new Vector(0, -1, 0)) * $horiz[0])*$horiz[0];
$vert = ( ( new Vector( 0, -1, 1 ) ) * $horiz[0] ) * $horiz[0];
my $r = cos( $pi / 6 ) / sin( $pi * 3 / 5 / 2 );
$vert *= $horiz[0]->len() * sqrt( $r * $r - 1 ) / $vert->len();
$horiz[1] = $horiz[0]->rotate( $vert, $pi * 2 / 3 );
$horiz[2] = $horiz[0]->rotate( $vert, -$pi * 2 / 3 );
$source = new Vector( 0, 0, 0 );

p_line( $source, $horiz[0], [ 0,   255, 0 ] );
p_line( $source, $horiz[1] );
p_line( $source, $horiz[2] );
p_line( $source, $vert,     [ 255, 0,   0 ] );

$vert->p();
$horiz[0]->p();

close($fh);
__END__

=head1 COPYRIGHT & LICENSE

Copyright 2018 by Shlomi Fish

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
