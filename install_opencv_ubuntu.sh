#!/bin/bash

set -e

path2opencv="~/.libs"
[ ! -d "path2opencv" ] && mkdir "$path2opencv"
cd "$path2opencv"

sudo apt update && sudo apt upgrade -y
sudo apt install build-essential cmake git pkg-config gcc-5 g++-5 \
                 libgtk2.0-dev libavcodec-dev libavformat-dev libswscale-dev \
                 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libdc1394-22-dev

git clone https://github.com/opencv/opencv
git clone https://github.com/opencv/opencv_contrib

mkdir opencv/build
cd opencv/build

cmake -D CMAKE_BUILD_TYPE=Release \
-D BUILD_EXAMPLES=ON \
-D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
-D WITH_CUDA=ON \
-D WITH_CUFFT=ON \
-D WITH_CUBLAS=ON \
-D CUDA_GENERATION="Pascal" \
-D CUDA_ARCH_BIN=6.1 \
-D CUDA_ARCH_PTX=6.1 \
-D CUDA_HOST_COMPILER:FILEPATH=/usr/bin/gcc-5 \
..

make -j4
sudo make install
sudo ldconfig

exit 0
