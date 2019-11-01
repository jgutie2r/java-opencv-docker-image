#!/bin/bash

#### This script has been used to create an image
#    that contains OpenCV and openssh-client. 
#    The image is used to boot several containers that
#    perform image processing tasks.
#    
#    Master in Web Tecnologies, Cloud Computing, and
#              Mobile Applications
#
#    http://www.uv.es/twcam
####

######################################
# INSTALL OPENCV ON UBUNTU OR DEBIAN #
######################################

# -------------------------------------------------------------------- |
#                       SCRIPT OPTIONS                                 |
# ---------------------------------------------------------------------|
OPENCV_VERSION='3.4.2'       # Version to be installed
OPENCV_CONTRIB='NO'          # Install OpenCV's extra modules (YES/NO)
# -------------------------------------------------------------------- |

DEBIAN_FRONTEND=noninteractive 

apt-get -y update
apt-get -y dist-upgrade 
apt-get install -y sudo

# 1. ADD NEW USER ACCOUNT
adduser --disabled-password --gecos '' app
adduser app sudo &&
echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers;

chmod g+rw /home 
mkdir -p /home/app
chown -R app:app /home/app

# 2. INSTALL THE DEPENDENCIES

apt-get install -y wget unzip
mkdir /opt/local
cd /opt/local
wget https://archive.apache.org/dist/ant/binaries/apache-ant-1.10.7-bin.zip 
mv apache-ant-1.10.7-bin.zip ant.zip
unzip ant.zip
rm ant.zip 
mv apache-ant-1.10.7 ant
export ANT_HOME=/opt/local/ant
export PATH=${ANT_HOME}/bin:${PATH}


build_tools=(unzip build-essential cmake python-dev python-numpy)

media_io_tools=(zlib1g-dev libjpeg-dev libwebp-dev libpng-dev libtiff5-dev libjasper-dev libopenexr-dev libgdal-dev)

# Video I/O:
#apt-get install -y libdc1394-22-dev libavcodec-dev libavformat-dev libswscale-dev \
#                        libtheora-dev libvorbis-dev libxvidcore-dev libx264-dev yasm \
#                        libopencore-amrnb-dev libopencore-amrwb-dev libv4l-dev libxine2-dev

lin_alg_tools=(libtbb-dev libeigen3-dev)


apt-get install -y ${build_tools[@]}
apt-get install -y ${media_io_tools[@]}
apt-get install -y ${lin_alg_tools[@]}

# 3. INSTALL THE LIBRARY

cd /tmp
wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip
unzip ${OPENCV_VERSION}.zip && rm ${OPENCV_VERSION}.zip
mv opencv-${OPENCV_VERSION} OpenCV

cd OpenCV && mkdir build && cd build

cmake -DBUILD_SHARED_LIBS=OFF ..

make -j8

mkdir /opt/local/lib
cp bin/opencv*.jar lib/libopencv_java*.so /opt/local/lib


# Install TensorFlow libraries for Java
cd /opt/local/lib
wget https://storage.googleapis.com/tensorflow/libtensorflow/libtensorflow_jni-cpu-linux-x86_64-1.14.0.tar.gz

tar xzvf libtensorflow_jni-cpu-linux-x86_64-1.14.0.tar.gz
rm libtensorflow_jni-cpu-linux-x86_64-1.14.0.tar.gz

wget https://storage.googleapis.com/tensorflow/libtensorflow/libtensorflow-1.14.0.jar


# Install openssh (to run scp from the container)
apt-get install -y openssh-client

apt-get remove --purge -y ${build_tools[@]}
apt-get remove --purge -y ${media_io_tools[@]}
apt-get remove --purge -y ${lin_alg_tools[@]}

apt-get autoclean && apt-get -y autoremove && apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /opt/local/ant

chown -R app:app /opt/local/lib


