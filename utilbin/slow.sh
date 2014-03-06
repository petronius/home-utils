#!/bin/bash

#
# Usage: slow <speed> [<delay>] | clear
#
# Slow all connections over port 80 to the specified bandwidth. Good for
# troubleshooting, testing, and pranks.
#

HELP="Usage:\tslow [clear | <speed> [<delay>] ]\n\tslow [ sorta | kinda | very ]\nEg.: slow 16Kbit/s 350ms"

SPEED=$1
DELAY=$2

if [ -z "$SPEED" ]; then
    echo -e $HELP
    exit
elif [ "$SPEED" == '-h' ]; then
    echo -e $HELP
    exit
elif [ "$SPEED" == '--help' ]; then
    echo -e $HELP
    exit


elif [ "$SPEED" == 'clear' ]; then
    CLEAR=1
elif [ "$SPEED" == 'stop' ]; then
    CLEAR=1
elif [ "$SPEED" == 'nevermind' ]; then
    CLEAR=1

elif [ "$SPEED" == 'crawl' ]; then
    SPEED='4Kb/s'
    DELAY_STRING="delay 950ms"
elif [ "$SPEED" == 'very' ]; then
    SPEED='16Kb/s'
    DELAY_STRING="delay 500ms"
elif [ "$SPEED" == 'kinda' ]; then
    SPEED='500kb/s'
    DELAY_STRING="delay 350ms"
elif [ "$SPEED" == 'sorta' ]; then
    SPEED='1500Kb/s'
    DELAY_STRING="delay 120ms"
fi


if [ -n "$DELAY" ]; then
    DELAY_STRING="delay $DELAY"
else
    DELAY_STRING=""
fi


if [ "$CLEAR" == "1" ]; then
    sudo ipfw delete 1
    sudo ipfw delete 2
else
    sudo ipfw pipe 1 config bw $SPEED $DELAY_STRING
    sudo ipfw add 1 pipe 1 src-port 80
    sudo ipfw add 2 pipe 1 dst-port 80
fi
