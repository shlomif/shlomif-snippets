#!/usr/bin/perl

package MySuperBase;

use Moose;

package MyBase;

use Moose;

BEGIN
{
    extends('MySuperBase');
}
use MooseX::StrictConstructor;


has 'one' => (is => "rw", isa => "Str");

package MyClass;

use Moose;

extends ('MyBase');

# Uncomment to get the test to pass.
# with ("MooseX::StrictConstructor::Role::Object");
has 'field1' => (is => "rw", isa => "Str");
has 'field2' => (is => "rw", isa => "Str");

package main;

use strict;
use warnings;

use Test::More tests => 2;

{
    my $self;

    eval {
    # Does not crash.
    $self = MyClass->new(
        {
            'field1' => "MyValue 1",
            'non_existent' => "iSuck",
        }
    );
    };

    my $err = $@;

    # TEST
    like ($err, qr{\AFound unknown attribute},
        "Throws an exception."
    );

    # TEST
    ok (!defined($self), "Object was not initialized.");
}

