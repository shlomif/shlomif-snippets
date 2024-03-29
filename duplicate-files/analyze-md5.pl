#!/usr/bin/perl

use strict;
use warnings;

my $prev = "Z";
my @fns;

sub duplicates
{
    if ( @fns >= 2 )
    {
        print( map { "$_\n" } @fns );
        print "\n";
    }
    $#fns = -1;
}

while (<>)
{
    chomp;
    if ( my ( $checksum, $filename ) = /\A([0-9a-fA-F]+)\s+(\S.*)\z/ )
    {
        if ( $checksum ne $prev )
        {
            duplicates();
        }

        $prev = $checksum;
        push @fns, $filename;
    }
}

duplicates();

__END__

=head1 COPYRIGHT & LICENSE

Copyright 2022 by Shlomi Fish

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
