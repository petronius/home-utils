#!/bin/bash
#
# Master alias file.
#

source $HOME/.utils/bash/system.sh

alias realias="source $HOME/.utils/bash/bash_aliases.sh"
alias srelaod="source $HOME/.utils/bash/system.sh"

if [ $LOGIN_SHELL ]; then
    alias '~~'="source $HOME/.bash_profile"
else
    alias '~~'="source $HOME/.bashrc"
fi

if [ ! $VIMEXISTS ] && [ "$(uname)" == "Darwin" ] && [ -f /Applications/Vim.app/Contents/MacOS/Vim ]; then
    alias vim='/Applications/Vim.app/Contents/MacOS/Vim'
    alias nano='/Applications/Vim.app/Contents/MacOS/Vim'
else
    ## ugh
    alias vim='vi'
fi

## Mistypes and compensation for general dumbassery

alias la="ls -la"
alias l="ls #"
alias ls="ls $LS_COLOR_FLAG -l"
alias ls-l="ls $LS_COLOR_FLAG -l"
alias ks="ls $LS_COLOR_FLAG -l"
alias cd..='cd ..'
alias snv='svn'

## Convenience shortcuts

alias ..='cd ..'
alias aliases='alias -p'
alias lynx='lynx -accept_all_cookies'
alias epoch='date +%s'


## System stuff

alias srm='srm -i'
alias su='sudo su'
alias ux='chmod u+x'
alias chmox="chmod"
alias valias='vi ~/.bash_aliases'
alias now='date "+%Y-%m-%d %H:%M:%S"'

## Programmin'

alias pyton="python"
alias pyhton="python"
alias pcprofile="python -m cProfile"
alias pyprofile="python -m Profile"

## MySQL shortcuts

alias msyql='mysql'
alias mysqlr='mysql -u root'
alias mysqlrp='mysql -u root -p'
# for when my brain is one step ahead of my commands
alias use="mysql -u root -p "

# Don't include work stuff in this (external) repository, but source it from
# it's place in the SVN-tracked tree.

if [ -f "$HOME/workspace/Dev/Michael/etc/bash_aliases" ]; then
    source $HOME/workspace/Dev/Michael/etc/bash_aliases
fi