#!/bin/bash

clear

# Don't include work stuff in this (external) repository, but source it from
# it's place in the SVN-tracked tree.

if [ -f "$HOME/workspace/Dev/Michael/etc/bash_logout" ]; then
    source $HOME/workspace/Dev/Michael/etc/bash_logout
fi