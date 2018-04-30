#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/vagrant/.pip ]
then
    echo "PIP already installed."
    exit 0
fi

touch /home/vagrant/.pip

sudo apt-get update
sudo apt-get install -y python-pip