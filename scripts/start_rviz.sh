#!/bin/zsh

SCRIPT_DIR=$(dirname $0)
WS=$(realpath $SCRIPT_DIR/../)
OVERLAY=$WS/install/setup.$(basename $SHELL)

DISPLAY_CONFIG=$WS/resources/euroc.rviz

source $OVERLAY
rviz2 -d $DISPLAY_CONFIG
