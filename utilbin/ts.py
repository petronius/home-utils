#!/usr/bin/env python
"""
Read data from stdin and output it line-by-line with timestamps.
"""

import datetime
import sys

try:
    while True:
        line = sys.stdin.readline()
        if line:
            sys.stdout.write('['+str(datetime.datetime.now())+'] '+line)
            sys.stdout.flush()
        else:
            sys.exit(0)
except KeyboardInterrupt:
    sys.exit(1)