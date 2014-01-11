
##
## Command-line friendly startup commands for most applications.
##

# These all need to be dumped into the background
GUI_APPLICATIONS=(
    firefox
    spotify
    steam
)

for app in ${GUI_APPLICATIONS[@]}; do

    if hash $app >/dev/null 2>&1; then

        logdir=/usr/local/var/log/guiapps/$user
        logfile=$logdir/$app.log
        sudo mkdir -p $logdir
        user=$(whoami)
        sudo chown $user $logdir
        sudo chmod u+rw $logdir

        read -r -d '' tmpfunc <<HEREDOC

            ${app}() {

                if hash logrotate >/dev/null 2>&1 && [ -f $logfile ]; then
                    logrotate $logfile
                fi
                $(hash -t $app) >$logfile 2>&1 &

            }
HEREDOC

        eval "$tmpfunc"

    #else
        # echo 'Warning: `hash '$app'` failed.'
    fi

done

openvpn() {

    ovpn="$(pgrep openvpn)"

    if [ "$1" == "stop" ]; then
        sudo kill $ovpn
    else
        if [ -z $openvpn ]; then
            sudo /usr/bin/openvpn --config /etc/openvpn/client.conf >(logger -t "[openvpn]") 2>&1 &
        fi
    fi
}

export openvpn
