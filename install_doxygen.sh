#!/bin/bash
sudo apt-get install flex -y

mkdir doxygen
cd doxygen
wget http://launchpadlibrarian.net/140087283/libbison-dev_2.7.1.dfsg-1_amd64.deb
wget http://launchpadlibrarian.net/140087282/bison_2.7.1.dfsg-1_amd64.deb
sudo dpkg -i libbison-dev_2.7.1.dfsg-1_amd64.deb
sudo dpkg -i bison_2.7.1.dfsg-1_amd64.deb
sudo apt-mark hold libbison-dev
sudo apt-mark hold bison    


git clone https://github.com/doxygen/doxygen.git
cd doxygen
mkdir build
cd build
cmake -G "Unix Makefiles" ..
make
sudo make install

