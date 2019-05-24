#!/usr/bin/perl

use strict;
use warnings;

package MyModule;

sub new
{
    my $class = shift;
    my $self = {};
    bless $self, $class;
    $self->initialize(@_);
    return $self;
}

sub initialize
{
    return 0;
}

sub create_closure_as_method
{
    my $counter = shift;
    *count = sub {
        my $self = shift;
        my $arg = shift;
        print "${counter}: $arg\n";
        ++$counter;
    };
    return 0;
}

1;

package main;

MyModule::create_closure_as_method(5);

my $obj = MyModule->new();
$obj->count("Foo");
$obj->count("Bar");
$obj->count("Baz");
$obj->count("Quux");

package MySubModule;

use vars (qw(@ISA));

@ISA=(qw(MyModule));

sub create2
{
    my $counter = shift;
    *count = sub {
        my $self = shift;
        my $arg = shift;
        my $inc = shift;
        $self->SUPER::count($arg);
        print "MySub: $counter : $arg\n";
        if ($inc)
        {
            ++$counter;
        }
    };
}

package main;

MySubModule::create2(100);

my $obj2 = MySubModule->new();

$obj2->count("Hello", 1);
$obj2->count("Yard", 0);
$obj2->count("Silly", 1);
$obj2->count("Quack", 0);

1;

