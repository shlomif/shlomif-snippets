#!/usr/bin/perl

use strict;
use warnings;

package MyClass;

use base 'Class::Accessor';

__PACKAGE__->mk_accessors(qw(lines c_idx));

use Carp;

sub new
{
    my $class = shift;
    my $self = {};

    bless $self, $class;

    $self->lines([
        qq{[Bashir, Dax and Jake are standing watching the space.]\n},
        qq{Dax: yep, space. Nothing but nothing all around.\n},
        qq{Q2: oh the "Big Bang". We don't call it that. The big bang was in fact an\n},
    ]);

    $self->c_idx(0);

    return $self;
}

sub _c
{
    my $self = shift;

    return $self->lines()->[$self->c_idx()];
}

sub _parse
{
    my $self = shift;

    $self->_c() =~ m{\A}g;

    if (   ($self->_c() =~ m{\G.*Jake}g)
        && ($self->_c() =~ m{\G.*(watch\w+)}g))
    {
        print "Yes $1\n";
    }
    else
    {
        confess "You suck!";
    }

    return 0;
}

package main;

exit(MyClass->new()->_parse());

