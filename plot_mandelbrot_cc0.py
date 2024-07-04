# mandel - a function to generate the Mandelbrot Set.
# Written by Shlomi Fish, 2001
#
# This file is under the CC0 / public domain.

import subprocess

import numpy as np

# import png

r_width, i_height = 640, 640


# Assign some default values to the parameters
def mandel(x=r_width, y=i_height, num_steps=20, init_value=0, max_level=255):
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


def int_mandel(x=r_width, y=i_height, num_steps=20,
               init_value=0, max_level=255):
    BASE = 100000
    BASE = (1 << 20)
    MAX_NORM = BASE * BASE * 2
    if BASE == (1 << 20):
        def BASE_DIV(mat):
            return mat >> 20
    else:
        def BASE_DIV(mat):
            return mat / BASE

    xx = np.linspace(-2*BASE, 2*BASE, x, dtype=np.longlong)
    yy = np.linspace(-2*BASE, 2*BASE, y, dtype=np.longlong)
    # Generate the coordinates in the complex plane
    # Y, X = np.meshgrid(xx, yy, indexing='ij', dtype=np.longlong)
    Y, X = np.meshgrid(xx, yy, indexing='ij')
    # Combine them into a matrix of complex numbers
    # Z = X + 1j * Y
    # Retrieve the dimensions of Z
    x_len, y_len = zs = X.shape
    # The length in the x direction
    # The length in the y direction
    # value is initialized to init_value in every point of the plane
    value_re = np.ones(zs, dtype=np.longlong) * init_value
    value_im = np.ones(zs, dtype=np.longlong) * init_value
    # In the beginning all points are considered as part of the Mandelbrot
    # set. Thus, they are initialized to zero.
    ret = np.zeros(zs, dtype=np.longlong)
    # The mask which indicates which points have already overflowed, is set
    # to zero, to indicate that none have so far.
    mask = np.zeros(zs, dtype=np.uint)

    # Perform the check "num_steps" times
    for step in range(num_steps):
        # For every point with a mandel value of "v" and a coordinate of "z"
        # perform  v <- (v ^ 2) + z
        #
        # * is an element-by-element multiplication of two matrixes
        # of the same size.
        # value = (value * value) + Z
        value_re, value_im = (
            (BASE_DIV(value_re * value_re - value_im * value_im))+X,
            (BASE_DIV(2 * value_re * value_im))+Y,
        )
        # assert value.any()
        # Retrieve the points that overflowed in this iteration
        # An overflowed point has a mandel value with an absolute value greater
        # than 2.
        current_mask = ((value_re * value_re + value_im * value_im) > MAX_NORM)
        # Update the mask. We use "or" in order to avoid a situation where
        # 1 and 1 become two or so.
        # mask = np.logical_or(mask, current_mask, dtype=np.longlong)
        mask = np.logical_or(mask, current_mask)
        # Upgrade the points in the mask to a greater value in the returned
        # Mandelbrot-map.
        ret += mask
        # Zero the points that have overflowed, so they will not propagate
        # to infinity.
        # value_re *= np.logical_not(current_mask, dtype=np.longlong)
        value_re *= np.logical_not(current_mask)
        value_im *= np.logical_not(current_mask)

    # Now ret is ready for prime time so we return it.
    ret = (ret * max_level) // num_steps
    return ret


def main():
    # mandelbrot_set = mandel(max_level=255, num_steps=255)
    mandelbrot_set = int_mandel(max_level=255, num_steps=255)
    mandelbrot_set = mandelbrot_set.astype('uint8')
    # m = np.repeat(mandelbrot_set, 3, axis=1)
    gradient = "Tropical Colors"
    greyscale_fn = "mandelpy.dat"
    # colored_fn = "mandel_colored.png"
    # png.from_array(m, 'RGB').save(greyscale_fn)
    mandelbrot_set.tofile(greyscale_fn)
    greyscale_bmp = "mandelpy.bmp"
    colored_fn = greyscale_bmp
    subprocess.check_call(
        [
            "gm", "convert", "-depth", "8", "-size",
            "{}x{}+0".format(r_width, i_height),
            "gray:"+greyscale_fn, greyscale_bmp,
        ]
    )
    subprocess.check_call(
        [
            "gimp",  greyscale_bmp,
            # "gimp-2.99",  greyscale_fn,
            "--no-interface",
            "--batch-interpreter=python-fu-eval",
            "-b",
            ('img = gimp.image_list()[0]\n' +
             'draw=img.active_drawable\n' +
             'pdb.gimp_context_set_gradient("{gradient}")\n' +
             'pdb.plug_in_gradmap(img, draw)\n' +
             'pdb.gimp_file_save(\n' +
             '    img, draw, "{colored_fn}", "{colored_fn}")\n' +
             'pdb.gimp_quit(1)\n'
             ).format(
                 colored_fn=colored_fn,
                 gradient=gradient,
             )
        ]
    )

    subprocess.check_call(["gwenview", colored_fn])


main()
