## Env utils

import sys
import os
import re
import readline

def like(iter, s, cat = ''):
    """
    Search an iterable of strings for strings which contain the substring 's'.
    """
    for i in iter:
        if ',' in s:
            parts = s.split('*')
            for part in parts:
                if part and part in i:
                    print '%s%s' % (cat, i)
                    break
        if s and s in i:
            print '%s%s' % (cat, i)


def search(m, s, cat = ''):
    """
    Search the module 'm' for functions or submodules that contain 's' in their
    name.
    """
    return like(dir(m), s, cat)


def find(s):
    """
    Search all loaded modules for functions or submodules that contain 's' in
    their name.
    """
    for k, m in sys.modules.items():
        search(m, s, k + '.')


# Store the rlcompleter's hook that's already been set.
_rlcompleter = readline.get_completer()
_alnum = re.compile(r"[^a-zA-Z0-9_]+").sub
_stmtsplit = re.compile(r"[ \n:\(\)\[\]\-\+\t]+").split

def completer(text, status):
    """
    Wrapper around the default rlcompleter complete function.
    """
    line = readline.get_line_buffer()
    if text in ['cd', 'ls']:
        out = [text + "('"]
    else:
        # Check the text right before the tab completion scope. If we are trying
        # to cd or ls or open something, the tab completion is going to be the
        # files in the current directory
        prev = line[:readline.get_begidx()]
        prev = filter(None, [_alnum("", i) for i in _stmtsplit(prev)])
        if prev and prev[-1].lower() in ['cd', 'ls', 'open', 'file']:
            out = filter(lambda x: x.startswith(text), os.listdir(os.getcwd()))
        else:
            # Otherwise, just fall back to the default
            return _rlcompleter(text, status)

    try:
        return out[status]
    except:
        return None

readline.set_completer(completer)
