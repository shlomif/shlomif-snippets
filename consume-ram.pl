#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;

# TEST
like( scalar(`ag -s '[ \\t]' .`),
    qr#\A[\r\n]*\z#, "No trailing space was found." );
