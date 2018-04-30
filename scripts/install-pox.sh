#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/vagrant/.pox ]
then
    echo "POX Controller already installed."
    exit 0
fi

touch /home/vagrant/.pox

cd /usr/local/bin
git clone http://github.com/noxrepo/pox
cd pox
git checkout eel
echo "alias pox='/usr/local/bin/pox/pox.py'" >> ~/.bashrc