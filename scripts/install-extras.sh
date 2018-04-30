#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/vagrant/.extras ]
then
    echo "Extras already Installed"
    exit 0
fi

touch /home/vagrant/.extras

sudo apt-get install -y git
sudo apt-get install -y openssh-server