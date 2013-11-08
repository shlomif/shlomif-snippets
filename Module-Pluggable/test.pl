#!/usr/bin/perl

use strict;
use warnings;

use MyClass;

MyClass->setup_plugins(["OtherHello", "Hello", "Foo"]);

my $mc = MyClass->new();
my @plugins = $mc->plugins();

print "plugins=", join(", ", @plugins), "\n";
$mc->{'hello'} = "Shlomi";
$mc->hello();
my $ret = $mc->foo(3,4);
print "\$ret = ", $ret, "\n";

