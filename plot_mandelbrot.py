"""
Mandelbrot set
==============

Compute the Mandelbrot fractal and plot it

Based on:

https://scipy-lectures.org/intro/numpy/auto_examples/plot_mandelbrot.html

under CC-BY 4.0 ( https://creativecommons.org/licenses/by/4.0/ )

Thanks!

"""
import numpy as np
import matplotlib.pyplot as plt
from numpy import newaxis


def compute_mandelbrot(N_max, some_threshold, nx, ny):
    # A grid of c-values
    x = np.linspace(-2, 1, nx)
    y = np.linspace(-1.5, 1.5, ny)

    c = x[:, newaxis] + 1j*y[newaxis, :]

    # Mandelbrot iteration

    z = c
    for j in range(N_max):
        z = z**2 + c

    mandelbrot_set = (abs(z) < some_threshold)

    return mandelbrot_set


mandelbrot_set = compute_mandelbrot(50, 50., 601, 401)

plt.imshow(mandelbrot_set.T, extent=[-2, 1, -1.5, 1.5])
plt.gray()
plt.show()
