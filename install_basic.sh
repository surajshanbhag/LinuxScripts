#!/bin/bash
set -x

sudo apt update
sudo apt upgrade -y
sudo apt-get -y autoremove

sudo apt-get install vim guake terminator screen tmux -y

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
sudo add-apt-repository ppa:graphics-drivers/ppa -y
sudo add-apt-repository ppa:atareao/atareao -y
sudo apt-add-repository ppa:fixnix/netspeed -y
sudo apt-add-repository ppa:yktooo/ppa -y
sudo add-apt-repository ppa:indicator-brightness/ppa

sudo apt-get update

sudo apt-get install nvidia-370 -y
sudo apt-get install indicator-weather -y
sudo apt-get install indicator-multiload -y
sudo apt-get install indicator-cpufreq -y
sudo apt-get install touchpad-indicator -y
sudo apt-get install indicator-netspeed-unity -y
sudo apt-get install indicator-sound-switcher -y
sudo apt-get install spotify-client -y
sudo apt-get install indicator-brightness -y

#cp /etc/defaults/grub ~/grub.bkp
#sed -i -- 's/GRUB_CMDLINE_LINUX="/GRUB_CMDLINE_LINUX="acpi_backlight=native acpi_osi="/g' /etc/defaults/grub
#sudo update-grub


indicator-sound-switcher &
indicator-cpufreq &
indicator-netspeed-unity &
indicator-multiload &

wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
sudo apt-get update
sudo apt-get install cuda -y

sudo apt-get install build-essential -y
sudo apt-get install cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev -y
sudo apt-get install python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev -y

sudo apt-get install -y build-essential cmake
sudo apt-get install -y qt5-default libvtk6-dev
sudo apt-get install -y zlib1g-dev libjpeg-dev libwebp-dev libpng-dev libtiff5-dev libjasper-dev libopenexr-dev libgdal-dev
sudo apt-get install -y libdc1394-22-dev libavcodec-dev libavformat-dev libswscale-dev libtheora-dev libvorbis-dev libxvidcore-dev libx264-dev yasm libopencore-amrnb-dev libopencore-amrwb-dev libv4l-dev libxine2-dev
sudo apt-get install -y libtbb-dev libeigen3-dev
sudo apt-get install -y python-dev python-tk python-numpy python3-dev python3-tk python3-numpy
sudo apt-get install -y ant default-jdk
sudo apt-get install -y doxygen


##opencv installation
cd ~/
mkdir opencv
cd opencv
git clone https://github.com/opencv/opencv.git
git clone https://github.com/opencv/opencv_contrib.git

cd opencv
git checkout 3.1.0
git config --global user.name "surajshanbhag"
git config --global user.email "surajmshanbhag@gmail.com"
git format-patch -1 10896129b39655e19e4e7c529153cb5c2191a1db && git am < 0001-GraphCut-deprecated-in-CUDA-7.5-and-removed-in-8.0.patch
cd ../opencv_contrib
git checkout 3.1.0

cd ../opencv/build
make -j7
sudo make install
sudo ldconfig

cd ~/
#instal ROS
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
sudo apt-get update
sudo apt-get install ros-kinetic-desktop-full -y
sudo rosdep init
rosdep update

echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc
source ~/.bashrc
sudo apt-get install python-rosinstall -y

mkdir -p ~/catkin_ws/src
cd ~/catkin_ws/src
cd ~/catkin_ws
catkin_make
source devel/setup.bash
