#!/bin/bash

cd ~

sudo apt update && sudo apt upgrade
if [ $? -ne 0 ] ; then
    echo ""
    echo "######################################"
    echo "# Erreur update && upgrade           #"
    echo "######################################"
    echo ""
    exit 1
else
    echo ""
    echo "######################################"
    echo "# Update && upgrade OK               #"
    echo "######################################"
    echo ""
fi

sudo apt install build-essential \
                 python-numpy python3-numpy python-dev python3-dev \
                 cmake \
                 git \
                 libgtkgl2.0-dev \
                 libgtk2.0-dev \
                 pkg-config \
                 libavcodec-dev \
                 libavformat-dev \
                 libswscale-dev \
                 libvtk6-dev \
                 libtbb2 \
                 libtbb-dev \
                 libjpeg-dev \
                 libpng-dev \
                 libtiff-dev \
                 libjasper-dev \
                 libdc1394-22-dev \
                 libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
                 libfaac-dev libmp3lame-dev libopencore-amrnb-dev \
                 libopencore-amrwb-dev libvorbis-dev libxvidcore-dev \
                 v4l-utils ffmpeg libgdcm2-dev \
                 libeigen3-dev libgflags-dev libgoogle-glog-dev \
                 libsuitesparse-dev libatlas-base-dev \
                 ant libv4l-dev doxygen nvidia-cuda-toolkit libqt4-dev
if [ $? -ne 0 ] ; then
    echo ""
    echo "######################################"
    echo "# Erreur install dépendances         #"
    echo "######################################"
    echo ""
    exit 2
else
    echo ""
    echo "######################################"
    echo "# Installation des librairies OK     #"
    echo "######################################"
    echo ""
fi

git clone https://github.com/opencv/opencv
if [ $? -ne 0 ] ; then
    echo ""
    echo "######################################"
    echo "# Erreur récupération OpenCV         #"
    echo "######################################"
    echo ""
    exit 2
else
    echo ""
    echo "######################################"
    echo "# Téléchargement OpenCV OK           #"
    echo "######################################"
    echo ""
fi

git clone https://github.com/opencv/opencv_contrib
if [ $? -ne 0 ] ; then
    echo ""
    echo "######################################"
    echo "# Erreur récupération OpenCV Contrib #"
    echo "######################################"
    echo ""
    exit 2
else
    echo ""
    echo "######################################"
    echo "# Téléchargement OpenCV_Contrib OK   #"
    echo "######################################"
    echo ""
fi

mkdir opencv/build
cd opencv/build
cmake -D BUILD_EXAMPLES=ON \
      -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D CMAKE_BUILD_TYPE=DEBUG \
      ..
if [ $? -ne 0 ] ; then
    echo ""
    echo "######################################"
    echo "# Erreur cmake                       #"
    echo "######################################"
    echo ""
    exit 3
else
    echo ""
    echo "######################################"
    echo "# Configuration CMake OK             #"
    echo "######################################"
    echo ""
fi

make -j4
if [ $? -ne 0 ] ; then
    echo ""
    echo "######################################"
    echo "# Erreur make -j4                    #"
    echo "######################################"
    echo ""
    exit 4
else
    echo ""
    echo "######################################"
    echo "# Compilation dépendances OK         #"
    echo "######################################"
    echo ""
fi

sudo make install
if [ $? -ne 0 ] ; then
    echo ""
    echo "######################################"
    echo "# Erreur make install                #"
    echo "######################################"
    echo ""
    exit 5
else
    echo ""
    echo "######################################"
    echo "# Installation dans /usr/local OK    #"
    echo "######################################"
    echo ""
fi

sudo ldconfig

cd ~
g++ -ggdb `pkg-config --cflags opencv` -o contours2 opencv/samples/cpp/contours2.cpp `pkg-config --libs opencv`
if [ $? -ne 0 ] ; then
    echo ""
    echo "######################################"
    echo "# Erreur compile                     #"
    echo "######################################"
    echo ""
    exit 6
else
    echo ""
    echo "######################################"
    echo "# Compilation OK                     #"
    echo "######################################"
    echo ""
fi

./contours2
if [ $? -ne 0 ] ; then
    echo ""
    echo "######################################"
    echo "# Échec du test                      #"
    echo "######################################"
    echo ""
    exit 7
else
    echo "######################################"
    echo "# Ça marche !!!!!                    #"
    echo "######################################"
    echo ""
fi

rm -rf opencv opencv_contrib contours2

exit 0;
