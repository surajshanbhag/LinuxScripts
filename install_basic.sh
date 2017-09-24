#!/bin/bash
reset
sudo apt update
sudo apt upgrade -y
sudo apt-get -y autoremove
clear



install_nvidia="yes" # grub will be updated
nvidia_ver="nvidia-375"

install_cuda="yes"
install_ros="yes"



ubuntu_rev=`lsb_release -r -s`
linux_headers="linux-headers-$(uname -r)"

software_ppa=('ppa:graphics-drivers/ppa' 
'ppa:atareao/atareao' 
'ppa:fixnix/netspeed' 
'ppa:yktooo/ppa' 
'ppa:indicator-brightness/ppa'
'ppa:webupd8team/sublime-text-3' 
'ppa:kasra-mp/ubuntu-indicator-weather' )

software_list=('vim'
    'terminator'
    'screen'
    'tmux'
    'guake'
    'sublime-text-installer' 
    'indicator-weather' 
    'indicator-multiload' 
    'indicator-cpufreq' 
    'touchpad-indicator' 
    'indicator-netspeed-unity' 
    'indicator-sound-switcher' 
    'indicator-brightness' 
    'gparted'
    'git-cola'
    'build-essential' 
    'cmake' 
    'cmake-qt-gui' 
    'qt5-default'
    'libvtk6-dev' 
    'zlib1g-dev'
    'libjpeg-dev'
    'libwebp-dev'
    'libpng-dev'
    'libtiff5-dev'
    'libjasper-dev'
    'libopenexr-dev'
    'libgdal-dev'
    'libdc1394-22-dev'
    'libavcodec-dev'
    'libavformat-dev'
    'libswscale-dev'
    'libtheora-dev'
    'libvorbis-dev'
    'libxvidcore-dev'
    'libx264-dev'
    'yasm'
    'libopencore-amrnb-dev'
    'libopencore-amrwb-dev'
    'libv4l-dev'
    'libxine2-dev'
    'libtbb-dev'
    'libeigen3-dev' 
    'python-dev'
    'python-tk'
    'python-numpy'
    'python3-dev'
    'python3-tk'
    'python3-numpy' 
    'ant'
    'default-jdk' 
    'git'
    'libgtk2.0-dev'
    'pkg-config'
    'libtbb2'
    'libtiff-dev'
    $linux_headers )

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'
RET=0
# add ppa

error_exit()
{
    printf "${BOLD}${YELLOW}%s ${RED} Failed ${NC}\n" $1
    exit
}

add_apt_repo()
{
    ppa=$1
    printf "${CYAN}>>>>>>>>>>>>>>>>> adding %s ${NC}\n" "$ppa"
    sudo add-apt-repository $ppa --yes
    if [ $? == 0 ]; then
        echo "$ppa" >> ppa
    else
        error_exit $ppa
    fi
}

install_apt()
{
    sft=$1
    printf "${CYAN}>>>>>>>>>>>>>>>>> Installing %s  ${NC}\n" "$sft"
    sudo apt-get --assume-yes install $sft 1>/dev/null 
    if [ $? == 0 ]; then
        echo "$sft" >> software_list
    else
        error_exit $sft
    fi
}

printf "${GREEN}${BOLD}Adding apt repo ${NC}\n"
for ppa in "${software_ppa[@]}"
do 
    if [ -f "ppa" ]; then
        if grep -Fxq $ppa ppa
        then
            printf "${GREEN}Already Added:%s${NC}\n" "$ppa"
        else
            add_apt_repo $ppa
        fi
    else
        add_apt_repo $ppa
    fi
done
sudo apt-get update
clear
printf "${GREEN} ${BOLD}Installing ${NC}\n"
for sft in "${software_list[@]}"
do 
   if [ -f "software_list" ]; then
        if grep -Fxq $sft software_list
        then
            printf "${GREEN}Installed :%s${NC}\n" "$sft"
        else
            install_apt $sft
        fi
    else
        install_apt $sft
    fi 
done
clear
# install nvidia
if [ ! -f "cuda" ]; then
    if [ "$install_nvidia" == "yes" ]
    then
        if [ ! -f "nvidia" ]; 
        then
            printf "${GREEN} ${BOLD}Installing NVIDIA DRIVERS %s${NC}\n" "$nvidia_ver"
            sudo apt-get install $nvidia_ver --force-yes
            if [ $? == 0 ]; 
            then
                sudo cp /etc/default/grub ~/grub.bkp
                sudo sed -i -- 's/GRUB_CMDLINE_LINUX="/GRUB_CMDLINE_LINUX="acpi_backlight=native acpi_osi=/g' /etc/default/grub
                 update-grub
                if [ $? == 0 ]; then
                    echo "$nvidia_ver" >> nvidia
                fi 
            else
                error_exit "nvidia"
            fi
            
        fi
    fi
