#! /usr/bin/env perl
#
# Author Shlomi Fish <shlomif@cpan.org>
# Version 0.0.1
#
use strict;
use warnings;
use 5.014;
use autodie;

use Path::Tiny qw/ path tempdir tempfile cwd /;

use Cairo ();

my $surface = Cairo::ImageSurface->create( 'argb32', 2000, 1000 );
my $cr      = Cairo::Context->create($surface);
$cr->select_font_face( "Arial", "normal", "bold" );
$cr->set_font_size(16);
my $extents = $cr->text_extents("Hello");

use Data::Dumper qw/ Dumper /;
print Dumper( [$extents] );
