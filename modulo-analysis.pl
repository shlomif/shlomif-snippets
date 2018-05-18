#!/usr/bin/perl

use strict;
use warnings;

my $formula1 = shift(@ARGV);
my $formula2 = shift(@ARGV);

my @formulas = ( $formula1, $formula2 );

for my $base ( 2 .. 101 )
{
    my @results;
    for my $formula_idx ( 0 .. 1 )
    {
        my %found;
        for my $start_mod ( 0 .. $base - 1 )
        {
            local $_ = $start_mod;
            my $r = eval( $formulas[$formula_idx] . '' );
            push @{ $found{ $r % $base } }, $start_mod;
        }
        push @results, \%found;
    }
    print "Base $base ", join(
        ";",
        map {
            my $x = $_;
            "["
                . join( ",",
                map { $_ . " {" . join( "|", @{ $x->{$_} } ) . "} " }
                sort { $a <=> $b } keys($_) )
                . "]"
        } @results
        ),
        "\n";

    my $found = 0;
    foreach my $final_m ( sort { $a <=> $b } keys( %{ $results[0] } ) )
    {
        if ( exists( $results[1]->{$final_m} ) )
        {
            $found = 1;
        }
    }

    if ( !$found )
    {
        die
"For base $base , there are no valid solutions for the two formulas.";
    }
}
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
