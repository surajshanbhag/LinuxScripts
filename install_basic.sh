#!/bin/bash
set -x

sudo apt update
sudo apt upgrade -y
sudo apt-get -y autoremove

sudo apt-get install vim guake terminator screen tmux -y

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886 -y
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
sudo add-apt-repository ppa:graphics-drivers/ppa -y
sudo add-apt-repository ppa:atareao/atareao -y
sudo apt-add-repository ppa:fixnix/netspeed -y
sudo apt-add-repository ppa:yktooo/ppa -y
sudo add-apt-repository ppa:indicator-brightness/ppa --y
sudo add-apt-repository ppa:webupd8team/sublime-text-3 -y
sudo apt-get update


sudo apt-get install sublime-text-installer -y
sudo apt-get install nvidia-375 -y
sudo apt-get install indicator-weather -y
sudo apt-get install indicator-multiload -y
sudo apt-get install indicator-cpufreq -y
sudo apt-get install touchpad-indicator -y
sudo apt-get install indicator-netspeed-unity -y
sudo apt-get install indicator-sound-switcher -y
sudo apt-get install spotify-client -y
sudo apt-get install indicator-brightness -y
sudo apt-get install git-cola

wget https://atom.io/download/deb
mv deb atom-amd64.deb
sudo dpkg -i atom-amd64.deb
rm -rf atom-amd64.deb

cp /etc/default/grub ~/grub.bkp
sudo sed -i -- 's/GRUB_CMDLINE_LINUX="/GRUB_CMDLINE_LINUX="acpi_backlight=native acpi_osi="/g' /etc/default/grub
sudo update-grub


indicator-sound-switcher &
indicator-cpufreq &
indicator-netspeed-unity &
indicator-multiload &

sudo apt-get install build-essential -y
sudo apt-get install cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev -y
sudo apt-get install python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev -y

wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
sudo apt-get update
sudo apt-get install cuda -y


sudo apt-get install -y build-essential cmake cmake-gui

sudo apt-get install -y qt5-default libvtk6-dev

sudo apt-get install -y zlib1g-dev libjpeg-dev libwebp-dev libpng-dev libtiff5-dev libjasper-dev libopenexr-dev libgdal-dev

sudo apt-get install -y libdc1394-22-dev libavcodec-dev libavformat-dev libswscale-dev libtheora-dev libvorbis-dev libxvidcore-dev libx264-dev yasm libopencore-amrnb-dev libopencore-amrwb-dev libv4l-dev libxine2-dev

sudo apt-get install -y libtbb-dev libeigen3-dev

sudo apt-get install -y python-dev python-tk python-numpy python3-dev python3-tk python3-numpy

sudo apt-get install -y ant default-jdk

#backup bashrc
cp ~/.bashrc bashrc_copy

# setup bash rc

echo 'export PATH=/usr/local/cuda-8.0/bin${PATH:+:${PATH}}' >>~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda-8.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >>~/.bashrc

echo "PS1='[${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[00m\]]:\[\033[01;34m\]\w\[\033[00m\]\$ '" >> ~/.bashrc
echo "alias sbc='source ~/.bashrc'">>~/.bashrc
echo "alias gits='git status'">>~/.bashrc
echo "alias gitp='git push origin master'"
echo "alias catkin_make_release='catkin_make -DCMAKE_BUILD_TYPE=Release'">>~/.bashrc
echo "alias killjobs='jobs -ps | xargs kill -9'">>~/.bashrc
echo "alias sros='source ~/catkin_ws/devel/setup.bash && source /opt/ros/kinetic/setup.bash'">>~/.bashrc

wget https://www.edubuntu.org/sites/default/files/docimages/wallpapers-oneiric/Stalking_Ocelot_by_Sayantan_Chaudhuri-full.jpg
mv Stalking_Ocelot_by_Sayantan_Chaudhuri-full.jpg ~/Pictures/Stalking_Ocelot_by_Sayantan_Chaudhuri-full.jpg
gsettings get org.gnome.desktop.background picture-uri ~/Pictures/Stalking_Ocelot_by_Sayantan_Chaudhuri-full.jpg

#cd ~/
#mkdir opencv
#cd opencv
#git clone https://github.com/opencv/opencv.git
#git clone https://github.com/opencv/opencv_contrib.git

#cd opencv
#git checkout 3.1.0
#cd ../opencv_contrib
#git checkout 3.1.0
