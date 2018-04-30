#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/vagrant/.emacs ]
then
    echo "Emacs already Installed"
    exit 0
fi

touch /home/vagrant/.emacs

sudo apt-add-repository -y ppa:adrozdoff/emacs
sudo apt-get -y update
sudo apt-get -y install emacs25