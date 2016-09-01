#!/usr/bin/env python

# This little program offsets the samples of a WAV file by delta in the range
# -3 to 3. The result appears to be still hearable (though there are some
# artefacts). It was written as an experiment to see if I can demonstrate that
# losslesly compressing a 40 MB audio file to 20 kilo-Bytes was not
# realistic.

# TODO:
# * Make the code portable to python 3.
# * Optimize the runtime speed.
# * Convert to use some command line arguments.

import io
import random2
import struct

random2.seed(24)

def process(i):
    d = random2.randint(-3,3)
    ret = i + d
    return (0 if ret < 0 else (65535 if ret > 65535 else ret))

inp = io.open('out.wav', 'rb')
out = io.open('processed.wav', 'wb')

out.write(inp.read(100*4))

b = inp.read(2)
while b:
    out.write(struct.pack('H', process(struct.unpack('H', b)[0])))
    b = inp.read(2)

inp.close()
out.close()
