# machine learning gears
FROM gcr.io/tensorflow/tensorflow:latest-devel-gpu
MAINTAINER Marsan Ma <marsan@gmail.com>

#---------------------------------
#   basic tools
#---------------------------------
RUN apt-get update
RUN apt-get install -y wget htop vim unzip procps

#---------------------------------
#   kaggle/python layers
#---------------------------------
# Anaconda3 (https://hub.docker.com/r/continuumio/anaconda3/~/dockerfile/)
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/archive/Anaconda3-4.1.0-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh

RUN apt-get install -y curl grep sed dpkg && \
    TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb && \
    apt-get clean

ENV PATH /opt/conda/bin:$PATH

# kaggle/python0 (https://hub.docker.com/r/kaggle/python0/~/dockerfile/)
RUN apt-get install -y build-essential python-software-properties

# kaggle/python1 (https://hub.docker.com/r/kaggle/python1/~/dockerfile/)
RUN pip install seaborn python-dateutil spacy dask pytagcloud pyyaml ggplot joblib \
    husl geopy ml_metrics mne pyshp gensim && \
    apt-get install -y libfreetype6-dev && \
    apt-get install -y libglib2.0-0 libxext6 libsm6 libxrender1 libfontconfig1 --fix-missing && \
    # textblob
    pip install textblob && \
    #word cloud
    pip install git+git://github.com/amueller/word_cloud.git

# kaggle/python2 (https://hub.docker.com/r/kaggle/python2/~/dockerfile/)
RUN apt-get install -y libfreetype6-dev && \
    apt-get install -y libglib2.0-0 libxext6 libsm6 libxrender1 libfontconfig1 --fix-missing && \
    # textblob
    # pip install python-igraph && \
    #xgboost
    cd /usr/local/src && mkdir xgboost && cd xgboost && \
    git clone --recursive https://github.com/dmlc/xgboost.git && cd xgboost && \
    make && cd python-package && python setup.py install

# kaggle/python3 (https://hub.docker.com/r/kaggle/python3/~/dockerfile/)
RUN apt-get -y install zlib1g-dev liblcms2-dev libwebp-dev && \
    pip install Pillow

# kaggle/python (https://hub.docker.com/r/kaggle/python/~/dockerfile/)
#RUN cd /usr/local/src && git clone https://github.com/scikit-learn/scikit-learn.git && \
#    cd scikit-learn && python setup.py build && python setup.py install && \
RUN conda install scikit-learn
# HDF5 support
RUN conda install h5py

RUN pip install --upgrade mpld3 && \
    pip install mplleaflet && \
    pip install gpxpy && \
    pip install arrow && \
    pip install sexmachine  && \
    pip install Geohash && \
    pip install deap && \
    pip install tpot && \
    pip install haversine && \
    pip install toolz cytoolz && \
    pip install sacred && \
    pip install plotly && \
    pip install git+https://github.com/nicta/dora.git && \
    pip install git+https://github.com/hyperopt/hyperopt.git && \
    # tflean. Deep learning library featuring a higher-level API for TensorFlow. http://tflearn.org
    #pip install git+https://github.com/tflearn/tflearn.git && \
    pip install fitter && \
    pip install langid && \
    # Delorean. Useful for dealing with datetime
    pip install delorean

#---------------------------------
#   Marsan's toolbelt
#---------------------------------
RUN conda install mkl
RUN conda install libgfortran

RUN pip install \
  pandas \
  mongoengine \
  bottle \
  cherrypy \
  jieba3k \
  yolk3k \
  azure

RUN pip install \
  cython \
  html5lib

RUN pip install \
  pyyaml \
  demjson \
  hanziconv

RUN pip install \
  ftfy \
  hiredis \
  google-api-python-client \
  regex

RUN pip install \
  Django \
  django-pipeline \
  django-bootstrap3 \
  django_compressor \
  rest-pandas \
  gunicorn \
  boto3 \
  PyMySQL

RUN pip install \
  djangoajax \
  django-dashing


## MySQL
#RUN apt-get install -y python3-dev libmysqlclient-dev
#RUN pip install mysqlclient


# pathos (python parallel process)
#RUN pip install -U git+https://github.com/uqfoundation/pathos.git@master

#RUN pip install -U \
#  newspaper3k

# Tensorflow GPU supported version
RUN pip install https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow-0.10.0rc0-cp35-cp35m-linux_x86_64.whl


#---------------------------------
#   Supervisord
#---------------------------------
# Install Supervisor.
RUN \
  apt-get update && \
  apt-get install -y supervisor && \
  rm -rf /var/lib/apt/lists/* && \
  sed -i 's/^\(\[supervisord\]\)$/\1\nnodaemon=true/' /etc/supervisor/supervisord.conf

# Define mountable directories.
VOLUME ["/etc/supervisor/conf.d"]

# ------------------------------------------------------------------------------
# Security changes
# - Determine runlevel and services at startup [BOOT-5180]
RUN update-rc.d supervisor defaults

# - Check the output of apt-cache policy manually to determine why output is empty [KRNL-5788]
RUN apt-get update | apt-get upgrade -y

# - Install a PAM module for password strength testing like pam_cracklib or pam_passwdqc [AUTH-9262]
RUN apt-get install libpam-cracklib -y
RUN ln -s /lib/x86_64-linux-gnu/security/pam_cracklib.so /lib/security



#---------------------------------
#   Enviroment
#---------------------------------
# Timezone
RUN echo "Asia/Taipei" > /etc/timezone 
RUN dpkg-reconfigure -f noninteractive tzdata

# conventions
COPY files/bashrc .bashrc
COPY files/vimrc .vimrc

# setup supervisor apps & start supervisor
COPY files/supervisor/* /etc/supervisor/conf.d/
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]

## Set the working directory
WORKDIR /home/workspace

EXPOSE 8880:8900
EXPOSE 80
EXPOSE 443

