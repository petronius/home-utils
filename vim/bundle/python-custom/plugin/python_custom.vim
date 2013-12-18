
"
" After a short delay, if we're handing out in NERDTree or MiniBufExplorer, jump
" back to the main pane. (Otherwise I keep accidentally opening files in the
" wrong panes.)
"
" This relies on :set switchbuf=useopen
"
function! PyCustom_ResetToMainBuffer()
python << EOF

import vim

PROSCRIBED_NAMES = ['NERD_tree_', '-MiniBufExplorer-']

def update_buffer():
    for window in vim.windows:
        for name in PROSCRIBED_NAMES:
            if not name in window.buffer.name:
                n = window.buffer.number - 1
                print n
                vim.command("sb %s" % n)
                return

for name in PROSCRIBED_NAMES:
    if name in vim.current.buffer.name:
        update_buffer()
        break

EOF
endfunction

autocmd CursorHold * call PyCustom_ResetToMainBuffer()
autocmd CursorHoldI * call PyCustom_ResetToMainBuffer()


"
" If we're opening vim inside a git repo, let's read the NERDTreeIgnore values
" from .gitignore. Otherwise, use only the defaults
"
" TODO: This isn't actually transforming the .gitignore patterns into vim-
" consumable regexes.
"
function! PyCustom_ReadNERDTreeIgnore()
python << EOF

from __future__ import with_statement

import os
import subprocess
import vim


DEFAULT_IGNORE = [
    '\.pyc$',
    '\.pyo$',
    '__pycache__$',
    '\.egg-info$',
    '\.o$',
    '\.hi$',
]

p = subprocess.Popen([
    'git',
    'rev-parse',
    '--show-toplevel',
], stdout = subprocess.PIPE, stderr = subprocess.PIPE)
stdout, stderr = p.communicate()

if not p.returncode:
    fpath = os.path.join(stdout.strip(), '.gitignore')

    with open(fpath) as f:
        patterns = f.readlines()
        for pattern in patterns:
            pattern = pattern.strip()
            if not pattern:
                continue
            if pattern.startswith('#'):
                continue
            if pattern.endswith('/'):
                # Directories
                pattern = pattern.strip('/')
                DEFAULT_IGNORE.append(pattern + '$[[dir]]')
            else:
                DEFAULT_IGNORE.append(pattern)

EOF
endfunction

"call PyCustom_ReadNERDTreeIgnore()