#!/usr/bin/env python2
#
# -------------------------------------------------------------------------------------
#
# Copyright (c) 2013, Jose F. Maldonado
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification,
# are permitted provided that the following conditions are met:
#
#    - Redistributions of source code must retain the above copyright
#    notice, this
#    list of conditions and the following disclaimer.
#    - Redistributions in binary form must reproduce the above
#    copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or
#    other materials provided with the distribution.
#    - Neither the name of the author nor the names of its contributors may
#    be used
#    to endorse or promote products derived from this software without specific
#    prior
#    written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
# TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# ================
#
# Based on https://github.com/jfmdev/PythonFuSamples
# Thanks!
#  -- Shlomi Fish

import os.path
import subprocess
import shutil
from tempfile import mkdtemp
from gimpfu import gimp, main, pdb, register
from gimpfu import PF_IMAGE, PF_STRING


def file_load_lepton(filename, raw_filename):
    ''' Save the current layer into a PNG file, a JPEG file and a BMP file.

    Parameters:
    image : image The current image.
    layer : layer The layer of the image that is selected.
    file : string The file to open in a new layer.
    '''
    # Indicates that the process has started.
    gimp.progress_init("Opening '" + filename + "'...")

    try:
        tmpdirobj = mkdtemp()
        tmp_dirname = tmpdirobj
        jpeg_fn = os.path.join(tmp_dirname, "from_lep.jpeg")
        subprocess.check_call(["lepton", filename, jpeg_fn])
        fileImage = pdb.file_jpeg_load(jpeg_fn, filename)
        if(fileImage is None):
            gimp.message("The image could not be opened since" +
                         "it is not an image file.")
        shutil.rmtree(tmp_dirname)
        return fileImage
    except Exception as err:
        gimp.message("Unexpected error: " + str(err))
        raise err


def register_load_handlers():
    gimp.register_load_handler('file-lepton-load', 'lep,lepton', '')
    pdb['gimp-register-file-handler-mime']('file-lepton-load', 'image/lepton')


register(
    "file-lepton-load",
    "Open Dropbox Lepton Files",
    "Open Dropbox Lepton Files",
    "JFM",
    "Open source (BSD 3-clause license)",
    "2013",
    "Lepton",
    None,  # image type
    [
        (PF_STRING, "filename", "File to open", None),
        (PF_STRING, "raw-filename", "Name entered", None),
    ],
    [(PF_IMAGE, 'image', 'Output image'), ],
    file_load_lepton,
    on_query=register_load_handlers,
    menu="<Load>",
    )

main()
