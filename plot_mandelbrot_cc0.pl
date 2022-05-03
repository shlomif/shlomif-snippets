# mandel - a function to generate the Mandelbrot Set.
# Written by Shlomi Fish, 2001
#
# This file is under the CC0 / public domain.

use PDL;

# import subprocess
# import numpy as np
# import png


# Assign some default values to the parameters
sub mandel
{
my ($args)=@_;
my $x = ($args->{'x'} // 640);
 my $y = ($args->{'y'} // 640);
 my $num_steps = ($args->{'num_steps'} // 20);
 my $init_value = ($args->{'init_value'} // 0);
 my $max_level = ($args->{'max_level'} // 255);
    xx = np.linspace(-2, 2, x)
    yy = np.linspace(-2, 2, y)
    # Generate the coordinates in the complex plane
    Y, X = np.meshgrid(xx, yy, indexing='ij')
    # Combine them into a matrix of complex numbers
    Z = X + 1j * Y
    # Retrieve the dimensions of Z
    x_len, y_len = zs = Z.shape
    # The length in the x direction
    # The length in the y direction
    # value is initialized to init_value in every point of the plane
    value = np.ones(zs, dtype=complex) * init_value
    # In the beginning all points are considered as part of the Mandelbrot
    # set. Thus, they are initialized to zero.
    ret = np.zeros(zs, dtype=np.uint)
    # The mask which indicates which points have already overflowed, is set
    # to zero, to indicate that none have so far.
    mask = np.zeros(zs, dtype=bool)

    # Perform the check "num_steps" times
    for step in range(num_steps):
        # For every point with a mandel value of "v" and a coordinate of "z"
        # perform  v <- (v ^ 2) + z
        #
        # * is an element-by-element multiplication of two matrixes
        # of the same size.
        value = (value * value) + Z
        # assert value.any()
        # Retrieve the points that overflowed in this iteration
        # An overflowed point has a mandel value with an absolute value greater
        # than 2.
        current_mask = (abs(value) > 2.0)
        # Update the mask. We use "or" in order to avoid a situation where
        # 1 and 1 become two or so.
        mask = np.logical_or(mask, current_mask)
        # Upgrade the points in the mask to a greater value in the returned
        # Mandelbrot-map.
        ret += mask
        # Zero the points that have overflowed, so they will not propagate
        # to infinity.
        value *= np.logical_not(current_mask)

    # Now ret is ready for prime time so we return it.
    ret = (ret * max_level) // num_steps
    return ret
}

mandelbrot_set = mandel(max_level=255, num_steps=255)
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
