package MyClass::Plugin::OtherHello;

use strict;
use warnings;
use NEXT;

sub hello
{
    my $self = shift;

    $self->NEXT::hello(@_);

    print "Shalom " . $self->{'hello'} . "!\n";
}

1;

