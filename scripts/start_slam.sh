#!/bin/zsh

SCRIPT_DIR=$(dirname $0)
WS=$(realpath $SCRIPT_DIR/../)
OVERLAY=$WS/install/setup.$(basename $SHELL)

VOCABULARY=$WS/resources/orb_vocab.fbow
CONFIG=$WS/resources/euroc_stereo.yaml

source $OVERLAY 
ros2 run openvslam_ros run_slam -v $VOCABULARY -c $CONFIG -r
