#!/usr/bin/perl

use strict;
use warnings;
use HTML::TreeBuilder 5; # Ensure weak references in use

foreach my $file_name (@ARGV) {
  my $tree = HTML::TreeBuilder->new; # empty tree
  $tree->parse_file($file_name);
  # print "Hey, here's a dump of the parse tree of $file_name:\n";
  # $tree->dump; # a method we inherit from HTML::Element
  foreach my $e ($tree->look_down(_tag => "style")) {
      $e->delete();
  }
  foreach my $e ($tree->look_down(_tag => "link", rel => "stylesheet")) {
      $e->delete();
  }
  print "And here it is, bizarrely rerendered as HTML:\n",
    $tree->as_HTML, "\n";

  # Now that we're done with it, we must destroy it.
  $tree = $tree->delete; # Not required with weak references
}

