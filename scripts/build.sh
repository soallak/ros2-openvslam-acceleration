#!/bin/bash

init_dir=$(pwd)
prj_dir=$(dirname $0)/../

cd $prj_dir
source ./.envrc

source $ROS2_HOME/setup.bash
colcon build

cd $init_dir
