#!/bin/bash
set -e

# setup ros2 environment
source "/opt/ros/$ROS_DISTRO/setup.bash"
source "/openvslam_acceleration/local_setup.bash"
exec "$@"