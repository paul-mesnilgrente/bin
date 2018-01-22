#!/bin/bash

set -e

path2opencv="~/.libs"
[ ! -d "path2opencv" ] && mkdir "$path2opencv"
cd "$path2opencv"

sudo apt update && sudo apt upgrade -y
sudo apt install build-essential cmake git pkg-config \
                 python-numpy python3-numpy python-dev python3-dev \
                 libgtkgl2.0-dev libgtk2.0-dev \
                 libavcodec-dev libavformat-dev \
                 libswscale-dev \
                 libvtk6-dev \
                 libtbb2 libtbb-dev \
                 libjpeg-dev libpng-dev libtiff-dev \
                 libjasper-dev \
                 libdc1394-22-dev \
                 libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
                 libfaac-dev libmp3lame-dev libopencore-amrnb-dev \
                 libopencore-amrwb-dev libvorbis-dev libxvidcore-dev \
                 v4l-utils ffmpeg libgdcm2-dev \
                 libeigen3-dev libgflags-dev libgoogle-glog-dev \
                 libsuitesparse-dev libatlas-base-dev \
                 ant libv4l-dev doxygen libqt4-dev \
                 nvidia-cuda-toolkit

git clone https://github.com/opencv/opencv
git clone https://github.com/opencv/opencv_contrib

mkdir opencv/build
cd opencv/build

cmake -D BUILD_EXAMPLES=ON \
      -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D CMAKE_BUILD_TYPE=DEBUG \
      ..
make -j4
sudo make install
sudo ldconfig

cd "$path2opencv"
g++ -ggdb `pkg-config --cflags opencv` \
    -o contours2 opencv/samples/cpp/contours2.cpp \
    `pkg-config --libs opencv`
./contours2

exit 0
