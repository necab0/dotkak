#!/bin/bash

if ! ( hash git 2>/dev/null ); then
    echo "Please install git"
    exit 1
fi

DOTKAK=~/.kak
KAK=~/.config/kak

echo "Drop all existing plugins?"
read -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf $DOTKAK/autoload
    curl -LSso $DOTKAK/autoload/plug.kak --create-dirs https://raw.githubusercontent.com/andreyorst/plug.kak/v2019.01.20/rc/plug.kak
    ln -s /usr/share/kak/autoload/ $DOTKAK/autoload/site-wide
    rm -rf $DOTKAK/plugins
fi

echo "About to wipe your $KAK."
read -p "Proceed? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf $KAK
    ln -s $DOTKAK $KAK
    # install all plugins
    # TODO: find a clean-ish solution to do this with a headless client
    kak -e plug-install
fi
