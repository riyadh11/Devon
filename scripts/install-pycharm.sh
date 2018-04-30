#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/vagrant/.pycharm ]
then
    echo "Pycharm already Installed"
    exit 0
fi

touch /home/vagrant/.pycharm

sudo add-apt-repository ppa:mystic-mirage/pycharm
sudo apt-get -y update
sudo apt-get install -y pycharm-community