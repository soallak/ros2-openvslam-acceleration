#!/bin/bash


set -e


workdir=$(mktemp -d)
cd $workdir

# Build & install g2o
git clone https://github.com/RainerKuemmerle/g2o.git; cd g2o; mkdir build; cd build; \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/ .. && make && make install

# Build & install FBoW
git clone https://github.com/stella-cv/FBoW.git; cd FBoW; mkdir build; cd build; \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/ .. && make && make install

# Build & install Pangolin
git clone --recursive https://github.com/stevenlovegrove/Pangolin.git; cd Pangolin; \
    #./scripts/install_prerequisites.sh recommended; \
    mkdir build; cd build; \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/ .. && make && make install
