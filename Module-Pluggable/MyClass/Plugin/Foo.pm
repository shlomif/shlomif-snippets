package MyClass::Plugin::Foo;

use strict;
use warnings;

sub foo
{
    my $self = shift;
    my ($i, $j) = @_;
    return ($i+$j);
}

1;
