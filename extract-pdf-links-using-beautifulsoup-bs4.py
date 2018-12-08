#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2018 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.

"""

"""
import re
from bs4 import BeautifulSoup

soup = BeautifulSoup(open('index.html').read(), 'html.parser')

for a in soup.find_all('a'):
    href = a['href']
    if re.search('AD\\.[pP][dD][fF]$', href):
        print(href)
