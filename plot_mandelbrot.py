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


def compute_mandelbrot(n_max, some_threshold, nx, ny):
    # A grid of c-values
    x = np.linspace(-2, 1, nx)
    y = np.linspace(-1.5, 1.5, ny)

    c = x[:, newaxis] + 1j*y[newaxis, :]

    # Mandelbrot iteration
    ret = np.zeros([nx, ny], dtype=np.int32)
    mask = np.zeros([nx, ny], dtype=np.bool)

    z = c
    for j in range(n_max):
        z = z**2 + c
        where = (abs(z) > some_threshold)
        z *= (np.logical_not(where))
        mask = np.logical_or(mask, where)
        ret += mask
        # print(np.where(ret == j-1))
    return ret

    mandelbrot_set = (abs(z) < some_threshold)

    return mandelbrot_set


mandelbrot_set = compute_mandelbrot(255, 2.2, 601, 401).astype('uint8')


def foo(y):
    ret = []
    for x in y:
        for _ in range(3):
            ret.append(int(x))
    return ret


m = np.repeat(mandelbrot_set, 3, axis=1)
print(set([min(x) for x in m]))
# print(m)
png.from_array(m, 'RGB').save("mandel.png")

subprocess.call(
    [
        "/usr/bin/gimp",  "./mandel.png",
        "--batch-interpreter=python-fu-eval",
        "-b",
        ('img = gimp.image_list()[0]\ndraw=img.active_drawable\n' +
         'pdb.gimp_context_set_gradient("Tropical Colors")\n' +
         'pdb.plug_in_gradmap(img, draw)\n' +
         'pdb.gimp_file_save(img, draw, "mandel2.png", "mandel2.png")\n\n'
         )
    ])


def show(mandelbrot_set):
    mandelbrot_set /= 256
    plt.imshow(mandelbrot_set.T, extent=[-2, 1, -1.5, 1.5])
    plt.gray()
    plt.show()
