#!/bin/bash

init_dir=$(pwd)
prj_dir=$(dirname $0)/../

cd $prj_dir
source ./.envrc

source $ROS2_HOME/setup.bash
colcon build --merge-install --parallel-workers=32 --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

cd $init_dir
