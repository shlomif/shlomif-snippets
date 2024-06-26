#!/usr/bin/perl

package Vector;

use strict;
use warnings;

use overload '+' => sub {
    my @coords;
    my ($v1, $v2) = @_;
    my $c1 = $v1->{coords};
    my $c2 = $v2->{coords};
    for my $pos (0 .. 2)
    {
        push @coords, $c1->[$pos] +$c2->[$pos];
    }
    return Vector->new(@coords);
    },
    '*' => sub {
    if ( ( ref( $_[1] ) eq 'Vector' ) && ( ref( $_[0] ) ne 'Vector' ) )
    {
        return $_[1] * $_[0];
    }
    elsif ( ref( $_[1] ) eq 'Vector' )
    {
        my @a = @{ $_[0]->{coords} };
        my @b = @{ $_[1]->{coords} };
        return new Vector(
            $a[1] * $b[2] - $a[2] * $b[1],
            $a[2] * $b[0] - $a[0] * $b[2],
            $a[0] * $b[1] - $a[1] * $b[0]
        );
    }
    else
    {
        return Vector->new( map { $_ * $_[1]; } @{ $_[0]->{coords} } );
    }
    },
    '/' => sub {
    return Vector->new( map { $_ / $_[1]; } @{ $_[0]->{coords} } );
    },
    '-' => sub {
    return $_[0] + (-1) * $_[1];
    },
    ;

sub _initialize
{
    my $self = shift;
    $self->{coords} = [ 0, 0, 0 ];
    return;
}

sub new
{
    my $class = shift;
    my $self  = {};
    bless $self, $class;
    $self->_initialize();

    if ( ref( $_[0] ) eq 'Vector' )
    {
        $self->{coords} = [ @{ $_[0]->{coords} } ];
    }
    else
    {
        my @a = ( @_, 0, 0, 0 );
        $self->{coords} = [ @a[ 0 .. 2 ] ];
    }

    return $self;
}

sub len
{
    my $self = shift;
    my $sum  = 0;
    foreach my $x ( @{ $self->{coords} } )
    {
        $sum += $x * $x;
    }
    return sqrt($sum);
}

sub to_2d
{
    my $a_len = 800;
    my $b_len = 100;
    my $self  = shift();
    my @a     = @{ $self->{coords} };
    return (
        int( $a[0] * $a_len / ( $a[2] + $b_len ) ) + 100,
        int( $a[1] * $a_len / ( $a[2] + $b_len ) ) + 100
    );
}

sub rotate
{
    my $self  = shift(@_);
    my $other = shift(@_);
    my $angle = shift(@_);

    my $perpend = ( $other * $self );
    $perpend *= $self->len() / $perpend->len();

    return ( cos($angle) * $self + sin($angle) * $perpend );
}

sub p
{
    my $self = shift(@_);
    print join( " ", @{ $self->{coords} } ), " ", $self->len(), "\n";
}

1;
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
