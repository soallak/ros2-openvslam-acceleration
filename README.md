ROS2 image pipeline acceleration workspace. Consult [PLC2 wiki](https://gitlab.plc2.de/Soeren/INSEALION/-/wikis/ROS2-AA-on-TE0807) for additional information

## Dependencies 
The following dependencies needs to be installed before compiling and using this repository:

- Dependencies of [OpenVSLAM](https://openvslam-community.readthedocs.io/en/latest/installation.html#dependencies)
- Vitis 2020.2

## Getting Started

1. Import repositories using *vcs*: 
```
cd src/
vcs import < src/.repos
```

2. This is optional, in my case,  I needed to manually extend colcon, instead of installing from
   PyPi:

  a. colcon-acceleration: 
```
cd src/kria/colcon-acceleration
python setup.py build
python setup.py install --user
```

  b. and the same for colcon-mixin: 
```
cd src/kria/colcon-mixin
python setup.py build
python setup.py install --user
```
3. In the root of this repository, source ROS2 installation and build

```
source $ROS2_HONE/setup.zsh
colcon build --merge-install
```

4. For hardware, from a new terminal do:
```
source $ROS2_HONE/setup.zsh
colcon acceleration select te0807

#Test that tool chain is working
colcon build --build-base=build-te0807 --install-base=install-te0807 --merge-install --mixin te0807 --packages-select ament_vitis ament_acceleration vadd_publisher

# Compile image_proc for te0807
colcon build --build-base=build-te0807 --install-base=install-te0807 --merge-install --mixin te0807 --packages-select ament_vitis ament_acceleration image_proc vitis_common tracetools_image_pipeline

#To create sd_card.img. Not supported for te0807
colcon acceleration linux vanilla --install-dir install-te0807

```


## SLAM Pipeline
To compile run:
```
colcon build --merge-install --cmake-args -DUSE_PANGOLIN_VIEWER=ON -DUSE_SOCKET_PUBLISHER=OFF 
```
The above command will also download default datasets.


### Without Rviz2

```
ros2 launch slam_launch slam.launch.py dataset_path:=build/data_euroc/Machine_Hall_01/ dataset_period:=100 dataset_type:=euroc
```

### With Rviz2

```
ros2 launch slam_launch slam.launch.py dataset_path:=build/data_euroc/Machine_Hall_01/ dataset_period:=100 dataset_type:=euroc start_rviz2:=true
```

## Traces Analysis

```
lttng create data_euroc_Machine_Hall_01
lttng enable-event --userspace slam_tracepoint_provider:'*' 
lttng start
```

After all images are published

```
lttng stop
ros2 run slam_tracepoint_analysis process  ~/lttng-traces/data_euroc_Machine_Hall_01-20220322-200832/ data_euroc_Machine_Hall_01_cpu.png

```
