#!/bin/bash


WS=$(realpath $(dirname  $0)/..)
BUILD_DIR=$WS/build

FILENAME=compile_commands.json

if [[ ! -f $BUILD_DIR/$FILENAME ]]
then
 echo "$BUILD_DIR/$FILENAME not found. Compile using 'colcon build --merge-install --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON' for example" 
 exit 1
fi 

if [[ -h $WS/$FILENAME ]]
then 
    rm -i "$WS"/$FILENAME
fi

if [[ ! -e $WS/$FILENAME ]]
then 
    ln -s "$BUILD_DIR"/$FILENAME "$WS"/$FILENAME
fi
