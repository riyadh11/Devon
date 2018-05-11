#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/vagrant/.ns3 ]
then
    echo "NS3 already Installed"
    exit 0
fi

touch /home/vagrant/.ns3

# Dependency
sudo apt-get -y install gcc g++ python
sudo apt-get -y install gcc g++ python python-dev
sudo apt-get -y install mercurial python-setuptools git
sudo apt-get -y install qt5-default
sudo apt-get -y install python-pygraphviz python-kiwi python-pygoocanvas libgoocanvas-dev ipython
sudo apt-get -y install openmpi-bin openmpi-common openmpi-doc libopenmpi-dev
sudo apt-get -y install autoconf cvs bzr unrar
sudo apt-get -y install gdb valgrind 
sudo apt-get -y install uncrustify
sudo apt-get -y install doxygen graphviz imagemagick
sudo apt-get -y install texlive texlive-extra-utils texlive-latex-extra texlive-font-utils texlive-lang-portuguese dvipng
sudo apt-get -y install python-sphinx dia 
sudo apt-get -y install gsl-bin libgsl2 libgsl-dev
sudo apt-get -y install flex bison libfl-dev
sudo apt-get -y install tcpdump
sudo apt-get -y install sqlite sqlite3 libsqlite3-dev
sudo apt-get -y install libxml2 libxml2-dev
sudo apt-get -y install cmake libc6-dev libc6-dev-i386 libclang-dev
pip install cxxfilt
sudo apt-get -y install libgtk2.0-0 libgtk2.0-dev
sudo apt-get -y install vtun lxc
sudo apt-get -y install libboost-signals-dev libboost-filesystem-dev

# install
hg clone http://code.nsnam.org/bake

sudo echo "
export BAKE_HOME=`pwd`/bake 
export PATH=$PATH:$BAKE_HOME
export PYTHONPATH=$PYTHONPATH:$BAKE_HOME
" >> ~/.bashrc

bake.py check
bake.py configure -e ns-3.26
bake.py show   
bake.py deploy
bake.py download
bake.py build