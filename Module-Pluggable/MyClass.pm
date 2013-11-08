package MyClass;

use strict;
use warnings;

use Module::Pluggable;
use UNIVERSAL::require;

sub new
{
    my $class = shift;
    my $self = {};
    bless $self, $class;
    $self->_initialize(@_);
    return $self;
}

sub _initialize
{
    my $self = shift;
    return 0;
}

sub setup_plugins
{
    my $class = shift;
    my $plugins = shift;
    foreach my $plugin (@$plugins)
    {
        my $plugin_class = "${class}::Plugin::$plugin";
        $plugin_class->require;
        if ($@)
        {
            die $@;
        }
        {
            no strict 'refs';
            push @{"${class}::ISA"}, $plugin_class;
        }
    }
}

1;

