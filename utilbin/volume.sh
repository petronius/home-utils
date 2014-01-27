#!/bin/bash

AWK_CMD=awk {print $5, "@", $6}
SED_CMD=sed -E 's/(\[|\])//g'

STEREO_LEVEL=$(amixer sget Master | grep -v "[off]" | grep "Front Left" | $AWK_CMD | $SED_CMD)

# Just in case we're on a mono system for some wierd reason
MONO_LEVEL=$(amixer sget Master | grep -v "[off]" | grep "Mono" | $AWK_CMD | $SED_CMD)

if [ -z "$STEREO_LEVEL"]; then
    LEVEL=$MONO_LEVEL
else
    LEVEL=$STEREO_LEVEL
fi

if [ -z "$LEVEL" ]; then
    LEVEL='mute'
fi

echo $LEVEL