#!/usr/bin/perl

use strict;
use warnings;

package MyClass;

sub new
{
    my $class = shift;
    my $self = {};
    bless $self, $class;

    $self->{msg} = shift;

    return $self;
}

our $self;

sub add_implicit_self
{
    my $sub_name = shift;
    my $sub_ref = \&{$sub_name};
    {
        no strict 'refs';
        no warnings 'redefine';

        ${__PACKAGE__."::"}{$sub_name} = sub {
            local $self = shift;
            return $sub_ref->(@_);
        };
    }
}

sub print_message
{
    my $uc = shift;

    my $msg = $self->{msg};
    if ($uc)
    {
        $msg = uc($msg);
    }

    print "$msg\n";
}

sub set_message
{
    $self->{msg} = shift;
}

add_implicit_self('print_message');
add_implicit_self('set_message');

package main;

my $o1 = MyClass->new("Hello");
$o1->print_message();

my $o2 = MyClass->new("Naomi");
$o2->print_message(1);
$o2->print_message();

$o1->set_message("Yowza");
$o1->print_message(1);

