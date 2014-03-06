#!/usr/bin/env python
from __future__ import with_statement
import os
import pydoc

d = os.path.dirname(__file__)
f = os.path.join(d, 'README.txt')

with open(f) as f:
    pydoc.pipepager(f.read(), 'less')