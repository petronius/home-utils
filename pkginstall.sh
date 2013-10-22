#!/bin/bash

# Zero to setup

ARCH_PKGS=(
    alsa-utils
    conky-cli
    coreutils
    dnsutils
    dzen2
    findutils
    firefox
    flashplugin
    geoip
    git
    gvim
    gzip
    imagemagick
    inetutils
    ldns
    less
    lsb-release
    lsof
    lynx
    mariadb
    mlocate
    mopidy-git
    ncurses
    netcfg
    openvpn
    openssh
    p7zip
    parted
    perl
    pptpclient
    pulseaudio
    pyglet
    python-2
    python2-pip
    python2-beaker
    python2-beautifulsoup3
    python2-crypto
    python2-imaging
    python2-lxml
    python2-mako
    python2-markupsafe
    python2-numpy
    python2-paramiko
    python2-regex
    python2-reportlab
    python2-setuptools
    python2-sqlalchemy
    python
    python-pip
    ranger
    readline
    rsync
    ruby
    rxvt-unicode
    scribus
    spotify
    steam
    sudo
    tar
    tmux
    unrar
    unzip
    usbutils
    vim-minibufexpl
    vim-nerdtree
    vim-runtime
    vlc
    wget
    xmonad
    xmonad-contrib
    xsel
    xterm
)

DEBIAN_PKGS=(
    tmux
    python
    # coming soon, I guess?
)

DISTRO=$(lsb_release -i | grep -Po "\t[a-z]+" | cut -c 2- )

if [[ "$DISTRO" == "arch" ]];
   
    if [ -z "$(which yaourt)" ]; then
        echo "Install yaourt first."
        exit 1
    fi

    INSTALL_COMMAND="yaourt --noconfirm -S"
    PKG_LIST=$ARCH_PKGS

else if [[ "$DISTRO" == "debian" ]]; then
    
    INSTALL_COMMAND="sudo apt-get -y install"
    PKG_LIST=$DEBIAN_PKGS

fi

$INSTALL_COMMAND $PKG_LIST

