#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/vagrant/.brave ]
then
    echo "Brave already Installed"
    exit 0
fi

touch /home/vagrant/.brave

wget -qO - https://s3-us-west-2.amazonaws.com/brave-apt/keys.asc | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://s3-us-west-2.amazonaws.com/brave-apt xenial main"
sudo apt-get -y update
sudo apt-get install -y brave