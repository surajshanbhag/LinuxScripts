#!/bin/bash

opencv_version="3.2.0"


RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'
RET=0

#install dependencies
softwares=('build-essential cmake git'
'pkg-config unzip ffmpeg qtbase5-dev python-dev python3-dev python-numpy python3-numpy'
'libopencv-dev libgtk-3-dev libdc1394-22 libdc1394-22-dev libjpeg-dev libpng12-dev libtiff5-dev libjasper-dev'
'libavcodec-dev libavformat-dev libswscale-dev libxine2-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev'
'libv4l-dev libtbb-dev libfaac-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev'
'libvorbis-dev libxvidcore-dev v4l-utils python-vtk'
'liblapacke-dev libopenblas-dev checkinstall'
'libgdal-dev')

for i in "${!softwares[@]}"; do 
    printf "${RED}%s installing : ${BLUE} %s\n${NC}" "$((i+1))" "${softwares[$i]}"
    sudo apt-get install --assume-yes ${softwares[$i]}
    echo "Failed installation at :" ${softwares[$i]} 
    if [ $? != 0 ]; then
        echo -e "${RED}Failed installation at : ${NC}" ${softwares[$i]} 
        exit
    fi
done

read -p "Press [Enter] key to start backup..."
mkdir ~/opencv
cd ~/opencv
git clone https://github.com/opencv/opencv.git
cd opencv
git checkout $opencv_version
cd ~/opencv
git clone https://github.com/opencv/opencv_contrib.git
cd opencv_contrib
git checkout $opencv_version
cd ~/opencv

mkdir -p ~/opencv/opencv/build
cd ~/opencv/opencv/build

clear
echo -e "${BLUE} Starting Build with CMAKE\n${NC}"
#cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D FORCE_VTK=ON -D WITH_TBB=ON -D WITH_V4L=ON -D WITH_QT=ON -D WITH_OPENGL=ON -D WITH_CUBLAS=ON -D CUDA_NVCC_FLAGS="-D_FORCE_INLINES" -D WITH_GDAL=ON -D WITH_XINE=ON -D BUILD_EXAMPLES=ON ..
if [ $? != 0 ]; then
    echo -e "${RED}Failed: CMAKE\n${NC}"
    exit
fi
make -j $(($(nproc) + 1))