fi
clear
# install cuda

if [ "$install_cuda" == "yes" ]
then
    if [ ! -f "cuda" ]; then
        if [ "$ubuntu_rev" == "14.04" ]; then
            deb_url="http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1404/x86_64/"
            debFile="cuda-repo-ubuntu1404_8.0.61-1_amd64.deb"
            printf "${GREEN} ${BOLD}Installing CUDA for Ubuntu %s: using deb: %s${NC}\n" "$ubuntu_rev" "$debFile"
        elif [ "$ubuntu_rev" == "16.04" ]; then
            deb_url="http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/"
            debFile="ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.61-1_amd64.deb"
            printf "${GREEN} ${BOLD}Installing CUDA for Ubuntu %s: using deb: %s${NC}\n" "$ubuntu_rev" "$debFile"
        fi
        wget $deb_url/$debFile
        if [ $? == 0 ]; then
            sudo dpkg -i $debFile
            if [ $? == 0 ]; then
                sudo apt-get update
                sudo apt-get install cuda -y
                if [ $? == 0 ]; then
                    echo 'export PATH=/usr/local/cuda-8.0/bin${PATH:+:${PATH}}' >>~/.bashrc
                    echo 'export LD_LIBRARY_PATH=/usr/local/cuda-8.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >>~/.bashrc
                    echo "CUDA" >> cuda
                else
                    error_exit "cuda install"
                fi
           else
                error_exit "cuda dpkg"
           fi
       else
            error_exit "cuda download"
       fi
    fi       
fi

if [ "$install_ros" == "yes" ]
then
    if [ ! -f "ros" ]; then
        if [ "$ubuntu_rev" == "14.04" ]; then
            version="indigo"
        elif [ "$ubuntu_rev" == "16.04" ]; then
            version="kinetic"
        fi
        
        printf "${GREEN} ${BOLD}Installing ROS %s for Ubuntu %s ${NC}\n" "$version" "$ubuntu_rev" 
	    if [ ! -f /etc/apt/sources.list.d/ros-latest.list ];then        
	        sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
	    fi
        sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
        sudo apt-get update
        sudo apt-get autoremove
        sudo apt-get update
        sudo apt-get install ros-$version-desktop-full
        if [ $? == 0 ]; then
            if [ "$version" == "indigo" ]
            then
                sudo apt-get install python-rosinstall --assume-yes
            elif [ "$version" == "kinetic" ]
            then
                sudo apt-get install python-rosinstall python-rosinstall-generator python-wstool build-essential --assume-yes
            fi
            if [ $? == 0 ]; then
                echo "source /opt/ros/$version/setup.bash" >> ~/.bashrc
                echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc
                source /opt/ros/$version/setup.bash
                sudo rosdep init
                rosdep update
                mkdir -p ~/catkin_ws/src
                cd ~/catkin_ws/
                catkin_make
                source devel/setup.bash
                echo "ROS" > ros
            else
                error_exit "ROS"
            fi
        else
            error_exit "ROS install"
        fi
    fi
fi


#atom
wget https://atom.io/download/deb
mv deb atom-amd64.deb
sudo dpkg -i atom-amd64.deb
rm -rf atom-amd64.deb

#spotify
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886 0DF731E45CE24F27EEEB1450EFDC8610341D9410
sudo apt-get update
deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list


# start applications
indicator-sound-switcher &
indicator-cpufreq &
indicator-netspeed-unity &
indicator-multiload &

wget https://www.edubuntu.org/sites/default/files/docimages/wallpapers-oneiric/Stalking_Ocelot_by_Sayantan_Chaudhuri-full.jpg
mv Stalking_Ocelot_by_Sayantan_Chaudhuri-full.jpg ~/Pictures/Stalking_Ocelot_by_Sayantan_Chaudhuri-full.jpg
gsettings set org.gnome.desktop.background picture-uri file://$HOME/Pictures/Stalking_Ocelot_by_Sayantan_Chaudhuri-full.jpg

echo "PS1='[${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[00m\]]:\[\033[01;34m\]\w\[\033[00m\]\$ '" >> ~/.bashrc
echo "alias sbc='source ~/.bashrc'">>~/.bashrc
echo "alias gits='git status'">>~/.bashrc
echo "alias gitp='git push origin master'"
echo "alias catkin_make_release='catkin_make -DCMAKE_BUILD_TYPE=Release'">>~/.bashrc
echo "alias killjobs='jobs -ps | xargs kill -9'">>~/.bashrc
echo "alias sros='source ~/catkin_ws/devel/setup.bash && source /opt/ros/kinetic/setup.bash'">>~/.bashrc


