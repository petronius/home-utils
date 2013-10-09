#!/bin/bash

#
# Move old bash startup and shutdown scripts out of the way and link these
# versions in in their place.
#


SCRIPTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NOW="$(date +%s)"

BASHFILES=('.bash_profile' '.bash_aliases' '.bash_logout' '.bashrc')

RCFILES=('.vimrc' '.gitconfig' '.inputrc')

DIRECTORIES=('.vim' '.pystartup' '.utilbin')

XMONAD=('xmonad.hs')

dirset=('SUBDIRS' 'BASHFILES' 'RCFILES' 'DIRECTORIES')

for val in ${dirset[@]}; do

    for f in $(eval echo "\${$val[@]}"); do

        targetpath="$HOME/$f"
        
        case $val in
            BASHFILES)
                sourcepath="$SCRIPTDIR/bash/${f##*.}.sh"
                ;;
            RCFILES)
                sourcepath="$SCRIPTDIR/config/${f##*.}"
                ;;
            DIRECTORIES)
                sourcepath="$SCRIPTDIR/${f##*.}"
                ;;
            XMONAD)
                sourcepath="xmonad/$f"
                ;;
        esac

        if [ -L $targetpath ]; then
            echo "Removing old symlink for $targetpath ..."
            rm -v $targetpath
         elif [ -d $targetpath ] || [ -f $targetpath ]; then
            echo "Backing up exising version of $targetpath ..."
            mv -v $targetpath "$HOME/${targetpath//\//_}_$NOW"
         fi
         echo $sourcepath $targetpath
         ln -sv $sourcepath $targetpath

    done
done

if [ -n "$(which xmonad)" ]; then
    echo "Recompiling xmoand ..."
    xmonad --recompile
fi

if [[ -d "$HOME/.utils" ]]; then
    echo "Links flattened, $HOME/.utils/ now okay to delete."
fi
