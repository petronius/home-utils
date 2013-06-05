#!/bin/bash

#
# Common setup for login and non-login shells
#

case $USER in
    # daaAAannja zone
    root)
        export PS1='\[\033[1;31m\][\u@\H]\[\033[m\]\t \w ($?)\[\033[1;31m\]#\[\033[m\] '
        ;;
    # Nonhuman users
    www|www-data|git|ftp|mysql|pdns|news|mail|man|games|sys|bin|openldap|sshd|debian-sks|proxy|backup)
        export PS1='\[\033[1;33m\][\u@\H]\[\033[m\]\t \w ($?)\[\033[1;33m\]$\[\033[m\] '
        ;;
    # Human users and safe users
    *)
        export PS1='\[\033[1;32m\][\u@\H]\[\033[m\]\t \w ($?)\[\033[1;32m\]$\[\033[m\] '
        ;;
esac

# Append local bin directories
if [ -d "$HOME/bin" ]; then
    export PATH="$PATH:$HOME/bin"
fi

if [ -d "/usr/local/git/bin/" ]; then
    export PATH="$PATH:/usr/local/git/bin/"
fi

export WORKSPACE="$HOME/workspace"

export CDPATH="$CDPATH:$WORKSPACE"

export HISTFILESIZE=1000
export HISTCONTROL=ignoreboth
export HISTIGNORE="ls:ls -l:clear:exit"

source "$HOME/.utils/bash/bash_aliases.sh"

export PYTHONSTARTUP="$HOME/.pystatup/__init__.py"
export PYTHONIOENCODING="utf-8"

export EDITOR=vim
export INPUTRC="$HOME/.inputrc"