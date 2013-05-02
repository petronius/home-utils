#!/bin/bash

#
# For non-login shells
#
export LOGIN_SHELL=$false

source $HOME/.utils/bash/system.sh
source $HOME/.utils/bash/common.sh

DEBEMAIL=petronius@d3mok.net
DEBFULLNAME="Michael Schuller"
export DEBEMAIL DEBFULLNAME

PATH=$PATH:/var/list/.bin
export PATH

# Don't include work stuff in this (external) repository, but source it from
# it's place in the SVN-tracked tree.

if [ -f "~/workspace/Dev/Michael/etc/bashrc" ]; then
    source ~/workspace/Dev/Michael/etc/bashrc
fi