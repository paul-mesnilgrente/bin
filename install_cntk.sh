#!/bin/bash

# Author: Paul Mesnilgrente
# Date: 03/20/2017
# Last update: 03/23/2017
# Sources: https://github.com/Microsoft/CNTK/wiki/Setup-CNTK-on-Linux

INSTALL_DIR=$HOME/INSTALL_CNTK
NB_PROC=$(($(nproc) - 2))
if [ $? -eq 1 ]; then
	INSTALL_DIR=$1
fi
mkdir $INSTALL_DIR




# Intel Math Kernel Library (Intel MKL)
# https://github.com/Microsoft/CNTK/wiki/Setup-CNTK-on-Linux#mkl
cd "$INSTALL_DIR"
sudo mkdir /usr/local/CNTKCustomMKL
wget https://www.cntk.ai/mkl/CNTKCustomMKL-Linux-3.tgz
sudo tar -xzf CNTKCustomMKL-Linux-3.tgz -C /usr/local/CNTKCustomMKL





# OpenMPI
# https://github.com/Microsoft/CNTK/wiki/Setup-CNTK-on-Linux#open-mpi
# The issue pointed out seems to say that even if the version proposed by the distro
# is up to date, it is better to install the compiled version
cd "$INSTALL_DIR"
wget https://www.open-mpi.org/software/ompi/v1.10/downloads/openmpi-1.10.3.tar.gz
tar -xzvf ./openmpi-1.10.3.tar.gz
cd openmpi-1.10.3
./configure --prefix=/usr/local/mpi
make -j$NB_PROC all
sudo make install

export PATH=/usr/local/mpi/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/mpi/lib:$LD_LIBRARY_PATH
echo '' >> ~/.bashrc
echo '# OpenMPI is needed for CNTK' >> ~/.bashrc
echo 'export PATH=/usr/local/mpi/bin:$PATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/mpi/lib:$LD_LIBRARY_PATH' >> ~/.bashrc





# Protobuf
# https://github.com/Microsoft/CNTK/wiki/Setup-CNTK-on-Linux#protobuf
cd "$INSTALL_DIR"
sudo apt install -y autoconf automake libtool curl make g++ unzip
wget https://github.com/google/protobuf/archive/v3.1.0.tar.gz
tar -xzf v3.1.0.tar.gz
cd protobuf-3.1.0
./autogen.sh
./configure CFLAGS=-fPIC CXXFLAGS=-fPIC --disable-shared --prefix=/usr/local/protobuf-3.1.0
make -j$NB_PROC
sudo make install





# ZLib
# https://github.com/Microsoft/CNTK/wiki/Setup-CNTK-on-Linux#zlib
# V1.2.8 the 03/22/2017 on Ubuntu 16.04
cd "$INSTALL_DIR"
sudo apt install -y zlib1g-dev





# libzip
# https://github.com/Microsoft/CNTK/wiki/Setup-CNTK-on-Linux#libzip
# V1.0.1 the 03/22/2017 on Ubuntu 16.04 but 1.1.2 required
cd "$INSTALL_DIR"
wget http://nih.at/libzip/libzip-1.1.2.tar.gz
tar -xzvf ./libzip-1.1.2.tar.gz
cd libzip-1.1.2
./configure
make -j$NB_PROC all
sudo make install

export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
echo 'export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH' >> ~/.bashrc





# Boost Library
# https://github.com/Microsoft/CNTK/wiki/Setup-CNTK-on-Linux#boost-library
cd "$INSTALL_DIR"
sudo apt install -y libbz2-dev python-dev

wget https://sourceforge.net/projects/boost/files/boost/1.60.0/boost_1_60_0.tar.gz/download -O boost_1_60_0.tar.gz
tar -xzf boost_1_60_0.tar.gz
cd boost_1_60_0
./bootstrap.sh --prefix=/usr/local/boost-1.60.0
sudo ./b2 -d0 -j$NB_PROC install





# CUDA
cd "$INSTALL_DIR"
wget https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda_8.0.61_375.26_linux-run
bash cuda_8.0.61_375.26_linux-run





# CNTK
cd "$INSTALL_DIR"
git clone https://github.com/Microsoft/cntk
cd cntk
git submodule update --init -- Source/Multiverso

mkdir build/release -p
cd build/release
../../configure --asgd=no --with-mkl=/usr/local/CNTKCustomMKL
make -j$NB_PROC all

exit 0
