#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/vagrant/.ryu ]
then
    echo "RYU Controller already installed."
    exit 0
fi

touch /home/vagrant/.ryu

sudo pip install ryu