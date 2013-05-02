#!/bin/bash

if [ -z "$SYSTEM_IS_IMPORTED" ]; then

    export SYSTEM_IS_IMPORTED=1

    export USER=$(whoami)
    export UNAME=$(uname)

    if [ "$UNAME" == "Darwin" ]; then
        export LS_COLOR_FLAG='-G'
    else
        # gnu
        export LS_COLOR_FLAG='--color'
    fi

    export VIM_EXISTS=$(vim --version > /dev/null 2>&1; echo $?)

    #
    # Set metadata about the current OS and machine architecture.
    #
    while read line; do
        case $line in
            Description:*)
                export OS_STRING="$(echo $line | sed 's/^Description\:\s//')"
                ;;
            Distributor\ ID:*)
                export OS_DISTRO="$(echo $line | sed 's/^Distributor ID\:\s//')"
                ;;
            Release:*)
                export OS_RELEASE="$(echo $line | sed 's/^Release\:\s//')"
                ;;
            Codename:*)
                export OS_CODENAME="$(echo $line | sed 's/^Codename\:\s//')"
                ;;
        esac
    done < <(lsb_release -a 2>/dev/null)

    if [ -z "$OS_STRING" ]; then
        # MacOS doesn't have lsb_release, of course.
        export OS_STRING=$(uname -v)
        export OS_DISTRO=$(uname -s)
        export OS_RELEASE=$(uname -r)
        export OS_CODENAME=""
    fi

    # If we do this now, we don't have to call uname every time we need the info.
    export MACH_ARCH=$(uname -p)
    export MACH_HWARE=$(uname -m)

fi
