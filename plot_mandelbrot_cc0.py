# mandel - a function to generate the Mandelbrot Set.
# Written by Shlomi Fish, 2001
#
# This file is under the public domain.

import numpy as np


# Assign some default values to the parameters
# nargin is an internal Matlab variable that specifies how many
# parameters were passed to the function.
def mandel(x=100, y=100, steps=20, init_value=0):
    xx = np.linspace(-2, 2, x)
    yy = np.linspace(-2, 2, y)
    # Generate the coordinates in the complex plane
    X, Y = np.meshgrid(xx, yy, indexing='ij')
    # Combine them into a matrix of complex numbers
    Z = X+1j*Y
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

    # Perform the check "steps" times
    for step in range(steps):
        # For every point with a mandel value of "v" and a coordinate of "z"
        # perform  v <- (v ^ 2) + z
        #
        # .* is an element-by-element multiplication of two matrixes
        # of the same size.
        # (regular * indicates matrix multiplication)
        value = (value * value) + Z
        # Retrieve the points that overflowed in this iteration
        # An overflowed point has a mandel value with an absolute value greater
        # than 2.
        current_mask = (abs(value) > 2)
        # Update the mask. We use "or" in order to avoid a situation where
        # 1 and 1 become two or so.
        mask = np.logical_or(mask, current_mask)
        # Upgrade the points in the mask to a greater value in the returned
        # Mandelbrot-map.
        ret = ret + mask
        # Zero the points that have overflowed, so they will not propagate
        # to infinity.
        value = value * np.logical_not(current_mask)

    # Now ret is ready for prime time so we return it.
    return ret


print(mandel())
