#! /usr/bin/env python3
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2025 Shlomi Fish < https://www.shlomifish.org/ >
#
# Licensed under the terms of the MIT license.


class MyGimp:
    def destroy(self):
        self.gi = None
        self.Gimp = None
        self.pdb = None

    def __init__(self):
        import gi
        gi.require_version("Gimp", "3.0")
        from gi.repository import Gimp   # noqa: E402
        pdb = Gimp.get_pdb()
        self.Gio = Gio  # noqa: F821
        self.gi = gi
        self.Gimp = Gimp
        self.pdb = pdb

    def run_pdb(self, name, kv):
        pdb = self.pdb
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

    def file_save(self, img, filepath):
        Gimp = self.Gimp
        result = self.run_pdb("gimp-file-save", {
            "file": self.Gio.File.new_for_path(filepath),
            "image": img,
            "run-mode": Gimp.RunMode.NONINTERACTIVE,
        })
        return result


def only1(lst):
    assert (len(lst) == 1)
    ret = lst[0]
    return ret
