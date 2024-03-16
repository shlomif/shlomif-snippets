package MyProxy;

use strict;
use warnings;

package MyProxy::Hash;

require Tie::Hash;

use vars qw(@ISA);

@ISA = qw(Tie::ExtraHash);

sub STORE
{
    my ( $self, $key, $value ) = (@_);
    if ( $key ne "**PROXIED**" )
    {
        die "Illegal hash assignment called from "
            . join( "::", caller ) . "\n";
    }
    $self->SUPER::STORE( $key, $value );
}

sub FETCH
{
    my ( $self, $key ) = (@_);
    if ( $key ne "**PROXIED**" )
    {
        die "Illegal hash fetching called from " . join( "::", caller ) . "\n";
    }
    return $self->SUPER::FETCH($key);
}

sub EXISTS
{
    my ( $self, $key ) = (@_);
    die "Illegal exists() called from " . join( "::", caller ) . "\n";
}

package MyProxy;

use strict;
use warnings;

use vars qw($AUTOLOAD);

sub new
{
    my $class = shift;
    my %hash;
    tie %hash, "MyProxy::Hash";
    my $self = \%hash;

    bless( $self, $class );

    $self->initialize(@_);

    return $self;
}

sub initialize
{
    my $self          = shift;
    my $proxied_class = shift;

    $self->{'**PROXIED**'} = $proxied_class->new(@_);

    return 0;
}

sub AUTOLOAD
{
    my $self      = shift;
    my $func_name = $AUTOLOAD;
    $func_name =~ s!^MyProxy::!!;
    return $self->{'**PROXIED**'}->$func_name(@_);
}

1;

