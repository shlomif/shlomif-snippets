#!/usr/bin/perl

use strict;
use warnings;
use autodie;
use Path::Tiny qw/ path /;

use HTML::StripScripts::Parser;

{

    package My::StripScripts;
    use base qw(HTML::StripScripts::Parser);

    sub validate_href_attribute
    {
        my ( $self, $text ) = @_;

        my $ret = $self->SUPER::validate_href_attribute($text);
        if ($ret)
        {
            return $ret;
        }
        if ( $text =~ m#^[\.\/\w\-]{1,100}$# )
        {
            return $text;
        }
    }
}

sub strip_file
{
    my $filename = shift;
    my $hss      = My::StripScripts->new(
        {
            Context   => 'Document',
            AllowSrc  => 1,
            AllowHref => 1,
        },
    );

    $hss->parse_file($filename);
    path("$filename.js-less")->spew_utf8( $hss->filtered_document() );
}

my $filename = shift;
strip_file($filename);
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
