# Loaded by the (b)python interpreter.

import atexit
import cjson
import datetime
import inspect
import os
import readline
import rlcompleter
import subprocess
import sys
import time
import urllib
import urllib2

COLORS = {
    'black':    '0;30',     'bright gray':  '0;37',
    'blue':     '0;34',     'white':        '1;37',
    'green':    '0;32',     'bright blue':  '1;34',
    'cyan':     '0;36',     'bright green': '1;32',
    'red':      '0;31',     'bright cyan':  '1;36',
    'purple':   '0;35',     'bright red':   '1;31',
    'yellow':   '0;33',     'bright purple':'1;35',
    'dark gray':'1;30',     'bright yellow':'1;33',
    'normal':   '0'
}

def tocolor(text, color):
    text = str(text)
    rcolor = COLORS.get(color)
    if not rcolor:
        color = filter(lambda x: x == color, [COLORS.get(i) for i in COLORS.keys()])
        if len(color):
            rcolor = color[0]
        else:
            rcolor = '0'
    return "\001\033[%sm\002%s\001\033[0m\002" % (rcolor, text)

# For some reason this doesn't get set when starting bpython.
if not '__file__' in dir():
    __file__ = os.path.expanduser('~/workspace/Dev/Michael/lib/python/startup/__init__.py')

## If we do this as startup.defaults then this file loads twice, which is annoying.
sys.path.append('/'.join(os.path.abspath(__file__).split('/')[:-2]) + '/startup')


## Give us the contents of ~/workspace/Dev/Michael/lib/python as an import path
sys.path.append('/'.join(os.path.abspath(__file__).split('/')[:-2]))
sys.path.append('/'.join(os.path.abspath(__file__).split('/')[:-4]) + '/bin')

# Custom utilities for the interpreter
import iutils

# Cross-session histories
HISTORY_FILE = os.path.expanduser('~/.pysh')
atexit.register(readline.write_history_file, HISTORY_FILE)
try:
    readline.read_history_file(HISTORY_FILE)
except IOError:
    pass

class PS1(object):
    def __str__(self):
        try:
            cwd = os.getcwd()
            exp = os.path.expanduser('~')
            if cwd.startswith(exp):
                cwd = cwd.replace(exp, '~')
            now = str(datetime.datetime.now().strftime('%H:%M:%S'))
            ps = '%s %s >>> ' % (now, cwd)
            self._len = len(ps)
            return ps
        except Exception, e:
            return str(e)

class PS2(object):
    def __str__(self):
        try:
            return ' ' * (len(str(sys.ps1)) - 5) + ' ... '
        except Exception, e:
            return str(e)

class LS(object):
    def __call__(self, dir = '.'):
        self.__repr__(dir)
    def __repr__(self, dir = '.'):
        for i in os.listdir(dir):
            print ' ',i
        return ''

class CD(object):
    _last = None
    def __call__(self, dir):
        _last = self._last
        self._last = os.getcwd()
        if dir == '-' and _last:
            return os.chdir(_last)
        else:
            return os.chdir(dir)
    def __repr__(self):
        self(os.path.expanduser('~'))
        return ''

def cat(*args):
    # Open all the files first, in case there is an IOError or something.
    args = [open(f) for f in args]
    for f in args:
        sys.stdout.write(f.read())

sys.ps1 = PS1()
sys.ps2 = PS2()
ls = LS()
cd = CD()