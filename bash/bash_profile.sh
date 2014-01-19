#!/bin/bash

#
# For login shells
#
export LOGIN_SHELL=$false

source $HOME/.utils/bash/system.sh
source $HOME/.utils/bash/common.sh

# Work machine stuff. Don't include work stuff in this (external) repository,
# but source it from it's place in the SVN-tracked tree.

if [ -f "$HOME/workspace/Dev/Michael/etc/bash_profile" ]; then
    source $HOME/workspace/Dev/Michael/etc/bash_profile
fi
