package GenerateMantra;

use strict;
use warnings;
#
# Short description for GenerateMantra.pm
#
# Author Shlomi Fish <shlomif@cpan.org>
# Version 0.1
# Copyright (C) 2024 Shlomi Fish <shlomif@cpan.org>
# Modified On 2024-03-30 04:24
# Created  2024-03-30 04:24
#

use Moo;

use List::Util qw( sum );

sub permute
{
    my ( $self, $arr, $p ) = @_;

    my $total    = sum( keys(@$arr) );
    my $s        = sum(@$p);
    my $lastitem = $total - $s;

    my @pos = ( @$p, $lastitem );
    my @ret = ( @$arr[@pos] );

    return \@ret;
}

1;

# __END__
# # Below is stub documentation for your module. You'd better edit it!
