"""
Mandelbrot set
==============

Compute the Mandelbrot fractal and plot it

Based on:

https://scipy-lectures.org/intro/numpy/auto_examples/plot_mandelbrot.html

under CC-BY 4.0 ( https://creativecommons.org/licenses/by/4.0/ )

Thanks!

"""
import subprocess

import matplotlib.pyplot as plt

import numpy as np
from numpy import newaxis

import png


def compute_mandelbrot(iterations_count, max_level, diverge_threshold,
                       reals_width, imaginaries_width=None,
                       reals_range=(-2, 1),
                       imaginaries_range=(-1.5, 1.5),
                       ):
    # A grid of c-values
    def _diff(r):
        return r[1]-r[0]

    if imaginaries_width is None:
        imaginaries_width = int(
            _diff(reals_range) * reals_width / _diff(imaginaries_range)
        )
    x = np.linspace(reals_range[0], reals_range[1], reals_width)
    y = np.linspace(
        imaginaries_range[0], imaginaries_range[1], imaginaries_width
    )

    c = x[newaxis, :] + 1j*y[:, newaxis]

    # Mandelbrot iteration
    dims = (imaginaries_width, reals_width)
    ret = np.zeros(dims, dtype=np.int32)
    mask = np.zeros(dims, dtype=np.bool)

    z = c
    for j in range(iterations_count):
        z = z**2 + c
        where = (abs(z) > diverge_threshold)
        z *= np.logical_not(where)
        mask = np.logical_or(mask, where)
        ret += mask
    ret = ret * max_level // iterations_count
    return ret


mandelbrot_set = compute_mandelbrot(
    iterations_count=80,
    max_level=255,
    diverge_threshold=2.2,
    reals_width=600,
).astype('uint8')


m = np.repeat(mandelbrot_set, 3, axis=1)
greyscale = "mandel.png"
colored = "mandel_colored.png"
png.from_array(m, 'RGB').save(greyscale)

subprocess.check_call(
    [
        "gimp",  greyscale,
        # "gimp-2.99",  greyscale,
        "--no-interface",
        "--batch-interpreter=python-fu-eval",
        "-b",
        ('img = gimp.image_list()[0]\ndraw=img.active_drawable\n' +
         'pdb.gimp_context_set_gradient("Tropical Colors")\n' +
         'pdb.plug_in_gradmap(img, draw)\n' +
         'pdb.gimp_file_save(img, draw, "{colored}", "{colored}")\n' +
         'pdb.gimp_quit(1)\n'
         ).format(colored=colored)
    ])

subprocess.check_call(["gwenview", colored])


def show(mandelbrot_set):
    mandelbrot_set /= 256
    plt.imshow(mandelbrot_set.T, extent=[-2, 1, -1.5, 1.5])
    plt.gray()
    plt.show()
