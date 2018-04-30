#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/vagrant/.nano ]
then
    echo "Nano already Installed"
    exit 0
fi

touch /home/vagrant/.nano

sudo apt-get install -y nano