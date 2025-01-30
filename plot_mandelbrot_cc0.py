# mandel - a function to generate the Mandelbrot Set.
# Written by Shlomi Fish, 2001
#
# This file is under the CC0 / public domain.

import subprocess

import numpy as np

# import png

r_width, i_height = 640, 640

# inspired by https://github.com/akkana/gimp-plugins/blob/master/gimp3/saver.py
# thanks


# Assign some default values to the parameters
def mandel(x=r_width, y=i_height, num_steps=20, init_value=0, max_level=255,
           startx=-2.0, endx=2.0, starty=-2.0, endy=2.0):
    xx = np.linspace(startx, endx, x)
    yy = np.linspace(starty, endy, y)
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

    sq_value_re = value_re * value_re
    sq_value_im = value_im * value_im

    # Perform the check "num_steps" times
    for step in range(num_steps):
        # For every point with a mandel value of "v" and a coordinate of "z"
        # perform  v <- (v ^ 2) + z
        #
        # * is an element-by-element multiplication of two matrixes
        # of the same size.
        # value = (value * value) + Z
        value_re, value_im = (
            (BASE_DIV(sq_value_re - sq_value_im))+X,
            (BASE_DIV(2 * value_re * value_im))+Y,
        )
        # assert value.any()
        # Retrieve the points that overflowed in this iteration
        # An overflowed point has a mandel value with an absolute value greater
        # than 2.
        current_mask = ((sq_value_re + sq_value_im) > MAX_NORM)
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

        sq_value_re = value_re * value_re
        sq_value_im = value_im * value_im

    # Now ret is ready for prime time so we return it.
    ret = (ret * max_level) // num_steps
    return ret


GIMP_WRAPPER_FUNCS = '''
import gi
gi.require_version("Gimp", "3.0")
from gi.repository import Gimp
pdb = Gimp.get_pdb()

def gimp_wrap_run_pdb(pdb, name, kv):
    pdb_proc = pdb.lookup_procedure(name)
    pdb_config = pdb_proc.create_config()
    for k, v in kv.items():
        if isinstance(k, tuple):
            ktype, k = k
            assert ktype == "array"
            pdb_config.set_core_object_array(k, v)
        else:
            pdb_config.set_property(k, v)
    result = pdb_proc.run(pdb_config)
    arr = [result.index(i) for i in range(result.length())]
    return arr

def gimp_wrap_file_save(pdb, img, filepath):
    result = gimp_wrap_run_pdb(pdb, "gimp-file-save", {
    "file": Gio.File.new_for_path(filepath),
    "image": img,
    "run-mode": Gimp.RunMode.NONINTERACTIVE,
    })
    return result

def _only1(lst):
    assert(len(lst) == 1)
    ret = lst[0]
    return ret
'''


def main():
    extents = {
        'startx': -0.5,
        'endx': 0.5,
        'starty': -0.5,
        'endy': 0.5,
    }
    mandelbrot_set = mandel(max_level=255, num_steps=255, **extents)
    mandelbrot_set = mandel(max_level=255, num_steps=255,)
    # mandelbrot_set = int_mandel(max_level=255, num_steps=255)
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
            "--quit",
            "--no-interface",
            "--batch-interpreter=python-fu-eval",
            "-b",
            ('''
{GIMP_WRAPPER_FUNCS}
gradient_name = "{gradient}"
colored_fn = "{colored_fn}"

images = Gimp.get_images()
img = _only1(images)
layers = img.get_layers()
draw = _only1(layers)
gradient = Gimp.Gradient.get_by_name(gradient_name)
Gimp.context_set_gradient(gradient)
result = gimp_wrap_run_pdb(pdb, "plug-in-gradmap", {{
("array", "drawables"):
[draw, ],
"image": img,
"run-mode": Gimp.RunMode.NONINTERACTIVE,
}})
gimp_wrap_file_save(
    pdb, img, colored_fn)
# Gimp.get_pdb().gimp_quit(1)
''').format(
                 colored_fn=colored_fn,
                 gradient=gradient,
                 GIMP_WRAPPER_FUNCS=GIMP_WRAPPER_FUNCS,
             )
        ]
    )
    # raise "gimp was invoked"

    subprocess.check_call(["gwenview", colored_fn])


main()
