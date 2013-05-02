#!/bin/bash

#
# Move old bash startup and shutdown scripts out of the way and link these
# versions in in their place.
#


SCRIPTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NOW="$(date +%s)"

SUBDIRS=('bash' 'config')

BASHFILES=('.bash_profile' '.bash_aliases' '.bash_logout' '.bashrc')

RCFILES=('.vimrc' '.gitconfig')

DIRECTORIES=('.vim' '.pystartup')

dirset=('SUBDIRS' 'BASHFILES' 'RCFILES' 'DIRECTORIES')
mkdir -p "$HOME/.utils/"

for val in ${dirset[@]}; do

    for f in $(eval echo "\${$val[@]}"); do

        targetpath="$HOME/$f"
        
        case $val in
            SUBDIRS)
                targetpath="$HOME/.utils/$f"
                sourcepath="$SCRIPTDIR/$f"
                ;;
            BASHFILES)
                sourcepath="$HOME/.utils/bash/${f##*.}.sh"
                ;;
            RCFILES)
                sourcepath="$HOME/.utils/config/${f##*.}"
                ;;
            DIRECTORIES)
                sourcepath="$HOME/.utils/bash/${f##*.}"
                ;;
        esac

        if [ -L $targetpath ]; then
            echo "Removing old symlink for $targetpath ..."
            rm -v $targetpath
         elif [ -d $targetpath ] || [ -f $targetpath ]; then
            echo "Backing up exising version of $targetpath ..."
            mv -v $targetpath "$HOME/${targetpath//\//\_}_$NOW"
         fi
         echo $sourcepath $targetpath
         ln -sv $sourcepath $targetpath

    done
done
