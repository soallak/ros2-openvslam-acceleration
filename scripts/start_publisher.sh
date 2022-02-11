#!/bin/zsh

SCRIPT_DIR=$(dirname $0)
WS=$(realpath $SCRIPT_DIR/../)
OVERLAY=$WS/install/setup.$(basename $SHELL)

DATASET=$1
FPS=10
source $OVERLAY 

if [[ -d $DATASET ]]; then 
  ros2 run publisher euroc_images -i $DATASET --fps $FPS
fi
