#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/vagrant/.gedit ]
then
    echo "Gedit already Installed"
    exit 0
fi

touch /home/vagrant/.gedit

sudo apt-add-repository ppa:mc3man/older
sudo apt-get -y update && sudo apt-get install -y gedit gedit-plugins gedit-common