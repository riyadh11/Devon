#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/vagrant/.firefox ]
then
    echo "Firefox already Installed"
    exit 0
fi

touch /home/vagrant/.firefox

sudo apt-get install -y firefox