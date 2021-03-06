
"
" After a short delay, if we're hanging out in NERDTree or MiniBufExplorer,
" jump back to the main pane. (Otherwise I keep accidentally opening files in
" the wrong panes.)
"
" This relies on :set switchbuf=useopen
"
function! PyCustom_ResetToMainBuffer()
python << EOF

import vim

PROSCRIBED_NAMES = ['NERD_tree_', '-MiniBufExplorer-']

def update_buffer():
    for window in vim.windows:
        namein = set([name in window.buffer.name for name in PROSCRIBED_NAMES])
        if namein == set([False]):
            vim.command("sb %s" % window.buffer.number)

for name in PROSCRIBED_NAMES:
    if name in vim.current.buffer.name:
        update_buffer()
        break

EOF
endfunction

autocmd CursorHold * call PyCustom_ResetToMainBuffer()
autocmd CursorHoldI * call PyCustom_ResetToMainBuffer()

" Debugging, really
function! PyCustom_ListBuffers()
python << EOF

import vim
for buffer in vim.buffers:
    print buffer.number, buffer.name

EOF
endfunction

"
" Drop back into Normal mode when switching to MiniBufExplorer. (Insert mode
" screws up the buffer explorer, and can lead to messing up the view)
"
function! PyCustom_MiniBufExpl_ForceNormal()
python << EOF

import vim

BUFNAME = '-MiniBufExplorer-'

if BUFNAME in vim.current.buffer.name:
    vim.command(":set noinsertmode")

EOF
endfunction

autocmd BufEnter * call PyCustom_MiniBufExpl_ForceNormal()

" CURRENTLY UNUSED
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

# Get the top-level directory of the project to find the .gitignore file
p = subprocess.Popen([
    'git',
    'rev-parse',
    '--show-toplevel',
], stdout = subprocess.PIPE, stderr = subprocess.PIPE)
stdout, stderr = p.communicate()

if not p.returncode:
    fpath = os.path.join(stdout.strip(), '.gitignore')

    try:
        with open(fpath) as f:
            patterns = f.readlines()
            for pattern in patterns:
                pattern = pattern.strip()
                if not pattern or pattern.startswith('#'):
                    continue
                if pattern.endswith('/'):
                    # Directories
                    pattern = pattern.strip('/')
                    DEFAULT_IGNORE.append(pattern + '$[[dir]]')
                else:
                    DEFAULT_IGNORE.append(pattern)
    except (IOError, OSError):
        pass

EOF
endfunction

"call PyCustom_ReadNERDTreeIgnore()
