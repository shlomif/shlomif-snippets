# mandel - a function to generate the Mandelbrot Set.
# Written by Shlomi Fish, 2001
#
# This file is under the CC0 / public domain.

use strict;
use warnings;
use 5.014;

use PDL;

# use PDL::IO::Image qw/ wimage /;
# use PDL::IO qw/ wimage /;
use PDL::IO::FastRaw qw/ writefraw /;

sub _linspace
{
    my ( $aa, $bb, $n ) = @_;

    return zeroes($n)->xlinvals( $aa, $bb );
}

sub _len
{
    my ($vec) = @_;

    return +( $vec->dims() )[0];
}

sub _meshgrid
{
    my ( $xx, $yy, $n ) = @_;

    # my $x2  = ones( $yy->dims() )->transpose() x $xx;
    my $x = $xx->dummy( 1, _len($yy) );

    # my $y2 = $yy->transpose() x ones( $xx->dims() );
    my $y = $yy->dummy( 0, _len($xx) );

    return ( $x, $y );
}

sub mandel
{
    my ($args) = @_;

    # Assign some default values to the parameters
    my $x          = ( $args->{'x'}          // 640 );
    my $y          = ( $args->{'y'}          // 640 );
    my $num_steps  = ( $args->{'num_steps'}  // 20 );
    my $init_value = ( $args->{'init_value'} // 0 );
    my $max_level  = ( $args->{'max_level'}  // 255 );

    # Generate the coordinates in the complex plane
    my $xx = _linspace( -2, 2, $x );
    my $yy = _linspace( -2, 2, $y );
    my ( $X, $Y ) = _meshgrid( $xx, $yy, );

    # Combine them into a matrix of complex numbers
    my $Z = $X + pdl('i') * $Y;
    say "Z:", $Z->info;

    # Retrieve the dimensions of Z
    my @zs = $Z->dims();

    # value is initialized to init_value in every point of the plane
    my $value = ones( cdouble(), @zs ) * $init_value;

    # In the beginning all points are considered as part of the Mandelbrot
    # set. Thus, they are initialized to zero.
    my $ret = zeros( ushort(), @zs );

    # The mask which indicates which points have already overflowed, is set
    # to zero, to indicate that none have so far.
    my $mask = zeros( byte(), @zs );

    foreach my $step ( 1 .. $num_steps )
    {
        print "step=$step ", $ret->info, "\n";

        # For every point with a mandel value of "v" and a coordinate of "z"
        # perform  v <- (v ^ 2) + z
        #
        # * is an element-by-element multiplication of two matrixes
        # of the same size.
        if (0)
        {
            $value = ( $value * $value ) + $Z;
        }
        else
        {
            ( $value *= $value ) += $Z;
        }

        # Retrieve the points that overflowed in this iteration
        # An overflowed point has a mandel value with an absolute value greater
        # than 2.
        my $current_mask = ( abs($value) > 2.0 );

        # Update the mask. We use "or" in order to avoid a situation where
        # 1 and 1 become two or so.
        $mask |= $current_mask;

        # Upgrade the points in the mask to a greater value in the returned
        # Mandelbrot-map.
        $ret += $mask;

        # Zero the points that have overflowed, so they will not propagate
        # to infinity.
        $value *= ~($current_mask);
    }

    # Now ret is ready for prime time so we return it.
    die "end1" if not $ret->at( 0, 0 );
    $ret = ( ( ( $ret * $max_level ) / $num_steps )->ushort );
    die "end2" if not $ret->at( 0, 0 );
    $ret = $ret->byte();
    my $r = +{};
    ( $r->{r_width}, $r->{i_height} ) = @zs;
    $r->{filename} =
        sprintf( "f_rw=%lu_iw=%lu.img", $r->{r_width}, $r->{i_height} );
    writefraw( $ret, $r->{filename} );    # write a raw file
    return $r;
}

sub example
{
    my $mandel = mandel( { max_level => 255, num_steps => 80, } );

    my $greyscale_fn = "mandelperl.bmp";

    # wimage( $mandelbrot_set, $greyscale_fn );
    my $command = sprintf(
        "gm convert -depth 8 -size %lux%lu+0 gray:%s %s",
        $mandel->{r_width},  $mandel->{i_height},
        $mandel->{filename}, $greyscale_fn
    );
    system($command);
    system( "gwenview", $greyscale_fn );

    return;
}

example();
