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

