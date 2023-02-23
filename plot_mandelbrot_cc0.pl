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

# Assign some default values to the parameters
sub _linspace
{
    my ( $aa, $bb, $n ) = @_;

    return zeroes($n)->xlinvals( $aa, $bb );
}

sub _meshgrid
{
    my ( $xx, $yy, $n ) = @_;
    my $x = ones( $yy->dims() )->transpose() x $xx;
    my $y = $yy->transpose() x ones( $xx->dims() );
    return ( $x, $y );
}

sub mandel
{
    my ($args)     = @_;
    my $x          = ( $args->{'x'}          // 640 );
    my $y          = ( $args->{'y'}          // 640 );
    my $num_steps  = ( $args->{'num_steps'}  // 20 );
    my $init_value = ( $args->{'init_value'} // 0 );
    my $max_level  = ( $args->{'max_level'}  // 255 );
    my $xx         = _linspace( -2, 2, $x );
    my $yy         = _linspace( -2, 2, $y );

    # Generate the coordinates in the complex plane
    my ( $X, $Y ) = _meshgrid( $xx, $yy, );
    say $X->at( 0, 90 );
    say $Y->info;
    say $Y->at( 90, 0 );

    # Combine them into a matrix of complex numbers
    my $Z = $X + pdl('i') * $Y;
    say "Z:", $Z->info;

    # Retrieve the dimensions of Z
    # my ( $x_len, $y_len ) = ( my @zs ) = $Z->dims();
    ( my @zs ) = $Z->dims();

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
        $value = ( $value * $value ) + $Z;

        # assert value.any()
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

# my $mandelbrot_set = mandel( { max_level => 255, num_steps => 20, } );
my $ret = mandel( { max_level => 255, num_steps => 20, } );

my $greyscale_fn = "mandelperl.bmp";

# wimage( $mandelbrot_set, $greyscale_fn );
my $command = sprintf( "gm convert -depth 8 -size %lux%lu+0 gray:%s %s",
    $ret->{r_width}, $ret->{i_height}, $ret->{filename}, $greyscale_fn );
system($command);
system( "gwenview", $greyscale_fn );

=begin removed

mandelbrot_set = mandelbrot_set.astype('uint8')
m = np.repeat(mandelbrot_set, 3, axis=1)
gradient = "Tropical Colors"
greyscale_fn = "mandel.png"
# colored_fn = "mandel_colored.png"
colored_fn = greyscale_fn
png.from_array(m, 'RGB').save(greyscale_fn)

subprocess.check_call(
    [
        "gimp",  greyscale_fn,
        # "gimp-2.99",  greyscale_fn,
        "--no-interface",
        "--batch-interpreter=python-fu-eval",
        "-b",
        ('img = gimp.image_list()[0]\n' +
         'draw=img.active_drawable\n' +
         'pdb.gimp_context_set_gradient("{gradient}")\n' +
         'pdb.plug_in_gradmap(img, draw)\n' +
         'pdb.gimp_file_save(img, draw, "{colored_fn}", "{colored_fn}")\n' +
         'pdb.gimp_quit(1)\n'
         ).format(
             colored_fn=colored_fn,
             gradient=gradient,
         )
    ]
)

subprocess.check_call(["gwenview", colored_fn])
=cut
