use strict;
use warnings;

my $text = <<'END_OF_STRING';
T2_DOCS = humour/by-others/was-the-death-star-attack-an-inside-job/index.html humour/fortunes/friends.html humour/fortunes/index.html humour/fortunes/joel-on-software.html humour/fortunes/nyh-sigs.html humour/fortunes/osp_rules.html humour/fortunes/paul-graham.html humour/fortunes/sharp-perl.html humour/fortunes/sharp-programming.html humour/fortunes/shlomif-factoids.html humour/fortunes/shlomif-fav.html humour/fortunes/shlomif.html humour/fortunes/subversion.html humour/fortunes/tinic.html humour/human-hacking/arabic-v2.html humour/human-hacking/conclusions/index.html humour/human-hacking/hebrew-v2.html
T2_TTMLS =
VIPE_IMAGES =
VIPE_DIRS =
VIPE_DOCS = index.html
VIPE_TTMLS =
END_OF_STRING

if ( $ENV{BUG} )
{
    print +( $text =~
            s!^(T2_DOCS = )([^\n]*)!$1 . ($2 =~ s#\bhumour/fortunes/##gr)!emrs )
        =~ /T2_DOCS/g;
}
else
{
    print +( $text =~ s!^(T2_DOCS = )([^\n]*)!$1 . $2!emrs ) =~ /T2_DOCS/g;
}
print "\n";

=head1 COPYRIGHT & LICENSE

Copyright 2014 by Shlomi Fish

This program is distributed under the MIT (X11) License:
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
