#!/bin/bash

#--------------------------------
#   Install docker basic version
#--------------------------------
# configure prerequisites
sudo apt-get update
sudo apt-get install --assume-yes wget htop git

# install docker
wget -qO- https://get.docker.com/ | sh

# configure docker (i.e. force devicemapper and bind to localhost)
sudo ln -sf /usr/bin/docker /usr/local/bin/docker
sudo sed -i '$acomplete -F _docker docker' /etc/bash_completion.d/docker
#sudo sed -i 's|^#*DOCKER_OPTS.*$|DOCKER_OPTS="-H tcp://127.0.0.1:2375 -H unix:///var/run/docker.sock"|g' /etc/default/docker
sudo sed -i 's|^#*DOCKER_OPTS.*$|DOCKER_OPTS="-dns 8.8.8.8 -dns 8.8.4.4 -g /home/$(whoami)/workspace/dockers/images"|g' /etc/default/docker

# create docker group and add user
sudo groupadd docker
sudo usermod -aG docker $(whoami)

# install docker-compose (https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-14-04)
sudo apt-get -y install python-pip
sudo pip install docker-compose

#--------------------------------
#   GPU for deep learning
#   (nvidia driver, cuda, nvidia-docker)
#--------------------------------
# nvidia driver dependency
sudo apt-get update
sudo apt-get install -y gcc make

# nvidia driver drm workaround (https://github.com/BVLC/caffe/wiki/Caffe-on-EC2-Ubuntu-14.04-Cuda-7)
sudo apt-get install -y linux-image-extra-`uname -r` linux-headers-`uname -r` linux-image-`uname -r`

# install nvidia driver
#wget http://us.download.nvidia.com/XFree86/Linux-x86_64/367.27/NVIDIA-Linux-x86_64-367.27.run
wget http://us.download.nvidia.com/XFree86/Linux-x86_64/367.57/NVIDIA-Linux-x86_64-367.57.run
chmod +x NVIDIA-Linux-x86_64-367.57.run
sudo ./NVIDIA-Linux-x86_64-367.57.run -a -x --ui=none
rm ./NVIDIA-Linux-x86_64-367.57.run
rm -rf ./NVIDIA-Linux-x86_64-367.57

# install cuda repository
#wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1404/x86_64/cuda-repo-ubuntu1404_7.5-18_amd64.deb
#sudo dpkg -i cuda-repo-ubuntu1404_7.5-18_amd64.deb
#rm ./cuda-repo-ubuntu1404_7.5-18_amd64.deb
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.44-1_amd64.deb
sudo dpkg -i --force-overwrite cuda-repo-ubuntu1604_8.0.44-1_amd64.deb
rm ./cuda-repo-ubuntu1604_8.0.44-1_amd64.deb


#update apt
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y opencl-headers build-essential protobuf-compiler \
    libprotoc-dev libboost-all-dev libleveldb-dev hdf5-tools libhdf5-serial-dev \
    libopencv-core-dev  libopencv-highgui-dev libsnappy-dev libsnappy1 \
    libatlas-base-dev cmake libstdc++6-4.8-dbg libgoogle-glog0 libgoogle-glog-dev \
    libgflags-dev liblmdb-dev git python-pip gfortran
sudo apt-get clean

# install cuda
sudo apt-get install -y cuda
sudo apt-get clean

# verify cuda
nvidia-smi
lsmod | grep -i nvidia
ls -alh /dev | grep -i nvidia

# Install nvidia-docker and nvidia-docker-plugin
wget -P /tmp https://github.com/NVIDIA/nvidia-docker/releases/download/v1.0.0-rc.3/nvidia-docker_1.0.0.rc.3-1_amd64.deb
sudo dpkg -i /tmp/nvidia-docker*.deb && rm /tmp/nvidia-docker*.deb

# Test nvidia-smi
nvidia-docker run --rm nvidia/cuda nvidia-smi


