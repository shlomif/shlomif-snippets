#!/usr/bin/env python
class Hello(object):
    def myhello(self):
        print "This is myhello."

h = Hello()
h.myhello()
h.non_existent_method()
