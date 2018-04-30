#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/vagrant/.mininet ]
then
    echo "Mininet already installed."
    exit 0
fi

touch /home/vagrant/.mininet

cd /usr/local/bin
git clone git://github.com/mininet/mininet
cd mininet
git checkout -b 2.2.2 2.2.2
cd ..
mininet/util/install.sh
sudo echo "alias miniedit='/usr/local/bin/mininet/examples/miniedit.py'" >> ~/.bashrc