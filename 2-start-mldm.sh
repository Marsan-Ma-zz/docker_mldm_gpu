#!/bin/bash


# [prepare dir for Jupyter]
mkdir -p $HOME/workspace/notebooks

# [start container with GPU support]
#docker run -d \
nvidia-docker run -d \
  --name=mldm_gpu \
  -v $HOME/workspace:/home/workspace \
  -p 8880-8900:8880-8900 -p 80:80 -p 443:443 \
  -it marsan/mldm_gpu

##  -h mldm_env \ 
##  -p 6800-6810:6800-6810 \
##docker run -it kaggle/python bash 

#docker-compose up -d
#docker-compose restart

