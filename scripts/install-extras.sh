#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/vagrant/.extras ]
then
    echo "Extras already Installed"
    exit 0
fi

touch /home/vagrant/.extras

# Install Dependency
sudo apt-get install -y software-properties-common
sudo apt-get install -y git
sudo apt-get install -y openssh-server
sudo apt-get install -y apt-transport-https

# Configure Alias
sudo echo "alias sudo='sudo '" >> ~/.bashrc

# Fix Bug 16.04
# sudo apt-get remove -y --purge libappstream3