#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/vagrant/.pox ]
then
    echo "POX Controller already installed."
    exit 0
fi

touch /home/vagrant/.pox

cd /usr/local/bin
sudo git clone http://github.com/noxrepo/pox
cd pox
sudo git checkout eel
sudo echo "alias pox='/usr/local/bin/pox/pox.py'" >> ~/.bashrc