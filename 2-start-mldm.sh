#!/bin/bash

WORK=$HOME/workspace

nvidia-docker run -d \
  --name=mldm_gpu \
  -v $WORK:/home/$(whoami)/workspace \
  -p 8880-8899:8880-8899 \
  -it marsan/mldm_gpu

#  --device /dev/nvidia0:/dev/nvidia0 \
#  --device /dev/nvidia1:/dev/nvidia1 \
#  --device /dev/nvidia2:/dev/nvidia2 \
#  --device /dev/nvidia3:/dev/nvidia3 \
#  --device /dev/nvidiactl:/dev/nvidiactl \
#  --device /dev/nvidia-uvm:/dev/nvidia-uvm \
  
 
##  -h mldm_env \ 
##  -p 6800-6810:6800-6810 \
##docker run -it kaggle/python bash 

#docker-compose up -d
#docker-compose restart

