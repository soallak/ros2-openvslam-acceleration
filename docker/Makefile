 
RELEASE=`git describe --tags`

build: openvslam

openvslam:
	docker build -f BuildHost.Dockerfile -t $@:$(RELEASE) .

run:
	xhost +
	docker run -it --net host -v /tmp/.X11-unix:/tmp/.X11-unix -v $(HOME)/.Xauthority:/home/krs/.Xauthority -e DISPLAY=:0 openvslam:$(RELEASE) /bin/bash

.PHONY: openvslam build run