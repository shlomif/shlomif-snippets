#!/usr/bin/perl

use strict;
use warnings;

package Parent;

sub mycaller
{
    print "Hello\n";
    mycalled();
}

sub mycalled
{
    print "Parent::mycalled() is here!\n";
}

package Child;

our @ISA = (qw(Parent));

sub mycalled
{
    print "Child::mycalled is here!\n";
}

sub call_mycaller
{
    __PACKAGE__->mycaller();
}

package main;

Child::call_mycaller();

1;

