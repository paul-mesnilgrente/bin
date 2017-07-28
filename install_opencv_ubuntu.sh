#!/bin/bash

path2opencv="~/.libs"
mkdir "$path2opencv" 2> /dev/null
cd "$path2opencv"

function check_result
{
    if [ $1 -eq $2 ]; then
        presult.sh -s "OK: $3"
    else
        presult.sh -f "ERROR:" "$3"
        exit $4
    fi
}

sudo apt update && sudo apt upgrade; check_result $? 0 "update && upgrade" 1

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
check_result $? 0 "apt install dependencies" 2

git clone https://github.com/opencv/opencv; check_result $? 0 "git clone opencv" 3

git clone https://github.com/opencv/opencv_contrib; check_result $? 0 "git clone opencv_contrib" 4

mkdir opencv/build; check_result $? 0 "create opencv/build" 5

cd opencv/build

cmake -D BUILD_EXAMPLES=ON \
      -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D CMAKE_BUILD_TYPE=DEBUG \
      ..; check_result $? 0 "local cmake with options" 6

make -j4; check_result $? 0 "make -j4" 7

sudo make install; check_result $? 0 "make install" 8

sudo ldconfig; check_result $? 0 "ldconfig" 9

cd "$path2opencv"
g++ -ggdb `pkg-config --cflags opencv` \
    -o contours2 opencv/samples/cpp/contours2.cpp \
    `pkg-config --libs opencv`;
check_result $? 0 "example compilation" 10

./contours2; check_result $? 0 "execution of the test program" 11

exit 0
