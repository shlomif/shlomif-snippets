package MyClass::Plugin::Hello;

use strict;
use warnings;

sub hello
{
    my $self = shift;
    print "Hello " . $self->{'hello'} . "!\n";
}

1;

